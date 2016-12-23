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
	set taskId to (item 1 of argv)
	set taskName to (item 2 of argv)
	if (item 3 of argv is "true") then
		set taskCompleted to true
	else
		set taskCompleted to false
	end if
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
			set pendingTasks to allTasks()
		else
			set pendingTasks to every task of theContext whose completed is false
		end if
		
		repeat with theTask in pendingTasks
			if (id of theTask = taskId) then
				
				if (taskName is not "-") then
					set name of theTask to taskName
				end if
				
				log (taskCompleted)
				if (taskCompleted is not "-") then
					set completed of theTask to taskCompleted
				end if
				
				if (dueDate is not "-") then
					set due date of theTask to convertedDueDate
				end if
				
				if (notes is not "-") then
					set note of theTask to notes
				end if
				
				return true
				
				exit repeat
			end if
		end repeat
		
		-- may have been completed recently
		if (foundContext is 0) then
			set completedTasks to every flattened task of default document whose completed is true
		else
			set completedTasks to every task of theContext whose completed is true
		end if
		
		repeat with theTask in completedTasks
			if (id of theTask = taskId) then
				
				if (taskName is not "-") then
					set name of theTask to taskName
				end if
				
				log (taskCompleted)
				if (taskCompleted is not "-") then
					set completed of theTask to taskCompleted
				end if
				
				if (dueDate is not "-") then
					set due date of theTask to convertedDueDate
				end if
				
				if (notes is not "-") then
					set note of theTask to notes
				end if
				
				return true
				
				exit repeat
			end if
		end repeat
	end tell
end run