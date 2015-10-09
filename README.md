# Convxml parser plugin for Embulk

embulkを使用して、xmlから好きな名前でカラムを作成する<br>
※複数のレコードにも対応※


## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Example

* input.xml
```yaml
<root>
    <a name="a1">
        <b>bbb1</b>
        <b>bbb2</b>
        <b>bbb3</b>
        <c>ccc1</c>
    </a>
    <a>
        <b>bbb4</b>
        <b>bbb5</b>
        <b>bbb6</b>
        <c>ccc2</c>
    </a>
</root>
```
* config.yml
```yaml
in:
  type: file
  path_prefix: input2.xml
  parser:
   type: convxml
   rootpath: 'root/a'
   schema:
   - {name: b_name1, type: string, exp: "element.elements['b[2]'].text"}
   - {name: c_name2, type: string, exp: "element.elements['c'].text"}
exec: {}
out:
 type: stdout
```
* preview
```yaml
+----------------+----------------+
| b_name1:string | c_name2:string |
+----------------+----------------+
|           bbb2 |           ccc1 |
|           bbb5 |           ccc2 |
+----------------+----------------+
```
## advice
config.ymlでrootpathを指定しない場合のymlファイルの書き方はこちらを参照↓<br>
https://github.com/EndoTakumu/embulk-parser-singlexml   <br>
parserはこのプラグインで動作します。
