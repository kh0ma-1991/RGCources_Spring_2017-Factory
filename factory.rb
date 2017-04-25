class Factory
  def self.new(*args,&block)
    result = Class.new do

      attr_accessor *args

      define_method :initialize do |*i_args|
        for i in 0...(args.length)
          instance_variable_set("@#{args[i].to_s}","#{i_args[i].to_s}")
        end
      end

      define_method :[] do |i_arg|
        variable = ''
        variable = i_arg if (i_arg.instance_of? String)
        variable = i_arg.to_s if (i_arg.instance_of? Symbol)
        variable = args[i_arg] if (i_arg.is_a? Integer)
        instance_variable_get("@#{variable}")
      end
    end
    result.class_eval &block if block_given?
    result
  end
end

Customer = Factory.new(:name, :address, :zip)

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)

p joe.name    # => "Joe Smith"
p joe['name'] # => "Joe Smith"
p joe[:name]  # => "Joe Smith"
p joe[0]      # => "Joe Smith"

Kustomer = Factory.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end

p Kustomer.new('Dave', '123 Main').greeting