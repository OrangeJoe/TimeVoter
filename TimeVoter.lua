PLUGIN.Title = "TimeVoter"
PLUGIN.Description = "Vote to skip night"
PLUGIN.Version = "1.0"
PLUGIN.Author = "Orange Joe"

function PLUGIN:Init()
	print( "Plugin: " .. self.Title .. " Ver. " .. self.Version )
	flags_plugin = plugins.Find("flags")
	if (not flags_plugin) then
		error("FLAGS PLUGIN REQUIRED ! Please visit the Oxide forums to get the Flags Plugin.")
		return
	end
	self:AddChatCommand( "vtime", self.cmdVoteTimer)
	self:AddChatCommand( "vday", self.cmdVoteDay)
	self:AddChatCommand( "vnight", self.cmdVoteNight)
	self:TimersDestroy()
	self.Voted = {}
	ReqVotes = 10
	DayTally = 0 
end

local ReqVotes = 10
local DayTally = 0

function PLUGIN:cmdVoteDay(netuser, cmd)
	local tme = Rust.EnvironmentControlCenter.Singleton:GetTime()
	if tme >= tonumber(20.00) then
		local Tally = DayTally
		Tally = Tally + 1
		DayTally = Tally
		rust.BroadcastChat("=TIMEVOTER=", "A VOTE HAS BEEN CASTED FOR DAY !")
		rust.BroadcastChat("=TIMEVOTER=", "VOTE(S) FOR DAY: " ..DayTally.. " [ " ..ReqVotes.. " ] VOTES TO PASS !")
		timer.Once(300, function() self:cmdVoteDay() end )
		if DayTally >= ReqVotes then
			rust.RunServerCommand("env.time 6")
			rust.BroadcastChat("=TIMEVOTER=", "VOTE PASSED, NIGHT WILL BE SKIPPED !")
			DayTally = 0			
		end
	else
		rust.SendChatToUser( netuser, "=TIMEVOTER=", "POLLS OPEN FROM 20.00 - 0.00 Hrs !")
	end
end

function PLUGIN:cmdVoteNight(netuser, cmd)
	local tme = Rust.EnvironmentControlCenter.Singleton:GetTime()
	if tme >= tonumber(20.00) then
		local Tally = DayTally
		Tally = Tally - 1
		DayTally = Tally
		rust.BroadcastChat("=TIMEVOTER=", "A VOTE HAS BEEN CASTED FOR NIGHT !")
		rust.BroadcastChat("=TIMEVOTER=", "VOTE(S) FOR DAY: " ..DayTally.. " [ " ..ReqVotes.. " ] VOTES TO PASS !")
		timer.Once(300, function() self:cmdVoteNight() end )
	else
		rust.SendChatToUser( netuser, "=TIMEVOTER=", "POLLS OPEN FROM 20.00 - 0.00 Hrs !")
	end
end

function PLUGIN:cmdVoteTimer(netuser, cmd)
	rust.SendChatToUser( netuser, "=TIMEVOTER=", "======== VOTING BEGINS AT 20.00 Hrs ========")
	rust.SendChatToUser( netuser, "=TIMEVOTER=", "/vday   | To cast a day tally.")
	rust.SendChatToUser( netuser, "=TIMEVOTER=", "/vnight | To void a day tally.")
	rust.SendChatToUser( netuser, "=TIMEVOTER=", "ONE VOTE PER PLAYER | " ..ReqVotes.. " REQUIRED VOTES TO PASS")	
end

function PLUGIN:SendHelpText( netuser )
	rust.SendChatToUser( netuser, "/vtime | Displays info about day/night voting.")
end
