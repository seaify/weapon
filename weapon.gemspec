Gem::Specification.new do |s|
  s.name        = 'weapon'
  s.version     = '0.0.0'
  s.date        = '2015-07-15'
  s.summary     = "weapon for rails application!"
  s.description = "provide mina deploy, github setup, slack exception notify, i18n scaffold, rails-settings-ui, guard custom"
  s.authors     = ["Chuck.lei"]
  s.email       = 'dilin.life@gmail.com'
  s.files       = ["lib/weapon.rb"]
  s.homepage    = 'http://rubygems.org/gems/weapon'
  s.license     = 'MIT'

  s.executables << 'weapon'

  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_dependency 'thor', '~> 0.14'
  s.add_dependency 'choice'
  s.add_dependency 'awesome_print'
end
