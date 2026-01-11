require("deepcore/std/class")
require("PGSpawnUnits")
StoryUtil = require("eawx-util/StoryUtil")
UnitUtil = require("eawx-util/UnitUtil")

---@class GenericSwap
GenericSwap = class()

function GenericSwap:new(event_name, player, from_list, to_list)
    --Logger:trace("entering GenericSwap:new")
 
    self.ForPlayer = Find_Player(player)

    self.Story_Tag = event_name

    self.From_List = from_list
    self.To_List = to_list

    crossplot:subscribe(self.Story_Tag, self.activate, self)
    
end

function force_hero_respawn(hero_team)
	local plot = Get_Story_Plot("Conquests\\Story_Sandbox_Government_Rep.xml")
    if plot then
		local respawnEvent = plot.Get_Event("Force_Respawn")
		if respawnEvent then
			respawnEvent.Set_Reward_Parameter(0, hero_team)
			Story_Event("FORCE_RESPAWN_HERO")
		end
	end
end

function GenericSwap:activate()
    --Logger:trace("entering GenericSwap:activate")
    for i, fromUnit in pairs(self.From_List) do
        local toUnit = self.To_List[i]
		if self.Story_Tag == "CLONE_UPGRADES" then
			force_hero_respawn(fromUnit .. "_Team")
		end
		UnitUtil.ReplaceAtLocation(fromUnit, toUnit)
    end
end

return GenericSwap
