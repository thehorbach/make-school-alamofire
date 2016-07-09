expects_func "push(_:_:)", type: "(Int, inout [Int]) -> ()"
expects_func "top(_:)", type: "([Int]) -> Int?"
expects_func "pop(_:)", type: "(inout [Int]) -> Int?"

values_for :ops, [
	[[:push, 1], [:pop], [:top], [:push, 2], [:push, 3], [:pop], [:pop], [:pop], [:pop]],
	[[:pop], [:pop], [:push, 1], [:push, 1], [:top], [:pop], [:push, 2], [:push, 3],[:push, 2], [:push, 3], [:pop], [:pop], [:pop], [:pop]]
]


after <<-ERB
	<% if has_push and has_pop and has_top %>
	var s: [Int] = []

	<% ops.each do |op| %>
		<% if op[0] == :push %>
			push(<%= op[1] %>, &s)
			print(s)
		<% elsif op[0] == :pop %>
			print(pop(&s))
		<% else %>
			print(top(s))
		<% end %>
	<% end %>

	<% end %>
ERB

html_hide [:input]
html_add "Test" do |ops|
	operations = "var s: [Int] = []\n\n"

	ops.each do |op|
		if op[0] == :push
			operations += "push(#{op[1]}, &s)\n"
			operations += "print(s)\n\n"
		elsif op[0] == :pop
			operations += "print(pop(&s))\n\n"	
		else 
			operations += "print(top(s))\n\n"
		end
	end

	syntaxHighlight(operations)
end


solution do |ops|
	st = []
	res = ""

	ops.each do |op|
		if op[0] == :push
			st << op[1]
			res += "#{s st}\n"
		elsif op[0] == :pop
			val = st.pop
			if val 
				res += "Optional(#{val})\n"
			else
				res += "nil\n"
			end
		else
			if st.count > 0
				res += "Optional(#{st.last})\n"
			else
				res += "nil\n"
			end
		end
	end

	# puts res

	res
end

