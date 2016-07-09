expects_func "push(_:_:)", type: "(Int, inout [Int]) -> ()"
expects_func "pop(_:)", type: "(inout [Int]) -> Int?"

values_for :ops, [
	[[:push, 1], [:pop], [:push, 2], [:push, 3], [:pop], [:pop], [:pop], [:pop]],
	[[:pop], [:pop], [:push, 1], [:push, 1], [:pop], [:push, 2], [:push, 3],[:push, 2], [:push, 3], [:pop], [:pop], [:pop], [:pop]]
]


after <<-ERB
	<% if has_push and has_pop %>
	var q: [Int] = []

	<% ops.each do |op| %>
		<% if op[0] == :push %>
			push(<%= op[1] %>, &q)
			print(q)
		<% else %>
			print(pop(&q))
		<% end %>
	<% end %>

	<% end %>
ERB

html_hide [:input]
html_add "Test" do |ops|
	operations = "var q: [Int] = []\n\n"

	ops.each do |op|
		if op[0] == :push
			operations += "push(#{op[1]}, &q)\n"
			operations += "print(q)\n\n"
		else 
			operations += "print(pop(&q))\n\n"
		end
	end

	syntaxHighlight(operations)
end

solution do |ops|
	q = []
	res = ""

	ops.each do |op|
		if op[0] == :push
			q << op[1]
			res += "#{s q}\n"
		else
			val = q.shift
			if val 
				res += "Optional(#{val})\n"
			else
				res += "nil\n"
			end
		end
	end

	res
end

