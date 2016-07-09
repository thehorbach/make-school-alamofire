values_for :numbers, [
	[4, 2, 6, 60, 20],
	[1, 1],
	[12, 60, 42, 66],
	[55, 66, 22, 33, 44],
	[8, 32, 16, 128]
]

solution do |numbers|
	(1..numbers.max).to_a.select { |div|
		numbers.select { |number|
			number % div == 0
		}.count == numbers.count
	}.max
end
