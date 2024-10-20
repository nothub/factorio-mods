function exterminate()
    for _, surface in pairs(game.surfaces) do
        local bugs = surface.find_entities_filtered{force="enemy"}
        for _, bug in pairs(bugs) do
            bug.destroy()
        end
    end

    game.map_settings.enemy_expansion.enabled = false
    game.map_settings.pollution.enabled = false

    game.forces["enemy"].evolution_factor = 0
    for _, surface in pairs(game.surfaces) do
        local mgs = surface.map_gen_settings
        mgs.autoplace_controls["enemy-base"].size = "none"
        surface.map_gen_settings = mgs
        surface.clear_pollution()
    end

    game.print("Bugs exterminated!")
end

script.on_event(defines.events.on_player_joined_game, function(event)
    local player = game.players[event.player_index]
    local button = player.gui.top.add{type="button", name="exterminate_button", caption="EXTERMINATE"}
end)

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name == "exterminate_button" then
        exterminate()
    end
end)
