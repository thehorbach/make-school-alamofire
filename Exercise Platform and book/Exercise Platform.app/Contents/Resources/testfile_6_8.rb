values_for :listOfNumbers, [
	[1, 1, 1],
	[1, 4, 2, 3, 5, 1],
	[2, 5, 7, 23],
	[55, 66, 23, 31, 42],
	[43, 25, 57, 28, 93]
]

values_for :x, [
	2,
	2,
	1,
	31,
	25
]

solution do |listOfNumbers, x|
	listOfNumbers.include?(x) ? "yes" : "no"
end