set :branch, 'staging'
set :unicorn_config, -> { "#{deploy_to}/#{current_path}/config/unicorn/staging.rb" }
set :unicorn_pid, -> { "#{deploy_to}/#{current_path}/tmp/pids/unicorn-staging.pid" }
set :rails_env, 'staging'

#set variables
set :domain, 'domain_for_replace'
set :deploy_to, 'deploy_directory_for_replace_staging'
set :repository, 'repo_path_for_replace'
set :user, 'username_for_replace'
