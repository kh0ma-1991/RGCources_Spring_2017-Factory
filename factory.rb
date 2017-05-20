class Factory
  def self.new(*args, &block)
    unless args.all? { |arg| arg.instance_of? Symbol }
      raise NameError.new("identifier #{args.first} needs to be constant")
    end
    result = Class.new do
      attr_accessor *args
      define_method :initialize do |*i_args|
        if args.length != i_args.length
          raise ArgumentError.new('factory size differs')
        end
        args.each_with_index { |arg, index| send("#{arg}=", i_args[index]) }
      end
      define_method :[] do |i_arg|
        variable = (i_arg.is_a? Integer) ? args[i_arg] : i_arg
        unless respond_to? variable.to_s
          raise NameError.new("no member #{variable} in factory")
        end
        send(variable)
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
