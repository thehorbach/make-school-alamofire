values_for :N, [2, 4, 6, 8, 1]
values_for :M, [1, 3, 2, 5, 10]

solution do |n, m|
	result = ""
	n.times do
		m.times do
			result += "*"
		end
		result += "\n"
	end

	result
end

