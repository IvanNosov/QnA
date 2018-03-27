# config valid for current version and patch releases of Capistrano
lock '~> 3.10.1'

set :application, 'qa'
set :repo_url, 'git@github.com:IvanNosov/qa.git'
set :branch, 'lesson_20'
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/developer/qa'
set :deploy_user, 'developer'
# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'
# after :publishing, :restart
# after :deploy, 'thinking_sphinx:configure'
# after :deploy, 'thinking_sphinx:generate'
# after :deploy, 'thinking_sphinx:restart'
# after :deploy, 'thinking_sphinx:index'

after 'deploy:publishing', 'deploy:restart', 'ts:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:stop'
    invoke 'unicorn:reload'
  end

  task :stop do
    invoke 'unicorn:stop'
  end
end