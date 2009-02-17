class Ploticus
	attr_reader :output
	attr_accessor :options
	def initialize
		@output = ""
		#@options = "-croprel 0.01,0.015,0.01,-0.025"
		@options = ""
	end
	def script(opts={}, &block)
		opts.each {|k,v| eval "@#{k} = v"}
		instance_eval &block
		self
	end
	def self.script(*args, &block)
		self.new.script *args, &block
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
	def format_data(data)
		data.map do |row|
			row.is_a?(Array) ? row.join(' ') : row.to_s
		end.join("\n        ")
	end
protected
	def proc_(name, &block)
		oldp, @proc = @proc, name
		self << "#proc #{name}"
		instance_eval &block
		self << ""
		@proc = oldp
	end
	def group(name, &block)
		old_group, @group = @group, name
		instance_eval &block
		@group = old_group
	end
	def meta(name, *args, &block)
		pre = @proc ? "  " : ""
		self << "#{pre}##{name} #{format(args)}"
		if block
			oldp, @proc = @proc, name
			instance_eval &block
			self << ""
			@proc = oldp
		end
	end
	def cmd(name, *args)
		name = "#{@group}.#{name}" if @group
		data = format(args)
		self << "  #{name}: #{data}"
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
		name = id.id2name
		if name.starts_with? '_'
			meta(name[1..-1], *args, &block)
		elsif block
			proc_(name, &block)
		else
			cmd(name, *args)
		end
	end
end
