require 'thor'
require 'awesome_print'

class Weapon < Thor
  include Thor::Actions

  desc "setup_mina_deploy", "setup mina deploy"
  def setup_mina_deploy
    ok = run "git remote -v"
    if ok == false
      puts "this project should in version controll use git"
      run "git init"
      run "git add *"
      run "git commit -a -m 'first commit'"
    end
    puts "setup mina deploy"
    run "mina init"
    username = ask("input your user name on deploy host:")
    File.open('config/deploy.rb', 'a') { |f| f.write("\nset :user, '#{username}' ")}
    domain = ask("input your deploy host, like example.com or 123.100.100.100:")
    gsub_file "config/deploy.rb", "'foobar.com'", "'" + domain + "'"
    directory = ask("input your deploy directory:")
    directory = directory.gsub(/\/$/, "")
    gsub_file "config/deploy.rb", "/var/www/foobar.com", directory

    repository = ask("input your git remote url, like git@github.com:seaify/weapon.git ")
    gsub_file "config/deploy.rb", "git://...", repository

    setup_dir_command = 'ssh ' + username + '@' + domain + " -t 'mkdir -p " + directory  + ';chown -R ' + username + ' ' + directory + "'"
    run setup_dir_command
    run 'mina setup'
  end

  desc "setup_settings_ui", "setup settings ui"
  def setup_settings_ui
    puts "setup settings ui"
  end

  desc "setup_exception_slack_notify", "setup exception slack notify"
  def setup_exception_slack_notify
    puts "setup exception slack notify"
  end


  desc "custom_i18n", "custom i18n"
  def custom_i18n
    puts "custom i18n"
  end

  desc "install_recomend_gems", "install_recommend_gems"
  def install_recommend_gems
    puts "install recommend gems"
  end

  desc "pull_to_github", "pull to github"
  def pull_to_github
    puts "pull to github"
    run 'gem install hub'
    run "hub create #{app_name}"
    run "hub push -u origin dev"
    #update deploy.rb repo
    result = `hub remote -v | awk '{ print $2}' | head -n1`
    repository = result.strip
    gsub_file "config/deploy.rb", "git://...", repository
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

Weapon.start ARGV