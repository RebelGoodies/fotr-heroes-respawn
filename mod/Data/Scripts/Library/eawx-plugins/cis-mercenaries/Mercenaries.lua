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
--*       File:              Mercenaries.lua                                                     *
--*       File Created:      Monday, 24th February 2020 02:19                                      *
--*       Author:            [TR] Kiwi                                                             *
--*       Last Modified:     Friday, 9th April 2021 21:16                                      *
--*       Modified By:       [TR] Kiwi                                                             *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/class")
require("eawx-util/StoryUtil")

Mercenaries = class()

function Mercenaries:new(gc)
    --Table With mercenaries
	self.original_list = {
        "BOSSK_TEAM",
        "DENGAR_TEAM",
		"FARO_ARGYUS_TEAM",
		"VAZUS_TEAM",
		"SHAHAN_ALAMA_TEAM"
    }
	self.MercenaryHeroes = {}
	for index, entry in pairs(self.original_list) do
		self.MercenaryHeroes[index] = entry
	end
	self.num_died = 0
    self.PossibleRecruiters = {
        "Rebel"
    }
    --galactic_conquest class
    self.gc = gc
    --attach listener to production finished event
    self.gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
	self.gc.Events.GalacticHeroKilled:attach_listener(self.on_galactic_hero_killed, self)
end

function Mercenaries:on_production_finished(planet, object_type_name)
    --Logger:trace("entering Mercenaries:on_production_finished")
    if object_type_name ~= "RANDOM_MERCENARY" then
        return
    end
    --Grab Object Type for Random Mercenary dummy
    local RandomMercenary = Find_First_Object("Random_Mercenary")
    
	if TestValid(RandomMercenary) then
		if table.getn(self.MercenaryHeroes) < 1 then --Something broke
			self.num_died = 0
			for index, entry in pairs(self.original_list) do
				self.MercenaryHeroes[index] = entry
			end
		end
		--Grabs random array index for mercenary table
		local mercenaryIndex = GameRandom.Free_Random(1,table.getn(self.MercenaryHeroes))
		--Grab selected mercenary via random index
		local mercenary_to_spawn = self.MercenaryHeroes[mercenaryIndex]
		--Grab Owner and Location of random mercenary dummy
		local MercenaryOwner = RandomMercenary.Get_Owner()
		local MercenaryLocation = RandomMercenary.Get_Planet_Location()
		--Grab Object type for selected mercenary
		local MercenaryUnit = Find_Object_Type(mercenary_to_spawn)
		--Spawn Mercenary at location of mercenary dummy for mercenary owner
		Spawn_Unit(MercenaryUnit, MercenaryLocation, MercenaryOwner)
		table.remove(self.MercenaryHeroes, mercenaryIndex)
		RandomMercenary.Despawn()
		if table.getn(self.MercenaryHeroes) == 0 then
			StoryUtil.ShowScreenText("All Mercenaries have been hired.", 7, nil, {r = 244, g = 200, b = 0})
			for _, faction in pairs(self.PossibleRecruiters) do
				Find_Player(faction).Lock_Tech(Find_Object_Type("RANDOM_MERCENARY"))
			end
		else
			MercenaryOwner.Lock_Tech(Find_Object_Type("RANDOM_MERCENARY"))
		end
	end
end

function Mercenaries:on_galactic_hero_killed(hero_name, owner)
	for _, entry in pairs(self.original_list) do
		if entry == hero_name then
			self.num_died = self.num_died + 1
			Story_Event(tostring(entry) .. "_DIED") --Signal to xml
			if self.num_died == table.getn(self.original_list) then
				self.num_died = 0
				for index, entry in pairs(self.original_list) do
					table.insert(self.MercenaryHeroes, entry)
				end
				for _, faction in pairs(self.PossibleRecruiters) do
					Find_Player(faction).Unlock_Tech(Find_Object_Type("RANDOM_MERCENARY"))
				end
			else
				Find_Player(owner).Unlock_Tech(Find_Object_Type("RANDOM_MERCENARY"))
			end
			StoryUtil.ShowScreenText("There are " .. table.getn(self.MercenaryHeroes) .. " Mercenaries available to hire.", 7, nil, {r = 244, g = 200, b = 0})
			break
		end
	end
end