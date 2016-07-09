values_for :a, [2, 2, 3, 4, 10, 65]
values_for :b, [2, 5, 2 , 9, 22, 17]

solution do |a, b|
	a + b
end

expects_value :sum, :SOLUTION


#POSSIBLE USES

# expects_value :sum, 

# expects_value :sum do |a,b|
# 	a * b
# end

# puts variabila