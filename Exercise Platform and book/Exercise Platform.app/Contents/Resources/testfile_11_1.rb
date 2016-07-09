def rot_code n
	alphabet = Array('a'..'z')
	
	code = alphabet[n..-1] + alphabet[0..n-1] 

	if n == 0
		code = alphabet
	end

	Hash[alphabet.zip(code)]
end


values_for :code, [
	rot_code(1),
	rot_code(3),
	rot_code(10),
	rot_code(13),
	rot_code(7)
]

values_for :message, [
	"hello world",
	"wow this problem is hard",
	"if you can read this you are on the right track",
	"the secret to life is forty two",
	"fun crypto challenge"
]

solution do |code, message|
	message.split("").map { |x|
		code[x] || " "
	}.join
end

