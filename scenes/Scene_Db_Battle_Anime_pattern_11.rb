module Scene_Db_Battle_Anime_pattern_11

    # カメハメ波(悟飯)
    def anime_pattern_1148()
        if @battle_anime_frame == 0  # init
            Audio.se_play("Audio/SE/" + "Z1 気を溜める")
            @output_anime_type = 1
            battle_anime_change(0, 11)
            @ray_color = 0
        elsif @battle_anime_frame >= 41 && @battle_anime_frame <= 45
            battle_anime_change(0, 12)
        elsif @battle_anime_frame == 46
            Audio.se_stop()
            Audio.se_play("Audio/SE/" + "Z3 エネルギー波")
        elsif @battle_anime_frame >= 47 && @battle_anime_frame <= 75
            @effect_anime_pattern = 203
            @ray_x = 340
            @ray_y = 142
            @ax = 2 if @battle_anime_frame == 47 && $btl_progress >= 2
            @ax = -2 if @battle_anime_frame == 50 && $btl_progress >= 2
            @ax = 0 if @battle_anime_frame == 53 && $btl_progress >= 2
        elsif @battle_anime_frame == 76
            @effect_anime_pattern = 0
            @effect_anime_frame = 0
            @effect_anime_type = 0
        elsif  @battle_anime_frame == 80
            set_chr_display_out()
        elsif @battle_anime_frame >= 81 && @battle_anime_frame <= 110
            @effect_anime_pattern = 204
        elsif @battle_anime_frame == 111
            anime_pattern_init()
            return @battle_anime_result + 1
        end

        return nil
    end  # end of 1148



end
