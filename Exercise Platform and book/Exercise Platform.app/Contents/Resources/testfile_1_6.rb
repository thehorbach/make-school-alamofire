has_no_output

values_for :a, [1, 3, 10]
values_for :b, [2, 2, 32]

expects_value :a do |a, b|
	b
end

expects_value :b do |a, b|
	a 
end

check_with do |a, b, run_info|
	newa = run_info[:info]["a"].to_i
	newb = run_info[:info]["b"].to_i

	newa == b and newb == a
end

