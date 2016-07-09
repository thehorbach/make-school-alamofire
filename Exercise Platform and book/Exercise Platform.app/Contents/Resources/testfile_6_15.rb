values_for :listOfNumbers, [
	[1, 1, 1],
	[1, 4, 2, 3, 5, 1],
	[2, 5, 7, 23],
	[55, 66, 23, 31, 42],
	[43, 25, 57, 28, 93]
]

expects_value :unique do |listOfNumbers|
	listOfNumbers.uniq	
end

solution do |listOfNumbers|
	listOfNumbers.uniq.map(&:to_s).join("\n")
end
