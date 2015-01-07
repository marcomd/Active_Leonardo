Gem::Specification.new do |s|
  s.name          = "active_leonardo"
  s.version       = "0.5.0"
  s.date          = "2015-01-07"
  s.summary       = "This gem provides a new customized scaffold generator to combine with active admin"
  s.description   = "This generator help you to create new Rails applications to combine with active admin gem. It generates application structure to easily get the internationalization and authorization."
  s.homepage      = "https://github.com/marcomd/Active_Leonardo"
  s.authors       = ["Marco Mastrodonato", "Marco Longhitano"]
  s.email         = ["m.mastrodonato@gmail.com", "marcovlonghitano@gmail.com"]
  s.licenses      = ['GPL-3.0']
  s.requirements  = "Start a new app with the active_template.rb inside root folder"
  
  s.require_paths = ["lib"]
  s.files         = Dir["lib/**/*"] + ["LICENSE", "README.md", "CHANGELOG.md", "active_template.rb"]

  s.add_runtime_dependency 'rails', '>= 3.2'
  #s.add_runtime_dependency "activeadmin", ">= 0.6.3" #waiting version 1.0
end
