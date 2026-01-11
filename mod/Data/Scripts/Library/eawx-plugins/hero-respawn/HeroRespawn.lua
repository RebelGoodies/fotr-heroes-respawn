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
--*       Last Modified:     After Monday, 24th February 2020 02:34                                *
--*       Modified By:       Not [TR] Jorritkarwehr                                                *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("PGSpawnUnits")
require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("PGDebug")
require("SetFighterResearch")

HeroRespawn = class()

function HeroRespawn:new(herokilled_finished_event, human_player, gc)
    self.human_player = human_player
    herokilled_finished_event:attach_listener(self.on_galactic_hero_killed, self)
	gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)

	crossplot:subscribe("ORDER_66_EXECUTED", self.Order_66_Handler, self)
	
	self.respawn_exceptions = require("RespawnExceptions")
	self.durge_chance = 105
	self.dooku_died = false
end

function HeroRespawn:on_galactic_hero_killed(hero_name, owner)
    --Logger:trace("entering HeroRespawn:on_galactic_hero_killed")
	local spawned = false
	if hero_name == "GRIEVOUS_TEAM_RECUSANT" then
		spawned = self:spawn_grievous("Grievous_Team_Munificent","GRIEVOUS_RESPAWN_MUNIFICENT", hero_name)
		Transfer_Fighter_Hero("GRIEVOUS_RECUSANT", "GRIEVOUS_MUNIFICENT")
    elseif hero_name == "GRIEVOUS_TEAM" then
		spawned = self:spawn_grievous("Grievous_Team_Munificent","GRIEVOUS_RESPAWN_MUNIFICENT", hero_name)
		Transfer_Fighter_Hero("INVISIBLE_HAND", "GRIEVOUS_MUNIFICENT")
	elseif hero_name == "GRIEVOUS_TEAM_MALEVOLENCE" then
		spawned = self:spawn_grievous("Grievous_Team","GRIEVOUS_RESPAWN_INVISIBLE_HAND", hero_name)
		Transfer_Fighter_Hero("GRIEVOUS_MALEVOLENCE", "INVISIBLE_HAND")
	elseif hero_name == "GRIEVOUS_TEAM_MALEVOLENCE_2" then
		spawned = self:spawn_grievous("Grievous_Team_Recusant","GRIEVOUS_RESPAWN_RECUSANT", hero_name)
		Transfer_Fighter_Hero("GRIEVOUS_MALEVOLENCE_2", "GRIEVOUS_RECUSANT")
	elseif hero_name == "GRIEVOUS_MUNIFICENT_GROUND" then
		GlobalValue.Set("GRIEVOUS_DEAD", true)
	elseif hero_name == "DURGE_TEAM" then
		spawned = self:check_durge()
	elseif hero_name == "DOOKU_TEAM" then
		spawned = self:check_dooku_doppelganger()
	elseif hero_name == "YULAREN_RESOLUTE" then
		spawned = self:spawn_yularen("Yularen_Integrity", hero_name)
	elseif hero_name == "YULAREN_INVINCIBLE" then
		spawned = self:spawn_yularen("Yularen_Integrity", hero_name)
	elseif hero_name == "TRENCH_INVINCIBLE" then
		spawned = self:start_cyber_trench_countdown()
	elseif hero_name == "ZOZRIDOR_SLAYKE_CARRACK" then
		spawned = self:slaykes_second_chance()
	end
	
	if not spawned then
		if self.respawn_exceptions[owner] then
			for _, hero_team in pairs(self.respawn_exceptions[owner]) do
				if string.upper(hero_team) == hero_name then
					StoryUtil.ShowScreenText("%s will not return.", 7, hero_name, {r = 244, g = 160, b = 0})
					self:remove_duplicate(string.upper(hero_team))
					break
				end
			end
		end
	end
end

function HeroRespawn:on_production_finished(planet, object_type_name, owner)
	if object_type_name == "OPTION_INCREASE_REP_STAFF" then
		StoryUtil.ShowScreenText("Staff Slots Increased", 3, nil, {r = 40, g = 222, b = 40})
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", {-2,-1,-1,-1,-1,-1}, 0)
	end
end

function HeroRespawn:remove_duplicate(hero_team)
	--Logger:trace("entering HeroRespawn:remove_duplicate "..hero_team)
	local plot = Get_Story_Plot("Conquests\\Story_Sandbox_Government_CIS.xml")
    if plot then
		local removeEvent = plot.Get_Event("Remove_Hero")
		if removeEvent then
			removeEvent.Set_Reward_Parameter(0, hero_team)
			Story_Event("NOTIFY_REMOVE_HERO")
		else
			StoryUtil.ShowScreenText("DEBUG: HeroRespawn:remove_duplicate - removeEvent returned nil", 7, nil, {r = 244, g = 30, b = 100})
			Story_Event(hero_team.."_DUPLICATE")
		end
	else
		StoryUtil.ShowScreenText("DEBUG: HeroRespawn:remove_duplicate - plot returned nil", 7, nil, {r = 244, g = 30, b = 100})
	end
end

function HeroRespawn:Order_66_Handler()
	local despawn_list = require("DespawnListOrder66")
	for _, team in pairs(despawn_list) do
		self:remove_duplicate(team)
	end
end

function HeroRespawn:spawn_grievous(team, event, dead_team)
	--Logger:trace("entering HeroRespawn:spawn_grievous")

	local p_CIS = Find_Player("Rebel")
	local planet
	local capital = Find_First_Object("NewRep_Senate")
	if TestValid(capital) then
		planet = capital.Get_Planet_Location()
	end
	if not TestValid(planet) then
		planet = StoryUtil.FindFriendlyPlanet(p_CIS)
	end
	if not StoryUtil.CheckFriendlyPlanet(planet,p_CIS) then
		planet = StoryUtil.FindFriendlyPlanet(p_CIS)
	end
	if planet then
		if dead_team then
			self:remove_duplicate(dead_team)
		end
		GlobalValue.Set("GRIEVOUS_DEAD", false)
		SpawnList({team}, planet, p_CIS, true, false)
		Story_Event(event)
		return true
	end
	return false
end

function HeroRespawn:spawn_yularen(team, dead_team)
	--Logger:trace("entering HeroRespawn:spawn_yularen")

	local p_republic = Find_Player("Empire")
	local planet
	local capital = Find_First_Object("Remnant_Capital")
	if TestValid(capital) then
		planet = capital.Get_Planet_Location()
	end
	if not TestValid(planet) then
		planet = StoryUtil.FindFriendlyPlanet(p_republic)
	end
	if not StoryUtil.CheckFriendlyPlanet(planet,p_republic) then
		planet = StoryUtil.FindFriendlyPlanet(p_republic)
	end
	if planet then
		if dead_team then
			self:remove_duplicate(dead_team)
		end
		SpawnList({team}, planet, p_republic, true, false)
		if Find_Player("Empire").Is_Human() then
			StoryUtil.Multimedia("TEXT_SPEECH_YULAREN_RETURNS_INTEGRITY", 15, nil, "Piett_Loop", 0)
		end
		return true
	end
	return false
end

function HeroRespawn:check_durge()
	--Logger:trace("entering HeroRespawn:check_durge")

	local check = GameRandom(1, 100)
	if self.durge_chance >= check then
		local p_CIS = Find_Player("Rebel")
		local planet = StoryUtil.FindFriendlyPlanet(p_CIS)
		if planet then
			self:remove_duplicate("Durge_Team")
			SpawnList({"Durge_Team"}, planet, p_CIS, true, false)
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

function HeroRespawn:check_dooku_doppelganger()
	--Logger:trace("entering HeroRespawn:check_dooku_doppelganger")
	if self.dooku_died == false then
		local p_CIS = Find_Player("Rebel")
		local planet = StoryUtil.FindFriendlyPlanet(p_CIS)
		self:remove_duplicate("Dooku_Team")
		StoryUtil.SpawnAtSafePlanet("SERENNO", p_CIS, StoryUtil.GetSafePlanetTable(), {"Dooku_Team"})
		StoryUtil.Multimedia("TEXT_SPEECH_DOOKU_DOPPELGANGER_SPAWN", 15, nil, "Dooku_Loop", 0)
		self.dooku_died = true
	else
		self.dooku_died = false
	end
	return self.dooku_died
end

function HeroRespawn:slaykes_second_chance()
	--Logger:trace("entering HeroRespawn:slaykes_second_chance")
	local p_republic = Find_Player("Empire")
	local planet = StoryUtil.FindFriendlyPlanet(p_republic)
	self:remove_duplicate("Zozridor_Slayke_Carrack")
	StoryUtil.SpawnAtSafePlanet("ERIADU", p_republic, StoryUtil.GetSafePlanetTable(), {"Zozridor_Slayke_CR90"})
	return true
end

function HeroRespawn:start_cyber_trench_countdown()
	--Logger:trace("entering HeroRespawn:start_cyber_trench_countdown")
	--StoryUtil.ShowScreenText("Trench will return.", 7)
	Story_Event("START_TRENCH_COUNTDOWN")
	return true
end