require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")

return {
    on_enter = function(self, state_context)
        --Logger:trace("entering fotr-ftgu-era-two:on_enter")

        GlobalValue.Set("CURRENT_ERA", 2)

        self.Active_Planets = StoryUtil.GetSafePlanetTable()
        self.entry_time = GetCurrentTime()
        --self.StaticFleets = false

        crossplot:publish("VENATOR_RESEARCH_FINISHED", "empty")
		
		if self.entry_time <= 5 then
            self.Starting_Spawns = require("eawx-mod-fotr/spawn-sets/FTGU_EraTwoStartSet")
			--self.Starting_Planets = require("eawx-mod-fotr/spawn-sets/FTGU_StartingPlanets")
			
            for faction, spawnlist in pairs(self.Starting_Spawns) do
                local player = Find_Player(faction)
				
				for planet, herolist in pairs(spawnlist) do
					if player.Is_Human() then
						-- Human player only starts with one planet
						StoryUtil.SpawnAtSafePlanet(planet, player, self.Active_Planets, herolist)
					else
						-- Spawn AI heroes randomly on owned planets
						for _, hero in pairs(herolist) do
							--local sp_fac = self.Starting_Planets[faction]
							--local randomIndex = GameRandom.Free_Random(1,table.getn(sp_fac))
							--local planet = sp_fac[randomIndex]
							StoryUtil.SpawnAtSafePlanet(planet, player, self.Active_Planets, {hero})
						end
					end
                end
            end
        end
    end,
    on_update = function(self, state_context)
    end,
    on_exit = function(self, state_context)
    end
}