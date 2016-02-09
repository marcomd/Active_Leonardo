Gem::Specification.new do |s|
  s.name          = "active_leonardo"
  s.version       = "0.6.0"
  s.date          = "2016-02-09"
  s.summary       = "This gem provides a new customized scaffold generator to combine with active admin"
  s.description   = "This generator help you to create new Rails applications to combine with active admin gem. It generates application structure to easily get the internationalization and authorization."
  s.homepage      = "https://github.com/marcomd/Active_Leonardo"
  s.authors       = ["Marco Mastrodonato", "Marco Longhitano"]
  s.required_ruby_version = '>= 1.9.3'
  s.email         = ["m.mastrodonato@gmail.com", "marcovlonghitano@gmail.com"]
  s.licenses      = ['LGPL-3.0']
  s.requirements  = "The active_template.rb, check the homepage project"
  
  s.require_paths = ["lib"]
  s.files         = Dir["lib/**/*"] + %w(LICENSE README.md CHANGELOG.md active_template.rb)

  s.add_runtime_dependency 'rails', '>= 3.2'
  #s.add_runtime_dependency "activeadmin", ">= 0.6.3" #waiting version 1.0
end
