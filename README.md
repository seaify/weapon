# [weapon 中文版](README.zh-CN.md)

# weapon

Weapon is a collector which provide the reusable part from each project . Each part can be directly choose to quick install in the rails project.

It currently contains the following list parts:  
1. [weapon custom_i18n](custom_i18n.md), scaffold generator i18n support, auoto generate model attributes key mapping in config/local/*.yml, generated view and controller i18n support  
2. mina deploy & unicorn server, you just need to input the host's user name, ip, deploy directory. It will also generate nginx file, and upload to server's /etc/nginx/sites-enabled
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

Usage
--------
```ruby
chuck@chuck-MacBook-Pro:~/seaify/weapon(master|✔) % weapon  
Commands:
  weapon create_gem          # create basic gem information
  weapon custom_i18n         # custom i18n and use slim as template engine, use simple_form, currently write to zh-CN.yml
  weapon for_seaify          # only for seaify personal use, combine of other commands act as rails application template
  weapon help [COMMAND]      # Describe available commands or one specific command
  weapon install_must_gems   # install must need gems like guard, guard-livereload, guard-rspec...
  weapon push_to_github      # push to github
  weapon setup_mina_unicorn  # setup mina deploy and unicorn server
  weapon setup_settings_ui   # setup settings ui
```

More Information
----------------

* [Rubygems](https://rubygems.org/gems/weapon)
* [Issues](https://github.com/seaify/weapon/issues)