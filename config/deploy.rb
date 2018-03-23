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
      #ActionCable task
  desc 'Restart ActionCable' do
    task :restart_action_cable do
      on roles(:app), in: :sequence, wait: 5 do
      # Find the Passenger Standalone instance name
        instances = JSON.parse(capture(:'passenger-config', 'list-instances', '--json'))
        instance_name = instances.find { |i| i['integration_mode'] == 'standalone' }&.dig('name')
    
        if instance_name.nil?
          # The instance isn't running so start a new one
          within(current_path) do
            with(env: 'NOEXEC_EXCLUDE=passenger') do
            execute(:passenger, 'start',
              '-e', fetch(:stage),
              '-p', '28080',
              '-R', 'cable/config.ru',
              '--pid-file', shared_path.join('tmp/pids/cable.pid'),
              '--log-file', shared_path.join('log/cable.log'),
              '--force-max-concurrent-requests-per-process', '0',
              '--daemonize'
              )
            end
          end
          else
            # Restart the instance
            execute(:'passenger-config', 'restart-app', current_path, '--instance', instance_name)
          end
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
    after :publishing, :restart_action_cable
  end
end
