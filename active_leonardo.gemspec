Gem::Specification.new do |s|
  s.name = "active_leonardo"
  s.version = "0.0.1"
  s.date = "2012-05-23"
  s.summary = "This gem provides a new customized scaffold generator to combine with active admin"
  s.description = "This generator help you to create new Rails applications to combine with active admin gem. It generates application structure to easily get the internationalization and authorization."
  s.homepage = "http://github.com/marcomd/Leonardo"
  s.authors = ["Marco Mastrodonato"]
  s.email = ["m.mastrodonato@gmail.com"]
  s.requirements = "Start a new app with the template.rb inside root folder"
  
  s.require_paths = ["lib"]
  s.files = Dir["lib/**/*"] + Dir["test/**/*"] + ["LICENSE", "README.rdoc", "CHANGELOG", "active_template.rb"]

  s.add_dependency("activeadmin", ">= 0.4.0")
end
