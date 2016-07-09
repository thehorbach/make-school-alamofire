values_for :grade1, [7.0,3.0,10.0,5.0,10.0]
values_for :grade2, [9.0,3.0,9.0,3.0,10.0]
values_for :grade3, [5.0,3.0,8.0,10.0,5.0]
values_for :yourGrade, [8.0,4.0,6.0,8.0,6.0]


solution do |grade1, grade2, grade3, yourGrade|
	average = (grade1 + grade2 + grade3 + yourGrade) / 4.0
	if (yourGrade > average)
		"above average"
	else
		"below average"
	end
end
