values_for :N, [2, 4, 6, 8, 10]

solution do |n|
	result = ""
	n.times do |i|
		(i + 1).times do
			result += "*"
		end
		result += "\n"
	end

	result
end
