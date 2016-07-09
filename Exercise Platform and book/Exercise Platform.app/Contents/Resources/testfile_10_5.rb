values_for :moneyArray, [
	[
		Tuple.new([10, :Penny]),  
		Tuple.new([15, :Nickle]),  
		Tuple.new([3,  :Quarter]),  
		Tuple.new([20, :Penny]),  
		Tuple.new([3,  :Dime]),  
		Tuple.new([7,  :Quarter])
	],
	[
		Tuple.new([23,  :Dime]),  
		Tuple.new([33,  :Quarter]),  
		Tuple.new([12, :Penny]),  
		Tuple.new([35, :Nickle]),  
		Tuple.new([27, :Penny]),  
		Tuple.new([13,  :Quarter])
	]

]

@_coinValues = {
	:Penny => 1,
	:Nickle => 5,
	:Dime => 10,
	:Quarter => 25
}

solution do |moneyArray|
	total = 0

	moneyArray.each do |info|
		cnt, type = info.data

		total += @_coinValues[type] * cnt
	end

	s total
end