# [weapon 中文版](README.zh-CN.md)

# weapon

Weapon is a collector which provide the reusable part from each project . Each part can be directly choose to quick install in the rails project.

It currently contains the following list parts:  
1. [weapon custom_i18n](custom_i18n.md), scaffold generator i18n support, auoto generate model attributes key mapping in config/local/*.yml, generated view and controller i18n support  
2. mina deploy, you just need to input the host's user name, ip, deploy directory, git repo  
3. rails_settings_ui, you just need to run 'weapon rails_settings_ui', then http://localhost:3000/settings works  
4. push_to_github, push your directory into github with no effort, no need to use the browser  

Install
--------

```shell
gem install weapon
```
or add the following line to Gemfile:

```ruby
gem 'weapon'
```
and run `bundle install` from your shell.

Environment version
-----------------------

ruby 2.1.5  
rails 4.2.2  

More Information
----------------

* [Rubygems](https://rubygems.org/gems/weapon)
* [Issues](https://github.com/seaify/weapon/issues)