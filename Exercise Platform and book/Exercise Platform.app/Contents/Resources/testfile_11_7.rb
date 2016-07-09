values_for :numbers, [
	[1, 2, 3, 2, 3, 5, 2, 1, 3, 4, 2, 2, 2],
	[3, 8, 8, 7, 2, 3, 5, 2, 1, 3, 4, 2, 2, 2],
	[8, 8, 7, 2, 3, 5, 2, 1, 3, 1, 2, 3, 8, 8, 4, 2, 2, 2],
	[6, 3, 9, 9, 2, 1, 3, 1, 2, 3, 8, 8, 4, 2, 2, 2],
	[2, 3, 8, 6, 3, 9, 9, 2, 1, 3, 1]
]

html_hide [:expected_output]
html_add "Example Solution" do |numbers|
	fr = Hash[numbers.zip(numbers.map { |x|
		numbers.select { |y| y == x}.count
	})]

	codeHighlight(numbers.uniq.map { |nr|
		"#{nr} #{fr[nr]}"
	}.join("\n"))
end

check_with do |numbers, run_info|
	output = run_info[:output]

	fr = Hash[numbers.zip(numbers.map { |x|
		numbers.select { |y| y == x}.count
	})]

	isOK = true

	output.lines.map { |line|
		line.split.map(&:to_i)
	}.each do |nr, f|
		if fr[nr] != f 
			isOK = false
			break
		end
	end

	if output.lines.map { |line| line.split.map(&:to_i).first }.uniq.count != numbers.uniq.count
		isOK = false
	end

	isOK
end