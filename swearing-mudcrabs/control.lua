script.on_event(defines.events.on_entity_damaged,
    function(event)
        if event.cause == nil then return end

        local attacker = event.cause
        local target = event.entity

        -- player attacks an enemy unit
        if target.type == "unit" and attacker.type == "character" and attacker.player ~= nil then
            attacker.player.surface.play_sound {
                path = "player_attacks",
                position = target.position
            }

        -- player attacks an enemy unit (while in a car)
        elseif target.type == "unit" and attacker.type == "car" and entity.last_user ~= nil then
            entity.last_user.surface.play_sound {
                path = "player_attacks",
                position = target.position
            }

        -- player gets damaged
        elseif target.type == "character" and target.player ~= nil then
            target.player.surface.play_sound {
                path = "player_damaged",
                position = target.player.position
            }
        end
    end
)

script.on_event(defines.events.on_player_died,
    function(event)
        game.get_player(event.player_index).surface.play_sound { path = "player_died" }
    end
)

script.on_event(defines.events.on_character_corpse_expired,
    function(event)
        event.corpse.surface.play_sound { path = "corpse_expired" }
    end
)
