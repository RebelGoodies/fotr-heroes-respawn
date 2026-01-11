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
--*       File:              HeroRespawn.lua                                                     *
--*       File Created:      Monday, 24th February 2020 02:19                                      *
--*       Author:            [TR] Jorritkarwehr                                                             *
--*       Last Modified:     Monday, 24th February 2020 02:34                                      *
--*       Modified By:       [TR] Jorritkarwehr                                                             *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("PGSpawnUnits")
require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("PGDebug")

HeroRespawn = class()

function HeroRespawn:new(herokilled_finished_event, human_player)
    self.human_player = human_player
    herokilled_finished_event:attach_listener(self.on_galactic_hero_killed, self)
	self.durge_chance = 105
end

function HeroRespawn:on_galactic_hero_killed(hero_name, owner)
    --Logger:trace("entering HeroRespawn:on_galactic_hero_killed")
	
	if hero_name == "GRIEVOUS_TEAM_RECUSANT" then
		self:spawn_grievous("Grievous_Team_Munificent","GRIEVOUS_RESPAWN_MUNIFICENT")
    elseif hero_name == "GRIEVOUS_TEAM" then
		self:spawn_grievous("Grievous_Team_Munificent","GRIEVOUS_RESPAWN_MUNIFICENT")
	elseif hero_name == "GRIEVOUS_TEAM_MALEVOLENCE" then
		self:spawn_grievous("Grievous_Team","GRIEVOUS_RESPAWN_INVISIBLE_HAND")
	elseif hero_name == "GRIEVOUS_TEAM_MALEVOLENCE_2" then
		self:spawn_grievous("Grievous_Team_Recusant","GRIEVOUS_RESPAWN_RECUSANT")
	elseif hero_name == "DURGE_TEAM" then
		self:check_durge()
	elseif hero_name == "TRENCH_INVINCIBLE" then
		self:start_cyber_trench_countdown()
	end
end

function HeroRespawn:spawn_grievous(team, event)
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
		SpawnList({team}, planet, p_CIS, true, false)
		Story_Event(event)
	end
end

function HeroRespawn:check_durge()
	--Logger:trace("entering HeroRespawn:check_durge")

	local check = GameRandom(1, 100)
	if self.durge_chance >= check then
		local p_CIS = Find_Player("Rebel")
		local planet = StoryUtil.FindFriendlyPlanet(p_CIS)
		if planet then
			SpawnList({"Durge_Team"}, planet, p_CIS, true, false)
			Story_Event("DURGE_RESPAWNS")
			self.durge_chance = self.durge_chance - 10
			StoryUtil.ShowScreenText("Revive chance: " .. tostring(self.durge_chance), 5)
		else
			Story_Event("DURGE_GONE")
		end
	else
		Story_Event("DURGE_GONE")
	end
end

function HeroRespawn:start_cyber_trench_countdown()
	--Logger:trace("entering HeroRespawn:start_cyber_trench_countdown")
	
	Story_Event("TRENCH_COUNTDOWN_BEGINS")
end