# Put application's parameters into config.yml
CONFIG = HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env])