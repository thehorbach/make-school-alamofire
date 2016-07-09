first_names = %w{ Calvin Garry Leah Sonja Noel Andrei Silviu Claudiu Alex }
last_names = %w{ Newton Mckenzie Rivera Moreno Bowen Puni Pop Smith Doe }

peoples = first_names.zip(last_names).map { |f, l|
	{
		"firstName" => f,
		"lastName" => l
	}
}

values_for :people, [
	peoples[1..3],
	peoples[3..-1],
	peoples[2..-2],
	peoples[0..-3],
	peoples[2..5]
]

expects :firstNames 

html_hide [:your_var, :expected_var]

html_add "Your Result" do |people, runInfo|
	info = runInfo[:info]

	firstNames = info["firstNames"]

	if firstNames[0] == "[" and firstNames[-1] == "]"
		formated = firstNames

		syntaxHighlight(formated)
	else
		syntaxHighlight("")
	end
end

html_add "Example Solution" do |people|
	syntaxHighlight(s(people.map { |x| x["firstName"] }))
end


has_no_output

check_with do |people, run_info|
	first_names = run_info[:info]["firstNames"][1..-2].split(", ").map { |name|
		name[0] == '"' ? name[1..-2] : name 
	}

	solution = people.map { |x| x["firstName"] }

	first_names == solution
end