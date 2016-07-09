values_for :aString, [
	"Replace the letter e with *",
	"We Heart Swift",
	"Did you know that Kathy is throwing a party tonight?",
	"ee eeeee eee ee hello",
	"this is not a string"
]

expects_value :replacedString do |aString|
	aString.gsub("e", "*")
end

html_hide [:your_var, :expected_var]

html_add "Your Result" do |aString, run_info|
	info = run_info[:info]
	syntaxHighlight("\"#{info["replacedString"]}\"")
end

html_add "Expected Result" do |aString|
	syntaxHighlight("\"#{aString.gsub("e", "*")}\"")
end

has_no_output