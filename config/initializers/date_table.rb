module DateTable
	
	def each_row(&block)
		table = map {|col| col.to_a.reverse}
		while true
			top = table.map do |col|
				col.any? ? col[0][0] : ''
			end
			break if (date = top.max).empty?
			entries = table.map do |col|
				if col.any? and col[0][0] == date
					col.shift[1]
				else
					[]
				end
			end
			yield date, entries
		end
	end

end
