-- Convert date function. Call with string in YYYY-MM-DD HH:MM:SS format (time part optional)
on convertDate(textDate)
	set resultDate to the current date
	
	set the year of resultDate to (text 1 thru 4 of textDate)
	set the month of resultDate to (text 6 thru 7 of textDate)
	set the day of resultDate to (text 9 thru 10 of textDate)
	set the time of resultDate to 0
	
	if (length of textDate) > 10 then
		set the hours of resultDate to (text 12 thru 13 of textDate)
		set the minutes of resultDate to (text 15 thru 16 of textDate)
		
		if (length of textDate) > 16 then
			set the seconds of resultDate to (text 18 thru 19 of textDate)
		end if
	end if
	
	return resultDate
end convertDate

use application "OmniFocus"
use O : script "omnifocus"

on run argv
	set taskName to (item 1 of argv)
	set projectName to (item 2 of argv)
	set sectionName to (item 3 of argv)
	set dueDate to (item 4 of argv)
	set notes to (item 5 of argv)
	
	if (dueDate is not "-") then
		set convertedDueDate to convertDate(dueDate)
	end if
	
	tell O
		set foundContext to 0
		try
			set theContext to findContext("Asana")
			set foundContext to 1
		end try
		
		if (foundContext is 0) then
			tell default document
				set theContext to make new context with properties {name:"Asana"}
				set foundContext to 1
			end tell
		end if
	end tell
	
	tell default document
		set theTask to make new inbox task with properties {name:taskName}
	end tell
	
	tell O
		try
			if (foundContext is 0) then
				setContext(theTask, "Asana")
			else
				setContext(theTask, theContext)
			end if
		end try
		
		try
			if (sectionName is not "-") then
				set projectSet to 0
				try
					set theProject to findProjectContains(sectionName)
					set projectSet to 1
				end try
				
				if (projectSet is 0) then
					if (projectName is not "-") then
						set theProject to findProjectContains(projectName)
					end if
				end if
			else
				if (projectName is not "-") then
					set theProject to findProjectContains(projectName)
				end if
			end if
		end try
		
		try
			if (isProject(theProject)) then
				setContainer(theTask, theProject)
			end if
		end try
		
		if (dueDate is not "-") then
			set due date of theTask to convertedDueDate
		end if
		
		if (notes is not "-") then
			set note of theTask to notes
		end if
		
		return id of theTask
	end tell
	
	--set transportText to (item 1 of argv)
	
	--tell O
	--	set parseResponse to parse(transportText)
	--	set newTask to first item of parseResponse
	--	return id of newTask
	--end tell
end run