# [weapon 中文版](README.zh-CN.md)

# weapon

Weapon is a collector which provide the reusable part from each project . Each part can be directly choose to be quickly install in the rails project.

It currently contains the following list parts:  
1. only need to input user@host, it will auto add ssh key/database.yml/application.yml/nginx conf to server, will auto build staging & production env.
2. [weapon custom_i18n](custom_i18n.md), scaffold generator i18n support, auoto generate model attributes key mapping in config/local/*.yml, generated view and controller i18n support  
4. model_from_sql, when u only have database, but no migration, it can auto build models for u. it will read all tables, then set the model file and table_name for each table._ 
3. rails_settings_ui, you just need to run 'weapon rails_settings_ui', then http://localhost:3000/settings works  
5. push_to_github, push your directory into github with no effort, no need to use the browser  

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
chuck@chuck-MacBook-Pro-2:~/seaify/online-products % weapon
Commands:
  weapon create_gem          # create basic gem information and push to github, push to rubygems
  weapon custom_i18n         # custom i18n and use slim as template engine, use simple_form, currently write to zh-CN.yml
  weapon for_seaify          # only for seaify personal use, combine of other commands act as rails application template
  weapon help [COMMAND]      # Describe available commands or one specific command
  weapon install_must_gems   # install must need gems like guard, guard-livereload, guard-rspec...
  weapon model_from_sql      # build model from sql
  weapon push_to_github      # push to github
  weapon setup_mina_unicorn  # setup mina deploy and unicorn server
  weapon setup_settings_ui   # setup settings ui
```

More Information
----------------

* [Rubygems](https://rubygems.org/gems/weapon)
* [Issues](https://github.com/seaify/weapon/issues)