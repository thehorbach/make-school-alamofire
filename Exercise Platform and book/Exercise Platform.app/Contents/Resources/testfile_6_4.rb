values_for :listOfNumbers, [
	[1, 1, 1],
	[1, 4, 2, 3, 5, 1],
	[2, 5, 7, 23],
	[55, 66, 23, 31, 42],
	[43, 25, 57, 28, 93]
]

solution do |listOfNumbers|
	ret = ""

	listOfNumbers.each_with_index do |number, index|
		if index % 2 == 1
			ret += "#{number}\n"
		end
	end

	ret
end