
Gem::Specification.new do |spec|
  spec.name          = "embulk-parser-convxml"
  spec.version       = "0.1.0"
  spec.authors       = ["YOUR_NAME"]
  spec.summary       = "Convxml parser plugin for Embulk"
  spec.description   = "Parses Convxml files read by other file input plugins."
  spec.email         = ["YOUR_NAME"]
  spec.licenses      = ["MIT"]
  # TODO set this: spec.homepage      = "https://github.com/YOUR_NAME/embulk-parser-convxml"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'YOUR_GEM_DEPENDENCY', ['~> YOUR_GEM_DEPENDENCY_VERSION']
  spec.add_development_dependency 'embulk', ['~> 0.7.5']
  spec.add_development_dependency 'bundler', ['~> 1.0']
  spec.add_development_dependency 'rake', ['>= 10.0']
end
