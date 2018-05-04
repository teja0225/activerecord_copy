require 'mysql'  
require 'sqlite3'
class Record

	def self.connect(db,host,username,password,database)
		@@db = db
		@@host = host
		@@username = username
		@@password = password
		@@database = database
		puts "#{@@db} #{@@host} #{@@username} #{@@password} #{@@database}"
	end

	def connection
		if @@db.downcase == 'mysql'
			con = Mysql.new(@@host, @@username, @@password, @@database) 
		elsif @@db.downcase == 'sqlite'
			con = SQLite3::Database.open "backup_org"
		end
	end

	def self.open(db)
		puts "Executing Query: USE #{db}"
		return !Record.new.connection.query("USE #{db}")
	end

	def exec_query(query)
		begin
			puts query
			if @@db.downcase == 'mysql'
				res = connection.query(query)
				connection.close
			elsif @@db.downcase == 'sqlite'
				res = connection.execute(query)
				puts res
			end
			if res.nil?
				return true
			else
				return res
			end
		rescue => ex
			puts ex.message
			return false
		end
	end

	def get_key(table_name)
		key = ""
		res = connection.query("SHOW KEYS FROM #{table_name} WHERE Key_name = 'PRIMARY'")
		res.each_hash { |h| key = h['Column_name']} 
		return key
	end

	def insert(table_name,*args)
		table_name = table_name.to_s.upcase
		query = Array.new
		args.each do |arg|
			if arg.is_a? String
				arg = "'#{arg}'"
			end
			query << arg
		end
		return exec_query("INSERT INTO #{table_name} values (#{query.join(',')})")
	end

	def update(table_name,where,set)
		table_name = table_name.to_s.upcase
		query = Array.new
		where_clause = Array.new
		if where.is_a? Hash
			where.each do |key,value|
			if value.is_a? String
				value = "'#{value}'"
			end	
			where_clause << "#{key}=#{value}"
		end
		else
			if where.is_a? String
				where = "'#{where}'"
			end	
			key = get_key(table_name)
			where_clause << "#{key} = #{where}"
		end
		set.each do |key,value|
			if value.is_a? String
				value = "'#{value}'"
			end	
			query << "#{key}=#{value}"
		end
		return exec_query("UPDATE #{table_name} SET #{query.join(",")} WHERE #{where_clause.join(" and ")}") 
	end

	def delete(table_name,args)
		table_name = table_name.to_s.upcase
		if args.is_a? Hash
			query = Array.new
			args.each do |key,value|
				if value.is_a? String
					value = "'#{value}'"
				end
				query << "#{key}=#{value}"
			end
				return exec_query("DELETE FROM #{table_name} WHERE #{query.join(" and ")}")
		else
			if args.is_a? String
				args = "'#{args}'"
			end
			key = get_key(table_name)
			return exec_query("DELETE FROM #{table_name} WHERE #{key}=#{args}") 
		end
	end

	def show (table_name,id)
		table_name = table_name.to_s.upcase
		if id.is_a? String
			id  = "'#{id}'"
		end
		key = get_key(table_name)
		return exec_query("SELECT * FROM #{table_name} WHERE #{key} = #{id}")
	end

	def show_all(table_name,attributes = {})
		table_name = table_name.to_s.upcase
		query = Array.new
		if attributes == {}
			return exec_query("SELECT * FROM #{table_name}")
		else
			attributes.each do |key,value|
				if value.is_a? String
					value = "'#{value}'"
				end
				query << "#{key}=#{value}"
			end
			return exec_query("SELECT * FROM #{table_name} where #{query.join(" and ")}")
		end
	end
end

class Employee
	
	attr_accessor :fname, :minit, :lname, :employee_id, :bdate, :address, :sex, :salary, :super_ssn, :dno

	def initialize(fname = "", minit = "", lname = "", employee_id = "", bdate = "", address = "", sex = "", salary = "", super_ssn = "", dno = "")
    self.fname = fname
    self.minit = minit
    self.lname = lname
    self.employee_id = employee_id
    self.bdate = bdate
    self.address = address
    self.sex = sex
    self.salary = salary
    self.super_ssn = super_ssn
    self.dno = dno
  end

	def save
		res = Record.new.insert(self.class,
														self.fname,
    												self.minit,
    												self.lname,
    												self.employee_id,
    												self.bdate,
    												self.address,
    												self.sex,
    												self.salary,
    												self.super_ssn,
    												self.dno)
		return res
	end

	def update(*attributes)
		Record.new.update(self.class,self.employee_id,*attributes)
	end

	def self.update_all(where_hash,set_hash)
		Record.new.update(self,where_hash,set_hash)
	end

	def delete()
		Record.new.delete(self.class,self.employee_id)
	end

	def self.delete_all(*attributes)
		Record.new.delete(self,*attributes)
	end

	def show
		return Record.new.show(self.class,self.employee_id)
	end

	def self.show_all(*attributes)
		Record.new.show_all(self,*attributes)
	end
end