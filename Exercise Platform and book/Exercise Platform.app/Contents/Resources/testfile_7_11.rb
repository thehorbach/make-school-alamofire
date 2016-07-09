expects_func "timeDifference(firstHour:firstMinute:secondHour:secondMinute:)", 
			 type: "(firstHour: Int, firstMinute: Int, secondHour: Int, secondMinute: Int) -> Int"

values_for :firstHour,    [12, 13, 14, 15]
values_for :firstMinute,  [ 0, 15, 30, 45]
values_for :secondHour,   [12, 13, 18, 22]
values_for :secondMinute, [ 9, 56, 11, 45]


params = "firstHour: <%= firstHour %>, firstMinute: <%= firstMinute %>, secondHour: <%= secondHour %>, secondMinute: <%= secondMinute %>"
add_func_call :timeDifference, params, print: true

html_hide [:input]

solution do |firstHour, firstMinute, secondHour, secondMinute |
	hourDifference = secondHour - firstHour
    minuteDifference = secondMinute - firstMinute

    if minuteDifference < 0 
        hourDifference -= 1
        minuteDifference += 60
    end

    s (hourDifference * 60 + minuteDifference)
end

