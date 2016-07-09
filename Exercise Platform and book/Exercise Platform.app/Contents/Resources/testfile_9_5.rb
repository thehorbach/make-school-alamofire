values_for :numbers, [
	[1, 2, 3, 4, 6, 8, 9, 3, 12, 11],
	[1, 2, 3, 4, 5, 6, 7],
	[3, 3, 6, 7, 6, 3, 9],
	[1, 2, 5, 7, 13],
	[3, 3, 12, 2, 1, 3, 18]
]

expects :numbers do |numbers|
	sorted = numbers.sort { |x, y|
		n_div(x) <=> n_div(y)
	}

	sorted
end

html_hide [:expected_var]

html_add "Example solution" do |numbers|
	sorted = numbers.sort { |x, y|
		n_div(x) <=> n_div(y)
	}

	syntaxHighlight("#{s sorted}")
end

def n_div x
	Array(1..x).select { |i|
		x % i == 0
	}.count
end

check_with do |numbers, run_info|
	sorted = numbers.sort { |x, y|
		n_div(x) <=> n_div(y)
	}

	begin
		user = run_info[:info]["numbers"][1..-2].split(",").map(&:to_i)

		if user.count == sorted.count
			isOK = true
			
			user.zip(sorted).each do |u, s|
				if n_div(u) != n_div(s)
					isOK = false
					break
				end
			end

			isOK
		else
			false
		end
	rescue Exception => e
		false
	end
end

has_no_output
