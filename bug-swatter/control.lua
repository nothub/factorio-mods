function disable_bugs()
    game.print("Bugs disabled.")
    for _, surface in pairs(game.surfaces) do
        local bugs = surface.find_entities_filtered{force="enemy"}
        for _, bug in pairs(bugs) do
            bug.destroy()
        end
    end
    game.map_settings.enemy_expansion.enabled = false
    game.map_settings.pollution.enabled = false
    game.evolution_factor = 0
end

script.on_event(defines.events.on_player_joined_game, function(event)
    local player = game.players[event.player_index]
    local button = player.gui.top.add{type="button", name="disable_bugs_button", caption="Disable bugs"}
end)

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name == "disable_bugs_button" then
        disable_bugs()
    end
end)
