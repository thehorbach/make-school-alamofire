values_for :a, [
	Tuple.new([1, 2]),
	Tuple.new([3, 42]),
	Tuple.new([11, 11]),
	Tuple.new([12, 13]),
	Tuple.new([4, 3])
]

values_for :b, [
	Tuple.new([2, 3]),
	Tuple.new([15, 2]),
	Tuple.new([22, 2]),
	Tuple.new([342, 12]),
	Tuple.new([21, 13])
]

expects_value :sum 

html_hide [:expected_var]
html_add "Example solution" do |a, b|
	a1, a2 = a.values
	b1, b2 = b.values

	top = a1 * b2 + b1 * a2
	bottom = a2 * b2

	syntaxHighlight("(#{top}, #{bottom})")
end

check_with do |a, b, info|
	rTop, rBot = info[:info]["sum"][1..-2].split(", ").map(&:to_i)

	a1, a2 = a.values
	b1, b2 = b.values

	bottom = a2 * b2
	top = a1 * b2 + b1 * a2

	rTop * bottom == rBot * top
end

has_no_output