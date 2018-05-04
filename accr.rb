$h= Hash.new
def att_accessor(*args)
	args.each do |arg|
		puts "defining setter and getter methods for #{arg}"
		define_method("#{arg}=") do |var|
			puts self
			#instance_variable_set("@#{arg}",var)
     		$h.merge!("#{self}_#{arg}"=> var)
	   	end
	    define_method("#{arg}") do
	    	#instance_variable_get("@#{arg}")
	    	$h["#{self}_#{arg}"]
	   	end
	end
end

class Car
	att_accessor :engine_price, :wheel_price, :airbag_price, :alarm_price, :stereo_price
end

class Vehicle
	att_accessor :engine_price
end

c = Car.new
c1 = Car.new
c1.engine_price = 25
c1.wheel_price = 50
c.engine_price = 10
v = Vehicle.new
v.engine_price = 20
puts v.engine_price
puts c.engine_price
puts c1.engine_price
puts c1.wheel_price