require("PGStoryMode")
require("RandomGCSpawnCW")
require("deepcore/crossplot/crossplot")

function Definitions()

    DebugMessage("%s -- In Definitions", tostring(Script))
    StoryModeEvents = {
		Delayed_Initialize = Initialize
	}
	
end		

function Initialize(message)
    if message == OnEnter then
		crossplot:galactic()
		p_Republic = Find_Player("Empire")
		if p_Republic.Is_Human() then
			crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 10)
			crossplot:publish("REPUBLIC_MOFF_DECREMENT", 10)
		end
	else
		crossplot:update()
    end
end