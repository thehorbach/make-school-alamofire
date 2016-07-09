values_for :numberOfFields, [5, 8, 1, 20, 5, 100]
values_for :wheatYield, [7.5, 10.0, 20.0, 1.5, 80.0, 0.5]
values_for :weatherWasGood, [true, false, true, false, true, false]

solution do |numberOfFields, wheatYield, weatherWasGood|
	total = numberOfFields * wheatYield
	total *= 1.5 if weatherWasGood

	total
end

float_output