values_for :a, [24, 21, 512, 12, 12345]
values_for :b, [18, 13, 512, 36, 2555]

solution do |a,b|
	def gcd(a,b)
		return a if b == 0
		return gcd(b,a % b)
	end

	result = "#{gcd(a,b)}\n"

	result
end