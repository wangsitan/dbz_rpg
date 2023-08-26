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


    # 爆裂ラッシュ
    def anime_pattern_1152()
        @ray_x = 330
        @ray_y = STANDARD_CHAY - 2

        if $btl_progress == 2
            backhai_no = 201
            back_x = 228
            back_y = 88
        else
            backhai_no = 101
            back_x = 198
            back_y = 34
        end

        case @battle_anime_frame
        when 0
            if $btl_progress == 2
                Audio.se_play("Audio/SE/" + "Z3 変身")    # 効果音を再生する
                @ray_color = 3
            else
                Audio.se_play("Audio/SE/" + "Z2 気を溜める")    # 効果音を再生する
                @ray_color = 0
            end
        when 1..89
            back_anime_pattern(backhai_no, back_x, back_y)
        when 90
            Audio.se_stop()
            Audio.se_play("Audio/SE/" + "Z1 高速移動")    # 効果音を再生する
            @chay = -120
            back_anime_pattern(backhai_no, back_x, back_y)
        when 91..130
            back_anime_pattern(backhai_no, back_x, back_y)
            if @battle_anime_frame % 4 == 0
                picture = Cache.picture("戦闘アニメ") #ダメージ表示用
                rect = Rect.new(0, 48, 64, 64)
                @back_window.contents.blt(@chax-6,144+2,picture,rect)
            end
        when 131
            Audio.se_play("Audio/SE/" + "Z1 逃げる")    # 効果音を再生する
            @enex = CENTER_ENEX
            @eney = STANDARD_ENEY
            @chax = -200
            @chay = STANDARD_CHAY
            @ray_color = 0
            battle_anime_change(0, 16)
            @ax = 20
        when 140..1166
            hit_efe_x = 346
            hit_efe_y = 154
            case @battle_anime_frame
            when 156..157
                @ax = 0
                battle_anime_change(0, 3)
                Audio.se_stop if @battle_anime_frame == 156
                Audio.se_play("Audio/SE/" + "ZG 打撃4") if @battle_anime_frame == 156
                @gx = -8
                battle_anime_change(1, 16)
                @effect_anime_pattern = 123
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y
            when 158..159
                @gx = 8
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y
            when 160..163
                @gx = 0
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y
            when 164
                @effect_anime_pattern = 0
                @effect_anime_frame = 0
                battle_anime_change 0,0
                @ax = -12
                @ay = 6
            when 172
                @ax = 0
                @ay = 0
                battle_anime_change 0,16
            when 180
                @ax = 24
                @ay = -12

            when 184..200
                @gx = -24
                @gy = -6
                @ax = 0
                @ay = 0
                if $btl_progress >= 2
                    battle_anime_change 0,1
                else
                    battle_anime_change 0,2
                end
                battle_anime_change 1,17
                Audio.se_play("Audio/SE/" + "ZG 打撃2") if @battle_anime_frame == 184
                @effect_anime_pattern = 123 if @battle_anime_frame == 184
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y
                #p @battle_anime_frame
                @effect_anime_pattern = 0 if @battle_anime_frame == 200
            when 201..215
                @effect_anime_frame = 0
                battle_anime_change 0,16
                @ax = 24
                @ay = -6
                Audio.se_play("Audio/SE/" + "Z1 逃げる") if @battle_anime_frame == 201
            when 216..225
                @enex = CENTER_ENEX - 24*10 if @battle_anime_frame == 216
                @eney = STANDARD_ENEY + 6*10 if @battle_anime_frame == 216
                battle_anime_change 1,17 if @battle_anime_frame == 216
                battle_anime_change 1,16 if @battle_anime_frame == 221
                @gx = -24
                @gy = -6
            when 226
                @gx = 0
                @gy = 0
                @chax = CENTER_CHAX + 16 - 24*10 if @battle_anime_frame == 226
                @chay = STANDARD_CHAY + 6*10 if @battle_anime_frame == 226
            when 227..236
                @ax = 24
                @ay = -6
            when 237
                @ax = 0
                @ay = 0
            when 241
                @ax = 0
                @gx = -4
                battle_anime_change 0,1
                Audio.se_play("Audio/SE/" + "Z1 打撃") #if @battle_anime_frame == 184
            when 242..246
                @effect_anime_pattern = 123
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y

            when 247
                @effect_anime_frame = 0
                @effect_anime_pattern = 0
                #@gx = -4
                battle_anime_change 0,2
                Audio.se_play("Audio/SE/" + "Z1 打撃") #if @battle_anime_frame == 184
            when 248..250
                @effect_anime_pattern = 123
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y - 14
            when 251
                #@gx = -4
                @effect_anime_frame = 0
                @effect_anime_pattern = 0
                battle_anime_change 0,1
                Audio.se_play("Audio/SE/" + "Z1 打撃") #if @battle_anime_frame == 184
            when 252..254
                @effect_anime_pattern = 123
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y
            when 255
                @effect_anime_frame = 0
                @effect_anime_pattern = 0
                @gx = -4
                battle_anime_change 0,2
                Audio.se_play("Audio/SE/" + "Z1 打撃") #if @battle_anime_frame == 184
            when 256..258
                @effect_anime_pattern = 123
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y - 14
            when 259
                @effect_anime_frame = 0
                @effect_anime_pattern = 0
                #@gx = -4
                battle_anime_change 0,1
                Audio.se_play("Audio/SE/" + "Z1 打撃") #if @battle_anime_frame == 184
            when 260..262
                @effect_anime_pattern = 123
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y
            when 263
                @effect_anime_frame = 0
                @effect_anime_pattern = 0
                #@gx = -4
                battle_anime_change 0,2
                Audio.se_play("Audio/SE/" + "Z1 打撃") #if @battle_anime_frame == 184
            when 264..266
                @effect_anime_pattern = 123
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y - 14
            when 267
                @effect_anime_frame = 0
                @effect_anime_pattern = 0
                #@gx = -4
                battle_anime_change 0,1
                Audio.se_play("Audio/SE/" + "Z1 打撃") #if @battle_anime_frame == 184
            when 268..270
                @effect_anime_pattern = 123
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y
            when 271
                @effect_anime_frame = 0
                @effect_anime_pattern = 0
                #@gx = -4
                battle_anime_change 0,2
                Audio.se_play("Audio/SE/" + "Z1 打撃") #if @battle_anime_frame == 184
            when 272..274
                @effect_anime_pattern = 123
                @ray_x = hit_efe_x
                @ray_y = hit_efe_y - 14
                @gx = 0
                battle_anime_change 0,0
                @ax = -24
            when 275
                @effect_anime_pattern = 0
                @effect_anime_frame = 0
            when 276
                @ax = 48
            when 278
                @ax = 0
                battle_anime_change 0,4
                battle_anime_change 1,17
                Audio.se_play("Audio/SE/" + "Z1 強打")
                @effect_anime_pattern = 121
            when 279..300
                @gx = -24
                if @battle_anime_frame == 289
                    battle_anime_change 0,16
                    @ay = -24
                    Audio.se_play("Audio/SE/" + "Z1 逃げる")
                    Audio.se_play("Audio/SE/" + "DB3 気を溜める2")
                end
            when 301
                @effect_anime_frame = 0
                @effect_anime_pattern = 0
                @gx = 0
                @ay = -6
                @output_anime_type = 1
                battle_anime_change 0,17
                battle_anime_change 0,18 if $game_switches[445] == true
                @tec_output_back_no = 1
                @chax = CENTER_CHAX + 74
                @chay = (STANDARD_CHAY + 142)
                @chr_cutin_flag = false
            when 340
                Audio.se_stop
                Audio.se_play("Audio/SE/" + "Z1 エネルギー波")
                @effect_anime_pattern = 257
                battle_anime_change 0,18
                battle_anime_change 0,19 if $game_switches[445] == true
                #短髪の場合は変更
                @ay = 0
                @ray_spd_up_flag = true
            when 341..399
                @effect_anime_frame = 13 if @effect_anime_frame >= 13
            when 400
                @effect_anime_pattern = 0
                @effect_anime_frame = 0
                @effect_anime_type = 0
                @output_anime_type = 0
                set_chr_display_out
                battle_anime_change 1,16
            when 401..430
                @ray_x = 330
                @ray_y = -600
                @effect_anime_pattern = 258
            when 431
                @battle_anime_frame = 1166
            end
        when 1167
            anime_pattern_init()
            return @battle_anime_result + 1
        end

        return nil
    end  # end of 1152

end
