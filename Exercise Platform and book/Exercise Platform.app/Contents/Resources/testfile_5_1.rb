values_for :firstName, ["Andrei", "Silviu", "Claudiu"  , "Chris",   "Steve"]
values_for :lastName,  ["Puni",   "Pop",    "Cerghizan", "Lattner", "Jobs"]

expects_value :fullName do |firstName, lastName|
	firstName + " " + lastName
end

html_hide [:your_var, :expected_var]

html_add "Your Result" do |firstName, lastName, run_info|
	info = run_info[:info]
	syntaxHighlight("\"#{info["fullName"]}\"")
end

html_add "Expected Result" do |firstName, lastName|
	syntaxHighlight("\"#{firstName + " " + lastName}\"")
end


has_no_output