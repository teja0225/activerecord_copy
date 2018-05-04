require_relative 'db'

class Query

	Record.connect('sqlite','', '', '', 'backup_org')

	@employee1 = Employee.new("Alicia","C","Smith","998887780",'1969-03-28',"731 Fondren, Houston, TX","M","","888665555",4)
	@employee1.salary = 20000
	if @employee1.save
		puts "saved"
	end
=begin
	if @employee1.delete
		puts "deleted"
	end

	if @employee1.update(:Fname => 'Samuel', :Minit => 'F')
		puts "updated"
	end

	where_hash = {Salary: 20000 ,Dno: 5}
	set_hash = {:Fname => 'Samuel', :Minit => 'F'}
	if Employee.update_all(where_hash, set_hash)
		puts "updated"
	end	

	if Employee.delete_all(Salary: 20000,Dno: 5)
		puts "deleted"
	end

	res = @employee1.show
	if res.nil?
		puts "no rec selected"
	else
		res.each_hash do |rec|
			rec.each do |key,value|
				puts "#{key}: #{value}"
			end
		end
	end

	res = Employee.show_all
	if res.nil?
		puts "no rec selected"
	else
		res.each_hash do |rec|
			rec.each do |key,value|
				puts "#{key}: #{value}"
			end
			puts ""
		end
	end

	where_hash = {Salary: 25000 ,Dno: 5}
	res = Employee.show_all(where_hash)	
	if res.nil?
		puts "no rec selected"
	else
		res.each_hash do |rec|
			rec.each do |key,value|
				puts "#{key}: #{value}"
			end
			puts ""
		end
	end

	puts Record.open "backup_org"
=end
end


=begin
require 'sqlite3'
SQLite3::Database.new "backup_org"
con = SQLite3::Database.open "backup_org"
#con.execute "CREATE TABLE IF NOT EXISTS EMPLOYEE(Id INTEGER PRIMARY KEY, 
 #       Name TEXT, Price INT)"
con.execute "CREATE TABLE `EMPLOYEE` (
  `Fname` varchar(15) NOT NULL,
  `Minit` char(1) DEFAULT NULL,
  `Lname` varchar(15) NOT NULL,
  `Ssn` char(9) NOT NULL PRIMARY KEY,
  `Bdate` date DEFAULT NULL,
  `Address` varchar(30) DEFAULT NULL,
  `Sex` char(1) DEFAULT NULL,
  `Salary` decimal(10,2) DEFAULT NULL,
  `Super_ssn` char(9) DEFAULT NULL,
  `Dno` int(11) NOT NULL
  )" 
=end