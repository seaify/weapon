## 简介
最近的项目中，频繁使用到I18n，以及新建rails项目时，总是重复操作，如使用devise, simple_form, guard，以及配置一些gem.所以写了一个rails application template, 避免这类的重复事情
## 如何使用
1. rails new myapp -m https://raw.githubusercontent.com/seaify/rails-application-templates/master/composer.rb
2. cd myapp; rails g scaffold post title:string

## [应用模板](composer.rb) 做了些什么
### 自动将项目文件加入git版本控制，并支持创建到github上
### 支持mina部署
需要提前保证本地机器，能ssh无密码直接登陆到服务器上
1. 根据提示输入用户名，host名，目录名，改变config/deploy.rb
```ruby
  username = ask("input your user name on deploy host:")
  File.open('config/deploy.rb', 'a') { |f| f.write("\nset :user, '#{username}' ")}

  domain = ask("input your deploy host, like example.com or 123.100.100.100:")
  gsub_file "config/deploy.rb", "'foobar.com'", "'" + domain + "'"

  directory = ask("input your deploy directory:")
  directory = directory.gsub(/\/$/, "")
  gsub_file "config/deploy.rb", "/var/www/foobar.com", directory
```
2. 自动在服务器上创建相应目录，以及修改权限
```ruby
  setup_dir_command = 'ssh ' + username + '@' + domain + " -t 'mkdir -p " + directory  + ';chown -R ' + username + ' ' + directory + "'"
  run setup_dir_command
```
3. 将config/database.yml，自动上传到部署服务器上
```ruby
scp_file_command = 'scp config/database.yml ' + username + '@' + domain + ':' + directory + '/shared/config/'
run scp_file_command
```
4. 执行完后，mina ssh, mina console, mina deploy测试正常

### i18n支持， 创建I18nScaffoldControllerGenerator
1. 默认使用I18nScaffoldControllerGenerator, config/application.rb中
```ruby
config.generators.scaffold_controller = "i18n_scaffold_controller"
```
这样rails g scaffold post title:string执行后，I18nScaffoldControllerGenerator会被使用到
2. 默认页面模板引擎使用slim, config/application.rb中
```ruby
config.generators.template_engine = :slim
```
3. 默认locale使用zh-CN, 在config/locales/zh-CN.yml中，自动创建了action.new, action.edit这些通用的Key, rails g scaffold xx生成的页面会用到
```
zh-CN:
	action:
	  new: 新建
      edit: 编辑
      show: 查看
      delete: 删除
      back: 返回
      confirm_delete: 确认删除
```
4. 生成的view页面，对于model的每个字段，使用human_attribute_name方法, model_name使用Post.model_name.human, 而new, show, edit这些button的文本使用t('action.new')这种形式
```ruby
h1 = Post.model_name.human
table.table-striped
  tr
    th = Post.human_attribute_name("title")
    th
    th
    th
  - @posts.each do |post|
    tr
      td = post.title
      td = link_to t('action.show'), post
      td = link_to t('action.edit'), edit_post_path(post)
      td = link_to t('action.delete'), post, :confirm => t('action.confirm_delete'), :method => :delete
br
= link_to (t('action.new') + Post.model_name.human), new_post_path
```
在config/locales/zh-CN.yml中，配置如下
```
activerecord:
	models:
	  post: 文章
	attributes:
	  post:
	    title: 标题
```
title那一列就能显示为标题了，详见http://guides.rubyonrails.org/i18n.html. 目前activerecords, models, attributes这部分I18n的值暂时未自动生成到config/locale/zh-CN.yml中，改天有空补上。
5. 产生的controller里，create, update, destroy时的notice, 以i18n的形式返回结果
```ruby
  def destroy
    @post.destroy
    redirect_to posts_url, notice: t('post.success.destroyed')
  end
```
6. 自动在zh-CN.yml中产生post.success.created这些key, value对
```
zh-CN:
	post:
	  success:
	    created: post 创建成功
		updated: post 更新成功
		destroyed: post 删除成功
```

### 其他
1. gemfile中，source未改变，本来改成了taobao源，后来加入mina部署到digitalocean后，发现直接暴力的改gem source源为taobao是不合适的。在本地，就执行bundle config 'mirror.https://rubygems.org' 'https://ruby.taobao.org' 吧
2. 配置了guard, guard-bundler, guard-migrate, guard-annotate这些gem
3. 配置了rails-settings-ui, 访问http://localhost:3000/settings页面，就能更新定义好的设置
4. 配置了devise, 访问http://localhost:3000/users/sign_in
5. scaffold生成的页面，采用bootstrap的样式

### 参考
[railsGuides i18n](http://guides.rubyonrails.org/i18n.html)
[scaffold_cn, generate zh_CN templates for scaffold in ruby on rails](https://github.com/homeway/scaffold_cn)
[无需更改 Gemfile，让 bundle 使用淘宝源](https://ruby-china.org/topics/26314)

ps： 我用的markdown编辑器是haroopad，预览显示很正常，多列1，2，3，4，5在github和这却都变成了1，看样子语法上有一点小的区别。越发觉得haroopad赞了。

