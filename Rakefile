#!/usr/bin/env rake

require 'mysql2'

desc "Create the database if it doesn't exist"
task :createdb do
	if ENV["RDSHOST"].nil? or ENV["RDSROOTUSER"].nil? or ENV["RDSROOTPASS"].nil? or ENV['DBNAME'].nil? or ENV['DBUSER'].nil? or ENV['DBPASS'].nil?
		fail "MISSING DATABASE ENVIRONMENT VARIABLES. MODIFY JENKINS CONFIG"
	else
		begin
			client = Mysql2::Client.new(
				host: ENV["RDSHOST"],
				username: ENV["DBUSER"],
				password: ENV["DBPASS"],
				database: ENV['DBNAME'])
			announce "Database already exists. Skipping!"
		rescue
			client = Mysql2::Client.new(
				host: ENV["RDSHOST"],
				username: ENV["RDSROOTUSER"],
				password: ENV["RDSROOTPASS"])
			client.query("CREATE DATABASE IF NOT EXISTS #{ENV['DBNAME']}")
			client.query("GREANT ALL ON `#{ENV['DBNAME']}.*` TO '#{ENV['DBUSER']}'@'%' IDENTIFIED BY '#{ENV['DBPASS']}'")
		end
	end
end

task :writeconf do
	puts @conffiles
	#@conffiles.each do |conf|
	#	puts
end

desc "Do tasks specific to Drupal installations"
task :drupal => [:createdb] do
	@conffiles = [
		{
			from: 'sites/default/default.settings.php',
			to: 'sites/default/settings.php',
			replace: [
				{ string: '$DBHOST$', with: ENV['RDSHOST'] },
				{ string: '$DBNAME$', with: ENV['DBNAME'] },
				{ string: '$DBUSER$', with: ENV['DBUSER'] },
				{ string: '$DBPASS$', with: ENV['DBPASS'] }
			]
		}
	] 
	Rake::Task[:writeconf].invoke
end
