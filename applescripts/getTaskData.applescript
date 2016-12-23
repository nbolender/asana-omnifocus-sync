use application "OmniFocus"
use O : script "omnifocus"
use json : script "json"

on run argv
	set taskId to (item 1 of argv)
	
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
				
				set json_dict to json's createDictWith({{"id", (id of theTask)}, {"name", (name of theTask)}, {"completed", (completed of theTask)}, {"due_on", (due date of theTask as string)}, {"notes", (note of theTask)}, {"created", (creation date of theTask as string)}, {"modified", (modification date of theTask as string)}})
				
				return json's encode(json_dict)
				
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
				
				set json_dict to json's createDictWith({{"id", (id of theTask)}, {"name", (name of theTask)}, {"completed", (completed of theTask)}, {"due_on", (due date of theTask as string)}, {"notes", (note of theTask)}, {"created", (creation date of theTask as string)}, {"modified", (modification date of theTask as string)}})
				
				return json's encode(json_dict)
				
				exit repeat
			end if
		end repeat
		
	end tell
end run