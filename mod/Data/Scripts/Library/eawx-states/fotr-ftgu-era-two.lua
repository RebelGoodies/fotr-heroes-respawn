return {
    on_enter = function(self, state_context)
        --Logger:trace("entering fotr-ftgu-era-two:on_enter")

        GlobalValue.Set("CURRENT_ERA", 2)

        self.entry_time = GetCurrentTime()

        crossplot:publish("VENATOR_RESEARCH_FINISHED", "empty")

    end,
    on_update = function(self, state_context)
    end,
    on_exit = function(self, state_context)
    end
}