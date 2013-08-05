#!/usr/bin/env rake

require 'mysql2'

desc "Create the database if it doesn't exist"
task :createdb do
	begin
		client = Mysql2::Client.new(
			host: ENV["RDSHOST"],
			username: ENV["DBUSER"],
			password: ENV["DBPASS"])
		puts "Database already exists. Skipping!"
	rescue
		client = Mysql2::Client.new(
			host: ENV["RDSHOST"],
			username: ENV["RDSROOTUSER"],
			password: ENV["RDSROOTPASS"])
		client.query("CREATE DATABASE IF NOT EXISTS #{ENV['DBNAME']}")
		client.query("GREANT ALL ON `#{ENV['DBNAME']}.*` TO '#{ENV['DBUSER']}'@'%' IDENTIFIED BY '#{ENV['DBPASS']}'")
	end
end

task :writeconf do
	puts @conffiles
end

desc "Do tasks specific to Drupal installations"
task :drupal => [:createdb] do
	@conffiles = [
		{
			from: 'somefile',
			to: 'someotherfile',
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
