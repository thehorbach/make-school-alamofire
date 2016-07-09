first_names = %w{ Calvin Garry Leah Sonja Noel Andrei Silviu Claudiu Alex }
last_names = %w{ Newton Mckenzie Rivera Moreno Bowen Puni Pop Smith Doe }

peoples = first_names.zip(last_names).map { |f, l|
	{
		"firstName" => f,
		"lastName" => l,
		"score" => f.length
	}
}

values_for :people, [
	peoples[1..3],
	peoples[3..-1],
	peoples[2..-2],
	peoples[0..-3],
	peoples[2..5]
]

solution do |people|
	best = -1
	sol = ""

	people.each do |p|
		if p["score"] > best
			best = p["score"]
			sol = "#{p["firstName"]} #{p["lastName"]}"
		end
	end

	sol
end