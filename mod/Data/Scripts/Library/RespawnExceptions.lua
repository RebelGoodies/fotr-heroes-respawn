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

		"Onara_Kuat_Pride_of_the_Core", --Mandator_II_Dreadnought 155
		"Sanya_Tagge_Battlecruiser", --Tagge_Battlecruiser 70
		"Orman_Tagge_Battlecruiser", --Tagge_Battlecruiser 70
		--"Kuat_of_Kuat_Procurator", --Procurator_Battlecruiser 37
	},
	["REBEL"] = {--CIS
		--"Dooku_Team",
		--"Durge_Team",
		--"Grievous_Team",
		--"Trench_Invincible", --Providence_Dreadnought 43
		--"Trench_Invulnerable", --Providence_Dreadnought 43
		
		"Krett_Lucrehulk_Battleship", --Lucrehulk_Battleship 101
		"Merai_Free_Dac", --Lucrehulk_Auxiliary 53
		"Doctor_Instinction", --Lucrehulk_Carrier 87
		"Tonith_Corpulentus", --Lucrehulk_Carrier_Control 86
		"Tuuk_Procurer", --Lucrehulk_Carrier_Control 86
		"Sai_Sircu_Devastation", --Devastation 107
		"Shu_Mai_Subjugator", -- Subjugator 103
		"Grievous_Malevolence", -- Subjugator 103
		"Grievous_Malevolence_2", -- Subjugator 103
		
		"Pundar_Profit", --Lucrehulk_Auxiliary 53 (Pirate Legend)
	},
	["HUTT_CARTELS"] = {
		"Pundar_Profit", --Lucrehulk_Auxiliary 53 (Pirate Legend)
	},
	["INDEPENDENT_FORCES"] = {
		"Hondo_Ohnaka_Team",
		"Gevtes_Team",
		"Keek_Team",
		"Holchas_Team",

		--Jedi Rebellion
		"Cin_Drallig_Team",
		"Serra_Keto_Team",
		"Jocasta_Nu_Team",
		"Laddinare_Torbin_Team",

		--Jedi Hideouts
		"Obi_Wan_Delta_Team", "Obi_Wan_Eta_Team",
		"Yoda_Delta_Team", "Yoda_Eta_Team",
		"Ahsoka_Delta_Team", "Ahsoka_Eta_Team",
		"Luminara_Unduli_Delta_Team", "Luminara_Unduli_Eta_Team",
		"Barriss_Offee_Delta_Team", "Barriss_Offee_Eta_Team",
		"Shaak_Ti_Delta_Team", "Shaak_Ti_Eta_Team",
		"Rahm_Kota_Team",
	},
}