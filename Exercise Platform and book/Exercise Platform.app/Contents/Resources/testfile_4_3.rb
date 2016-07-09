values_for :N, [2, 4, 6, 8, 10]

solution do |n|
	result = ""

	pow = 2

	while pow <= n 
		result += "#{pow}\n"
		pow *= 2
	end

	result
end
