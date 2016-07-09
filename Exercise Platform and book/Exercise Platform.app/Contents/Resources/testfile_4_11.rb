values_for :N, [3, 5, 4, 8, 10]

solution do |n|
	result = "+#{'-' * n}+\n"

	n.times do |i|
		if i % 2 == 0
			chr = "#"
		else
			chr = " "
		end
		result += "|"
		n.times do |j|
			result += chr
			if chr == "#"
				chr = " "
			else
				chr = "#"
			end
		end
		result += "|\n"
	end
	result += "+#{'-' * n}+\n"

	result
end
