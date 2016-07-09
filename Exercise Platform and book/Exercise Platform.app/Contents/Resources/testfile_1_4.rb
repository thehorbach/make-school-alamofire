has_no_output

values_for :sum, [16, 9, 13]
values_for :diff, [4, 5, 1]

expects_value :a
expects_value :b

html_hide [:expected_var]
html_add "Example Solution" do |sum, diff|
	a = (sum + diff) / 2
	b = sum - a

	syntaxHighlight("a = #{a}, b = #{b}")
end

check_with do |sum, diff, run_info|
	a = run_info[:info]["a"].to_i
	b = run_info[:info]["b"].to_i

	allOK = false

	if a + b == sum and [a, b].max - [a, b].min == diff
		allOK = true
	end

	allOK
end
