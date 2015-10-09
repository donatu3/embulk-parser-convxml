require "rexml/document"

module Embulk
	module Parser    
		class Convjson < ParserPlugin
			Plugin.register_parser("convxml", self)
            

			def self.transaction(config, &control)
				# 設定の読み込み
				task = {
				    #:foreach => config.param("foreach", :string, default: 1),
                    #複数のレコードを作成する場合、rootpathで指定された要素分のレコードが作成できる。
                    #指定しなければ自分で全てを指定
                    :rootpath => config.param("rootpath", :string, default: "false"),
					:exclude => config.param("exclude", :string, default: "false"),
					:schema => config.param("schema", :array, default: nil)
				}

				# レコードのカラム(詳細は schema 定義に従う)
				columns = task[:schema].each_with_index.map do |column, index|
					Column.new(index, column["name"], column["type"].to_sym)
				end
					yield(task, columns)
			end

			def init
                @rootpath = task["rootpath"]
				@exclude = task["exclude"]
				@schema = task["schema"]
			end

			def run(file_input)
				# ファイル毎に1レコード
			while file = file_input.next_file
                #inputのファイルを読み取る
                doc = REXML::Document.new(file.read)
                #docの中にxmlの全文が入っている
                ###rootpathが指定されていた場合（false以外なら）###

                if (@rootpath == "false") then
                    @page_builder.add(make_record(doc, nil))
                else
                    p ("rootpath :" + @rootpath.to_s)
                    doc.elements.each(@rootpath) do |element|
                        ##rootpathの要素分だけループする##
                        next if evaluate_exp(doc,@exclude,element)
                        @page_builder.add(make_record(doc,element))
                    end
                end
			end
				page_builder.finish
			end

			private

			# レコードを作成
                def make_record(doc,element)
                #configで定義したスキーマ分のループ
				@schema.each_with_index.map do |column|
                    #configで指定したname、カラムの実際の名前になる
					name = column["name"]
                    #configで定義したexp、rubyの式で値取得が行われる。
					exp = column["exp"]
                    #configで指定したtype、指定した型で変換が行われる。
					type = column["type"]
                    #configで指定したformat、タイムスタンプの時どう出力するか。
				    format = column["format"]
                    #型変換の関数
                    convert_type(evaluate_exp(doc,exp,element), type, format)
				end
			end

			# 式を評価する
            def evaluate_exp(data,exp,element)
                #docはxmlの全文となっている。
                doc = data
                ##rootpathを指定していない場合は##
                    #doc.elements['announce/forecast/outlook/name'].textなどとexpで指定すれば良い。
                ##rootpathを指定している場合は##
                    #element.elements['b[3]'].textなどとexpで指定すれば良い。
				eval(exp)
			end

			# valをtype型に変換する
			def convert_type(val, type, format)
				if val.class.to_s == type then
					val
				else
					case type
					when "string"
						val.to_s
					when "long"
                        #val.to_i
                        ##何も無いときは空にするため
                        val.to_s.empty? ? nil : val.to_i
					when "double"
						#val.to_f
                        ##何も無いときは空にするため
                        val.to_s.empty? ? nil : val.to_f
					when "boolean"
						["yes", "true", "1"].include?(val.downcase)
					when "timestamp"
						val.empty? ? nil : Time.strptime(val, format)
					else
						raise "Unsupported type #{type}"
					end
				end
			end

		end
	end
end
