## weapon custom_i18n
1. after run "weapon custom_i18n", you need to run "rails g simple_form:install --bootstrap"
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

2. after install，run "rails g scaffold post title:string", will auto write the models's attributes into config/locales/zh-CN.yml  
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
```
3. the generated yml file

```ruby
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

4. the generated new(edit, show..).html.slim all use i18n, include actions like new, edit
5. notice in the controller use i18n too