-- If you edit this file, save a backup copy incase your changes get overwritten.
-- Changes don't affect saved games, only new ones.
--
-- Default special respawns will happen regardless of what's in the list below.
-- These heroes like Durge and Grievous are commented (--) below in case you want
-- them to perminately die after thier special respawn(s). Remove -- if you do.
--
--For space heroes,  use the hero ship
--For ground heroes, use the Team variant
--For ground+space,  use the Team variant
return {
	["EMPIRE"] = {--Republic
		--"Yularen_Integrity",
		--"Zozridor_Slayke_CR90",
	},
	["REBEL"] = {--CIS
		--"Dooku_Team",
		--"Durge_Team",
		--"Grievous_Munificent_Ground",
		--"Trench_Invulnerable",
		
		"Tonith_Corpulentus", --Generic_Lucrehulk_Control
		"Tuuk_Procurer", --Generic_Lucrehulk_Control
		"Merai_Free_Dac", --Auxiliary_Lucrehulk
		"Doctor_Instinction", --Generic_Lucrehulk
		"Vetlya_Core_Destroyer", --Lucrehulk_Core_Destroyer
		
		"Pundar_Profit", --Auxiliary_Lucrehulk (Pirate Legend)
	},
	["HUTT_CARTELS"] = {
		"Pundar_Profit", --Auxiliary_Lucrehulk (Pirate Legend)
	},
	["INDEPENDENT_FORCES"] = {
		--"Hondo_Ohnaka_Team",
	},
}