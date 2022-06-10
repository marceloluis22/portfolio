# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

set :application, "marcelo-moyano.com.ar"
set :repo_url, "https://github.com/marceloluis22/portfolios.git"
set :branch, 'main' 

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, "/var/www/#{fetch :application}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'


# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

desc 'Restart application'
task :restart do
  on roles(:app), in: :sequence, wait: 5 do
    within release_path do
      execute :bundle, 'install'
      execute :chmod, '777 '+release_path.join('tmp/cache/').to_s
      execute :chmod, '777 '+release_path.join('log/').to_s
      execute :rake, 'db:create RAILS_ENV=production'
      execute :rake, 'db:migrate RAILS_ENV=production'
      execute :rake, 'assets:precompile RAILS_ENV=production'
      execute 'sudo service nginx restart'
    end
  end
end

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
set :passenger_restart_with_touch, true