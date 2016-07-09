require './utils.rb'
require './XcodeHelper.rb'


module Ast
	@@ast_cache = {}

	def self.cache 
		@@ast_cache
	end
end


def get_ast(code)
    md5 = Digest::MD5.new
    md5 << code

    codeHASH = md5.hexdigest
    
    if Ast.cache[codeHASH]
        return Ast.cache[codeHASH]
    end

    # puts codeHASH

    # store code
    path = "/var/tmp/ast#{codeHASH}.swift"
    File.open(path, "w+") { |file|  
        file << code
    }

    raw_ast = ""

    Open3.popen3("#{swiftc_2} -dump-ast #{path}") do |stdin, stdout, stderr|
        raw_ast = stderr.read
    end

    open("ast", "w") { |io|  io.write(raw_ast)}
    
    ast = parse_ast(raw_ast)

    Ast.cache[codeHASH] = ast

    ast 
end

def parse_ast(raw_ast)
    # fix to ignore wornings and other messages
    while raw_ast.lines.first[0] != "("
        if raw_ast.lines.first["error:"]
            return {
                status: :compilation_error
            }
        end
        
        raw_ast = raw_ast.lines[1..-1].join
    end
    
    if raw_ast[0] != "("
        return {
            status: :compilation_error
        }
    end
    
    root = nil
    stack = []
    level_stack = []
    last_level = 0
    
    raw_ast.lines.select { |line|
        line.strip.length != 0
    }.each do |line|
        if line.strip == ")"
            stack.pop
            next
        end
        
        
        if line.strip =~ /^\)+$/
            next
        end
        
        
        level = line.match(/^\s*/)[0].length
        closes = line.match(/\)*$/)[0].length
        
        rest_of_node = line.gsub(/^\s*\(/, "").gsub(/\)*$/, "")
        
        split = rest_of_node.split(" ")
        
        name = split.shift
        params = nil
        
        # puts "processing #{name} / #{level} | #{line.inspect}"
        
        if split.count > 0
            raw_params = split.join(" ")
            should_change = false
            
            for i in 0...raw_params.length
                if raw_params[i] == "'"
                    should_change = !should_change
                end
                if should_change and raw_params[i] == " "
                    raw_params[i] = "#"
                end
            end
            
            params = {}
            
            raw_params.split(" ").map { |param|
                param.gsub("#", " ")
            }.each do |param|
                eqsplit = param.split("=")
                if eqsplit.count == 2
                    key, val = eqsplit
                    params[key] = val
                    else
                    if param[0] == '"' and param[-1] == '"'
                        inside = param[1..-2]
                        
                        if name == "func_decl"
                            params[:signature] = inside
                            else
                            params[inside] = true
                        end
                        
                        if name == "var_decl"
                            params[:symbol] = inside
                        end
                        
                        if name == "enum_decl"
                            params[:symbol] = inside
                        end
                        
                        if name == "enum_element_decl"
                            params[:symbol] = inside
                        end
                        else
                        params[param] = true
                    end
                end
            end
            
            if name == "func_decl"
                if params["type"] and params["type"].is_a? String
                    params["type"] = params["type"].unstring
                end
            end
        end
        
        
        # puts [level, closes, name].inspect#, params]
        
        node = {
            name: name,
            level: level
        }
        
        if params 
            node[:params] = params
        end
        
        if root == nil 
            root = node
        end
        
        while stack.count > 0 and stack.last[:level] >= level
            stack.pop
        end
        
        stack << node
        
        if stack.count > 1 
            parent = stack[-2]
            
            parent[:childs] ||= []
            
            parent[:childs] << node
        end
        
        # closes.times do 
        # 	unless stack.empty?
        # 		stack.pop	
        # 	end
        # end
    end
    
    
    # puts raw_ast
    # exit
    
    # puts JSON.pretty_generate(root)
    # puts "*" * 60
    # puts variables_from(root)
    
    # print_ast root
    
    root
end

def functions_from ast 
	if ast[:name] == "func_decl"
		# puts ast[:params]
		func_name = ast[:params][:signature]
		return [func_name]
	elsif ast[:childs] 
		return ast[:childs].map { |child|
			functions_from child
		}.reduce([]) { |x, y|
			x + y
		}.select { |x|
			x != nil
		}
	else
		return []
	end
end

def functions_info_from ast 
	if ast[:name] == "func_decl"
		return [ast[:params]]
	elsif ast[:childs] 
		return ast[:childs].map { |child|
			functions_info_from child
		}.reduce([]) { |x, y|
			x + y
		}
	else
		return []
	end
end

def variables_from ast 
	if ast[:name] == "var_decl"
		var_name = ast[:params][:symbol]
		return [var_name]
	elsif ast[:childs] 
		return ast[:childs].map { |child|
			variables_from child
		}.reduce([]) { |x, y|
			x + y
		}
	else
		return []
	end
end

def variables_with_types_from ast 
	if ast[:name] == "var_decl"
		var_name = ast[:params][:symbol]
		type = ast[:params]["type"][1..-2]
		return [[var_name, type]]
	elsif ast[:childs] 
		return ast[:childs].map { |child|
			variables_with_types_from child
		}.reduce([]) { |x, y|
			x + y
		}
	else
		return []
	end
end

def enums_from ast 
	if ast[:name] == "enum_decl"
		enum_name = ast[:params][:symbol]
		return [{
			enum: enum_name,
			elements: enums_elements_from(ast)
		}]
	elsif ast[:childs] 
		return ast[:childs].map { |child|
			enums_from child
		}.reduce([]) { |x, y|
			x + y
		}
	else
		return []
	end
end

def enums_elements_from ast 
    if ast[:name] == "enum_case_decl"
    	if ast[:childs] == nil or ast[:childs].count == 0
    		return []
    	end

    	element_names = ast[:childs].select { |child|
    		child[:name] == "enum_element_decl"
    	}.map { |child|
    		child[:params][:symbol]
    	}
    	
		return element_names
	elsif ast[:childs] 
		return ast[:childs].map { |child|
			enums_elements_from child
		}.reduce([]) { |x, y|
			x + y
		}
	else
		return []
	end
end

def function_calls_from ast
	calls = []

	if ast[:name] == "declref_expr"
		element_name = ast[:params]["decl"]

		# puts "B: #{element_name}"

		if element_name["@"]
			element_name = element_name.split("@").first
		end

		element_name = element_name.split('.').last

		if element_name["("]
			element_name = element_name.split("(").first
		end

		# puts "E: #{element_name}"

		calls << element_name
	end

	if ast[:childs] 
		calls += ast[:childs].map { |child|
			function_calls_from child
		}.inject([], :+)
	end
	
	return calls
end

def is_function_called(function_name, ast, function_calls=nil)

	if function_calls == nil
		function_calls = function_calls_from(ast)
	end

	# puts "=" * 100
	# puts "function_name = #{function_name}"
	# puts "function_calls = #{function_calls.inspect}"

	# print_ast ast

	function_calls.each do |call|
		return true if call == function_name
	end

	return false
end

def print_ast ast, indent = ""
	if indent == ""
		puts "-" * 60
	end

	puts "#{indent}* #{ast[:name]}[#{(ast[:childs] || []).count}]"
	if ast[:childs]
		ast[:childs].each do |child|
			print_ast child, indent + "  "
		end
	end
end

def function_declaration(function_name, ast) 
	if ast[:name] == "func_decl"
		func_name = ast[:params][:signature].split("(")[0]

		if func_name == function_name
			return ast 
		else 
			return nil
		end
	elsif ast[:childs]
		declaration = nil
		
		ast[:childs].each do |child|
			declaration ||= function_declaration(function_name, child)
		end

		return declaration
	else 
		return nil
	end
end

def is_function_recursive(function_name, ast)
	declaration = function_declaration(function_name, ast)

	# print_ast ast
	
	if declaration 
		if is_function_called(function_name, declaration)
			return true 
		end
	end

	return false

end