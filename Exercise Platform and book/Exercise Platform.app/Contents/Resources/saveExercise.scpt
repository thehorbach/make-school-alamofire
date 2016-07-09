tell application "Xcode"
activate
delay 0.4

tell application "System Events" to tell process "Xcode" to key code 1 using {command down}

delay 0.1

end tell
