set :application, ENV['JOB_NAME']#{}"PHPDrupalTest"
set :repository,  ENV['GIT_URL ']#{}"git@github.com:devopsbrett/OTech-Drupal.git"
set :scm, :git

set :user, 'ubuntu'
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "10.62.95.125"                          # Your HTTP server, Apache/etc
role :app, "10.62.95.125"                          # This may be the same as your `Web` server
role :db,  "10.62.95.125", :primary => true 

#set :ssh_options, {:keys => [ File.join(Dir.home, 'keys', 'aws-bmack.pem')]}
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache

after 'deploy:setup', 'drupal:setup'
after 'deploy:create_symlink', 'drupal:symlink'

def put_sudo(data, to)
	filename = File.basename(to)
	to_dir = File.dirname(to)
	put data, "/tmp/#{filename}"
	run "#{try_sudo} mv /tmp/#{filename} #{to_dir}" 
end

namespace :drupal do
	task :setup do
		puts "PLEASE WORK"
		puts "#{repository}"
		run "#{try_sudo} mkdir -p #{shared_path}/site/files"
		put_sudo File.read(File.expand_path("../../sites/default/settings.php", __FILE__)), "#{shared_path}/site/settings.php"
		run "#{try_sudo} chown -R #{user}:www-data #{deploy_to}"
		run "#{try_sudo} chmod g+rw  #{shared_path}/site/files"
	end

	task :symlink do
		run "#{try_sudo} cp -n #{latest_release}/sites/default/default.settings.php #{shared_path}/site/default.settings.php"
		run "#{try_sudo} rm -Rf #{latest_release}/sites/default"
		run "#{try_sudo} ln -s #{shared_path}/site #{latest_release}/sites/default"
	end

	task :allow_settings_write do
		run "#{try_sudo} chmod g+rw #{shared_path}/site/settings.php"
	end

end

namespace :deploy do
	task :finalize_update do
		run "#{try_sudo} chown -R #{user}:www-data #{latest_release}"
		run "#{try_sudo} chmod -R go-w #{latest_release}"
		run "#{try_sudo} chmod g-w #{shared_path}/site/settings.php"	
	end

	task :restart do
		#do nothing
	end
end
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end