require("deepcore/std/class")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")

---@class GenericSwap
GenericSwap = class()

---@param event_name string
---@param player string
---@param from_list string[]
---@param to_list string[]
function GenericSwap:new(event_name, player, from_list, to_list)
    --Logger:trace("entering GenericSwap:new")
 
    self.ForPlayer = Find_Player(player)

    self.Story_Tag = event_name

    self.From_List = from_list
    self.To_List = to_list

    crossplot:subscribe(self.Story_Tag, self.activate, self)
    
end

---@param hero_team string
function GenericSwap:force_hero_respawn(hero_team)
	local plot = Get_Story_Plot("Conquests\\Story_Sandbox_Government_CIS.xml")
    if plot then
		local respawnEvent = plot.Get_Event("Force_Respawn")
		if respawnEvent then
			respawnEvent.Set_Reward_Parameter(0, hero_team)
			Story_Event("NOTIFY_FORCE_RESPAWN_HERO")
		else
			StoryUtil.ShowScreenText("DEBUG: GenericSwap:force_hero_respawn - respawnEvent returned nil", 10, nil, {r = 244, g = 30, b = 100})
		end
	else
		StoryUtil.ShowScreenText("DEBUG: GenericSwap:force_hero_respawn - Plot returned nil", 10, nil, {r = 244, g = 30, b = 100})
	end
end

function GenericSwap:activate()
    --Logger:trace("entering GenericSwap:activate")
    for i, fromUnit in pairs(self.From_List) do
        local toUnit = self.To_List[i]
		if self.Story_Tag == "CLONE_UPGRADES" then
			-- So that they get phase2 upgrade
			self:force_hero_respawn(fromUnit .. "_Team")
		end
		UnitUtil.ReplaceAtLocation(fromUnit, toUnit)
    end
end

return GenericSwap
