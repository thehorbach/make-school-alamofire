require './plist.rb'

def findXcode bigversion = 6
	xcode_candidates = Dir["/Applications/**.app"].select { |candidate|
		is_xcode(candidate)
	}.select { |candidate|
		is_version(bigversion, candidate)
	}
	
	xcode_candidates.first
end

def is_xcode filepath
	unless File.directory? filepath
		return false
	end

	unless File.exists? filepath + "/Contents/version.plist"
		return false
	end

	unless File.exists? filepath + "/Contents/XPCServices"
		return false
	end
	
	unless File.exists? filepath + "/Contents/Developer"
		return false
	end

	filepath.downcase["xcode"] != nil
end


def is_version ver, filepath
	version_info = Plist::parse_xml("#{filepath}/Contents/version.plist")

	version = version_info["CFBundleShortVersionString"]

	big_version = version.split(".").first

	big_version == ver.to_s
end

def xcode_swift_location xcode 
	(xcode + "/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift").gsub(" ", '\ ')
end

def xcode_swiftc_location xcode 
	(xcode + "/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc").gsub(" ", '\ ')
end


@swift_1_location = nil

def swift_1
	@swift_1_location ||= xcode_swift_location findXcode(6)
	@swift_1_location
end

@swift_2_location = nil

def swift_2
	@swift_2_location ||= xcode_swift_location findXcode(7)
	@swift_2_location
end


@swiftc_1_location = nil

def swiftc_1
	@swiftc_1_location ||= xcode_swiftc_location findXcode(6)
	@swiftc_1_location
end

@swiftc_2_location = nil

def swiftc_2
	@swiftc_2_location ||= xcode_swiftc_location findXcode(7)
	@swiftc_2_location
end

# puts `#{swift_1} --version`
# puts swift_2

# puts `#{swiftc_1} --version`
# puts `#{swiftc_2} --version`






