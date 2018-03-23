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

namespace :deploy do
  desc 'Restart application' do
    task :restart do
      on roles(:app), in: :sequence, wait: 5 do
        execute :touch, release_path.join('tmp/restart.txt')
      end
    end
  end
  #db load schema
  namespace :db do
    desc 'Load the database schema if needed' do
      task load: [:set_rails_env] do
        on primary :db do
          unless test(%([ -e "#{shared_path.join('.schema_loaded')}" ]))
            within release_path do
              with rails_env: fetch(:rails_env) do
                execute :rake, 'db:schema:load'
                execute :touch, shared_path.join('.schema_loaded')
              end
            end
          end
        end
      end
    end
    after :publishing, :restart
    after :deploy, "thinking_sphinx:configure"
    after :deploy, "thinking_sphinx:start"
    after :deploy, "thinking_sphinx:index"
  end
end
