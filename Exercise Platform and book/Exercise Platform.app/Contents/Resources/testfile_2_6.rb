values_for :year, [2014, 2000, 2004, 1900, 1999, 2011, 2020, 2016, 1996]

solution do |year|
	if year % 4 == 0
		if year % 100 == 0 and year % 400 != 0
			"Not a leap year!"
		else
			"Leap year!"
		end
	else
		"Not a leap year!"
	end
end
