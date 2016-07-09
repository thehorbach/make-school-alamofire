values_for :location, [
	Tuple.new({x: 0, y: 0}),
	Tuple.new({x: 1, y: 1}),
	Tuple.new({x: -1, y: -1}),
	Tuple.new({x: 10, y: 11}),
	Tuple.new({x: 30, y: 30})
]

values_for :steps, [
	[:Up, :Up, :Left, :Down, :Left],
	[:Up, :Up, :Left, :Down, :Left, :Up, :Left, :Right, :Right, :Down, :Left],
	[:Up, :Up, :Left, :Right, :Right, :Down, :Left, :Left, :Up, :Left, :Right],
	[:Up, :Up, :Left, :Down, :Left, :Up, :Left, :Right, :Right, :Down, :Left],
	[:Up, :Up, :Left, :Right, :Right, :Down, :Left, :Left, :Up, :Left, :Right]
]

solution do |location, steps|
	x, y = location.values

	steps.each do |step|
		if step == :Up
			x += 1
		end
		if step == :Down
			x -= 1
		end
		if step == :Right
			y += 1
		end
		if step == :Left
			y -= 1
		end
	end

	s Tuple.new([x, y])
end

