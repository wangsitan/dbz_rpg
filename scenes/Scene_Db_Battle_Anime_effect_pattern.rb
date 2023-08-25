module Scene_Db_Battle_Anime_effect_pattern
    #=== copied from class
    #include Share
    #include Db_Battle_Anime_test_Setup

    #キャラクターステータス表示位置
    # character status
    Chastexstr = -16
    Chasteystr = 340
    Chastexend = 672
    Chasteyend = 156
    STANDARD_CHAX = -70
    STANDARD_CHAY = 120
    STANDARD_ENEX = 602
    STANDARD_ENEY = STANDARD_CHAY
    STANDARD_BACKX = 0
    STANDARD_BACKY = 256
    CENTER_CHAX = 240
    CENTER_ENEX = 304
    TEC_CENTER_CHAX = 266
    RAY_SPEED = 14
    ENE_STOP_TEC = 102  #超能力の技ID
    ENE_STOP_TEC2 = 720  #超能力の技ID
    STOP_TURN = 1       #超能力でストップするターン
    FLASH_Y_SIZE_CUTIN_ON = 296
    FLASH_Y_SIZE_CUTIN_OFF = 356
    FASTFADEFRAME = 5 #RとBでスキップ時のフェードフレーム数
    #===

    #--------------------------------------------------------------------------
    # ● エフェクトアニメパターン：エネルギー弾、爆発等
    # mirror_pattern:強制的に逆のモードにする
    #--------------------------------------------------------------------------
    def effect_pattern(n, ray_x=0, ray_y=0, mirror_pattern=@attackDir)
        case n

        when 1 # エネルギー弾系(正面)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if ray_x == 0 || ray_x == nil
                ray_x = 240
                ray_y = 100
            end
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end

        when 2 # カメハメ波系(正面)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if ray_x == 0 || ray_x == nil
                ray_x = 240
                ray_y = 110
            end
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 3 # エネルギー弾系(正面)緑(手の位置)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(240, 110, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 4 # エネルギー弾系(正面)緑_双方向
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(240 - @effect_anime_frame * 2, 122 - @effect_anime_frame * 2, picture, rect)
            @back_window.contents.blt(262 + @effect_anime_frame * 2, 122 - @effect_anime_frame * 2, picture, rect)
            if @effect_anime_frame % 15 == 0
                @effect_anime_type += 1
            end
        when 5 # エネルギー弾系(正面)緑(口の位置)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            end

            if ray_x == 0 || ray_x == nil
                ray_x = 250
                ray_y = 140
            end

            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 6 # エネルギー弾系(正面)緑(中心の位置)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(桃)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(250, 114, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 7 # 魔貫光殺砲(正面)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_魔貫光殺砲系(緑)") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(238, 124, picture, rect)
            if @effect_anime_frame >= 6
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 8 # エネルギー弾系(正面)(悟飯センター)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(桃)") # ダメージ表示用
            end
            if ray_x == 0 || ray_x == nil
                ray_x = 252
                ray_y = 130
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 9 # 気円斬(クリリン)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") # ダメージ表示用

            rect = Rect.new(@effect_anime_type * 128, 0, 128, 28)
            if @effect_anime_frame >= 0 && @effect_anime_frame <= 30
                # @back_window.contents.blt(252,120,picture,rect)
            elsif @effect_anime_frame == 31
                @effect_anime_type += 1
            elsif @effect_anime_frame == 41
                @effect_anime_type += 1
            elsif @effect_anime_frame == 51
                @effect_anime_type += 1
            end
            @back_window.contents.blt(252, 120, picture, rect)
        when 10 # 繰気弾(ヤムチャ)
            if ray_x == 0 || ray_x == nil
                ray_x = 230
                ray_y = 66
            end
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame >= 0 && @effect_anime_frame <= 30
            elsif @effect_anime_frame == 51
                @effect_anime_type += 1
            elsif @effect_anime_frame == 71
                @effect_anime_type += 1
            elsif @effect_anime_frame == 91
                @effect_anime_type += 1
            elsif @effect_anime_frame == 111 && $btl_progress >= 2
                @effect_anime_type += 1
            end
        when 11 # エネルギー弾系(正面)(テンシンハンの手)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(230, 114, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 12 # 四身の拳系(正面)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") # ダメージ表示用
            case @effect_anime_frame

            when 0..30
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(@chax - 2 * @effect_anime_frame, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 2 * @effect_anime_frame, STANDARD_CHAY, picture, rect)
            when 31..59

                rect = Rect.new(0, 0 + (96 * 3), 96, 96)
                @back_window.contents.blt(@chax - 60, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 60, STANDARD_CHAY, picture, rect)
                if @effect_anime_frame == 59
                    Audio.se_play("Audio/SE/" + "Z1 分身") # 効果音を再生する
                end
            when 60..120
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(@chax - 60, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 60, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax - 60 - 2 * (@effect_anime_frame - 60), STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 60 + 2 * (@effect_anime_frame - 60), STANDARD_CHAY, picture, rect)
            else
                if @effect_anime_frame == 121
                    Audio.se_play("Audio/SE/" + "Z1 エネルギー波2") # 効果音を再生する
                end
                rect = Rect.new(0, 0 + (96 * 6), 96, 96)
                @back_window.contents.blt(@chax - 60, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 60, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax - 180, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 180, STANDARD_CHAY, picture, rect)
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(紫)") # ダメージ表示用
                rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
                @back_window.contents.blt(68, 114, picture, rect)
                @back_window.contents.blt(68 + 120, 114, picture, rect)
                @back_window.contents.blt(68 + 240, 114, picture, rect)
                @back_window.contents.blt(68 + 360, 114, picture, rect)
                if @effect_anime_frame == 130
                    @effect_anime_type += 1
                elsif @effect_anime_frame == 140
                    @effect_anime_type += 1
                elsif @effect_anime_frame == 150
                    @effect_anime_type += 1
                end
            end
        when 13 # 四身の拳気功砲(正面)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") # ダメージ表示用
            case @effect_anime_frame

            when 0..30
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(@chax - 2 * @effect_anime_frame, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 2 * @effect_anime_frame, STANDARD_CHAY, picture, rect)
            when 31..59

                rect = Rect.new(0, 0 + (96 * 3), 96, 96)
                @back_window.contents.blt(@chax - 60, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 60, STANDARD_CHAY, picture, rect)
                if @effect_anime_frame == 59
                    Audio.se_play("Audio/SE/" + "Z1 分身")    # 効果音を再生する
                end
            when 60..120
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(@chax - 60, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 60, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax - 60 - 2 * (@effect_anime_frame - 60), STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 60 + 2 * (@effect_anime_frame - 60), STANDARD_CHAY, picture, rect)
            else
                if @effect_anime_frame == 121
                    Audio.se_play("Audio/SE/" + "Z1 ザー")    # 効果音を再生する
                    Audio.se_play("Audio/SE/" + "Z1 気を溜める4") # 効果音を再生する
                end
                rect = Rect.new(0, 0 + (96 * 2), 96, 96)
                @back_window.contents.blt(@chax - 60, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 60, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax - 180, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(@chax + 180, STANDARD_CHAY, picture, rect)
                back_anime_pattern 8
            end
        when 14 # エネルギー弾系(正面)(ラディッツ)手の位置
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾_敵") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾_敵(黄)") # ダメージ表示用
            elsif @ray_color == 2
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾_敵(赤)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(228, 102, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 15 # エネルギー弾系(正面)(ラディッツ)正面
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾_敵") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(248, 112, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 16 # エネルギー弾系(正面)(カイワレマン系頭)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(赤)") # ダメージ表示
            end

            if ray_x == 0 || ray_x == nil
                ray_x = 249
                ray_y = 112
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 17 # 貫光線(正面)(ラディッツ)手の位置
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_貫光線_正面") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(228, 102, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 18 # エネルギー弾系(正面)(サンショ手の位置)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(桃)") # ダメージ表示用
            end
            if ray_x == 0 || ray_x == nil
                ray_x = 230
                ray_y = 104
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 19 # エネルギー弾系(正面)(ベジータ)手の位置
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾_敵") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(238, 122, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 20 # 元気弾

            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(230, 76, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 21 # パワーボール(べジータ)
            # p ray_x,ray_y
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(ray_x.to_i, ray_y.to_i, picture, rect)
        when 31 # エネルギー波系(小)横
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波(緑)") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 28)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            else
                rect = Rect.new(0, 28, 400, 28)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            end

        when 32 # かめはめ波系(中)横
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中(緑)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中(桃)") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 60)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 140, picture, rect)
            else
                rect = Rect.new(0, 60, 400, 60)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 140, picture, rect)
            end
        when 33 # 爆裂魔光砲系(大)横
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大(緑)") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 92)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 124, picture, rect)
            else
                rect = Rect.new(0, 92, 400, 92)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 124, picture, rect)
            end
        when 35 # エネルギー波系(小)横x2(目から怪光線)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波(緑)") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 28)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 144, picture, rect)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 174, picture, rect)
            else
                rect = Rect.new(0, 28, 400, 28)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 144, picture, rect)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 174, picture, rect)
            end
        when 36 # 魔貫光殺砲

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_魔貫光殺砲") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 32)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            else
                rect = Rect.new(0, 32, 400, 32)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            end
        when 37 # エネルギー波縦

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_縦") # ダメージ表示用
            rect = Rect.new(60, 0, 60, 400)
            @back_window.contents.blt(330, -600 + @effect_anime_frame * RAY_SPEED / 2, picture, rect)
        when 38 # 気円斬

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") # ダメージ表示用
            rect = Rect.new(128, 0, 128, 28)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            end

        when 39 # 狼牙風風拳

            end_frame = 85
            if @btl_ani_cha_chg_no == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) # ダメージ表示用
            end
            attack_se = "Z3 打撃"
            case @effect_anime_frame

            when 0..10
                rect = Rect.new(0, 14 * 96, 96, 96)
            when 11..20
                rect = Rect.new(0, 13 * 96, 96, 96)
            when 21..30
                rect = Rect.new(0, 12 * 96, 96, 96)
            when 31..35
                rect = Rect.new(0, 0 * 96, 96, 96)
            when 36..39
                rect = Rect.new(0, 3 * 96, 96, 96)
            when 40..43
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 44..46
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 47..50
                rect = Rect.new(0, 4 * 96, 96, 96)
            when 51..53
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 54..56
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 57..60
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 61..80
                rect = Rect.new(0, 16 * 96, 96, 96)
            else
                # when 81..85

                if @btl_ani_cha_chg_no == 0
                    if $cha_set_action[@chanum] == 758
                        picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
                        rect = Rect.new(0, 3 * 96, 96, 96)
                    elsif $btl_progress >= 2
                        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
                        rect = Rect.new(0, 3 * 96, 96, 96)
                    else
                        picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
                        rect = Rect.new(0, 2 * 96, 96, 96)
                    end
                else

                    if $cha_set_action[@chanum] == 758
                        picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) # ダメージ表示用
                        rect = Rect.new(0, 3 * 96, 96, 96)
                    elsif $btl_progress >= 2
                        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) # ダメージ表示用
                        rect = Rect.new(0, 3 * 96, 96, 96)
                    else
                        picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) # ダメージ表示用
                        rect = Rect.new(0, 2 * 96, 96, 96)
                    end

                end
                # else

                # if @btl_ani_cha_chg_no == 0
                #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
                # else
                #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
                # end
                # if $btl_progress >= 2
                #  rect = Rect.new(0, 3*96,96,96)
                # else
                #  rect = Rect.new(0, 3*96,96,96)
                # end
            end

            if @effect_anime_frame >= 36 && @effect_anime_frame % 5 == 0 && end_frame > @effect_anime_frame
                Audio.se_play("Audio/SE/" + attack_se) # 効果音を再生する
            end

            if @effect_anime_frame >= 61 && @effect_anime_frame <= 80
                @back_window.contents.blt(CENTER_CHAX - (@effect_anime_frame - 60) * 8, STANDARD_CHAY, picture, rect)
            elsif @effect_anime_frame >= 81 && @effect_anime_frame <= 84
                @back_window.contents.blt(80 + (@effect_anime_frame - 80) * 16, STANDARD_CHAY, picture, rect)
            else # if @effect_anime_frame < 86
                @back_window.contents.blt(CENTER_CHAX, STANDARD_CHAY, picture, rect)
            end

        when 40 # 繰気弾

            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end

            rect = Rect.new(256, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end

        when 41 # 四身の拳用エネルギー波系(小)横
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波(緑)") # ダメージ表示用
            elsif @ray_color == 2
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波(紫)") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 28)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 120, picture, rect)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 120 + 30, picture, rect)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 120 + 60, picture, rect)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 120 + 90, picture, rect)
            else
                rect = Rect.new(0, 28, 400, 28)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            end
        when 42 # エネルギー波中横(敵)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_敵_中") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_敵_中(黄)") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 60)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            else
                rect = Rect.new(0, 60, 400, 60)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            end
        when 43 # エネルギー波大横(敵)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_敵_大") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 88)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 134, picture, rect)
            else
                rect = Rect.new(0, 88, 400, 88)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 134, picture, rect)
            end
        when 44 # エネルギー液横(敵)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(緑)") # ダメージ表示用
            elsif @ray_color == 2
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(水色)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(桃)") # ダメージ表示用
            end
            if @attackDir == 0 && mirror_pattern == 0
                rect = Rect.new(0, 0, 400, 32)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            else
                rect = Rect.new(0, 32, 400, 32)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            end
        when 45 # 貫光線

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_貫光線_横") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 32)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            else
                rect = Rect.new(0, 32, 400, 32)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            end
        when 46 # 刀攻撃
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_敵_" + $data_enemies[@enedatenum].name) # ダメージ表示用
            attack_se = "Z1 刀攻撃"
            case @effect_anime_frame

            when 0..10
                rect = Rect.new(0, 4 * 96, 96, 96)
            when 11..20
                rect = Rect.new(0, 5 * 96, 96, 96)
            when 21..30
                rect = Rect.new(0, 6 * 96, 96, 96)
            when 31..40
                rect = Rect.new(0, 7 * 96, 96, 96)
            when 41..50
                rect = Rect.new(0, 8 * 96, 96, 96)
            when 51..60
                rect = Rect.new(0, 9 * 96, 96, 96)
            when 61..70
                rect = Rect.new(0, 10 * 96, 96, 96)
            else
                rect = Rect.new(0, 10 * 96, 96, 96)
            end

            if @effect_anime_frame == 55
                Audio.se_play("Audio/SE/" + attack_se) # 効果音を再生する
            end

            @back_window.contents.blt(CENTER_ENEX, STANDARD_ENEY, picture, rect)
        when 47 # かめはめ波系(中)円つき横
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中(緑)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_円_中(桃)") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 60)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 140, picture, rect)
            else
                rect = Rect.new(0, 60, 400, 60)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 140, picture, rect)
            end
        when 48 # かめはめ波系(特大)横
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_緑") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_青") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 192)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            else
                rect = Rect.new(0, 192, 400, 192)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            end
        when 49 # 界王拳

            end_frame = 85
            picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
            attack_se = "Z1 打撃"
            case @effect_anime_frame

            when 0..10
                rect = Rect.new(0, 14 * 96, 96, 96)
            when 11..20
                rect = Rect.new(0, 13 * 96, 96, 96)
            when 21..30
                rect = Rect.new(0, 12 * 96, 96, 96)
            when 31..35
                rect = Rect.new(0, 0 * 96, 96, 96)
            when 36..39
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 40..43
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 44..46
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 47..50
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 51..53
                rect = Rect.new(0, 3 * 96, 96, 96)
            when 54..56
                rect = Rect.new(0, 4 * 96, 96, 96)
            when 57..60
                rect = Rect.new(0, 3 * 96, 96, 96)
            when 61..63
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 64..66
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 67..70
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 71..73
                rect = Rect.new(0, 2 * 96, 96, 96)
            else
                rect = Rect.new(0, 2 * 96, 96, 96)
            end

            if @effect_anime_frame >= 36 && @effect_anime_frame % 4 == 0 && end_frame > @effect_anime_frame
                Audio.se_play("Audio/SE/" + attack_se) # 効果音を再生する
            end

            if @effect_anime_frame >= 61 && @effect_anime_frame <= 80
                @back_window.contents.blt(CENTER_CHAX - (@effect_anime_frame - 60) * 8, STANDARD_CHAY, picture, rect)
            elsif @effect_anime_frame >= 81 && @effect_anime_frame <= 84
                @back_window.contents.blt(80 + (@effect_anime_frame - 80) * 16, STANDARD_CHAY, picture, rect)
            else # if @effect_anime_frame < 86
                @back_window.contents.blt(CENTER_CHAX, STANDARD_CHAY, picture, rect)
            end
        when 50 # ダブル衝撃波_キャラ現れる

            end_frame = 85

            if $partyc[@chanum.to_i] == 3
                picture = Cache.picture(set_battle_character_name 10, 0)
            # picture = Cache.picture($btl_top_file_name + "戦闘_チチ") #ダメージ表示用
            else
                picture = Cache.picture(set_battle_character_name 3, 0)
                # picture = Cache.picture($btl_top_file_name + "戦闘_ゴクウ") #ダメージ表示用
            end
            # attack_se = "Z3 打撃"
            case @effect_anime_frame

            when 0..10
                rect = Rect.new(0, 14 * 96, 96, 96)
            when 11..20
                rect = Rect.new(0, 13 * 96, 96, 96)
            when 21..30
                rect = Rect.new(0, 12 * 96, 96, 96)
            when 31..40
                rect = Rect.new(0, 8 * 96, 96, 96)
            else
                rect = Rect.new(0, 8 * 96, 96, 96)
            end

            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
        when 51 # ダブル衝撃波発動

            end_frame = 85
            if $partyc[@chanum.to_i] == 3
                picture = Cache.picture(set_battle_character_name 10, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チチ") #ダメージ表示用
            else
                picture = Cache.picture(set_battle_character_name 3, 1)
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用
            end
            # attack_se = "Z3 打撃"
            rect = Rect.new(0, 1 * 96, 96, 96)

            @back_window.contents.blt(CENTER_CHAX + 120 - 16, STANDARD_CHAY, picture, rect)
        when 52 # 捨て身攻撃_キャラ現れる

            end_frame = 85

            if $partyc[@chanum.to_i] == 3
                picture = Cache.picture(set_battle_character_name 4, 0)
            # picture = Cache.picture($btl_top_file_name + "戦闘_ピッコロ") #ダメージ表示用
            else
                picture = Cache.picture(set_battle_character_name 3, 0)
                # picture = Cache.picture($btl_top_file_name + "戦闘_ゴクウ") #ダメージ表示用
            end

            # attack_se = "Z3 打撃"
            case @effect_anime_frame

            when 0..10
                rect = Rect.new(0, 14 * 96, 96, 96)
            when 11..20
                rect = Rect.new(0, 13 * 96, 96, 96)
            when 21..30
                rect = Rect.new(0, 12 * 96, 96, 96)
            when 31..40
                rect = Rect.new(0, 8 * 96, 96, 96)
            else
                rect = Rect.new(0, 8 * 96, 96, 96)
            end

            if $partyc[@chanum.to_i] == 3
                @back_window.contents.blt(CENTER_CHAX - 120 + 6, STANDARD_CHAY, picture, rect)
            else
                @back_window.contents.blt(CENTER_CHAX + 180, STANDARD_CHAY, picture, rect)
            end
        when 53 # 捨て身攻撃_エネルギー波発動

            picture = Cache.picture(set_battle_character_name 3, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用
            rect = Rect.new(0, 2 * 96, 96, 96)
            if $partyc[@chanum.to_i] == 3
                @back_window.contents.blt(CENTER_CHAX + 180 - 2, STANDARD_CHAY, picture, rect)
            else
                @back_window.contents.blt(CENTER_CHAX + 180 - 12, STANDARD_CHAY, picture, rect)
            end
            picture = Cache.picture(set_battle_character_name 4, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") #ダメージ表示用
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX - 120 - 10, STANDARD_CHAY, picture, rect)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(240 + 158 - 10, 100, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 54 # 捨て身攻撃_悟空ダッシュ発動
            picture = Cache.picture(set_battle_character_name 4, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") #ダメージ表示用
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX - 120 - 10, STANDARD_CHAY, picture, rect)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(240 + 158 - 10, 100, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 55 # 捨て身攻撃_ピッコロ_まかんこうさっぽうため1
            picture = Cache.picture(set_battle_character_name 4, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") #ダメージ表示用
            rect = Rect.new(0, 5 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX - 120 - 10, STANDARD_CHAY, picture, rect)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(240 + 158, 100, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 56 # 捨て身攻撃_ピッコロ_まかんこうさっぽうため2ゆびあたま
            picture = Cache.picture(set_battle_character_name 4, 1) # ダメージ表示用
            rect = Rect.new(0, 7 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX - 120 - 10, STANDARD_CHAY, picture, rect)

        # if @effect_anime_frame % 4 == 0
        #  picture = Cache.picture("戦闘アニメ") #ダメージ表示用
        #  rect = Rect.new(0,48, 64, 64)
        #  @back_window.contents.blt(CENTER_ENEX+64,STANDARD_ENEY+32,picture,rect)
        # end
        when 57 # 捨て身攻撃_ピッコロ_まかんこうさっぽうため2ゆびまえ
            picture = Cache.picture(set_battle_character_name 4, 1) # ダメージ表示用
            rect = Rect.new(0, 8 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX - 120 - 10, STANDARD_CHAY, picture, rect)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_魔貫光殺砲系(緑)") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(238 - 120 - 30, 124, picture, rect)
            if @effect_anime_frame >= 6
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 58 # 捨て身攻撃_悟空敵の後ろに出現
            if @effect_anime_frame % 4 == 0
                picture = Cache.picture("戦闘アニメ") # ダメージ表示用
                rect = Rect.new(0, 48, 64, 64)
                @back_window.contents.blt(CENTER_ENEX + 64, STANDARD_ENEY - 60, picture, rect)
            end
        when 59 # 捨て身攻撃_Z2悟空敵の後ろに出現
            if @effect_anime_frame % 4 == 0
                picture = Cache.picture("戦闘アニメ") # ダメージ表示用
                rect = Rect.new(0, 48, 64, 64)
                @back_window.contents.blt(TEC_CENTER_CHAX + 16, STANDARD_CHAY + 16, picture, rect)
            end
        when 60 # かめはめ乱舞_キャラ現れる

            x = 0

            for x in 0..1
                if $partyc[@chanum.to_i] == 3 || $partyc[@chanum.to_i] == 14
                    picture = Cache.picture(set_battle_character_name 6, 0) if x == 0 # ダメージ表示用
                    picture = Cache.picture(set_battle_character_name 7, 0) if x == 1 # ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_クリリン") if x == 0#ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_ヤムチャ") if x == 1#ダメージ表示用
                elsif $partyc[@chanum.to_i] == 6
                    picture = Cache.picture(set_battle_character_name 3, 0) if x == 0 # ダメージ表示用
                    picture = Cache.picture(set_battle_character_name 7, 0) if x == 1 # ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_ゴクウ") if x == 0#ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_ヤムチャ") if x == 1#ダメージ表示用
                elsif $partyc[@chanum.to_i] == 7
                    picture = Cache.picture(set_battle_character_name 3, 0) if x == 0 # ダメージ表示用
                    picture = Cache.picture(set_battle_character_name 6, 0) if x == 1 # ダメージ表示用
                    # picture = Cache.picture($btl_top_file_name + "戦闘_ゴクウ") if x == 0#ダメージ表示用
                    # picture = Cache.picture($btl_top_file_name + "戦闘_クリリン") if x == 1#ダメージ表示用
                end

                # attack_se = "Z3 打撃"
                case @effect_anime_frame

                when 0..10
                    rect = Rect.new(0, 14 * 96, 96, 96)
                when 11..20
                    rect = Rect.new(0, 13 * 96, 96, 96)
                when 21..30
                    rect = Rect.new(0, 12 * 96, 96, 96)
                when 31..40
                    rect = Rect.new(0, 8 * 96, 96, 96)
                else
                    rect = Rect.new(0, 8 * 96, 96, 96)
                end

                if x == 0
                    @back_window.contents.blt(CENTER_CHAX - 120 + 8, STANDARD_CHAY, picture, rect) if $partyc[@chanum.to_i] == 3
                    @back_window.contents.blt(TEC_CENTER_CHAX + 18, STANDARD_CHAY, picture,
                                              rect) if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7

                else
                    @back_window.contents.blt(CENTER_CHAX + 180 + 38, STANDARD_CHAY, picture,
                                              rect) if $partyc[@chanum.to_i] == 3 || $partyc[@chanum.to_i] == 6
                    @back_window.contents.blt(CENTER_CHAX - 120 + 8, STANDARD_CHAY, picture, rect) if $partyc[@chanum.to_i] == 7
                end
            end
        when 61 # かめはめ乱舞_発動
            tameframe = 120
            hatudouframe = 30
            picture = Cache.picture(set_battle_character_name 3, 1) # ダメージ表示用
            case @effect_anime_frame

            when 0..tameframe
                rect = Rect.new(0, 3 * 96, 96, 96)
            else
                rect = Rect.new(0, 4 * 96, 96, 96)
            end
            @back_window.contents.blt(TEC_CENTER_CHAX + 4, STANDARD_CHAY, picture, rect)

            picture = Cache.picture(set_battle_character_name 6, 1) # ダメージ表示用
            case @effect_anime_frame

            when 0..tameframe
                rect = Rect.new(0, 1 * 96, 96, 96)
            else
                rect = Rect.new(0, 2 * 96, 96, 96)
            end
            @back_window.contents.blt(CENTER_CHAX - 120 + 8 - 28, STANDARD_CHAY + 2, picture, rect)

            picture = Cache.picture(set_battle_character_name 7, 1) # ダメージ表示用
            @back_window.contents.blt(CENTER_CHAX + 180 + 38 - 20, STANDARD_CHAY - 2, picture, rect)

            if @effect_anime_frame >= tameframe + hatudouframe
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
                rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
                @back_window.contents.blt(242, 114, picture, rect)
                @back_window.contents.blt(-18 + CENTER_CHAX - 120 + 8 - 28, -2 + STANDARD_CHAY + 2, picture, rect)
                @back_window.contents.blt(-24 + CENTER_CHAX + 180 + 38 - 20, -6 + STANDARD_CHAY - 2, picture, rect)
                if @effect_anime_frame >= tameframe + hatudouframe + (@effect_anime_type + 1) * 10
                    @effect_anime_type += 1
                end
            end
        when 62 # かめはめ波乱舞横
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_カメハメ乱舞エネルギー波") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 152)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 100, picture, rect)
            else
                rect = Rect.new(0, 192, 400, 192)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            end
        when 63 # かめはめ乱舞(Z2)_キャラ現れる

            x = 0

            for x in 0..1
                if $partyc[@chanum.to_i] == 3 || $partyc[@chanum.to_i] == 14
                    picture = Cache.picture(set_battle_character_name 6, 1) if x == 0 # ダメージ表示用
                    picture = Cache.picture(set_battle_character_name 7, 1) if x == 1 # ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン") if x == 0#ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ") if x == 1#ダメージ表示用
                elsif $partyc[@chanum.to_i] == 6
                    picture = Cache.picture(set_battle_character_name 3, 1) if x == 0 # ダメージ表示用
                    picture = Cache.picture(set_battle_character_name 14, 1) if x == 0 && $super_saiyazin_flag[1] == true
                    picture = Cache.picture(set_battle_character_name 7, 1) if x == 1 # ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") if x == 0#ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ") if x == 1#ダメージ表示用
                elsif $partyc[@chanum.to_i] == 7
                    picture = Cache.picture(set_battle_character_name 3, 1) if x == 0 # ダメージ表示用
                    picture = Cache.picture(set_battle_character_name 14, 1) if x == 0 && $super_saiyazin_flag[1] == true
                    picture = Cache.picture(set_battle_character_name 6, 1) if x == 1 # ダメージ表示用
                    # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") if x == 0#ダメージ表示用
                    # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン") if x == 1#ダメージ表示用
                end

                rect = Rect.new(0, 0 * 96, 96, 96)
                ushirox = 0
                idouryou = 8
                if x == 0
                    @back_window.contents.blt(STANDARD_CHAX - ushirox + @effect_anime_frame * idouryou, STANDARD_CHAY + 64, picture,
                                              rect) if $partyc[@chanum.to_i] == 3 || $partyc[@chanum.to_i] == 14
                    @back_window.contents.blt(STANDARD_CHAX + @effect_anime_frame * idouryou + 30, STANDARD_CHAY, picture,
                                              rect) if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7
                # p STANDARD_CHAX+@effect_anime_frame*idouryou,TEC_CENTER_CHAX if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7
                else
                    @back_window.contents.blt(STANDARD_CHAX - ushirox + @effect_anime_frame * idouryou, STANDARD_CHAY - 64, picture,
                                              rect) if $partyc[@chanum.to_i] == 3 || $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 14
                    @back_window.contents.blt(STANDARD_CHAX - ushirox + @effect_anime_frame * idouryou, STANDARD_CHAY + 64, picture,
                                              rect) if $partyc[@chanum.to_i] == 7
                end
            end
        # p STANDARD_CHAX-ushirox+@effect_anime_frame*idouryou
        when 64 # かめはめ乱舞(Z2)_キャラ現れたあと放置
            ushirox = 0
            idougo = 212 + 24
            rect = Rect.new(0, 0 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name 3, 1)
            picture = Cache.picture(set_battle_character_name 14, 1) if $super_saiyazin_flag[1] == true
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY, picture, rect)
            picture = Cache.picture(set_battle_character_name 6, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            @back_window.contents.blt(idougo, STANDARD_CHAY + 64, picture, rect)
            picture = Cache.picture(set_battle_character_name 7, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
            @back_window.contents.blt(idougo, STANDARD_CHAY - 64, picture, rect)

        when 65 # かめはめ乱舞(Z2)_キャラ現れたあと発動
            ushirox = 0
            idougo = 212 + 24
            tameframe = 120
            hatudouframe = 30

            case @effect_anime_frame

            when 0..tameframe
                rect = Rect.new(0, 2 * 96, 96, 96)
            else
                rect = Rect.new(0, 3 * 96, 96, 96)
            end
            picture = Cache.picture(set_battle_character_name 3, 1)
            picture = Cache.picture(set_battle_character_name 14, 1) if $super_saiyazin_flag[1] == true
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY, picture, rect)
            picture = Cache.picture(set_battle_character_name 6, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            @back_window.contents.blt(idougo, STANDARD_CHAY + 64, picture, rect)
            picture = Cache.picture(set_battle_character_name 7, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
            @back_window.contents.blt(idougo, STANDARD_CHAY - 64, picture, rect)

            if @effect_anime_frame > tameframe
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_カメハメ乱舞エネルギー波")
                # p 168+(@effect_anime_frame - tameframe)*RAY_SPEED
                rect = Rect.new(0, 0, 168 + (@effect_anime_frame - tameframe) * RAY_SPEED, 204)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            end
        when 66 # かめはめ乱舞(Z2)_キャラ現れたあと発動ヒット
            picture = Cache.picture("Z1_戦闘_必殺技_カメハメ乱舞エネルギー波") # ダメージ表示用
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ")
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 152)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 100, picture, rect)
            else
                rect = Rect.new(0, 192, 400, 192)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            end
        when 67 # 元気玉受け系(正面)(悟飯センター)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(桃)") # ダメージ表示用
            end
            rect = Rect.new((5 - @effect_anime_type) * 128, 0, 128, 128)
            @back_window.contents.blt(252, 130, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 68 # 元気玉はじく系(正面)(悟飯センター)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(桃)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(252, 130 - @effect_anime_frame * 4, picture, rect)
            if @effect_anime_frame >= (@effect_anime_type + 1) * 5
                @effect_anime_type += 1
                # @effect_anime_frame = 0
            end
        when 69 # 元気玉はじく(ヒット)
            @effect_anime_type = 2
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            # if @attackDir == 0
            @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y - @effect_anime_frame * 4, picture, rect)
        # else
        # @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
        # end
        when 70 # 操気円斬_キャラ現れる

            if $partyc[@chanum.to_i] == 6
                picture = Cache.picture(set_battle_character_name 7, 0)
                # picture = Cache.picture($btl_top_file_name + "戦闘_ヤムチャ") #ダメージ表示用
                picture = Cache.picture(set_battle_character_name 7, 1) if @effect_anime_frame >= 31
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ") if @effect_anime_frame >= 31
            else
                picture = Cache.picture(set_battle_character_name 6, 0)
                picture = Cache.picture(set_battle_character_name 6, 1) if @effect_anime_frame >= 31
                # picture = Cache.picture($btl_top_file_name + "戦闘_クリリン") #ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン") if @effect_anime_frame >= 31

            end
            # attack_se = "Z3 打撃"
            case @effect_anime_frame

            when 0..10
                rect = Rect.new(0, 14 * 96, 96, 96)
            when 11..20
                rect = Rect.new(0, 13 * 96, 96, 96)
            when 21..30
                rect = Rect.new(0, 12 * 96, 96, 96)
            when 31..40
                rect = Rect.new(0, 0 * 96, 96, 96)
            else
                rect = Rect.new(0, 0 * 96, 96, 96)
            end
            if $partyc[@chanum.to_i] == 6
                @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
            else
                @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
            end
        when 71 # 繰気弾(ヤムチャ)

            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame >= 0 && @effect_anime_frame <= 30
            elsif @effect_anime_frame == 51
                @effect_anime_type += 1
            elsif @effect_anime_frame == 71
                @effect_anime_type += 1
            elsif @effect_anime_frame == 91
                @effect_anime_type += 1
            end
        when 72 # 繰気弾

            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end

            rect = Rect.new(256, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 40 + @effect_anime_frame * 2, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end
        when 73 # 繰気弾

            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end

            rect = Rect.new(256, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(450 - @effect_anime_frame * 2, 278 - @effect_anime_frame * RAY_SPEED, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end

        when 74 # 繰気弾

            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end

            rect = Rect.new(256, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(320 - @effect_anime_frame * 2, -100 + @effect_anime_frame * RAY_SPEED, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end

        when 75 # 繰気弾

            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end

            rect = Rect.new(256, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(200 + @effect_anime_frame * 16, 278 - @effect_anime_frame * RAY_SPEED, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end
        when 76 # 繰気弾

            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end

            rect = Rect.new(256, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(660 - @effect_anime_frame * 20, 110 - @effect_anime_frame * 2, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end
        when 77 # 気円斬(クリリン)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") # ダメージ表示用

            rect = Rect.new(@effect_anime_type * 128, 0, 128, 28)
            if @effect_anime_frame >= 0 && @effect_anime_frame <= 30
                # @back_window.contents.blt(252,120,picture,rect)
            elsif @effect_anime_frame == 31
                @effect_anime_type += 1
            elsif @effect_anime_frame == 41
                @effect_anime_type += 1
            elsif @effect_anime_frame == 51
                @effect_anime_type += 1
            end
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
        when 78 # 操気円斬(Z2)_キャラ現れる

            if $partyc[@chanum.to_i] == 6
                picture = Cache.picture(set_battle_character_name 7, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
            elsif $partyc[@chanum.to_i] == 7
                picture = Cache.picture(set_battle_character_name 6, 1)
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            end
            rect = Rect.new(0, 0 * 96, 96, 96)
            ushirox = 0
            idouryou = 8
            if $partyc[@chanum.to_i] == 6
                @back_window.contents.blt(STANDARD_CHAX + @effect_anime_frame * idouryou + 30, STANDARD_CHAY - 50, picture,
                                          rect)
            # p STANDARD_CHAX+@effect_anime_frame*idouryou,TEC_CENTER_CHAX if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7
            else
                @back_window.contents.blt(STANDARD_CHAX + @effect_anime_frame * idouryou + 30, STANDARD_CHAY + 50, picture,
                                          rect)
            end
        when 79 # 操気円斬(Z2)_キャラ現れる(放置)
            picture = Cache.picture(set_battle_character_name 6, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            rect = Rect.new(0, 0 * 96, 96, 96)
            # ushirox=0
            # idouryou = 8
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
        when 80 # ダブルどどんぱ(正面)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(240 + 96, 120, picture, rect)
            @back_window.contents.blt(240 - 98, 110, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 81 # ダブルどどんぱエネルギー波系(小)横x2

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 28)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 144, picture, rect)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 174, picture, rect)
            else
                rect = Rect.new(0, 28, 400, 28)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 144, picture, rect)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 174, picture, rect)
            end
        when 82 # 師弟の絆発動たま
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(250 - 94, 114, picture, rect)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(252 + 96, 130, picture, rect)

            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 83 # 師弟の絆発動たま横
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大(師弟の絆)") # ダメージ表示用
            rect = Rect.new(0, @ray_anime_type * 92, 400, 92)
            @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 124, picture, rect)

            if @ray_anime_frame >= 8 && @ray_anime_type == 0
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 8
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 84 # 師弟の絆(Z2)_キャラ現れる

            if $partyc[@chanum.to_i] == 4
                picture = Cache.picture(set_battle_character_name 5, 1)
                if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
                    picture = Cache.picture(set_battle_character_name 18, 1)
                end
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
            else
                picture = Cache.picture(set_battle_character_name 4, 1)
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
            end
            rect = Rect.new(0, 0 * 96, 96, 96)
            ushirox = 0
            idouryou = 8
            if $partyc[@chanum.to_i] == 4
                @back_window.contents.blt(STANDARD_CHAX + @effect_anime_frame * idouryou + 30, STANDARD_CHAY - 50, picture,
                                          rect)
            # p STANDARD_CHAX+@effect_anime_frame*idouryou,TEC_CENTER_CHAX if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7
            else
                @back_window.contents.blt(STANDARD_CHAX + @effect_anime_frame * idouryou + 30, STANDARD_CHAY + 50, picture,
                                          rect)
            end
        when 85 # 師弟の絆(Z2)_キャラ現れる(放置)
            picture = Cache.picture(set_battle_character_name 4, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
            picture = Cache.picture(set_battle_character_name 5, 1)
            if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
                picture = Cache.picture(set_battle_character_name 18, 1)
            end
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY - 50, picture, rect)
        when 86 # 師弟の絆(Z2)_キャラ現れる(放置)
            picture = Cache.picture(set_battle_character_name 5, 1)
            if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
                picture = Cache.picture(set_battle_character_name 18, 1)
            end
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY - 50, picture, rect)

        when 87 # 界王拳

            end_frame = 41
            picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
            attack_se = "Z1 打撃"
            case @effect_anime_frame
            when 0..4
                battle_anime_change 0, 7
                battle_anime_change 0, 11 if $super_saiyazin_flag[1] == true
            when 5..8
                battle_anime_change 0, 9
                battle_anime_change 0, 13 if $super_saiyazin_flag[1] == true
            when 9..12
                battle_anime_change 0, 10
                battle_anime_change 0, 14 if $super_saiyazin_flag[1] == true
            when 13..16
                battle_anime_change 0, 9
                battle_anime_change 0, 13 if $super_saiyazin_flag[1] == true
            when 17..20
                battle_anime_change 0, 10
                battle_anime_change 0, 14 if $super_saiyazin_flag[1] == true
            when 21..23
                battle_anime_change 0, 11
                battle_anime_change 0, 15 if $super_saiyazin_flag[1] == true
            when 24..26
                battle_anime_change 0, 12
                battle_anime_change 0, 16 if $super_saiyazin_flag[1] == true
            when 27..30
                battle_anime_change 0, 11
                battle_anime_change 0, 15 if $super_saiyazin_flag[1] == true
            when 31..33
                battle_anime_change 0, 9
                battle_anime_change 0, 13 if $super_saiyazin_flag[1] == true
            when 34..36
                battle_anime_change 0, 10
                battle_anime_change 0, 14 if $super_saiyazin_flag[1] == true
            when 37..40
                battle_anime_change 0, 12
                battle_anime_change 0, 16 if $super_saiyazin_flag[1] == true
            when 41..43
                battle_anime_change 0, 11
                battle_anime_change 0, 15 if $super_saiyazin_flag[1] == true
            else
                battle_anime_change 0, 10
                battle_anime_change 0, 14 if $super_saiyazin_flag[1] == true
            end

            if @effect_anime_frame % 4 == 0 && end_frame > @effect_anime_frame
                Audio.se_play("Audio/SE/" + attack_se) # 効果音を再生する
            end
        when 88 # サイコアタック
            if @btl_ani_cha_chg_no == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) # ダメージ表示用
            end
            rect = Rect.new(0, 4 * 96, 96, 96)

            rect = Rect.new(0, 5 * 96, 96, 96) if @effect_anime_frame > 21
            if @effect_anime_frame <= 21
                @back_window.contents.blt(STANDARD_ENEX + 60 - @effect_anime_frame * RAY_SPEED, STANDARD_CHAY - 24, picture,
                                          rect)
            else
                @back_window.contents.blt(STANDARD_ENEX + 74 - 21 * RAY_SPEED, STANDARD_CHAY - 8, picture, rect)
            end
        when 89 # スパーキングコンボキャラ現れる2人目上
            picture = Cache.picture(set_battle_character_name @scombo_cha2, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)

            rect = Rect.new(0, 0 * 96, 96, 96)
            ushirox = 0
            idouryou = 8
            @back_window.contents.blt(STANDARD_CHAX + @effect_anime_frame * idouryou + 30, STANDARD_CHAY - 50, picture,
                                      rect)
        when 90 # スパーキングコンボキャラ現れる2人目下
            picture = Cache.picture(set_battle_character_name @scombo_cha2, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)

            rect = Rect.new(0, 0 * 96, 96, 96)
            ushirox = 0
            idouryou = 8
            @back_window.contents.blt(STANDARD_CHAX + @effect_anime_frame * idouryou + 30, STANDARD_CHAY + 50, picture,
                                      rect)
        when 91 # スパーキングコンボキャラ現れる2人目放置(上)
            picture = Cache.picture(set_battle_character_name @scombo_cha2, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY - 50, picture, rect)
        when 92 # スパーキングコンボキャラ現れる2人目放置(下)
            picture = Cache.picture(set_battle_character_name @scombo_cha2, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
        when 93 # ダイナマイトキック

            end_frame = 50
            end_frame2 = 150
            tyousei_x = 0
            tyousei_y = 0
            if @btl_ani_cha_chg_no == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) # ダメージ表示用
            end
            attack_se = "Z1 打撃"
            case @effect_anime_frame

            when 0..7
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 8..15
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 16..23
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 24..31
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 32..39
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 40..47
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 51..60
                rect = Rect.new(0, 3 * 96, 96, 96)
                tyousei_x -= (@effect_anime_frame - end_frame) * 8
                tyousei_y -= (@effect_anime_frame - end_frame) * 4
            when 61..70
                rect = Rect.new(0, 4 * 96, 96, 96)
                tyousei_x -= (@effect_anime_frame - end_frame) * 8
                tyousei_y -= (@effect_anime_frame - end_frame) * 4
            when 71..80
                rect = Rect.new(0, 5 * 96, 96, 96)
                tyousei_x -= (@effect_anime_frame - end_frame) * 8
                tyousei_y -= (@effect_anime_frame - end_frame) * 4
            else
                rect = Rect.new(0, 0 * 96, 96, 96)

            end

            if @effect_anime_frame % 8 == 0 && end_frame > @effect_anime_frame
                Audio.se_play("Audio/SE/" + attack_se) # 効果音を再生する
            end

            # if @effect_anime_frame >= 61 && @effect_anime_frame <= 80
            #  @back_window.contents.blt(CENTER_CHAX-(@effect_anime_frame-60)*8,STANDARD_CHAY,picture,rect)
            # elsif @effect_anime_frame >= 81 && @effect_anime_frame <= 84
            #  @back_window.contents.blt(80+(@effect_anime_frame-80)*16,STANDARD_CHAY,picture,rect)
            # else #if @effect_anime_frame < 86
            # @back_window.contents.blt(CENTER_CHAX,STANDARD_CHAY,picture,rect)

            @back_window.contents.blt(TEC_CENTER_CHAX + tyousei_x, STANDARD_CHAY + tyousei_y, picture, rect)
            if end_frame == @effect_anime_frame
                # @enerect = Rect.new(0 , 0+(96*1), 96, 96)
                Audio.se_play("Audio/SE/" + "ZG 打撃2")
            end
        # end
        when 94 # 氷結攻撃
            if ray_x == 0 || ray_x == nil
                ray_x = 230
                ray_y = 120
            end
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_氷(FF3)") # ダメージ表示用

            rect = Rect.new(@effect_anime_type * 96, 0, 96, 96)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame == 8
                @effect_anime_type += 1
            elsif @effect_anime_frame == 16
                @effect_anime_type += 1
                # elsif @effect_anime_frame == 76
                #  @effect_anime_type += 1
            end
        when 95 # 亀仙流かめはめは_発動Z1
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(-44 + CENTER_CHAX - 120 + 8 - 28, -2 + STANDARD_CHAY + 4, picture, rect) # クリリン
            @back_window.contents.blt(172, 116, picture, rect)
            @back_window.contents.blt(310, 126, picture, rect)

            @back_window.contents.blt(-8 + CENTER_CHAX + 180 + 38 - 20, -6 + STANDARD_CHAY + 4, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 96 # 亀仙流かめはめは_発動Z2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大") # ダメージ表示用
            rect = Rect.new(0, 192, 192 + @effect_anime_frame * RAY_SPEED, 192)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
        when 97 # エネルギー弾系(正面)フォトンストライク
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            end

            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(212, 102, picture, rect)
            @back_window.contents.blt(288, 102, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 98 # エネルギー波大横(敵)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_敵_大") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 88)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 134 - 44, picture, rect)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 134 + 44, picture, rect)
            else
                rect = Rect.new(0, 88, 400, 88)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 134 + 44, picture, rect)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 134 - 44, picture, rect)
            end
        when 99 # 師弟の絆発動たま
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(250 - 94, 114, picture, rect)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(252 + 90, 122, picture, rect)

            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
        when 101 # 爆発小
            picture = Cache.picture("戦闘アニメ_爆発1") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 96, 0, 96, 96)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end

            if @damage_center == false
                if @attackDir == 0
                    @back_window.contents.blt(320, 120, picture, rect)
                else
                    @back_window.contents.blt(230, 120, picture, rect)
                end
            else
                if @attackDir == 0
                    @back_window.contents.blt(320 - 64, 120, picture, rect)
                else
                    @back_window.contents.blt(230, 120, picture, rect)
                end
            end
        when 102 # 爆発中
            picture = Cache.picture("戦闘アニメ_爆発3") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 112, 0, 112, 120)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
            if @damage_center == false
                if @attackDir == 0
                    @back_window.contents.blt(318, 120, picture, rect)
                else
                    @back_window.contents.blt(230, 120, picture, rect)
                end
            else
                if @attackDir == 0
                    @back_window.contents.blt(254, 120, picture, rect)
                else
                    @back_window.contents.blt(254, 120, picture, rect)
                end
            end
        when 103 # 爆発大
            picture = Cache.picture("戦闘アニメ_爆発4") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 176, 0, 176, 144)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
            if @damage_center == false
                if @attackDir == 0
                    @back_window.contents.blt(298, 120, picture, rect)
                else
                    @back_window.contents.blt(204, 120, picture, rect)
                end
            else
                if @attackDir == 0
                    @back_window.contents.blt(234, 120, picture, rect)
                else
                    @back_window.contents.blt(234, 120, picture, rect)
                end
            end
        when 104 # 爆発大Z2
            picture = Cache.picture("戦闘アニメ_爆発5") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 158, 0, 158, 160)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
            if @damage_center == false
                if @attackDir == 0
                    @back_window.contents.blt(298 - 16, 120 - 16, picture, rect)
                else
                    @back_window.contents.blt(204 - 16, 120 - 16, picture, rect)
                end
            else
                if @attackDir == 0
                    @back_window.contents.blt(298 - 16 - 64, 120 - 16, picture, rect)
                else
                    @back_window.contents.blt(204 - 16, 120 - 16, picture, rect)
                end
            end
        when 105 # 爆発特大Z2
            picture = Cache.picture("戦闘アニメ_爆発6") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 256, 0, 256, 256)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
            if @damage_center == false
                if @attackDir == 0
                    @back_window.contents.blt(298 - 64, 110 - 64, picture, rect)
                else
                    @back_window.contents.blt(204 - 56, 110 - 64, picture, rect)
                end
            else
                if @attackDir == 0
                    @back_window.contents.blt(298 - 64 - 64, 110 - 64, picture, rect)
                else
                    @back_window.contents.blt(204 - 56, 110 - 64, picture, rect)
                end
            end
        when 106 # 爆発大(縦センター
            picture = Cache.picture("戦闘アニメ_爆発4") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 176, 0, 176, 144)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
            if @attackDir == 0
                @back_window.contents.blt(270, 88, picture, rect)
            # @back_window.contents.blt(234,88,picture,rect)
            else
                @back_window.contents.blt(200, 88, picture, rect)
                # @back_window.contents.blt(214,88,picture,rect)
            end
        when 107 # 巻きつく

            if $cha_bigsize_on[@chanum] == true
                picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル") # ダメージ表示用
                rect = Rect.new(146, 38, 640, 26)
                @back_window.contents.blt(ray_x + 48, ray_y + 6, picture, rect)

                picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル_巻きつく(大)") # ダメージ表示用
                rect = Rect.new(0, 0, 128, 80)
                @back_window.contents.blt(ray_x - 72, ray_y - 12, picture, rect)

            else
                picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル") # ダメージ表示用
                rect = Rect.new(146, 38, 640, 26)
                @back_window.contents.blt(ray_x + 56, ray_y + 6, picture, rect)

                picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル_巻きつく") # ダメージ表示用
                rect = Rect.new(0, 0, 64, 40)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)

            end
        when 118 # 攻撃回避(任意位置攻撃側を巨大判定)

            if @effect_anime_frame % 4 == 0
                if @attackDir == 0
                    if $cha_bigsize_on[@chanum] != true
                        picture = Cache.picture("戦闘アニメ") # ダメージ表示
                        rect = Rect.new(0, 48, 64, 64)
                        @back_window.contents.blt(ray_x, ray_y, picture, rect)
                    else
                        picture = Cache.picture("戦闘アニメ96×96用回避") # ダメージ表示
                        rect = Rect.new(0, 0, 128, 128)
                        @back_window.contents.blt(ray_x - 32, ray_y - 32, picture, rect)
                    end

                # @back_window.contents.blt(@chax+96,@chay+32,picture,rectb)
                # @back_window.contents.blt(@enex+32,@eney+16+500,picture,rect)
                else
                    if $data_enemies[@enedatenum].element_ranks[23] != 1
                        picture = Cache.picture("戦闘アニメ") # ダメージ表示
                        rect = Rect.new(0, 48, 64, 64)
                        @back_window.contents.blt(ray_x, ray_y, picture, rect)
                    else
                        picture = Cache.picture("戦闘アニメ96×96用回避") # ダメージ表示
                        rect = Rect.new(0, 0, 128, 128)
                        @back_window.contents.blt(ray_x - 32, ray_y - 32, picture, rect)
                    end

                    # @back_window.contents.blt(@enex-96,@chay+32,picture,rectb)

                end

            end
        when 119 # 攻撃回避(任意位置防御側を巨大判定)

            if @effect_anime_frame % 4 == 0
                if @attackDir == 0

                    if $data_enemies[@enedatenum].element_ranks[23] != 1
                        picture = Cache.picture("戦闘アニメ") # ダメージ表示
                        rect = Rect.new(0, 48, 64, 64)
                        @back_window.contents.blt(ray_x, ray_y, picture, rect)
                    else
                        picture = Cache.picture("戦闘アニメ96×96用回避") # ダメージ表示
                        rect = Rect.new(0, 0, 128, 128)
                        @back_window.contents.blt(ray_x - 32, ray_y - 32, picture, rect)
                    end
                # @back_window.contents.blt(@chax+96,@chay+32,picture,rectb)
                # @back_window.contents.blt(@enex+32,@eney+16+500,picture,rect)
                else

                    if $cha_bigsize_on[@chanum] != true
                        picture = Cache.picture("戦闘アニメ") # ダメージ表示
                        rect = Rect.new(0, 48, 64, 64)
                        @back_window.contents.blt(ray_x, ray_y, picture, rect)
                    else
                        picture = Cache.picture("戦闘アニメ96×96用回避") # ダメージ表示
                        rect = Rect.new(0, 0, 128, 128)
                        @back_window.contents.blt(ray_x - 32, ray_y - 32, picture, rect)
                    end
                    # @back_window.contents.blt(@enex-96,@chay+32,picture,rectb)

                end

            end
        when 120 # 攻撃回避

            if @effect_anime_frame % 4 == 0
                if @attackDir == 0

                    if $data_enemies[@enedatenum].element_ranks[23] != 1
                        picture = Cache.picture("戦闘アニメ") # ダメージ表示
                        rect = Rect.new(0, 48, 64, 64)
                        @back_window.contents.blt(@enex + 32, @eney + 16 + 500, picture, rect)
                    else
                        picture = Cache.picture("戦闘アニメ96×96用回避") # ダメージ表示
                        rect = Rect.new(0, 0, 128, 128)
                        @back_window.contents.blt(@enex + 32, @eney + 16 + 500 - 32, picture, rect)
                    end
                # @back_window.contents.blt(@chax+96,@chay+32,picture,rectb)
                # @back_window.contents.blt(@enex+32,@eney+16+500,picture,rect)
                else

                    if $cha_bigsize_on[@chanum] != true
                        picture = Cache.picture("戦闘アニメ") # ダメージ表示
                        rect = Rect.new(0, 48, 64, 64)
                        @back_window.contents.blt(@chax + 8, @chay + 16 + 500, picture, rect)
                    else
                        picture = Cache.picture("戦闘アニメ96×96用回避") # ダメージ表示
                        rect = Rect.new(0, 0, 128, 128)
                        @back_window.contents.blt(@chax + 8 - 64, @chay + 16 + 500 - 32, picture, rect)
                    end
                    # @back_window.contents.blt(@enex-96,@chay+32,picture,rectb)

                end

            end
        when 121 # 攻撃ヒット
            picture = Cache.picture("戦闘アニメ") # ダメージ表示用
            rectb = Rect.new(32 * 0, 16, 32, 32)
            rectc = Rect.new(32, 0, 32, 16)
            if @effect_anime_frame >= 0 && @effect_anime_frame <= 4
                if @attackDir == 0
                    @back_window.contents.blt(@chax + 96, @chay + 32, picture, rectb)
                    if $data_enemies[@enedatenum].element_ranks[23] != 1
                        @back_window.contents.blt(@enex, @eney, picture, rectc)
                    else
                        @back_window.contents.blt(@enex, @eney - 48, picture, rectc)
                    end
                else
                    @back_window.contents.blt(@enex - 32, @eney + 32, picture, rectb)
                    @back_window.contents.blt(@chax + 64, @chay, picture, rectc)
                end
            elsif @effect_anime_frame >= 5 && @effect_anime_frame <= 10
                rectb = Rect.new(32 * 1, 16, 32, 32)
                if @attackDir == 0
                    @back_window.contents.blt(@chax + 96, @chay + 32, picture, rectb)
                    if $data_enemies[@enedatenum].element_ranks[23] != 1
                        @back_window.contents.blt(@enex, @eney, picture, rectc)
                    else
                        @back_window.contents.blt(@enex, @eney - 48, picture, rectc)
                    end
                else
                    @back_window.contents.blt(@enex - 32, @chay + 32, picture, rectb)
                    @back_window.contents.blt(@chax + 64, @chay, picture, rectc)
                end

            end
        when 122 # キャラぶつかる(センター)
            picture = Cache.picture("戦闘アニメ") # ダメージ表示用
            rectb = Rect.new(32, 16, 32, 32)
            @back_window.contents.blt(640 / 2 - 16, 480 / 2 - 90, picture, rectb)
        when 123 # キャラぶつかる自由位置
            picture = Cache.picture("戦闘アニメ") # ダメージ表示用

            if @effect_anime_frame >= 0 && @effect_anime_frame <= 4
                rectb = Rect.new(32 * 0, 16, 32, 32)
            elsif @effect_anime_frame >= 5 # && @effect_anime_frame <= 10
                rectb = Rect.new(32 * 1, 16, 32, 32)
            end
            @back_window.contents.blt(ray_x, ray_y, picture, rectb)
        when 124 # キラーン自由位置
            picture = Cache.picture("戦闘アニメ_キラーン") # ダメージ表示用

            if @effect_anime_frame >= 0 && @effect_anime_frame <= 7
                rect = Rect.new(32 * 0, 0, 32, 32)
            elsif @effect_anime_frame >= 8 && @effect_anime_frame <= 15
                rect = Rect.new(32 * 1, 0, 32, 32)
            elsif @effect_anime_frame >= 16 && @effect_anime_frame <= 23
                rect = Rect.new(32 * 2, 0, 32, 32)
            elsif @effect_anime_frame >= 24 && @effect_anime_frame <= 31
                rect = Rect.new(32 * 1, 0, 32, 32)
            elsif @effect_anime_frame >= 32 && @effect_anime_frame <= 39
                rect = Rect.new(32 * 0, 0, 32, 32)
            else
                rect = Rect.new(0, 0, 0, 0)
            end
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
        when 125 # 攻撃ヒット自由位置
            picture = Cache.picture("戦闘アニメ") # ダメージ表示用
            rectb = Rect.new(32 * 0, 16, 32, 32)
            rectc = Rect.new(32, 0, 32, 16)
            if @effect_anime_frame >= 0 && @effect_anime_frame <= 4
                if @attackDir == 0
                    @back_window.contents.blt(ray_x, ray_y, picture, rectb)
                # if $data_enemies[@enedatenum].element_ranks[23] != 1
                #  @back_window.contents.blt(ray_x,ray_y,picture,rectc)
                # else
                #  @back_window.contents.blt(ray_x,ray_y-48,picture,rectc)
                # end
                else
                    @back_window.contents.blt(ray_x, ray_y, picture, rectb)
                    # @back_window.contents.blt(ray_x+64,ray_y,picture,rectc)
                end
            elsif @effect_anime_frame >= 5 && @effect_anime_frame <= 10
                rectb = Rect.new(32 * 1, 16, 32, 32)
                if @attackDir == 0
                    @back_window.contents.blt(ray_x, ray_y, picture, rectb)
                # if $data_enemies[@enedatenum].element_ranks[23] != 1
                #  @back_window.contents.blt(ray_x,ray_y,picture,rectc)
                # else
                #  @back_window.contents.blt(ray_x,ray_y-48,picture,rectc)
                # end
                else
                    @back_window.contents.blt(ray_x, ray_y, picture, rectb)
                    # @back_window.contents.blt(ray_x+64,ray_y,picture,rectc)
                end

            end
        # Z2
        when 201 # エネルギー弾系(発動)
            @effect_anime_type = 2
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                if @ray_spd_up_flag == false
                    @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
                else
                    @back_window.contents.blt(ray_x + @effect_anime_frame * (RAY_SPEED + @ray_spd_up_num), ray_y, picture, rect)
                end
            else
                if @ray_spd_up_flag == false
                    @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
                else
                    @back_window.contents.blt(ray_x - @effect_anime_frame * (RAY_SPEED + @ray_spd_up_num), ray_y, picture, rect)
                end
            end

        # if @effect_anime_frame >= 10
        #  @effect_anime_type += 1
        #  @effect_anime_frame = 0
        # end
        when 202 # エネルギー弾系(ヒット)
            @effect_anime_type = 2
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 96, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 96, picture, rect)
            end
        when 203 # かめはめ波系(発動)
            # @effect_anime_type = 2
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2(青)") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 96, 64)
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 64, 96, 64)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 204 # かめはめ波系(ヒット)
            # @effect_anime_type = 2
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2(青)") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 0, 96, 64)
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 144, picture, rect)
            else
                rect = Rect.new(0, 64, 96, 64)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 144, picture, rect)
            end
        when 205 # 界王拳系(ヒット)
            # @effect_anime_type = 2
            if @ray_color == 0

                if $super_saiyazin_flag[1] == true
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_界王拳(超悟空)") # ダメージ表示用
                else
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_界王拳") # ダメージ表示用
                end
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_スピードアタック") # ダメージ表示用
            end
            # if @effect_anime_frame >= 10 && @effect_anime_type == 0
            # @effect_anime_type += 1
            # @effect_anime_frame = 0
            # elsif @effect_anime_frame >= 10 && @effect_anime_type == 1
            # @effect_anime_type = 0
            # @effect_anime_frame = 0
            # end
            if @attackDir == 0
                rect = Rect.new(0, 0, 236, 122)
                @back_window.contents.blt(-236 + @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            else
                rect = Rect.new(0, 0, 236, 122)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end
        when 206 # 界王拳かめはめ波系(発動)
            # @effect_anime_type = 2

            if $btl_progress < 2
                if @ray_color == 0

                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3") # ダメージ表示用
                elsif @ray_color == 1
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(緑)") # ダメージ表示用
                elsif @ray_color == 3
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(青)") # ダメージ表示用
                    # elsif @ray_color == 4
                    #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(桃)") #ダメージ表示用
                end
            else
                if @ray_color == 0

                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") # ダメージ表示用
                elsif @ray_color == 1
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(緑)") # ダメージ表示用
                elsif @ray_color == 3
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(青)") # ダメージ表示用
                elsif @ray_color == 4
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(桃)") # ダメージ表示用
                end
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 222, 134)
                rect = Rect.new(0, 0, 190, 126) if $btl_progress >= 2
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 128, 192, 128)
                rect = Rect.new(0, 126, 190, 126) if $btl_progress >= 2
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 207 # 界王拳かめはめ波系(ヒット)
            # @effect_anime_type = 2
            if $btl_progress < 2
                if @ray_color == 0

                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3") # ダメージ表示用
                elsif @ray_color == 1
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(緑)") # ダメージ表示用
                elsif @ray_color == 3
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(青)") # ダメージ表示用
                end
            else
                if @ray_color == 0
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") # ダメージ表示用
                elsif @ray_color == 1
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(緑)") # ダメージ表示用
                elsif @ray_color == 3
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(青)") # ダメージ表示用
                elsif @ray_color == 4
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(桃)") # ダメージ表示用
                end
            end
            if @attackDir == 0
                rect = Rect.new(0, 0, 222, 134)
                rect = Rect.new(0, 0, 190, 126) if $btl_progress >= 2
                @back_window.contents.blt(-192 + @effect_anime_frame * RAY_SPEED, 96, picture, rect)
            else
                rect = Rect.new(0, 128, 192, 128)
                rect = Rect.new(0, 126, 190, 126) if $btl_progress >= 2
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 96, picture, rect)
            end
        when 208 # 元気弾系(発動)
            @effect_anime_type = 3
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 209 # 元気弾系(ヒット)
            @effect_anime_type = 3
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 112, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 112, picture, rect)
            end
        when 210 # 超元気弾系(発動)
            @effect_anime_type = 5
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 211 # 超元気弾系(ヒット)
            @effect_anime_type = 5
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 112, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 112, picture, rect)
            end
        when 212 # 目から怪光線系(発動)
            @effect_anime_type = 1
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end

        when 213 # 目から怪光線系(ヒット)
            @effect_anime_type = 1
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 96, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 96, picture, rect)
            end
        when 214 # 魔貫光殺砲系(発動)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_魔貫光殺砲") # ダメージ表示用
            rect = Rect.new(0, 46, 54 + @effect_anime_frame * RAY_SPEED, 46)
            if @attackDir == 0
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            end

        when 215 # 魔貫光殺砲系(ヒット)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_魔貫光殺砲") # ダメージ表示用
            rect = Rect.new(0, 0, 400, 46)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 140, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 140, picture, rect)
            end
        when 216 # 拡散エネルギー波系(発動)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") # ダメージ表示用
            rect = Rect.new(0, 112, 54 + @effect_anime_frame * RAY_SPEED, 112)
            if @attackDir == 0
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            end

        when 217 # 拡散エネルギー波系(ヒット)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") # ダメージ表示用
            rect = Rect.new(0, 0, 400, 112)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 122, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 122, picture, rect)
            end
        when 218 # 気円斬系(発動)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") #ダメージ表示用
            picture = Cache.picture("Z2_戦闘_必殺技_気円斬") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, 0, 128, 44)
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 0, 128, 44)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 219 # 気円斬系(ヒット)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") #ダメージ表示用
            picture = Cache.picture("Z2_戦闘_必殺技_気円斬") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, 0, 192, 128)
                @back_window.contents.blt(-192 + @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            else
                rect = Rect.new(0, 0, 192, 128)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            end
        when 220 # 繰気弾系(発動)
            @effect_anime_type = 2
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 221 # 繰気弾系(ヒット)
            @effect_anime_type = 2
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end
        when 222 # 四身の拳

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") # ダメージ表示用
            case @effect_anime_frame

            when 0..30
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * @effect_anime_frame + 26, ray_y - 1 * @effect_anime_frame, picture,
                                          rect)
                @back_window.contents.blt(ray_x - 0.5 * @effect_anime_frame + 26, ray_y + 1 * @effect_anime_frame, picture,
                                          rect)
            when 31..59

                rect = Rect.new(0, 0 + (96 * 3), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                if @effect_anime_frame == 59
                    Audio.se_play("Audio/SE/" + "Z1 分身") # 効果音を再生する
                end
            when 60..120
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x + 0.5 * (@effect_anime_frame - 30) + 26, ray_y - 1 * (@effect_anime_frame - 30), picture,
                                          rect)
                @back_window.contents.blt(ray_x - 0.5 * (@effect_anime_frame - 30) + 26, ray_y + 1 * (@effect_anime_frame - 30), picture,
                                          rect)
            when 121..150
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x + 0.5 * 90 + 26, ray_y - 1 * 90, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 90 + 26, ray_y + 1 * 90, picture, rect)
            else
                if @effect_anime_frame == 151
                    # Audio.se_play("Audio/SE/" + "Z1 ザー")    # 効果音を再生する
                    Audio.se_play("Audio/SE/" + "Z3 エネルギー波") # 効果音を再生する
                end
                rect = Rect.new(0, 0 + (96 * 1), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 90 + 26, ray_y - 1 * 90, picture, rect)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 90 + 26, ray_y + 1 * 90, picture, rect)
                @effect_anime_type = 2
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
                rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
                if @attackDir == 0
                    @back_window.contents.blt(ray_x + 0.5 * 90 + 26 + (@effect_anime_frame - 150) * RAY_SPEED,
                                              ray_y - 20 - 1 * 90, picture, rect)
                    @back_window.contents.blt(ray_x + 0.5 * 30 + 26 + (@effect_anime_frame - 150) * RAY_SPEED,
                                              ray_y - 20 - 1 * 30, picture, rect)
                    @back_window.contents.blt(ray_x - 0.5 * 30 + 26 + (@effect_anime_frame - 150) * RAY_SPEED,
                                              ray_y - 20 + 1 * 30, picture, rect)
                    @back_window.contents.blt(ray_x - 0.5 * 90 + 26 + (@effect_anime_frame - 150) * RAY_SPEED,
                                              ray_y - 20 + 1 * 90, picture, rect)
                else
                    @back_window.contents.blt(ray_x - @effect_anime_frame - 150 * RAY_SPEED, ray_y, picture, rect)
                end
            end
        when 223 # エネルギー弾系(ヒット)
            @effect_anime_type = 2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, STANDARD_CHAY - 20 - 1 * 90 + @effect_anime_frame * 3,
                                          picture, rect)
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, STANDARD_CHAY - 20 - 1 * 30 + @effect_anime_frame * 1,
                                          picture, rect)
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, STANDARD_CHAY - 20 + 1 * 30 - @effect_anime_frame * 1,
                                          picture, rect)
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, STANDARD_CHAY - 20 + 1 * 90 - @effect_anime_frame * 3,
                                          picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, STANDARD_CHAY, picture, rect)
            end
        when 224 # 四身の拳

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") # ダメージ表示用
            case @effect_anime_frame

            when 0..30
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * @effect_anime_frame + 26, ray_y - 1 * @effect_anime_frame, picture,
                                          rect)
                @back_window.contents.blt(ray_x - 0.5 * @effect_anime_frame + 26, ray_y + 1 * @effect_anime_frame, picture,
                                          rect)
            when 31..59

                rect = Rect.new(0, 0 + (96 * 3), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                if @effect_anime_frame == 59
                    Audio.se_play("Audio/SE/" + "Z1 分身")    # 効果音を再生する
                end
            when 60..120
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x + 0.5 * (@effect_anime_frame - 30) + 26, ray_y - 1 * (@effect_anime_frame - 30), picture,
                                          rect)
                @back_window.contents.blt(ray_x - 0.5 * (@effect_anime_frame - 30) + 26, ray_y + 1 * (@effect_anime_frame - 30), picture,
                                          rect)
            when 121..150
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x + 0.5 * 90 + 26, ray_y - 1 * 90, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 90 + 26, ray_y + 1 * 90, picture, rect)
            else
                if @effect_anime_frame == 151
                    Audio.se_play("Audio/SE/" + "Z1 ザー")    # 効果音を再生する
                    # Audio.se_play("Audio/SE/" + "Z3 エネルギー波")    # 効果音を再生する
                end
                rect = Rect.new(0, 0 + (96 * 2), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 90 + 26, ray_y - 1 * 90, picture, rect)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 90 + 26, ray_y + 1 * 90, picture, rect)
                @effect_anime_type = 2
            end
        when 225 # エネルギー波_小系(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            end

            rect = Rect.new(0, 48, 54 + @effect_anime_frame * RAY_SPEED, 48)
            if @attackDir == 0
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new(352 - @effect_anime_frame * RAY_SPEED, 0, 48 + @effect_anime_frame * RAY_SPEED, 48)
                @back_window.contents.blt(ray_x - 92 - @effect_anime_frame * RAY_SPEED, ray_y - 10, picture, rect)
            end

        when 226 # エネルギー波_小系(ヒット)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            end
            rect = Rect.new(0, 0, 400, 48)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 148, picture, rect)
            else
                rect = Rect.new(0, 48, 400, 48)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 148, picture, rect)
            end
        when 227 # エネルギー波_小系(発動)敵
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_緑") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_赤") # ダメージ表示用
            end
            # rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
            if @attackDir == 0
                rect = Rect.new(0, 48, 54 + @effect_anime_frame * RAY_SPEED, 48)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new(352 - @effect_anime_frame * RAY_SPEED, 0, 48 + @effect_anime_frame * RAY_SPEED, 48)
                @back_window.contents.blt(ray_x - 92 - @effect_anime_frame * RAY_SPEED, ray_y - 10, picture, rect)
            end
        when 228 # エネルギー波_小系(ヒット敵)敵
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_緑") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_赤") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 48)
                @back_window.contents.blt(-450 + @effect_anime_frame * RAY_SPEED, 148, picture, rect)
            else
                rect = Rect.new(0, 48, 400, 48)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED + 64, 148, picture, rect)
            end
        when 229 # 衝撃波系(発動)敵
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系_赤") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 30, 116)
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 116, 30, 116)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 230 # 衝撃波系(ヒット)敵
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系_赤") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 30, 116)
                @back_window.contents.blt(-64 + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 116, 30, 116)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 231 # 拡散エネルギー波系(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_青_敵") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_赤_敵") # ダメージ表示用
            end
            rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 112, 54 + @effect_anime_frame * RAY_SPEED, 112)
            if @attackDir == 0
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end

        when 232 # 拡散エネルギー波系(ヒット)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_青_敵") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_赤_敵") # ダメージ表示用
            end

            rect = Rect.new(0, 0, 400, 112)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 122, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 122, picture, rect)
            end
        when 233 # 口から怪光線ドドリア系(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 234 # 口から怪光線ドドリア系(ヒット)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_緑") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 80)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 80, 400, 80)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 235 # スーパーカメハメ波ため
            if @ray_color == 3
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)(青)") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)(緑)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)(赤)") # ダメージ表示用
            else
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)") # ダメージ表示用
            end
            rect = Rect.new(32 * @ray_anime_type, 0, 32, 32)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @ray_anime_frame >= 4 && @ray_anime_type != 4
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 4
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 236 # スーパーカメハメ波発動
            if @attackDir == 0 && mirror_pattern == 0
                if @ray_color == 0
                    picture = Cache.picture("Z3_必殺技_超カメハメ波") # ダメージ表示用
                elsif @ray_color == 3
                    picture = Cache.picture("Z3_必殺技_超カメハメ波_青") # ダメージ表示用
                end
            else
                if @ray_color == 0
                    picture = Cache.picture("Z3_必殺技_超カメハメ波_反転") # ダメージ表示用
                elsif @ray_color == 3
                    picture = Cache.picture("Z3_必殺技_超カメハメ波_青_反転") # ダメージ表示用
                end
            end

            if @attackDir == 0 && mirror_pattern == 0
                rect = Rect.new(0, 0, 54 + @effect_anime_frame * RAY_SPEED, 350)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                if 500 - 54 - @effect_anime_frame * RAY_SPEED <= 500
                    rect = Rect.new(500 - 54 - @effect_anime_frame * RAY_SPEED, 0, 500 - 54 + @effect_anime_frame * RAY_SPEED,
                                    350)
                else
                    rect = Rect.new(0, 0, 500, 350)
                end
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            end
        when 237 # ファイナルリベンジャーため(小)
            if @ray_color == 3
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅小)(青)") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅小)(緑)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅小)(赤)") # ダメージ表示用
            else
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅小)") # ダメージ表示用
            end
            rect = Rect.new(16 * @ray_anime_type, 0, 16, 16)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @ray_anime_frame >= 4 && @ray_anime_type != 4
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 4
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 238
            # @effect_anime_type = 2

            if $super_saiyazin_flag[7] == true
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ファイナルリベンジャー_超") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ファイナルリベンジャー") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(236 * @ray_anime_type, 0, 236, 122)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new(0, 0, 236, 122)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end
            if @ray_anime_frame >= 8 && @ray_anime_type == 0
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 8
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 239 # エネルギーは大(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                if @ray_color == 0
                    rect = Rect.new(0, 92, 144 + @effect_anime_frame * RAY_SPEED, 92)
                elsif @ray_color == 1
                    rect = Rect.new(0, 92, 144 + @effect_anime_frame * RAY_SPEED, 92)
                elsif @ray_color == 3
                    rect = Rect.new(0, 122, 144 + @effect_anime_frame * RAY_SPEED, 122)
                elsif @ray_color == 4
                    rect = Rect.new(0, 122, 144 + @effect_anime_frame * RAY_SPEED, 122)
                end
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                if @ray_color == 0
                    rect = Rect.new(256 - @effect_anime_frame * RAY_SPEED, 0, 144 + @effect_anime_frame * RAY_SPEED, 92)
                elsif @ray_color == 1
                    rect = Rect.new(256 - @effect_anime_frame * RAY_SPEED, 0, 144 + @effect_anime_frame * RAY_SPEED, 92)
                elsif @ray_color == 3
                    rect = Rect.new(256 - @effect_anime_frame * RAY_SPEED, 0, 144 + @effect_anime_frame * RAY_SPEED, 122)
                elsif @ray_color == 4
                    rect = Rect.new(256 - @effect_anime_frame * RAY_SPEED, 0, 144 + @effect_anime_frame * RAY_SPEED, 122)
                end
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 240 # エネルギーは大(ヒット)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大_敵_赤") # ダメージ表示用
            end

            if @attackDir == 0
                if @ray_color == 0
                    rect = Rect.new(0, 0, 400, 92)
                elsif @ray_color == 1
                    rect = Rect.new(0, 0, 400, 92)
                elsif @ray_color == 3
                    rect = Rect.new(0, 0, 400, 122)
                elsif @ray_color == 4
                    rect = Rect.new(0, 0, 400, 122)
                end

                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                if @ray_color == 0
                    rect = Rect.new(0, 92, 400, 92)
                elsif @ray_color == 1
                    rect = Rect.new(0, 92, 400, 92)
                elsif @ray_color == 3
                    rect = Rect.new(0, 122, 400, 122)
                elsif @ray_color == 4
                    rect = Rect.new(0, 122, 400, 122)
                end

                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 241 # 拡散エネルギー波系(発動)
            if @ray_anime_type == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_青_敵") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_赤_敵") # ダメージ表示用
            end

            rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 112, 54 + @effect_anime_frame * RAY_SPEED, 112)

            if @attackDir == 0
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end

            if @ray_anime_frame >= 2 && @ray_anime_type != 2
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 2
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end

        when 242 # 拡散エネルギー波系(ヒット)
            if @ray_anime_type == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_青_敵") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_赤_敵") # ダメージ表示用
            end

            rect = Rect.new(0, 0, 400, 112)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 122, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 122, picture, rect)
            end

            if @ray_anime_frame >= 2 && @ray_anime_type != 2
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 2
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 243 # 気円斬系(ヒット)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 0, 192, 128)
                @back_window.contents.blt(-192 - 220 + @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            else
                rect = Rect.new(0, 128, 192, 128)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 150, picture, rect)
            end
        when 244 # ダブルどどんぱ(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            end

            # rect = Rect.new(0, 48,54+@effect_anime_frame*RAY_SPEED,48)
            if @attackDir == 0
                rect = Rect.new(0, 48, 54 + @effect_anime_frame * (RAY_SPEED + 2), 48)
                if $btl_progress < 2
                    @back_window.contents.blt(328, 148 - 50, picture, rect)
                else
                    @back_window.contents.blt(322, 148 - 42, picture, rect)
                end
                rect = Rect.new(0, 48, 54 + @effect_anime_frame * RAY_SPEED, 48)
                if $btl_progress < 2
                    @back_window.contents.blt(350, 148 + 32, picture, rect)
                else
                    @back_window.contents.blt(366, 148 + 34, picture, rect)
                end
            else
                rect = Rect.new(352 - @effect_anime_frame * RAY_SPEED, 0, 48 + @effect_anime_frame * RAY_SPEED, 48)
                @back_window.contents.blt(ray_x - 92 - @effect_anime_frame * RAY_SPEED, ray_y - 10, picture, rect)
            end

        when 245 # ダブルどどんぱ(ヒット)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            end
            rect = Rect.new(0, 0, 400, 48)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 148 + 24, picture, rect)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 148 - 24, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 148, picture, rect)
            end
        when 246 # 師弟の絆(発動)
            # @effect_anime_type = 2

            if $btl_progress < 2
                rect = Rect.new(0, 0, 192, 128)
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3") # ダメージ表示用
                @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 96 - 46 + 1 * @effect_anime_frame, picture,
                                          rect)

                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(緑)") # ダメージ表示用
                @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 96 + 42 - 1 * @effect_anime_frame, picture,
                                          rect)

            else
                rect = Rect.new(0, 0, 190, 126)
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") # ダメージ表示用
                @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 98 - 46 + 1 * @effect_anime_frame, picture,
                                          rect)
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(緑)") # ダメージ表示用
                @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 98 + 50 - 1 * @effect_anime_frame, picture,
                                          rect)

            end
        when 247 # 師弟の絆(ヒット)
            if $btl_progress < 2
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(師弟の絆)") # ダメージ表示用
                rect = Rect.new(0, @ray_anime_type * 134, 222, 134)
                @back_window.contents.blt(-192 + @effect_anime_frame * RAY_SPEED, 104, picture, rect)
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(師弟の絆)") # ダメージ表示用
                rect = Rect.new(0, @ray_anime_type * 126, 190, 126)
                @back_window.contents.blt(-192 + @effect_anime_frame * RAY_SPEED, 126, picture, rect)

            end
            if @ray_anime_frame >= 8 && @ray_anime_type == 0
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 8
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 248 # サイヤンアタック界王拳系(追いかけ)
            # @effect_anime_type = 2
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_界王拳") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_スピードアタック") # ダメージ表示用
            end
            # if @effect_anime_frame >= 10 && @effect_anime_type == 0
            # @effect_anime_type += 1
            # @effect_anime_frame = 0
            # elsif @effect_anime_frame >= 10 && @effect_anime_type == 1
            # @effect_anime_type = 0
            # @effect_anime_frame = 0
            # end
            if @attackDir == 0
                rect = Rect.new(0, 0, 236, 122)
                @back_window.contents.blt(-236 + @effect_anime_frame * RAY_SPEED * 3, 120 - 20 - @effect_anime_frame * 2,
                                          picture, rect)
            else
                rect = Rect.new(0, 0, 236, 122)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end
        when 249 # ギャリックカメハメは(発動)Z2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") # ダメージ表示用
            rect = Rect.new(0, 80, 80 + @effect_anime_frame * (RAY_SPEED + 2), 80)
            rect = Rect.new(0, 80, 80 + 5 * (RAY_SPEED + 2), 80) if @effect_anime_frame >= 5
            @back_window.contents.blt(160, 118, picture, rect)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            if @effect_anime_frame < 5
                rect = Rect.new(314 - @effect_anime_frame * RAY_SPEED, 0, 86 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(396 - @effect_anime_frame * RAY_SPEED, 118, picture, rect)
            else
                rect = Rect.new(314 - 5 * RAY_SPEED, 0, 86 + 5 * RAY_SPEED, 80)
                @back_window.contents.blt(396 - 5 * RAY_SPEED, 118, picture, rect)
            end
            # p @effect_anime_frame
        when 250 # ギャリックカメハメは(発動2)Z2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") # ダメージ表示用
            rect = Rect.new(0, 0, 400, 80)
            @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            rect = Rect.new(80, 80, 320, 80)
            @back_window.contents.blt(-720 + @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            @back_window.contents.blt(-1040 + @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            @back_window.contents.blt(-1360 + @effect_anime_frame * RAY_SPEED, 76, picture, rect)

            rect = Rect.new(0, 80, 400, 80)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 160, picture, rect)
            rect = Rect.new(112, 80, 288, 80)
            @back_window.contents.blt(928 - @effect_anime_frame * RAY_SPEED, 160, picture, rect)
            @back_window.contents.blt(1216 - @effect_anime_frame * RAY_SPEED, 160, picture, rect)
            @back_window.contents.blt(1504 - @effect_anime_frame * RAY_SPEED, 160, picture, rect)
            # p @effect_anime_frame
        when 251 # ギャリックカメハメは(発動2)Z2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") # ダメージ表示用
            rect = Rect.new(0, 0, 400, 80)
            @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 134, picture, rect)

            rect = Rect.new(0, 80, 400, 80)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 134, picture, rect)

            # p @effect_anime_frame
        when 252 # 元気玉ため
            if @ray_color == 3
                picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)(青)") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)(緑)") # ダメージ表示用
            else
                picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)") # ダメージ表示用
            end
            rect = Rect.new(64 * @ray_anime_type, 0, 64, 64)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @ray_anime_frame >= 4 && @ray_anime_type != 3
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 4
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 253 # 超元気玉ため

            picture = Cache.picture("Z3_戦闘_必殺技_超元気玉_溜め") # ダメージ表示用

            rect = Rect.new(0, @ray_anime_type * 110, 246, 110)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @ray_anime_frame >= 20 && @ray_anime_type != 5
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 4 && @ray_anime_type == 5
                @ray_anime_type = 4
                @ray_anime_frame = 0
            end
        when 254 # まかんこうさっぽう発動

            picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲(発動)") # ダメージ表示用

            rect = Rect.new(@ray_anime_type * 166, 0, 166, 176)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @ray_anime_frame >= 2 && @ray_anime_type != 1
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 2 && @ray_anime_type == 1
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 255 # Z3まかんこうさっぽう(ヒット)
            picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") # ダメージ表示用

            rect = Rect.new(0, 0, 400, 64)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 64, 400, 64)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 256 # Z3エネルギー波半円発動
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(青)") # ダメージ表示用
            elsif @ray_color == 9
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(紫)") # ダメージ表示用
            end

            if @attackDir == 0 && mirror_pattern == 0
                rect = Rect.new(0, 0, @effect_anime_frame * RAY_SPEED, 128)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new(700 - @effect_anime_frame * RAY_SPEED, 128, @effect_anime_frame * RAY_SPEED, 128)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 257 # エネルギー波縦発動

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_縦") # ダメージ表示用
            rect = Rect.new(0, 0, 60, @effect_anime_frame * RAY_SPEED + 56)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
        when 258 # エネルギー波縦ヒット

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_縦") # ダメージ表示用
            rect = Rect.new(60, 0, 60, 400)
            @back_window.contents.blt(ray_x, ray_y + @effect_anime_frame * RAY_SPEED, picture, rect)
        when 259 # エネルギー波縦ヒット

            picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)") # ダメージ表示用
            rect = Rect.new(0, 0, 32, 32)
            @back_window.contents.blt(ray_x, ray_y + @effect_anime_frame * RAY_SPEED / 2, picture, rect)
        when 260 # Z3気円斬系(ヒット)
            picture = Cache.picture("Z3_戦闘_必殺技_気円斬") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 30 * 4, 126, 30)
                @back_window.contents.blt(-192 + @effect_anime_frame * RAY_SPEED, 160, picture, rect)
            else
                rect = Rect.new(0, 30 * 4, 192, 30)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 160, picture, rect)
            end
        when 261 # そうきだんため
            if @ray_color == 3
                picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)(青)") # ダメージ表示用
            else
                picture = Cache.picture("Z3_必殺技_繰気弾(球点滅中)") # ダメージ表示用
            end
            rect = Rect.new(64 * @ray_anime_type, 0, 64, 64)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
        when 262 # そうきだん(ヒット)
            if @ray_color == 3
                picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)(青)") # ダメージ表示用
                rect = Rect.new(64 * 3, 0, 64, 64)
            elsif @ray_color == 1
                picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)(緑)") # ダメージ表示用
                rect = Rect.new(64 * 3, 0, 64, 64)
            else
                picture = Cache.picture("Z3_必殺技_繰気弾(球点滅中)") # ダメージ表示用
                rect = Rect.new(64 * 5, 0, 64, 64)
            end

            if @attackDir == 0
                @back_window.contents.blt(-192 + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else

                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 263 # 四身の拳

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") # ダメージ表示用
            case @effect_anime_frame

            when 0..15
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 4 * @effect_anime_frame + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - 4 * @effect_anime_frame + 26, ray_y, picture, rect)
            when 16..29

                rect = Rect.new(0, 0 + (96 * 3), 96, 96)
                @back_window.contents.blt(ray_x + 4 * 15 + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - 4 * 15 + 26, ray_y, picture, rect)
            # if @effect_anime_frame == 59
            #  Audio.se_play("Audio/SE/" + "Z1 分身")    # 効果音を再生する
            # end
            when 30..60
                # p @effect_anime_frame
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 4 * 15 + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - 4 * 15 + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x + 4 * (@effect_anime_frame - 15) + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - 4 * (@effect_anime_frame - 15) + 26, ray_y, picture, rect)
            when 61..75
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 4 * 15 + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - 4 * 15 + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x + 4 * 45 + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - 4 * 45 + 26, ray_y, picture, rect)
            when 76..110
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 4 * 15 + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x + 4 * 45 + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - 4 * 45 + 26, ray_y, picture, rect)
                rect = Rect.new(0, 0 + (96 * 6), 96, 96)
                @back_window.contents.blt(ray_x - 4 * 15 + 26 - 2 * (@effect_anime_frame - 75), ray_y - 8 * (@effect_anime_frame - 75), picture,
                                          rect)
            when 111..145
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 4 * 45 + 26, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - 4 * 45 + 26, ray_y, picture, rect)
                rect = Rect.new(0, 0 + (96 * 0), 96, 96)
                @back_window.contents.blt(ray_x + 4 * 15 + 26 + 2 * (@effect_anime_frame - 111), ray_y - 8 * (@effect_anime_frame - 111), picture,
                                          rect)
            when 146..180
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 4 * 45 + 26, ray_y, picture, rect)
                rect = Rect.new(0, 0 + (96 * 6), 96, 96)
                @back_window.contents.blt(ray_x - 4 * 45 + 26 - 2 * (@effect_anime_frame - 146), ray_y - 8 * (@effect_anime_frame - 146), picture,
                                          rect)
            when 181..215
                rect = Rect.new(0, 0 + (96 * 0), 96, 96)
                @back_window.contents.blt(ray_x + 4 * 45 + 26 + 2 * (@effect_anime_frame - 181), ray_y - 8 * (@effect_anime_frame - 181), picture,
                                          rect)
            end
        when 264 # ビッグバンアタック
            if @ray_color == 3
                if @attackDir == 0
                    picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動(青)") # ダメージ表示用
                else
                    picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動(青)_反転") # ダメージ表示用
                end
            elsif @ray_color == 1
                if @attackDir == 0
                    picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動(緑)") # ダメージ表示用
                else
                    picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動(緑)_反転") # ダメージ表示用
                end
            else
                if @attackDir == 0
                    picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動") # ダメージ表示用
                else
                    picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動_反転") # ダメージ表示用
                end
            end
            if @attackDir == 0
                rect = Rect.new(302 * @ray_anime_type, 0, 302, 200)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new(302 * @ray_anime_type, 0, 302, 200)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            end
            if @ray_anime_frame >= 4 && @ray_anime_type != 1
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 4 && @ray_anime_type == 1
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 265 # Z3エネルギー波半円ヒット
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(青)") # ダメージ表示用
            elsif @ray_color == 9
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(紫)") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 128, 700, 128)
                @back_window.contents.blt(-700 + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 0, 700, 128)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 266 # Z3エネルギー弾ヒット
            if @ray_color == 0
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(桃)") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 190, 126)
                @back_window.contents.blt(-162 + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 126, 190, 126)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 267 # Z3_戦闘_必殺技_剣攻撃
            if @attackDir == 0
                picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃") # ダメージ表示用
            else
                picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(左右反転)") # ダメージ表示用
            end

            rect = Rect.new(160 * @ray_anime_type, 0, 160, 96)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)

            if @ray_anime_frame >= 2 # && @ray_anime_type != 6
                @ray_anime_type += 1
                @ray_anime_frame = 0
            end
        when 268 # Z3_戦闘_必殺技_剣攻撃上下反転
            if @attackDir == 0
                picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(上下反転)") # ダメージ表示用
            else
                picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(上下左右反転)") # ダメージ表示用
            end

            rect = Rect.new(160 * @ray_anime_type, 0, 160, 96)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)

            if @ray_anime_frame >= 2 # && @ray_anime_type != 6
                @ray_anime_type += 1
                @ray_anime_frame = 0
            end
        when 269 # Z3_戦闘_必殺技_剣攻撃縦
            if @attackDir == 0
                picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(縦)") # ダメージ表示用
            else
                picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(左右反転)") # ダメージ表示用
            end

            rect = Rect.new(96 * @ray_anime_type, 0, 96, 160)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)

            if @ray_anime_frame >= 2 # && @ray_anime_type != 6
                @ray_anime_type += 1
                @ray_anime_frame = 0
            end
        when 270 # Z3_戦闘_必殺技_剣攻撃縦上下反転
            if @attackDir == 0
                picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(縦上下反転)") # ダメージ表示用
            else
                picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(上下左右反転)") # ダメージ表示用
            end

            rect = Rect.new(96 * @ray_anime_type, 0, 96, 160)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)

            if @ray_anime_frame >= 2 # && @ray_anime_type != 6
                @ray_anime_type += 1
                @ray_anime_frame = 0
            end
        when 271 # デスボール系(ヒット)

            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 112, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 112, picture, rect)
            end
        when 272 # Z3まかんこうさっぽう(発動横)
            picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") # ダメージ表示用

            rect = Rect.new(0, 0, 400, 64)
            if @attackDir == 0
                rect = Rect.new(0, 64, 64 + @effect_anime_frame * RAY_SPEED, 64)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new((400 - 64) - @effect_anime_frame * RAY_SPEED, 0, (400 - 64) + @effect_anime_frame * RAY_SPEED,
                                64)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 273 # ロケットパンチ(発動)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ロケットパンチ") # ダメージ表示用

            shake_dot = 4
            shakex, shakey = pic_shake_cal shake_dot

            if @effect_anime_frame != 0
                shakex, shakey = 0, 0
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 24, 14)
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED + shakex, ray_y + shakey, picture, rect)
            else
                rect = Rect.new(0, 14, 24, 14)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED + shakex, ray_y + shakey, picture, rect)
            end
        when 274 # ロケットパンチ(ヒット)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ロケットパンチ") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 0, 24, 14)
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 144, picture, rect)
            else
                rect = Rect.new(0, 14, 24, 14)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 144, picture, rect)
            end
        when 275 # ヘルズフラッシュ発動
            if @attackDir == 0
                if @ray_color == 0
                    picture = Cache.picture("Z3_必殺技_超カメハメ波") # ダメージ表示用
                elsif @ray_color == 3
                    picture = Cache.picture("Z3_必殺技_超カメハメ波_青") # ダメージ表示用
                end
            else
                if @ray_color == 0
                    picture = Cache.picture("Z3_必殺技_超カメハメ波_反転") # ダメージ表示用
                elsif @ray_color == 3
                    picture = Cache.picture("Z3_必殺技_超カメハメ波_青_反転") # ダメージ表示用
                end
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 54 + @effect_anime_frame * RAY_SPEED, 350)
                # @back_window.contents.blt(ray_x-76,ray_y-50,picture,rect)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)

            else
                if 500 - 54 - @effect_anime_frame * RAY_SPEED <= 500
                    rect = Rect.new(500 - 54 - @effect_anime_frame * RAY_SPEED, 0, 500 - 54 + @effect_anime_frame * RAY_SPEED,
                                    350)
                else
                    rect = Rect.new(0, 0, 500, 350)
                end
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            end
        when 276 # Z3そうきえんざん(発動)
            picture = Cache.picture("Z3_戦闘_必殺技_気円斬") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 30 * 4, 126, 30)
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 30 * 4, 192, 30)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 277 # Z3そうきえんざん(ヒット)
            picture = Cache.picture("Z3_戦闘_必殺技_気円斬") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 30 * 4, 126, 30)
                @back_window.contents.blt(-192 - 220 + @effect_anime_frame * RAY_SPEED, 160, picture, rect)
            else
                rect = Rect.new(0, 30 * 4, 192, 30)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 160, picture, rect)
            end
        when 278 # ファイナルフラッシュため
            picture = Cache.picture("ZG_戦闘_必殺技_ファイナルフラッシュ弾") # ダメージ表示用
            rect = Rect.new(32 * @ray_anime_type, 0, 32, 32)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @ray_anime_frame >= 4 && @ray_anime_type != 4
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 4 && @ray_anime_type == 4
                # @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 279 # 気の開放エネルギー弾(発動)
            @effect_anime_type = 2
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                if @ray_spd_up_flag == false
                    @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
                    @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y + 64, picture, rect)
                else
                    @back_window.contents.blt(ray_x + @effect_anime_frame * (RAY_SPEED + @ray_spd_up_num), ray_y, picture, rect)
                    @back_window.contents.blt(ray_x + @effect_anime_frame * (RAY_SPEED + @ray_spd_up_num), ray_y + 64, picture,
                                              rect)
                end
            else
                if @ray_spd_up_flag == false
                    @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
                else
                    @back_window.contents.blt(ray_x - @effect_anime_frame * (RAY_SPEED + @ray_spd_up_num), ray_y, picture, rect)
                end
            end

        # if @effect_anime_frame >= 10
        #  @effect_anime_type += 1
        #  @effect_anime_frame = 0
        # end
        when 280 # 気の開放エネルギー弾(ヒット)
            @effect_anime_type = 2
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 32 + 54, picture, rect)
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 32 + 40 + 54, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 96, picture, rect)
            end
        when 281 # どどはめは(発動)
            picture = Cache.picture("Z3_戦闘_必殺技_どどはめはエネルギー波") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 0, 144 + @effect_anime_frame * RAY_SPEED, 204)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new(256 - @effect_anime_frame * RAY_SPEED, 0, 144 + @effect_anime_frame * RAY_SPEED, 122)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 282 # どどはめは(ヒット)
            picture = Cache.picture("Z3_戦闘_必殺技_どどはめはエネルギー波_ヒット") # ダメージ表示用

            rect = Rect.new(0, 0, 400, 128)
            if @attackDir == 0
                @back_window.contents.blt(-20 - 400 + @effect_anime_frame * RAY_SPEED, 32 + 54 + 24, picture, rect)
            # @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,32+40+54,picture,rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 96, picture, rect)
            end

        when 283 # Z2_エネルギー液発動
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(緑)") # ダメージ表示用
            elsif @ray_color == 2
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(水色)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(桃)") # ダメージ表示用
            end

            if @attackDir == 0 && mirror_pattern == 0
                rect = Rect.new(0, 32, 24 + @effect_anime_frame * RAY_SPEED, 32)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new(400 - @effect_anime_frame * RAY_SPEED, 0, @effect_anime_frame * RAY_SPEED, 32)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 284 # エネルギー波_小系(発動)敵(イベント用強制敵側)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_緑") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_赤") # ダメージ表示用
            end
            # rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
            rect = Rect.new(352 - @effect_anime_frame * RAY_SPEED, 0, 48 + @effect_anime_frame * RAY_SPEED, 48)
            @back_window.contents.blt(ray_x - 92 - @effect_anime_frame * RAY_SPEED, ray_y - 10, picture, rect)
        when 285 # エネルギー波_小系(ヒット敵)敵(イベント用強制敵側)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_緑") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_赤") # ダメージ表示用
            end

            rect = Rect.new(0, 48, 400, 48)
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED + 64, 148, picture, rect)
        when 286 # 爆発大(イベント用強制味方側)
            picture = Cache.picture("戦闘アニメ_爆発4") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 176, 0, 176, 144)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end
            if @damage_center == false
                @back_window.contents.blt(204, 120, picture, rect)
            else
                @back_window.contents.blt(234, 120, picture, rect)
            end
        when 287 # 爆発大Z2(イベント用強制味方側)
            picture = Cache.picture("戦闘アニメ_爆発5") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 158, 0, 158, 160)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1
                @effect_anime_frame = 0
            end

            @back_window.contents.blt(ray_x, ray_y, picture, rect)
        when 288 # 高速移動(イベント用)
            if @effect_anime_frame % 4 == 0
                picture = Cache.picture("戦闘アニメ") # ダメージ表示用
                rect = Rect.new(0, 48, 64, 64)
                @back_window.contents.blt(CENTER_ENEX - 66, STANDARD_ENEY + 26, picture, rect)
            end
        when 289 # スピリッツキャノン一枚絵用
            if @ray_color == 3
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅大)(青)") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅大)(緑)") # ダメージ表示用
            else
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅大)") # ダメージ表示用
            end
            rect = Rect.new(64 * @ray_anime_type, 0, 64, 64)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @ray_anime_frame >= 4 && @ray_anime_type != 4
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 4
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 290 # アクセルダンスエネルギー波ため
            if @ray_color == 3
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)(青)") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)(緑)") # ダメージ表示用
            else
                picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)") # ダメージ表示用
            end
            rect = Rect.new(32 * @ray_anime_type, 0, 32, 32)
            @back_window.contents.blt(270, 164, picture, rect)
            @back_window.contents.blt(340, 164, picture, rect)
            if @ray_anime_frame >= 4 && @ray_anime_type != 4
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 4
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 291 # ヒートドームアタック(発動
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_緑") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_赤") # ダメージ表示用
            end

            rect = Rect.new(0, 800 - 140 - @effect_anime_frame * RAY_SPEED, 192, 140 + @effect_anime_frame * RAY_SPEED)
            @back_window.contents.blt(ray_x, ray_y - @effect_anime_frame * RAY_SPEED, picture, rect)
        when 292 # ヒートドームアタック(ヒット
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_緑") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_赤") # ダメージ表示用
            end
            rect = Rect.new(0, 0, 192, 400)
            @back_window.contents.blt(ray_x, ray_y - @effect_anime_frame * RAY_SPEED, picture, rect)
        when 293 # Z3エネルギー弾発動
            if @ray_color == 0
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(桃)") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 0, 190, 126)
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 126, 190, 126)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 294 # 繰気弾系(ヒット)
            @effect_anime_type = 4
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            # elsif @ray_color == 1
            #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 114, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 114, picture, rect)
            end
        when 295 # Z3エネルギー波_特大発動
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_緑") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_青") # ダメージ表示用
            end

            if @attackDir == 0
                rect = Rect.new(0, 192, 192 + @effect_anime_frame * RAY_SPEED, 192)

                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                # p @effect_anime_frame,400-192-@effect_anime_frame*RAY_SPEED
                # rect = Rect.new(400-192-@effect_anime_frame*RAY_SPEED, 0,400-192-@effect_anime_frame*RAY_SPEED,192)
                rect = Rect.new(400 - 192 - @effect_anime_frame * RAY_SPEED, 0, 400 - 192 + @effect_anime_frame * RAY_SPEED,
                                192)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 296 # エネルギー波_中Z2以降(発動)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 297 # エネルギー波_中Z2以降(ヒット)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 80)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 80, 400, 80)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 298 # ノンステップバイオレンスエネルギー波_小系(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            end

            rect = Rect.new(0, 48, 54 + @effect_anime_frame * RAY_SPEED, 48)
            if @attackDir == 0
                @back_window.contents.blt(@chax + 72, @chay + 16, picture, rect)
                @back_window.contents.blt(@chax + 80, @chay + 112, picture, rect)
            else
                rect = Rect.new(352 - @effect_anime_frame * RAY_SPEED, 0, 48 + @effect_anime_frame * RAY_SPEED, 48)
                @back_window.contents.blt(ray_x - 92 - @effect_anime_frame * RAY_SPEED, ray_y - 10, picture, rect)
            end
        when 299 # ノンステップバイオレンスエネルギー波_小系(ヒット)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            end
            rect = Rect.new(0, 0, 400, 48)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 148 - 24, picture, rect)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 148 + 24, picture, rect)
            else
                rect = Rect.new(0, 48, 400, 48)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 148, picture, rect)
            end
        when 300 # ダブルZ3気円斬系(発動)
            picture = Cache.picture("Z3_戦闘_必殺技_気円斬") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 30 * 4, 126, 30)
                @back_window.contents.blt(338 + @effect_anime_frame * RAY_SPEED, 144 - 50, picture, rect)
                @back_window.contents.blt(338 + @effect_anime_frame * RAY_SPEED, 144 + 50, picture, rect)
            else
                rect = Rect.new(0, 30 * 4, 192, 30)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 160, picture, rect)
            end
        when 301 # ダブルZ3気円斬系(ヒット)
            picture = Cache.picture("Z3_戦闘_必殺技_気円斬") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 30 * 4, 126, 30)
                @back_window.contents.blt(-192 + @effect_anime_frame * RAY_SPEED, 160 - 40, picture, rect)
                @back_window.contents.blt(-192 + @effect_anime_frame * RAY_SPEED, 160 + 40, picture, rect)
            else
                rect = Rect.new(0, 30 * 4, 192, 30)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 160, picture, rect)
            end
        when 302 # ギャリックバスター(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 2, ray_y - 124, picture, rect)
                @back_window.contents.blt(ray_x + 4, ray_y - 32, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 303 # アウトサイダーショット(ピ&バ)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 18, ray_y - 134, picture, rect)
                @back_window.contents.blt(ray_x + 2, ray_y - 36, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 304 # アウトサイダーショット(ピ&17号)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 2, ray_y - 138, picture, rect)
                @back_window.contents.blt(ray_x + 6, ray_y - 34, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 305 # ダブルませんこう(ゴハン＆トランクス)発動
            if @ray_color == 0
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(桃)") # ダメージ表示用
            end

            if @attackDir == 0
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4")
                rect = Rect.new(0, 0, 190, 126)
                @back_window.contents.blt(ray_x - 10 + @effect_anime_frame * RAY_SPEED, ray_y - 146, picture, rect)
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(青)")
                rect = Rect.new(0, 0, 190, 126)
                @back_window.contents.blt(ray_x + 4 + @effect_anime_frame * RAY_SPEED, ray_y - 54, picture, rect)
            else
                rect = Rect.new(0, 126, 190, 126)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 306 # ダブルませんこう(ゴハン＆トランクス)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(ダブルませんこう_ゴハン_トランクス)") # ダメージ表示用
            rect = Rect.new(0, @ray_anime_type * 126, 190, 126)
            @back_window.contents.blt(-192 + @effect_anime_frame * RAY_SPEED, 126, picture, rect)

            if @ray_anime_frame >= 8 && @ray_anime_type == 0
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 8
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 307 # Z3まかんこうさっぽう(発動横)
            picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") # ダメージ表示用

            rect = Rect.new(0, 0, 400, 64)
            if @attackDir == 0
                rect = Rect.new(0, 64, 64 + @effect_anime_frame * RAY_SPEED, 64)
                @back_window.contents.blt(ray_x + 20, ray_y - 132, picture, rect)
                @back_window.contents.blt(ray_x + 18, ray_y - 28, picture, rect)
            else
                rect = Rect.new((400 - 64) - @effect_anime_frame * RAY_SPEED, 0, (400 - 64) + @effect_anime_frame * RAY_SPEED,
                                64)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 308 # Z3まかんこうさっぽう(ヒット)
            picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") # ダメージ表示用

            rect = Rect.new(0, 0, 400, 64)
            if @attackDir == 0
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, ray_y - 32, picture, rect)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, ray_y + 32, picture, rect)
            else
                rect = Rect.new(0, 64, 400, 64)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 309 # サイヤンアタック(ピ&バ)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            end

            rect = Rect.new(0, 48, 54 + @effect_anime_frame * RAY_SPEED, 48)
            if @attackDir == 0
                @back_window.contents.blt(@chax + 74, @chay + 18, picture, rect)
                @back_window.contents.blt(@chax + 92, @chay + 86, picture, rect)
            else
                rect = Rect.new(352 - @effect_anime_frame * RAY_SPEED, 0, 48 + @effect_anime_frame * RAY_SPEED, 48)
                @back_window.contents.blt(ray_x - 92 - @effect_anime_frame * RAY_SPEED, ray_y - 10, picture, rect)
            end
        when 310 # アウトサイダーショット(バーダック&トーマ)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 18, ray_y - 134, picture, rect)
                @back_window.contents.blt(ray_x + 14, ray_y - 32, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 311 # アウトサイダーショット(バーダック&セリパ)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 18, ray_y - 134, picture, rect)
                @back_window.contents.blt(ray_x + 0, ray_y - 28, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 312 # アウトサイダーショット(バーダック&トテッポ)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 18, ray_y - 134, picture, rect)
                @back_window.contents.blt(ray_x + 12, ray_y - 40, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 313 # アウトサイダーショット(バーダック&パンブーキン)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 18, ray_y - 134, picture, rect)
                @back_window.contents.blt(ray_x + 14, ray_y - 20, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 314 # 地球人ストライク 四身の拳
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") # ダメージ表示用

            x_idou = 1.5
            x_tyousei = 14
            case @effect_anime_frame

            when 0..30
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + x_idou * @effect_anime_frame - x_tyousei, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - x_idou * @effect_anime_frame - x_tyousei, ray_y, picture, rect)
            when 31..59

                rect = Rect.new(0, 0 + (96 * 3), 96, 96)
                @back_window.contents.blt(ray_x + x_idou * 30 - x_tyousei, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - x_idou * 30 - x_tyousei, ray_y, picture, rect)
                if @effect_anime_frame == 59
                    Audio.se_play("Audio/SE/" + "Z1 分身") # 効果音を再生する
                end
            when 60..120
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + x_idou * 30 - x_tyousei, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - x_idou * 30 - x_tyousei, ray_y, picture, rect)
                @back_window.contents.blt(ray_x + x_idou * (@effect_anime_frame - 30) - x_tyousei, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - x_idou * (@effect_anime_frame - 30) - x_tyousei, ray_y, picture, rect)
            else
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + x_idou * 30 - x_tyousei, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - x_idou * 30 - x_tyousei, ray_y, picture, rect)
                @back_window.contents.blt(ray_x + x_idou * 90 - x_tyousei, ray_y, picture, rect)
                @back_window.contents.blt(ray_x - x_idou * 90 - x_tyousei, ray_y, picture, rect)
            end
        when 315 # 地球人ストライク サイコアタックと狼牙

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ") # ダメージ表示用
            rect = Rect.new(0, 5 * 96, 96, 96)
            @back_window.contents.blt(STANDARD_ENEX + 74 - 21 * RAY_SPEED, STANDARD_CHAY - 8, picture, rect)
            end_frame = 85

            if @btl_ani_cha_chg_no == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) # ダメージ表示用
            end
            attack_se = "Z3 打撃"
            case @effect_anime_frame

            when 0..10
                rect = Rect.new(0, 14 * 96, 96, 96)
            when 11..20
                rect = Rect.new(0, 13 * 96, 96, 96)
            when 21..30
                rect = Rect.new(0, 12 * 96, 96, 96)
            when 31..35
                rect = Rect.new(0, 0 * 96, 96, 96)
            when 36..39
                rect = Rect.new(0, 3 * 96, 96, 96)
            when 40..43
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 44..46
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 47..50
                rect = Rect.new(0, 4 * 96, 96, 96)
            when 51..53
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 54..56
                rect = Rect.new(0, 1 * 96, 96, 96)
            when 57..60
                rect = Rect.new(0, 2 * 96, 96, 96)
            when 61..80
                rect = Rect.new(0, 16 * 96, 96, 96)
            else
                # when 81..85

                if @btl_ani_cha_chg_no == 0
                    if $btl_progress >= 2
                        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
                        rect = Rect.new(0, 3 * 96, 96, 96)
                    else
                        picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) # ダメージ表示用
                        rect = Rect.new(0, 2 * 96, 96, 96)
                    end
                else
                    if $btl_progress >= 2
                        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) # ダメージ表示用
                        rect = Rect.new(0, 3 * 96, 96, 96)
                    else
                        picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) # ダメージ表示用
                        rect = Rect.new(0, 2 * 96, 96, 96)
                    end

                end
                # else

                # if @btl_ani_cha_chg_no == 0
                #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
                # else
                #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
                # end
                # if $btl_progress >= 2
                #  rect = Rect.new(0, 3*96,96,96)
                # else
                #  rect = Rect.new(0, 3*96,96,96)
                # end
            end

            if @effect_anime_frame >= 36 && @effect_anime_frame % 5 == 0 && end_frame > @effect_anime_frame
                Audio.se_play("Audio/SE/" + attack_se) # 効果音を再生する
            end

            if @effect_anime_frame >= 61 && @effect_anime_frame <= 80
                @back_window.contents.blt(CENTER_CHAX - (@effect_anime_frame - 60) * 8, STANDARD_CHAY, picture, rect)
            elsif @effect_anime_frame >= 81 && @effect_anime_frame <= 84
                @back_window.contents.blt(80 + (@effect_anime_frame - 80) * 16, STANDARD_CHAY, picture, rect)
            else # if @effect_anime_frame < 86
                @back_window.contents.blt(CENTER_CHAX, STANDARD_CHAY, picture, rect)
            end
        when 316 # エネルギー波_小系(発動)敵
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            rect = Rect.new(352 - @effect_anime_frame * RAY_SPEED, 0, 48 + @effect_anime_frame * RAY_SPEED, 48)
            @back_window.contents.blt(ray_x - 92 + 84 - @effect_anime_frame * RAY_SPEED, ray_y - 10 - 96, picture, rect)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            @back_window.contents.blt(ray_x - 92 + 100 - @effect_anime_frame * RAY_SPEED, ray_y - 10 - 16, picture, rect)

        when 317 # メタルクラッシュ
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") # ダメージ表示用
            rect = Rect.new(0, 48, 400, 48)
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED + 64, 148 - 24, picture, rect)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            # rect = Rect.new(0, 48,400,48)
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED + 64, 148 + 24, picture, rect)
        when 318 # 四身の拳かめはめは(発動)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") # ダメージ表示用
            if @btl_ani_cha_chg_no == 0
                picture2 = Cache.picture(set_battle_character_name $partyc[@chanum.to_i], 1)
            # picture2 = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
            else
                picture2 = Cache.picture(set_battle_character_name @btl_ani_cha_chg_no, 1)
                # picture2 = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
            end

            tasux = 160
            case @effect_anime_frame

            when 0..30
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * @effect_anime_frame + 26, ray_y - 1 * @effect_anime_frame, picture,
                                          rect)
                @back_window.contents.blt(ray_x - 0.5 * @effect_anime_frame + 26, ray_y + 1 * @effect_anime_frame, picture,
                                          rect)

                rect = Rect.new(0, 0 + (96 * 0), 96, 96)
                if @battle_anime_frame % 2 == 0
                    @back_window.contents.blt(ray_x + 0.5 * 30 + 26 + tasux, ray_y - 1 * 30, picture2, rect)
                else
                    @back_window.contents.blt(ray_x - 0.5 * 30 + 26 + tasux, ray_y + 1 * 30, picture2, rect)
                end
            when 31..59

                rect = Rect.new(0, 0 + (96 * 3), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)

                rect = Rect.new(0, 0 + (96 * 0), 96, 96)
                if @battle_anime_frame % 2 == 0
                    @back_window.contents.blt(ray_x + 0.5 * 30 + 26 + tasux, ray_y - 1 * 30, picture2, rect)
                else
                    @back_window.contents.blt(ray_x - 0.5 * 30 + 26 + tasux, ray_y + 1 * 30, picture2, rect)
                end
                if @effect_anime_frame == 59
                    Audio.se_play("Audio/SE/" + "Z1 分身") # 効果音を再生する
                end
            when 60..120
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x + 0.5 * (@effect_anime_frame - 30) + 26, ray_y - 1 * (@effect_anime_frame - 30), picture,
                                          rect)
                @back_window.contents.blt(ray_x - 0.5 * (@effect_anime_frame - 30) + 26, ray_y + 1 * (@effect_anime_frame - 30), picture,
                                          rect)

                rect = Rect.new(0, 0 + (96 * 0), 96, 96)
                if @battle_anime_frame % 4 == 0
                    @back_window.contents.blt(ray_x + 0.5 * 30 + 26 + tasux, ray_y - 1 * 30, picture2, rect)
                elsif @battle_anime_frame % 4 == 1
                    @back_window.contents.blt(ray_x - 0.5 * 30 + 26 + tasux, ray_y + 1 * 30, picture2, rect)
                elsif @battle_anime_frame % 4 == 2
                    @back_window.contents.blt(ray_x - 0.5 * 90 + 26 + tasux, ray_y + 1 * 90, picture2, rect)
                else
                    @back_window.contents.blt(ray_x + 0.5 * 90 + 26 + tasux, ray_y - 1 * 90, picture2, rect)
                end
            when 121..150
                rect = Rect.new(0, 0 + (96 * 4), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x + 0.5 * 90 + 26, ray_y - 1 * 90, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 90 + 26, ray_y + 1 * 90, picture, rect)

                rect = Rect.new(0, 0 + (96 * 0), 96, 96)
                if @battle_anime_frame % 4 == 0
                    @back_window.contents.blt(ray_x + 0.5 * 30 + 26 + tasux, ray_y - 1 * 30, picture2, rect)
                elsif @battle_anime_frame % 4 == 1
                    @back_window.contents.blt(ray_x - 0.5 * 30 + 26 + tasux, ray_y + 1 * 30, picture2, rect)
                elsif @battle_anime_frame % 4 == 2
                    @back_window.contents.blt(ray_x - 0.5 * 90 + 26 + tasux, ray_y + 1 * 90, picture2, rect)
                else
                    @back_window.contents.blt(ray_x + 0.5 * 90 + 26 + tasux, ray_y - 1 * 90, picture2, rect)
                end
            else
                if @effect_anime_frame == 151
                    # Audio.se_play("Audio/SE/" + "Z1 ザー")    # 効果音を再生する
                    # Audio.se_play("Audio/SE/" + "Z3 エネルギー波")    # 効果音を再生する
                end
                rect = Rect.new(0, 0 + (96 * 0), 96, 96)
                @back_window.contents.blt(ray_x + 0.5 * 90 + 26, ray_y - 1 * 90, picture, rect)
                @back_window.contents.blt(ray_x + 0.5 * 30 + 26, ray_y - 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 30 + 26, ray_y + 1 * 30, picture, rect)
                @back_window.contents.blt(ray_x - 0.5 * 90 + 26, ray_y + 1 * 90, picture, rect)

                rect = Rect.new(0, 0 + (96 * 0), 96, 96)
                if @battle_anime_frame % 4 == 0
                    @back_window.contents.blt(ray_x + 0.5 * 30 + 26 + tasux, ray_y - 1 * 30, picture2, rect)
                elsif @battle_anime_frame % 4 == 1
                    @back_window.contents.blt(ray_x - 0.5 * 30 + 26 + tasux, ray_y + 1 * 30, picture2, rect)
                elsif @battle_anime_frame % 4 == 2
                    @back_window.contents.blt(ray_x - 0.5 * 90 + 26 + tasux, ray_y + 1 * 90, picture2, rect)
                else
                    @back_window.contents.blt(ray_x + 0.5 * 90 + 26 + tasux, ray_y - 1 * 90, picture2, rect)
                end
            end
        when 319 # 四身の拳かめはめは(ヒット)
            @effect_anime_type = 2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, STANDARD_CHAY - 20 - 1 * 90 + @effect_anime_frame * 3,
                                          picture, rect)
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, STANDARD_CHAY - 20 - 1 * 30 + @effect_anime_frame * 1,
                                          picture, rect)
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, STANDARD_CHAY - 20 + 1 * 30 - @effect_anime_frame * 1,
                                          picture, rect)
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, STANDARD_CHAY - 20 + 1 * 90 - @effect_anime_frame * 3,
                                          picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, STANDARD_CHAY, picture, rect)
            end

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, 0, 96, 64)
                @back_window.contents.blt(-128 + @effect_anime_frame * RAY_SPEED, 144, picture, rect)
            else
                rect = Rect.new(0, 64, 96, 64)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 144, picture, rect)
            end
        when 320 # 行くぞクリリン(発動)
            # @effect_anime_type = 2

            if $btl_progress < 2
                rect = Rect.new(0, 0, 222, 134)
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(緑)") # ダメージ表示用
                @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 96 - 58 + 1 * @effect_anime_frame, picture,
                                          rect)

                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3") # ダメージ表示用
                @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 96 + 60 - 1 * @effect_anime_frame, picture,
                                          rect)

            else
                rect = Rect.new(0, 0, 190, 126)
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(緑)") # ダメージ表示用
                @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 98 - 56 + 1 * @effect_anime_frame, picture,
                                          rect)

                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") # ダメージ表示用
                @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 98 + 60 - 1 * @effect_anime_frame, picture,
                                          rect)

            end
        when 321 # アウトサイダーショット(ピ&ベ)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 2, ray_y - 136, picture, rect)
                @back_window.contents.blt(ray_x + 2, ray_y - 28, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 322
            picture = Cache.picture("Z3_戦闘_必殺技_ロボット兵腕2") # ダメージ表示用
            rect = Rect.new(0, 0, 32, 18)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
        when 323
            picture = Cache.picture("Z3_戦闘_必殺技_ロボット兵腕3") # ダメージ表示用
            rect = Rect.new(0, 0, 30, 24)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @battle_anime_frame >= 379
                picture = Cache.picture("Z3_必殺技_爆発") # ダメージ表示用
                rect = Rect.new(0, 0, 32, 32)
                tempx = @chax + (rand(18) * 2)
                tempy = @chay + (rand(16) * 2)
                @back_window.contents.blt(tempx, tempy, picture, rect)
            end
        when 324 # 超元気玉ため(逆)

            picture = Cache.picture("Z3_戦闘_必殺技_超元気玉_溜め(逆)") # ダメージ表示用

            rect = Rect.new(0, @ray_anime_type * 110, 246, 110)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @ray_anime_frame >= 20 && @ray_anime_type != 5
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 4 && @ray_anime_type == 5
                @ray_anime_type = 4
                @ray_anime_frame = 0
            end
        when 325 # スーパービッグノヴァ発動

            picture = Cache.picture("Z3_戦闘_必殺技_デスボール(極大玉縦)(オレンジ)") # ダメージ表示用

            rect = Rect.new(0, 0, 512, 250)
            @back_window.contents.blt(ray_x - (@effect_anime_frame * 8), ray_y + (@effect_anime_frame * 2), picture, rect)
        when 326 # スーパービッグノヴァ発動(ヒット)

            picture = Cache.picture("Z3_戦闘_必殺技_デスボール(極大玉)(オレンジ)") # ダメージ表示用

            rect = Rect.new(0, 0, 900, 512)
            @back_window.contents.blt(ray_x - (@effect_anime_frame * 8), ray_y + (@effect_anime_frame * 2), picture, rect)
        when 327 # メタルクウラコア(ケーブル)発動

            picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル") # ダメージ表示用

            rect = Rect.new(0, 80 * @ray_anime_type, 64 + @effect_anime_frame * 8, 80)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)

            if @ray_anime_frame >= 4
                @ray_anime_type += 1
                @ray_anime_frame = 0
            end

            if @ray_anime_type >= 3
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 328 # メタルクウラコア(ケーブル)伸びる

            picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル") # ダメージ表示用

            rect = Rect.new(0, 80 * @ray_anime_type, 1400, 80)
            @back_window.contents.blt(ray_x - @effect_anime_frame * 8, ray_y, picture, rect)

            if @ray_anime_frame >= 4
                @ray_anime_type += 1
                @ray_anime_frame = 0
            end

            if @ray_anime_type >= 3
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 329 # メタルクウラコア(ケーブル)ヒット

            picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル") # ダメージ表示用

            rect = Rect.new(0, 80 * @ray_anime_type, 1400, 80)
            @back_window.contents.blt(ray_x - @effect_anime_frame * 8, ray_y, picture, rect)

            if @ray_anime_frame >= 4
                @ray_anime_type += 1
                @ray_anime_frame = 0
            end

            if @ray_anime_type >= 3
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 330 # Z3気円斬系(発動)
            picture = Cache.picture("Z3_戦闘_必殺技_気円斬") # ダメージ表示用

            rect = Rect.new(0, 30 * @ray_anime_type, 126, 30)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @ray_anime_frame >= 4
                @ray_anime_type += 1
                @ray_anime_frame = 0
            end

            if @ray_anime_type >= 4
                @ray_anime_type = 4
                @ray_anime_frame = 0
            end
        when 331 # ナメック戦士発動
            # if @ray_color == 0
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") # ダメージ表示用
            # elsif @ray_color == 1
            #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中(緑)") #ダメージ表示用
            # elsif @ray_color == 4
            #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中(桃)") #ダメージ表示用
            # end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(326, 116, picture, rect)
                @back_window.contents.blt(282, 42, picture, rect)
                @back_window.contents.blt(282, 172, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 332 # 狼牙風風拳 ヤムチャとわかもの

            end_frame = 85
            picture = Cache.picture($btl_top_file_name + "戦闘_ヤムチャ") # ダメージ表示用
            picture2 = Cache.picture($btl_top_file_name + "戦闘_必殺技_わかもの") # ダメージ表示用
            attack_se = "Z3 打撃"
            case @effect_anime_frame

            when 0..10
                rect = Rect.new(0, 14 * 96, 96, 96)
                rect2 = Rect.new(0, 26 * 96, 96, 96)
            when 11..20
                rect = Rect.new(0, 13 * 96, 96, 96)
                rect2 = Rect.new(0, 25 * 96, 96, 96)
            when 21..30
                rect = Rect.new(0, 12 * 96, 96, 96)
                rect2 = Rect.new(0, 24 * 96, 96, 96)
            when 31..35
                rect = Rect.new(0, 0 * 96, 96, 96)
                rect2 = Rect.new(0, 19 * 96, 96, 96)
            when 36..39
                rect = Rect.new(0, 3 * 96, 96, 96)
                rect2 = Rect.new(0, 22 * 96, 96, 96)
            when 40..43
                rect = Rect.new(0, 1 * 96, 96, 96)
                rect2 = Rect.new(0, 20 * 96, 96, 96)
            when 44..46
                rect = Rect.new(0, 2 * 96, 96, 96)
                rect2 = Rect.new(0, 21 * 96, 96, 96)
            when 47..50
                rect = Rect.new(0, 4 * 96, 96, 96)
                rect2 = Rect.new(0, 23 * 96, 96, 96)
            when 51..53
                rect = Rect.new(0, 2 * 96, 96, 96)
                rect2 = Rect.new(0, 21 * 96, 96, 96)
            when 54..56
                rect = Rect.new(0, 1 * 96, 96, 96)
                rect2 = Rect.new(0, 20 * 96, 96, 96)
            when 57..60
                rect = Rect.new(0, 2 * 96, 96, 96)
                rect2 = Rect.new(0, 21 * 96, 96, 96)
            when 61..80
                rect = Rect.new(0, 16 * 96, 96, 96)
                rect2 = Rect.new(0, 18 * 96, 96, 96)
            else
                if $btl_progress >= 2
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ") # ダメージ表示用
                    picture2 = Cache.picture($btl_top_file_name + "戦闘_必殺技_わかもの") # ダメージ表示用
                    rect = Rect.new(0, 3 * 96, 96, 96)
                    rect2 = Rect.new(0, 21 * 96, 96, 96)
                else
                    picture = Cache.picture($btl_top_file_name + "戦闘_ヤムチャ") # ダメージ表示用
                    picture2 = Cache.picture($btl_top_file_name + "戦闘_必殺技_わかもの") # ダメージ表示用
                    rect = Rect.new(0, 2 * 96, 96, 96)
                    rect2 = Rect.new(0, 21 * 96, 96, 96)
                end

            end
            # else

            # if @btl_ani_cha_chg_no == 0
            #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
            # else
            #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
            # end
            # if $btl_progress >= 2
            #  rect = Rect.new(0, 3*96,96,96)
            # else
            #  rect = Rect.new(0, 3*96,96,96)
            # end

            if @effect_anime_frame >= 36 && @effect_anime_frame % 5 == 0 && end_frame > @effect_anime_frame
                Audio.se_play("Audio/SE/" + attack_se) # 効果音を再生する
            end
            yamux = 10
            wakamonox = 154

            if @effect_anime_frame >= 61 && @effect_anime_frame <= 80
                @back_window.contents.blt(CENTER_CHAX + yamux, STANDARD_CHAY - (@effect_anime_frame - 60) * 4, picture, rect)
                @back_window.contents.blt(CENTER_CHAX + wakamonox, STANDARD_CHAY - (@effect_anime_frame - 60) * 4, picture2,
                                          rect2)
            elsif @effect_anime_frame >= 81 && @effect_anime_frame <= 85
                @back_window.contents.blt(CENTER_CHAX + yamux, STANDARD_CHAY - 80 + (@effect_anime_frame - 80) * 16, picture,
                                          rect)
                @back_window.contents.blt(CENTER_CHAX + wakamonox, STANDARD_CHAY - 80 + (@effect_anime_frame - 80) * 16, picture2,
                                          rect2)
            else # if @effect_anime_frame < 86
                @back_window.contents.blt(CENTER_CHAX + yamux, STANDARD_CHAY, picture, rect)
                @back_window.contents.blt(CENTER_CHAX + wakamonox, STANDARD_CHAY, picture2, rect2)
            end
        when 333 # エネルギー弾系(正面)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if ray_x == 0 || ray_x == nil
                ray_x = 240
                ray_y = 100
            end
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1 if @effect_anime_type != 5
                @effect_anime_frame = 0
            end
        when 334 # アウトサイダーショット(トーマ&セリパ)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 12, ray_y - 130, picture, rect)
                @back_window.contents.blt(ray_x + 0, ray_y - 28, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 335 # アウトサイダーショット(トーマ&トテッポ)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 12, ray_y - 130, picture, rect)
                @back_window.contents.blt(ray_x + 18, ray_y - 40, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 336 # アウトサイダーショット(セリパ&パンブーキン)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 0, ray_y - 128, picture, rect)
                @back_window.contents.blt(ray_x + 6, ray_y - 32, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 337 # アウトサイダーショット(トテッポ&パンブーキン)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x + 18, ray_y - 142, picture, rect)
                @back_window.contents.blt(ray_x + 6, ray_y - 32, picture, rect)
            else
                rect = Rect.new(346 - @effect_anime_frame * RAY_SPEED, 0, 54 + @effect_anime_frame * RAY_SPEED, 80)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 338 # ダブルエネルギー波_小系(発動)敵
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            rect = Rect.new(352 - @effect_anime_frame * RAY_SPEED, 0, 48 + @effect_anime_frame * RAY_SPEED, 48)
            @back_window.contents.blt(ray_x - 92 + 84 - @effect_anime_frame * RAY_SPEED, ray_y - 10 - 96 + 2, picture, rect)
            @back_window.contents.blt(ray_x - 92 + 84 - @effect_anime_frame * RAY_SPEED, ray_y - 10 - 96 + 2 + 100, picture,
                                      rect)
        when 339 # ダブルエネルギー波_小系(ヒット)敵
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            rect = Rect.new(0, 48, 640, 48)
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y - 10 - 96 + 2 + 24, picture, rect)
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y - 10 - 96 + 2 + 100 - 24, picture, rect)
        when 340 # エビルコメットヒット
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") # ダメージ表示用
            rect = Rect.new(0, 48, 640, 48)
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y - 24 * 1, picture, rect)
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y + 24 * 1, picture, rect)
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y - 24 * 2, picture, rect)
            @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y + 24 * 2, picture, rect)

        when 341 # カエル攻撃ヒット
            picture = Cache.picture("Z2_戦闘_必殺技_敵_メダマッチャ") # ダメージ表示用

            if @effect_anime_frame < 16
                rect = Rect.new(0, 96 * 12, 96, 96)
            else
                rect = Rect.new(0, 96 * 11, 96, 96)
            end
            tyouseifre = @effect_anime_frame
            fremax = 27
            if @effect_anime_frame > fremax
                tyouseifre = fremax
            end
            kx = tyouseifre * 16
            ky = -tyouseifre * 2
            kkx = 640
            kky = 80
            @back_window.contents.blt(kkx - 8 + 7 * 2 - kx, kky - 34 - 7 * 2 - ky, picture, rect)
            @back_window.contents.blt(kkx - 16 - kx, kky - 42 - 7 * 2 - ky, picture, rect)
            @back_window.contents.blt(kkx - 32 - kx, kky - 42 - 7 * 2 - ky, picture, rect)
            @back_window.contents.blt(kkx - 40 - 7 * 2 - kx, kky - 34 - 7 * 2 - ky, picture, rect)
        when 342 # Z3まかんこうさっぽう(発動横)
            picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") # ダメージ表示用

            rect = Rect.new(0, 0, 400, 64)
            if @attackDir == 0
                rect = Rect.new(0, 64, 64 + @effect_anime_frame * RAY_SPEED, 64)
                @back_window.contents.blt(ray_x + 20, ray_y - 132, picture, rect)
                @back_window.contents.blt(ray_x + 22, ray_y - 36, picture, rect)
            else
                rect = Rect.new((400 - 64) - @effect_anime_frame * RAY_SPEED, 0, (400 - 64) + @effect_anime_frame * RAY_SPEED,
                                64)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 343 # Z3トリプル魔閃光(発動横)
            picture = Cache.picture("Z3_戦闘_必殺技_トリプル魔閃光") # ダメージ表示用

            rect = Rect.new(0, 0, 64 + @effect_anime_frame * RAY_SPEED, 204)
            # @back_window.contents.blt(ray_x+20,ray_y-132,picture,rect)
            @back_window.contents.blt(ray_x - 8, ray_y - 10, picture, rect)
        when 344 # Z3トリプルまかんこうさっぽう(発動横)
            picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") # ダメージ表示用

            rect = Rect.new(0, 64, 64 + @effect_anime_frame * RAY_SPEED, 64)
            @back_window.contents.blt(ray_x - 10, ray_y - 144, picture, rect)
            @back_window.contents.blt(ray_x + 22, ray_y - 86, picture, rect)
            @back_window.contents.blt(ray_x - 8, ray_y - 20, picture, rect)
        when 345 # Z3トリプルまかんこうさっぽう(ヒット)
            picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") # ダメージ表示用
            rect = Rect.new(0, 0, 400, 64)
            @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, ray_y - 32 - 32 + 8, picture, rect)
            @back_window.contents.blt(-340 + @effect_anime_frame * RAY_SPEED, ray_y + 0, picture, rect)
            @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, ray_y + 32 + 32 - 8, picture, rect)
        when 346 # アウトサイダーショット(ピ&16号)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end

            rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
            @back_window.contents.blt(ray_x + 2, ray_y - 138, picture, rect)
            @back_window.contents.blt(ray_x + 26, ray_y - 34, picture, rect)
        when 347 # アウトサイダーショット(未来悟飯&17号)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end

            rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
            @back_window.contents.blt(ray_x + 24, ray_y - 132, picture, rect)
            @back_window.contents.blt(ray_x + 6, ray_y - 36, picture, rect)
        when 348 # アウトサイダーショット(未来悟飯&16号)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end

            rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
            @back_window.contents.blt(ray_x + 24, ray_y - 132, picture, rect)
            @back_window.contents.blt(ray_x + 26, ray_y - 34, picture, rect)

        when 349 # アウトサイダーショット(未来悟飯&ベジータ)(発動)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") # ダメージ表示用
            end

            rect = Rect.new(0, 80, 54 + @effect_anime_frame * RAY_SPEED, 80)
            @back_window.contents.blt(ray_x + 24, ray_y - 132, picture, rect)
            @back_window.contents.blt(ray_x + 2, ray_y - 28, picture, rect)
        when 350 # 超体当たり(ヒット)
            picture = Cache.picture("Z3_必殺技_超体当たり(パイクーハン)") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(190 * @ray_anime_type, 0, 190, 126)
                @back_window.contents.blt(-236 + @effect_anime_frame * RAY_SPEED, 100, picture, rect)
            else
                rect = Rect.new(190 * @ray_anime_type, 0, 190, 126)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 100, picture, rect)
            end

            if @ray_anime_frame >= 8 && @ray_anime_type == 0
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 8
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 351 # 巻きつき攻撃 引き抜く
            picture = Cache.picture("Z3_戦闘_必殺技_ブウ_巻きつく") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, @effect_anime_type * 96, 96, 96)
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, @effect_anime_type * 96, 96, 96)
                @back_window.contents.blt(ray_x - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end

        when 352 # 光線
            picture = Cache.picture("Z3_戦闘_必殺技_お菓子光線_前中後繋ぎ") # ダメージ表示用

            if @attackDir == 0
                rect = Rect.new(0, @effect_anime_type * 96, 96, 96)
                @back_window.contents.blt(ray_x + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 0, 608, 52)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end

        when 353 # かめはめ波系(特大_加工)横 ヒット
            if @ray_color == 0
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_加工") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_緑_加工") # ダメージ表示用
            else
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_青_加工") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 0, 400, 192)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            else
                rect = Rect.new(0, 192, 400, 192)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            end
        when 354 # ブウ巻きつきヒット

            picture = Cache.picture("Z3_戦闘_必殺技_ブウ_巻きつく(巨大)") # ダメージ表示用

            rect = Rect.new(192 * @effect_anime_type, 0, 192, 192)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
        when 355 # ダブルアタック(天津飯とトランクス)(発動)
            # @effect_anime_type = 2

            rect = Rect.new(0, 0, 190, 126)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") # ダメージ表示用
            @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 98 - 56 + 1 * @effect_anime_frame, picture,
                                      rect)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(青)") # ダメージ表示用
            @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 98 + 50 - 1 * @effect_anime_frame, picture,
                                      rect)

        when 356 # ダブルアタック(天津飯とトランクス)(ヒット)
            if @ray_anime_type == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4")
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(青)")
            end # ダメージ表示用
            rect = Rect.new(0, 0, 190, 126)
            @back_window.contents.blt(-192 + @effect_anime_frame * RAY_SPEED, 126, picture, rect)

            if @ray_anime_frame >= 8 && @ray_anime_type == 0
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 8
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 357 # ダブルアタック(チャオズとトランクス)(発動)
            # @effect_anime_type = 2

            rect = Rect.new(0, 0, 190, 126)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") # ダメージ表示用
            @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 98 - 46 + 1 * @effect_anime_frame, picture,
                                      rect)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(青)") # ダメージ表示用
            @back_window.contents.blt(340 + @effect_anime_frame * RAY_SPEED, 98 + 50 - 1 * @effect_anime_frame, picture,
                                      rect)
        when 358 # かめはめ波系(特大_加工)横 発動
            if @ray_color == 0
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_加工") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_緑_加工") # ダメージ表示用
            else
                picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_青_加工") # ダメージ表示用
            end

            rey_kizyunx = 54 + @effect_anime_frame * RAY_SPEED
            if @attackDir == 0
                rect = Rect.new(0, 192, rey_kizyunx, 192)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)

            else
                rect = Rect.new(400 - rey_kizyunx, 0, rey_kizyunx, 192)
                @back_window.contents.blt(ray_x - rey_kizyunx, ray_y, picture, rect)
            end
        when 359 # ダブルかめはめ波(悟空、亀仙人)
            picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_大") # ダメージ表示用

            rect = Rect.new(0, 92, 54 + @effect_anime_frame * RAY_SPEED, 92)
            if $super_saiyazin_flag[1] == true
                @back_window.contents.blt(ray_x + 14, ray_y - 132, picture, rect)
            else
                @back_window.contents.blt(ray_x + 4, ray_y - 126, picture, rect)
            end
            @back_window.contents.blt(ray_x - 10, ray_y - 20, picture, rect)
        when 360 # ダブルかめはめ波(悟飯／クリリン、亀仙人)
            picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_大") # ダメージ表示用

            rect = Rect.new(0, 92, 54 + @effect_anime_frame * RAY_SPEED, 92)
            # if $super_saiyazin_flag[1] == true
            #  @back_window.contents.blt(ray_x+14,ray_y-132,picture,rect)
            # else
            #  @back_window.contents.blt(ray_x+4,ray_y-126,picture,rect)
            # end
            @back_window.contents.blt(ray_x - 10, ray_y - 122, picture, rect)
            @back_window.contents.blt(ray_x - 10, ray_y - 20, picture, rect)
        when 361 # ダブルかめはめ波(ヤムチャ、亀仙人)
            picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_大") # ダメージ表示用

            rect = Rect.new(0, 92, 54 + @effect_anime_frame * RAY_SPEED, 92)
            # if $super_saiyazin_flag[1] == true
            #  @back_window.contents.blt(ray_x+14,ray_y-132,picture,rect)
            # else
            #  @back_window.contents.blt(ray_x+4,ray_y-126,picture,rect)
            # end
            @back_window.contents.blt(ray_x + 6, ray_y - 130, picture, rect)
            @back_window.contents.blt(ray_x - 10, ray_y - 20, picture, rect)
        when 362 # ダブルかめはめ波(未来悟飯、亀仙人)
            picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_大") # ダメージ表示用

            rect = Rect.new(0, 92, 54 + @effect_anime_frame * RAY_SPEED, 92)
            # if $super_saiyazin_flag[1] == true
            #  @back_window.contents.blt(ray_x+14,ray_y-132,picture,rect)
            # else
            #  @back_window.contents.blt(ray_x+4,ray_y-126,picture,rect)
            # end
            @back_window.contents.blt(ray_x + 22, ray_y - 134, picture, rect)
            @back_window.contents.blt(ray_x - 10, ray_y - 20, picture, rect)
        when 363 # スパーキングコンボキャラ現れる2人目右
            picture = Cache.picture(set_battle_character_name @scombo_cha2, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)

            rect = Rect.new(0, 0 * 96, 96, 96)
            ushirox = 0
            idouryou = 12
            @back_window.contents.blt(STANDARD_CHAX + @effect_anime_frame * idouryou - 30 + 12, STANDARD_CHAY, picture,
                                      rect)
        when 364 # スパーキングコンボキャラ現れる2人目左
            picture = Cache.picture(set_battle_character_name @scombo_cha2, 1)
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)

            rect = Rect.new(0, 0 * 96, 96, 96)
            ushirox = 0
            idouryou = 8
            @back_window.contents.blt(STANDARD_CHAX + @effect_anime_frame * idouryou - 48, STANDARD_CHAY, picture, rect)
        when 365 # スピリッツかめはめ波系(特大_加工)横 ヒット
            picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_加工(スピリッツかめはめ波)") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, @ray_anime_type * 192, 400, 192)
                @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            else
                rect = Rect.new(0, 192, 400, 192)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 76, picture, rect)
            end
            if @ray_anime_frame >= 8 && @ray_anime_type == 0
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 8
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 366 # エネルギー弾系(正面:スピリッツかめはめ波系)
            if @ray_anime_type == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            end
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            if ray_x == 0 || ray_x == nil
                ray_x = 240
                ray_y = 100
            end
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
            if @effect_anime_frame >= 10
                @effect_anime_type += 1 if @effect_anime_type != 5
                @effect_anime_frame = 0
            end

            if @ray_anime_frame >= 8 && @ray_anime_type == 0
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 8
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        when 367 # 絶好のチャンス(悟飯／クリリン)
            picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_大") # ダメージ表示用

            rect = Rect.new(0, 92, 54 + @effect_anime_frame * RAY_SPEED, 92)
            # if $super_saiyazin_flag[1] == true
            #  @back_window.contents.blt(ray_x+14,ray_y-132,picture,rect)
            # else
            #  @back_window.contents.blt(ray_x+4,ray_y-126,picture,rect)
            # end
            @back_window.contents.blt(ray_x - 14, ray_y - 128, picture, rect)
            @back_window.contents.blt(ray_x - 10, ray_y - 22, picture, rect)
        when 368 # 界王拳系(自由)
            if $super_saiyazin_flag[1] == true
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_界王拳(超悟空)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_界王拳") # ダメージ表示用
            end
            if @effect_anime_frame >= 10 && @effect_anime_type == 0
                @effect_anime_type += 1
                @effect_anime_frame = 0
            elsif @effect_anime_frame >= 10 && @effect_anime_type == 1
                @effect_anime_type = 0
                @effect_anime_frame = 0
            end
            rect = Rect.new(236 * @effect_anime_type, 0, 236, 122)
            @back_window.contents.blt(ray_x, ray_y, picture, rect)
        when 369 # Z3エネルギー波半円ヒット(赤、青斑点)
            # if @ray_color == 0
            #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円") #ダメージ表示用
            # elsif @ray_color == 1
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(緑)") #ダメージ表示用
            # elsif @ray_color == 3
            #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(青)") #ダメージ表示用
            # elsif @ray_color == 9
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(紫)") #ダメージ表示用
            # end

            if @ray_anime_frame >= 4 && @effect_anime_type == 0
                @effect_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 4 && @effect_anime_type == 1
                @effect_anime_type = 0
                @ray_anime_frame = 0
            end

            case @effect_anime_type

            when 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円") # ダメージ表示用
            when 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(青)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円") # ダメージ表示用
            end
            if @attackDir == 0
                rect = Rect.new(0, 128, 700, 128)
                @back_window.contents.blt(-700 + @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            else
                rect = Rect.new(0, 0, 700, 128)
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, ray_y, picture, rect)
            end
        when 370 # Z1ダブルアイビーム発動
            # ピッコロ
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(160 - (@effect_anime_frame) * 2, 100 - (@effect_anime_frame) * 2, picture, rect)
            @back_window.contents.blt(166 + (@effect_anime_frame) * 2, 100 - (@effect_anime_frame) * 2, picture, rect)

            # 天津飯
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") # ダメージ表示用
            rect = Rect.new(@effect_anime_type * 128, 0, 128, 128)
            @back_window.contents.blt(342, 98 - (@effect_anime_frame) * 2, picture, rect)
        when 371 # Z1ダブルアイビームヒット
            rect = Rect.new(0, 0, 400, 28)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波(緑)") # ダメージ表示用
            @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 129, picture, rect)
            @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 189, picture, rect)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波") # ダメージ表示用
            @back_window.contents.blt(-400 + @effect_anime_frame * RAY_SPEED, 159, picture, rect)
        when 372 # ファイナルかめはめ波(特大_加工)横 発動
            picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_加工(スピリッツかめはめ波)_発動") # ダメージ表示用
            if @attackDir == 0
                rect = Rect.new(0, @ray_anime_type * 192, @effect_anime_frame * RAY_SPEED, 192)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            else
                rect = Rect.new(0, @ray_anime_type * 192, @effect_anime_frame * RAY_SPEED, 192)
                @back_window.contents.blt(ray_x, ray_y, picture, rect)
            end
            if @ray_anime_frame >= 8 && @ray_anime_type == 0
                @ray_anime_type += 1
                @ray_anime_frame = 0
            elsif @ray_anime_frame >= 8
                @ray_anime_type = 0
                @ray_anime_frame = 0
            end
        else
        end
        @ray_anime_frame += 1
        @effect_anime_frame += 1
    end

end  # end of module
