values_for :aString, [
	"Hello World!",
	"We Heart Swift",
	"this string has 29 characters",
	"this is not a string"
]

expects_value :reverse do |aString|
	aString.reverse
end

html_hide [:your_var, :expected_var]

html_add "Your Result" do |aString, run_info|
	info = run_info[:info]
	syntaxHighlight("\"#{info["reverse"]}\"")
end

html_add "Expected Result" do |aString|
	syntaxHighlight("\"#{aString.reverse}\"")
end


has_no_output