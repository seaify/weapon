require 'thor'
require 'awesome_print'

class Weapon < Thor
  include Thor::Actions

  def self.source_root
    File.dirname(__FILE__)
  end

  desc "makesure_in_git", "makesure all the files is in git version control"
  def makesure_in_git
    unless (run "git remote -v")
      puts "this project should in version controll use git"
      run "git init"
      run "git add *"
      run "git commit -a -m 'first commit'"
    end
  end

  desc "setup_mina_deploy", "setup mina deploy"
  def setup_mina_deploy
    invoke :makesure_in_git
    puts "setup mina deploy"
    run "mina init"
    username = ask("input your user name on deploy host:")
    File.open('config/deploy.rb', 'a') { |f| f.write("\nset :user, '#{username}' ")}
    domain = ask("input your deploy host, like example.com or 123.100.100.100:")
    gsub_file "config/deploy.rb", "'foobar.com'", "'" + domain + "'"
    directory = ask("input your deploy directory:")
    directory = directory.gsub(/\/$/, "")
    gsub_file "config/deploy.rb", "/var/www/foobar.com", directory

    repository = ask("input your git remote url to pull from, like git@github.com:seaify/weapon.git ")
    gsub_file "config/deploy.rb", "git://...", repository

    setup_dir_command = 'ssh ' + username + '@' + domain + " -t 'mkdir -p " + directory  + ';chown -R ' + username + ' ' + directory + "'"
    run setup_dir_command
    run 'mina setup'
  end

  desc "setup_settings_ui", "setup settings ui"
  def setup_settings_ui
    invoke :makesure_in_git
    #inject_into_file "Gemfile", "gem 'rails-settings-ui', '~> 0.3.0'\n gem 'rails-settings-cached', '0.4.1'\n", :before => /^end/
    File.open("Gemfile", "a").write("\ngem 'rails-settings-ui', '~> 0.3.0'\n gem 'rails-settings-cached', '0.4.1'\n")
    run "bundle"
    run "rails g settings setting"
    run "rails g rails_settings_ui:install"
    run "rake db:migrate"
    copy_file 'support/rails_settings_ui/rails_settings_ui.rb', 'config/initializers/rails_settings_ui.rb'
    copy_file 'support/rails_settings_ui/setting.rb', 'app/models/setting.rb'
  end

  desc "setup_exception_slack_notify", "setup exception slack notify"
  def setup_exception_slack_notify
    invoke :makesure_in_git
    puts "setup exception slack notify"
  end


  desc "custom_i18n and use slim as template engine, use simple_form, currently write to zh-CN.yml", "custom i18n"
  def custom_i18n
    invoke :makesure_in_git
    puts "custom i18n"
    File.open("Gemfile", "a").write("\ngem 'slim-rails'\ngem 'simple_form', '~> 3.1.0'")
    run "bundle"

    unless File.exist?('config/locales/zh-CN.yml')
      copy_file 'support/custom_i18n/zh-CN.yml', 'config/locales/zh-CN.yml'
    end

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
  end

  desc "install_recomend_gems", "install_recommend_gems"
  def install_recommend_gems
    invoke :makesure_in_git
    puts "install recommend gems"
  end

  desc "push_to_github", "push to github"
  def push_to_github
    invoke :makesure_in_git
    puts "pull to github"
    run 'gem install hub'
    run "hub create #{File.basename(Dir.getwd)}"
    run "hub push -u origin master"
  end

  desc "all", "exec all other command"
  def all
    setup_mina_deploy
    setup_settings_ui
    setup_exception_slack_notify
    custom_i18n
    install_recommend_gems
    pull_to_github
  end
end
