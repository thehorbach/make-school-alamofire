values_for :N, [1, 2, 3, 4, 5]

solution do |n|
	result = ""
	n.times do |i|
		2.times do 
			result += "  " * (n - i - 1)
			result += "**" * (2 * (i + 1) - 1)
			result += "\n"
		end
	end

	result
end