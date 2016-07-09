values_for :a, [2, 2, 3, 4, 10, 65]
values_for :b, [2, 5, 2 , 9, 22, 17]

expects_value :formattedSum do |a, b|
	"#{a} + #{b} = #{a + b}"
end

html_hide [:your_var, :expected_var]

html_add "Your Result" do |a, b, run_info|
	info = run_info[:info]
	syntaxHighlight("\"#{info["formattedSum"]}\"")
end

html_add "Expected Result" do |a, b|
	syntaxHighlight("\"#{"#{a} + #{b} = #{a + b}"}\"")
end

has_no_output