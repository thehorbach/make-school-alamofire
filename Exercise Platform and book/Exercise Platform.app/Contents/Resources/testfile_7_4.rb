expects_func "countdown(_:)", type: "(Int) -> ()"

values_for :_number, [1, 3, 5, 7, 10]

before <<-ERB
func sleep(time: Int) {
	print("sleep \\\(time)")
}
ERB


add_func_call :countdown, "<%= _number %>", print: false
html_hide [:input]

solution do |number|
	res = ""
	(1..number).to_a.reverse.each do |i|
		res += "#{i}\n"
		if i > 1 
			res += "sleep 1\n"
		end
	end
	res += "GO!\n"
end

