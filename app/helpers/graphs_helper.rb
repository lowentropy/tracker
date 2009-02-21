module GraphsHelper

	def ploticus(format=:svg, render=true, opts={}, &block)
		with opts do
			script = capture &block
			unless render
				concat script
			else
				f = IO.popen "ploticus -stdin -o stdout -#{format}", 'w+'
				f.write script
				f.close_write
				concat f.read
				f.close
			end
		end
	end

	def format_data(data)
		data.map do |elem|
			elem.is_a?(Array) ? row.join(' ') : row.to_s
		end.join("\n        ")
	end

	def method_missing(id, *args, &block)
		name = id.id2name
		if name.starts_with? '_'
			meta name[1..-1], *args, &block
		elsif block
			proc_ name, &block
		else
			command name, *args
		end
	end

#protected

	def with(assn={}, &block)
		assn.each {|k,v| eval "@#{k} = v"}
		yield
		assn.keys.each {|k| eval "@#{k} = nil"}
	end

	def proc_(name, &block)
		concat "#proc #{name}\n#{inner}\n"
		with(:proc => name, &block)
		concat "\n"
	end

	def group(name, &block)
		with(:group => name + '.', &block)
	end

	def meta(name, *args, &block)
		concat "#{' ' if @proc}##{name} #{format(args)}\n"
		if block
			with(:proc => name, &block) 
			concat "\n", block.binding
		end
	end

	def command(name, *args)
		concat "  #{@group}#{name}: #{format(args)}\n"
	end

	def format(arg)
		case arg
			when Hash then arg.map {|k,v| "#{k}=#{format(v)}"}.join(' ')
			when Array then arg.map {|v| format(v)}.join(' ')
			else arg.to_s
		end
	end

end
