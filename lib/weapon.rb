require 'thor'
require 'awesome_print'
require 'colorize'
require 'rails'
require 'rails/generators/actions'
require 'fileutils'

class Weapon < Thor
  include Thor::Actions
  include Rails::Generators::Actions

  def self.source_root
    File.dirname(__FILE__)
  end

  no_commands do
    def makesure_in_git(dir=".")
      #run "spring stop"
      unless (run "cd #{dir}; git remote -v")
        puts "this project should in version controll use git"
        run "cd #{dir}; git init; git add *; git commit -a -m 'commit by seaify/weapon'"
      end
    end

    def config_bootstrap
      File.open("Gemfile", "a").write("\ngem 'bootstrap-sass'")
      run "bundle"
      #config bootstrap stylesheets
      File.open('app/assets/javascripts/application.js', 'a') { |f| f.write("\n//= require bootstrap-sprockets")}
      File.open('app/assets/stylesheets/application.scss', 'a') { |f| f.write("\n@import 'bootstrap-sprockets';\n@import 'bootstrap';") }
      run "rm app/assets/stylesheets/application.css"
    end

  end


  desc "setup_mina_unicorn", "setup mina deploy and unicorn server"
  def setup_mina_unicorn(user_host)
    makesure_in_git
    repo_path = `git config --get remote.origin.url`.strip()
    return puts "at least one remote url should be set before we start!!!".colorize(:red) unless repo_path.present?
    gem_group :development do
      gem 'mina-multistage', require: false
      gem 'mina-unicorn', require: false
      gem 'unicorn'
    end
    run "bundle"
    FileUtils.mkdir_p "config/deploy"
    FileUtils.mkdir_p "config/unicorn"

    copy_file 'support/mina_unicorn/deploy.rb', 'config/deploy.rb'
    copy_file 'support/mina_unicorn/unicorn_production.rb', 'config/unicorn/production.rb'
    copy_file 'support/mina_unicorn/unicorn_staging.rb', 'config/unicorn/staging.rb'
    copy_file 'support/mina_unicorn/deploy_production.rb', 'config/deploy/production.rb'
    copy_file 'support/mina_unicorn/deploy_staging.rb', 'config/deploy/staging.rb'
    copy_file 'support/mina_unicorn/unicorn-nginx.conf', 'unicorn-nginx.conf'
    copy_file 'support/mina_unicorn/staging-unicorn-nginx.conf', 'staging-unicorn-nginx.conf'

    puts "setup mina deploy"

    app_name = `pwd`.split('/')[-1].strip()
    username, domain = user_host.split('@')
    deploy_directory = "/home/#{username}/#{app_name}"


    %w(app_name username domain deploy_directory repo_path).each do |key|
      ap key
      gsub_file "config/deploy/production.rb", "#{key}_for_replace", eval(key)
      gsub_file "config/deploy/staging.rb", "#{key}_for_replace", eval(key)

      gsub_file "config/unicorn/production.rb", "#{key}_for_replace", eval(key)
      gsub_file "config/unicorn/staging.rb", "#{key}_for_replace", eval(key)

      gsub_file "unicorn-nginx.conf", "#{key}_for_replace", eval(key)
      gsub_file "staging-unicorn-nginx.conf", "#{key}_for_replace", eval(key)
      gsub_file "config/deploy.rb", "#{key}_for_replace", eval(key)

    end

    setup_dir_command = 'ssh ' + username + '@' + domain + " -t 'mkdir -p " + deploy_directory  + ';chown -R ' + username + ' ' + deploy_directory + "'"
    run setup_dir_command
    setup_staging_dir_command = 'ssh ' + username + '@' + domain + " -t 'mkdir -p " + deploy_directory  + '_staging;chown -R ' + username + ' ' + deploy_directory + "_staging'"
    run setup_staging_dir_command


    #run 'scp unicorn-nginx.conf ' + username + '@' + domain + ':' + "/etc/nginx/sites-enabled/#{app_name}.conf"
=begin
    run "git clone https://github.com/sstephenson/rbenv.git ~/.rbenv"
    run "echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc"
    run "echo 'eval "$(rbenv init -)"' >> ~/.zshrc"
=end
    run "ssh-copy-id #{username}@#{domain}"

    staging = `git branch -a | grep staging | ag remote`
    ap staging
    run 'mina setup' if staging.present?
    run 'mina production setup'

    run 'scp config/database.yml ' + username + '@' + domain + ':' + deploy_directory + '/shared/config/'
    run 'scp config/application.yml ' + username + '@' + domain + ':' + deploy_directory + '/shared/config/'

    run 'cp config/secrets.yml config/production_secrets.yml'
    gsub_file "config/production_secrets.yml", "production", "staging"
    gsub_file "config/production_secrets.yml", "test", "production"
    run 'scp config/production_secrets.yml ' + username + '@' + domain + ':' + deploy_directory + '/shared/config/secrets.yml'
    run "rm config/production_secrets.yml"

    ## for staging

    run 'cp config/database.yml config/staging_database.yml'
    gsub_file "config/staging_database.yml", "production", "staging"
    run 'scp config/staging_database.yml ' + username + '@' + domain + ':' + deploy_directory + '_staging/shared/config/database.yml'
    run "rm config/staging_database.yml"

    run 'cp config/secrets.yml config/staging_secrets.yml'
    gsub_file "config/staging_secrets.yml", "development", "staging"
    run 'scp config/staging_secrets.yml ' + username + '@' + domain + ':' + deploy_directory + '_staging/shared/config/secrets.yml'
    run "rm config/staging_secrets.yml"

    run 'scp config/application.yml ' + username + '@' + domain + ':' + deploy_directory + '_staging/shared/config/'

    ## run mina setup && deploy
    run 'mina deploy' if staging.present?
    run 'mina production deploy'
    run 'git add config/ .gitignore staging-unicorn-nginx.conf unicorn-nginx.conf'
    run 'git commit -a -m "add mina unicorn multi stage support"'
    puts "remember to make soft link to unicorn-nginx.conf && staging-unicorn-nginx.conf".colorize(:blue)
    puts "remember to restart nginx server".colorize(:blue)
    puts "remember to add ssh key to your repo setting url".colorize(:blue)
    puts "staging branch missing, you need create staging branch, then exec mina setup, mina deploy".colorize(:red) unless staging.present?
  end

  desc "model_from_sql", "build model from sql"
  def model_from_sql
    makesure_in_git
    FileUtils.mkdir_p "lib/generators/model_from_sql"
    copy_file 'support/model_from_sql/model_from_sql_generator.rb', 'lib/generators/model_from_sql/model_from_sql_generator.rb'
    run 'git add lib/'
    run 'rails g model_from_sql'
    run 'git add app/ test/ lib/'
    run 'git commit -a -m "add model_from_sql generator and build models from sql"'
  end

  desc "build all activeadmin page ", "build all activeadmin page"
  def build_activeadmin_pages
    makesure_in_git
    FileUtils.mkdir_p "lib/generators/build_activeadmin_pages"
    copy_file 'support/build_activeadmin_pages/build_activeadmin_pages_generator.rb', 'lib/generators/build_activeadmin_pages/build_activeadmin_pages_generator.rb'
    run 'git add lib/'
    run 'rails g build_activeadmin_pages'
    run 'git add app/ test/ lib/'
    run 'git commit -a -m "add build_activeadmin_pages generator and build pages from model"'
  end

  desc "setup_settings_ui", "setup settings ui"
  def setup_settings_ui
    makesure_in_git
    #inject_into_file "Gemfile", "gem 'rails-settings-ui', '~> 0.3.0'\n gem 'rails-settings-cached', '0.4.1'\n", :before => /^end/
    File.open("Gemfile", "a").write("\ngem 'rails-settings-ui', '~> 0.3.0'\n gem 'rails-settings-cached', '0.4.1'\n")
    run "bundle"
    run "rails g settings setting"
    run "rails g rails_settings_ui:install"
    run "rake db:migrate"
    copy_file 'support/rails_settings_ui/rails_settings_ui.rb', 'config/initializers/rails_settings_ui.rb'
    copy_file 'support/rails_settings_ui/setting.rb', 'app/models/setting.rb'
  end

  desc "custom_i18n", "custom i18n and use slim as template engine, use simple_form, currently write to zh-CN.yml"
  def custom_i18n
    makesure_in_git
    puts "custom i18n"
    File.open("Gemfile", "a").write("\ngem 'slim-rails'\ngem 'simple_form', '~> 3.1.0'")
    run "bundle"

    unless File.exist?('config/locales/zh-CN.yml')
      copy_file 'support/custom_i18n/zh-CN.yml', 'config/locales/zh-CN.yml'
    end

    config_bootstrap
    run "rails g simple_form:install --bootstrap"
    copy_file 'support/custom_i18n/_form.html.slim', 'lib/templates/slim/scaffold/_form.html.slim'
    copy_file 'support/custom_i18n/index.html.slim', 'lib/templates/slim/scaffold/index.html.slim'
    copy_file 'support/custom_i18n/new.html.slim', 'lib/templates/slim/scaffold/new.html.slim'
    copy_file 'support/custom_i18n/edit.html.slim', 'lib/templates/slim/scaffold/edit.html.slim'
    copy_file 'support/custom_i18n/show.html.slim', 'lib/templates/slim/scaffold/show.html.slim'

    copy_file 'support/custom_i18n/controller.rb', 'lib/templates/rails/i18n_scaffold_controller/controller.rb'
    copy_file 'support/custom_i18n/i18n_scaffold_controller_generator.rb', 'lib/generators/rails/i18n_scaffold_controller/i18n_scaffold_controller_generator.rb'

    inject_into_file 'config/application.rb', after: "# -- all .rb files in that directory are automatically loaded.\n" do <<-'RUBY'
    config.generators.template_engine = :slim
    config.generators.scaffold_controller = "i18n_scaffold_controller"
    config.i18n.default_locale = "zh-CN"
    RUBY
    end
    run "rails g simple_form:install --bootstrap"
  end

  desc "push_to_github", "push to github"
  def push_to_github(dir_name='.')
    repo_name = (dir_name == '.')? File.basename(Dir.getwd): dir_name
    makesure_in_git(dir_name)
    puts "pull to github"
    run "cd #{dir_name}; gem install hub;hub create #{repo_name}; hub push -u origin master"
  end

  desc "for_seaify", "only for seaify personal use, combine of other commands act as rails application template"
  def for_seaify
    makesure_in_git
    invoke :install_must_gems
    invoke :custom_i18n
    invoke :setup_settings_ui
  end



  desc "install_must_gems", "install must need gems like guard, guard-livereload, guard-rspec..."
  def install_must_gems

    makesure_in_git

    gem 'enumerize'
    gem 'aasm'
    gem 'slim-rails'
    gem 'sass-rails', '~> 5.0'
    gem 'bootstrap-sass'
    gem 'font-awesome-sass'
    gem 'simple_form', '~> 3.1.0'
    gem 'annotate', '~> 2.6.6'
    gem 'i18n-tasks', '~> 0.8.3'
    gem 'monadic'
    gem 'gon'
    gem 'exception_notification'
    gem 'awesome_print'
    gem 'slack-notifier'
    gem 'activevalidators'

    gem_group :development do
      gem 'mina', require: false
      gem 'mina-multistage', require: false
      gem 'mina-sidekiq', require: false
    end

    gem 'figaro'
    gem 'whenever', '~> 0.9.2'
    gem "rails-erd"

    gem_group :development, :test do
      gem 'web-console', '~> 2.0'
      gem 'rspec-rails'
      gem 'factory_girl_rails'
      gem 'faker', '~> 1.4.3'
      gem 'spring'
    end

    gem_group :development do
      gem 'guard-bundler'
      gem 'guard-rails'
      gem 'guard-rspec'
      gem 'guard-livereload'
      gem 'rack-livereload'
      gem 'guard-migrate'
      gem 'guard-annotate'
      gem 'guard-shell'
      gem 'quiet_assets'
      gem 'rails_layout'
      gem 'spring-commands-rspec'
      gem 'better_errors'
      gem 'meta_request'
      gem 'binding_of_caller'
      gem 'hirb'
      gem 'brakeman'
      gem 'rails_panel'
      gem 'pry'
      gem 'pry-byebug'
      gem 'pry-nav'
      #gem 'pry-rails', :group => :development
    end

    gem_group :test do
      gem 'database_cleaner'
      gem 'launchy'
      gem 'selenium-webdriver'
      gem 'faker'
      gem 'simplecov'
      gem 'timecop'
    end

    application(nil, env: "development") do
      "config.middleware.insert_before(Rack::Lock, Rack::LiveReload)"
    end

    application do
      "config.generators.template_engine = :slim"
    end

    gsub_file 'Gemfile', "gem 'byebug'", ''
    run "bundle"
    run "guard init"
    generate "rspec:install"
    generate "simple_form:install"

    run "git add lib/ spec/ config Guardfile .rspec .gitignore"
    run "git commit -a --amend --no-edit"

  end

  desc "create_gem", "create basic gem information and push to github, push to rubygems"
  def create_gem(name)
    FileUtils.mkdir_p "lib"
    FileUtils.mkdir_p "bin"

    gemspec_file = "#{name}/#{name}.gemspec"
    copy_file "support/create_gem/basic.gemspec", gemspec_file
    gsub_file gemspec_file, "gem_name_for_replace", name
    gsub_file gemspec_file, "date_for_replace", Time.now.strftime("%Y-%m-%d")
    gsub_file gemspec_file, "libfile_for_replace", "lib/#{name}.rb"

    summary = ask("input summary for this gem")
    gsub_file gemspec_file, "summary_for_replace", summary

    description = ask("input description for this gem")
    gsub_file gemspec_file, "description_for_replace", description

    author = ask("input name as author for this gem")
    gsub_file gemspec_file, "author_for_replace", author

    email = ask("input email for this gem")
    gsub_file gemspec_file, "email_for_replace", email


    libfile = "#{name}/lib/#{name}.rb"
    copy_file "support/create_gem/basic.rb", libfile
    gsub_file libfile, "gem_name_for_replace", name.camelize


    binfile = "#{name}/bin/#{name}"
    copy_file "support/create_gem/basic.bin", binfile
    run "chmod +x #{binfile}"

    gsub_file binfile, "gem_name_for_replace", name
    gsub_file binfile, "Gem_name_for_replace", name.camelize

    makesure_in_git(name)
    invoke :push_to_github, name

    s = `cd #{name};git remote -v`.split(' ')[1]
    homepage = 'https://github.com/' + s.split('/')[0].split(':')[-1] + '/' + s.split('/')[1].split('.')[0]
    ap homepage
    gsub_file gemspec_file, "homepage_for_replace", homepage

    run "cd #{name};git commit -a --amend --no-edit"

    command = "cd #{name};gem build #{name}.gemspec; gem push #{name}-0.0.1.gem"
    ap command
    run command
  end

end
