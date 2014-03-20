Gem::Specification.new do |s|
  s.name = "active_leonardo"
  s.version = "0.2.2"
  s.date = "2014-03-14"
  s.summary = "This gem provides a new customized scaffold generator to combine with active admin"
  s.description = "This generator help you to create new Rails applications to combine with active admin gem. It generates application structure to easily get the internationalization and authorization."
  s.homepage = "https://github.com/marcomd/Active_Leonardo"
  s.authors = ["Marco Mastrodonato, Marco Longhitano"]
  s.email = ["m.mastrodonato@gmail.com, marcovlonghitano@gmail.com"]
  s.requirements = "Start a new app with the active_template.rb inside root folder"
  
  s.require_paths = ["lib"]
  s.files = Dir["lib/**/*"] + ["LICENSE", "README.md", "CHANGELOG.md", "active_template.rb"]

  #s.add_dependency("rails", ">= 3.2.0")
  #s.add_dependency("activeadmin", ">= 0.6.3")
end
