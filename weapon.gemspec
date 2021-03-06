Gem::Specification.new do |s|
  s.name        = 'weapon'
  s.version     = '0.2.4'
  s.date        = '2016-12-07'
  s.summary     = "weapon for rails application!"
  s.description = "provide mina deploy, github setup, slack exception notify, i18n scaffold, rails-settings-ui, guard custom"
  s.authors     = ["seaify"]
  s.email       = 'dilin.life@gmail.com'
  s.files       = Dir["lib/weapon.rb", "lib/support/**/*"]
  s.homepage    = 'https://github.com/seaify/weapon'
  s.license     = 'MIT'

  s.executables << 'weapon'

  s.add_development_dependency 'rails', '~> 4.2'
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_dependency 'thor', '~> 0.14'
  s.add_dependency 'colorize', '~> 0.7.7'
  s.add_dependency 'awesome_print', '~> 1.6'
end
