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

task :seeddata do
	#seed data 
end

desc "Do tasks specific to Drupal installations"
task :drupal => [:createdb] do 
	puts ENV["RDSHOST"]
	puts ENV["DBNAME"]
	puts ENV["DBPASS"]
end
