values_for :mealCost, [3.5,10.0,30.0,100.0,1.5]
values_for :tip, [25,0,12,10,200]


solution do |mealCost,tip|
	mealCost * (100.0 + tip) / 100.0
end

float_output