values_for :finalsGrade,  [2.0, 5.0, 1.0, 2.0, 4.0]
values_for :midtermGrade, [3.0, 5.0, 2.0, 5.0, 3.0]
values_for :projectGrade, [2.0, 5.0, 4.0, 1.0, 2.0]


solution do |finalsGrade,midtermGrade,projectGrade|
	0.5 * finalsGrade + 0.2 * midtermGrade + 0.3 * projectGrade
end

float_output