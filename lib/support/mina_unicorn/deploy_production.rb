set :unicorn_config, -> { "#{deploy_to}/#{current_path}/config/unicorn/production.rb" }
set :branch, 'master'
set :rails_env, 'production'

set :domain, 'domain_for_replace'
set :deploy_to, 'deploy_directory_for_replace'
set :repository, 'repo_path_for_replace'
set :user, 'username_for_replace'
