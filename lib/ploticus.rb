class Ploticus
	attr_reader :output
	attr_accessor :options
	def initialize
		@output = ""
		@debug = true
		@options = "-croprel 0.01,0.015,0.01,-0.025"
	end
	def script(&block)
		instance_eval &block
	end
	def render(format=:svg)
		f = IO.popen("ploticus -stdin -o stdout -#{format} #{options}", "w+")
		f.write @output
		f.close_write
		f.read
	end
	def <<(line)
		@output << line + "\n"
	end
	def save(file)
		format = file[file.rindex('.')+1..-1]
		File.open(file,'w') {|f| f.write(render(format))}
	end
protected
	def data(data)
		cmd(:data, data.map {|row| row.join(' ')}.join("\n        "))
	end
	def proc_(name, &block)
		self << "#proc #{name}"
		instance_eval &block
		self << ""
	end
	def if_(*args, &block)
		cmd("#if", *args)
		instance_eval &block
		cmd("#endif")
	end
	def clone(name)
		cmd("#clone", name)
	end
	def saveas(name)
		cmd("#saveas", name)
	end
	def group(name, &block)
		@group = name
		instance_eval &block
	end
	def cmd(name, *args)
		name = "#{@group}.name" if @group
		self << "  #{name}: #{format(args)}"
	end
	def format(arg)
		if arg.is_a? Hash
			arg.map {|k,v| "#{k}=#{format(v)}"}.join(' ')
		elsif arg.is_a? Array
			arg.map {|v| format(v)}.join(' ')
		else
			arg.to_s
		end
	end
	def method_missing(id, *args, &block)
		if block
			self.proc_(id.id2name, &block)
		else
			self.cmd(id.id2name, *args)
		end
	end
end
