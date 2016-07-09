expects_func "combineArrays(_:_:_:)", type: "([Int], [Int], (Int, Int) -> Int) -> [Int]"

values_for :swift_code, [
	'{ $0 + $1 }',
	'{ $0 - $1 }',
	'{ $0 * $1 }',
	'{ ($0 + $1) * ($0 + $1) }',
	'{ ($0 + $1) * ($0 - $1) }'
]

values_for :ruby_code, [
	lambda { |x, y| return x + y },
	lambda { |x, y| return x - y },
	lambda { |x, y| return x * y },
	lambda { |x, y| return (x + y) ** 2 },
	lambda { |x, y| return (x + y) * (x - y) }
]

values_for :array1, [
	[1, 2, 3, 4, 6, 8, 9, 3, 12, 11],
	[1, 2, 3, 4, 5, 6, 7],
	[3, 3, 6, 7, 6, 3, 9],
	[1, 2, 5, 7, 13],
	[3, 3, 12, 2, 1, 3, 18]
]

values_for :array2, [
	[3, 5, 3, 4, 5, 8, 9, 1, 12, 31],
	[4, 4, 6, 2, 6, 1, 9],
	[1, 2, 3, 4, 5, 6, 7],
	[2, 4, 3, 8, 3],
	[5, 2, 21, 12, 13, 8, 21]
]

add_func_call :combineArrays, "<%= array1 %>, <%= array2 %>, <%= swift_code %>", print: true
html_hide [:input]


solution do |swift_code, ruby_code, array1, array2|
	s array1.zip(array2).map { |x, y| 
		ruby_code.call(x, y)
	}
end
