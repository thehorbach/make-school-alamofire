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

expects :fullNames

html_hide [:your_var, :expected_var]

html_add "Your Result" do |people, runInfo|
	info = runInfo[:info]

	fullNames = info["fullNames"]

	if fullNames[0] == "[" and fullNames[-1] == "]"
		formated = fullNames

		syntaxHighlight(formated)
	else
		syntaxHighlight("")
	end
end

html_add "Example Solution" do |people|
	syntaxHighlight(s(people.map { |x| x["firstName"] + " " + x["lastName"] }))
end

has_no_output

check_with do |people, run_info|
	full_names = run_info[:info]["fullNames"][1..-2].split(", ").map { |name|
		name[0] == '"' ? name[1..-2] : name 
	}

	solution = people.map { |x| x["firstName"] + " " + x["lastName"] }

	full_names == solution
end