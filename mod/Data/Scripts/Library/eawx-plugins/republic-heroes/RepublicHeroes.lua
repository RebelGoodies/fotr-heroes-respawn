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
--*       File:              RepublicHeroes.lua                                                     *
--*       File Created:      Monday, 24th February 2020 02:19                                      *
--*       Author:            [TR] Jorritkarwehr                                                             *
--*       Last Modified:     Monday, 24th February 2020 02:34                                      *
--*       Modified By:       [TR] Jorritkarwehr                                                             *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("PGStoryMode")
require("PGSpawnUnits")
require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("HeroSystem")
require("SetFighterResearch")

RepublicHeroes = class()

function RepublicHeroes:new(gc, herokilled_finished_event, human_player)
    self.human_player = human_player
    gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
	herokilled_finished_event:attach_listener(self.on_galactic_hero_killed, self)
	self.inited = false
	
	crossplot:subscribe("VENATOR_HEROES", self.Venator_Heroes, self)
	crossplot:subscribe("VENATOR_RESEARCH_FINISHED", self.Venator_Heroes, self)
	crossplot:subscribe("VICTORY_HEROES", self.VSD_Heroes, self)
	crossplot:subscribe("VICTORY_RESEARCH_FINISHED", self.VSD_Heroes, self)
	crossplot:subscribe("ORDER_66_EXECUTED", self.Order_66_Handler, self)
	crossplot:subscribe("ERA_THREE_TRANSITION", self.Era_3, self)
	crossplot:subscribe("ERA_FOUR_TRANSITION", self.Era_4, self)
	crossplot:subscribe("REPUBLIC_ADMIRAL_DECREMENT", self.admiral_decrement, self)
	crossplot:subscribe("REPUBLIC_MOFF_DECREMENT", self.moff_decrement, self)
	crossplot:subscribe("REPUBLIC_ADMIRAL_LOCKIN", self.admiral_lockin, self)
	crossplot:subscribe("REPUBLIC_MOFF_LOCKIN", self.moff_lockin, self)
	
	admiral_data = {
		total_slots = 3,			--Max slot number. Set at the start of the GC and never change
		free_hero_slots = 3,		--Slots open to buy
		vacant_hero_slots = 0,	--Slots that need another action to move to free
		initialized = false,
		full_list = { --All options for reference operations
			["Yularen"] = {"YULAREN_ASSIGN",{"YULAREN_RETIRE","YULAREN_RETIRE2"},{"YULAREN_RESOLUTE","YULAREN_INTEGRITY"},"TEXT_HERO_YULAREN"},
			["Wieler"] = {"WIELER_ASSIGN",{"WIELER_RETIRE"},{"WIELER_RESILIENT"},"TEXT_HERO_WIELER"},
			["Coburn"] = {"COBURN_ASSIGN",{"COBURN_RETIRE"},{"COBURN_TRIUMPHANT"},"TEXT_HERO_COBURN"},
			["Kilian"] = {"KILIAN_ASSIGN",{"KILIAN_RETIRE"},{"KILIAN_ENDURANCE"},"TEXT_HERO_KILIAN"},
			["Dao"] = {"DAO_ASSIGN",{"DAO_RETIRE"},{"DAO_VENATOR"},"TEXT_HERO_DAO"},
			["Denimoor"] = {"DENIMOOR_ASSIGN",{"DENIMOOR_RETIRE"},{"DENIMOOR_TENACIOUS"},"TEXT_HERO_DENIMOOR"},
			["Dron"] = {"DRON_ASSIGN",{"DRON_RETIRE"},{"DRON_VENATOR"},"TEXT_HERO_DRON"},
			["Screed"] = {"SCREED_ASSIGN",{"SCREED_RETIRE"},{"SCREED_ARLIONNE"},"TEXT_HERO_SCREED_FOTR"},
			["Dodonna"] = {"DODONNA_ASSIGN",{"DODONNA_RETIRE"},{"DODONNA_ARDENT"},"TEXT_HERO_DODONNA"},
			["Pellaeon"] = {"PELLAEON_ASSIGN",{"PELLAEON_RETIRE"},{"PELLAEON_LEVELER"},"TEXT_HERO_PELLAEON"},
			["Tallon"] = {"TALLON_ASSIGN",{"TALLON_RETIRE", "TALLON_RETIRE2"},{"TALLON_SUNDIVER", "TALLON_BATTALION"},"TEXT_HERO_TALLON"},
			["Dallin"] = {"DALLIN_ASSIGN",{"DALLIN_RETIRE"},{"DALLIN_KEBIR"},"TEXT_HERO_DALLIN"},
			["Autem"] = {"AUTEM_ASSIGN",{"AUTEM_RETIRE"},{"AUTEM_VENATOR"},"TEXT_HERO_AUTEM"},
			["Forral"] = {"FORRAL_ASSIGN",{"FORRAL_RETIRE"},{"FORRAL_VENSENOR"},"TEXT_HERO_FORRAL"},
			["Maarisa"] = {"MAARISA_ASSIGN",{"MAARISA_RETIRE", "MAARISA_RETIRE2"},{"MAARISA_CAPTOR", "MAARISA_RETALIATION"},"TEXT_HERO_MAARISA"},
			["Grumby"] = {"GRUMBY_ASSIGN",{"GRUMBY_RETIRE"},{"GRUMBY_INVINCIBLE"},"TEXT_UNIT_GRUMBY"},
			["Baraka"] = {"BARAKA_ASSIGN",{"BARAKA_RETIRE"},{"BARAKA_NEXU"},"TEXT_HERO_BARAKA"},
			["Martz"] = {"MARTZ_ASSIGN",{"MARTZ_RETIRE"},{"MARTZ_PROSECUTOR"},"TEXT_HERO_MARTZ"},
		},
		available_list = {--Heroes currently available for purchase. Seeded with those who have no special prereqs
			"Dallin",
			"Maarisa",
			"Grumby",
		},
		story_locked_list = {},--Heroes not accessible, but able to return with the right conditions
		active_player = Find_Player("Empire"),
		extra_name = "EXTRA_ADMIRAL_SLOT",
		random_name = "RANDOM_ADMIRAL_ASSIGN",
		global_display_list = "REP_ADMIRAL_LIST" --Name of global array used for documention of currently active heroes
	}
	
	moff_data = {
		total_slots = 1,			--Max slot number. Set at the start of the GC and never change
		free_hero_slots = 1,		--Slots open to buy
		vacant_hero_slots = 0,	--Slots that need another action to move to free
		initialized = false,
		full_list = { --All options for reference operations
			["Tarkin"] = {"TARKIN_ASSIGN",{"TARKIN_RETIRE","TARKIN_RETIRE2"},{"TARKIN_VENATOR","TARKIN_EXECUTRIX"},"TEXT_HERO_TARKIN"},
			["Trachta"] = {"TRACHTA_ASSIGN",{"TRACHTA_RETIRE"},{"TRACHTA_VENATOR"},"TEXT_HERO_TRACHTA"},
			["Wessex"] = {"WESSEX_ASSIGN",{"WESSEX_RETIRE"},{"WESSEX_REDOUBT"},"TEXT_HERO_DEN_WESSEX"},
			["Grant"] = {"GRANT_ASSIGN",{"GRANT_RETIRE"},{"GRANT_VENATOR"},"TEXT_HERO_GRANT"},
			["Vorru"] = {"VORRU_ASSIGN",{"VORRU_RETIRE"},{"VORRU_VENATOR"},"TEXT_HERO_VORRU"},
			["Hauser"] = {"HAUSER_ASSIGN",{"HAUSER_RETIRE"},{"HAUSER_DREADNAUGHT"},"TEXT_HERO_HAUSER"},
			["Wessel"] = {"WESSEL_ASSIGN",{"WESSEL_RETIRE"},{"WESSEL_ACCLAMATOR"},"TEXT_HERO_WESSEL"},
			["Seerdon"] = {"SEERDON_ASSIGN",{"SEERDON_RETIRE"},{"SEERDON_INVINCIBLE"},"TEXT_HERO_SEERDON"},			
			["Praji"] = {"PRAJI_ASSIGN",{"PRAJI_RETIRE"},{"PRAJI_VALORUM"},"TEXT_HERO_COLLIN_PRAJI"},
			["Ravik"] = {"RAVIK_ASSIGN",{"RAVIK_RETIRE"},{"RAVIK_VICTORY"},"TEXT_HERO_RAVIK"},			
		},
		available_list = {--Heroes currently available for purchase. Seeded with those who have no special prereqs
			"Hauser",
			"Wessel",
			"Seerdon",			
			--"Coy",
		},
		story_locked_list = {},--Heroes not accessible, but able to return with the right conditions
		active_player = Find_Player("Empire"),
		extra_name = "EXTRA_MOFF_SLOT",
		random_name = "RANDOM_MOFF_ASSIGN",
		global_display_list = "REP_MOFF_LIST" --Name of global array used for documention of currently active heroes
	}
	
	Autem_Checks = 0
	Trachta_Checks = 0
end

function RepublicHeroes:on_production_finished(planet, object_type_name)--object_type_name, owner)
	--Logger:trace("entering RepublicHeroes:on_production_finished")
	if not self.inited then
		self.inited = true
		self:init_heroes()
	end
	Handle_Build_Options(object_type_name, admiral_data)
	Handle_Build_Options(object_type_name, moff_data)
end

function RepublicHeroes:init_heroes()
	--Logger:trace("entering RepublicHeroes:init_heroes")
	init_hero_system(admiral_data)
	init_hero_system(moff_data)
	
	Set_Fighter_Hero("IMA_GUN_DI_DELTA","DAO_VENATOR")
	
	local tech_level = admiral_data.active_player.Get_Tech_Level()
	
	--Handle special actions for starting tech level
	if tech_level > 1 then
		Handle_Hero_Add("Tallon", admiral_data)
		Handle_Hero_Add("Pellaeon", admiral_data)
		Handle_Hero_Add("Baraka", admiral_data)
	end
	
	if tech_level == 2 then
		Handle_Hero_Add("Martz", admiral_data)
	end
	
	if tech_level > 2 then
		Handle_Hero_Exit("Dao", admiral_data)
		Handle_Hero_Add("Autem", admiral_data)
		set_unit_index("Maarisa", 2, admiral_data)
		Trachta_Checks = 1
	end
	
	if tech_level > 3 then
		Handle_Hero_Add("Trachta", moff_data)
	end
end

--Era transitions
function RepublicHeroes:Era_3()
	--Logger:trace("entering RepublicHeroes:Era_3")
	Autem_Check()
end

function RepublicHeroes:Era_4()
	--Logger:trace("entering RepublicHeroes:Era_4")
	Trachta_Check()
end

function RepublicHeroes:admiral_decrement(quantity)
	--Logger:trace("entering RepublicHeroes:admiral_decrement")
	Decrement_Hero_Amount(quantity, admiral_data)
end

function RepublicHeroes:moff_decrement(quantity)
	--Logger:trace("entering RepublicHeroes:e")
	Decrement_Hero_Amount(quantity, moff_data)
end

function RepublicHeroes:admiral_lockin(list)
	--Logger:trace("entering RepublicHeroes:admiral_lockin")
	lock_retires(list, admiral_data)
end

function RepublicHeroes:moff_lockin(list)
	--Logger:trace("entering RepublicHeroes:moff_lockin")
	lock_retires(list, moff_data)
end

function RepublicHeroes:on_galactic_hero_killed(hero_name, owner)
	--Logger:trace("entering RepublicHeroes:on_galactic_hero_killed")
	Handle_Hero_Killed(hero_name, owner, admiral_data)
	Handle_Hero_Killed(hero_name, owner, moff_data)
end

function RepublicHeroes:Venator_Heroes()
	--Logger:trace("entering RepublicHeroes:Venator_Heroes")
	Handle_Hero_Add("Yularen", admiral_data)
	Handle_Hero_Add("Wieler", admiral_data)
	Handle_Hero_Add("Coburn", admiral_data)
	Handle_Hero_Add("Kilian", admiral_data)
	Handle_Hero_Add("Dao", admiral_data)
	Handle_Hero_Add("Denimoor", admiral_data)
	Handle_Hero_Add("Dron", admiral_data)
	Handle_Hero_Add("Forral", admiral_data)
	Handle_Hero_Add("Tarkin", moff_data)
	Handle_Hero_Add("Wessex", moff_data)
	Handle_Hero_Add("Grant", moff_data)
	Handle_Hero_Add("Vorru", moff_data)	
	
	local upgrade_unit = Find_Object_Type("Maarisa_Retaliation_Upgrade")
	admiral_data.active_player.Unlock_Tech(upgrade_unit)
	
	Autem_Check()
	Trachta_Check()
end

function Autem_Check()
	--Logger:trace("entering RepublicHeroes:Autem_Check")
	Autem_Checks = Autem_Checks + 1
	if Autem_Checks == 2 then
		Handle_Hero_Add("Autem", admiral_data)
	end
end

function Trachta_Check()
	--Logger:trace("entering RepublicHeroes:Trachta_Check")
	Trachta_Checks = Trachta_Checks + 1
	if Trachta_Checks == 2 then
		Handle_Hero_Add("Trachta", moff_data)
	end
end

function RepublicHeroes:VSD_Heroes()
	--Logger:trace("entering RepublicHeroes:VSD_Heroes")
	Handle_Hero_Add("Dodonna", admiral_data)
	Handle_Hero_Add("Screed", admiral_data)
	Handle_Hero_Add("Praji", moff_data)
	Handle_Hero_Add("Ravik", moff_data)
end

function RepublicHeroes:Order_66_Handler()
	--Logger:trace("entering RepublicHeroes:Order_66_Handler")
	Handle_Hero_Exit("Autem", admiral_data)
	Handle_Hero_Exit("Dallin", admiral_data)
	Clear_Fighter_Hero("IMA_GUN_DI_DELTA")
end