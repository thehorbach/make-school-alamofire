expects_func "gcd(_:_:)", recursive: true, type: "(Int, Int) -> Int"

values_for :a, [24, 21, 512, 12, 12345]
values_for :b, [18, 13, 512, 36, 2555]

def gcd a, b
	if b == 0
		a
	else
		if a > b 
			gcd(a-b, b)
		else 
			gcd(b, b-a)
		end
	end
end


add_func_call :gcd, "<%= a %>, <%= b %>", print: true
html_hide [:input]


solution do |a, b|
	gcd a, b
end

