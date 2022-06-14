data:extend {

    {
        type = "sound",
        name = "player_attacks",
        category = "alert",
        variations = {
            { filename = "__swearing-mudcrabs__/sound/mudcrab_death_1.ogg" },
            { filename = "__swearing-mudcrabs__/sound/mudcrab_death_2.ogg" },
            { filename = "__swearing-mudcrabs__/sound/mudcrab_injured_1.ogg" },
            { filename = "__swearing-mudcrabs__/sound/mudcrab_injured_2.ogg" },
        },
        aggregation = {
            max_count = 1,
            remove = false,
            count_already_playing = true,
        },
    },

    {
        type = "sound",
        name = "player_damaged",
        category = "alert",
        variations = {

            { filename = "__swearing-mudcrabs__/sound/hurt_old.ogg" },
        },
        aggregation = {
            max_count = 1,
            remove = false,
            count_already_playing = true,
        },
    },

    {
        type = "sound",
        name = "player_died",
        category = "alert",
        variations = {
            { filename = "__swearing-mudcrabs__/sound/basti_grim_mach_doch_mal_was.ogg" },
            { filename = "__swearing-mudcrabs__/sound/basti_kacknub.ogg" },
            { filename = "__swearing-mudcrabs__/sound/basti_wtf.ogg" },
        },
        aggregation = {
            max_count = 1,
            remove = false,
            count_already_playing = true,
        },
    },

    {
        type = "sound",
        name = "corpse_expired",
        category = "alert",
        variations = {
            { filename = "__swearing-mudcrabs__/sound/is-this-good-for-the-player.ogg" },
        },
        aggregation = {
            max_count = 1,
            remove = false,
            count_already_playing = true,
        },
    },

}
