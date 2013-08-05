#!/usr/bin/env rake

require 'mysql2'

desc "Create the database if it doesn't exist"
task :createdb do
	begin
		client = Mysql2::Client.new(
			host: ENV["RDSHOST"],
			username: ENV["DBUSER"],
			password: ENV["DBPASS"],
			database: ENV['DBNAME'])

		puts "Database already exists. Skipping!"
	rescue
		puts "Creating Database!"
		client = Mysql2::Client.new(
			host: ENV["RDSHOST"],
			username: ENV["RDSROOTUSER"],
			password: ENV["RDSROOTPASS"])
		client.query("CREATE DATABASE IF NOT EXISTS #{ENV['DBNAME']}")
		client.query("GRANT ALL ON `#{ENV['DBNAME']}`.* TO '#{ENV['DBUSER']}'@'%' IDENTIFIED BY '#{ENV['DBPASS']}'")
	end	
end

task :writeconf do
	#puts @conffiles
	@conffiles.each do |conf|
		f = IO.read(File.expand_path(conf[:from], __FILE__))
		f[:replace].each do |r|
			f[r[:string]] = r[:replace]
		end
		puts f
	end
end

desc "Do tasks specific to Drupal installations"
task :drupal => [:createdb] do
	@conffiles = [
		{
			from: '../sites/default/default.settings.php',
			to: '../sites/default/settings.php',
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
