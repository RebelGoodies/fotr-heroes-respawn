return {
    on_enter = function(self, state_context)
        --Logger:trace("entering fotr-ftgu-era-three:on_enter")

        GlobalValue.Set("CURRENT_ERA", 3)

        self.entry_time = GetCurrentTime()

        crossplot:publish("VENATOR_RESEARCH_FINISHED", "empty")
		crossplot:publish("PHASE_TWO_RESEARCH_FINISHED", "empty")
        crossplot:publish("BULWARK_RESEARCH_FINISHED", "empty")
        crossplot:publish("VICTORY_RESEARCH_FINISHED", "empty")
    
    end,
    on_update = function(self, state_context)
    end,
    on_exit = function(self, state_context)
    end
}