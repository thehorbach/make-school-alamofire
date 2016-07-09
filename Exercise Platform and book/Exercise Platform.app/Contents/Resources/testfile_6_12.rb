values_for :N, [3, 10, 13, 20, 30]

html_hide [:your_var, :expected_var]

expects_value :fibonacci do |n| 
	f1 = 1
	f2 = 0

	ret = []

	n.times do 
		ret << f1
		f1, f2 = f1 + f2, f1
	end

	ret 
end

solution do |n|
	f1 = 1
	f2 = 0

	ret = []

	n.times do 
		ret << f1
		f1, f2 = f1 + f2, f1
	end

	ret.join("\n")
end