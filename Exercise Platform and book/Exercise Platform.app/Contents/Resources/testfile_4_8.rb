values_for :N, [2, 4, 6, 8, 10]

solution do |n|
	result = ""
	n.times do |i|
		result += " " * (n - i - 1)
		result += "*" * (2 * (i + 1) - 1)
		result += "\n"
	end

	result
end
