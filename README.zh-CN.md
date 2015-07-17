## 简介
原帖是写了一个[rails application template](https://github.com/seaify/weapon/blob/master/readme.bak.md)，但后来发现，rails new myapp -m xx.rb这种形式，并不方便使用，以及不方便已有项目使用，于是将其改造成了[weapon](https://github.com/seaify/weapon)，一个gem包，可以自由去选择为已有项目添加什么样的功能。

O(∩_∩)O~，第一个gem,  第一次用thor,  欢迎支持。

## 支持的功能
```ruby
chuck@chuck-MacBook-Pro:~/seaify/weapon(master|✔) % weapon                                                                                        
Commands:
  weapon config_bootstrap   # config bootstrap, example, used for simmple_form
  weapon custom_i18n        # custom i18n and use slim as template engine, use simple_form, currently write to zh-CN.yml
  weapon help [COMMAND]     # Describe available commands or one specific command
  weapon makesure_in_git    # makesure all the files is in git version control
  weapon push_to_github     # push to github
  weapon setup_mina_deploy  # setup mina deploy
  weapon setup_settings_ui  # setup settings ui
```
其中，会被我们使用到的command,  有setup_mina_deploy, custom_i18n, setup_settings_ui, push_to_github. 后面会增加exception slack notify, i18n-js，jwt token等这些功能

## 安装和使用
安装方法:  gem install或者添加到gemfile
```ruby
gem install weapon
```
使用方法, 不加参数时，会列出所有的可选命令项:
```ruby
weapon custom_i18n
```

## weapon custom_i18n
执行weapon custom_i18n后，会有个错误，rails g simple_form:install --bootstrap报错，需要再手动执行下，这个神奇的问题，顺便在此寻求各位大神帮助！！！
```ruby
Use `bundle show [gemname]` to see where a bundled gem is installed.
         run  rm app/assets/stylesheets/application.css from "."
         run  rails g simple_form:install --bootstrap from "."
Could not find generator 'simple_form:install'. Maybe you meant 'integration_test' or 'active_record:model' or 'resource_route'
Run `rails generate --help` for more options.
      create  lib/templates/slim/scaffold/_form.html.slim
      create  lib/templates/slim/scaffold/index.html.slim
      create  lib/templates/slim/scaffold/new.html.slim
      create  lib/templates/slim/scaffold/edit.html.slim
      create  lib/templates/slim/scaffold/show.html.slim
      create  lib/templates/rails/i18n_scaffold_controller/controller.rb
      create  lib/generators/rails/i18n_scaffold_controller/i18n_scaffold_controller_generator.rb
      insert  config/application.rb
         run  rails g simple_form:install --bootstrap from "."
Could not find generator 'simple_form:install'. Maybe you meant 'integration_test' or 'active_record:model' or 'resource_route'
Run `rails generate --help` for more options.
```
安装后，执行rails g scaffold post title:string, 会自动的向config/locales/zh-CN.yml中写入, 会把model中的attribute，自动写入，按activerecord:attribute:model:field这种格式
```ruby
chuck@website:~/tmp/what(master|…) % rails g scaffold post title:string                                                                                 
      invoke  active_record
      create    db/migrate/20150717051311_create_posts.rb
      create    app/models/post.rb
      invoke    test_unit
      create      test/models/post_test.rb
      create      test/fixtures/posts.yml
      invoke  resource_route
       route    resources :posts
      invoke  i18n_scaffold_controller
      create    app/controllers/posts_controller.rb
      invoke    slim
      create      app/views/posts
      create      app/views/posts/index.html.slim
      create      app/views/posts/edit.html.slim
      create      app/views/posts/show.html.slim
      create      app/views/posts/new.html.slim
      create      app/views/posts/_form.html.slim
      invoke    test_unit
      create      test/controllers/posts_controller_test.rb
      invoke    helper
      create      app/helpers/posts_helper.rb
      invoke      test_unit
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/posts.coffee
      invoke    scss
      create      app/assets/stylesheets/posts.scss
      invoke  scss
      create    app/assets/stylesheets/scaffolds.scss
chuck@website:~/tmp/what(master|…) % cat config/locales/zh-CN.yml                                                                                 
---
zh-CN:
  action:
    back: "返回"
    new: "创建"
    show: "查看"
    edit: "编辑"
    delete: "删除"
    confirm_delete: "确认删除"
    created:
      successfully: "创建成功"
    updated:
      successfully: "更新成功"
    destroyed:
      successfully: "删除成功"
  activerecord:
    models:
      post: post
    attributes:
      post:
        title: title
        id: ID
        created_at: "创建时间"
        updated_at: "更新时间"
  helpers:
    submit:
      post:
        create: "创建"
        update: "更新"
```
同时创建的.html.slim页面都已经使用了i18n, 包括new, edit这些action，在controller里，返回的notice也进行了i18n.

## weapon setup_mina_deploy
```ruby
       run  mina init from "."
-----> Created ./config/deploy.rb
       Edit this file, then run `mina setup` after.
input your user name on deploy host: chuck
input your deploy host, like example.com or 123.100.100.100: 45.55.140.65
        gsub  config/deploy.rb
input your deploy directory: /home/chuck/xxx9991
        gsub  config/deploy.rb
input your git remote url to pull from, like git@github.com:seaify/weapon.git  https://github.com/seaify/shit
        gsub  config/deploy.rb
         run  ssh chuck@45.55.140.65 -t 'mkdir -p /home/chuck/xxx9991;chown -R chuck /home/chuck/xxx9991' from "."
Connection to 45.55.140.65 closed.
         run  mina setup from "."
-----> Setting up /home/chuck/xxx9991

       total 16
       drwxrwxr-x  4 chuck chuck 4096 Jul 17 01:21 .
       drwxr-xr-x 29 chuck chuck 4096 Jul 17 01:21 ..
       drwxrwxr-x  2 chuck chuck 4096 Jul 17 01:21 releases
       drwxrwxr-x  2 chuck chuck 4096 Jul 17 01:21 shared

```
执行完, mina ssh, mina deploy, mina console就可用了.

## 其它
1. weapon setup_settings_ui,  执行完后，访问http://localhost:3000/settings，就能去设置更新变量了
2. weapon push_to_github,  执行完后，将当下的代码push到github上去。不用跑到github手动创建repo

## 问题, 请教各路大神
1.  这个gem是使用thor的，怎样去用rails application template中的gem, generator这些函数呢？
2. 在thor里，我怎样去获取，当期rails项目下的配置信息呢，比如我想知道设置了哪些locales?
