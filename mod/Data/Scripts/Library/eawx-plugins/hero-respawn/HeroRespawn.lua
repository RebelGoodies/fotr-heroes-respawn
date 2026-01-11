--**************************************************************************************************
--*    _______ __                                                                                  *
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
--*     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
--*     |___| |__|__|__| |___._|________|__|__|_____|                                              *
--*    ______                                                                                      *
--*   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
--*   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
--*                                   |_____|                                                      *
--*                                                                                                *
--*                                                                                                *
--*       File:              HeroRespawn.lua                                                       *
--*       File Created:      Monday, 24th February 2020 02:19                                      *
--*       Author:            [TR] Jorritkarwehr                                                    *
--*       Last Modified:     After Monday, 24th February 2020 02:34                                      *
--*       Modified By:       Not [TR] Jorritkarwehr                                                             *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("PGSpawnUnits")
require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("PGDebug")
require("SetFighterResearch")

HeroRespawn = class()

---@param herokilled_finished_event GalacticHeroKilledEvent
---@param human_player PlayerObject
---@param gc GalacticConquest
function HeroRespawn:new(herokilled_finished_event, human_player, gc)
    gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
	gc.Events.GalacticHeroKilled:attach_listener(self.on_galactic_hero_killed, self)

	self.human_faction_name = human_player.Get_Faction_Name()
	self.p_CIS = Find_Player("Rebel")

	self.durge_chance = 105
	self.dooku_second_chance_used = false

	---@type table<string, string[]>
    self.respawn_exceptions = require("RespawnExceptions")

	self.human_respawn = true
	self.ai_respawn = true

	UnitUtil.SetLockList(self.human_faction_name, {"OPTION_RESPAWN_ON"}, not self.human_respawn)
	UnitUtil.SetLockList(self.human_faction_name, {"OPTION_RESPAWN_OFF"}, self.human_respawn)
	UnitUtil.SetLockList(self.human_faction_name, {"OPTION_AI_RESPAWN_ON"}, not self.ai_respawn)
	UnitUtil.SetLockList(self.human_faction_name, {"OPTION_AI_RESPAWN_OFF"}, self.ai_respawn)
end

---@param hero_name string
---@param owner string
function HeroRespawn:on_galactic_hero_killed(hero_name, owner)
    --Logger:trace("entering HeroRespawn:on_galactic_hero_killed")
	local has_spawned = false
    if hero_name == "GENERAL_GRIEVOUS" or hero_name == "GRIEVOUS_TEAM" then
        has_spawned = self:check_grievous()
    elseif hero_name == "GRIEVOUS_MUNIFICENT" then
        has_spawned = self:spawn_grievous("Grievous_Team","GRIEVOUS_RESPAWN_BELBULLAB", hero_name)
		UnitUtil.SetLockList("REBEL", {"Grievous_Reveal_Colicoid_Swarm", "Grievous_Reveal_Lucid_Voice"}, false)
        --todo: function to assign whatever hero may have been on Grievous_Munificent to next existent host ~Mord
    elseif hero_name == "GRIEVOUS_INVISIBLE_HAND" then
        has_spawned = self:spawn_grievous("Grievous_Munificent","GRIEVOUS_RESPAWN_MUNIFICENT", hero_name)
        Transfer_Fighter_Hero("GRIEVOUS_INVISIBLE_HAND", "GRIEVOUS_MUNIFICENT")
    elseif hero_name == "GRIEVOUS_RECUSANT" then
        has_spawned = self:spawn_grievous("Grievous_Munificent","GRIEVOUS_RESPAWN_MUNIFICENT", hero_name)
		Transfer_Fighter_Hero("GRIEVOUS_RECUSANT", "GRIEVOUS_MUNIFICENT")
    elseif hero_name == "GRIEVOUS_MALEVOLENCE" then
        has_spawned = self:spawn_grievous("Grievous_Invisible_Hand","GRIEVOUS_RESPAWN_PROVIDENCE", hero_name)
        Transfer_Fighter_Hero("GRIEVOUS_MALEVOLENCE", "GRIEVOUS_INVISIBLE_HAND")
    elseif hero_name == "GRIEVOUS_MALEVOLENCE_2" then
        has_spawned = self:spawn_grievous("Grievous_Recusant","GRIEVOUS_RESPAWN_RECUSANT", hero_name)
		Transfer_Fighter_Hero("GRIEVOUS_MALEVOLENCE_2", "GRIEVOUS_RECUSANT")

	elseif hero_name == "DURGE_TEAM" then
        has_spawned = self:check_durge()
	elseif hero_name == "DOOKU_TEAM" then
        has_spawned = self:check_dooku_doppelganger()
	elseif hero_name == "TRENCH_INVINCIBLE" then
        self:start_cyber_trench_countdown()
	elseif hero_name == "ZOZRIDOR_SLAYKE_CARRACK" then
        has_spawned = self:slaykes_second_chance()
	elseif hero_name == "ANAKIN_DARKSIDE_TEAM" then
        has_spawned = self:anakins_dark_suit()
	end

	if has_spawned then
		return
	end

	if owner == "INDEPENDENT_FORCES" or
		(self.human_faction_name == owner and self.human_respawn == false) or
		(self.human_faction_name ~= owner and self.ai_respawn == false)
	then
		StoryUtil.ShowScreenText("%s will not return.", 15, hero_name, {r = 244, g = 160, b = 0})
		self:remove_duplicate(hero_name)
		return
	end

    if self.respawn_exceptions[owner] then
        for _, hero_team in pairs(self.respawn_exceptions[owner]) do
            if string.upper(hero_team) == hero_name then
                StoryUtil.ShowScreenText("%s will not return.", 15, hero_name, {r = 244, g = 160, b = 0})
                self:remove_duplicate(hero_name)
                break
            end
        end
    end
end

---@return boolean has_spawned
function HeroRespawn:check_grievous()
    --Logger:trace("entering HeroRespawn:check_grievous")
	local has_spawned = false
    if TestValid(Find_First_Object("Grievous_Malevolence_2")) then
        Find_First_Object("Grievous_Malevolence_2").Despawn()
        has_spawned = self:spawn_grievous("Grievous_Recusant","GRIEVOUS_RESPAWN_RECUSANT")
        Transfer_Fighter_Hero("GRIEVOUS_MALEVOLENCE_2", "GRIEVOUS_RECUSANT")
    elseif TestValid(Find_First_Object("Grievous_Malevolence")) then
        Find_First_Object("Grievous_Malevolence").Despawn()
        has_spawned = self:spawn_grievous("Grievous_Invisible_Hand","GRIEVOUS_RESPAWN_PROVIDENCE")
        Transfer_Fighter_Hero("GRIEVOUS_MALEVOLENCE", "GRIEVOUS_INVISIBLE_HAND")
    elseif TestValid(Find_First_Object("Grievous_Invisible_Hand")) then
        Find_First_Object("Grievous_Invisible_Hand").Despawn()
        has_spawned = self:spawn_grievous("Grievous_Munificent","GRIEVOUS_RESPAWN_MUNIFICENT")
        Transfer_Fighter_Hero("GRIEVOUS_INVISIBLE_HAND", "GRIEVOUS_MUNIFICENT")
    elseif TestValid(Find_First_Object("Grievous_Recusant")) then
        Find_First_Object("Grievous_Recusant").Despawn()
        has_spawned = self:spawn_grievous("Grievous_Munificent","GRIEVOUS_RESPAWN_MUNIFICENT")
        Transfer_Fighter_Hero("GRIEVOUS_RECUSANT", "GRIEVOUS_MUNIFICENT")
    elseif TestValid(Find_First_Object("Grievous_Munificent")) then
        Find_First_Object("Grievous_Munificent").Despawn()
        has_spawned = self:spawn_grievous("Grievous_Team","GRIEVOUS_RESPAWN_BELBULLAB")
        --todo: function to assign whatever hero may have been on Grievous_Munificent to next existent host ~Mord
	else
        Story_Event("GRIEVOUS_DEAD")
	end
	return has_spawned
end

---@param team string
---@param event string
---@param dead_team? string
---@return boolean has_spawned
function HeroRespawn:spawn_grievous(team, event, dead_team)
	--Logger:trace("entering HeroRespawn:spawn_grievous")
	local respawn_grievous = StoryUtil.SpawnAtSafePlanet(nil, self.p_CIS, StoryUtil.GetSafePlanetTable(), {team}, nil, nil)
	if respawn_grievous then
		self:remove_duplicate(dead_team)
		Story_Event(event)
		return true
	else
		return false
	end
end

---@return boolean has_spawned
function HeroRespawn:check_durge()
	--Logger:trace("entering HeroRespawn:check_durge")

	local check = GameRandom(1, 100)
	if self.durge_chance >= check then
		local planet = StoryUtil.FindFriendlyPlanet(self.p_CIS)
		if planet then
			self:remove_duplicate("Durge_Team")
			SpawnList({"Durge_Team"}, planet, self.p_CIS, true, false)
			StoryUtil.Multimedia("TEXT_SPEECH_DURGE_RETURNS", 20, nil, "Durge_Loop", 0)
			self.durge_chance = self.durge_chance - 10
			StoryUtil.ShowScreenText("Revive chance: " .. tostring(self.durge_chance), 5)
			return true
		else
			StoryUtil.Multimedia("TEXT_SPEECH_DURGE_GONE", 20, nil, "Durge_Loop", 0)
			self.durge_chance = self.durge_chance + 5
		end
	else
		StoryUtil.Multimedia("TEXT_SPEECH_DURGE_GONE", 20, nil, "Durge_Loop", 0)
		self.durge_chance = self.durge_chance + 5
	end
	return false
end

---@return boolean has_spawned
function HeroRespawn:check_dooku_doppelganger()
	--Logger:trace("entering HeroRespawn:check_dooku_doppelganger")
	if self.dooku_second_chance_used == false then
		self.dooku_second_chance_used = true

		self:remove_duplicate("Dooku_Team")
		local respawn_dooku = StoryUtil.SpawnAtSafePlanet("SERENNO", self.p_CIS, StoryUtil.GetSafePlanetTable(), {"Dooku_Team"}, nil, nil)
		if respawn_dooku then
            StoryUtil.Multimedia("TEXT_SPEECH_DOOKU_DOPPELGANGER_SPAWN", 15, nil, "Dooku_Loop", 0)
			return true
        end
	else
		self.dooku_second_chance_used = false
	end
	return false
end

---@return boolean has_spawned
function HeroRespawn:slaykes_second_chance()
	--Logger:trace("entering HeroRespawn:slaykes_second_chance")
	local p_republic = Find_Player("Empire")
	local planet = StoryUtil.FindFriendlyPlanet(p_republic)
	self:remove_duplicate("Zozridor_Slayke_Carrack")
	respawn = StoryUtil.SpawnAtSafePlanet("ERIADU", p_republic, StoryUtil.GetSafePlanetTable(), {"Zozridor_Slayke_CR90"}, nil, nil)
	if respawn then
		return true
	else
		return false
	end
end

function HeroRespawn:start_cyber_trench_countdown()
	--Logger:trace("entering HeroRespawn:start_cyber_trench_countdown")
	
	-- Story_Event("TRENCH_COUNTDOWN_BEGINS")
	Story_Event("START_TRENCH_COUNTDOWN")
end

---@return boolean has_spawned
function HeroRespawn:anakins_dark_suit()
	--Logger:trace("entering HeroRespawn:anakins_dark_suit")
	local p_republic = Find_Player("Empire")
	local planet = StoryUtil.FindFriendlyPlanet(p_republic)
	self:remove_duplicate("Anakin_Darkside_Team")
	local respawn_anakin = StoryUtil.SpawnAtSafePlanet("CORUSCANT", p_republic, StoryUtil.GetSafePlanetTable(), {"Vader_Team"}, nil, nil)
	
	if respawn_anakin then
		StoryUtil.Multimedia("TEXT_SPEECH_DARTH_VADER_SPAWN", 15, nil, "Emperor_Loop", 0)
		return true
	else
		return false
	end
end

---Handle when options are built.
---@param planet Planet
---@param object_type_name string
function HeroRespawn:on_production_finished(planet, object_type_name)
	---Increase republic staff capacity
	if object_type_name == "OPTION_INCREASE_REP_STAFF" then
		StoryUtil.ShowScreenText("Staff Slots Increased", 3, nil, {r = 40, g = 222, b = 40})
		crossplot:publish("COMMAND_STAFF_DECREMENT", {-2,-1,-1,-1,-1,-1}, 0)

	elseif object_type_name == "OPTION_RESPAWN_ON" then
		self.human_respawn = true
		UnitUtil.SetLockList(self.human_faction_name, {"OPTION_RESPAWN_ON"}, false)
		UnitUtil.SetLockList(self.human_faction_name, {"OPTION_RESPAWN_OFF"})
		StoryUtil.ShowScreenText("Human Hero Respawns ENABLED", 6, nil, {r = 80, g = 244, b = 44})
	elseif object_type_name == "OPTION_RESPAWN_OFF" then
		self.human_respawn = false
		UnitUtil.SetLockList(self.human_faction_name, {"OPTION_RESPAWN_ON"})
		UnitUtil.SetLockList(self.human_faction_name, {"OPTION_RESPAWN_OFF"}, false)
		StoryUtil.ShowScreenText("Human Hero Respawns DISABLED", 6, nil, {r = 244, g = 120, b = 0})
	
	elseif object_type_name == "OPTION_AI_RESPAWN_ON" then
		self.ai_respawn = true
		UnitUtil.SetLockList(self.human_faction_name, {"OPTION_AI_RESPAWN_ON"}, false)
		UnitUtil.SetLockList(self.human_faction_name, {"OPTION_AI_RESPAWN_OFF"})
		StoryUtil.ShowScreenText("AI Hero Respawns ENABLED", 6, nil, {r = 80, g = 244, b = 44})
	elseif object_type_name == "OPTION_AI_RESPAWN_OFF" then
		self.ai_respawn = false
		UnitUtil.SetLockList(self.human_faction_name, {"OPTION_AI_RESPAWN_ON"})
		UnitUtil.SetLockList(self.human_faction_name, {"OPTION_AI_RESPAWN_OFF"}, false)
		StoryUtil.ShowScreenText("AI Hero Respawns DISABLED", 6, nil, {r = 244, g = 120, b = 0})
	end
end

---Uses a story plot and event to remove a hero unit
---@param hero_team string hero ship or team name in xml
function HeroRespawn:remove_duplicate(hero_team)
	--Logger:trace("entering HeroRespawn:remove_duplicate "..hero_team)
	if not hero_team then
		return
	end
	local plot = Get_Story_Plot("Conquests\\Story_Sandbox_Government_CIS.xml")
    if plot then
		local removeEvent = plot.Get_Event("Remove_Hero")
		if removeEvent then
			removeEvent.Set_Reward_Parameter(0, hero_team)
			Story_Event("NOTIFY_REMOVE_HERO")
		else
			StoryUtil.ShowScreenText("ERROR: HeroRespawn:remove_duplicate - removeEvent is nil", 7, nil, {r = 244, g = 30, b = 100})
			Story_Event(string.upper(hero_team).."_DUPLICATE")
		end
	else
		StoryUtil.ShowScreenText("ERROR: HeroRespawn:remove_duplicate - plot returned nil", 7, nil, {r = 244, g = 30, b = 100})
	end
end

---NOTE: Added to crossplot in init.lua
---Removes heroes defined in an order 66 despawn list
function HeroRespawn:Order_66_Handler()
	---@type string[]
	local despawn_list = require("DespawnListOrder66")
	for _, team in pairs(despawn_list) do
		self:remove_duplicate(team)
	end
end
