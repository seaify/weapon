require 'thor'

class Weapon < Thor

  desc "setup_mina_deploy", "setup mina deploy"
  def setup_mina_deploy
    puts "setup mina deploy"
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
  end

end

Weapon.start ARGV