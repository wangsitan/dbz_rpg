module Scene_Db_Battle_Anime_attack_start

    #--------------------------------------------------------------------------
    # ● 戦闘アニメ処理
    #--------------------------------------------------------------------------
    def attack_start()
        $err_run_process_d3 = "戦闘アニメ詳細処理開始"

        if $battle_test_flag == false # 戦闘テスト時は実行しない(なぜかSコンボ時にエラーになるため)
            damage_calculation(@attackDir)
        else
            @attack_hit = true
        end

        chpictureb = Cache.picture("戦闘アニメ")

        if $cha_bigsize_on[@chanum.to_i] != true
            @charect = Rect.new(0, 96 * 0, 96, 96)
        else
            @charect = Rect.new(0, 192 * 0, 192, 192)
        end
        # @enerect = Rect.new(0 ,96*0, 96, 96)
        ray_x = 0 # 必殺技発動時のエネルギー波の位置(Z2以降使ってる)
        ray_y = 0
        damage_pattern = nil    # 攻撃ヒット時のアニメパターン
        avoid_anime_no = 20     # 攻撃回避時にアニメパターン

        # 通常攻撃除外パターン用配列
        ok_normalattackpattern = []

        if @attackDir == 0  # L -> R
            if $cha_set_action[@chanum] < 11
                # normal attack
                attackPattern = $cha_set_action[@chanum]
                # attackPattern = rand($attack_pattern_max) + 1 #味方通常攻撃

                # 対象攻撃を格納
                ok_normalattackpattern = set_ok_normalattackpattern

                # 通常攻撃をセット
                begin
                    $normalattackpattern = rand($attack_pattern_max) + 1 # 味方通常攻撃
                    # p not_normalattackpattern.index($normalattackpattern),$normalattackpattern
                end until ok_normalattackpattern.index($normalattackpattern) != nil

            # $normalattackpattern = rand($attack_pattern_max) + 1 #味方通常攻撃
            else
                # skill
                attackPattern = $cha_set_action[@chanum] # 味方必殺
                if @all_attack_count == 1
                    if $battle_test_flag == false # 戦闘テスト時は実行しない(なぜかSコンボ時にエラーになるため)
                        tec_mp_cost = get_mp_cost($partyc[@chanum], $data_skills[attackPattern - 10].id, 1)
                    else
                        tec_mp_cost = 0
                    end
                    $cha_ki_zero[@chanum] = false

                    if $full_cha_ki_zero != nil
                        $full_cha_ki_zero[$partyc[@chanum]] = false
                    end

                    if @new_tecspark_flag == false # 閃き必殺を覚えた際はKiを消費しない
                        # 戦闘練習中でなければKIを消費する
                        if $game_switches[1305] != true
                            $game_actors[$partyc[@chanum]].mp -= tec_mp_cost
                        end
                    else
                        # @new_tecspark_flag = false
                    end
                    # $game_actors[$partyc[@chanum]].mp -= $data_skills[attackPattern - 10].mp_cost
                end
                # $game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState].mp_cost
            end

        elsif ($enecardi[@enenum] == 0 || $enecardi[@enenum] == $data_enemies[@enedatenum].hit - 1) && $data_enemies[@enedatenum].actions.size != 0
            # enemy skill
            attackPattern = @ene_set_action # 敵必殺

        else
            # enemy normal attack
            # 対象攻撃を格納
            ok_normalattackpattern = set_ok_normalattackpattern

            # p @ene_set_action #必だと 0になる
            attackPattern = @ene_set_action
            # attackPattern = rand($attack_pattern_max) + 1   #敵通常攻撃

            # 通常攻撃をセット
            begin
                $normalattackpattern = rand($attack_pattern_max) + 1 # 味方通常攻撃
                # p not_normalattackpattern.index($normalattackpattern),$normalattackpattern
            end until ok_normalattackpattern.index($normalattackpattern) != nil
            # $normalattackpattern = rand($attack_pattern_max) + 1 #敵通常攻撃
        end

        @battle_anime_frame = 0

        # 戦闘画像用の進行度格納
        if @attackDir == 0
            chk_scenario_progress($game_variables[40], 2) # 味方はそのまま進行度を格納
            $btl_progress = $game_variables[40]
        else
            if @enedatenum < $ene_str_no[1] # 敵は敵の番号見て格納
                $btl_progress = 0
            elsif @enedatenum < $ene_str_no[2]
                $btl_progress = 1
            else
                $btl_progress = 2
            end
            # 戦闘画像用の進行度格納
            chk_scenario_progress($btl_progress, 2)
        end

        # 戦闘背景用の進行度格納
        if $game_switches[466] != true # 戦闘背景を特殊進行度で格納するか
            chk_scenario_progress($game_variables[40], 3)
        else
            chk_scenario_progress($game_variables[301], 3)
        end

        # かばう戦闘シーンを表示していない
        $battle_kabau_scenesumi = false
        # かばう戦闘シーン実行中
        $battle_kabau_scenerun = false

        begin
            input_fast_fps()
            input_battle_fast_fps() if $game_variables[96] == 0

            @back_window.contents.clear
            output_back(attackPattern) # 背景更新

            # 発動スキルの表示(かばう用)
            if $battle_kabau_runcha != nil
                output_runskill(3) # 引数1で攻撃と判断
            end

            # 発動スキルの表示
            if $battle_kabau_runcha == nil
                output_runskill(1) # 引数1で攻撃と判断
            end
            # 巨大キャラの場合は技背景を小さくする
            if $data_enemies[@enedatenum].element_ranks[23] == 1 || $cha_bigsize_on[@chanum] == true
                @tec_back_small = true
            end

            # 真ん中移動を配列に入れランダム動作にする
            arr_mannakaidouno = [1, 5, 7, 8, 11, 12, 15]
            if @mannakaidouno == 0
                @mannakaidouno = arr_mannakaidouno[rand(arr_mannakaidouno.size)]
            end

            # 1:普通に真ん中に行く
            # 5:上下に揺れて
            # 7:両者上から下へ
            # 8:両者斜めから攻撃上、防御下
            # 11:商社斜め上からから登場味方左上、敵、右上
            # 12:両者小さいのでぶつかり上へ移動、上から登場して中央へ
            # 15:両者小さいので中央に行き通常の状態でセンターへ移動

            # けん制を配列に入れランダム動作にする
            arr_keinseino = [13, 18, 100001]
            if @keinseino == 0
                @keinseino = arr_keinseino[rand(arr_keinseino.size)]
            end
            # 13:両者小さいので2回ぶつかり左右から中央へ
            # 18:両者小さいのでぶつかり左右へ消える
            # 100001:小さいのでけん制しあう

            if @kenseiflag == nil
                if rand(2) == 1
                    @kenseiflag = true
                else
                    @kenseiflag = false
                end
            end
            # 戦闘テストの場合自動的にセット
            if $battle_test_flag == true
                attackPattern = $cha_set_action[0]
                $normalattackpattern = $test_normalattackpattern
                @mannakaidouno = 15
                # @keinseino = 1
            end

            begin # 例外検知発動
                # かばう戦闘シーンを表示するか
                if $battle_kabau_runcha != nil && $battle_kabau_scenesumi == false && $game_switches[884] == false
                    $battle_kabau_scenerun = true
                    @battle_anime_result = anime_pattern(39)
                elsif ($battle_kabau_scenesumi == true || $game_switches[884] == true) && $battle_kabau_runcha != nil
                    # かばう戦闘アニメが表示し終わったら初期化
                    # 初期化
                    $battle_kabau_runskill = nil
                    $battle_kabau_runcha = nil
                    $battle_kabawareru_runcha = nil

                    Graphics.fadeout(10) if $game_switches[884] == false
                    output_status()
                    @status_window.update()
                    @battle_anime_frame = -1
                    @battle_anime_result = 0
                    @runskill_frame = -1
                    @runskill_putx = []
                    Graphics.fadein(10) if $game_switches[884] == false
                else

                    case attackPattern  # cur: 0, 1, else

                    when 0

                    when 1  # normal attack
                        case $normalattackpattern  # cur: 1~18
                        when 1 # 通常攻撃単純(真ん中へ行って蹴り)
                            if @battle_anime_result == 0
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 1
                                set_def_attack()
                            elsif @battle_anime_result == 2
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 2 # 通常攻撃単純(両端から出てくる)
                            if @battle_anime_result == 0
                                # 両端から見合い
                                @battle_anime_result = anime_pattern(2)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(1)
                            elsif @battle_anime_result == 2
                                set_def_attack
                            elsif @battle_anime_result == 3
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 3 # 通常攻撃単純(真ん中へ回転)
                            if @battle_anime_result == 0
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(1)
                            elsif @battle_anime_result == 1
                                # ぶつかって斜めへ
                                @battle_anime_result = anime_pattern(3)
                            elsif @battle_anime_result == 2
                                # 回転
                                @battle_anime_result = anime_pattern(4)
                            elsif @battle_anime_result == 3
                                set_def_attack
                            elsif @battle_anime_result == 4
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 4 # 通常攻撃連打
                            if @battle_anime_result == 0
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(1)
                            elsif @battle_anime_result == 1
                                if @battle_anime_frame == 0
                                    Audio.se_play("Audio/SE/" + "Z1 打撃") # 効果音を再生する
                                end
                                # キック　左
                                set_def_attack(1)
                            elsif @battle_anime_result == 2
                                if @battle_anime_frame == 0
                                    Audio.se_play("Audio/SE/" + "Z1 打撃") # 効果音を再生する
                                end
                                # パンチ　右
                                set_def_attack(2)
                            elsif @battle_anime_result == 3
                                if @battle_anime_frame == 0
                                    Audio.se_play("Audio/SE/" + "Z1 打撃") # 効果音を再生する
                                end
                                # パンチ　左
                                set_def_attack(3)
                            elsif @battle_anime_result == 4
                                # キック　右
                                set_def_attack(4)
                            elsif @battle_anime_result == 5
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 5 # 通常攻撃 真ん中へ行ってから攻撃側がさがり打撃
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end

                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # 攻撃側後ろへ下がって前へ
                                @battle_anime_result = anime_pattern(6)
                            elsif @battle_anime_result == 3
                                set_def_attack
                            elsif @battle_anime_result == 4
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 6 # 通常攻撃 真ん中へ行ってから3回ぶつかって攻撃
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end

                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # 攻撃側後ろへ下がって前へ
                                @battle_anime_result = anime_pattern(9)
                            elsif @battle_anime_result == 3
                                set_def_attack
                            elsif @battle_anime_result == 4
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 7 # 通常攻撃 真ん中へ行ってから1回だけぶつかって攻撃
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # ぶつかって斜め
                                @battle_anime_result = anime_pattern(10)
                            elsif @battle_anime_result == 3
                                set_def_attack
                            elsif @battle_anime_result == 4
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 8 # 通常攻撃 真ん中へ行ってから1回ぶつかって、1買い下がって攻撃
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # ぶつかって斜め
                                @battle_anime_result = anime_pattern(10)
                            elsif @battle_anime_result == 3
                                # 攻撃側後ろへ下がって前へ
                                @battle_anime_result = anime_pattern(6)
                            elsif @battle_anime_result == 4
                                set_def_attack
                            elsif @battle_anime_result == 5
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 9 # 通常攻撃 両者小さいので2回ぶつかり左右から中央へ
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino) # 13
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(8)
                            elsif @battle_anime_result == 2
                                # 攻撃が下がって中央連打
                                @battle_anime_result = anime_pattern(14)
                            #      elsif @battle_anime_result == 3
                            #        set_def_attack
                            elsif @battle_anime_result == 3
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 10 # 通常攻撃 中央へ行って連打
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # 攻撃 中央連打
                                @battle_anime_result = anime_pattern(16)
                            #      elsif @battle_anime_result == 3
                            #        set_def_attack
                            elsif @battle_anime_result == 3
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 11 # 通常攻撃 中央へ行って連打、1回ぶつかり、止め
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # 攻撃 中央連打
                                @battle_anime_result = anime_pattern(17)
                            elsif @battle_anime_result == 3
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 12 # 通常攻撃 中央へ行って、消えながら連打
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # 消えながら連打
                                @battle_anime_result = anime_pattern(19)
                            elsif @battle_anime_result == 3
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 13 # 通常攻撃 回避して近づいて攻撃
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # 回避して近づいて攻撃
                                @battle_anime_result = anime_pattern(100101)
                            elsif @battle_anime_result == 3
                                set_def_attack
                            elsif @battle_anime_result == 4
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 14 # 通常攻撃 Z1 後ろに下がって溜めてから攻撃
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # 回避して近づいて攻撃
                                @battle_anime_result = anime_pattern(100102)
                            elsif @battle_anime_result == 3
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 15 # 通常攻撃 Z1中央上下中央で各3回攻撃
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # 回避して近づいて攻撃
                                @battle_anime_result = anime_pattern(100103)
                            elsif @battle_anime_result == 3
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 16 # 通常攻撃 Z1連打3回
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # 回避して近づいて攻撃
                                @battle_anime_result = anime_pattern(100104)
                            elsif @battle_anime_result == 3
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 17 # 通常攻撃 Z2連打
                            # けん制フラグによってけん制を飛ばすかどうか
                            if @kenseiflag == false && @battle_anime_result == 0
                                @battle_anime_result = 1
                            end
                            if @battle_anime_result == 0
                                # けん制
                                @battle_anime_result = anime_pattern(@keinseino)
                            elsif @battle_anime_result == 1
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 2
                                # 回避して近づいて攻撃
                                @battle_anime_result = anime_pattern(100105)
                            elsif @battle_anime_result == 3
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        when 18 # 通常攻撃何度か殴ってけん制(真ん中へ行って)
                            if @battle_anime_result == 0
                                # 攻撃・防御真ん中へ
                                @battle_anime_result = anime_pattern(@mannakaidouno)
                            elsif @battle_anime_result == 1
                                # 通常攻撃何度か殴ってけん制
                                @battle_anime_result = anime_pattern(100106)
                            elsif @battle_anime_result == 2
                                # 通常ダメージ
                                damage_pattern = 21
                                attackAnimeEnd = true
                            end
                        end  # end of case attackPattern==1
                    else  # skill
                        #p($btl_progress, attackPattern)
                        case $btl_progress  # 0,1,2 for Z1,Z2,Z3
                        # 必殺技
                        when 0  # Z1
                            case attackPattern
                            ##############################################################################
                            #
                            # Z1必殺技
                            #
                            ##############################################################################
                            when 11 # 衝撃波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(101)
                                elsif @battle_anime_result == 3
                                    # 衝撃波系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end

                            when 12 # エネルギー波

                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(102)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 13 # 複数エネルギー波

                            when 14 # 太陽拳

                            when 15 # かめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(105)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 16 # 界王拳
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(106)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 17 # 界王拳・かめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(107)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 28 # 元気弾
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(118)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 41 # 魔光砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(131)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 42 # 連続魔光砲

                            when 43 # 目から怪光線
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(133)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 44 # 口から怪光線
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(134)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 45 # 爆裂魔光砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(135)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 46 # 魔貫光殺砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(136)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 47 # 魔激砲

                            when 48 # 魔空波

                            when 49 # 激烈光弾

                            when 50 # 魔空包囲弾

                            when 56 # 魔光砲(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(146)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 57 # 魔閃光(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(147)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 61 # 大猿変身(悟飯)
                                @tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(151)
                                elsif @battle_anime_result == 3
                                    attackAnimeEnd = true
                                end
                            when 71 # エネルギー波(クリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(161)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 72 # カメハメ波(クリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(162)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 73 # 拡散エネルギー波(クリリン)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(163)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 24
                                    attackAnimeEnd = true
                                end
                            when 74 # 気円斬(クリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(164)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 81 # 狼牙風風拳
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(171)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 82 # かめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(172)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 83 # 繰気弾
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(173)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true

                                end
                            when 91 # エネルギー波(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(181)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 92 # 四身の拳(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(182)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 93 # 気功砲(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(183)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 94 # 四身の拳気功砲(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(184)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 24
                                    attackAnimeEnd = true
                                end
                            when 101 # どどんぱ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(191)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 102 # 超能力
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(192)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 25
                                    attackAnimeEnd = true
                                end
                            when 103 # サイコアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(193)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 29
                                    attackAnimeEnd = true
                                end

                            when 111 # 衝撃波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(101)
                                elsif @battle_anime_result == 3
                                    # 衝撃波系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 112 # ビーム
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(202)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 113 # 気功スラッガー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(203)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 114 # 超気功スラッガー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(204)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 169 # エネルギーは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1221)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 170 # 強力エネルギーは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1248)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 171 # 爆発波(バーダック)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1249)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 173 # ファイナルリベンジャー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1251)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 174 # スピリッツキャノン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1252)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 235 # 残像拳
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(325)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 236 # 元祖かめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(326)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 238 # 萬國驚天掌
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(328)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 73
                                    attackAnimeEnd = true
                                end
                            when 239 # MAXパワーかめはめは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(329)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 711 # 師弟の絆(ピッコロとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(801)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 714 # ダブル衝撃波(ゴクウとチチ)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(804)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 715 # 捨て身の攻撃(ゴクウとピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(805)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 716 # かめはめ乱舞(ゴクウとクリリンとヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(806)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 717 # 操気円斬(クリリンとヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(807)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 718 # 願いを込めた元気玉(ゴクウとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(808)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 27
                                    attackAnimeEnd = true
                                end
                            when 719 # ダブルどどんぱ(天津飯と餃子)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(809)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 720 # 超能力きこうほう(天津飯と餃子)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(810)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 28
                                    attackAnimeEnd = true
                                end
                            when 721 # 狼鶴相打陣(ヤムチャと天津飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(811)
                                elsif @battle_anime_result == 3
                                    @btl_ani_cha_chg_no = 7
                                    @battle_anime_result = anime_pattern(171)
                                elsif @battle_anime_result == 4
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(811)
                                elsif @battle_anime_result == 5
                                    @battle_anime_result = anime_pattern(182)
                                elsif @battle_anime_result == 6
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 740 # 亀仙流かめはめは(悟空クリリンヤムチャ亀仙人
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(830)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 749 # この世で一番強いヤツ(悟空ピッコロゴハンクリリン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(839)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 758 # もしもヤムチャに(悟空ヤムチャ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(848)
                                elsif @battle_anime_result == 3
                                    @btl_ani_cha_chg_no = 7
                                    @battle_anime_result = anime_pattern(171)
                                elsif @battle_anime_result == 4
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(848)
                                elsif @battle_anime_result == 5
                                    if @btl_ani_cha_chg_no != 3 && $super_saiyazin_flag[1] != true || @btl_ani_cha_chg_no != 14 && $super_saiyazin_flag[1] == true
                                        @chay = STANDARD_CHAY
                                        @chax = TEC_CENTER_CHAX
                                    end
                                    if $super_saiyazin_flag[1] != true
                                        @btl_ani_cha_chg_no = 3
                                    else
                                        @btl_ani_cha_chg_no = 14
                                    end
                                    @battle_anime_result = anime_pattern(105)
                                elsif @battle_anime_result == 6
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 761 # ありがとうピッコロさん！(ピッコロとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(851)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 762 # 行くぞクリリン(ピッコロとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(852)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 829 # ダブルアイビーム(ピッコロと天津飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(919)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 311 # 痺れ液(カイワレマン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(401)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 312 # 痺れ液(キュウコンマン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(401)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 313 # 痺れ液(サイバイマン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(403)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 314 # 自爆(サイバイマン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(404)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 315 # エネルギー波(パンプキン系)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(405)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 316 # エネルギー波(パンプキン系)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(406)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 394 # 大猿変身(オニオン)

                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(484)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 26
                                    attackAnimeEnd = true

                                end
                            when 317 # エネルギー波(ジンジャー系)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(407)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 318 # 強力エネルギー波(ジンジャー系)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(408)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 319 # 刀攻撃(ジンジャー系)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(409)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 320 # エネルギー波(ラディッツ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(410)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 321 # 強力エネルギー波(ラディッツ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(411)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 322 # エネルギー波(ナッパ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(412)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 323 # 爆発波(ナッパ)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(413)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 324 # 口からエネルギー波(ナッパ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(414)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 325 # 衝撃波(ベジータ)

                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(101)
                                elsif @battle_anime_result == 3
                                    # 衝撃波系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true

                                end
                            when 326 # エネルギー波(ベジータ)

                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(416)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true

                                end
                            when 328 # 気円斬(ベジータ)

                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(418)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true

                                end
                            when 329 # 爆発波(ベジータ)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(419)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 330 # ギャリック砲(ベジータ)

                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(420)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true

                                end
                            when 383 # 大猿変身(ベジータ)
                                @ene_tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(473)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    # damage_pattern = 26
                                    attackAnimeEnd = true

                                end
                            when 595 # エネルギーは(大猿ベジータ)
                                @ene_tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(685)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true

                                end
                            when 331 # エネルギー波(ニッキー系)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(407)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 332 # 強力エネルギー波(ニッキー系)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(408)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 333 # 刀攻撃(ニッキー系)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(409)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 334 # エネルギー波(サンショ系)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(424)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 335 # 強力エネルギー波(サンショ系)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(425)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 336 # エネルギー弾(ガーリック)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(426)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 338 # 強力エネルギー波(ガーリック)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(428)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 339 # 強力エネルギー波(ガーリック巨大化)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(429)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 340 # ブラックホール波(ガーリック巨大化)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(430)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 469 # キシーメ電磁ムチ(強
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(559)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 472 # エビ氷結攻撃
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(562)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 70
                                    attackAnimeEnd = true
                                end
                            when 473 # ミソ皮伸び攻撃
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(563)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 71
                                    attackAnimeEnd = true
                                end
                            when 474 # ミソエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(564)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 475 # ミソ強力エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(565)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 596 # エネルギーは(Drウィロー)
                                @ene_tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(686)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true

                                end
                            when 597 # フォトンストライク(両手エネルギー波(Drウィロー)
                                @ene_tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(687)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true

                                end
                            when 598 # 口からエネルギー波(Drウィロー)
                                @ene_tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(688)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true

                                end
                            when 599 # ギガンティックボマー(Drウィロー)
                                @ene_tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(689)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 600 # プラネットゲイザー(Drウィロー)
                                @ene_tec_oozaru = true
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(690)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true

                                end
                            end

                        when 1  # Z2
                            case attackPattern
                            ##############################################################################
                            #
                            # Z2必殺技
                            #
                            ##############################################################################
                            when 11 # 衝撃波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1101)
                                elsif @battle_anime_result == 3
                                    # 衝撃波系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 12 # エネルギー波(悟空)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1102)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 13 # 複数エネルギー波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    # @tec_output_back_no = 1
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2494)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 15 # カメハメ波(悟空)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1105)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 16 # 界王拳
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1106)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 17 # 界王拳・かめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1107)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 28 # 元気弾
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1118)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 29 # 超元気弾
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1119)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 30 # 超元気弾(イベント用)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1120)
                                elsif @battle_anime_result == 3
                                    attackAnimeEnd = true
                                end
                            when 36 # スーパーカメハメ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1126)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    # damage_pattern = 42
                                    # if $game_variables[40] >= 2
                                    #  damage_pattern = 42
                                    # else
                                    #  damage_pattern = 23
                                    # end
                                    attackAnimeEnd = true
                                end
                            when 41 # 魔光砲(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1131)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 43 # 目から怪光線(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1133)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 44 # 口から怪光線(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1134)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 45 # 爆裂魔光砲(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1135)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 46 # 魔貫光殺砲(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1136)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 56 # 魔光砲(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1146)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 57 # 魔閃光(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1147)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 62 # 爆裂ラッシュ(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1152)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ

                                    if $btl_progress >= 2
                                        damage_pattern = 46
                                    else
                                        damage_pattern = 24
                                    end
                                    attackAnimeEnd = true
                                end
                            when 71 # エネルギー波(クリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1146)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 72 # カメハメ波(クリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1162)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 73 # 拡散エネルギー波(クリリン)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1163)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 74 # 気円斬(クリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1164)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 81 # 狼牙風風拳
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(171)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 82 # カメハメ波(ヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1105)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 83 # 繰気弾(ヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1173)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 91 # エネルギー波(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1102)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 92 # 四身の拳(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1182)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 93 # 気功砲(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1183)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 94 # 四身の拳気功砲(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1184)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 24
                                    attackAnimeEnd = true
                                end
                            when 101 # どどんぱ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1191)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 102 # 超能力
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1192)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 25
                                    attackAnimeEnd = true
                                end
                            when 103 # サイコアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(193)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 29
                                    attackAnimeEnd = true
                                end
                            when 111 # 衝撃波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1101)
                                elsif @battle_anime_result == 3
                                    # 衝撃波系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 112 # ビーム
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1202)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 113 # 気功スラッガー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1203)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 114 # 超気功スラッガー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1204)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 131 # エネルギーは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1221)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 133 # 爆発波(ベジータ)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1223)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 134 # ギャリック砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1224)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 151 # エネルギー波(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1131)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 152 # 口から怪光線(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1242)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 153 # 強力エネルギー波(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1243)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 154 # ナメック戦士(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1244)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 155 # 魔貫光殺砲(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    # @tec_back_color = 1
                                    # @tec_output_back_no = 3
                                    @battle_anime_result = anime_pattern(32)
                                # @tec_output_back = false
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1245)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 157 # エネルギーは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1221)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 158 # 強力エネルギーは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1248)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 159 # 爆発波(バーダック)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1249)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 161 # ファイナルリベンジャー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1251)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 162 # スピリッツキャノン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1252)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 179 # 惑星戦士たちとの戦い(イベント用)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1269)
                                elsif @battle_anime_result == 3
                                    attackAnimeEnd = true
                                end
                            when 180 # フリーザとの戦い(イベント用)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1270)
                                elsif @battle_anime_result == 3
                                    attackAnimeEnd = true
                                end
                            when 235 # 残像拳
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(325)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 236 # 元祖かめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1326)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 238 # 萬國驚天掌
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1328)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 73
                                    attackAnimeEnd = true
                                end
                            when 239 # MAXパワーかめはめは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1329)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 256, 265, 275, 283 # エネルギーは(トーマ、セリパ、トテッポ、パンブーキン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    damage_pattern = 42 if $cha_bigsize_on[@chanum] == true
                                    attackAnimeEnd = true
                                end
                            # 連続エネルギー波(全体)
                            when 257, 266, 276, 284
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    # @tec_output_back_no = 1
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2494)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 258, 267, 277, 285 # 強力エネルギーは(トーマ、セリパ、トテッポ、パンブーキン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2499)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    damage_pattern = 44 if $cha_bigsize_on[@chanum] == true
                                    attackAnimeEnd = true
                                end
                            when 259 # トーマ(エネルギーボール
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1349)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 24
                                    attackAnimeEnd = true
                                end
                            when 261, 272, 280, 288 # 大猿変身
                                @tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1351)
                                elsif @battle_anime_result == 3
                                    attackAnimeEnd = true
                                end
                            when 269 # セリパ(ヒステリックサイヤンレディ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1359)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 278 # トテッポ(アングリーアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1368)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 286 # パンブーキン(マッシブカタパルト
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1376)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 711 # 師弟の絆(ピッコロとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1801)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 713 # サイヤンアタック(ゴクウとバーダック)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1803)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 714 # ダブル衝撃波(ゴクウとチチ)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1804)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 715 # 捨て身の攻撃(ゴクウとピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1805)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 716 # かめはめ乱舞(ゴクウとクリリンとヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1806)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 717 # 操気円斬(クリリンとヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1807)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 718 # 願いを込めた元気玉(ゴクウとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1808)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 27
                                    attackAnimeEnd = true
                                end
                            when 719 # ダブルどどんぱ(テンシンハンとチャオズ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1809)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 720 # 超能力きこうほう(天津飯と餃子)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1810)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 28
                                    attackAnimeEnd = true
                                end
                            when 721 # 狼鶴相打陣(ヤムチャと天津飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1811)
                                elsif @battle_anime_result == 3
                                    @btl_ani_cha_chg_no = 7
                                    # @tec_output_back = true
                                    @battle_anime_result = anime_pattern(171)
                                elsif @battle_anime_result == 4
                                    # 必殺技発動
                                    @tec_output_back = true
                                    @battle_anime_result = anime_pattern(1811)
                                elsif @battle_anime_result == 5
                                    @tec_output_back = true
                                    @battle_anime_result = anime_pattern(1182)
                                elsif @battle_anime_result == 6
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 723 # ギャリックかめはめは(ゴクウとベジータ)
                                @damage_huttobi = false
                                @damage_center = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1813)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 724 # どどはめは(ヤムチャとテンシンハンとチャオズ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1814)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 732 # 気の開放(ゴハンとクリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1822)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 735 # アウトサイダーショット(ピッコロとバーダック)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2825)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 740 # 亀仙流かめはめは(悟空クリリンヤムチャ亀仙人
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1830)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 742 # サイヤンアタック(トーマ＆パンブーキン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1832)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 743 # アウトサイダーショット(バーダックとトーマ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1833)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 744 # サイヤンアタック(セリパ＆トテッポ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1834)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 745 # アウトサイダーショット(バーダックとセリパ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1835)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 746 # アウトサイダーショット(バーダックとトテッポ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1836)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 747 # アウトサイダーショット(バーダックとパンブーキン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1837)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 749 # この世で一番強いヤツ(悟空ピッコロゴハンクリリン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1839)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 752 # 強襲サイヤ人(トーマたち)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    # @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1842)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 758 # もしもヤムチャに…(悟空とヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1848)
                                elsif @battle_anime_result == 3
                                    @btl_ani_cha_chg_no = 7
                                    # @tec_output_back = true
                                    @battle_anime_result = anime_pattern(171)
                                elsif @battle_anime_result == 4
                                    # 必殺技発動
                                    @tec_output_back = true
                                    @battle_anime_result = anime_pattern(1848)
                                elsif @battle_anime_result == 5
                                    if @btl_ani_cha_chg_no != 3 && $super_saiyazin_flag[1] != true || @btl_ani_cha_chg_no != 14 && $super_saiyazin_flag[1] == true
                                        @chay = STANDARD_CHAY
                                        @chax = TEC_CENTER_CHAX
                                    end
                                    if $super_saiyazin_flag[1] != true
                                        @btl_ani_cha_chg_no = 3
                                    else
                                        @btl_ani_cha_chg_no = 14
                                    end
                                    @tec_output_back = true
                                    @battle_anime_result = anime_pattern(1105)
                                elsif @battle_anime_result == 6
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end

                            when 761 # ありがとうピッコロさん！(ピッコロとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1851)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 762 # 行くぞクリリン(ピッコロとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1852)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 766 # 油断してやがったな(悟飯とベジータ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1856)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 767 # ありがとうピッコロさん！(若者とゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1857)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 768 # 地球の方(若者とクリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1858)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 769 # なぜかいきのあう(若者とヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1859)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 78
                                    attackAnimeEnd = true
                                end
                            when 775 # アウトサイダーショット(トーマとセリパ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1865)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 776 # アウトサイダーショット(トーマとトテッポ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1866)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 777 # アウトサイダーショット(セリパとトテッポ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1867)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 778 # アウトサイダーショット(トテッポとパンブーキン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1868)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 814 # 絶好のチャンス(ゴハンとクリリンとベジータ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1904)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 815 # オレを半殺しにしろ(クリリン、ベジータ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1905)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 816 # 超サイヤ人だ孫悟空(悟空、ピッコロ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1906)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 819 # 地球丸ごと超決戦
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1909)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 829 # ダブルアイビーム(ピッコロと天津飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1919)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 886 # 決死の超元気玉
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1976)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 48
                                    attackAnimeEnd = true
                                end
                            when 341 # (ナップル系)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 342 # (グプレー系)ビームガン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 343 # (アプール系)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 344 # (キュイ系)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 345 # キュイ系爆発波

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1435)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 346 # (キュイ系)連続エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1436)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 347 # (ドドリア系)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1437)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 348 # (ドドリア系)口から怪光線
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1438)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 349 # (ドドリア系)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1439)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 350 # (ザーボン系)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1440)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 351 # (ザーボン系)スーパーエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1441)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 352 # (ザーボン系)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1442)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 353 # (ザーボン変身)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1443)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 354 # (ザーボン変身)スーパーエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1444)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 355 # (ギニュー)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1445)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 356 # (ギニュー)スーパーエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1446)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 357 # (ギニュー)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1447)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 359 # (ジース)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1449)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 360 # (ジース)クラッシャーボール
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1450)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 361 # (バータ)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1451)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 362 # (バータ)スピードアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1452)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 363 # (リクーム)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1453)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 364 # (リクーム)連続エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(1454)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 365 # (リクーム)イレイザーガン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1455)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 366 # (グルド)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1456)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 367 # (グルド)タイムストップ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1457)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 25
                                    attackAnimeEnd = true
                                end
                            when 368 # (フリーザ)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1458)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 369 # (フリーザ)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1459)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 370 # (フリーザ)スーパーエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1460)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 371 # (フリーザ1)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1461)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 372 # (フリーザ1)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1462)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 373 # (フリーザ1)スーパーエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1463)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 374 # (フリーザ2)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1464)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 375 # (フリーザ2)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1465)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 376 # (フリーザ2)スーパーエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1466)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 377 # (フリーザ3)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1467)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 378 # (フリーザ3)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1468)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 379 # (フリーザ3)スーパーエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1469)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 634 # (フリーザ3)デスボール
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1724)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 704 # (フリーザ3)殺されるべきなんだ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1794)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 380 # (超ベジータ)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 381 # (超ベジータ)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1223)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 382 # (超ベジータ)ギャリック砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1224)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 705 # (超ベジータ)スーパーギャリック砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1795)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 384 # エネルギーは(ターレス
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1474)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 385 # 爆発波(ターレス
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1475)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 386 # キルドライバー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1476)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 387 # メテオバースト
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1477)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 654 # 大猿変身(ターレス)
                                @ene_tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                    @tec_output_back_no = 1 # 必殺背景縦
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1744)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    # damage_pattern = 26
                                    attackAnimeEnd = true
                                end
                            when 388 # エネルギーは(スラッグ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1478)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 389 # 爆発波(スラッグ
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1479)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 390 # ビッグスマッシャー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1480)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 391 # メテオバースト
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1481)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 655 # スラッグ巨大化
                                @ene_tec_oozaru = true

                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1745)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    # damage_pattern = 26
                                    attackAnimeEnd = true
                                end
                            when 392, 393 # (ジース,バータ)パープルコメットクラッシュ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1482)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 476 # (惑星戦士1)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 477 # (惑星戦士2)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 478 # (惑星戦士3)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 479 # (惑星戦士4)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            # Z2敵汎用エネルギー波
                            when 635, 639, 642, 646, 649, 656, 660, 663, 667, 670
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 636 # アモンド気円斬
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1726)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 637 # アモンドプラネットボム
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1727)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 640 # コズミックアタック(カカオ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1730)
                                elsif @battle_anime_result == 3
                                    # コズミックアタックダメージ
                                    damage_pattern = 80
                                    attackAnimeEnd = true
                                end
                            when 643 # 爆発波(ダイーズ
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1733)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 644 # メテオボール(ダイーズ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1734)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 647, 650 # ダブルエネルギー波 レズン、ラカセイ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1740)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 657 # エビルクエーサー アンギラ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1747)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 658 # 手が伸びる アンギラ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1748)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 661 # エビルグラビティ ドロダボ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1751)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 664 # エビルコメット メダマッチャ
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1754)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 665 # カエル攻撃 メダマッチャ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1755)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 25 # 23
                                    attackAnimeEnd = true
                                end
                            when 668 # エビルインパクト ゼエウン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1758)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 671 # アンギラとメダマッチャ腕伸びるカエル攻撃
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1761)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            else
                                if $battle_test_flag == true
                                    damage_pattern = @test_damage_pattern
                                else
                                    damage_pattern = 41
                                end
                                attackAnimeEnd = true
                            end
                        when 2  # Z3
                            case attackPattern
                            ##############################################################################
                            #
                            # Z3必殺技
                            #
                            ##############################################################################
                            when 11 # 衝撃波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1101)
                                elsif @battle_anime_result == 3
                                    # 衝撃波系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 12 # エネルギー波(悟空)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1102)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 15 # カメハメ波(悟空)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1105)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 16 # 界王拳
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true if $btl_progress >= 2
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1106)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 17 # 界王拳・かめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true if $btl_progress >= 2
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1107)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 28 # 元気弾
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    # @tec_output_back = false
                                    @tec_output_back_no = 1
                                    @battle_anime_result = anime_pattern(32)
                                # @tec_output_back = false
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    # @tec_output_back_no = 1
                                    # @tec_output_back = true
                                    @battle_anime_result = anime_pattern(2118)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 29 # 超元気弾
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_output_back_no = 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2119)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 36 # スーパーカメハメ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1126)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    # damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 37 # 瞬間移動カメハメ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2127)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    # damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 39, 69, 143, 168, 195, 255 # 超サイヤ人変身
                                @tec_tyousaiya = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2129)
                                elsif @battle_anime_result == 3
                                    attackAnimeEnd = true
                                end
                            when 41 # 魔光砲(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1131)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 42 # 爆裂波(ピッコロ)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    # @tec_output_back_no = 1
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2132)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 43 # 目から怪光線(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1133)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 44 # 口から怪光線(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1134)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 45 # 爆裂魔光砲(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1135)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 46 # 魔貫光殺砲(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_color = 1
                                    @tec_output_back_no = 3
                                    @battle_anime_result = anime_pattern(32)
                                    @tec_output_back = false
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2136)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 49 # 激烈光弾(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_color = 1
                                    @tec_output_back_no = 0
                                    @battle_anime_result = anime_pattern(32)
                                # @tec_output_back = false
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2139)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ

                                    if $game_variables[96] != 4
                                        damage_pattern = 42
                                        attackAnimeEnd = true
                                    else
                                        damage_pattern = 49
                                        attackAnimeEnd = true
                                    end
                                end
                            when 50 # 魔空包囲弾(ピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_color = 1
                                    @tec_output_back_no = 0
                                    @battle_anime_result = anime_pattern(32)
                                # @tec_output_back = false
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2140)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ

                                    if $game_variables[96] != 3
                                        damage_pattern = 42
                                        attackAnimeEnd = true
                                    else
                                        damage_pattern = 50
                                        attackAnimeEnd = true
                                    end
                                end
                            when 56 # 魔光砲(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1146)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 57 # 魔閃光(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2147)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 58 # カメハメ波(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1148)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 62 # 爆裂ラッシュ(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1152)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 46
                                    attackAnimeEnd = true
                                end
                            when 63 # 激烈ませんこう
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true

                                    # @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2153)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    # damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 64 # スーパーかめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2154)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    # damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 71 # エネルギー波(クリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1146)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 72 # カメハメ波(クリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1162)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 73 # 拡散エネルギー波(クリリン)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_output_back_no = 1
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2163)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 24
                                    attackAnimeEnd = true
                                end
                            when 74 # 気円斬(クリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2164)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 75 # 気円烈斬(クリリン)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @tec_output_back_no = 0
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2165)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 81 # 狼牙風風拳
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(171)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 82 # カメハメ波(ヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1105)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 83 # 繰気弾(ヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2173)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 84 # 超繰気弾(ヤムチャ)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_output_back_no = 1
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2174)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 85 # 新狼牙風風拳(ヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2175)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 91 # エネルギー波(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1102)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 92 # 四身の拳(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2182)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 93 # 気功砲(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2183)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 94 # 四身の拳気功砲(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2184)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 46
                                    attackAnimeEnd = true
                                end
                            when 95 # 新気功砲(テンシンハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2185)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 47
                                    attackAnimeEnd = true
                                end
                            when 101 # どどんぱ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1191)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 102 # 超能力
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2192)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 25
                                    attackAnimeEnd = true
                                end
                            when 103 # サイコアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(193)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 29
                                    attackAnimeEnd = true
                                end
                            when 104 # 超能力(全体)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_output_back_no = 1
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2194)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 76
                                    attackAnimeEnd = true
                                end
                            when 105 # おもいっきりどどんぱ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2195)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 111 # 衝撃波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1101)
                                elsif @battle_anime_result == 3
                                    # 衝撃波系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 112 # ビーム
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1202)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 113 # 気功スラッガー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1203)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 114 # 超気功スラッガー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1204)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 117 # 芭蕉扇
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    # @tec_output_back = false
                                    # @chr_cutin = true
                                    # @chr_cutin_flag = true
                                    # @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2207)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 131 # エネルギーは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1221)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 133 # 爆発波(ベジータ)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2223)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 134 # ギャリック砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1224)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 135 # ビッグバンアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_color = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2225)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 140 # ファイナルフラッシュ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_color = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2230)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 151 # エネルギー波(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1131)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 152 # 口から怪光線(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1242)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 153 # 強力エネルギー波(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1243)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 154 # ナメック戦士(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1244)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 155 # 魔貫光殺砲(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    # @tec_back_color = 1
                                    # @tec_output_back_no = 3
                                    @battle_anime_result = anime_pattern(32)
                                    @tec_output_back = false
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1245)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 156 # ミスティックフラッシャー(若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    # @tec_back_color = 1
                                    # @tec_output_back_no = 3
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                # @tec_output_back = false
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2246)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 79
                                    attackAnimeEnd = true
                                end

                            # バーダック
                            when 157 # エネルギーは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1221)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 158 # 強力エネルギーは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1248)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 159 # 爆発波(バーダック)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1249)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 161 # ファイナルリベンジャー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1251)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 162 # スピリッツキャノン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1252)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 165 # スーパーファイナルリベンジャー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2255)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 181 # エネルギー波(トランクス)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1102)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end

                            when 182, 417, 510 # カタナ攻撃(トランクス、サウザー、ゴクア)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2272)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 183 # 爆発波(トランクス)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2273)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 184 # ませんこう(トランクス)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2274)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 186 # バーニングアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_color = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2276)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end

                            when 187 # シャイニングソードアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_color = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2277)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true

                                end
                            when 188 # ヒートドームアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    # @tec_back_color = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2278)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    @tec_output_back_no = 1
                                    damage_pattern = 72
                                    attackAnimeEnd = true
                                end
                            when 191 # フィニッシュバスター
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    # @tec_back_color = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2281)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 204 # 気円斬(18号
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2294)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 208 # エネルギーウェイブ(18号
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2298)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 218 # エネルギーウェイブ(17号
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2308)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 224 # ロケットパンチ(16号
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2314)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 225 # ヘルズフラッシュ(16号
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2315)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 227 # 自爆(16号
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2317)
                                elsif @battle_anime_result == 3
                                    #  #何も起きない
                                    damage_pattern = 0
                                    attackAnimeEnd = true
                                end
                            when 235 # 残像拳
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(325)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 236 # 元祖かめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1326)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 238 # 萬國驚天掌
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1328)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 73
                                    attackAnimeEnd = true
                                end
                            when 239 # MAXパワーかめはめは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2329)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 240 # 魔封波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2330)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 246 # まこうほう(未来悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2336)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 247 # ませんこう
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true

                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2337)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 248 # 超爆力波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2338)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 250 # 魔貫光殺砲(未来悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    # @tec_back_color = 1
                                    # @tec_output_back_no = 3
                                    @battle_anime_result = anime_pattern(32)
                                    @tec_output_back = false
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2340)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 251 # スーパーカメハメ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2341)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 252 # 爆裂乱舞
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2342)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 256, 265, 275, 283 # エネルギーは(トーマ、セリパ、トテッポ、パンブーキン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    damage_pattern = 42 if $cha_bigsize_on[@chanum] == true
                                    attackAnimeEnd = true
                                end
                            # 連続エネルギー波(全体)
                            when 257, 266, 276, 284
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    # @tec_output_back_no = 1
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2494)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 258, 267, 277, 285 # 強力エネルギーは(トーマ、セリパ、トテッポ、パンブーキン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2499)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    damage_pattern = 44 if $cha_bigsize_on[@chanum] == true
                                    attackAnimeEnd = true
                                end
                            when 259 # トーマ(エネルギーボール
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1349)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 24
                                    attackAnimeEnd = true
                                end
                            when 260 # トーマ(フルパワーフレイムバレット
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2350)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 261, 272, 280, 288 # 大猿変身
                                @tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1351)
                                elsif @battle_anime_result == 3
                                    attackAnimeEnd = true
                                end
                            when 269 # セリパ(ヒステリックサイヤンレディ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1359)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 270 # セリパ(ハンティングアロー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2360)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 278 # トテッポ(アングリーアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1368)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 279 # トテッポ(アングリーキャノン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2369)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 286 # パンブーキン(マッシブカタパルト
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1376)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 287 # パンブーキン(マッシブキャノン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2377)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 298 # ダイナマイトキック(イベント用)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2388)
                                elsif @battle_anime_result == 3
                                    # 何もしないで次へ
                                    damage_pattern = 40
                                    attackAnimeEnd = true
                                end
                            when 711 # 師弟の絆(ピッコロとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1801)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 713 # サイヤンアタック(ゴクウとバーダック)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1803)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 714 # ダブル衝撃波(ゴクウとチチ)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1804)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 715 # 捨て身の攻撃(ゴクウとピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1805)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 716 # かめはめ乱舞(ゴクウとクリリンとヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1806)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 717 # 操気円斬(クリリンとヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1807)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 718 # 願いを込めた元気玉(ゴクウとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1808)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 27
                                    attackAnimeEnd = true
                                end
                            when 719 # ダブルどどんぱ(テンシンハンとチャオズ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1809)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 720 # 超能力きこうほう(天津飯と餃子)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1810)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 28
                                    attackAnimeEnd = true
                                end
                            when 721 # 狼鶴相打陣(ヤムチャと天津飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1811)
                                elsif @battle_anime_result == 3
                                    @btl_ani_cha_chg_no = 7
                                    # @tec_output_back = true
                                    @battle_anime_result = anime_pattern(171)
                                elsif @battle_anime_result == 4

                                    # 必殺技発動
                                    @tec_output_back = true
                                    @battle_anime_result = anime_pattern(1811)
                                elsif @battle_anime_result == 5
                                    @tec_output_back = true
                                    @battle_anime_result = anime_pattern(1182)
                                elsif @battle_anime_result == 6
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 722 # 地球人ストライク(クリリン、ヤムチャ、テンシンハン、チャオズ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2812)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 46
                                    attackAnimeEnd = true
                                end
                            when 723 # ギャリックかめはめは(ゴクウとベジータ)
                                @damage_huttobi = false
                                @damage_center = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1813)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 724 # どどはめは(ヤムチャとテンシンハンとチャオズ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1814)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 726 # ノンステップバイオレンス(17号と18号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2816)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 728 # ヘルズスパイラル(16号と17号と18号)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2818)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 729 # ダブル気円斬(クリリンと18号)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2819)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 730 # ギャリックバスター(ベジータとトランクス)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2820)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 732 # 気の開放(ゴハンとクリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1822)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 733 # 眠れる力(ごはんと16号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2823)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 735 # アウトサイダーショット(ピッコロとバーダック)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2825)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 736 # ダブルませんこう(ゴハンとトランクス)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2826)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 737 # ダブルまかんこうさっぽう(ピッコロと未来ゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2827)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 738 # 答えは8だ(クリリンとチャオズ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1828)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 739 # 四身の拳・かめはめは(ごくうとテンシンハン)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2829)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 740 # 亀仙流かめはめは(悟空クリリンヤムチャ亀仙人
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1830)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 742 # サイヤンアタック(トーマ＆パンブーキン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1832)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 743 # アウトサイダーショット(バーダックとトーマ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1833)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 744 # サイヤンアタック(セリパ＆トテッポ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1834)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 745 # アウトサイダーショット(バーダックとセリパ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1835)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 746 # アウトサイダーショット(バーダックとトテッポ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1836)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 747 # アウトサイダーショット(バーダックとパンブーキン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1837)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 748 # 3大超サイヤ人
                                $goku3dai = false
                                # ゴクウが通常の時は超サイヤ人に変身する
                                @tec_tyousaiya = true if $super_saiyazin_flag[1] != true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2838)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 749 # この世で一番強いヤツ(悟空ピッコロゴハンクリリン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2839)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 750 # メタルクラッシュ(超悟空と超ベジータ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2840)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 74
                                    attackAnimeEnd = true
                                end
                            when 751 # あっちいってけろ(ヤムチャチチ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2841)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 752 # 強襲サイヤ人(トーマたち)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    # @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1842)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 753 # アウトサイダーショット(ピッコロと17号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2843)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 754 # よけられるハズだべ・・・(チチかめせんにん
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2844)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 755 # うごきをとめろ(亀仙人とテンシンハンとチャオズ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2845)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 756 # ダブル残像拳(ごくうとクリリン)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2846)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 757 # 師弟アタック(未来悟飯とトランクス)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2847)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 758 # もしもヤムチャに…(悟空とヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1848)
                                elsif @battle_anime_result == 3
                                    @btl_ani_cha_chg_no = 7
                                    # @tec_output_back = true
                                    @battle_anime_result = anime_pattern(171)
                                elsif @battle_anime_result == 4
                                    # 必殺技発動
                                    @tec_output_back = true
                                    @battle_anime_result = anime_pattern(1848)
                                elsif @battle_anime_result == 5
                                    if @btl_ani_cha_chg_no != 3 && $super_saiyazin_flag[1] != true || @btl_ani_cha_chg_no != 14 && $super_saiyazin_flag[1] == true
                                        @chay = STANDARD_CHAY
                                        @chax = TEC_CENTER_CHAX
                                    end
                                    if $super_saiyazin_flag[1] != true
                                        @btl_ani_cha_chg_no = 3
                                    else
                                        @btl_ani_cha_chg_no = 14
                                    end
                                    @tec_output_back = true
                                    @battle_anime_result = anime_pattern(1105)
                                elsif @battle_anime_result == 6
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 759 # ダブル残像拳(クリリンと亀仙人)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true if $btl_progress >= 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2846)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 760 # 打て！悟飯(ピッコロとゴハンとクリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1850)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 761 # ありがとうピッコロさん！(ピッコロとゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1851)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 762 # 行くぞクリリン(ピッコロとクリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1852)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 764 # お母さんをいじめるな　悟飯とチチ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2854)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 46
                                    attackAnimeEnd = true
                                end
                            when 765 # アウトサイダーショット(ピッコロとベジータ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2855)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 766 # 油断してやがったな(悟飯とベジータ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1856)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 767 # ピッコロさん！？(若者とゴハン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1857)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 768 # 地球の方(若者とクリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1858)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 769 # なぜかいきのあう(若者とヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1859)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 78
                                    attackAnimeEnd = true
                                end
                            when 770 # ダブルまかんこうさっぽう(ピッコロとわかもの)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2860)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 771 # 大師匠と孫弟子(ピッコロとトランクス)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2861)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 772 # ダブルスラッシュ(トランクスとクリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2862)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 773 # ギャリックかめはめは(ヤムチャとベジータ)
                                @damage_huttobi = false
                                @damage_center = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2863)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 774 # 親子かめはめ波(悟空と悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2864)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 775 # アウトサイダーショット(トーマとセリパ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1865)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 776 # アウトサイダーショット(トーマとトテッポ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1866)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 777 # アウトサイダーショット(セリパとトテッポ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1867)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 778 # アウトサイダーショット(トテッポとパンブーキン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1868)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 779 # ダブルまかんこうさっぽう(未来悟飯とわかもの)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2869)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 780 # 母さんは俺が守る　未来悟飯とチチ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2870)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 781 # ダブルませんこう(未来ゴハンとトランクス)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2871)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 782 # トリプルませんこう(悟飯、未来ゴハンとトランクス)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2872)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 783 # トリプル魔貫光殺法(ピッコロ、未来ゴハンと若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2873)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 784 # アウトサイダーショット(ピッコロと18号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2874)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 785 # アウトサイダーショット(ピッコロと16号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2875)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 786 # アウトサイダーショット(未来悟飯と18号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2876)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 787 # アウトサイダーショット(未来悟飯と17号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2877)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 788 # アウトサイダーショット(未来悟飯と16号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2878)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 789 # アウトサイダーショット(未来悟飯とベジータ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2879)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 790 # 超爆力魔波(未来悟飯とピッコロ)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2880)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 791 # ダブルアタック(天津飯とトランクス)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2881)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 792 # ダブルアタック(チャオズとトランクス)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2882)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 793 # 悟飯ちゃんを巻き込む出ねえ(チチとピッコロ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2883)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 794 # 悟空さを巻き込む出ねえ(チチとベジータ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2884)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 795 # 戦闘民族サイヤ人、バーダック、トーマ、セリパたち
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2885)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 796 # ダブルかめはめ波(悟空)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2886)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 797 # ダブルかめはめ波(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2887)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 798 # ダブルかめはめ波(クリリン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2888)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 799 # ダブルかめはめ波(ヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2889)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 800 # ダブルかめはめ波(ヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2890)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 801 # かめはめ乱舞(親子)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2891)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 802 # アンドロイドストライク
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2892)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 803 # あの時の借りを返すよ！(天津飯と18号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2893)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 804 # あの時の借りを返すぞ！(天津飯と16号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2894)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 805 # 借りがあるらしいな！(天津飯と17号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2895)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 806 # あんたも助けるよ！(チャオズと18号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2896)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 807 # お前も助けるぞ！(チャオズと16号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2897)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 808 # 今度は俺が助けてやる(チャオズと17号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2898)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 809 # 流派を超えた連携(天津飯と亀仙人)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2899)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 47
                                    attackAnimeEnd = true
                                end
                            when 810 # 流派を超えた連携(チャオズと亀仙人)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2900)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 811 # ダブル魔封波(ピッコロと亀仙人)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2901)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 812 # ダブル魔封波(若者と亀仙人)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2902)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 813 # スピリッツかめはめ波(悟空とバーダック)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2903)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 814 # 絶好のチャンス(ゴハンとクリリンとベジータ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1904)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 815 # オレを半殺しにしろ(クリリン、ベジータ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1905)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 816 # 超サイヤ人だ孫悟空(悟空、ピッコロ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1906)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 817 # 俺たちに不可能はない(超悟空、超ベジータ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2907)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 818 # ダブルロイヤルアタック(超ベジータ、チャオズ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2908)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 819 # 地球丸ごと超決戦
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1909)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 820 # やっぱり息の合う二人
                                @damage_huttobi = false
                                @damage_center = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2910)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 821 # 足元がお留守だぜ！
                                @damage_huttobi = false
                                @damage_center = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2911)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 822 # オラにパワーをくれ！
                                # @damage_huttobi = false
                                # @damage_center = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2912)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 21
                                    attackAnimeEnd = true
                                end
                            when 823 # 新狼鶴相打陣
                                # @damage_huttobi = false
                                # @damage_center = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2913)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 824 # 超操気円裂斬
                                # @damage_huttobi = false
                                # @damage_center = true
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2914)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 825 # 烈戦人造人間
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2915)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    @damage_huttobi = false
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 828 # ダブルポコペン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2918)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 829 # ダブルアイビーム(ピッコロと天津飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1919)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 830 # 超能力きこうほう改(天津飯と餃子)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2920)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 82
                                    attackAnimeEnd = true
                                end
                            when 831 # 激烈魔閃光弾
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2921)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 832 # ファイナルバスター
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2922)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 833 # ファイナルかめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2923)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 834 # 未来のZ戦士
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2924)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 835 # サイコ気円裂斬
                                # @damage_huttobi = false
                                # @damage_center = true
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2925)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 837 # ダブルエクスプロージョン(ベジータとトランクス)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2927)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 838 # ダブルエクスプロージョン(未来悟飯とトランクス)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2928)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 839 # ダブルエクスプロージョン(ピッコロとトランクス)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2929)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 840 # ダブルエクスプロージョン(ピッコロ、ベジータ)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2930)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 841 # ダブルエクスプロージョン(ベジータ、未来悟飯)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2931)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 842 # ダブルエクスプロージョン(バーダック、ピッコロ)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2932)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 843 # ダブルエクスプロージョン(バーダック、ベジータ)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2933)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 844 # ダブルエクスプロージョン(バーダック、トランクス)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2934)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 845 # ダブルエクスプロージョン(バーダック、未来悟飯)

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                    @tec_back_small = true
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2935)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 846 # ロイヤルガード(ベ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2936)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 847 # ロイヤルガード(ト)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2937)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 849 # 親子乱舞(悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2939)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 850 # 親子乱舞(未来悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2940)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 851 # 信じる心(クリリンと16号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2941)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 852 # 月を破壊する者
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2942)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 853 # フルパワーアウトサイダーショット(バ、トー)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2943)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 854 # フルパワーアウトサイダーショット(バ、セ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2944)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 855 # フルパワーアウトサイダーショット(バ、トテ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2945)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 856 # フルパワーアウトサイダーショット(バ、パ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2946)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 857 # フルパワーアウトサイダーショット(トー、セ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2947)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 858 # フルパワーアウトサイダーショット(トー、トテ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2948)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 859 # フルパワーアウトサイダーショット(トー、パ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2949)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 860 # フルパワーアウトサイダーショット(セ、トテ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2950)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 861 # フルパワーアウトサイダーショット(セ、パ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2951)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 862 # フルパワーアウトサイダーショット(トテ、パ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2952)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 863 # フルパワーアウトサイダーショット(ピ、18)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2953)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 864 # フルパワーアウトサイダーショット(ピ、17)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2954)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 865 # フルパワーアウトサイダーショット(ピ、16)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2955)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 866 # フルパワーアウトサイダーショット(未来悟飯、18)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2956)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 867 # フルパワーアウトサイダーショット(未来悟飯、17)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2957)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 868 # フルパワーアウトサイダーショット(未来悟飯、16)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2958)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 869 # フルパワーアウトサイダーショット(未来悟飯、ベジータ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2959)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 870 # 師弟アタック改(ピッコロ、未来悟飯)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2960)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 871 # 師弟アタック改(ピッコロ、若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2961)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 872 # 弟子コンビアタック(未来悟飯、若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2962)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 873 # オメエもピッコロとおなじけ！(チチ&若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2963)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 874 # あっち行ってけろ改(チチ&ヤムチャ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2964)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 875 # 悟空さに近づく出ねえ！(チチ&18号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2965)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 876 # 悟空さに近づく出ねえ！(チチ&18号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2966)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 877 # 悟空さに近づく出ねえ！(チチ&18号)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2967)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 878 # だいじょうぶかチチ！？(悟空とチチ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2968)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 879 # 世話焼かせるんじゃねえ！(バーダックとチチ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2969)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 880 # カカロットが世話になったらしいな！(亀仙人とバーダック)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2970)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 881 # フルパワーアウトサイダーショット(未来悟飯、トーマ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2971)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 882 # フルパワーアウトサイダーショット(未来悟飯、セリパ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2972)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 883 # フルパワーアウトサイダーショット(未来悟飯、トテッポ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2973)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 884 # フルパワーアウトサイダーショット(未来悟飯、パ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2974)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 885 # 師弟アタック？(悟飯、若者)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2975)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 886 # 決死の超元気玉
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2976)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 48
                                    attackAnimeEnd = true
                                end
                            when 887 # 自然を愛する者
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2977)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 889 # スーパーどどはめは(ヤムチャとテンシンハンとチャオズ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true if $btl_progress >= 2
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2979)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 311 # 痺れ液(カイワレマン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(401)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 312 # 痺れ液(キュウコンマン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(401)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 313 # 痺れ液(サイバイマン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(403)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 314 # 自爆(サイバイマン)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(404)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 317 # エネルギー波(ジンジャー系)

                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(407)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 318 # 強力エネルギー波(ジンジャー系)
                                @tec_back_small = true

                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(408)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 319 # 刀攻撃(ジンジャー系)
                                @tec_back_small = true

                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(409)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 618 # 刀攻撃(ジンジャー系)
                                @tec_back_small = true

                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1708)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 331 # エネルギー波(ニッキー系)

                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(407)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 332 # 強力エネルギー波(ニッキー系)
                                @tec_back_small = true

                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(408)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 333 # 刀攻撃(ニッキー系)
                                @tec_back_small = true

                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(409)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 619 # 刀攻撃(ニッキー系)
                                @tec_back_small = true

                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1709)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 334 # エネルギー波(サンショ系)

                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(424)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 335 # 強力エネルギー波(サンショ系)
                                # @tec_back_small = true

                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(425)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 620 # 連続強力エネルギー波(サンショ系)
                                # @tec_back_small = true
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @chr_cutin_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1710)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 336 # エネルギー弾(ガーリック)
                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(426)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 338 # 強力エネルギー波(ガーリック)
                                @tec_back_small = true
                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(428)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 339 # 強力エネルギー波(ガーリック巨大化)
                                @tec_back_small = true
                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(429)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 340 # ブラックホール波(ガーリック巨大化)
                                @tec_back_small = true

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @chr_cutin_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(430)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 345 # キュイ系爆発波

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1435)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 346 # (キュイ系)連続エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1436)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 348 # (ドドリア系)口から怪光線
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true

                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1438)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 349 # (ドドリア系)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1439)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 354 # (ザーボン変身)スーパーエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1444)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 356 # (ギニュー)スーパーエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1446)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 357 # (ギニュー)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1447)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 360 # (ジース)クラッシャーボール
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1450)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 362 # (バータ)スピードアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1452)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 364 # (リクーム)連続エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1454)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 365 # (リクーム)イレイザーガン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1455)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 367 # (グルド)タイムストップ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1457)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 25
                                    attackAnimeEnd = true
                                end
                            when 392, 393 # (ジース,バータ)パープルコメットクラッシュ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1482)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 621 # デッドゾーン(ガーリック巨大化)
                                @tec_back_small = true

                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @chr_cutin_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    @tec_output_back_no = 1
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1711)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 75
                                    attackAnimeEnd = true
                                end

                            when 469 # キシーメ電磁ムチ(強
                                if @battle_anime_result == 0
                                    @chr_cutin_flag = true
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(559)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 471 # エビ氷結攻撃(全体)
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @chr_cutin_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    @chr_cutin_flag = true
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(561)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 70
                                    attackAnimeEnd = true
                                end
                            when 472 # エビ氷結攻撃
                                if @battle_anime_result == 0
                                    @chr_cutin_flag = true
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(562)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 70
                                    attackAnimeEnd = true
                                end
                            when 473 # ミソ皮伸び攻撃
                                if @battle_anime_result == 0
                                    @chr_cutin_flag = true
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(563)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 71
                                    attackAnimeEnd = true
                                end
                            when 474 # ミソエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(564)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 475 # ミソ強力エネルギー波
                                if @battle_anime_result == 0
                                    @chr_cutin_flag = true
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(565)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 596 # エネルギーは(Drウィロー)
                                @ene_tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(686)
                                elsif @battle_anime_result == 3

                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true

                                end
                            when 597 # フォトンストライク(両手エネルギー波(Drウィロー)
                                @ene_tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(687)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true

                                end
                            when 598 # 口からエネルギー波(Drウィロー)
                                @ene_tec_oozaru = true
                                @chr_cutin_flag = true
                                if @battle_anime_result == 0

                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(688)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true

                                end
                            when 599 # ギガンティックボマー(Drウィロー)
                                @ene_tec_oozaru = true
                                @chr_cutin_flag = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(689)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 600 # プラネットゲイザー(Drウィロー)
                                @ene_tec_oozaru = true
                                @chr_cutin_flag = true
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(690)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true

                                end
                            when 385 # 爆発波(ターレス
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1475)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 386 # キルドライバー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1476)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 387 # メテオバースト
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1477)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 654 # 大猿変身(ターレス)
                                @ene_tec_oozaru = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                    @tec_output_back_no = 1 # 必殺背景縦
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1744)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    # damage_pattern = 26
                                    attackAnimeEnd = true
                                end
                            when 652 # ターレス大猿 エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 653 # ターレス大猿 強力エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2499)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 388 # エネルギーは(スラッグ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1478)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 389 # 爆発波(スラッグ
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1479)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 390 # ビッグスマッシャー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1480)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 391 # メテオバースト
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1481)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 655 # スラッグ巨大化
                                @ene_tec_oozaru = true

                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1745)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    # damage_pattern = 26
                                    attackAnimeEnd = true
                                end
                            when 677 # エネルギーは(スラッグ巨大化
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 678 # 爆発波(スラッグ巨大化
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2498)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 679 # ビッグスマッシャー(スラッグ巨大化
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2499)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            # 敵汎用エネルギー波
                            when 201, 211, 221, 342, 343, 344, 347, 350, 353, 355, 359, 361, 363, 366, 384, 395..401, 406, 418, 422, 426, 430, 434, 438, 444, 449, 455, 481, 486, 491, 494, 497, 502, 507, 512, 518, 524, 529, 531, 536, 552, 560, 562, 565, 567, 569, 571, 574, 577, 581, 589, 601, 605, 609, 613, 635, 635, 639, 642, 646, 649, 656, 660, 663, 667, 670, 672, 681, 687, 695
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 402, 407, 575, 587 # フリーザ超能力(全体),ライチー
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_output_back_no = 1
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_output_back_no = 1
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2492)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 25
                                    attackAnimeEnd = true
                                end
                            when 403, 576, 584 # フリーザカッター
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_output_back_no = 3
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2493)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            # 連続エネルギー波(全体)
                            when 13, 202, 212, 222, 337, 404, 412, 414, 416, 421, 425, 427, 431, 435, 439, 445, 450, 456, 466, 498, 503, 508, 513, 519, 525, 532, 537, 553, 561, 564, 566, 572, 578, 582, 590, 602, 606, 610, 614, 628, 629, 630, 682, 688, 696
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    # @tec_output_back_no = 1
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2494)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 405, 410, 675 # デスボール
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_output_back_no = 1
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2495)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 634 # (フリーザ3)デスボール
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1724)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 704 # (フリーザ3)殺されるべきなんだ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1794)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 380 # (超ベジータ)エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1431)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 381 # (超ベジータ)爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1223)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 382 # (超ベジータ)ギャリック砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1224)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 705 # (超ベジータ)スーパーギャリック砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1795)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 408, 452, 488, 539, 568, 570, 573, 586, 591 # 爆発波(クウラ,セル完全体,合体13号,ブロリー,ターレス系,スラッグ系,ゴーストライチー,ハッチヒャック
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    # @tec_output_back_no = 1
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2498)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end

                            # 強力エネルギー波
                            when 203, 213, 223, 409, 419, 423, 432, 460, 461, 463, 464, 482, 487, 492, 495, 499, 504, 509, 514, 520, 526, 533, 538, 554, 583, 592, 603, 607, 611, 615, 622, 674, 686, 693, 697
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2499)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 411 # マシーナリーレイン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2501)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 413 # ネイズバインドウェーブ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2503)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 73
                                    attackAnimeEnd = true
                                end
                            when 415 # ドーレテリブルラッシュ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2505)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 420, 424, 443, 465 # ドレインライフ セルもここに
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2510)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 429, 433 # アクセルダンス
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2519)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    @tec_output_back_no = 1
                                    damage_pattern = 24
                                    attackAnimeEnd = true
                                end
                            when 462 # サウザーブレードスラッシュ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2552)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 440, 446, 451, 457 # (セル１)かめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2530)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 441, 458 # (セル１)魔貫光殺砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @tec_output_back = false
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2531)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 442, 448, 453 # (セル１)太陽拳
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2532)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 30
                                    attackAnimeEnd = true
                                end
                            when 447 # ビッグバンアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_output_back_no = 0
                                    @tec_back_color = 1
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2537)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 454 # 超かめはめは
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2544)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 480 # (ジンコウマン)しびれえき
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @tec_output_back_no = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2

                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2570)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 483 # 13号)サイレントアサシン13
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2573)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 484 # 13号)デッドリィアサルト
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2574)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 485 # 13号)SSデッドリィボンバー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_output_back_no = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2575)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 489 # 合体13号)SSデッドリィボンバー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_output_back_no = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2579)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 490 # 合体13号)フルパワーSSデッドリィボンバー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    # @tec_output_back_no = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2580)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 493 # 14号)アンドロイドチャージ14
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2583)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 496 # 15号)アンドロイドストライク15
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2586)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 505 # ボーフル)ギャラテクティックタイラント
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2595)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 506 # ボーフル)ギャラテティックバスター
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2596)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 511 # ゴクア)ギャラテクアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2601)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 71
                                    attackAnimeEnd = true
                                end
                            when 515 # ザンギャ)スカイザッパー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2605)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 516, 521, 527 # ザンギャビドーブージン超能力

                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_output_back_no = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2606)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 25
                                    attackAnimeEnd = true
                                end
                            when 522 # ビドー)ギャラクティッククラッシュ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    # @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2612)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 528 # ブージン)合体超能力
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2618)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 534 # ブロ超)イレイザーキャノン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2624)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 540 # イレイザーブロウ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2630)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 541 # ブロフル)イレイザーキャノン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2631)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 542 # ブロフル)スローイングブラスター
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2632)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 543 # ブロフル)オメガブラスター
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2633)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 545 # アラレ)ウンチ攻撃
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2635)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 25
                                    attackAnimeEnd = true
                                end
                            when 546 # アラレ)キーン
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    # @chr_cutin = true
                                    # @chr_cutin_flag = true
                                    # @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2636)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 547 # アラレ)岩攻撃
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @tec_output_back_no = 1
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2637)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 548 # アラレ)ブンブン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2638)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 549 # アラレ)んちゃほう
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2639)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 550 # アラレ)プロレスごっこ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2640)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 555 # オゾ)ミストかめはめ波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2645)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 556 # オゾ)ミストばくれつまこうほう
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2646)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 557 # オゾ)ミストませんこう
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2647)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 558 # オゾ)ミストギャリック砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ

                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2648)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 559 # オゾ)ミスト剣攻撃
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2649)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 563 # アービー系)パワードレイン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2653)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 579 # ゴッドガ)テイルザンバー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2669)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 580 # ゴッドガ)ガードンクラッシャー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2670)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 585 # ライチ)ビッグスマッシャー
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2675)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 41
                                    attackAnimeEnd = true
                                end
                            when 588 # ライチ)イレイサーショック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_output_back_no = 7
                                    # @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2678)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 593 # ハッチ)リベンジャーチャージ
                                # @tec_tyousaiya = true
                                $battle_ribe_charge = true
                                $battle_ribe_charge_turn = true
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @tec_output_back = false
                                    @tec_output_back_no = 1
                                    # @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2683)
                                elsif @battle_anime_result == 3
                                    attackAnimeEnd = true
                                end
                            when 594 # ハッチ)リベンジャーカノン
                                $battle_ribe_charge = false
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    # @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @tec_back_small = true
                                    # @chr_cutin_flag = true
                                    @tec_output_back_no = 1
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2684)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 604 # ガッシュ)ラッシュ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2694)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 608 # ビネガー)ラッシュ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2698)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 612 # タード)ラッシュ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2702)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 616 # ゾルド)ラッシュ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2706)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 617 # タード&ゾルド)ダブルアタック
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_output_back_no = 1
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2707)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 623 # ロボット兵 バルカン砲
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2713)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 624 # メタルクウラコア エネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2714)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 625 # メタルクウラコア 口からエネルギー波
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @tec_back_small = true
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2715)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 626 # メタルクウラコア エネルギー吸収
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    # @chr_cutin = true
                                    # @chr_cutin_flag = true
                                    # @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2716)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 77
                                    attackAnimeEnd = true
                                end
                            when 627 # メタルクウラコア スーパービッグノヴァ
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    # @chr_cutin = true
                                    # @chr_cutin_flag = true
                                    # @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @tec_output_back_no = 3
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2717)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 631 # タオパイパイ)どどんぱ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    # @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2431) # 2721
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 632 # タオパイパイ)スーパーどどんぱ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2499)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 42
                                    attackAnimeEnd = true
                                end
                            when 633 # タオパイパイ)カタナ攻撃
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2723)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 636 # アモンド気円斬
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1726)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 637 # アモンドプラネットボム
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1727)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 640 # コズミックアタック(カカオ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1730)
                                elsif @battle_anime_result == 3
                                    # コズミックアタックダメージ
                                    damage_pattern = 80
                                    attackAnimeEnd = true
                                end
                            when 643 # 爆発波(ダイーズ
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1733)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 644 # メテオボール(ダイーズ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1734)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 647, 650 # ダブルエネルギー波 レズン、ラカセイ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1740)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 657 # エビルクエーサー アンギラ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1747)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 658 # 手が伸びる アンギラ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1748)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 661 # エビルグラビティ ドロダボ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1751)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 664 # エビルコメット メダマッチャ
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = true
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1754)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 665 # カエル攻撃 メダマッチャ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1755)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 25 # 23
                                    attackAnimeEnd = true
                                end
                            when 668 # エビルインパクト ゼエウン
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1758)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 671 # アンギラとメダマッチャ腕伸びるカエル攻撃
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(1761)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 673 # チルド爆発波
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2763)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 683 # パイクーハン(超体当たり)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2773)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 685 # パイクーハン(サンダーフラッシュ)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2775)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 689 # かめはめ波 ブウ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2779)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 23
                                    attackAnimeEnd = true
                                end
                            when 690 # 巻きつき攻撃 ブウ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2780)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 71
                                    attackAnimeEnd = true
                                end
                            when 691 # お菓子光線 ブウ
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2781)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 81
                                    attackAnimeEnd = true
                                end
                            when 692 # 超爆発波 ブウ
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2782)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 698 # ラッシュ オゾット(変身)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2788)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 22
                                    attackAnimeEnd = true
                                end
                            when 699, 702 # イグナイトビジョン(オゾット、オゾット変身
                                if @all_attack_count >= 2 && @battle_anime_result == 0
                                    # @tec_output_back = false
                                    @chr_cutin = true
                                    @chr_cutin_flag = true
                                    @chr_cutin_mirror_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = 2
                                end
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    # @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2789)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 43
                                    attackAnimeEnd = true
                                end
                            when 700 # カオスバースト オゾット(変身)
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2790)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            when 703 # カオスバースト オゾット
                                if @battle_anime_result == 0
                                    # 上から左下に移動
                                    @battle_anime_result = anime_pattern(31)
                                elsif @battle_anime_result == 1
                                    # 必殺技発動画面へ
                                    @chr_cutin_flag = true
                                    @tec_back_small = true
                                    @battle_anime_result = anime_pattern(32)
                                elsif @battle_anime_result == 2
                                    # 必殺技発動
                                    @battle_anime_result = anime_pattern(2793)
                                elsif @battle_anime_result == 3
                                    # 光線系ダメージ
                                    damage_pattern = 44
                                    attackAnimeEnd = true
                                end
                            else
                                if $battle_test_flag == true
                                    damage_pattern = @test_damage_pattern
                                else
                                    damage_pattern = 22
                                end
                                attackAnimeEnd = true
                            end
                        end
                    end
                end
            rescue => e
                # $err_run_process_d3
                # set_err_run_process_msg
                # 例外が発生したときの処理
                p("エラー発生　：" + $err_run_process.to_s,
                  "--戦闘シーン情報--",
                  "　番号　　　：" + attackPattern.to_s,
                  "　進行度　　：" + @battle_anime_result.to_s,
                  "　フレーム数：" + @battle_anime_frame.to_s,
                  "　攻撃方向　：" + @attackDir.to_s,
                  "　味方キャラ：" + @chanum.to_s + "番目 " + $partyc[@chanum].to_s,
                  "　敵キャラ　：" + @enenum.to_s + "番目 " + $battleenemy[@enenum].to_s,
                  "--スクリプト情報--",
                  "　ErrMsg    ：" + e.message.to_s)
                exit # 強制終了
            else
                # 例外が発生しなかったときに実行される処理
            ensure
                # 例外の発生有無に関わらず最後に必ず実行する処理
            end

            # 発動スキルの表示
            # output_runskill 1 #引数1で攻撃と判断

            output_cutin(attackPattern)
            # if @battle_anime_frame == attackAnimeEnd + 30
            #  attackAnimeEnd = true
            # end
            # output_back attackPattern                       # 背景更新
            # @back_window.update
            # Graphics.update                   # ゲーム画面を更新
            if attackAnimeEnd != true

                if $battle_test_flag == true
                    text = "フレーム数：" + @battle_anime_frame.to_s
                    @back_window.contents.draw_text(15, 25, 300, 28, text)
                end

                Graphics.update # ゲーム画面を更新

                if @anime_frame_format == false
                    @battle_anime_frame += 1
                else
                    @battle_anime_frame = 0
                    @anime_frame_format = false
                end

                # 戦闘途中終了
                Input.update
                # Sコンボチェック
                if @btl_ani_scombo_new_flag != 0
                    scombo_new_flag = $game_switches[@btl_ani_scombo_new_flag]
                else
                    scombo_new_flag = false
                end
                if (Input.trigger?(Input::B) || (Input.press?(Input::R) and Input.press?(Input::B))) && $game_variables[96] == 0 && @new_tecspark_flag == false && scombo_new_flag == false || ($game_switches[860] == true && $game_switches[883] == true && scombo_new_flag == false) && (Input.trigger?(Input::B) || (Input.press?(Input::R) and Input.press?(Input::B)))
                    # 必殺技カットイン
                    func_attack_anime_end()
                    attackAnimeEnd = true
                    return
                end
            end
        end while attackAnimeEnd != true

        # p @attack_hit,damage_pattern
        # @attack_hit = true
        attackAnimeEnd = false
        @battle_anime_result = 0
        @battle_anime_frame = 0

        # 発動スキルの表示フレーム数
        @runskill_frame = 0

        # 必殺技で攻撃する必要があるか
        if @tec_non_attack == true
            attackAnimeEnd = true
        end

        # ヒットか回避か
        begin
            input_fast_fps
            input_battle_fast_fps if $game_variables[96] == 0
            @back_window.contents.clear
            output_back(attackPattern) # 背景更新
            # 戦闘途中終了
            Input.update
            # 周回プレイ時はイベント戦闘や初回閃きも回避できるように
            if (Input.trigger?(Input::B) || (Input.press?(Input::R) and Input.press?(Input::B))) && $game_variables[96] == 0 && @new_tecspark_flag == false && scombo_new_flag == false || ($game_switches[860] == true && $game_switches[883] == true && scombo_new_flag == false) && (Input.trigger?(Input::B) || (Input.press?(Input::R) and Input.press?(Input::B)))
                func_attack_anime_end()
                attackAnimeEnd = true
                return
            end
            if @battle_anime_result == 0
                if @attack_hit == true

                    # 爆発変化させる場合(仮)
                    # if @anime_event == false && $game_switches[463] == true

                    # end

                    @battle_anime_result = anime_pattern(damage_pattern)
                else
                    @battle_anime_result = anime_pattern(avoid_anime_no)
                end
            else
                attackAnimeEnd = true
            end
            if @output_battle_damage_flag == true
                output_battle_damage if $game_variables[96] == 0
            end
            # output_back attackPattern                       # 背景更新

            # 発動スキルの表示

            output_runskill(2) # 引数1でヒット用の表示と判断

            if $battle_test_flag == true
                text = "フレーム数：" + @battle_anime_frame.to_s
                @back_window.contents.draw_text(15, 25, 300, 28, text)
            end
            output_cutin(attackPattern)
            Graphics.update # ゲーム画面を更新

            if @anime_frame_format == false
                @battle_anime_frame += 1
            else
                @battle_anime_frame = 0
                @anime_frame_format = false
            end
        end while attackAnimeEnd != true

        func_attack_anime_end()
    end  # end of func

end  # end of module
