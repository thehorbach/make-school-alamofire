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

values_for :encodedMessage, [
	"ifmmp xpsme",
	"zrz wklv sureohp lv kdug",
	"sp iye mkx bokn drsc iye kbo yx dro bsqrd dbkmu",
	"gur frperg gb yvsr vf sbegl gjb",
	"mbu jyfwav johsslunl"
]

solution do |code, encodedMessage|
	decoder = code.invert

	encodedMessage.split("").map { |x|
		decoder[x] || " "
	}.join
end



