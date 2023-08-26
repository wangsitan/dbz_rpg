class Scene_Db_Battle_Anime < Scene_Base
    include Share
    include Db_Battle_Anime_test_Setup
    include Scene_Db_Battle_Anime_attack_start
    include Scene_Db_Battle_Anime_effect_pattern
    include Scene_Db_Battle_Anime_pattern
    include Scene_Db_Battle_Anime_pattern_11

    # キャラクターステータス表示位置
    # character status
    Chastexstr = -16
    Chasteystr = 340
    Chastexend = 672
    Chasteyend = 156

    #--------------------------------------------------------------------------
    # ● オブジェクト初期化
    #--------------------------------------------------------------------------
    def initialize(anime_event=false)
        # エラー処理用変数初期化
        $err_run_process = "戦闘アニメシーン"
        $err_run_process_d = ""
        $err_run_process_d2 = ""
        $err_run_process_d3 = ""
        @event_damege_result = false # イベント戦でダメージ処理をする
        @event_atc_hit = []          # イベント戦で敵の攻撃をヒットさせるか trueで回避
        @event_cha_atc_hit = []          # イベント戦で味方の攻撃をヒットさせるか trueで回避
        @event_ene_set_chara = []        # イベント戦で敵が何番目を攻撃するか
        @anime_event = anime_event
        @tmp_tec_move = [] # イベント戦闘時の必殺技発動の動き指定

        $one_turn_cha_hit_num = [] # 1ターン管理攻撃ヒット回数管理

        for x in 0..$cardset_cha_no.size
            $one_turn_cha_hit_num[x] = 0
        end

        battle_anime_test_setup

        if @anime_event == true # イベント戦の場合はセット
            set_battle_event
        end

        # 戦闘高速化デフォ設定
        # if $game_variables[303] == 0
        #  Graphics.frame_rate = 60
        # else
        #  if $game_variables[40] >= 2
        #    Graphics.frame_rate = 100 #90
        #  else
        #    p 1
        #    Graphics.frame_rate = 90
        #  end
        # end
    end

    #--------------------------------------------------------------------------
    # ● イベント用の内容をセット
    #--------------------------------------------------------------------------
    def set_battle_event
        # 固定処理
        @tmp_cardi = []
        @tmp_carda = []
        @tmp_cardg = []
        for x in 0..7
            @tmp_cardi[x] = $cardi[x]
            @tmp_carda[x] = $carda[x]
            @tmp_cardg[x] = $cardg[x]
        end

        # $partyc = [20]
        # $game_switches[17] = true
        # $game_switches[129] = true
        # $enehp[0] = 6000        #ここもそのまま
        # $game_variables[40] = 2 #シナリオ進行度
        # set_bgm = 0
        # $game_variables[96] = 1
        case $game_variables[96]

        when 1 # トランクス対フリーザサイボーグ

            $cha_set_action[0] = 187 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 410
            $cardi[0] = 8 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 5 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $battleenemy = [102]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [10, 0] # 攻撃順番
        # @set_bgm = 15
        when 2 # ゴクウ対トランクス
            $cha_set_action[0] = 1 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 182
            $cardi[0] = 8 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 5 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $enecardi[1] = 8 # 敵流派
            $enecarda[1] = 7 # 敵攻撃
            $enecardg[1] = 7 # 敵防御
            $battleenemy = [134, 134]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [0, 10, 11] # 攻撃順番
            @set_bgm = 14
            @event_atc_hit[0] = false
            @event_atc_hit[1] = true
        when 3 # ピッコロ対17号
            $cha_set_action[0] = 1 # 攻撃アクションNo
            $cha_set_action[1] = 1 # 攻撃アクションNo
            $cha_set_action[2] = 45  # 攻撃アクションNo
            $cha_set_action[3] = 50  # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cardset_cha_no[1] = 1
            $cardset_cha_no[2] = 2
            $cardset_cha_no[3] = 3
            $cha_set_enemy[0] = 0 # 味方が何番目の敵を攻撃するか
            $cha_set_enemy[1] = 1
            $cha_set_enemy[2] = 2
            $cha_set_enemy[3] = 3
            @event_ene_set_chara[0] = 0
            @event_ene_set_chara[1] = 1
            @event_ene_set_chara[2] = 2
            @event_ene_set_chara[3] = 3
            @tmp_ene_set_action = 432
            $cardi[0] = 5 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $cardi[1] = 3 # 味方流派
            $carda[1] = 7 # 味方攻撃
            $cardg[1] = 7 # 味方防御
            $cardi[2] = 4 # 味方流派
            $carda[2] = 7 # 味方攻撃
            $cardg[2] = 7 # 味方防御
            $cardi[3] = 4 # 味方流派
            $carda[3] = 7 # 味方攻撃
            $cardg[3] = 7 # 味方防御
            $enecardi[0] = 5 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $enecardi[1] = 5 # 敵流派
            $enecarda[1] = 7 # 敵攻撃
            $enecardg[1] = 7 # 敵防御
            $enecardi[2] = 4 # 敵流派
            $enecarda[2] = 7 # 敵攻撃
            $enecardg[2] = 7 # 敵防御
            $enecardi[3] = 9 # 敵流派
            $enecarda[3] = 7 # 敵攻撃
            $enecardg[3] = 7 # 敵防御
            $battleenemy = [125, 125, 125, 125]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [10, 0, 11, 1, 12, 2, 13, 3] # 攻撃順番
            @set_bgm = $bgm_no_ZSB2_pikkoro_for_gb
            @event_atc_hit[0] = false
            @event_atc_hit[1] = false
            @event_atc_hit[2] = false
            @event_atc_hit[3] = false
            @event_cha_atc_hit[0] = false
            @event_cha_atc_hit[1] = false
            @event_cha_atc_hit[2] = true
            @event_cha_atc_hit[3] = false
        when 4 # ピッコロ対セル
            $cha_set_action[0] = 49 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 182
            $cardi[0] = 4 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 8 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $battleenemy = [127]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [0] # 攻撃順番
            @set_bgm = $bgm_no_ZSB2_pikkoro_for_gb
        # @event_cha_atc_hit[0] = false
        when 5 # 16号対セル
            $cha_set_action[0] = 1 # 攻撃アクションNo
            $cha_set_action[1] = 224  # 攻撃アクションNo
            $cha_set_action[2] = 225  # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cardset_cha_no[1] = 1
            $cardset_cha_no[2] = 2
            $cha_set_enemy[0] = 0 # 味方が何番目の敵を攻撃するか
            $cha_set_enemy[1] = 0
            $cha_set_enemy[2] = 0
            @event_ene_set_chara[0] = 0
            @tmp_ene_set_action = 432
            $cardi[0] = 5 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $cardi[1] = 9 # 味方流派
            $carda[1] = 7 # 味方攻撃
            $cardg[1] = 7 # 味方防御
            $cardi[2] = 9 # 味方流派
            $carda[2] = 7 # 味方攻撃
            $cardg[2] = 7 # 味方防御
            $enecardi[0] = 4 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $battleenemy = [127]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [0, 10, 1, 2] # 攻撃順番
            @set_bgm = $bgm_no_ZSB1_16gou_for_gb
            @event_atc_hit[0] = false
            # @event_atc_hit[1] = false
            # @event_atc_hit[2] = false
            # @event_atc_hit[3] = false
            @event_cha_atc_hit[0] = true
            @event_cha_atc_hit[1] = false
            @event_cha_atc_hit[2] = false
        # @event_cha_atc_hit[3] = false
        when 6 # 天津飯　新気功砲
            $cha_set_action[0] = 95 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 182
            $cardi[0] = 1 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 9 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $battleenemy = [128]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [0] # 攻撃順番
        # @set_bgm = $bgm_no_FCJ1_battle2
        # @event_cha_atc_hit[0] = false
        when 7 # ベジータ　ファイナルフラッシュ
            $cha_set_action[0] = 140 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 182
            $cardi[0] = 8 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 9 # 敵流派
            $enecarda[0] = 0 # 敵攻撃
            $enecardg[0] = 0 # 敵防御
            $battleenemy = [129]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [0] # 攻撃順番
        # @set_bgm = $bgm_no_FCJ1_battle2
        # @event_cha_atc_hit[0] = false
        when 8 # セル反撃
            $cha_set_action[0] = 140 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 182
            $cardi[0] = 8 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 9 # 敵流派
            $enecarda[0] = 0 # 敵攻撃
            $enecardg[0] = 0 # 敵防御
            $battleenemy = [129]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            @tmp_ene_set_action = 0
            $attack_order = [10, 10, 10] # 攻撃順番
        # @set_bgm = $bgm_no_FCJ1_battle2
        # @event_cha_atc_hit[0] = false
        when 9 # サタンダイナマイトキック
            $cha_set_action[0] = 298 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 182
            $cardi[0] = 14 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 9 # 敵流派
            $enecarda[0] = 0 # 敵攻撃
            $enecardg[0] = 0 # 敵防御
            $battleenemy = [129]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [0] # 攻撃順番
            @tmp_tec_move[1] = 2
        when 10 # 16号自爆
            $cha_set_action[0] = 227 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 182
            $cardi[0] = 9 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 9 # 敵流派
            $enecarda[0] = 0 # 敵攻撃
            $enecardg[0] = 0 # 敵防御
            $battleenemy = [129]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [0] # 攻撃順番
        # @tmp_tec_move[1] = 2
        # @set_bgm = $bgm_no_FCJ1_battle2
        # @event_cha_atc_hit[0] = false
        when 11 # 超悟飯2対セル
            $cha_set_action[0] = 1 # 攻撃アクションNo
            $cha_set_action[1] = 1  # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cardset_cha_no[1] = 1
            $cha_set_enemy[0] = 0   # ここもそのまま
            $cha_set_enemy[1] = 0
            @tmp_ene_set_action = 0
            $cardi[0] = 4 # 味方流派
            $carda[0] = 0 # 味方攻撃
            $cardg[0] = 0 # 味方防御
            $cardi[1] = 4 # 味方流派
            $carda[1] = 0 # 味方攻撃
            $cardg[1] = 0 # 味方防御
            $enecardi[0] = 8 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $battleenemy = [129]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [10, 0, 10, 1] # 攻撃順番
        when 12 # バーダック編惑星戦士たちとの戦闘

            $cha_set_action[0] = 179 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 410
            $cardi[0] = 5 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 5 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $battleenemy = [61]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 0
            $attack_order = [0] # 攻撃順番
        when 13 # バーダック編フリーザとの戦闘

            $cha_set_action[0] = 180 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 410
            $cardi[0] = 5 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 5 # 敵流派
            $enecarda[0] = 0 # 敵攻撃
            $enecardg[0] = 0 # 敵防御
            $battleenemy = [53]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 0
            $attack_order = [0] # 攻撃順番
        when 14 # 未来悟飯と人造人間戦闘
            $cha_set_action[0] = 1 # 攻撃アクションNo
            $cha_set_action[1] = 1 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cardset_cha_no[1] = 1
            $cha_set_enemy[0] = 0 # ここもそのまま
            $cha_set_enemy[1] = 1
            @tmp_ene_set_action = 429
            $cardi[0] = 8 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $cardi[1] = 8 # 味方流派
            $carda[1] = 7 # 味方攻撃
            $cardg[1] = 7 # 味方防御
            $enecardi[0] = 9 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $enecardi[1] = 9 # 敵流派
            $enecarda[1] = 7 # 敵攻撃
            $enecardg[1] = 7 # 敵防御
            $battleenemy = [124, 125]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [0, 1, 10] # 攻撃順番
        when 15 # 未来トランクスとセル戦闘
            $cha_set_action[0] = 1 # 攻撃アクションNo
            $cha_set_action[1] = 1 # 攻撃アクションNo
            $cha_set_action[2] = 1 # 攻撃アクションNo
            $cha_set_action[3] = 1 # 攻撃アクションNo
            $cha_set_action[4] = 1 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cardset_cha_no[1] = 1
            $cardset_cha_no[2] = 2
            $cardset_cha_no[3] = 3
            $cardset_cha_no[4] = 4
            $cha_set_enemy[0] = 0   # ここもそのまま
            $cha_set_enemy[1] = 0   # ここもそのまま
            $cha_set_enemy[2] = 0   # ここもそのまま
            $cha_set_enemy[3] = 0   # ここもそのまま
            $cha_set_enemy[4] = 0   # ここもそのまま
            @tmp_ene_set_action = 1
            $cardi[0] = 8 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $cardi[1] = 8 # 味方流派
            $carda[1] = 7 # 味方攻撃
            $cardg[1] = 7 # 味方防御
            $cardi[2] = 8 # 味方流派
            $carda[2] = 7 # 味方攻撃
            $cardg[2] = 7 # 味方防御
            $cardi[3] = 8 # 味方流派
            $carda[3] = 7 # 味方攻撃
            $cardg[3] = 7 # 味方防御
            $cardi[4] = 8 # 味方流派
            $carda[4] = 7 # 味方攻撃
            $cardg[4] = 7 # 味方防御
            $enecardi[0] = 9 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $enecardi[1] = 9 # 敵流派
            $enecarda[1] = 7 # 敵攻撃
            $enecardg[1] = 7 # 敵防御
            $battleenemy = [127, 127]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [0, 1, 10, 2, 3, 11, 4] # 攻撃順番
        when 16 # 未来トランクスとセル戦闘(ヒートドームアタック
            $cha_set_action[0] = 188 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 429
            $cardi[0] = 8 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 9 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $battleenemy = [127]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 1
            $attack_order = [0] # 攻撃順番
        when 17 # 悟空 14、15号戦闘
            $cha_set_action[0] = 1 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 1
            $cardi[0] = 3 # 味方流派
            $carda[0] = 0 # 味方攻撃
            $cardg[0] = 0 # 味方防御
            $enecardi[0] = 8 # 敵流派
            $enecarda[0] = 3 # 敵攻撃
            $enecardg[0] = 3 # 敵防御
            $enecardi[1] = 8 # 敵流派
            $enecarda[1] = 3 # 敵攻撃
            $enecardg[1] = 3 # 敵防御
            $enecardi[2] = 8 # 敵流派
            $enecarda[2] = 3 # 敵攻撃
            $enecardg[2] = 3 # 敵防御
            $battleenemy = [140, 140, 141]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 31
            $attack_order = [10, 11, 12] # 攻撃順番
            @event_atc_hit[0] = true
            @event_atc_hit[1] = true
            @event_atc_hit[2] = false
        when 18 # 超バーダックとチルド戦闘(スーパーファイナルリベンジャー
            $cha_set_action[0] = 165 # 攻撃アクションNo
            $cardset_cha_no[0] = 0
            $cha_set_enemy[0] = 0 # ここもそのまま
            @tmp_ene_set_action = 429
            $cardi[0] = 8 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 6 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $battleenemy = [238]
            $battleenenum = $battleenemy.size
            $Battle_MapID = 35
            $attack_order = [0] # 攻撃順番
            @set_bgm = $bgm_no_DKN_tyoubardak_btl
        when 19 # Z2フリーザを超元気玉でしとめる
            # 悟空が先頭じゃなくても攻撃するように
            gokuno = $partyc.index(3)

            $cha_set_action[gokuno] = 30
            $cha_set_enemy[gokuno] = 0
            $cardset_cha_no[0] = gokuno

            @tmp_ene_set_action = 429
            $cardi[0] = 3 # 味方流派
            $carda[0] = 7 # 味方攻撃
            $cardg[0] = 7 # 味方防御
            $enecardi[0] = 6 # 敵流派
            $enecarda[0] = 7 # 敵攻撃
            $enecardg[0] = 7 # 敵防御
            $battleenemy = [56] # フリーザ
            $battleenenum = $battleenemy.size
            $Battle_MapID = 2
            $attack_order = [0] # 攻撃順番
            # @set_bgm = $bgm_no_DKN_tyoubardak_btl
        end

        # tempの方を使うスキルもあるので、こっちにも格納する
        # 2021/8/25現在 気の暴走でエラーの対策
        $temp_cardi = Marshal.load(Marshal.dump($cardi)) # ここもそのまま

        $chadeadchk[0] = false # ここもそのまま
        for x in 0..$battleenemy.size - 1
            $enedeadchk[x] = false # ここもそのまま
            $eneselfdeadchk[x] = false # ここもそのまま
        end

        # HPセット
        for x in 0..$battleenenum - 1
            $enehp[x] = $data_enemies[$battleenemy[x]].maxhp # 敵hpを代入
        end

        if $game_variables[95] == 0 # 指定Noへ移動が0ならば追加1
            $game_variables[41] += 1
        else
            $game_variables[41] = $game_variables[95] # 0以外なら指定をセット
        end
        $game_switches[128] = false # 戦闘終了後イベントNo追加
        $game_variables[95] = 0     # 戦闘終了後指定イベントへ
    end

    #--------------------------------------------------------------------------
    # ● ウインドウ開放
    #--------------------------------------------------------------------------
    def dispose_window
        @status_window.dispose
        @status_window = nil
        @back_window.dispose
        @back_window = nil
    end

    #--------------------------------------------------------------------------
    # ● ウインドウ内容クリア
    #--------------------------------------------------------------------------
    def window_contents_clear
        @status_window.contents.clear
        @back_window.contents.clear
    end

    #--------------------------------------------------------------------------
    # ● ウインドウ作成
    # mode:0通常
    #--------------------------------------------------------------------------
    def create_window
        # バックウインドウ作成
        # @back_window = Window_Base.new(-30,-30,700,540)
        # @back_window = Window_Base.new(-16,-16,672,512)
        # @back_window = Window_Base.new(-16,-16,672,356+32)
        @back_window = Window_Base.new(-16, -16, 672, 480 + 32)
        @back_window.opacity = 0
        @back_window.back_opacity = 0

        # キャラステータスウインドウ表示
        @status_window = Window_Base.new(Chastexstr, Chasteystr, Chastexend, Chasteyend)
        @status_window.opacity = 0
        @status_window.back_opacity = 0
    end

    #--------------------------------------------------------------------------
    # ● メイン処理
    #--------------------------------------------------------------------------
    def start
        super

        @chanum = 0 # 味方キャラ
        @enenum = 0 # 表示順
        @enedatenum = 1 # データ順
        @battle_anime_frame = 0 # 戦闘アニメフレーム数
        @anime_frame_format = false # 戦闘アニメフレーム数フォーマットフラグ
        @@chastex = 50 # 味方キャラステータス表示開始位置
        @@enestex = 310 # 敵キャラステータス表示開始位置
        @attackDir = 0 # 攻撃方向 0:味方⇒敵 1:敵⇒味方
        @attack_num = 0   # 攻撃回数
        @attack_count = 0 # 攻撃回数カウント
        @damage_huttobi = true # ダメージ時吹っ飛ぶか
        @damage_center = false # ダメージを真ん中で受けるか
        @battledamage = 0 # 戦闘ダメージ
        @attack_on = nil # 攻撃できるかどうか判定
        @attack_any_one_flag = nil # 攻撃で誰か一人でも攻撃したか(全体攻撃もここで管理)

        @ene_coerce_target_chanum = nil # 敵が味方を強制的にターゲットを決める
        Graphics.fadein(5)
        create_window
        @attack_hit = nil # 攻撃がヒットするか
        @chax = STANDARD_CHAX
        @chay = STANDARD_CHAY
        @enex = STANDARD_ENEX
        @eney = STANDARD_ENEY
        @output_battle_damage_flag = false
        @tec_output_back = false
        @tec_output_back_no = 0 # 背景種類
        @chr_cutin = false
        @chr_cutin_mirror_flag = false
        @chr_cutin_flag = false
        @genkitama_kanri_frame = []
        @genkitama_kanri_x = []
        @genkitama_kanri_y = []
        # @chax = -84
        # @chay = 122
        # @enex = 636
        # @eney = 122
        @backx = 0
        @backy = 256
        @tec_non_attack = false # 必殺技で攻撃なし(超サイヤ人変身など
        @tec_tyousaiya = false # 超サイヤ人変身の技を使った時
        @tec_back = 0
        @tec_back_anime_type = 0
        @tec_back_small = false # 必殺技背景縮小フラグ
        @tec_back_color = 0 # 背景色
        @battle_anime_result = 0
        @back_anime_frame = 0     # 戦闘バックエフェクトのフレーム数
        @back_anime_type = 0      # 戦闘バックエフェクトのタイプ
        @ray_anime_type = 0
        @ray_anime_frame = 0
        @ray_spd_up_flag = false # 光線の速さアップ
        @ray_spd_up_num = 6 # 光線の速さアップ量
        @scombo_cha_anime_frame = 0 # スパーキングコンボ用フレーム
        @scombo_cha1 = 0            # スパーキング用キャラ表示
        @scombo_cha2 = 0
        @scombo_cha3 = 0
        @scombo_cha4 = 0
        @scombo_cha5 = 0
        @scombo_cha6 = 0
        @scombo_cha1_anime_type = 0 # スパーキング用アニメタイプ
        @scombo_cha2_anime_type = 0
        @scombo_cha3_anime_type = 0
        @scombo_cha4_anime_type = 0
        @scombo_cha5_anime_type = 0
        @scombo_cha6_anime_type = 0
        @effect_anime_type = 0    # 戦闘エフェクトのタイプ
        @effect_anime_pattern = 0 # 戦闘エフェクトのNo ここにNoをいれてメソッドを呼ぶ
        @effect_anime_frame = 0   # 戦闘エフェクトのフレーム数
        @effect_anime_mirror = 255 # 戦闘エフェクトでエフェクトを逆のタイプを使うか
        @output_anime_type = 0    # キャラチップ変更時に通常・必殺技を読むか？
        @output_anime_type_y = 0  # Y軸を反転するかどうか
        @ray_color = 0            # 光線の色
        @tec_power = 0            # 必殺技攻撃力
        @all_attack_flag = false
        @all_attack_count = 0
        @ene_set_action = 0
        @scombo_flag = false      # スパーキングコンボ実行フラグ
        @chk_scombo_skill = []    # スパーキングコンボ用必殺技No格納
        @chk_scombo_cha_no = []   # スパーキングコンボ用対象キャラ格納
        # スパーキングコンボチェック用
        @btl_ani_scombo_cha_count = 0
        @btl_ani_scombo_get_flag = 0
        @btl_ani_scombo_new_flag = 0
        @btl_ani_scombo_no = 0
        @btl_ani_scombo_cha = []
        @btl_ani_scombo_flag_tec = []
        @btl_ani_scombo_skill_level_num = []
        @btl_ani_scombo_card_attack_num = []
        @btl_ani_scombo_card_gard_num = []
        @btl_ani_tokusyu_flag = false
        @btl_ani_cha_chg_no = 0
        @tyosaiyachgyureue = false
        @tyosaiyachghensin = false
        @tec_kyouda_se = false
        @kyouda_se = false
        @kyouda_Z2_se = false
        @one_turntec = [] # 1ターンに1回しか使えない技
        @new_tecspark_flag = false # 閃き必殺技を取得した際に消費Kiを0にするために使用

        @skill_kiup_flag = false # スキル気をためるが有効になったか

        @tmp_scom_run_skill = [] # Sコンボ時に有効になるskillNo

        if $game_variables[35] == 0 # 背景スクロール設定
            @back_scroll_speed = 0
        else
            @back_scroll_speed = 4
        end
        # シナリオ進行度によってファイル名の頭文字を変える
        chk_scenario_progress

        @cha_attack_run = []
        for x in 0..$partyc.size - 1 # 攻撃済みフラグを初期化
            @cha_attack_run[x] = false
        end

        # 発動スキルの表示フレーム数
        @runskill_frame = 0
        # 発動スキルの表示位置(横)
        @runskill_putx = []
        # 発動スキルの表示が完了したフレーム数
        @runskill_lastput_frame = 9999999

        # 連続攻撃回数初期化
        $cha_biattack_count = 0

        if @set_bgm != nil
            $battle_bgm = @set_bgm # 戦闘曲
            set_battle_bgm
        end

        # p "$game_variables[319]:" + $game_variables[319].to_s,"$game_variables[429]:" + $game_variables[429].to_s,"$game_switches[111]:" + $game_switches[111].to_s,"$battle_escape:" + $battle_escape.to_s
        # 戦闘前BGM[319],イベント戦前BGM[429],ソリッドステートスカウター固定[111]
        if $game_variables[319] != 0 && $game_switches[111] == false && $battle_escape == true || # 通常戦
           $game_laps == 0 && $game_variables[319] != 0 && $game_switches[111] == false && $battle_escape == false || # クリア前イベント戦
           $game_laps >= 1 && $game_variables[429] != 0 && $game_switches[111] == false && $battle_escape == false # クリア後イベント戦
            set_battle_bgm
        end

        # 通常攻撃の真ん中へ移動するパターンのランダム値を格納
        @mannakaidouno = 0

        # けん制するかどうか
        @kenseiflag = nil

        # 通常攻撃のけん制へ移動するパターンのランダム値を格納
        @keinseino = 0
    end

    #--------------------------------------------------------------------------
    # ● 終了処理
    #--------------------------------------------------------------------------
    def terminate
        # Graphics.fadeout(10)
        dispose_window

        # フレームレートを戻す
        if $fast_fps == false
            Graphics.frame_rate = 60
        end
        Graphics.fadein(0)

        for x in 0..$Cardmaxnum + 1.to_i # 使用したカードを更新
            if $cardset_cha_no[x] != 99

                createcardval(x)
            end
        end
        $game_switches[12] = true

        # 戦闘に参加したキャラのみ フラグ初期化
        # p $cardset_cha_no
        for x in 0..$cardset_cha_no.size - 1

            if $cardset_cha_no[x] != 99

                # フルの方も初期化、これをしないとflagがtrueのままになってしまう
                # バトルシーンに戻った時フルから読み込みここで戻したフラグがフルで元に戻される
                # 先手カード
                $full_cha_sente_card_flag[$partyc[$cardset_cha_no[x]]] = false
                $cha_sente_card_flag[$cardset_cha_no[x]] = false

                # 回避カード
                $full_cha_kaihi_card_flag[$partyc[$cardset_cha_no[x]]] = false
                $cha_kaihi_card_flag[$cardset_cha_no[x]] = false

            end
        end
        # 変数初期化
        $cha_set_action = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        $cardset_cha_no = [99, 99, 99, 99, 99, 99]
        # @@card_set_no = [99,99,99,99,99,99]
        $cha_set_enemy = [99, 99, 99, 99, 99, 99, 99, 99, 99]
        $attack_order = Array.new
        $one_turn_cha_defense_up = false
        $run_stop_card = false
        $run_alow_card = false                      # ゴズカードを使用したか？
        $run_glow_card = false                      # メズカードを使用したか？
        $battle_turn_num_chk_flag = false # ターン数カウントフラグ
        # @@chk_attack_order = Array.new

        # イベント戦闘No初期化
        $game_variables[96] = 0
    end

    #--------------------------------------------------------------------------
    # ● フレーム更新
    #--------------------------------------------------------------------------
    def update
        # super
        $err_run_process_d = "アニメ開始"
        for x in 0..($attack_order.size-1)  # loop for all fighters, including enemy
            # 攻撃したかのチェック用のフラグをここで初期化
            @attack_any_one_flag = false

            # 攻撃ループ回数を取得
            $btl_attack_count = x
            begin # 攻撃回数
                $err_run_process_d2 = "攻撃方向セット"
                set_attack_dir(x)

                $err_run_process_d2 = "攻撃回数セット"
                chk_attack_num(x)  # 攻撃回数確認

                $err_run_process_d2 = "攻撃敵の攻撃設定"
                ene_action_set()  # 敵の攻撃を設定

                $err_run_process_d2 = "敵のステータスを表示するか判定"
                chk_output_status()  # 相手のステータスを表示するかチェック(超サイヤ人変身など攻撃がない場合は表示しない

                $err_run_process_d2 = "攻撃可能か判定"
                chk_attack(x)  # 攻撃可能か判定

                # p $attack_on_flag,$attack_on_flag[x]
                # if $fullpower_on_flag[x] == nil
                # 攻撃したかチェック
                # @attack_on
                #  $fullpower_on_flag[x] = true
                # end

                $err_run_process_d2 = "通常攻撃のパターン決定"  # pattern
                for y in 1..$attack_anime_max # 攻撃パターンセット
                    begin
                        _tempAnime = rand(4) + 1
                    end until $attack_anime.index(_tempAnime) == nil
                    $attack_anime[y] = _tempAnime
                end

                $err_run_process_d2 = "必殺技発動の動作設定"
                @tec_move = []
                for y in 1..2
                    @tec_move[y] = rand($tec_move_pattern) + 1
                end

                # p @attack_num , @attack_count

                # 味方が攻撃するときのみチェック 効果変更のためボツ
                # if @attackDir == 0
                #  @skill_kiup_flag = get_skill_kiup($partyc[@chanum.to_i])
                # end

                begin # 全体攻撃
                    $err_run_process_d2 = "巨大キャラか判定"
                    # 巨大キャラかチェック
                    if @all_attack_flag == true
                        chk_all_attack()
                    end

                    # p @enedatenum#,$data_enemies[@enedatenum]
                    if $data_enemies[@enedatenum].element_ranks[23] != 1
                        @enerect = Rect.new(0, 96 * 0, 96, 96)
                    else
                        # p @enedatenum
                        @enerect = Rect.new(0, 192 * 0, 192, 192)
                    end

                    if x >= 1 && @attack_on == true || @attack_count > 0 && @attack_on == true
                        fadetime = 0
                        if ((Input.press?(Input::R) and Input.press?(Input::B)) && $game_variables[96] == 0 && @new_tecspark_flag == false || ($game_switches[860] == true && $game_switches[883] == true) && (Input.press?(Input::R) and Input.press?(Input::B)))
                            fadetime = FASTFADEFRAME
                        else
                            fadetime = 10
                        end
                        Graphics.fadeout(fadetime)
                    end

                    if @attack_on == true
                        @all_attack_count += 1

                        # 味方が攻撃される、かつ全体攻撃ではない、かつかばう実行者がいる
                        if @attackDir == 1 && @all_attack_flag == false && $battle_kabau_runcha != nil
                            @chanum = $battle_kabau_runcha
                            # 初期化
                            # $battle_kabau_runcha = nil
                            # $battle_kabau_runskill = nil
                        end

                        # 試験的に移動
                        # 移動したら挑発とかが先に発動するようになってダメだった
                        #==================================================================================================
                        # if $battle_test_flag == false #戦闘テスト時は実行しない(なぜかSコンボ時にエラーになるため)
                        #  damage_calculation (@attackDir)
                        # else
                        #  @attack_hit = true
                        # end
                        #==================================================================================================

                        # 地球育ちのサイヤ人などのスキル発動
                        run_battle_start_mae_skill(@attackDir)
                        # ここで個別処理しないとダメだったので

                        window_contents_clear
                        output_back
                        output_status
                        @status_window.update
                        @back_window.update
                        Graphics.update

                        # 全体攻撃一度でも攻撃した場合はtrueを維持
                        @attack_any_one_flag = true
                    end

                    if x >= 1 && @attack_on == true || @attack_count > 0 && @attack_on == true
                        fadetime = 0
                        if ((Input.press?(Input::R) and Input.press?(Input::B)) && $game_variables[96] == 0 && @new_tecspark_flag == false || ($game_switches[860] == true && $game_switches[883] == true) && (Input.press?(Input::R) and Input.press?(Input::B)))
                            fadetime = FASTFADEFRAME
                        else
                            fadetime = 10
                        end

                        Graphics.fadein(fadetime)

                    end

                    $err_run_process_d2 = "戦闘アニメ開始"
                    if @attack_on == true
                        attack_start()
                        if @event_damege_result == true || $game_variables[96] == 0 # 戦闘ダメージ結果反映
                            chk_battle_damage if @tec_non_attack == false
                        end
                    end
                    @output_battle_damage_flag = false
                end while @all_attack_flag == true

                @attack_count += 1

                @all_attack_flag = false
                @all_attack_count = 0
                @skill_kiup_flag = false # スキル気をためるが有効になったか

                @backx = 0

                # スパーキングコンボを使ったのであれば技を戻す

                scombo_no = 0 # Sコンボの格納用
                if @scombo_flag == true
                    # 必殺技使用回数増加用に必殺技番号をもとに戻す
                    # Sコンボ参加者行動済みに
                    # さらにMP消費
                    # p $cha_set_action

                    scombo_no = $cha_set_action[@chanum] # Sコンボの場合技Noを格納

                    # コンボも使用回数を残すようにした。
                    # 使用回数増加
                    # p $cha_skill_level[(scombo_no - 10)]
                    if $cha_skill_level[(scombo_no - 10)] == nil
                        $cha_skill_level[(scombo_no - 10)] = 0
                    end
                    $cha_skill_level[(scombo_no - 10)] += 1 if $game_switches[1305] == false # 戦闘の練習中は増えない

                    # 使用回数が9999を超えたら9999をセット
                    if $cha_skill_level[(scombo_no - 10)] > $cha_skill_level_max
                        $cha_skill_level[(scombo_no - 10)] = $cha_skill_level_max
                    end

                    for y in 0..@btl_ani_scombo_cha.size - 1
                        $cha_set_action[$partyc.index(@btl_ani_scombo_cha[y])] = (@btl_ani_scombo_flag_tec[y] + 10)
                        @cha_attack_run[$partyc.index(@btl_ani_scombo_cha[y])] = true

                        tec_mp_cost = get_mp_cost(@btl_ani_scombo_cha[y], $data_skills[@btl_ani_scombo_flag_tec[y]].id,
                                                  1)

                        # 戦闘練習中でなければKIを消費する
                        if $game_switches[1305] != true
                            $game_actors[@btl_ani_scombo_cha[y]].mp -= tec_mp_cost
                        end
                        $cha_ki_zero[$partyc.index(@btl_ani_scombo_cha[y])] = false

                        if $full_cha_ki_zero != nil
                            $full_cha_ki_zero[$partyc[$partyc.index(@btl_ani_scombo_cha[y])]] = false
                        end
                        # $game_actors[@btl_ani_scombo_cha[y]].mp -= $data_skills[@btl_ani_scombo_flag_tec[y]].mp_cost
                    end
                end

                # p "@attack_on:" + @attack_on.to_s,
                # "@attack_any_one_flag:" + @attack_any_one_flag.to_s,
                # "@attackDir:" + @attackDir.to_s,
                # "@cha_attack_run:" + @cha_attack_run[@chanum].to_s,
                # "@all_attack_flag:" + @all_attack_flag.to_s

                # if @attack_on == true || @attackDir == 0 && @cha_attack_run[@chanum] == true
                if @attack_any_one_flag == true || @attackDir == 0 && @cha_attack_run[@chanum] == true
                    # p @cha_attack_run[@chanum],@chanum,$cha_set_action[@chanum]
                    set_skill_level
                end

                # 攻撃したかのチェック用のフラグをここで初期化
                @attack_any_one_flag = false

                # 超サイヤ人変身
                if @tec_tyousaiya == true
                    if @attackDir == 0
                        case $partyc[@chanum.to_i]
                        when 3 # ,14
                            schanum = 1
                        when 5 # ,18
                            schanum = 2
                        when 12 # ,19
                            schanum = 3
                        when 17 # ,20
                            schanum = 4
                        when 18
                            schanum = 5
                        when 25
                            schanum = 6
                        when 16
                            schanum = 7
                        end

                        # 3大スーパーサイヤ人の場合は、発動者ではなく強制的に悟空を超サイヤ人にする
                        # schanum = 1 if $goku3dai == true
                        schanum = 1 if scombo_no == 748
                        on_super_saiyazin(schanum)
                    end
                end

                # 大猿変身
                if @tec_oozaru == true
                    if @attackDir == 0
                        case $partyc[@chanum.to_i]
                        when 27 # トーマ
                            schanum = 1
                        when 28 # セリパ
                            schanum = 2
                        when 29 # トテッポ
                            schanum = 3
                        when 30 # パンブーキン
                            schanum = 4
                        when 5 # 悟飯
                            schanum = 5
                        end

                        on_oozaru(schanum)
                        $cha_bigsize_on[@chanum.to_i] = true
                    end
                end

                # 敵大猿
                if @ene_tec_oozaru == true
                    if $battleenemy[@enenum] == 12 # ベジータを大猿化
                        $battleenemy[@enenum] = 26
                        $battle_begi_oozaru_run = true
                    end

                    if $battleenemy[@enenum] == 59 # Z2ターレスを大猿化
                        $battleenemy[@enenum] = 70
                        $battle_tare_oozaru_run = true
                    end

                    if $battleenemy[@enenum] == 233 # ZGターレス(強)を大猿化
                        $battleenemy[@enenum] = 222
                        $battle_tare_oozaru_run = true
                    end

                    if $battleenemy[@enenum] == 60 # Z2スラッグを巨大化
                        $battleenemy[@enenum] = 71
                        $battle_sura_big_run = true
                    end

                    if $battleenemy[@enenum] == 255 # ZGスラッグ(強)を巨大化
                        $battleenemy[@enenum] = 223
                        $battle_sura_big_run = true
                    end
                end
                Audio.bgs_stop
                $btl_yasegaman_on_flag = false
                @new_tecspark_flag = false
                @status_window.visible = true
                @tyosaiyachgyureue = false
                @tyosaiyachghensin = false
                @scombo_flag = false
                @output_battle_damage_flag = false
                @tec_output_back = false
                @tec_non_attack = false
                @tec_tyousaiya = false
                @tec_oozaru = false
                @ene_tec_oozaru = false
                @tec_kyouda_se = false
                @kyouda_se = false
                @kyouda_Z2_se = false
                @chr_cutin = false
                @chr_cutin_flag = false
                @chr_cutin_mirror_flag = false
                @tec_output_back_no = 0
                @mannakaidouno = 0
                @keinseino = 0
                @kenseiflag = nil
                $skill_yousumi_runflag = false # 様子見flag初期化
                # 三大超サイヤ人の素材参照フラグを初期化
                $goku3dai = false

                $battle_kabawareru_runcha = nil # 戦闘中かばわれるキャラ
                $battle_kabau_runcha = nil # 戦闘中かばうスキルを実行するキャラ
                $battle_kabau_runskill = nil # 戦闘中実行するかばうスキルNo
                $battle_kabau_scenerun = false # かばう戦闘シーンを処理したか

                for y in 1..$attack_anime_max
                    $attack_anime[y] = 0
                end

                # ここの条件次第が悪い
                # HPを吸収した時に一定HPの割合に行くとループする
                # たまに攻撃回数が少なくなる時がある
                # if @attackDir == 1
                #  p "@attack_num > @attack_count",
                #    "@attack_num:" + @attack_num.to_s,
                #    "@attack_count:" + @attack_count.to_s
                # end
            end while @attack_num > @attack_count
            # end while @attack_num != @attack_count
            @attack_count = 0
            # スパーキングコンボチェック用
            @btl_ani_scombo_cha_count = 0
            @btl_ani_scombo_get_flag = 0
            @btl_ani_scombo_new_flag = 0
            @btl_ani_scombo_no = 0
            @btl_ani_scombo_cha = []
            @btl_ani_scombo_flag_tec = []
            @btl_ani_scombo_skill_level_num = []
            @btl_ani_scombo_card_attack_num = []
            @btl_ani_scombo_card_gard_num = []
            @btl_ani_cha_chg_no = 0
            @btl_ani_tokusyu_flag = false
            @cha_attack_run[@chanum] = true if @attackDir == 0 # 味方であれば攻撃済み

            @one_turntec = []
            # p @cha_attack_run
        end  # end of for x in 0..($attack_order.size-1)

        if Input.trigger?(Input::C)
            # window_key_state "C"
        end
        if Input.trigger?(Input::B)
            # window_key_state "B"
        end
        if Input.trigger?(Input::X)
            # window_key_state "X"
        end
        if Input.trigger?(Input::DOWN)
            # window_key_state 2
        end
        if Input.trigger?(Input::UP)
            # window_key_state 8
        end
        if Input.trigger?(Input::RIGHT)
            # window_key_state 6
        end
        if Input.trigger?(Input::LEFT)
            # window_key_state 4
        end

        fadetime = 0
        if ((Input.press?(Input::R) and Input.press?(Input::B)) && $game_variables[96] == 0 && @new_tecspark_flag == false || ($game_switches[860] == true && $game_switches[883] == true) && (Input.press?(Input::R) and Input.press?(Input::B)))
            fadetime = FASTFADEFRAME
        else
            fadetime = 10
        end
        Graphics.fadeout(fadetime)
        if $game_variables[96] == 0
            $scene = Scene_Db_Battle.new($battle_escape, $battle_bgm, $battle_ready_bgm)
        else
            # 戦闘関係のフラグ初期化
            reset_battle_flag
            # スーパーサイヤ人変身を解く
            off_super_saiyazin_all
            # 大猿状態を解く
            off_oozaru_all
            # イベントNoを増やすかチェック
            $put_battle_bgm = false
            for x in 0..7
                $cardi[x] = @tmp_cardi[x]
                $carda[x] = @tmp_carda[x]
                $cardg[x] = @tmp_cardg[x]
            end
            $scene = Scene_Map.new
        end
    end  # end of update()

    #--------------------------------------------------------------------------
    # ● 相手のステータスを表示するか判定
    #--------------------------------------------------------------------------
    def chk_output_status
        # 必殺技で攻撃する必要があるか
        if @attackDir == 0
            if $cha_set_action[@chanum] > 10
                # 攻撃なしか判定
                if $data_skills[$cha_set_action[@chanum] - 10].element_set.index(10) != nil
                    @tec_non_attack = true
                end
            end
        else
            if @ene_set_action > 10

                if $data_skills[@ene_set_action - 10].element_set.index(10) != nil
                    @tec_non_attack = true
                end
            end
        end
    end

    #--------------------------------------------------------------------------
    # ● 攻撃方向をセット
    #--------------------------------------------------------------------------
    def set_attack_dir(x)
        if $attack_order[x].to_s.size == 1
            @attackDir = 0 # 攻撃方向セット
            @chanum = $cardset_cha_no[$attack_order[x]] # 味方キャラNoセット
            $cha_biattack_count += 1
        else
            @attackDir = 1 # 攻撃方向セット
            $cha_biattack_count = 0
        end
    end

    #--------------------------------------------------------------------------
    # ● 閃き必殺技が使用可能かチェック
    #--------------------------------------------------------------------------
    def chk_tecspark_flag tmp_set_action
        # p $cha_set_action キャラごとの攻撃スキル番号をセット、攻撃しないのであれば値は0
        # p $cardset_cha_no 指定の枚目にキャラ番号が振ってある1人目は0,2人目は1

        if @attackDir == 1
            x = 0
            card_attack_num = [] # 攻撃星の数
            card_gard_num = [] # 防御星の数
            cha_skill_level_num = []
        else

            if $partyc.index(@btl_ani_tecspark_cha) != nil # 仲間にいる
                if $cardset_cha_no.index($partyc.index(@btl_ani_tecspark_cha)) != nil # 攻撃参加している
                    # p $tecspark_chk_flag[@btl_ani_tecspark_tec_no],@btl_ani_tecspark_tec_no
                    if $tecspark_chk_flag[@btl_ani_tecspark_tec_no] != 0

                        if $tecspark_chk_flag[@btl_ani_tecspark_tec_no] == 1 # スイッチ

                            return false if $game_switches[$tecspark_chk_flag_no[@btl_ani_tecspark_tec_no]] == false
                        # p $tecspark_chk_flag_no[x],$game_switches[$tecspark_chk_flag_no[x]]
                        elsif $tecspark_chk_flag[@btl_ani_tecspark_tec_no] == 2 # 変数
                            # チェック方法 0:一致 1:以上 2:以下
                            case $tecspark_chk_flag_process[@btl_ani_tecspark_tec_no]
                            when 0
                                return false if $game_variables[$tecspark_chk_flag_no[@btl_ani_tecspark_tec_no]] != $tecspark_chk_flag_value[@btl_ani_tecspark_tec_no]
                            when 1
                                return false if $game_variables[$tecspark_chk_flag_no[@btl_ani_tecspark_tec_no]] < $tecspark_chk_flag_value[@btl_ani_tecspark_tec_no]
                            when 2
                                return false if $game_variables[$tecspark_chk_flag_no[@btl_ani_tecspark_tec_no]] > $tecspark_chk_flag_value[@btl_ani_tecspark_tec_no]
                            end
                        end
                    end

                    # シナリオ進行度
                    return false if $tecspark_chk_scenario_progress[@btl_ani_tecspark_tec_no] > $game_variables[40]
                    return false if rand(100) + 1 > $tecspark_chk_acquisition_rate[@btl_ani_tecspark_tec_no] # 取得率チェック
                    return false if $game_switches[$tecspark_get_flag[@btl_ani_tecspark_tec_no]] == true # 取得済みかチェック
                    return false if $chadeadchk[$partyc.index(@btl_ani_tecspark_cha)] == true # 生きてる
                    return false if $cha_stop_num[$partyc.index(@btl_ani_tecspark_cha)] != 0 # 超能力にかかってないか
                    return false if @cha_attack_run[$partyc.index(@btl_ani_tecspark_cha)] == true # 行動済みではない
                    return false if $cha_set_action[$partyc.index(@btl_ani_tecspark_cha)] - 10 != @btl_ani_tecspark_flag_tec # 対象技を使ってるか
                    return false if $game_actors[@btl_ani_tecspark_cha].class_id - 1 != $cardi[$cardset_cha_no.index($partyc.index(@btl_ani_tecspark_cha))] # 流派が一致
                    return false if $carda[$cardset_cha_no.index($partyc.index(@btl_ani_tecspark_cha))] < @btl_ani_tecspark_card_attack_num # カードの攻撃星が以上
                    return false if $cardg[$cardset_cha_no.index($partyc.index(@btl_ani_tecspark_cha))] < @btl_ani_tecspark_card_gard_num # カードの防御星が以上

                    $cha_skill_level[@btl_ani_tecspark_flag_tec] = 0 if $cha_skill_level[@btl_ani_tecspark_flag_tec] == nil # 必殺技使用回数がnilかチェックしてnilなら0格納
                    return false if $cha_skill_level[@btl_ani_tecspark_flag_tec] < @btl_ani_tecspark_skill_level_num
                    return false if $game_switches[1305] == true # 戦闘の練習中は覚えない
                else
                    return false
                end
            else
                return false
            end

        end

        return true
    end

    #--------------------------------------------------------------------------
    # ● 閃き必殺技があるかチェック
    #--------------------------------------------------------------------------
    def chk_tecspark set_action
        chk_result = false

        tmp_tecspark_count = Marshal.load(Marshal.dump($tecspark_count))
        tmp_tecspark_get_flag = Marshal.load(Marshal.dump($tecspark_get_flag))
        tmp_tecspark_new_flag = Marshal.load(Marshal.dump($tecspark_new_flag))
        tmp_tecspark_no = Marshal.load(Marshal.dump($tecspark_no))
        tmp_tecspark_cha = Marshal.load(Marshal.dump($tecspark_cha))
        tmp_tecspark_flag_tec = Marshal.load(Marshal.dump($tecspark_flag_tec))
        tmp_tecspark_skill_level_num = Marshal.load(Marshal.dump($tecspark_skill_level_num))
        tmp_tecspark_card_attack_num = Marshal.load(Marshal.dump($tecspark_card_attack_num))
        tmp_tecspark_card_gard_num = Marshal.load(Marshal.dump($tecspark_card_gard_num))

        # Sコンボ配列内に対象技があるかチェック
        # なければループ抜ける
        # あれば
        x = 0
        chk_loop_result = false
        loop do
            for x in 0..tmp_tecspark_count
                chk_loop_result = true if tmp_tecspark_flag_tec[x] == set_action
                # p "最初のループ",chk_loop_result,x,tmp_tecspark_flag_tec[x]
                if chk_loop_result != false || x >= tmp_tecspark_count
                    break
                end

                x += 1 if chk_loop_result == false
            end

            # p "最初のループ抜けた",chk_loop_result,x,tmp_tecspark_flag_tec[x]
            if chk_loop_result != false
                # ひらめき技チェック用
                @btl_ani_tecspark_get_flag = tmp_tecspark_get_flag[x]
                @btl_ani_tecspark_new_flag = tmp_tecspark_new_flag[x]
                @btl_ani_tecspark_no = tmp_tecspark_no[x]
                @btl_ani_tecspark_cha = tmp_tecspark_cha[x]
                @btl_ani_tecspark_flag_tec = tmp_tecspark_flag_tec[x]
                @btl_ani_tecspark_skill_level_num = tmp_tecspark_skill_level_num[x]
                @btl_ani_tecspark_card_attack_num = tmp_tecspark_card_attack_num[x]
                @btl_ani_tecspark_card_gard_num = tmp_tecspark_card_gard_num[x]
                @btl_ani_tecspark_tec_no = x
                tmp_tecspark_flag_tec[x] = [0, 0] # 検索に引っかからないように値を変更
                # tmp_loop_count += 1
                # p @btl_ani_tecspark_cha_count,@btl_ani_tecspark_get_flag,@btl_ani_tecspark_new_flag,@btl_ani_tecspark_no,@btl_ani_tecspark_cha,@btl_ani_tecspark_flag_tec,@btl_ani_tecspark_skill_level_num,@btl_ani_tecspark_card_attack_num,@btl_ani_tecspark_card_gard_num
                # p "スパーキングコンボチェック前",chk_loop_result,x,tmp_tecspark_flag_tec[x]
                chk_result = chk_tecspark_flag(@btl_ani_tecspark_no)
            end

            if chk_result == true || x >= tmp_tecspark_count
                break

            end

            chk_loop_result = false
        end

        # もし条件が一致するなら合体攻撃を格納
        if chk_result == true
            @new_tecspark_flag = true
            $cha_set_action[@chanum] = @btl_ani_tecspark_no + 10
            chk_new_get_tecspark # @btl_ani_scombo_no
        end
    end

    #--------------------------------------------------------------------------
    # ● 閃き必殺を初めて使用したかチェック
    #--------------------------------------------------------------------------
    def chk_new_get_tecspark # action_no
        if $game_switches[@btl_ani_tecspark_get_flag] == false
            $game_switches[@btl_ani_tecspark_new_flag] = true
            $game_switches[30] = true
        end
    end

    #--------------------------------------------------------------------------
    # ● 攻撃可能か判定
    #--------------------------------------------------------------------------
    def chk_attack(x)
        @attack_on = true
        if $attack_order[x].to_s.size == 1
            # 味方

            # 敵が全て撃破状態
            if $enedeadchk.index(false) == nil
                @attack_on = false
                return
            end
            # @attackDir = 0 #攻撃方向セット
            # @chanum = $cardset_cha_no[$attack_order[x]]                   #味方キャラNoセット
            # 自分が死んでないかかつ超能力が掛かっていないかかつSコンボに参加してないか確認
            if $chadeadchk[@chanum] == false && $cha_stop_num[@chanum] == 0 && @cha_attack_run[@chanum] == false
                @enenum = $cha_set_enemy[$cardset_cha_no[$attack_order[x]]] # 敵キャラNoセット(表示順)
                @enedatenum = $battleenemy[@enenum] # キャラNoセット(データ順)

                if $cha_set_action[@chanum] > 10
                    # 使用するスキルが閃きするかチェック
                    chk_tecspark($cha_set_action[@chanum] - 10)

                    # 使用するスキルが合体攻撃を含むのであれば条件を満たすかチェック
                    # 優先度をプレイヤーが変更できる機能を入れるため、順番次第でSコンボが発動できなくなるのでその対策として
                    # まず未取得分のみチェックする
                    chk_scombo_flag_num($cha_set_action[@chanum] - 10, true) # if $data_skills[$cha_set_action[@chanum] - 10].element_set[0] == 4

                    # 未取得が見つからなかったら取得済みもチェックする
                    if @scombo_flag == false
                        chk_scombo_flag_num($cha_set_action[@chanum] - 10, false)
                    end

                    if $data_skills[$cha_set_action[@chanum] - 10].element_set.index(10) != nil && $enedeadchk.index(false) != nil
                        return
                        # else
                        #  #敵が全員死んでるならば
                        #  @attack_on = false
                        #  return
                    end

                    if $data_skills[$cha_set_action[@chanum] - 10].scope == 2
                        @enenum = -1
                        @all_attack_flag = true
                        return
                    end
                end
            else
                # 戦闘参加で止まるターン数減らす
                if $cha_stop_num[@chanum] != 0
                    $cha_stop_num[@chanum] -= 1
                    if $full_cha_stop_num == nil || $full_cha_stop_num == [] || $full_cha_stop_num[$partyc[@chanum]] == nil
                        $full_cha_stop_num[$partyc[@chanum]] = 0
                    end
                    $full_cha_stop_num[$partyc[@chanum]] -= 1
                end
                @attack_on = false
                return
            end

            # 敵が死んでないか、かつ敵が皆死んでないかを確認
            if $enedeadchk[@enenum] == false
                return

            # 対象の敵が死んでため、対象を選択しなおす
            elsif $enedeadchk[@enenum] == true && $enedeadchk.index(false) != nil

                # 作戦がセットされてなかったら低い敵から攻撃をセット
                $cha_tactics[0][$partyc[@chanum]] = 0 if $cha_tactics[0][$partyc[@chanum]] == nil
                case $cha_tactics[0][$partyc[@chanum]]

                when 0 # 弱い敵
                    if $enehp.min > 0 # HPが低い敵から攻撃していく
                        @enenum = $enehp.index($enehp.min)
                    else
                        set_enehp = 1
                        while $enehp.index(set_enehp) == nil
                            set_enehp += 1
                        end
                        @enenum = $enehp.index(set_enehp)
                    end

                when 1 # 強い敵

                    # if $enehp.min != 0 #HPが高い敵から攻撃していく
                    enemaxhp = [[], []]
                    for x in 0..$battleenemy.size - 1

                        if $enedeadchk[x] == false
                            enemaxhp[0][x] = $data_enemies[$battleenemy[x]].maxhp

                        else
                            enemaxhp[0][x] = 0
                        end
                        enemaxhp[1][x] = x
                    end
                    # p enemaxhp[0],enemaxhp[1],enemaxhp[0].max
                    @enenum = enemaxhp[1][enemaxhp[0].index(enemaxhp[0].max)]
                    # end
                end

                # if $enehp.min != 0 #HPが低い敵から攻撃していく
                #  @enenum = $enehp.index($enehp.min)
                # else
                #  set_enehp = 1
                #  while $enehp.index(set_enehp) == nil
                #    set_enehp += 1
                #  end
                #  @enenum = $enehp.index(set_enehp)
                # end
                # p @enedatenum,$battleenemy[@enenum],@enenum
                # @enenum = $enedeadchk.index(false)
                @enedatenum = $battleenemy[@enenum]
                if @enedatenum.to_i > 5 || @enedatenum.to_i == 0 || @enedatenum.to_i == 3
                    # p "敵敵死亡状態:" + $enedeadchk
                    # p "敵数:" + $battleenenum.to_s, "攻撃順サイズ:" + $attack_order.size.to_s
                end
                return
            else
                @attack_on = false
                return
            end
        else
            # 敵
            # @attackDir = 1 #攻撃方向セット

            chaalldead = false

            if $enedeadchk[@enenum] == true || $ene_stop_num[@enenum] != 0 # 敵が死んでないか確認

                if $ene_stop_num[@enenum] != 0
                    $ene_stop_num[@enenum] -= 1
                end
                @attack_on = false
                return
            end

            if @ene_set_action > 10

                if $data_skills[@ene_set_action - 10].scope == 2
                    @chanum = -1
                    @all_attack_flag = true
                    return
                end
            end

            for y in 0..$Cardmaxnum # 死んでいない味方キャラがいるか確認
                @chanum = $cardset_cha_no[y]

                # カードがセットされていてかつ生きているかをチェック
                if @chanum != 99 && $chadeadchk[@chanum] == false
                    break
                elsif y == $Cardmaxnum
                    @attack_on = false
                    chaalldead = true
                end
            end

            # if $data_skills[@ene_set_action - 10].element_set.index(10) != nil && chaalldead == false
            #    return
            # else
            #    #味方が全員死んでるならば
            #    @attack_on = false
            #    return
            # end

            if chaalldead == false # 攻撃先の決定
                begin
                    begin
                        y = rand($Cardmaxnum + 1)
                        @chanum = $cardset_cha_no[y]
                        # 必殺技などで強制的にターゲットを決定
                        if @ene_coerce_target_chanum != nil
                            @chanum = $partyc.index(@ene_coerce_target_chanum)
                        end

                        # イベント戦
                        if @event_ene_set_chara[@enenum] != nil
                            @chanum = @event_ene_set_chara[@enenum]
                        end
                    end while @chanum == 99
                end while $chadeadchk[@chanum] == true

                # イベント戦ではない、ターゲットがかばう候補かつ、
                # かばうスキルの発動条件を満たしている
                if @event_ene_set_chara[@enenum] == nil &&
                   chk_kabau($partyc[@chanum]) == true

                    # 今のところ必要な処理はchk_kabauで出来ているのでここではなにもしない
                end
            elsif chaalldead == true
                @attack_on = false
                return
            end
        end
    end

    #--------------------------------------------------------------------------
    # ● 全員攻撃可能か判定
    #--------------------------------------------------------------------------
    def chk_all_attack()
        @attack_on = true

        if @attackDir == 0
            @enenum += 1
            @enedatenum = $battleenemy[@enenum]
            if @enenum == $battleenenum - 1 # 敵数が最後までループしたか？
                @all_attack_flag = false
            end
            if $enedeadchk[@enenum] != false # 死亡確認
                @attack_on = false
                return
            end
        else
            @chanum += 1

            if @chanum == $partyc.size - 1 # 味方数が最後までループしたか？
                @all_attack_flag = false
            end

            if $chadeadchk[@chanum] != false # 死亡確認
                @attack_on = false
                return
            end

            if $cardset_cha_no.index(@chanum) == nil # カードセット確認
                @attack_on = false
                return
            end
        end
    end

    #--------------------------------------------------------------------------
    # ● キャラ能力やカードを表示
    #--------------------------------------------------------------------------
    def output_status
        tyousei_x = 16
        tyousei_y = 10
        color = set_skn_color(0)
        @status_window.contents.fill_rect(0, 0, 672, 156, color)

        color = set_skn_color(1) # 味方ステータス枠

        # 表示するかチェック
        chk_put_status = true
        if @attackDir == 1
            chk_put_status = false if @tec_non_attack == true
        end

        if chk_put_status == true
            @status_window.contents.fill_rect(@@chastex + 64 + tyousei_x, 0 + 10, 118, 98, color)

            if $battle_kabau_runcha == nil || $game_switches[884] == true
                putchano = @chanum
            else
                putchano = $partyc.index($battle_kabawareru_runcha)
            end

            # ヘッダ
            picture = Cache.picture("数字英語")
            # HP
            rect = Rect.new(0, 16, 32, 16)
            @status_window.contents.blt(@@chastex + 68 + tyousei_x, 32 + tyousei_y, picture, rect)
            # KI
            rect = Rect.new(32, 16, 32, 16)
            @status_window.contents.blt(@@chastex + 68 + tyousei_x, 64 + tyousei_y, picture, rect)

            #=======================================================================
            # 味方キャラ能力
            #=======================================================================
            # picturea = Cache.picture("名前")
            pictureb = Cache.picture("数字英語")
            # picturec = Cache.picture($btl_top_file_name+"顔味方")
            if ($game_actors[$partyc[putchano]].hp.prec_f / $game_actors[$partyc[putchano]].maxhp.prec_f * 100).prec_i < $hinshi_hp
                rect, picturec = set_character_face(1, $partyc[putchano] - 3)
            # rect = Rect.new(64, ($partyc[putchano] - 3)*64, 64, 64) # 顔グラ
            else
                rect, picturec = set_character_face(0, $partyc[putchano] - 3)
                # rect = Rect.new(0, ($partyc[putchano] - 3)*64, 64, 64) # 顔グラ
            end
            @status_window.contents.blt(@@chastex + tyousei_x, 0 + tyousei_y, picturec, rect)
            rect = Rect.new(160, 0, 16, 16) # スラッシュ

            if $game_actors[$partyc[putchano]].maxhp.to_s.size <= 4 # HPスラッシュずらすか
                @status_window.contents.blt(@@chastex + 100 + tyousei_x, 48 + tyousei_y, pictureb, rect)
            else
                @status_window.contents.blt(@@chastex + 100 + tyousei_x - 16, 48 + tyousei_y, pictureb, rect)
            end

            if $game_actors[$partyc[putchano]].maxmp.to_s.size <= 4 # MPスラッシュずらすか
                @status_window.contents.blt(@@chastex + 100 + tyousei_x, 80 + tyousei_y, pictureb, rect)
            else
                @status_window.contents.blt(@@chastex + 100 + tyousei_x - 16, 80 + tyousei_y, pictureb, rect)
            end
            for y in 1..$game_actors[$partyc[putchano]].hp.to_s.size # HP
                rect = Rect.new($game_actors[$partyc[putchano]].hp.to_s[-y, 1].to_i * 16, 0, 16, 16)
                @status_window.contents.blt(@@chastex + tyousei_x + 164 - (y - 1) * 16, 32 + tyousei_y, pictureb, rect)
            end

            for y in 1..$game_actors[$partyc[putchano]].maxhp.to_s.size # MHP
                rect = Rect.new($game_actors[$partyc[putchano]].maxhp.to_s[-y, 1].to_i * 16, 0, 16, 16)
                @status_window.contents.blt(@@chastex + tyousei_x + 164 - (y - 1) * 16, 48 + tyousei_y, pictureb, rect)
            end

            for y in 1..$game_actors[$partyc[putchano]].mp.to_s.size # MP
                rect = Rect.new($game_actors[$partyc[putchano]].mp.to_s[-y, 1].to_i * 16, 0, 16, 16)
                @status_window.contents.blt(@@chastex + tyousei_x + 164 - (y - 1) * 16, 64 + tyousei_y, pictureb, rect)
            end

            for y in 1..$game_actors[$partyc[putchano]].maxmp.to_s.size # MMP
                rect = Rect.new($game_actors[$partyc[putchano]].maxmp.to_s[-y, 1].to_i * 16, 0, 16, 16)
                @status_window.contents.blt(@@chastex + tyousei_x + 164 - (y - 1) * 16, 80 + tyousei_y, pictureb, rect)
            end

            # 流派_カード
            picture = Cache.picture("カード関係")
            rect = set_card_frame(4) # 流派枠
            @status_window.contents.blt(@@chastex + tyousei_x, 64 + tyousei_y, picture, rect)
            rect = Rect.new(32 * ($game_actors[$partyc[putchano]].class_id - 1), 64, 32, 32) # 流派
            @status_window.contents.blt(@@chastex + 16 + tyousei_x, 64 + tyousei_y, picture, rect)
            rect = set_card_frame(0)
            @status_window.contents.blt(@@chastex + tyousei_x + 182 + 2, 0 + tyousei_y, picture, rect)

            for x in 0..$Cardmaxnum
                if $cardset_cha_no[x] == putchano.to_i then

                    rect = set_card_frame(2, $carda[x]) # 攻撃
                    @status_window.contents.blt(@@chastex + 184 + tyousei_x + $output_carda_tyousei_x + 2,
                                                2 + tyousei_y + $output_carda_tyousei_y, picture, rect)
                    rect = set_card_frame(3, $cardg[x]) # 防御
                    @status_window.contents.blt(@@chastex + 212 + tyousei_x + $output_cardg_tyousei_x + 2,
                                                62 + tyousei_y + $output_cardg_tyousei_y, picture, rect)
                    rect = Rect.new(0 + 32 * ($cardi[x]), 64, 32, 32) # 流派
                    @status_window.contents.blt(@@chastex + 198 + tyousei_x + $output_cardi_tyousei_x + 2,
                                                32 + tyousei_y + $output_cardi_tyousei_y, picture, rect)
                    picture = Cache.picture("アイコン")
                    # 流派が一致かパワーアップフラグがONの時は上アイコン表示
                    if $game_actors[$partyc[putchano]].class_id - 1 == $cardi[x] || $cha_power_up[putchano] == true || @skill_kiup_flag == true
                        # パワーアップ
                        rect = Rect.new(32 * 0, 16, 32, 32)
                        @status_window.contents.blt(@@chastex + 68 - 2 + tyousei_x, 0 + tyousei_y, picture, rect)
                    end
                    # 防御力アップ
                    if $one_turn_cha_defense_up == true || $cha_defense_up[putchano] == true
                        rect = Rect.new(32 * 1, 16, 32, 32)
                        @status_window.contents.blt(@@chastex + 96 + tyousei_x, 0 + tyousei_y, picture, rect)
                    end

                    # 超能力
                    if $cha_stop_num[putchano] > 0
                        rect = Rect.new(32 * 5, 16, 32, 32)
                        @status_window.contents.blt(@@chastex + 126 + tyousei_x, 0 + tyousei_y, picture, rect)
                    end
                end
            end

        end
        #=======================================================================
        # 敵キャラ能力
        #=======================================================================
        top_name = set_ene_str_no(@enedatenum)
        picturec = Cache.picture(top_name + "顔敵")

        # 表示するかチェック
        chk_put_status = true
        if @attackDir == 0
            chk_put_status = false if @tec_non_attack == true
        end
        if chk_put_status == true
            if @enedatenum < $ene_str_no[1]
                if ($enehp[@enenum].prec_f / $data_enemies[@enedatenum.to_i].maxhp.prec_f * 100).prec_i < $hinshi_hp
                    rect = Rect.new(64, (@enedatenum.to_i) * 64, 64, 64) # 顔グラ
                else
                    rect = Rect.new(0, (@enedatenum.to_i) * 64, 64, 64) # 顔グラ
                end
            elsif @enedatenum < $ene_str_no[2]
                if ($enehp[@enenum].prec_f / $data_enemies[@enedatenum.to_i].maxhp.prec_f * 100).prec_i < $hinshi_hp
                    rect = Rect.new(64, (@enedatenum - $ene_str_no[1] + 1).to_i * 64, 64, 64) # 顔グラ
                else
                    rect = Rect.new(0, (@enedatenum - $ene_str_no[1] + 1).to_i * 64, 64, 64) # 顔グラ
                end
            else # if @enedatenum < $ene_str_no[3]
                if ($enehp[@enenum].prec_f / $data_enemies[@enedatenum.to_i].maxhp.prec_f * 100).prec_i < $hinshi_hp
                    rect = Rect.new(64, (@enedatenum - $ene_str_no[2] + 1).to_i * 64, 64, 64) # 顔グラ
                else
                    rect = Rect.new(0, (@enedatenum - $ene_str_no[2] + 1).to_i * 64, 64, 64) # 顔グラ
                end
                # else
                #  if ($enehp[@enenum].prec_f / $data_enemies[@enedatenum.to_i].maxhp.prec_f * 100).prec_i < $hinshi_hp
                #    rect = Rect.new(64, (@enedatenum-$ene_str_no[3]+1).to_i*64, 64, 64) # 顔グラ
                #  else
                #    rect = Rect.new(0, (@enedatenum-$ene_str_no[3]+1).to_i*64, 64, 64) # 顔グラ
                #  end
            end

            @status_window.contents.blt(@@enestex + 184 + tyousei_x, 0 + tyousei_y, picturec, rect)

            # 流派_カード
            picture = Cache.picture("カード関係")
            rect = set_card_frame(4) # 流派枠
            @status_window.contents.blt(@@enestex + 184 + tyousei_x, 64 + tyousei_y, picture, rect)
            rect = Rect.new(32 * ($data_enemies[@enedatenum].hit - 1), 64, 32, 32) # 流派
            @status_window.contents.blt(@@enestex + 200 + tyousei_x, 64 + tyousei_y, picture, rect)
            rect = set_card_frame(0) # カード
            @status_window.contents.blt(@@enestex + 16, 0 + tyousei_y, picture, rect)
            # CardsetCha = [0,1,2,3,4,5] #カードをセットしたキャラ
            # p $data_enemies[1].hit

            rect = set_card_frame(2, $enecarda[@enenum]) # 攻撃
            @status_window.contents.blt(@@enestex + 2 + tyousei_x + $output_carda_tyousei_x, 2 + tyousei_y + $output_carda_tyousei_y,
                                        picture, rect)
            rect = set_card_frame(3, $enecardg[@enenum]) # 防御
            @status_window.contents.blt(@@enestex + 30 + tyousei_x + $output_cardg_tyousei_x, 62 + tyousei_y + $output_cardg_tyousei_y,
                                        picture, rect)
            rect = Rect.new(0 + 32 * ($enecardi[@enenum]), 64, 32, 32) # 流派
            @status_window.contents.blt(@@enestex + 16 + tyousei_x + $output_cardi_tyousei_x, 32 + tyousei_y + $output_cardi_tyousei_y,
                                        picture, rect)

            if $run_scouter_ene[@enenum] == true
                color = set_skn_color(1) # 味方ステータス枠
                @status_window.contents.fill_rect(@@enestex + 66 + tyousei_x, 0 + tyousei_y, 118, 98, color)
                # ヘッダ
                picture = Cache.picture("数字英語")

                # HP
                case $data_enemies[@enedatenum.to_i].maxhp.to_s.size

                when 7..100 # (100万)
                # HPなど表示しない
                when 6 # (10万)
                    rect = Rect.new(0, 16 * 9, 16, 16)
                    @status_window.contents.blt(@@enestex + 70 + tyousei_x, 32 + tyousei_y, picture, rect)
                else # 1万の桁いない
                    # HP
                    rect = Rect.new(0, 16, 32, 16)
                    @status_window.contents.blt(@@enestex + 70 + tyousei_x, 32 + tyousei_y, picture, rect)
                end

                # KI(KIだけどHPの桁に合わせて変える)
                case $data_enemies[@enedatenum.to_i].maxhp.to_s.size
                when 7..100 # (100万)
                # HPなど表示しない
                when 6 # (10万)
                    rect = Rect.new(16, 16 * 9, 16, 16)
                    @status_window.contents.blt(@@enestex + 70 + tyousei_x, 64 + tyousei_y, picture, rect)
                else # 1万の桁いない
                    # KI
                    rect = Rect.new(32, 16, 32, 16)
                    @status_window.contents.blt(@@enestex + 70 + tyousei_x, 64 + tyousei_y, picture, rect)
                end

                # picturea = Cache.picture("名前")
                pictureb = Cache.picture("数字英語")
                rect = Rect.new(160, 0, 16, 16) # スラッシュ
                if $data_enemies[@enedatenum.to_i].maxhp.to_s.size < 5
                    # HP
                    @status_window.contents.blt(@@enestex + 102 + tyousei_x, 48 + tyousei_y, pictureb, rect)
                    # KI
                    @status_window.contents.blt(@@enestex + 102 + tyousei_x, 80 + tyousei_y, pictureb, rect)

                elsif $data_enemies[@enedatenum.to_i].maxhp.to_s.size < 7 # 10万
                    # HP
                    @status_window.contents.blt(
                        @@enestex + 102 + tyousei_x - 16 * ($data_enemies[@enedatenum.to_i].maxhp.to_s.size - 4), 48 + tyousei_y, pictureb, rect
                    )
                    # KI
                    @status_window.contents.blt(
                        @@enestex + 102 + tyousei_x - 16 * ($data_enemies[@enedatenum.to_i].maxhp.to_s.size - 4), 80 + tyousei_y, pictureb, rect
                    )

                end

                # HP無限
                if $data_enemies[@enedatenum.to_i].element_ranks[57] == 1
                    rect = Rect.new(11 * 16, 16, 16, 16)
                    @status_window.contents.blt(@@enestex + tyousei_x + 166 - (1 - 1) * 16, 32 + tyousei_y, pictureb,
                                                rect)
                    @status_window.contents.blt(@@enestex + tyousei_x + 166 - (1 - 1) * 16, 48 + tyousei_y, pictureb,
                                                rect)
                else
                    for y in 1..$enehp[@enenum].to_s.size # HP
                        rect = Rect.new($enehp[@enenum].to_s[-y, 1].to_i * 16, 0, 16, 16)
                        @status_window.contents.blt(@@enestex + tyousei_x + 166 - (y - 1) * 16, 32 + tyousei_y, pictureb,
                                                    rect)
                    end

                    for y in 1..$data_enemies[@enedatenum.to_i].maxhp.to_s.size # MHP
                        rect = Rect.new($data_enemies[@enedatenum.to_i].maxhp.to_s[-y, 1].to_i * 16, 0, 16, 16)
                        @status_window.contents.blt(@@enestex + tyousei_x + 166 - (y - 1) * 16, 48 + tyousei_y, pictureb,
                                                    rect)
                    end
                end

                # KI　ーを表示
                rect = Rect.new(11 * 16, 16, 16, 16)
                @status_window.contents.blt(@@enestex + tyousei_x + 166 - (1 - 1) * 16, 64 + tyousei_y, pictureb, rect)
                @status_window.contents.blt(@@enestex + tyousei_x + 166 - (1 - 1) * 16, 80 + tyousei_y, pictureb, rect)

                # KIを表示
                # for y in 1..$enemp[@enenum].to_s.size #MP
                #  rect = Rect.new($enemp[@enenum].to_s[-y,1].to_i*16, 0, 16, 16)
                #  @status_window.contents.blt(@@enestex+166-(y-1)*16,64,pictureb,rect)
                # end
                #
                # for y in 1..$data_enemies[@enedatenum.to_i].maxmp.to_s.size #MMP
                #  rect = Rect.new($data_enemies[@enedatenum.to_i].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
                #  @status_window.contents.blt(@@enestex+166-(y-1)*16,80,pictureb,rect)
                # end

                # 流派が一致かパワーアップフラグがONの時は上アイコン表示
                picture = Cache.picture("アイコン")
                # パワーアップ
                if $data_enemies[@enedatenum].hit - 1 == $enecardi[@enenum] || $ene_power_up[@enenum] == true
                    rect = Rect.new(32 * 0, 16, 32, 32)
                    @status_window.contents.blt(@@enestex + tyousei_x + 70 - 2, 0 + tyousei_y, picture, rect)
                end

                # 防御力アップ
                if $ene_defense_up == true
                    rect = Rect.new(32 * 1, 16, 32, 32)
                    @status_window.contents.blt(@@enestex + tyousei_x + 98, 0 + tyousei_y, picture, rect)
                end

                # 超能力
                if $ene_stop_num[@enenum] > 0
                    rect = Rect.new(32 * 5, 16, 32, 32)
                    @status_window.contents.blt(@@enestex + tyousei_x + 128, 0 + tyousei_y, picture, rect)
                end
            end
        end
    end

    #--------------------------------------------------------------------------
    # ● 発動スキル表示
    # type:1:攻撃、防御時の発動スキル　2:ヒットした時の発動スキル
    #--------------------------------------------------------------------------
    def output_runskill type = 1
        # 実行スキルがあれば表示
        # 以下条件
        # ・表示する最高フレームまで
        # ・戦闘テストフラグが立っていない
        # ・味方の全体攻撃は初回のみ表示(敵の全体攻撃はすべて(になっているはず))
        # ・攻撃ヒットは全体攻撃でもすべて表示
        if (($tmp_run_skill.size > 0 || $tmp_run_hit_skill.size > 0 || $tmp_run_kabau_skill.size > 0) && @runskill_frame <= 60 && $battle_test_flag != true &&
          (@all_attack_count == 1 && @attackDir == 0 || @attackDir == 1 || type == 2)) && $game_variables[96] == 0 && @tec_non_attack == false
            waku_ysize = 28
            waku_picture = Cache.picture("戦闘_Sコンボ表示枠")
            waku_rect = Rect.new(0, 0, 240, waku_ysize)
            put_skillnum = 3 # 表示スキル数
            put_skillsraidx = 32 # スキルスライド
            put_skillsraidxmax = 240
            @runskill_frame += 1
            # @runskill_lastput_frame = 999999
            # 発動スキルの表示位置(横)

            # スキル種別
            if type == 1
                # 攻撃防御
                if $tmp_run_skill.size > put_skillnum
                    put_loop = put_skillnum
                else
                    put_loop = $tmp_run_skill.size - 1
                end
            elsif type == 3
                # かばう時
                if $tmp_run_kabau_skill.size > put_skillnum
                    put_loop = put_skillnum
                else
                    put_loop = $tmp_run_kabau_skill.size - 1
                end
            else
                # ヒット時
                if $tmp_run_hit_skill.size > put_skillnum
                    put_loop = put_skillnum
                else
                    put_loop = $tmp_run_hit_skill.size - 1
                end
            end
            # スキル表示
            for y in 0..put_loop

                # スキル表示位置を格納
                if @runskill_putx.size != put_loop.size
                    @runskill_putx << -put_skillsraidxmax + (y * -48)
                end

                # スライド分追加
                if $game_variables[352] == 0
                    # スライドする
                    @runskill_putx[y] += put_skillsraidx
                else
                    # 固定位置
                    @runskill_putx[y] = 0
                end

                # スキル表示位置調整
                if @runskill_putx[y] > 0
                    @runskill_putx[y] = 0
                end

                mozi = "" # 文字変数初期化(殻にする)

                # スキル表示か、etc表示か
                if y != put_skillnum
                    # スキル名取得
                    if type == 1
                        # 攻撃防御スキル
                        mozi += $cha_skill_mozi_set[$tmp_run_skill[y]]
                    elsif type == 3
                        # かばうスキル
                        mozi += $cha_skill_mozi_set[$tmp_run_kabau_skill[y]]
                    else
                        mozi += $cha_skill_mozi_set[$tmp_run_hit_skill[y]]
                    end
                else
                    mozi += "ETC"
                end
                output_mozi(mozi)
                rect = Rect.new(16 * 0, 16 * 0, 16 * mozi.split(//u).size, 24)

                # 色を白に変更
                $tec_mozi.change_tone(255, 255, 255)

                # 発動スキル表示
                if $game_variables[351] == 0 || $game_variables[351] == 1 && @attackDir == 0 ||
                   $game_variables[351] == 2 && @attackDir == 1
                    # 枠の表示
                    @back_window.contents.blt(@runskill_putx[y], waku_ysize * y, waku_picture, waku_rect)

                    # スキル名表示
                    @back_window.contents.blt(16 + @runskill_putx[y], waku_ysize * y, $tec_mozi, rect)
                end
            end
        end
        # もしまだ取得してなければ色を変える
        # if $cha_skill_spval[$partyc[@@cursorstate]][tmp_skill_list_put_skill_no[x]] < $cha_skill_get_val[tmp_skill_list_put_skill_no[x]]
        #  $tec_mozi.change_tone(128,128,128)
        # end

        # もしまだセットしたことなければ色を変える
        # if $cha_skill_set_flag[$partyc[@@cursorstate]][tmp_skill_list_put_skill_no[x]] == 0 && tmp_skill_list_put_skill_no[x] != 0
        #  $tec_mozi.change_tone(255,255,255)
        # end
    end

    #--------------------------------------------------------------------------
    # ● 除外通常戦闘攻撃をセット
    #--------------------------------------------------------------------------
    def set_ok_normalattackpattern
        # 一応攻撃と防御側両方のスピードを取得しておく

        aspd = 0
        abig = false
        gspd = 0
        gbig = false

        ok_atk = []

        if @attackDir == 0
            # 味方が攻撃
            aspd = $game_actors[$partyc[@chanum]].agi
            # 味方の大きさ状態
            abig = true if $cha_bigsize_on[@chanum.to_i] == true

            # 敵が防御
            gspd = $data_enemies[@enedatenum].agi
            gbig = true if $data_enemies[@enedatenum].element_ranks[23] == 1
        else
            # 味方が防御
            gspd = $game_actors[$partyc[@chanum]].agi
            gbig = true if $cha_bigsize_on[@chanum.to_i] == true

            # 敵が攻撃
            aspd = $data_enemies[@enedatenum].agi
            abig = true if $data_enemies[@enedatenum].element_ranks[23] == 1
        end

        if aspd >= 0
            ok_atk = [1, 2, 3, 4]
        end

        if aspd >= 25
            ok_atk << 14 # Z1 下がって溜めて攻撃
        end

        if aspd >= 30
            ok_atk << 18 # Z1 連打けん制
        end

        if aspd >= 35
            ok_atk << 15 # Z1 上下で何度か攻撃
            ok_atk << 16 # Z1 連打3回
        end

        if aspd >= 40
            ok_atk << 17 # Z2 連打
        end

        if aspd >= 45
            ok_atk << 5 # Z3 下がって攻撃
            ok_atk << 7 # 1回ぶつかって攻撃
        end

        if aspd >= 55
            ok_atk << 8 # 2回ぶつかる
            ok_atk << 10 # その場で連打
        end

        if aspd >= 65
            ok_atk << 6 # 何度かぶつかる
            ok_atk << 9 # 下がって連打
        end

        if aspd >= 75
            ok_atk << 11 # 連打ぶつかって止め
        end

        if aspd >= 85
            ok_atk << 13 # 攻撃側が何度か回避後攻撃
        end

        if aspd >= 95
            ok_atk << 12 # 回避しながら連打
        end

        # 巨大キャラの場合、戦闘アニメ処理が対応していないので除外する
        if $cha_bigsize_on[@chanum.to_i] == true || $data_enemies[@enedatenum].element_ranks[23] == 1
            # 回避アニメが対応していない
            ok_atk.delete(12)
            # 移動が下に行き過ぎる
            ok_atk.delete(15)
        end

        # ライチーのような打撃グラがないキャラは、攻撃側が回避を除外
        if @attackDir == 0 && $data_enemies[@enedatenum].element_ranks[52] == 1
            # p 1,$data_enemies[@enedatenum]
            ok_atk.delete(13)
        end
        return ok_atk
    end

    def func_attack_anime_end()
        @battle_anime_frame = 0
        @anime_frame_format = false
        @battle_anime_result = 0
        @backx = STANDARD_BACKX
        @backy = STANDARD_BACKY
        @back_anime_type = 0
        @back_anime_frame = 0
        @effect_anime_pattern = 0
        @effect_anime_type = 0
        @effect_anime_frame = 0
        @effect_anime_mirror = 255
        @tec_back = 0
        @output_anime_type = 0
        @scombo_cha_anime_frame = 0
        @scombo_cha1 = 0
        @scombo_cha2 = 0
        @scombo_cha3 = 0
        @scombo_cha1_anime_type = 0
        @scombo_cha2_anime_type = 0
        @scombo_cha3_anime_type = 0
        @damage_huttobi = true
        @damage_center = false
        @output_battle_damage_flag = false
        @chay = -200 # キャラ画面範囲外へ
        @eney = -200 # キャラ画面範囲外へ
        @ene_coerce_target_chanum = nil # 敵が味方を強制的にターゲットを決める
        Audio.se_stop

        # 発動スキル表示用の変数初期化
        $tmp_run_skill = []
        $tmp_run_hit_skill = []
        $tmp_run_kabau_skill = []

        # 発動スキルの表示フレーム数
        @runskill_frame = 0
        # 発動スキルの表示位置(横)
        @runskill_putx = []
        # 発動スキルの表示が完了したフレーム数
        @runskill_lastput_frame = 9999999

        if @all_attack_flag == false
            @tec_output_back_no = 0
            @tec_back_anime_type = 0
            @tec_back_color = 0 # 背景色
            @tec_back_small = false
            @tec_output_back = false
            @ray_spd_up_flag = false
            @chr_cutin = false
            @chr_cutin_flag = false
            @chr_cutin_mirror_flag = false
            @output_battle_damage_flag = false
        end
    end

    #--------------------------------------------------------------------------
    # ● カットイン表示
    #--------------------------------------------------------------------------
    def output_cutin(attackPattern=0)
        # 必殺技カットイン

        if @chr_cutin_flag == false
            @chr_cutin = false
        end

        if @enedatenum < $ene_str_no[1] # 敵は敵の番号見て格納
            enecut_top_file_name = "Z1_"
        elsif @enedatenum < $ene_str_no[2]
            enecut_top_file_name = "Z2_"
            mainasu = $ene_str_no[1]
            tyousei = 0
        else # if @enedatenum < $ene_str_no[3]
            enecut_top_file_name = "Z3_"
            mainasu = $ene_str_no[2]
            tyousei = 0
            # else
            #  enecut_top_file_name = "ZG_"
            #  mainasu = $ene_str_no[3]
            #  tyousei = 4
        end

        # カットイン出力するかチェック
        put_cutin = true

        # 出力しない条件
        # 敵がZ1
        #
        if enecut_top_file_name == "Z1_" && @attackDir == 1 ||
           $game_variables[40] == 0 && @attackDir == 1 && @chr_cutin_mirror_flag == true
            put_cutin = false

        end

        if @chr_cutin == true && put_cutin == true
            if $btl_progress == 0
            # $btl_top_file_name = "Z1_"
            elsif $btl_progress == 1 || $btl_progress == 2
                if @attackDir == 0

                    if @chr_cutin_mirror_flag == false

                        rect, picture = set_battle_cutin_name($partyc[@chanum.to_i])

                    # picture = Cache.picture($btl_top_file_name + "味方カットイン")
                    # rect = Rect.new(0, 64*($partyc[@chanum.to_i]-3), 640, 64) # 背景上
                    else

                        if enecut_top_file_name != "Z1_"
                            picture = Cache.picture(enecut_top_file_name + "敵カットイン")
                            rect = Rect.new(0, 64 * ($battleenemy[@enenum] - mainasu) + tyousei, 640, 64 - tyousei) # 背景上
                        end
                    end

                    if enecut_top_file_name != "Z1_" || @chr_cutin_mirror_flag != true
                        @back_window.contents.blt(0, 256 + 36, picture, rect)
                    end
                else
                    if @chr_cutin_mirror_flag == false
                        if enecut_top_file_name != "Z1_"
                            picture = Cache.picture(enecut_top_file_name + "敵カットイン")
                            rect = Rect.new(0, 64 * ($battleenemy[@enenum] - mainasu) + tyousei, 640, 64 - tyousei) # 背景上
                        end
                    else

                        rect, picture = set_battle_cutin_name($partyc[@chanum.to_i])
                    end

                    if (enecut_top_file_name != "Z1_" || @chr_cutin_mirror_flag != false)
                        @back_window.contents.blt(0, 256 + 36, picture, rect)
                    end
                end

            end

        end
    end

    #--------------------------------------------------------------------------
    # ● 背景・色表示
    #--------------------------------------------------------------------------
    def output_back(attackPattern=0)
        # @back_window.contents.clear

        if @all_attack_count <= 1
            # 背景取得
            picture = Cache.picture($btl_map_top_file_name + "戦闘_背景")
            rect = Rect.new(0, $Battle_MapID * 100, 640, 100) # 背景

            if @backx <= 320 && @backx >= -320
                @back_window.contents.blt(@backx - 320, @backy, picture, rect)
                @back_window.contents.blt(@backx + 320, @backy, picture, rect)
            elsif @backx >= 320 then
                @back_window.contents.blt(@backx - 320, @backy, picture, rect)
                @back_window.contents.blt(@backx - 960, @backy, picture, rect)
            elsif @backx <= -320 then
                @back_window.contents.blt(@backx + 320, @backy, picture, rect)
                @back_window.contents.blt(@backx + 960, @backy, picture, rect)
            end
        end

        if $btl_progress == 0
        # $top_file_name = "Z1_"
        elsif $btl_progress == 1
            if @tec_output_back == true
                case @tec_output_back_no

                when 0
                    hai_max_size_x = 640
                    one_frame_pase = 12
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_上")
                    rect = Rect.new(0, 0, hai_max_size_x, 64) # 背景上
                    # @back_window.contents.blt(0 , 0,picture,rect)
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 0, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 0, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 0, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 0, picture, rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 0, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 0, picture, rect)
                    end
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_下")
                    rect = Rect.new(0, 0, hai_max_size_x, 64) # 背景下
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 256 + 36, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 256 + 36, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 256 + 36, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 256 + 36, picture,
                                                  rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 256 + 36, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 256 + 36, picture,
                                                  rect)
                    end
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    if @attackDir == 0
                        @tec_back -= one_frame_pase
                    else
                        @tec_back += one_frame_pase
                    end

                    if @tec_back >= hai_max_size_x
                        @tec_back -= hai_max_size_x
                    elsif @tec_back <= -hai_max_size_x
                        @tec_back += hai_max_size_x
                    end
                when 1
                    hai_max_size_x = 640
                    one_frame_pase = 12
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左")
                    rect = Rect.new(0, 0, 64, hai_max_size_x) # 背景左
                    # @back_window.contents.blt(0 , 0,picture,rect)

                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(0, @tec_back - hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(0, @tec_back + hai_max_size_x / 2, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(0, @tec_back - hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(0, @tec_back - (hai_max_size_x + hai_max_size_x / 2), picture, rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(0, @tec_back + hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(0, @tec_back + hai_max_size_x + hai_max_size_x / 2, picture, rect)
                    end

                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右")
                    rect = Rect.new(0, 0, 92, hai_max_size_x) # 背景右
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(640 - 64, @tec_back - hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(640 - 64, @tec_back + hai_max_size_x / 2, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(640 - 64, @tec_back - hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(640 - 64, @tec_back - (hai_max_size_x + hai_max_size_x / 2), picture,
                                                  rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(640 - 64, @tec_back + hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(640 - 64, @tec_back + hai_max_size_x + hai_max_size_x / 2, picture,
                                                  rect)
                    end
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    # if @attackDir == 0
                    @tec_back -= one_frame_pase
                    # else
                    #  @tec_back += one_frame_pase
                    # end

                    if @tec_back >= hai_max_size_x
                        @tec_back -= hai_max_size_x
                    elsif @tec_back <= -hai_max_size_x
                        @tec_back += hai_max_size_x
                    end
                when 2 # 左上、右下
                    hai_max_size_x = 238
                    hai_max_size_y = hai_max_size_x
                    # one_frame_pase = 8
                    anime_type_max = 2

                    picture = Cache.picture("Z3_戦闘_必殺技_背景_左上")
                    picture = Cache.picture("Z3_戦闘_必殺技_背景_左上(赤)") if @tec_back_color == 1
                    rect = Rect.new(@tec_back_anime_type * hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景左

                    @back_window.contents.blt(0, 0, picture, rect)

                    hai_max_size_x = 222
                    hai_max_size_y = hai_max_size_x
                    picture = Cache.picture("Z3_戦闘_必殺技_背景_右下")
                    picture = Cache.picture("Z3_戦闘_必殺技_背景_右下(赤)") if @tec_back_color == 1
                    rect = Rect.new(@tec_back_anime_type * hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景右
                    @back_window.contents.blt(640 - hai_max_size_x, 480 - hai_max_size_y - 124, picture, rect)
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    if @tec_back_anime_type == anime_type_max
                        @tec_back_anime_type = 0
                    else
                        @tec_back_anime_type += 1
                    end
                when 3 # 右上、左下
                    hai_max_size_x = 238
                    hai_max_size_y = hai_max_size_x
                    # one_frame_pase = 8
                    anime_type_max = 2

                    picture = Cache.picture("Z3_戦闘_必殺技_背景_右上")
                    picture = Cache.picture("Z3_戦闘_必殺技_背景_右上(赤)") if @tec_back_color == 1
                    rect = Rect.new(@tec_back_anime_type * hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景左

                    @back_window.contents.blt(640 - hai_max_size_x, 0, picture, rect)

                    hai_max_size_x = 222
                    hai_max_size_y = hai_max_size_x
                    picture = Cache.picture("Z3_戦闘_必殺技_背景_左下")
                    picture = Cache.picture("Z3_戦闘_必殺技_背景_左下(赤)") if @tec_back_color == 1
                    rect = Rect.new(@tec_back_anime_type * hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景右
                    @back_window.contents.blt(0, 480 - hai_max_size_y - 124, picture, rect)
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    if @tec_back_anime_type == anime_type_max
                        @tec_back_anime_type = 0
                    else
                        @tec_back_anime_type += 1
                    end
                end

            end
        elsif $btl_progress == 2
            if @tec_output_back == true

                case @tec_output_back_no

                when 0

                    hai_max_size_x = 648
                    # hai_max_size_y = 110
                    one_frame_pase = 8
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_上")
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_上(赤)") if @tec_back_color == 1
                    rect = Rect.new(0, 0, hai_max_size_x, 110) # 背景上
                    rect = Rect.new(0, 0, hai_max_size_x, 64) if @tec_back_small == true # 背景上小さい
                    # @back_window.contents.blt(0 , 0,picture,rect)
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 0, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 0, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 0, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 0, picture, rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 0, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 0, picture, rect)
                    end
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_下(加工)")
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_下(加工)(赤)") if @tec_back_color == 1
                    # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_下")
                    # tyousei_y = 30

                    if @tec_back_small == false # 背景下小さい
                        hai_max_size_y = 114
                        tyousei_y = 50
                        rect = Rect.new(0, 0, hai_max_size_x, hai_max_size_y) # 背景下
                    else
                        hai_max_size_y = 60
                        tyousei_y = -4
                        rect = Rect.new(0, 0, hai_max_size_x, hai_max_size_y) # 背景下
                    end

                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 256 + 36 - tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 256 + 36 - tyousei_y, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 256 + 36 - tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 256 + 36 - tyousei_y,
                                                  picture, rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 256 + 36 - tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 256 + 36 - tyousei_y,
                                                  picture, rect)
                    end
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    if @attackDir == 0
                        @tec_back -= one_frame_pase
                    else
                        @tec_back += one_frame_pase
                    end

                    if @tec_back >= hai_max_size_x
                        @tec_back -= hai_max_size_x
                    elsif @tec_back <= -hai_max_size_x
                        @tec_back += hai_max_size_x
                    end

                when 1 # 縦
                    hai_max_size_x = 360
                    one_frame_pase = 16
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左(加工)")

                    rect = Rect.new(0, 0, 94, hai_max_size_x) # 背景左
                    # @back_window.contents.blt(0 , 0,picture,rect)

                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(0, @tec_back - hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(0, @tec_back + hai_max_size_x / 2, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(0, @tec_back - hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(0, @tec_back - (hai_max_size_x + hai_max_size_x / 2), picture, rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(0, @tec_back + hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(0, @tec_back + hai_max_size_x + hai_max_size_x / 2, picture, rect)
                    end

                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右(加工)")
                    rect = Rect.new(0, 0, 92, hai_max_size_x) # 背景右
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(640 - 94, @tec_back - hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(640 - 94, @tec_back + hai_max_size_x / 2, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(640 - 94, @tec_back - hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(640 - 94, @tec_back - (hai_max_size_x + hai_max_size_x / 2), picture,
                                                  rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(640 - 94, @tec_back + hai_max_size_x / 2, picture, rect)
                        @back_window.contents.blt(640 - 94, @tec_back + hai_max_size_x + hai_max_size_x / 2, picture,
                                                  rect)
                    end
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    # if @attackDir == 0
                    @tec_back -= one_frame_pase
                    # else
                    #  @tec_back += one_frame_pase
                    # end

                    if @tec_back >= hai_max_size_x
                        @tec_back -= hai_max_size_x
                    elsif @tec_back <= -hai_max_size_x
                        @tec_back += hai_max_size_x
                    end

                when 2 # 左上、右下
                    hai_max_size_x = 238
                    hai_max_size_y = hai_max_size_x
                    # one_frame_pase = 8
                    anime_type_max = 2

                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左上")
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左上(赤)") if @tec_back_color == 1
                    rect = Rect.new(@tec_back_anime_type * hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景左

                    @back_window.contents.blt(0, 0, picture, rect)

                    hai_max_size_x = 222
                    hai_max_size_y = hai_max_size_x
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右下")
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右下(赤)") if @tec_back_color == 1
                    rect = Rect.new(@tec_back_anime_type * hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景右
                    @back_window.contents.blt(640 - hai_max_size_x, 480 - hai_max_size_y - 124, picture, rect)
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    if @tec_back_anime_type == anime_type_max
                        @tec_back_anime_type = 0
                    else
                        @tec_back_anime_type += 1
                    end
                when 3 # 右上、左下
                    hai_max_size_x = 238
                    hai_max_size_y = hai_max_size_x
                    # one_frame_pase = 8
                    anime_type_max = 2

                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右上")
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右上(赤)") if @tec_back_color == 1
                    rect = Rect.new(@tec_back_anime_type * hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景左

                    @back_window.contents.blt(640 - hai_max_size_x, 0, picture, rect)

                    hai_max_size_x = 222
                    hai_max_size_y = hai_max_size_x
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左下")
                    picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左下(赤)") if @tec_back_color == 1
                    rect = Rect.new(@tec_back_anime_type * hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景右
                    @back_window.contents.blt(0, 480 - hai_max_size_y - 124, picture, rect)
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    if @tec_back_anime_type == anime_type_max
                        @tec_back_anime_type = 0
                    else
                        @tec_back_anime_type += 1
                    end
                when 4 # 左上、右上
                    anime_type_max = 2
                    hai_max_size_x = 176
                    hai_max_size_y = 320

                    rect = Rect.new(@tec_back_anime_type * hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景左
                    picture = Cache.picture("ZG_戦闘_必殺技_背景_超カメハメ波_左")
                    picture = Cache.picture("ZG_戦闘_必殺技_背景_超カメハメ波_左(赤)") if @tec_back_color == 1

                    @back_window.contents.blt(0, 18, picture, rect)

                    picture = Cache.picture("ZG_戦闘_必殺技_背景_超カメハメ波_右")
                    picture = Cache.picture("ZG_戦闘_必殺技_背景_超カメハメ波_右(赤)") if @tec_back_color == 1

                    @back_window.contents.blt(640 - hai_max_size_x, 18, picture, rect)

                    if @tec_back_anime_type == anime_type_max
                        @tec_back_anime_type = 0
                    else
                        @tec_back_anime_type += 1
                    end
                when 5 # 2段ファイナルフラッシュ
                    hai_max_size_x = 672
                    # hai_max_size_y = 110
                    one_frame_pase = 8
                    picture = Cache.picture("ZG_戦闘_必殺技_背景(赤)")
                    rect = Rect.new(0, 0, hai_max_size_x, 46) # 背景上
                    # @back_window.contents.blt(0 , 0,picture,rect)
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 0, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 0, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 0, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 0, picture, rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 0, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 0, picture, rect)
                    end
                    # picture = Cache.picture("ZG_戦闘_必殺技_背景_細い(赤)")
                    # rect = Rect.new(0, 0, hai_max_size_x, 28) # 背景下
                    tyousei_y = 46
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 128 + tyousei_y,
                                                  picture, rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 128 + tyousei_y, picture,
                                                  rect)
                    end
                    rect = Rect.new(0, 0, hai_max_size_x, 42) # 背景下
                    tyousei_y = 46 * 2 + 96
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 128 + tyousei_y,
                                                  picture, rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 128 + tyousei_y, picture,
                                                  rect)
                    end
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    if @attackDir == 0
                        @tec_back -= one_frame_pase
                    else
                        @tec_back += one_frame_pase
                    end

                    if @tec_back >= hai_max_size_x
                        @tec_back -= hai_max_size_x
                    elsif @tec_back <= -hai_max_size_x
                        @tec_back += hai_max_size_x
                    end
                when 6 # バーニングアタック
                    hai_max_size_x = 672
                    # hai_max_size_y = 110
                    one_frame_pase = 8
                    picture = Cache.picture("ZG_戦闘_必殺技_背景(赤)_バーニングアタック上")
                    rect = Rect.new(0, 0, hai_max_size_x, 110) # 背景上
                    # @back_window.contents.blt(0 , 0,picture,rect)
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 0 + 4, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 0 + 4, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 0 + 4, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 0 + 4, picture,
                                                  rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 0 + 4, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 0 + 4, picture,
                                                  rect)
                    end
                    # picture = Cache.picture("ZG_戦闘_必殺技_背景_細い(赤)")
                    # rect = Rect.new(0, 0, hai_max_size_x, 28) # 背景下
                    tyousei_y = 114
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 128 + tyousei_y,
                                                  picture, rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 128 + tyousei_y, picture,
                                                  rect)
                    end
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    if @attackDir == 0
                        @tec_back -= one_frame_pase
                    else
                        @tec_back += one_frame_pase
                    end

                    if @tec_back >= hai_max_size_x
                        @tec_back -= hai_max_size_x
                    elsif @tec_back <= -hai_max_size_x
                        @tec_back += hai_max_size_x
                    end
                when 7 # イレイサーショック
                    hai_max_size_x = 672
                    # hai_max_size_y = 110
                    one_frame_pase = 8
                    picture = Cache.picture("ZG_戦闘_必殺技_背景(赤)_イレイサーショック上")
                    rect = Rect.new(0, 0, hai_max_size_x, 110) # 背景上
                    # @back_window.contents.blt(0 , 0,picture,rect)
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 0 + 4, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 0 + 4, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 0 + 4, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 0 + 4, picture,
                                                  rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 0 + 4, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 0 + 4, picture,
                                                  rect)
                    end
                    # picture = Cache.picture("ZG_戦闘_必殺技_背景_細い(赤)")
                    # rect = Rect.new(0, 0, hai_max_size_x, 28) # 背景下
                    tyousei_y = 130
                    if @tec_back <= (hai_max_size_x / 2) && @tec_back >= -(hai_max_size_x / 2)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                    elsif @tec_back >= (hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back - (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back - (hai_max_size_x + (hai_max_size_x / 2)), 128 + tyousei_y,
                                                  picture, rect)
                    elsif @tec_back <= -(hai_max_size_x / 2) then
                        @back_window.contents.blt(@tec_back + (hai_max_size_x / 2), 128 + tyousei_y, picture, rect)
                        @back_window.contents.blt(@tec_back + hai_max_size_x + (hai_max_size_x / 2), 128 + tyousei_y, picture,
                                                  rect)
                    end
                    # @back_window.contents.blt(0 , 256+36,picture,rect)

                    if @attackDir == 0
                        @tec_back -= one_frame_pase
                    else
                        @tec_back += one_frame_pase
                    end

                    if @tec_back >= hai_max_size_x
                        @tec_back -= hai_max_size_x
                    elsif @tec_back <= -hai_max_size_x
                        @tec_back += hai_max_size_x
                    end
                end
            end
        end

        # 背景スクロール
        if @attackDir == 0
            @backx -= @back_scroll_speed
        else
            @backx += @back_scroll_speed
        end

        if @backx >= 640
            @backx -= 640
        elsif @backx <= -640
            @backx += 640
        end

        # フェード時に非表示が気になるのでここでも表示させる
        output_cutin(attackPattern)
        # ステータス背景色
        # color = set_skn_color 0
        # @back_window.contents.fill_rect(0,356,680,150,color)
    end

    #--------------------------------------------------------------------------
    # ● 戦闘開始前に実行するスキル
    # 同調とか
    #--------------------------------------------------------------------------
    # 引数　n:0味方:1敵
    def run_battle_start_mae_skill(n)
        @tmp_scom_run_skill = []
        if n == 0 # 味方

            # 味方の攻撃
            for x in 0..$Cardmaxnum

                if $cardset_cha_no[x] == @chanum.to_i

                    if @scombo_flag == false

                    else
                        #=================================================================================
                        # スキル開始
                        #=================================================================================
                        run_skill = [] # 実行されたスキルを表示するための一時退避用
                        sum_scom_naibu_maxaup = 0 # Sコン内部的にあがる最大値

                        # 同調
                        scom_skillno = [363] # [363,364,696]
                        scom_maxa = 0
                        scom_maxg = 0
                        run_skill = []
                        run_doutyou_skill = false
                        for y in 0..@btl_ani_scombo_flag_tec.size - 1
                            for z in 0..scom_skillno.size - 1
                                if chk_skill_learn(scom_skillno[z], @btl_ani_scombo_cha[y])[0] == true
                                    run_skill << scom_skillno[z]
                                    run_doutyou_skill = true
                                end
                            end

                            if run_doutyou_skill == true
                                set_cardno = get_chaselcardno(@btl_ani_scombo_cha[y])
                                scom_maxa = $carda[set_cardno] if scom_maxa < $carda[set_cardno]
                                scom_maxg = $cardg[set_cardno] if scom_maxg < $cardg[set_cardno]
                            end
                        end

                        # 発動スキルに追加
                        if chk_run_scomskillno(scom_skillno, run_skill) != nil
                            @tmp_scom_run_skill << chk_run_scomskillno(scom_skillno, run_skill)
                        end

                        # 発動スキルに追加 ここだけ攻防別で認識させたいので、例外的に個別に指定する
                        # if chk_run_scomskillno([363,696],run_skill) != nil
                        #  @tmp_scom_run_skill << chk_run_scomskillno([363,696],run_skill)
                        # end

                        # 発動スキルに追加 ここだけ攻防別で認識させたいので、例外的に個別に指定する
                        # if chk_run_scomskillno([364,696],run_skill) != nil
                        #  @tmp_scom_run_skill << chk_run_scomskillno([363,696],run_skill)
                        # end

                        # 星調整
                        if scom_maxa != 0 || scom_maxg != 0
                            for y in 0..@btl_ani_scombo_flag_tec.size - 1
                                set_cardno = get_chaselcardno(@btl_ani_scombo_cha[y])
                                # if run_skill.index(696) != nil || run_skill.index(363) != nil
                                $carda[set_cardno] = scom_maxa
                                # end
                                # if run_skill.index(696) != nil || run_skill.index(364) != nil
                                $cardg[set_cardno] = scom_maxg
                                # end
                            end
                        end

                        # Sコンボ発動で星調整の取得
                        # 地球育ちのサイヤ人
                        scom_skillno = [678, 679, 680, 681, 682, 683, 684, 685, 686]
                        scom_aup = 0
                        scom_gup = 0
                        run_skill = []
                        for y in 0..@btl_ani_scombo_flag_tec.size - 1
                            for z in 0..scom_skillno.size - 1
                                if chk_skill_learn(scom_skillno[z], @btl_ani_scombo_cha[y])[0] == true
                                    run_skill << scom_skillno[z]
                                    if scom_aup < $cha_skill_a_hoshi[scom_skillno[z]]
                                        scom_aup = $cha_skill_a_hoshi[scom_skillno[z]]
                                    end
                                    if scom_gup < $cha_skill_g_hoshi[scom_skillno[z]]
                                        scom_gup = $cha_skill_g_hoshi[scom_skillno[z]]
                                    end
                                end
                            end
                        end

                        # 発動スキルに追加
                        if chk_run_scomskillno(scom_skillno, run_skill) != nil
                            @tmp_scom_run_skill << chk_run_scomskillno(scom_skillno, run_skill)
                        end

                        # 星調整
                        if scom_aup != 0 || scom_gup != 0
                            for y in 0..@btl_ani_scombo_flag_tec.size - 1
                                @btl_ani_scombo_cha[y]
                                # Sコンボ参加者の最大攻撃の星に合わせる
                                set_cardno = 0 # キャラクターが選択したカードNoを格納
                                # キャラクターが選択したカードNoを取得
                                set_cardno = get_chaselcardno(@btl_ani_scombo_cha[y])
                                $carda[set_cardno] += scom_aup
                                $cardg[set_cardno] += scom_gup

                                $carda[set_cardno] = 7 if $carda[set_cardno] > 7
                                $cardg[set_cardno] = 7 if $cardg[set_cardno] > 7
                            end
                        end

                        #=================================================================================
                        # スキル終わり
                        #=================================================================================
                    end
                end
            end
        end
    end

    #--------------------------------------------------------------------------
    # ● ダメージ計算
    #--------------------------------------------------------------------------
    # 引数　n:0味方:1敵
    def damage_calculation(n)
        @attack_hit = true
        @tmp_scom_run_skill = []
        if n == 0 # 味方

            # 味方の攻撃
            for x in 0..$Cardmaxnum

                if $cardset_cha_no[x] == @chanum.to_i

                    if $cha_set_action[@chanum] >= 11
                        @tec_power = $data_skills[$cha_set_action[@chanum] - 10].base_damage

                        # 熟練度でのダメージ計算
                        # p $game_variables[$data_skills[$cha_set_action[@chanum] - 10].id + 100]
                        if $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] != 0 && $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] != nil
                            # if $game_variables[$data_skills[$cha_set_action[@chanum] - 10].id + 100] != 0
                            skill_level = $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id]
                            # ダメージ計算最大数に調整する
                            skill_level = $cha_add_dmg_skill_level_max if skill_level >= $cha_add_dmg_skill_level_max
                            # skill_level = $game_variables[$data_skills[$cha_set_action[@chanum] - 10].id + 100]
                            skill_level = skill_level.prec_f
                            skill_level = (100 + skill_level)
                            skill_level = skill_level / 100

                            # p skill_level
                            # p @tec_power = (@tec_power*skill_level).ceil
                            @tec_power = (@tec_power * skill_level).ceil

                            # 熟練度が1000を超えていた場合
                            if $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] > ($cha_add_dmg_skill_level_max + 1)
                                skill_level2 = $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] - $cha_add_dmg_skill_level_max
                                skill_level2 = skill_level2.prec_f
                                skill_level2 = skill_level2 / $cha_add_dmg_atk_ratio

                                @tec_power = (@tec_power + skill_level2).ceil
                            end

                            # 大猿で必殺技の攻撃力アップ技か
                            if $cha_bigsize_on[@chanum.to_i] == true
                                @tec_power = (@tec_power.to_i * 2).prec_i
                            end
                        end
                    end

                    if @scombo_flag == false

                        if $cha_set_action[@chanum] >= 11
                            # 必殺技
                            @battledamage = (($game_actors[$partyc[@chanum.to_i]].atk + @tec_power) * 8 * ($carda[x] + 7 + rand(2) + 1)) / ($data_enemies[@enedatenum].def * ($enecardg[@enenum] + 7) / 3)
                        else
                            # 通常攻撃
                            # nil対策
                            $cha_normal_attack_level[$partyc[@chanum]] =
                                0 if $cha_normal_attack_level[$partyc[@chanum]] == nil

                            @tec_power = 3

                            skill_level = $cha_normal_attack_level[$partyc[@chanum]]
                            # ダメージ計算最大数に調整する
                            skill_level = $cha_add_dmg_skill_level_max if skill_level >= $cha_add_dmg_skill_level_max

                            skill_level = skill_level.prec_f
                            skill_level = (100 + skill_level)
                            skill_level = skill_level / 100

                            @tec_power = (@tec_power * skill_level).ceil

                            # 熟練度が1000を超えていた場合
                            if $cha_normal_attack_level[$partyc[@chanum]] > ($cha_add_dmg_skill_level_max + 1)
                                skill_level2 = $cha_normal_attack_level[$partyc[@chanum]] - $cha_add_dmg_skill_level_max
                                skill_level2 = skill_level2.prec_f
                                skill_level2 = skill_level2 / $cha_add_dmg_atk_ratio

                                @tec_power = (@tec_power + skill_level2).ceil
                            end

                            @battledamage = (($game_actors[$partyc[@chanum.to_i]].atk + @tec_power) * 8 * ($carda[x] + 7 + rand(2) + 1)) / ($data_enemies[@enedatenum].def * ($enecardg[@enenum] + 7) / 3)
                            # p $game_actors[$partyc[@chanum.to_i]].atk,@tec_power,$cha_normal_attack_level[$partyc[@chanum]]
                        end
                    else
                        # スパーキングコンボの場合は全員の攻撃力と技の攻撃力を足してさらに攻撃カードがほしと同じになる
                        # さらに、レベル分力をアップ
                        chanum_atk = 0
                        max_carda = 0 # 参加者の最大攻撃星最大値
                        # Sコンボのそもそもの攻撃力を追加
                        @tec_power = $data_skills[($cha_set_action[@chanum] - 10)].base_damage
                        # p @tec_power

                        #=================================================================================
                        # スキル開始
                        #=================================================================================
                        run_skill = [] # 実行されたスキルを表示するための一時退避用
                        sum_scom_naibu_maxaup = 0 # Sコン内部的にあがる最大値

                        # スキルで星の数調整
                        # 武泰斗の教え
                        scom_skillno = [687, 688, 689, 690, 691, 692, 693, 694, 695]
                        scom_max_aup = 0
                        run_skill = []
                        for y in 0..@btl_ani_scombo_flag_tec.size - 1
                            for z in 0..scom_skillno.size - 1
                                if chk_skill_learn(scom_skillno[z], @btl_ani_scombo_cha[y])[0] == true
                                    run_skill << scom_skillno[z]
                                    if scom_max_aup < $cha_skill_a_hoshi[scom_skillno[z]]
                                        scom_max_aup = $cha_skill_a_hoshi[scom_skillno[z]]
                                    end
                                end
                            end
                        end

                        # 発動スキルに追加
                        if chk_run_scomskillno(scom_skillno, run_skill) != nil
                            @tmp_scom_run_skill << chk_run_scomskillno(scom_skillno, run_skill)
                        end

                        # スキルの効果分を加算
                        sum_scom_naibu_maxaup += scom_max_aup

                        # スキルで星の数調整
                        # 連携
                        scom_skillno = [671, 672, 673, 674, 675, 676, 677]
                        scom_max_aup = 0
                        run_skill = []
                        for y in 0..@btl_ani_scombo_flag_tec.size - 1
                            for z in 0..scom_skillno.size - 1
                                if chk_skill_learn(scom_skillno[z], @btl_ani_scombo_cha[y])[0] == true
                                    run_skill << scom_skillno[z]
                                    if scom_max_aup < $cha_skill_a_hoshi[scom_skillno[z]]
                                        scom_max_aup = $cha_skill_a_hoshi[scom_skillno[z]]
                                    end
                                end
                            end
                        end

                        # 発動スキルに追加
                        if chk_run_scomskillno(scom_skillno, run_skill) != nil
                            @tmp_scom_run_skill << chk_run_scomskillno(scom_skillno, run_skill)
                        end

                        # スキルの効果分を加算
                        sum_scom_naibu_maxaup += scom_max_aup

                        #=================================================================================
                        # スキル終わり
                        #=================================================================================

                        for y in 0..@btl_ani_scombo_flag_tec.size - 1
                            scombo_tec_power = $data_skills[@btl_ani_scombo_flag_tec[y]].base_damage
                            if $cha_skill_level[@btl_ani_scombo_flag_tec[y]] != 0 && $cha_skill_level[@btl_ani_scombo_flag_tec[y]] != nil
                                skill_level = $cha_skill_level[@btl_ani_scombo_flag_tec[y]]
                                # ダメージ計算最大数に調整する
                                skill_level = $cha_add_dmg_skill_level_max if skill_level >= $cha_add_dmg_skill_level_max
                                skill_level = skill_level.prec_f
                                skill_level = (100 + skill_level)
                                skill_level = skill_level / 100
                                @tec_power += (scombo_tec_power * skill_level).ceil

                                # 熟練度が1000を超えていた場合
                                if $cha_skill_level[@btl_ani_scombo_flag_tec[y]] > ($cha_add_dmg_skill_level_max + 1)
                                    skill_level2 = $cha_skill_level[@btl_ani_scombo_flag_tec[y]] - $cha_add_dmg_skill_level_max
                                    skill_level2 = skill_level2.prec_f
                                    skill_level2 = skill_level2 / $cha_add_dmg_atk_ratio

                                    @tec_power = (@tec_power + skill_level2).ceil

                                end

                            else
                                @tec_power += scombo_tec_power
                                # p @tec_power
                            end
                            # 攻撃力
                            chanum_atk += $game_actors[@btl_ani_scombo_cha[y]].atk
                            # レベル
                            # chanum_atk += ($game_actors[@btl_ani_scombo_cha[y]].level / 2)
                            chanum_atk += ($game_actors[@btl_ani_scombo_cha[y]].level)
                            # p "味方攻撃力合計" + chanum_atk.to_s,"必殺技攻撃力合計" + @tec_power.to_s

                            # Sコンボ参加者の最大攻撃の星に合わせる
                            set_cardno = 0 # キャラクターが選択したカードNoを格納
                            # キャラクターが選択したカードNoを取得
                            set_cardno = get_chaselcardno(@btl_ani_scombo_cha[y])
                            if max_carda < $carda[set_cardno]
                                max_carda = $carda[set_cardno]
                            end
                        end

                        # Sコンボの使用回数分攻撃力を追加
                        if $cha_skill_level[($cha_set_action[@chanum] - 10)] == nil
                            $cha_skill_level[($cha_set_action[@chanum] - 10)] = 0
                        end
                        # 回数は人数 / 2 (人数が多いのが損にならないように)
                        # 人数の係数計算(3人以降は1人に応じて1.2倍ずつ熟練度の効果が増加する)
                        tec_size_keisuu = 1.0

                        if @btl_ani_scombo_flag_tec.size.to_i > 2
                            tec_size_keisuu = 1.0 + ((@btl_ani_scombo_flag_tec.size.to_i - 2) * 0.2)
                        end

                        @tec_power += ($cha_skill_level[($cha_set_action[@chanum] - 10)].to_f * (@btl_ani_scombo_flag_tec.size.to_i.to_f / 2) * tec_size_keisuu).ceil

                        # Sコンボの参加人数で星の数調整
                        max_carda += (@btl_ani_scombo_flag_tec.size - 2)

                        # スキルの効果分を加算(内部処理のみ変えるもの)
                        max_carda += sum_scom_naibu_maxaup

                        # Zを超えていたらZにする
                        if max_carda > 7
                            max_carda = 7
                        end

                        # ダメージ再集計算
                        @battledamage = ((chanum_atk + @tec_power) * 8 * (max_carda + 7 + rand(2) + 1)) / ($data_enemies[@enedatenum].def * ($enecardg[@enenum] + 7) / 3)

                        # 常にZ
                        # @battledamage = ((chanum_atk + @tec_power) * 8 * (7 + 7 + rand(2) + 1)) / ($data_enemies[@enedatenum].def * ($enecardg[@enenum] + 7)/3)
                    end

                    # スーパーサイヤ人ならばダメージ増加
                    # Sコンボ用に参加者もチェックする処理
                    temp_cha_no = []
                    if $data_skills[$cha_set_action[@chanum] - 10].element_set.index(33) != nil
                        # 使用技がSコンボだった
                        # p "Sコンボである"
                        temp_cha_no.concat($tmp_btl_ani_scombo_cha)
                    else
                        # 通常攻撃または一人の必殺技だった
                        # p "Sコンボじゃない"
                        temp_cha_no.concat([$partyc[@chanum.to_i]])
                    end

                    attacksupersaiyairu = false
                    for z in 0..temp_cha_no.size - 1
                        if $game_actors[temp_cha_no[z]].class_id == 9
                            attacksupersaiyairu = true
                        end
                    end

                    if attacksupersaiyairu == true
                        # if $game_actors[$partyc[@chanum.to_i]].class_id == 9
                        # ##if $partyc[@chanum.to_i] == 14 || $partyc[@chanum.to_i] == 17 || $partyc[@chanum.to_i] == 18 || $partyc[@chanum.to_i] == 19
                        @battledamage = (@battledamage.to_i * 1.3).prec_i
                    end

                    # 大猿ならばダメージ増加
                    # if $partyc[@chanum.to_i] == 5 || $partyc[@chanum.to_i] == 27 || $partyc[@chanum.to_i] == 28 || $partyc[@chanum.to_i] == 29 || $partyc[@chanum.to_i] == 30

                    if $cha_bigsize_on[@chanum.to_i] == true
                        @battledamage = (@battledamage.to_i * 1.5).prec_i
                    end
                    # end

                    # 流派がそろったときの処理
                    if $game_actors[$partyc[@chanum.to_i]].class_id - 1 == $cardi[x] || $cha_power_up[@chanum] == true || @skill_kiup_flag == true # スキル気をためるが有効になったか
                        @battledamage = (@battledamage.to_i * 1.3).prec_i
                    end

                    if $ene_defense_up == true # 防御力がアップしていればダメージ減少
                        @battledamage = (@battledamage * 0.7).prec_i
                    end

                    # スキルのダメージ調整
                    @battledamage = set_damage_add($partyc[@chanum.to_i], @enedatenum, @battledamage, 0, $cha_set_action[@chanum],
                                                   @enenum)

                    # Sコンボのスキル表示を追加
                    $tmp_run_skill += @tmp_scom_run_skill

                    # 必殺技でかつダメージなしの技であればダメージを0に
                    if $cha_set_action[@chanum] > 10
                        if $data_skills[$cha_set_action[@chanum] - 10].element_set.index(11) != nil
                            # if $cha_set_action[@chanum] == ENE_STOP_TEC #超能力の場合 ダメージなし
                            @battledamage = 0
                        end
                    end
                    # p (($data_enemies[@enedatenum].agi * 1.6 + $enecardg[@enenum]) - ($game_actors[$partyc[@chanum.to_i]].agi * 1.1 + $carda[x])).prec_i
                    avoid = ((($data_enemies[@enedatenum].agi * 1.2 + $enecardg[@enenum]) / 3) - (($game_actors[$partyc[@chanum.to_i]].agi * 1.1 + $carda[x]) / 3)).prec_i
                    # p $data_skills[$cha_set_action[@chanum]-10].element_set.index(29),$cha_set_action[@chanum]-10
                    if 0 < avoid
                        # p (($data_enemies[@enedatenum].agi * 1.2 + $enecardg[@enenum]) - ($game_actors[$partyc[@chanum.to_i]].agi * 1.1 + $carda[x])).prec_i
                        # 味方の攻撃が必ず当たるフラグがONの場合は必ず当たる　回避優先
                        # かつ必中スキルを覚えていない
                        if rand(100) + 1 < avoid && $game_switches[129] == false && $data_skills[$cha_set_action[@chanum] - 10].element_set.index(29) == nil && chk_skill_learn(
                            389, $partyc[@chanum.to_i]
                        )[0] == false
                            @attack_hit = false
                            @battledamage = 0
                        end
                    end

                    # 敵攻撃回避フラグがONの場合は必ず回避
                    if $game_switches[18] == true || @event_cha_atc_hit[@chanum] == true
                        @attack_hit = false
                        @battledamage = 0
                    end

                    # 変数味方攻撃力n倍が0以外なら倍率をかける
                    @battledamage = (@battledamage * $game_variables[81]).prec_i if $game_variables[81] != 0
                end
            end

            # ヒットスキルを取得(味方)
            get_attack_hit_skill(@chanum.to_i, @enenum, @attack_hit, @attackDir, $cha_set_action[@chanum],
                                 @battledamage)

        # @battledamage
        else
            # テキの攻撃
            for x in 0..$Cardmaxnum
                if $cardset_cha_no[x] == @chanum.to_i
                    tmp_tec_power = 0
                    @tec_power = 0
                    if @ene_set_action >= 11

                        tmp_tec_power = $data_skills[@ene_set_action - 10].base_damage
                        @tec_power = ($data_enemies[@enedatenum].atk.prec_f * (tmp_tec_power.prec_f / 100)).prec_i - $data_enemies[@enedatenum].atk
                        # p @tec_power,$data_enemies[@enedatenum].atk,tmp_tec_power
                        # p ($data_enemies[@enedatenum].atk.prec_f * (@tec_power.prec_f / 100)).prec_i,$data_enemies[@enedatenum].atk,@tec_power
                    end

                    # p $data_enemies[@enedatenum].atk,@enedatenum
                    # p @tec_power
                    @battledamage = (($data_enemies[@enedatenum].atk + @tec_power) * 8 * ($enecarda[@enenum] + 7 + rand(2) + 1)) / ($game_actors[$partyc[@chanum.to_i]].def * ($cardg[x] + 7) / 3)
                    # 流派がそろったときの処理
                    if $data_enemies[@enedatenum].hit - 1 == $enecardi[@enenum] || $ene_power_up[@enenum] == true
                        @battledamage = (@battledamage.to_i * 1.2).prec_i
                    end

                    # p $game_actors[$partyc[@chanum.to_i]]
                    # スーパーサイヤ人ならばダメージ減少
                    # p $game_actors[$partyc[@chanum.to_i]].class_id
                    if $game_actors[$partyc[@chanum.to_i]].class_id == 9
                        # if $partyc[@chanum.to_i] == 14 || $partyc[@chanum.to_i] == 17 || $partyc[@chanum.to_i] == 18 || $partyc[@chanum.to_i] == 19
                        @battledamage = (@battledamage * 0.85).prec_i
                    end

                    # 大猿ならばダメージ減少
                    # if $partyc[@chanum.to_i] == 27 || $partyc[@chanum.to_i] == 28 || $partyc[@chanum.to_i] == 29 || $partyc[@chanum.to_i] == 30

                    if $cha_bigsize_on[@chanum.to_i] == true
                        @battledamage = (@battledamage.to_i * 0.7).prec_i
                    end
                    # end

                    # 防御アップ状態であれば
                    if $one_turn_cha_defense_up == true || $cha_defense_up[@chanum.to_i] == true # 防御力がアップしていればダメージ減少
                        @battledamage = (@battledamage * 0.7).prec_i
                    end

                    # スキルのダメージ調整
                    @battledamage = set_damage_add($partyc[@chanum.to_i], @enedatenum, @battledamage, 1, 0, @enenum)

                    # 必殺技でかつダメージなしの技であればダメージを0に
                    if @ene_set_action > 10
                        if $data_skills[@ene_set_action - 10].element_set.index(11) != nil
                            # if $cha_set_action[@chanum] == ENE_STOP_TEC #超能力の場合 ダメージなし
                            @battledamage = 0
                        end
                    end

                    # p (($game_actors[$partyc[@chanum.to_i]].agi * 1.6 + $cardg[x]) - ($data_enemies[@enedatenum].agi * 1.1 + $enecarda[@enenum]) ).prec_i
                    avoid = ((($game_actors[$partyc[@chanum.to_i]].agi * 1.2 + $cardg[x]) / 3) - (($data_enemies[@enedatenum].agi * 1.1 + $enecarda[@enenum])) / 3).prec_i
                    avoid = get_avoid_add($partyc[@chanum.to_i], avoid)
                    if 0 < avoid
                        # p (($game_actors[$partyc[@chanum.to_i]].agi * 1.2 + $cardg[x]) - ($data_enemies[@enedatenum].agi * 1.1 + $enecarda[@enenum]) ).prec_i
                        # 敵の攻撃が必ず当たるフラグがONの場合は必ず当たる　回避優先
                        if rand(100) + 1 < avoid && $game_switches[130] == false && $data_skills[@ene_set_action - 10].element_set.index(29) == nil
                            @attack_hit = false
                            # @battledamage = 0
                        end
                    end

                    # 不惜身命====================================================
                    if chk_skill_learn(642, $partyc[@chanum.to_i])[0] == true || # 不惜身命9
                       chk_skill_learn(641, $partyc[@chanum.to_i])[0] == true || # 不惜身命8
                       chk_skill_learn(640, $partyc[@chanum.to_i])[0] == true || # 不惜身命7
                       chk_skill_learn(639, $partyc[@chanum.to_i])[0] == true || # 不惜身命6
                       chk_skill_learn(638, $partyc[@chanum.to_i])[0] == true || # 不惜身命5
                       chk_skill_learn(637, $partyc[@chanum.to_i])[0] == true || # 不惜身命4
                       chk_skill_learn(636, $partyc[@chanum.to_i])[0] == true || # 不惜身命3
                       chk_skill_learn(635, $partyc[@chanum.to_i])[0] == true || # 不惜身命2
                       chk_skill_learn(634, $partyc[@chanum.to_i])[0] == true # 不惜身命1
                        @attack_hit = true
                    end

                    # カードでの回避
                    if $cha_kaihi_card_flag[@chanum] == true
                        @attack_hit = false
                        # @battledamage = 0
                    end

                    # 味方攻撃回避フラグがONの場合は必ず回避
                    if $game_switches[17] == true || @event_atc_hit[@enenum] == true
                        @attack_hit = false
                        # @battledamage = 0
                    end

                    # 攻撃回避ならダメージ0
                    if @attack_hit == false
                        @battledamage = 0
                    end
                    # 変数味方攻撃力n倍が0以外なら倍率をかける
                    @battledamage = (@battledamage * $game_variables[82]).prec_i if $game_variables[82] != 0
                    # ヒットスキルを取得(敵)
                    # get_attack_hit_skill @chanum.to_i,@enenum,@attack_hit,@attackDir,0
                    # 敵の攻撃も送るようにしてみる
                    get_attack_hit_skill(@chanum.to_i, @enenum, @attack_hit, @attackDir, @ene_set_action,
                                         @battledamage)
                end

            end

        end
        # 強襲サイヤ人ダメージ
        # 攻撃力×8×(星の数＋７)＋0.799X))÷((漢数字＋7)×防御側BP×防御力

        @tec_power = 0 # 必殺技攻撃力初期化
    end

    #--------------------------------------------------------------------------
    # ● 戦闘ダメージ処理(死亡したかも判定)
    #--------------------------------------------------------------------------
    def chk_battle_damage
        if @attackDir == 0
            # 敵がダメージ
            # 戦闘練習時以外はHPを減らす
            if $game_switches[1305] != true
                $enehp[@enenum] -= @battledamage
            else
                # 1ターンのダメージ計算
                $game_variables[425] += @battledamage
            end

            # p $enehp[@enenum],@battledamage

            # 味方攻撃ダメージ合計
            $tmp_cha_attack_damege[$partyc[@chanum.to_i]] = 0 if $tmp_cha_attack_damege[$partyc[@chanum.to_i]] == nil
            $tmp_cha_attack_damege[$partyc[@chanum.to_i]] += @battledamage

            # 味方攻撃回数
            $tmp_cha_attack_count[$partyc[@chanum.to_i]] = 0 if $tmp_cha_attack_count[$partyc[@chanum.to_i]] == nil
            $tmp_cha_attack_count[$partyc[@chanum.to_i]] += 1

            # 最高ダメージ、キャラ一時保存
            if $game_variables[205] < @battledamage
                $game_variables[205] = @battledamage
                $game_variables[206] = $partyc[@chanum.to_i]
                $game_variables[215] = $battleenemy[@enenum]
            end
            if $enehp[@enenum] <= 0 # 敵死亡判定
                $enedeadchk[@enenum] = true
                $enehp[@enenum] = 0
                $battle_enedead_cha_no[@enenum] = $partyc[@chanum.to_i] # とどめを刺した味方キャラを格納
            end
            if @attack_hit == true
                if $cha_set_action[@chanum] > 10
                    if $data_skills[$cha_set_action[@chanum] - 10].element_set.index(12) != nil || $data_skills[$cha_set_action[@chanum] - 10].element_set.index(13) != nil || $data_skills[$cha_set_action[@chanum] - 10].element_set.index(14) != nil
                        # if $cha_set_action[@chanum] == ENE_STOP_TEC || $cha_set_action[@chanum] == ENE_STOP_TEC2 || $cha_set_action[@chanum] == ENE_STOP_TEC + 1
                        for x in 0..$Cardmaxnum
                            if $cardset_cha_no[x] == @chanum.to_i

                                # 超能力(太陽拳はコメントアウトした)
                                if $data_skills[$cha_set_action[@chanum] - 10].element_set.index(12) != nil # || $data_skills[$cha_set_action[@chanum]-10].element_set.index(14) != nil
                                    $ene_stop_num[@enenum] += STOP_TURN

                                    # 流派一致でさらに止める
                                    if $game_actors[$partyc[@chanum.to_i]].class_id - 1 == $cardi[x]
                                        $ene_stop_num[@enenum] += STOP_TURN
                                    end
                                end

                                # 流派一致で止める技
                                if $game_actors[$partyc[@chanum.to_i]].class_id - 1 == $cardi[x] && $data_skills[$cha_set_action[@chanum] - 10].element_set.index(13) != nil
                                    $ene_stop_num[@enenum] += STOP_TURN
                                end

                                # 太陽拳
                                if $data_skills[$cha_set_action[@chanum] - 10].element_set.index(14) != nil
                                    $ene_stop_num[@enenum] += STOP_TURN
                                end
                            end
                        end
                    end
                end

                # 大ざる解除用 大猿 シッポ 尻尾 気円斬 刀
                if $data_skills[$cha_set_action[@chanum] - 10].element_set.index(25) != nil

                    # ベジータ
                    $battleenemy[@enenum] = 12 if $battleenemy[@enenum] == 26

                    # ターレス
                    $battleenemy[@enenum] = 233 if $battleenemy[@enenum] == 222
                    $battleenemy[@enenum] = 59 if $battleenemy[@enenum] == 70

                end
            end

        else
            # 味方がダメージ
            $game_actors[$partyc[@chanum.to_i]].hp -= @battledamage

            # HPが0以下かつ、やせがまんが有効の場合はHPを1にする。
            if $game_actors[$partyc[@chanum.to_i]].hp <= 0 && $btl_yasegaman_on_flag == true
                $game_actors[$partyc[@chanum.to_i]].hp = 1
            end

            # ダメージが0以外ならヒットしたと判定
            if @battledamage != 0
                $one_turn_cha_hit_num[$cardset_cha_no.index(@chanum.to_i)] += 1
            end
            # 吸収
            if $data_skills[@ene_set_action - 10].element_set.index(15) != nil
                $enehp[@enenum] += @battledamage

                # 最大値を超えたら最大値にあわせる
                $enehp[@enenum] = $data_enemies[@enedatenum].maxhp if $data_enemies[@enedatenum].maxhp < $enehp[@enenum]
            end

            if @attack_hit == true

                # スキル鋼の意思か慈愛の心を取得していなければ、超能力効果を実行する
                # 動きを止める
                if (chk_haganenoishirun($partyc[@chanum]) != true && chk_ziairun($partyc[@chanum]) != true)
                    if $data_skills[@ene_set_action - 10].element_set.index(12) != nil || $data_skills[@ene_set_action - 10].element_set.index(14) != nil

                        $cha_stop_num[@chanum] += STOP_TURN
                        if $full_cha_stop_num == nil || $full_cha_stop_num == [] || $full_cha_stop_num[$partyc[@chanum]] == nil
                            $full_cha_stop_num[$partyc[@chanum]] = 0
                        end
                        $full_cha_stop_num[$partyc[@chanum]] += STOP_TURN
                    end
                end

                # 流派一致で動きを止める
                if (chk_haganenoishirun($partyc[@chanum]) != true && chk_ziairun($partyc[@chanum]) != true)
                    if $data_enemies[@enedatenum].hit - 1 == $enecardi[@enenum] && $data_skills[@ene_set_action - 10].element_set.index(13) != nil
                        $cha_stop_num[@chanum] += STOP_TURN
                        if $full_cha_stop_num == nil || $full_cha_stop_num == [] || $full_cha_stop_num[$partyc[@chanum]] == nil
                            $full_cha_stop_num[$partyc[@chanum]] = 0
                        end
                        $full_cha_stop_num[$partyc[@chanum]] += STOP_TURN
                    end
                end

                # 尻尾切る
                if $data_skills[@ene_set_action - 10].element_set.index(25) != nil
                    case $partyc[@chanum]

                    when 27 # トーマ
                        oozarucha = 1
                    when 28 # セリパ
                        oozarucha = 2
                    when 29 # トテッポ
                        oozarucha = 3
                    when 30 # パンブーキン
                        oozarucha = 4
                    when 5 # 悟飯
                        oozarucha = 5
                    end
                    $cha_bigsize_on[@chanum] = false
                    off_oozaru(oozarucha)

                end

                # 自爆
                if $data_skills[@ene_set_action - 10].element_set.index(60) != nil
                    $enedeadchk[@enenum] = true
                    $eneselfdeadchk[@enenum] = true
                    $enehp[@enenum] = 0
                end
            end
            # 味方防御ダメージ合計
            $tmp_cha_gard_damege[$partyc[@chanum.to_i]] = 0 if $tmp_cha_gard_damege[$partyc[@chanum.to_i]] == nil
            $tmp_cha_gard_damege[$partyc[@chanum.to_i]] += @battledamage

            # 味方防御回数
            $tmp_cha_gard_count[$partyc[@chanum.to_i]] = 0 if $tmp_cha_gard_count[$partyc[@chanum.to_i]] == nil
            $tmp_cha_gard_count[$partyc[@chanum.to_i]] += 1

            # 最高ダメージ、キャラ一時保存
            if $game_variables[209] < @battledamage
                $game_variables[209] = @battledamage
                $game_variables[210] = $battleenemy[@enenum]
                $game_variables[217] = $partyc[@chanum.to_i]
            end
            if $game_actors[$partyc[@chanum.to_i]].hp <= 0 # 味方死亡判定
                $chadeadchk[@chanum] = true
            end
        end

        # get_attack_hit_skill $partyc[@chanum.to_i],@enenum,@attack_hit,@attackDir
        # get_attack_hit_skill @chanum.to_i,@enenum,@attack_hit,@attackDir
    end

    #--------------------------------------------------------------------------
    # ● 攻撃アニメ変更
    #--------------------------------------------------------------------------
    # 引数：aord:攻撃か防御か n:戦闘アニメNo
    # aord: 0 for attack, 1 for defense ?
    def battle_anime_change(aord, n)
        if aord == 0
            if @attackDir == 0 then
                if $cha_bigsize_on[@chanum.to_i] != true
                    @charect = Rect.new(0, 0 + (96 * n), 96, 96)
                else
                    @charect = Rect.new(0, 192 * n, 192, 192)
                end
            else
                # @enerect = Rect.new(0 , 0+(96*n), 96, 96)
                # 巨大キャラかチェック
                if $data_enemies[@enedatenum].element_ranks[23] != 1
                    @enerect = Rect.new(0, 96 * n, 96, 96)
                else
                    @enerect = Rect.new(0, 192 * n, 192, 192)
                end
            end
        else
            if @attackDir == 0 then
                if $data_enemies[@enedatenum].element_ranks[23] != 1
                    @enerect = Rect.new(0, 96 * n, 96, 96)
                else
                    @enerect = Rect.new(0, 192 * n, 192, 192)
                end
            else
                # @charect = Rect.new(0 , 0+(96*n), 96, 96)
                if $cha_bigsize_on[@chanum.to_i] != true
                    @charect = Rect.new(0, 0 + (96 * n), 96, 96)
                else
                    @charect = Rect.new(0, 192 * n, 192, 192)
                end
            end

        end
    end

    #--------------------------------------------------------------------------
    # ● 状況を見て回避アニメを表示
    # ag:攻撃、防御どっち側を取得する確認
    #  a:攻撃 g:防御
    # put_x:出力位置x
    # put_y:出力位置y
    #--------------------------------------------------------------------------
    def put_kaihianime ag, put_x, put_y
        tyousei_x = 0
        if @attackDir == 0 && ag == "g" || @attackDir == 1 && ag == "a"

            if ag == "a"
                tyousei_x = -24
            else
                tyousei_x = 24
            end

            # 敵側取得表示
            if $data_enemies[@enedatenum].element_ranks[23] != 1
                picture = Cache.picture("戦闘アニメ") # ダメージ表示
                rect = Rect.new(0, 48, 64, 64)
                @back_window.contents.blt(put_x, put_y, picture, rect)
            else
                picture = Cache.picture("戦闘アニメ96×96用回避") # ダメージ表示
                rect = Rect.new(0, 0, 128, 128)
                @back_window.contents.blt(put_x + tyousei_x, put_y - 32, picture, rect)
            end

        else
            if ag == "a"
                tyousei_x = 72
            else
                tyousei_x = 72
            end
            # 味方側取得表示
            if $cha_bigsize_on[@chanum] != true
                picture = Cache.picture("戦闘アニメ") # ダメージ表示
                rect = Rect.new(0, 48, 64, 64)
                @back_window.contents.blt(put_x, put_y, picture, rect)
            else
                picture = Cache.picture("戦闘アニメ96×96用回避") # ダメージ表示
                rect = Rect.new(0, 0, 128, 128)
                # @back_window.contents.blt(@chax+8-64,@chay+16+500-32,picture,rect)
                @back_window.contents.blt(put_x - tyousei_x, put_y - 32, picture, rect)
            end
        end
    end

    #--------------------------------------------------------------------------
    # ● 戦闘キャラ画面範囲外へ
    #--------------------------------------------------------------------------
    def set_chr_display_out()
        if @attackDir == 0
            @output_anime_type = 0
            @chay = -200 # キャラ画面範囲外へ
            @enex = CENTER_ENEX
            @eney = STANDARD_ENEY
        else
            @eney = -200 # キャラ画面範囲外へ
            @chax = CENTER_CHAX
            @chay = STANDARD_CHAY
        end

        if @chr_cutin_flag == true
            @chr_cutin_mirror_flag = true
        end
    end

    #--------------------------------------------------------------------------
    # ● 背景アニメパターン
    # mirror_pattern:強制的に逆のモードにする
    #--------------------------------------------------------------------------
    def back_anime_pattern(n, back_x=0, back_y=0, mirror_pattern=@attackDir)
        case n

        when 1 # 衝撃波系横

            if @attackDir == 0 && $data_enemies[@enedatenum].element_ranks[23] == 1 || @attackDir == 1 && $cha_bigsize_on[@chanum] == true # || @attackDir == 1 && $data_enemies[@enedatenum].element_ranks[23] == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_衝撃波系") # ダメージ表示用
                rect = Rect.new(0, @back_anime_type * 180, 640, 42)
                @back_window.contents.blt(0, 80 - 48, picture, rect)
                rect = Rect.new(0, 138 + @back_anime_type * 180, 640, 42)
                @back_window.contents.blt(0, 80 + 180 - 42 + 48, picture, rect)
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_衝撃波系") # ダメージ表示用
                rect = Rect.new(0, @back_anime_type * 180, 640, 180)
                @back_window.contents.blt(0, 80, picture, rect)
            end
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end

        when 2 # 必殺技発動時縦

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_魔族系(縦)") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 480, 640, 356)
            @back_window.contents.blt(0, 0, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 3 # 必殺技発動時横

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_魔族系(横)") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 304, 640, 304)
            @back_window.contents.blt(0, 0, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 4 # 気を溜める(小)？
            if @ray_color == 0
                picture = Cache.picture("Z1_戦闘_必殺技_気を溜める") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z1_戦闘_必殺技_気を溜める(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture("Z1_戦闘_必殺技_気を溜める(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture("Z1_戦闘_必殺技_気を溜める") # ダメージ表示用
            end

            if back_x == 0 || back_x == nil

                back_x = 234
                back_y = 70
            end
            rect = Rect.new(0, @back_anime_type * 222, 160, 222)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 5 # 気を溜める(中)？

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 192, 128, 192)
            @back_window.contents.blt(250, 56, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 6 # 気を溜める(魔閃光)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 160, 160, 160)

            if back_x == 0 || back_x == nil

                back_x = 234
                back_y = 112
            end

            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 7 # 気を溜める(気功砲)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める4") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 360, 640, 356)
            @back_window.contents.blt(0, 0, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 8 # 気を溜める(四身の拳気功砲)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(四身の拳気功砲)") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 360, 640, 360)
            @back_window.contents.blt(0, 0, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 9 # 四身の拳気功砲系縦

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_気功砲系") # ダメージ表示用

            if @attackDir == 0 && $data_enemies[@enedatenum].element_ranks[23] == 1 || @attackDir == 1 && $cha_bigsize_on[@chanum] == true
                if @attackDir == 0
                    rect = Rect.new(0, @back_anime_type * 360, 142, 356)
                    @back_window.contents.blt(170 - 14, 0, picture, rect)
                    rect = Rect.new(242, @back_anime_type * 360, 142, 356)
                    @back_window.contents.blt(170 - 14 + 142 + 200, 0, picture, rect)
                else
                    rect = Rect.new(0, @back_anime_type * 360, 142, 356)
                    @back_window.contents.blt(-20, 0, picture, rect)
                    rect = Rect.new(242, @back_anime_type * 360, 142, 356)
                    @back_window.contents.blt(-20 + 142 + 200, 0, picture, rect)
                end
            else
                if @attackDir == 0
                    rect = Rect.new(0, @back_anime_type * 360, 384, 356)
                    @back_window.contents.blt(170, 0, picture, rect)
                else
                    rect = Rect.new(0, @back_anime_type * 360, 384, 356)
                    @back_window.contents.blt(90, 0, picture, rect)
                end
            end
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 10 # 気を溜める(超能力)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_超能力") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 160, 128, 160)
            @back_window.contents.blt(248, 110, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 11 # 気を溜める(ラディッツ)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_手に気を溜める_片手") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 48, 40, 48)
            @back_window.contents.blt(266, 116, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 9
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 12 # 気を溜める両手(ラディッツ)
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_手に気を溜める_両手") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 48, 100, 48)
            @back_window.contents.blt(266, 116, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 9
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 13 # 気を溜める(ブラックホール波)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める5") # ダメージ表示用
            if $btl_progress >= 2
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める10") # ダメージ表示用
            end
            rect = Rect.new(0, @back_anime_type * 378, 640, 356)
            @back_window.contents.blt(0, 0, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 14 # 気を溜める(ナッパエネルギー波)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める6") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 178, 190, 178)
            @back_window.contents.blt(220, 100, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 15 # 気を溜める(ナッパ口からエネルギー波)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める7") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 256, 256, 256)
            @back_window.contents.blt(190, 60, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 16 # 気を溜める(ギャリック砲)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める8") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 380, 640, 356)
            @back_window.contents.blt(0, 0, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 17 # 気を溜める(界王拳カメハメは)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める9") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 378, 640, 356)
            @back_window.contents.blt(0, 0, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 18 # 捨て身攻撃まかんこうさっぽうため

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 192, 128, 192)
            @back_window.contents.blt(250 - 120 - 36, 56, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 19 # 捨て身悟空現れる
            picture = Cache.picture(set_battle_character_name(3, 1))
            picture = Cache.picture(set_battle_character_name(14, 1)) if $super_saiyazin_flag[1] == true
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用

            if $btl_progress == 0
                rect = Rect.new(0, 11 * 96, 96, 96)
                @back_window.contents.blt(CENTER_ENEX + 12, STANDARD_ENEY - 90, picture, rect)
            elsif $btl_progress == 1 || $btl_progress == 2
                rect = Rect.new(0, 16 * 96, 96, 96)
                @back_window.contents.blt(CENTER_ENEX + 12, STANDARD_ENEY - 90 + 6, picture, rect)
            end
        when 20 # 捨て身悟空離れる
            picture = Cache.picture(set_battle_character_name(3, 1))
            picture = Cache.picture(set_battle_character_name(14, 1)) if $super_saiyazin_flag[1] == true
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用

            rect = Rect.new(0, 10 * 96, 96, 96)
            rect = Rect.new(0, 7 * 96, 96, 96) if $btl_progress == 1
            if @back_anime_type == 0
                # rect = Rect.new(0,10*96,96,96)
                @back_window.contents.blt(CENTER_ENEX + 12 + @back_anime_frame * 8, STANDARD_ENEY - 6, picture, rect)
            else
                rect = Rect.new(0, 11 * 96, 96, 96)
                rect = Rect.new(0, 16 * 96, 96, 96) if $btl_progress == 1 || $btl_progress == 2
                @back_window.contents.blt(CENTER_ENEX + 12 + 8 * 4, STANDARD_ENEY + 6 - 6 - (@back_anime_frame - 8) * 16,
                                          picture, rect)
            end

            if @back_anime_frame == 8 #  && @back_anime_type != 2
                @back_anime_type += 1
            end
        when 21 # 気を溜める(小)(操気円斬ヤムチャ
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(緑)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める") # ダメージ表示用
            end
            rect = Rect.new(0, @back_anime_type * 222, 160, 222)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 22 # 気を溜める(小)(操気円斬ヤムチャ自身
            picture = Cache.picture(set_battle_character_name(7, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
            rect = Rect.new(0, 3 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
        when 23 # 気を溜める(小)(操気円斬ヤムチャ自身
            picture = Cache.picture(set_battle_character_name(7, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
            rect = Rect.new(0, 4 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
        when 24 # 気を溜める(小)(操気円斬ヤムチャ自身
            picture = Cache.picture(set_battle_character_name(7, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
            rect = Rect.new(0, 5 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
        when 25 # 気を溜める(小)(操気円斬ヤムチャ自身
            picture = Cache.picture(set_battle_character_name(7, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
            rect = Rect.new(0, 6 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
        when 26 # 気を溜める(小)(操気円斬ヤムチャ自身
            picture = Cache.picture(set_battle_character_name(7, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
            rect = Rect.new(0, 7 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
        when 27 # 気を溜める(小)(操気円斬クリリン自身
            picture = Cache.picture(set_battle_character_name(6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
        when 28 # 気を溜める(小)(操気円斬クリリン自身
            picture = Cache.picture(set_battle_character_name(6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            rect = Rect.new(0, 7 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
        when 29 # 気を溜める(小)(操気円斬クリリン自身
            picture = Cache.picture(set_battle_character_name(6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            rect = Rect.new(0, 8 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
        when 30 # 繰気弾

            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") # ダメージ表示用
            end

            rect = Rect.new(256, 0, 128, 128)
            if @attackDir == 0
                @back_window.contents.blt(-450 + @back_anime_frame * 16, -290 + @back_anime_frame * 8, picture, rect)
            else
                @back_window.contents.blt(640 - @effect_anime_frame * RAY_SPEED, 120, picture, rect)
            end
        when 31 # 操気円斬
            picture = Cache.picture(set_battle_character_name(6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
        when 32 # 操気円斬
            picture = Cache.picture(set_battle_character_name(6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            rect = Rect.new(0, 5 * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
        when 33 # 操気円斬
            picture = Cache.picture(set_battle_character_name(6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            rect = Rect.new(0, 6 * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
        when 34 # 操気円斬
            picture = Cache.picture(set_battle_character_name(6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            rect = Rect.new(0, 7 * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
        when 35 # 操気円斬
            picture = Cache.picture(set_battle_character_name(6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            rect = Rect.new(0, 1 * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
        when 36 # ダブルどどんぱ_キャラ現れる

            if $partyc[@chanum.to_i] == 8
                picture = Cache.picture(set_battle_character_name(9, 0))
                picture = Cache.picture(set_battle_character_name(9, 1)) if @back_anime_frame >= 31
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ") if @back_anime_frame >= 31
            # picture = Cache.picture($btl_top_file_name + "戦闘_チャオズ") #ダメージ表示用
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ") if @back_anime_frame >= 31
            else

                picture = Cache.picture(set_battle_character_name(8, 0)) # ダメージ表示用
                picture = Cache.picture(set_battle_character_name(8, 1)) if @back_anime_frame >= 31
                # picture = Cache.picture($btl_top_file_name + "戦闘_テンシンハン") #ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") if @back_anime_frame >= 31

            end
            # attack_se = "Z3 打撃"
            case @back_anime_frame

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
            if $partyc[@chanum.to_i] == 8
                @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
            else
                @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
            end
        when 37 # ダブルどどんぱ_ゆびたて
            rect = Rect.new(0, 2 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(9, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)

            rect = Rect.new(0, 7 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(8, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
            @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
        when 38 # ダブルどどんぱ_ゆびまえ
            rect = Rect.new(0, 3 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(9, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)

            rect = Rect.new(0, 8 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(8, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
            @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
        when 39 # ダブルどどんぱ(Z2)_キャラ現れる
            if $partyc[@chanum.to_i] == 8
                picture = Cache.picture(set_battle_character_name(9, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
            elsif $partyc[@chanum.to_i] == 9
                picture = Cache.picture(set_battle_character_name(8, 1))
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
            end
            rect = Rect.new(0, 0 * 96, 96, 96)
            ushirox = 0
            idouryou = 8
            if $partyc[@chanum.to_i] == 8
                @back_window.contents.blt(STANDARD_CHAX + @back_anime_frame * idouryou + 30, STANDARD_CHAY - 50, picture,
                                          rect)
            # p STANDARD_CHAX+@effect_anime_frame*idouryou,TEC_CENTER_CHAX if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7
            else
                @back_window.contents.blt(STANDARD_CHAX + @back_anime_frame * idouryou + 30, STANDARD_CHAY + 50, picture,
                                          rect)
            end
        when 40 # ダブルどどんぱ(Z2)_キャラ現れる(放置)
            rect = Rect.new(0, 0 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(8, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
            picture = Cache.picture(set_battle_character_name(9, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY - 50, picture, rect)
        when 41 # ダブルどどんぱ(Z2)_放つ
            rect = Rect.new(0, 5 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(8, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
            rect = Rect.new(0, 1 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(9, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY - 50, picture, rect)
        when 42 # 超能力きこうほう
            rect = Rect.new(0, 1 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(9, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)

            rect = Rect.new(0, 2 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(8, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
            @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
        when 43 # 気を溜める(超能力きこうほう)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_超能力") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 160, 128, 160)
            @back_window.contents.blt(back_x, back_y, picture, rect)

            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 44 # Z2超能力きこうほう
            rect = Rect.new(0, 0 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(8, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
            if $btl_progress == 2
                rect = Rect.new(0, 6 * 96, 96, 96)
            else
                rect = Rect.new(0, 2 * 96, 96, 96)
            end
            picture = Cache.picture(set_battle_character_name(9, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY - 50, picture, rect)
        when 45 # Z2超能力きこうほう
            rect = Rect.new(0, 2 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(8, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
            if $btl_progress == 2
                rect = Rect.new(0, 6 * 96, 96, 96)
            else
                rect = Rect.new(0, 2 * 96, 96, 96)
            end
            picture = Cache.picture(set_battle_character_name(9, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY - 50, picture, rect)
        when 46 # 師弟の絆_キャラ現れる

            if $partyc[@chanum.to_i] == 4
                picture = Cache.picture(set_battle_character_name(5, 0))
                # picture = Cache.picture(set_battle_character_name 5,1)
                # if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
                #  picture = Cache.picture(set_battle_character_name 18,0)
                #  picture = Cache.picture(set_battle_character_name 18,1)
                # end
                picture = Cache.picture(set_battle_character_name(5, 1)) if @back_anime_frame >= 31
            # if ($super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true) && @back_anime_frame >= 31
            #  picture = Cache.picture(set_battle_character_name 18,1)
            # end
            # picture = Cache.picture($btl_top_file_name + "戦闘_ゴハン") #ダメージ表示用
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン") if @back_anime_frame >= 31
            else
                picture = Cache.picture(set_battle_character_name(4, 0))
                picture = Cache.picture(set_battle_character_name(4, 1)) if @back_anime_frame >= 31
                # picture = Cache.picture($btl_top_file_name + "戦闘_ピッコロ") #ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") if @back_anime_frame >= 31

            end
            # attack_se = "Z3 打撃"
            case @back_anime_frame

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
            if $partyc[@chanum.to_i] == 4
                @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
            else
                @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
            end
        when 47 # 師弟の絆_キャラ現れる(ゴハンのみ表示
            picture = Cache.picture(set_battle_character_name(5, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)

        when 48 # 師弟の絆_高速移動
            if @back_anime_frame % 4 == 0
                picture = Cache.picture("戦闘アニメ") # ダメージ表示用
                rect = Rect.new(0, 48, 64, 64)
                @back_window.contents.blt(back_x, back_y, picture, rect)
            end
        when 49 # 師弟の絆_技溜

            rect = Rect.new(0, 2 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(5, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)

            rect = Rect.new(0, 5 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(4, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
            @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)

        when 50 # 師弟の絆_技発動

            rect = Rect.new(0, 3 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(5, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)

            rect = Rect.new(0, 6 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(4, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
            @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)

        when 51 # 師弟の絆_気を溜める
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(緑)") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 222, 160, 222)
            @back_window.contents.blt(234 - 90, 70, picture, rect)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 160, 160, 160)
            @back_window.contents.blt(234 + 96, 112, picture, rect)

            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 52 # Z2師弟の絆_気を溜める
            rect = Rect.new(0, 2 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(4, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
            rect = Rect.new(0, 2 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(5, 1))
            if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
                picture = Cache.picture(set_battle_character_name(18, 1))
            end
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY - 50, picture, rect)
        when 53 # Z2師弟の絆_発動
            rect = Rect.new(0, 3 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(4, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY + 50, picture, rect)
            rect = Rect.new(0, 3 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(5, 1))
            if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
                picture = Cache.picture(set_battle_character_name(18, 1))
            end
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY - 50, picture, rect)
        when 54 # 狼鶴相打陣_ヤムチャ表示
            picture = Cache.picture(set_battle_character_name(7, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
            rect = Rect.new(0, 0 * 96, 96, 96)
            @back_window.contents.blt(CENTER_CHAX, STANDARD_CHAY, picture, rect)
        when 55 # 師弟の絆_キャラ現れる

            if $partyc[@chanum.to_i] == 4
                picture = Cache.picture(set_battle_character_name(6, 0))
                picture = Cache.picture(set_battle_character_name(6, 1)) if @back_anime_frame >= 31
            # picture = Cache.picture($btl_top_file_name + "戦闘_ゴハン") #ダメージ表示用
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン") if @back_anime_frame >= 31
            else
                picture = Cache.picture(set_battle_character_name(4, 0))
                picture = Cache.picture(set_battle_character_name(4, 1)) if @back_anime_frame >= 31
                # picture = Cache.picture($btl_top_file_name + "戦闘_ピッコロ") #ダメージ表示用
                # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") if @back_anime_frame >= 31

            end
            # attack_se = "Z3 打撃"
            case @back_anime_frame

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
            if $partyc[@chanum.to_i] == 4
                @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
            else
                @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
            end
        when 56 # 行くぞ！クリリン_技溜

            rect = Rect.new(0, 1 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)

            rect = Rect.new(0, 5 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(4, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
            @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
        when 57 # 行くぞ！クリリン_気を溜める
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(緑)") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 222, 160, 222)
            @back_window.contents.blt(234 - 90, 70, picture, rect)

            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3") #ダメージ表示用

            # rect = Rect.new(0,@back_anime_type*160,160,160)
            # @back_window.contents.blt(234+96,112,picture,rect)

            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 58 # 師弟の絆_技発動

            rect = Rect.new(0, 2 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
            @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)

            rect = Rect.new(0, 6 * 96, 96, 96)
            picture = Cache.picture(set_battle_character_name(4, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
            @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
        when 59 # ダブルアイビーム_キャラ現れる(ピッコロ、天津飯
            if $partyc[@chanum.to_i] == 8
                picture = Cache.picture(set_battle_character_name(4, 0))
                picture = Cache.picture(set_battle_character_name(4, 1)) if @back_anime_frame >= 31
            else
                picture = Cache.picture(set_battle_character_name(8, 0))
                picture = Cache.picture(set_battle_character_name(8, 1)) if @back_anime_frame >= 31

            end

            case @back_anime_frame

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
            if $partyc[@chanum.to_i] == 4
                @back_window.contents.blt(CENTER_CHAX + 120, STANDARD_CHAY, picture, rect)
            else
                @back_window.contents.blt(CENTER_CHAX - 66, STANDARD_CHAY, picture, rect)
            end

        ##########################################################
        # Z2
        ##########################################################

        when 101 # 気を溜める(大)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3(赤)") # ダメージ表示用
            end

            rect = Rect.new(@back_anime_type * 184, 0, 184, 240)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 102 # 気を溜める(特大)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める4") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める4(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める4(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める4(赤)") # ダメージ表示用
            end
            rect = Rect.new(@back_anime_type * 224, 0, 224, 288)
            @back_window.contents.blt(back_x, back_y - 36, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 103 # 気を溜める(元気弾)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める5") # ダメージ表示用

            rect = Rect.new(@back_anime_type * 236, 0, 236, 254)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 8 && @back_anime_type != 11
                @back_anime_type += 1
                @back_anime_frame = 0
                # elsif @back_anime_frame >= 6
                # @back_anime_type = 0
                # @back_anime_frame = 0
            end
        when 104 # 気を溜める(超元気弾)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める6") # ダメージ表示用

            rect = Rect.new(@back_anime_type * 512, 0, 256, 320)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 8 && @back_anime_type != 11
                @back_anime_type += 1
                @back_anime_frame = 0
                # elsif @back_anime_frame >= 6
                # @back_anime_type = 0
                # @back_anime_frame = 0
            end
        when 105 # 気を溜める(中)
            if @ray_color == 0
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2(青)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2(赤)") # ダメージ表示用
            end

            rect = Rect.new(@back_anime_type * 152, 0, 152, 192)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 106 # 背景スーパーカメハメ波
            if @attackDir == 0 && mirror_pattern == 0
                picture = Cache.picture("Z3_必殺技_超カメハメ波(バック上)") # ダメージ表示用
                rect = Rect.new(0, 128 * @back_anime_type, 384, 128)
                @back_window.contents.blt(0, 0, picture, rect)
                picture = Cache.picture("Z3_必殺技_超カメハメ波(バック下)") # ダメージ表示用
                rect = Rect.new(0, 64 * @back_anime_type, 192, 64)
                @back_window.contents.blt(0, 292, picture, rect)
            else
                picture = Cache.picture("Z3_必殺技_超カメハメ波(バック上)_反転") # ダメージ表示用
                rect = Rect.new(0, 128 * @back_anime_type, 384, 128)
                @back_window.contents.blt(640 - 384, 0, picture, rect)
                picture = Cache.picture("Z3_必殺技_超カメハメ波(バック下)_反転") # ダメージ表示用
                rect = Rect.new(0, 64 * @back_anime_type, 192, 64)
                @back_window.contents.blt(640 - 192, 292, picture, rect)
            end
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 107 # 気を溜める(パープルコメットクラッシュ)

            if @back_anime_type == 0
                if @ray_color == 3
                    picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
                elsif @ray_color == 4
                    picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(赤)") # ダメージ表示用
                end
                rect = Rect.new(5 * 128, 0, 128, 128)
                @back_window.contents.blt(back_x, back_y, picture, rect)
            else
                if @ray_color == 3
                    picture = Cache.picture("Z2_戦闘_必殺技_敵_バータ") # ダメージ表示用
                else
                    picture = Cache.picture("Z2_戦闘_必殺技_敵_ジース") # ダメージ表示用
                end
                rect = Rect.new(0, 0 + (96 * 2), 96, 96)
                @back_window.contents.blt(@enex, STANDARD_ENEY, picture, rect)
            end

            if @back_anime_frame >= 2 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 2
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 108 # 気が交わる(パープルコメットクラッシュ)
            picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            rect = Rect.new(5 * 128, 0, 128, 128)
            @back_window.contents.blt(STANDARD_CHAX + @back_anime_frame * 10, STANDARD_ENEY, picture, rect)

            picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(赤)") # ダメージ表示用
            @back_window.contents.blt(STANDARD_ENEX - @back_anime_frame * 10 + 60, STANDARD_ENEY, picture, rect)
        when 109 # 気が交わる青赤(パープルコメットクラッシュ)
            if @back_anime_type == 0
                picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(青)") # ダメージ表示用
            else
                picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(赤)") # ダメージ表示用
            end
            rect = Rect.new(5 * 128, 0, 128, 128)

            @back_window.contents.blt(CENTER_ENEX, STANDARD_ENEY, picture, rect)
            if @back_anime_frame >= 2 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 2
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 110 # 合体攻撃発動者
            picture = Cache.picture(set_battle_character_name(3, 1))
            picture = Cache.picture(set_battle_character_name(14, 1)) if $super_saiyazin_flag[1] == true
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用
            rect = Rect.new(0, @scombo_cha1_anime_type * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX, STANDARD_CHAY, picture, rect)
        when 111 # ピッコロ後ろの現れる
            picture = Cache.picture(set_battle_character_name(4, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") #ダメージ表示用
            rect = Rect.new(0, @scombo_cha2_anime_type * 96, 96, 96)
            @back_window.contents.blt(STANDARD_CHAX + @scombo_cha_anime_frame * 8, STANDARD_CHAY, picture, rect)
        when 112 # 悟空前に現れる
            picture = Cache.picture(set_battle_character_name(3, 1))
            picture = Cache.picture(set_battle_character_name(14, 1)) if $super_saiyazin_flag[1] == true
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用
            rect = Rect.new(0, @scombo_cha2_anime_type * 96, 96, 96)
            @back_window.contents.blt(STANDARD_CHAX + @scombo_cha_anime_frame * 16, STANDARD_CHAY, picture, rect)
        when 113 # 合体攻撃発動者
            picture = Cache.picture(set_battle_character_name($partyc[@chanum.to_i], 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha1_anime_type * 96, 96, 96)
            @back_window.contents.blt(TEC_CENTER_CHAX - @scombo_cha_anime_frame * 8, STANDARD_CHAY, picture, rect)
        when 114 # ヤムチャ前に現れる
            picture = Cache.picture(set_battle_character_name(7, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ") #ダメージ表示用
            rect = Rect.new(0, @scombo_cha2_anime_type * 96, 96, 96)
            @back_window.contents.blt(STANDARD_CHAX + @scombo_cha_anime_frame * 16, STANDARD_CHAY, picture, rect)
        when 115 # スパーキング用1人目
            picture = Cache.picture(set_battle_character_name(@scombo_cha1, 0))
            # picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha1].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha1_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 116 # スパーキング用1人目必殺技
            picture = Cache.picture(set_battle_character_name(@scombo_cha1, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha1].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha1_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 117 # スパーキング用2人目
            picture = Cache.picture(set_battle_character_name(@scombo_cha2, 0))
            # picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha2].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha2_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 118 # スパーキング用2人目必殺技
            picture = Cache.picture(set_battle_character_name(@scombo_cha2, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha2_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 119 # スパーキング用3人目
            picture = Cache.picture(set_battle_character_name(@scombo_cha3, 0))
            # picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha3_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 120 # スパーキング用3人目必殺技
            picture = Cache.picture(set_battle_character_name(@scombo_cha3, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha3_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 121 # スパーキング用4人目
            picture = Cache.picture(set_battle_character_name(@scombo_cha4, 0))
            # picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha4_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 122 # スパーキング用4人目必殺技
            picture = Cache.picture(set_battle_character_name(@scombo_cha4, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha4_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 123 # スパーキング用5人目
            picture = Cache.picture(set_battle_character_name(@scombo_cha5, 0))
            # picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha5_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 124 # スパーキング用5人目必殺技
            picture = Cache.picture(set_battle_character_name(@scombo_cha5, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha5_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 125 # スパーキング用6人目
            picture = Cache.picture(set_battle_character_name(@scombo_cha6, 0))
            # picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha6_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 126 # スパーキング用6人目必殺技
            picture = Cache.picture(set_battle_character_name(@scombo_cha6, 1))
            # picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
            rect = Rect.new(0, @scombo_cha6_anime_type * 96, 96, 96)
            @back_window.contents.blt(back_x, back_y, picture, rect)
        when 127 # ヤムチャ前に現れる
            picture = Cache.picture(set_battle_character_name(7, 1))
            rect = Rect.new(0, @scombo_cha2_anime_type * 96, 96, 96)
            @back_window.contents.blt(STANDARD_CHAX + @scombo_cha_anime_frame * 16, STANDARD_CHAY, picture, rect)
        when 128 # 発動キャラ前に現れる(汎用)
            picture = Cache.picture(set_battle_character_name(@scombo_cha1, 1))
            rect = Rect.new(0, @scombo_cha1_anime_type * 96, 96, 96)
            @back_window.contents.blt(STANDARD_CHAX + @scombo_cha_anime_frame * 16, STANDARD_CHAY, picture, rect)
        when 129 # 気を溜める(超元気弾)溜め続ける

            picture = Cache.picture("Z2_戦闘_必殺技_気を溜める(超元気玉全開)") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 320, 816, 320)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 2
                @back_anime_type += 1
                @back_anime_frame = 0
                if @back_anime_type == 3
                    @back_anime_type = 0
                end
                # elsif @back_anime_frame >= 6
                # @back_anime_type = 0
                # @back_anime_frame = 0
            end
        ##########################################################
        # Z3
        ##########################################################
        when 201 # 気を溜める(Z3)

            if @ray_color == 1
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(緑)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(青)") # ダメージ表示用
            else
                picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める") # ダメージ表示用
            end

            rect = Rect.new(@back_anime_type * 136, 0, 136, 142)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 16 && @back_anime_type != 1
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 16
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 202 # 気を溜める(ZG)

            picture = Cache.picture("ZG_戦闘_必殺技_気を溜める") # ダメージ表示用

            rect = Rect.new(@back_anime_type * 156, 0, 156, 144)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 8 && @back_anime_type != 1
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 8
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 211 # 17号バリア
            picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾(青)")
            rect = Rect.new(5 * 128, 0, 128, 128)

            if @back_anime_frame <= 2
                @back_window.contents.blt(CENTER_ENEX, STANDARD_ENEY, picture, rect)
            elsif @back_anime_frame >= 4
                @back_anime_frame = 0
            end
        when 212 # 超元気玉吸収
            picture = Cache.picture("Z3_戦闘_必殺技_超元気玉_弾")
            rect = Rect.new(@back_anime_type * 126, 0, 126, 126)
            @back_window.contents.blt(back_x, back_y, picture, rect)

            if @back_anime_frame >= 8 && @back_anime_type != 1
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 8
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 213 # 気を溜める(#超元気玉吸収)

            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める9") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 378, 640, 378)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 214 # ロボット兵手先発動
            scllorspd = 12
            picture = Cache.picture("Z3_戦闘_必殺技_ロボット兵腕1") # ダメージ表示用
            rect = Rect.new(0, 0, @back_anime_frame * scllorspd, 24)
            @back_window.contents.blt(back_x, back_y, picture, rect)

        when 215 # ロボット兵手先発動前に移動
            scllorspd = 12
            picture = Cache.picture("Z3_戦闘_必殺技_ロボット兵腕1") # ダメージ表示用
            rect = Rect.new(0, 0, 1280, 24)
            @back_window.contents.blt(back_x - @back_anime_frame * scllorspd, back_y, picture, rect)

        when 216 # アンギラ手が伸びる
            picture = Cache.picture("Z2_戦闘_必殺技_アンギラ手が伸びる") # ダメージ表示用
            rect = Rect.new(0, 0, 26 + @back_anime_frame * RAY_SPEED, 24)
            @back_window.contents.blt(back_x - @back_anime_frame * RAY_SPEED, back_y, picture, rect)
        when 217 # アンギラ手を縮める
            picture = Cache.picture("Z2_戦闘_必殺技_アンギラ手が伸びる") # ダメージ表示用
            rect = Rect.new(0, 0, 640 - @back_anime_frame * RAY_SPEED, 24)
            @back_window.contents.blt(back_x + @back_anime_frame * RAY_SPEED, back_y, picture, rect)

        when 218 # 気を溜める 11
            if @ray_color == 0
                picture = Cache.picture("Z3_戦闘_必殺技_気を溜める11(赤)") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_戦闘_必殺技_気を溜める11(赤)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture("Z3_戦闘_必殺技_気を溜める11(赤)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture("Z3_戦闘_必殺技_気を溜める11(赤)") # ダメージ表示用
            end

            rect = Rect.new(@back_anime_type * 156, 0, 156, 144)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 8 && @back_anime_type != 1
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 8
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 219 # 気を溜めるブウ超爆発波
            picture = Cache.picture("Z3_必殺技_超爆発波_気を溜める")
            rect = Rect.new(0, @back_anime_type * 300, 300, 300)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 8 && @back_anime_type != 1
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 8
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 220 # 気を溜めるブウ超爆発波必殺技発動時縦

            picture = Cache.picture("Z3_戦闘_必殺技_背景_ブウ_超爆発波") # ダメージ表示用

            rect = Rect.new(0, @back_anime_type * 356, 640, 356)
            @back_window.contents.blt(0, 0, picture, rect)
            if @back_anime_frame >= 4 && @back_anime_type != 2
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 4
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        when 221 # 気を溜める 12
            if @ray_color == 0
                picture = Cache.picture("Z3_戦闘_必殺技_気を溜める12(赤)") # ダメージ表示用
            elsif @ray_color == 1
                picture = Cache.picture("Z3_戦闘_必殺技_気を溜める12(赤)") # ダメージ表示用
            elsif @ray_color == 3
                picture = Cache.picture("Z3_戦闘_必殺技_気を溜める12(赤)") # ダメージ表示用
            elsif @ray_color == 4
                picture = Cache.picture("Z3_戦闘_必殺技_気を溜める12(赤)") # ダメージ表示用
            end

            rect = Rect.new(@back_anime_type * 300, 0, 300, 300)
            @back_window.contents.blt(back_x, back_y, picture, rect)
            if @back_anime_frame >= 8 && @back_anime_type != 1
                @back_anime_type += 1
                @back_anime_frame = 0
            elsif @back_anime_frame >= 8
                @back_anime_type = 0
                @back_anime_frame = 0
            end
        end
        @back_anime_frame += 1
    end

    #--------------------------------------------------------------------------
    # ● ダメージ表示
    #--------------------------------------------------------------------------
    def output_battle_damage
        tyousei_x = 16
        tyousei_y = 10
        picturez = Cache.picture("数字英語") # ダメージ表示用
        for y in 1..@battledamage.to_s.size # HP
            rect = Rect.new(@battledamage.to_s[-y, 1].to_i * 16, 32, 16, 16)
            if @attackDir == 0 # 味方
                if $game_variables[29] == 0 || $game_variables[29] == 2 # 下
                    @status_window.contents.blt(@@enestex + tyousei_x + 232 - (y - 1) * 16, 48 + tyousei_y, picturez,
                                                rect)
                end

                if $game_variables[29] == 1 || $game_variables[29] == 2 # 上
                    if @damage_center == false
                        @back_window.contents.blt(CENTER_ENEX + 72 - (y - 1) * 16, 100, picturez, rect)
                    else
                        @back_window.contents.blt((CENTER_ENEX + 72 - 50) - (y - 1) * 16, 100, picturez, rect)
                    end
                end
            else
                if $game_variables[29] == 0 || $game_variables[29] == 2 # 下
                    @status_window.contents.blt(@@chastex + tyousei_x + 48 - (y - 1) * 16, 48 + tyousei_y, picturez,
                                                rect)
                end

                if $game_variables[29] == 1 || $game_variables[29] == 2 # 上
                    if @damage_center == false
                        @back_window.contents.blt(CENTER_CHAX + 40 - (y - 1) * 16, 100, picturez, rect)
                    else
                        @back_window.contents.blt((CENTER_CHAX + 40 - 50) - (y - 1) * 16, 100, picturez, rect)
                    end
                end

                # 吸収
                if $data_skills[@ene_set_action - 10].element_set.index(15) != nil # 下
                    rect = Rect.new(@battledamage.to_s[-y, 1].to_i * 16, 64, 16, 16)
                    @status_window.contents.blt(@@enestex + tyousei_x + 232 - (y - 1) * 16, 48 + tyousei_y, picturez,
                                                rect)
                end
            end
        end
    end

    #--------------------------------------------------------------------------
    # ● 戦闘アニメ表示(キャラ)
    # 引数n[キャラチップの種類 0:通常攻撃 1:必殺技],y[y軸も反転 0:する 1:しない]
    #--------------------------------------------------------------------------
    def output_battle_anime n = 0, y = 0, cha_chg_no = 0
        top_name = set_ene_str_no(@enedatenum)

        if n == 0
            if cha_chg_no == 0
                # chpicturea = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name)
                chpicturea = Cache.picture(set_battle_character_name($partyc[@chanum.to_i], n))
            else
                # chpicturea = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[cha_chg_no].name)
                chpicturea = Cache.picture(set_battle_character_name(cha_chg_no, n))
            end
            enpicturea = Cache.picture(top_name + "戦闘_敵_" + $data_enemies[@enedatenum].name)
        end
        if n == 1 && @attackDir == 0 # 味方が必殺
            if cha_chg_no == 0
                # chpicturea = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name)
                chpicturea = Cache.picture(set_battle_character_name($partyc[@chanum.to_i], n))
            else
                # chpicturea = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[cha_chg_no].name)
                chpicturea = Cache.picture(set_battle_character_name(cha_chg_no, n))
            end
            enpicturea = Cache.picture(top_name + "戦闘_敵_" + $data_enemies[@enedatenum].name)
        elsif n == 1 && @attackDir == 1 # 敵が必殺
            # chpicturea = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name)
            chpicturea = Cache.picture(set_battle_character_name($partyc[@chanum.to_i]))
            enpicturea = Cache.picture(top_name + "戦闘_必殺技_敵_" + $data_enemies[@enedatenum].name)
        end

        # 結果反映
        if @attackDir == 0
            @gx = -@gx
            if y != 0
                @gy = -@gy
            end
            @chax += @ax
            @chay += @ay
            @enex += @gx
            @eney += @gy
            @backx += @bx
            @backy += @by

            # 敵巨大キャラ
            if $data_enemies[@enedatenum].element_ranks[23] != 1
                @back_window.contents.blt(@enex, @eney, enpicturea, @enerect)
            else
                @back_window.contents.blt(@enex, @eney - 48, enpicturea, @enerect)
            end

            # 味方巨大キャラ
            if $cha_bigsize_on[@chanum.to_i] != true
                @back_window.contents.blt(@chax, @chay, chpicturea, @charect)
            else
                @back_window.contents.blt(@chax - 96, @chay - 48, chpicturea, @charect)
            end

        else
            @ax = -@ax
            if y != 0
                @ay = -@ay
            end
            @bx = -@bx
            @chax += @gx
            @chay += @gy
            @enex += @ax
            @eney += @ay
            @backx += @bx
            @backy += @by

            # 味方巨大キャラ
            if $cha_bigsize_on[@chanum.to_i] != true
                @back_window.contents.blt(@chax, @chay, chpicturea, @charect)
            else
                @back_window.contents.blt(@chax - 96, @chay - 48, chpicturea, @charect)
            end

            # 敵巨大キャラ
            if $data_enemies[@enedatenum].element_ranks[23] != 1
                @back_window.contents.blt(@enex, @eney, enpicturea, @enerect)
            else
                @back_window.contents.blt(@enex - 48, @eney - 48, enpicturea, @enerect)
            end
        end
    end

    #--------------------------------------------------------------------------
    # ● 戦闘アニメパターンで使用する変数の初期化
    #--------------------------------------------------------------------------
    def anime_pattern_init
        output_battle_anime(@output_anime_type, @output_anime_type_y, @btl_ani_cha_chg_no)
        Audio.se_stop
        @output_anime_type = 0
        @output_anime_type_y = 0
        @back_anime_type = 0
        @back_anime_frame = 0
        @ray_anime_type = 0
        @ray_anime_frame = 0
        @effect_anime_pattern = 0
        @effect_anime_frame = 0
        @effect_anime_type = 0
        @effect_anime_mirror = 255
        @ax = 0
        @ay = 0
        @gx = 0
        @gy = 0
        @bx = 0
        @by = 0
        @anime_frame_format = true
    end

    #--------------------------------------------------------------------------
    # ● 敵の攻撃セット
    #--------------------------------------------------------------------------
    def ene_action_set
        # 必殺をもっていないケースを想定していないIF分のため変更
        # if $enecardi[@enenum] == 0 || $enecardi[@enenum] == $data_enemies[@enedatenum].hit-1

        if ($enecardi[@enenum] == 0 || $enecardi[@enenum] == $data_enemies[@enedatenum].hit - 1) && $data_enemies[@enedatenum].actions.size != 0
            if $data_enemies[@enedatenum].actions.size != 0
                # 必殺技
                # @ene_set_action = $data_enemies[@enedatenum].actions[rand($data_enemies[@enedatenum].actions.size)].skill_id + 10 #敵必殺
                begin
                    ene_action_ok = false
                    tmp_ene_set_action = rand($data_enemies[@enedatenum].actions.size)

                    # 通常技
                    if $data_enemies[@enedatenum].actions[tmp_ene_set_action].condition_type == 0
                        ene_action_ok = true
                        if $data_skills[$data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id].element_set[0] == 4
                            ene_action_ok = chk_scombo_flag($data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id)
                        end
                    elsif $data_enemies[@enedatenum].actions[tmp_ene_set_action].condition_type == 2
                        # p $data_enemies[@enedatenum].actions[tmp_ene_set_action].condition_param2
                        # p ($enehp[@enenum]*100/ $data_enemies[@enedatenum].maxhp),$data_enemies[@enedatenum].actions[tmp_ene_set_action].condition_param2.to_i
                        if ($enehp[@enenum] * 100 / $data_enemies[@enedatenum].maxhp) <= $data_enemies[@enedatenum].actions[tmp_ene_set_action].condition_param2.to_i
                            ene_action_ok = true
                            # 合体攻撃
                            # 合体攻撃属性を持っているかチェック
                            # p $data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id,$data_skills[$data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id].element_set

                            if $data_skills[$data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id].element_set[0] == 4
                                ene_action_ok = chk_scombo_flag($data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id)
                            end
                        end
                    end

                    # 1ターンに1回しか使えない技を選択していないか
                    if @one_turntec.index($data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id) != nil
                        ene_action_ok = false
                    end
                end until ene_action_ok == true

                if $data_skills[$data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id].element_set.index(24) != nil
                    @one_turntec << $data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id
                end
                # p @one_turntec
                if $game_variables[96] == 0
                    @ene_set_action = $data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id + 10 # 敵必殺
                else
                    @ene_set_action = @tmp_ene_set_action
                end
            else
                @ene_set_action = 1
            end
        else
            # elsif $enecardi[@enenum] != 0

            @ene_set_action = 1 # 敵通常攻撃
        end
    end

    #--------------------------------------------------------------------------
    # ● 合体攻撃を初めて使用したかチェック
    #--------------------------------------------------------------------------
    def chk_new_get_scombo # action_no
        if $game_switches[@btl_ani_scombo_get_flag] == false
            $game_switches[@btl_ani_scombo_new_flag] = true
            $game_switches[30] = true
        end
    end

    #--------------------------------------------------------------------------
    # ● 合体攻撃対象の技を探し使用可能かチェックする
    # 　set_action:確認対象必殺技No
    #  chknewonlyflag:未取得のスキルのみチェックするフラグ
    #--------------------------------------------------------------------------
    def chk_scombo_flag_num set_action, chknewonlyflag
        # $cha_set_action[@chanum] - 10
        chk_result = false

        tmp_scombo_renban = Marshal.load(Marshal.dump($scombo_renban))
        tmp_scombo_count = Marshal.load(Marshal.dump($scombo_count))
        tmp_scombo_cha_count = Marshal.load(Marshal.dump($scombo_cha_count))
        tmp_scombo_get_flag = Marshal.load(Marshal.dump($scombo_get_flag))
        tmp_scombo_new_flag = Marshal.load(Marshal.dump($scombo_new_flag))
        tmp_scombo_no = Marshal.load(Marshal.dump($scombo_no))
        tmp_scombo_cha = Marshal.load(Marshal.dump($scombo_cha))
        tmp_scombo_flag_tec = Marshal.load(Marshal.dump($scombo_flag_tec))
        tmp_scombo_skill_level_num = Marshal.load(Marshal.dump($scombo_skill_level_num))
        tmp_scombo_card_attack_num = Marshal.load(Marshal.dump($scombo_card_attack_num))
        tmp_scombo_card_gard_num = Marshal.load(Marshal.dump($scombo_card_gard_num))
        tmp_scombo_chk_flag_oozaru_put = Marshal.load(Marshal.dump($scombo_chk_flag_oozaru_put))

        # Sコンボの並びを自分で変えるときだけ処理する
        if $game_variables[358] == 1
            # 処理用に再格納
            ttmp_scombo_renban = Marshal.load(Marshal.dump($scombo_renban))
            ttmp_scombo_count = Marshal.load(Marshal.dump($scombo_count))
            ttmp_scombo_cha_count = Marshal.load(Marshal.dump($scombo_cha_count))
            ttmp_scombo_get_flag = Marshal.load(Marshal.dump($scombo_get_flag))
            ttmp_scombo_new_flag = Marshal.load(Marshal.dump($scombo_new_flag))
            ttmp_scombo_no = Marshal.load(Marshal.dump($scombo_no))
            ttmp_scombo_cha = Marshal.load(Marshal.dump($scombo_cha))
            ttmp_scombo_flag_tec = Marshal.load(Marshal.dump($scombo_flag_tec))
            ttmp_scombo_skill_level_num = Marshal.load(Marshal.dump($scombo_skill_level_num))
            ttmp_scombo_card_attack_num = Marshal.load(Marshal.dump($scombo_card_attack_num))
            ttmp_scombo_card_gard_num = Marshal.load(Marshal.dump($scombo_card_gard_num))
            ttmp_scombo_chk_flag_oozaru_put = Marshal.load(Marshal.dump($scombo_chk_flag_oozaru_put))

            ttmp_scombo_chk_flag_ssaiya = Marshal.load(Marshal.dump($scombo_chk_flag_ssaiya))
            ttmp_scombo_chk_flag_ssaiya_cha = Marshal.load(Marshal.dump($scombo_chk_flag_ssaiya_cha))
            ttmp_scombo_chk_flag_ssaiya_put = Marshal.load(Marshal.dump($scombo_chk_flag_ssaiya_put))

            # Sコンボが一つもないかどうかで処理を変える
            if $player_scombo_priority[$partyc[@chanum]] == nil
                scomsize = 0
            else
                scomsize = $player_scombo_priority[$partyc[@chanum]].size
            end

            # 配列系はサイズを縮める
            tmp_scombo_count = scomsize - 1
            tmp_scombo_renban = tmp_scombo_renban[0..scomsize - 1]
            tmp_scombo_cha_count = tmp_scombo_cha_count[0..scomsize - 1]
            tmp_scombo_get_flag = tmp_scombo_get_flag[0..scomsize - 1]
            tmp_scombo_new_flag = tmp_scombo_new_flag[0..scomsize - 1]
            tmp_scombo_no = tmp_scombo_no[0..scomsize - 1]
            tmp_scombo_cha = tmp_scombo_cha[0..scomsize - 1]
            tmp_scombo_flag_tec = tmp_scombo_flag_tec[0..scomsize - 1]
            tmp_scombo_skill_level_num = tmp_scombo_skill_level_num[0..scomsize - 1]
            tmp_scombo_card_attack_num = tmp_scombo_card_attack_num[0..scomsize - 1]
            tmp_scombo_card_gard_num = tmp_scombo_card_gard_num[0..scomsize - 1]
            tmp_scombo_chk_flag_oozaru_put = tmp_scombo_chk_flag_oozaru_put[0..scomsize - 1]

            # 初期化
            for x in 0..scomsize - 1
                tmp_scombo_renban[x] = ttmp_scombo_renban[$player_scombo_priority[$partyc[@chanum]][x]]
                tmp_scombo_cha_count[x] = ttmp_scombo_cha_count[$player_scombo_priority[$partyc[@chanum]][x]]
                tmp_scombo_get_flag[x] = ttmp_scombo_get_flag[$player_scombo_priority[$partyc[@chanum]][x]]
                tmp_scombo_new_flag[x] = ttmp_scombo_new_flag[$player_scombo_priority[$partyc[@chanum]][x]]

                tmp_scombo_no[x] = ttmp_scombo_no[$player_scombo_priority[$partyc[@chanum]][x]]
                tmp_scombo_cha[x] = ttmp_scombo_cha[$player_scombo_priority[$partyc[@chanum]][x]]
                tmp_scombo_flag_tec[x] = ttmp_scombo_flag_tec[$player_scombo_priority[$partyc[@chanum]][x]]
                tmp_scombo_skill_level_num[x] =
                    ttmp_scombo_skill_level_num[$player_scombo_priority[$partyc[@chanum]][x]]
                tmp_scombo_card_attack_num[x] =
                    ttmp_scombo_card_attack_num[$player_scombo_priority[$partyc[@chanum]][x]]
                tmp_scombo_card_gard_num[x] = ttmp_scombo_card_gard_num[$player_scombo_priority[$partyc[@chanum]][x]]
                tmp_scombo_chk_flag_oozaru_put[x] =
                    ttmp_scombo_chk_flag_oozaru_put[$player_scombo_priority[$partyc[@chanum]][x]]
            end

            # p tmp_scombo_no,$player_scombo_priority[$partyc[@chanum]]
        end

        # Sコンボ配列内に対象技があるかチェック
        # なければループ抜ける
        # あれば
        x = 0
        loop do
            for x in 0..tmp_scombo_count
                chk_loop_result = tmp_scombo_flag_tec[x].index(set_action)
                # p "最初のループ",chk_loop_result,x,tmp_scombo_flag_tec[x]
                if chk_loop_result != nil || x >= tmp_scombo_count
                    break
                end

                x += 1 if chk_loop_result == nil
            end

            # p "最初のループ抜けた",chk_loop_result,x,tmp_scombo_flag_tec[x]
            if chk_loop_result != nil
                # スパーキングコンボチェック用
                @btl_ani_scombo_cha_count = tmp_scombo_cha_count[x]
                @btl_ani_scombo_get_flag = tmp_scombo_get_flag[x]
                @btl_ani_scombo_new_flag = tmp_scombo_new_flag[x]
                @btl_ani_scombo_no = tmp_scombo_no[x]
                @btl_ani_scombo_cha = tmp_scombo_cha[x]
                @btl_ani_scombo_flag_tec = tmp_scombo_flag_tec[x]
                @btl_ani_scombo_skill_level_num = tmp_scombo_skill_level_num[x]
                @btl_ani_scombo_card_attack_num = tmp_scombo_card_attack_num[x]
                @btl_ani_scombo_card_gard_num = tmp_scombo_card_gard_num[x]
                @btl_ani_scombo_chk_flag_oozaru_put = tmp_scombo_chk_flag_oozaru_put[x]
                # @btl_ani_scombo_tec_no = x
                @btl_ani_scombo_tec_no = tmp_scombo_renban[x]
                tmp_scombo_flag_tec[x] = [0, 0] # 検索に引っかからないように値を変更
                # tmp_loop_count += 1
                # p @btl_ani_scombo_cha_count,@btl_ani_scombo_get_flag,@btl_ani_scombo_new_flag,@btl_ani_scombo_no,@btl_ani_scombo_cha,@btl_ani_scombo_flag_tec,@btl_ani_scombo_skill_level_num,@btl_ani_scombo_card_attack_num,@btl_ani_scombo_card_gard_num
                # p "スパーキングコンボチェック前",chk_loop_result,x,tmp_scombo_flag_tec[x]
                chk_result = chk_scombo_flag(@btl_ani_scombo_no, chknewonlyflag)
            end

            if chk_result == true || x >= tmp_scombo_count
                break

            end
        end

        # もし条件が一致するなら合体攻撃を格納
        if chk_result == true
            @scombo_flag = true
            $cha_set_action[@chanum] = @btl_ani_scombo_no + 10
            $tmp_btl_ani_scombo_cha = @btl_ani_scombo_cha
            chk_new_get_scombo # @btl_ani_scombo_no
        end
    end

    #--------------------------------------------------------------------------
    # ● 合体攻撃が使用可能かチェック
    # tmp_set_action:チェック対象のSコンボNo
    # newonlyflag:未取得のSコンボのみ対象とする
    #--------------------------------------------------------------------------
    def chk_scombo_flag tmp_set_action, chknewonlyflag = false
        # p $cha_set_action キャラごとの攻撃スキル番号をセット、攻撃しないのであれば値は0
        # p $cardset_cha_no 指定の枚目にキャラ番号が振ってある1人目は0,2人目は1

        # p @attackDir,tmp_set_action
        if @attackDir == 1

            x = 0
            card_attack_num = [] # 攻撃星の数
            card_gard_num = [] # 防御星の数
            cha_skill_level_num = []
            case tmp_set_action

            when 304 # 自爆(サイバイマン
                # ヤムチャ以外には使わない
                # return false if $partyc[@chanum] != 7

                chkchanum = 7

                if get_chabtljoin_dead((chkchanum) == true)
                    return false
                else
                    @ene_coerce_target_chanum = chkchanum
                end
            when 373 # 大猿変身(べジータ

                return false if $battle_begi_oozaru_run == true

            when 644 # 大猿変身(ターレス

                return false if $battle_tare_oozaru_run == true

            when 645 # 巨大化(スラッグ

                return false if $battle_sura_big_run == true

            when 382, 383 # パープルコメットクラッシュ
                # ジースが生きてる

                # ジースバータ
                if $battleenemy.index(49) != nil
                    enenum = [49, 50]
                else
                    enenum = [248, 249]
                end

                for x in 0..enenum.size - 1
                    # p $battleenemy.index(enenum[x]),$enedeadchk[$battleenemy.index(enenum[x])-1],$ene_stop_num[$battleenemy.index(enenum[x])-1]
                    return false if $battleenemy.index(enenum[x]) == nil
                    return false if $enedeadchk[$battleenemy.index(enenum[x]) - 1] == true # 生きてるか
                    return false if $ene_stop_num[$battleenemy.index(enenum[x]) - 1] != 0 # 超能力にかかってないか
                end
            when 518 # ブージン)合体超能力

                enenum = [145, 146, 147]

                for x in 0..enenum.size - 1
                    # p $battleenemy.index(enenum[x]),$enedeadchk[$battleenemy.index(enenum[x])-1],$ene_stop_num[$battleenemy.index(enenum[x])-1]
                    return false if $battleenemy.index(enenum[x]) == nil
                    return false if $enedeadchk[$battleenemy.index(enenum[x]) - 1] == true # 生きてるか
                    return false if $ene_stop_num[$battleenemy.index(enenum[x]) - 1] != 0 # 超能力にかかってないか
                end
            when 583 # リベンジャーチャージ
                return false if $battle_ribe_charge == true # リベンジャーチャージ管理用
            when 584 # リベンジャーカノン
                return false if $battle_ribe_charge == false # リベンジャーチャージ管理用
                return false if $battle_ribe_charge_turn == true # リベンジャーチャージしたターンか
            when 607 # タード&ゾルト)ダブルアタック

                enenum = [178, 180]

                for x in 0..enenum.size - 1
                    # p $battleenemy.index(enenum[x]),$enedeadchk[$battleenemy.index(enenum[x])-1],$ene_stop_num[$battleenemy.index(enenum[x])-1]
                    return false if $battleenemy.index(enenum[x]) == nil
                    return false if $enedeadchk[$battleenemy.index(enenum[x]) - 1] == true # 生きてるか
                    return false if $ene_stop_num[$battleenemy.index(enenum[x]) - 1] != 0 # 超能力にかかってないか
                end
            when 637, 640 # レズン、ラカセイ)ダブルエネルギー波

                # レズン、ラカセイ
                if $battleenemy.index(68) != nil
                    enenum = [68, 69]
                else
                    enenum = [220, 221]
                end

                for x in 0..enenum.size - 1
                    # p $battleenemy.index(enenum[x]),$enedeadchk[$battleenemy.index(enenum[x])-1],$ene_stop_num[$battleenemy.index(enenum[x])-1]
                    return false if $battleenemy.index(enenum[x]) == nil
                    return false if $enedeadchk[$battleenemy.index(enenum[x]) - 1] == true # 生きてるか
                    return false if $ene_stop_num[$battleenemy.index(enenum[x]) - 1] != 0 # 超能力にかかってないか
                end
            end
        else
            for x in 0..@btl_ani_scombo_cha_count - 1

                if $partyc.index(@btl_ani_scombo_cha[x]) != nil # 仲間にいる
                    if $cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x])) != nil # 攻撃参加している
                        # if $cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x])) != nil #攻撃参加している 20140203コメントアウト
                        # p $scombo_chk_flag[@btl_ani_scombo_tec_no],@btl_ani_scombo_tec_no
                        if $scombo_chk_flag[@btl_ani_scombo_tec_no] != 0

                            if $scombo_chk_flag[@btl_ani_scombo_tec_no] == 1 # スイッチ

                                return false if $game_switches[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] == false
                            # p $scombo_chk_flag_no[x],$game_switches[$scombo_chk_flag_no[x]]
                            elsif $scombo_chk_flag[@btl_ani_scombo_tec_no] == 2 # 変数
                                # チェック方法 0:一致 1:以上 2:以下
                                case $scombo_chk_flag_process[@btl_ani_scombo_tec_no]
                                when 0
                                    return false if $game_variables[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] != $scombo_chk_flag_value[@btl_ani_scombo_tec_no]
                                when 1
                                    return false if $game_variables[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] < $scombo_chk_flag_value[@btl_ani_scombo_tec_no]
                                when 2
                                    return false if $game_variables[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] > $scombo_chk_flag_value[@btl_ani_scombo_tec_no]
                                end
                            end
                        end

                        # スキルでSコンボの必要な星を調整
                        scmb_mainasu_a = 0
                        scmb_mainasu_g = 0

                        scmb_mainasu_a, scmb_mainasu_g = chk_doutyou_run(@btl_ani_scombo_cha[x])

                        # シナリオ進行度
                        return false if $scombo_chk_scenario_progress[@btl_ani_scombo_tec_no] > $game_variables[40]
                        return false if chk_skill_learn(430, @btl_ani_scombo_cha[x])[0] == true # アウトサイダー取得していないか
                        return false if chk_skill_learn(644, @btl_ani_scombo_cha[x])[0] == true # アウトサイダー取得していないか
                        return false if chk_skill_learn(645, @btl_ani_scombo_cha[x])[0] == true # アウトサイダー取得していないか
                        return false if chk_skill_learn(646, @btl_ani_scombo_cha[x])[0] == true # アウトサイダー取得していないか
                        return false if chk_skill_learn(647, @btl_ani_scombo_cha[x])[0] == true # アウトサイダー取得していないか
                        return false if chk_skill_learn(648, @btl_ani_scombo_cha[x])[0] == true # アウトサイダー取得していないか
                        return false if chk_skill_learn(649, @btl_ani_scombo_cha[x])[0] == true # アウトサイダー取得していないか
                        return false if chk_skill_learn(650, @btl_ani_scombo_cha[x])[0] == true # アウトサイダー取得していないか
                        return false if chk_skill_learn(651, @btl_ani_scombo_cha[x])[0] == true # アウトサイダー取得していないか
                        return false if chk_skill_learn(476, @btl_ani_scombo_cha[x])[0] == true # 傍若無人取得していないか
                        return false if chk_skill_learn(477, @btl_ani_scombo_cha[x])[0] == true # 傍若無人取得していないか
                        return false if chk_skill_learn(478, @btl_ani_scombo_cha[x])[0] == true # 傍若無人取得していないか
                        return false if chk_skill_learn(479, @btl_ani_scombo_cha[x])[0] == true # 傍若無人取得していないか
                        return false if chk_skill_learn(480, @btl_ani_scombo_cha[x])[0] == true # 傍若無人取得していないか
                        return false if chk_skill_learn(481, @btl_ani_scombo_cha[x])[0] == true # 傍若無人取得していないか
                        return false if chk_skill_learn(482, @btl_ani_scombo_cha[x])[0] == true # 傍若無人取得していないか
                        return false if chk_skill_learn(483, @btl_ani_scombo_cha[x])[0] == true # 傍若無人取得していないか
                        return false if chk_skill_learn(484, @btl_ani_scombo_cha[x])[0] == true # 傍若無人取得していないか
                        return false if $chadeadchk[$partyc.index(@btl_ani_scombo_cha[x])] == true # 生きてる
                        return false if $cha_stop_num[$partyc.index(@btl_ani_scombo_cha[x])] != 0 # 超能力にかかってないか
                        return false if @cha_attack_run[$partyc.index(@btl_ani_scombo_cha[x])] == true # 行動済みではない
                        return false if $cha_set_action[$partyc.index(@btl_ani_scombo_cha[x])] - 10 != @btl_ani_scombo_flag_tec[x] # 対象技を使ってるか
                        return false if $game_actors[@btl_ani_scombo_cha[x]].class_id - 1 != $cardi[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] # 流派が一致
                        return false if $carda[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] < (@btl_ani_scombo_card_attack_num[x] - scmb_mainasu_a) # カードの攻撃星が以上
                        return false if $cardg[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] < (@btl_ani_scombo_card_gard_num[x] - scmb_mainasu_g) # カードの防御星が以上

                        $cha_skill_level[@btl_ani_scombo_flag_tec[x]] = 0 if $cha_skill_level[@btl_ani_scombo_flag_tec[x]] == nil # 必殺技使用回数がnilかチェックしてnilなら0格納
                        return false if $cha_skill_level[@btl_ani_scombo_flag_tec[x]] < @btl_ani_scombo_skill_level_num[x]

                        if $game_switches[1305] == false # 戦闘の練習中は覚えない
                            return false if $game_switches[$scombo_get_flag[@btl_ani_scombo_tec_no]] == true && chknewonlyflag == true # 未取得のスキルのみ
                        else
                            return false if $game_switches[$scombo_get_flag[@btl_ani_scombo_tec_no]] == false && chknewonlyflag == true # 未取得のスキルのみだとしても
                        end
                        return false if $game_switches[$scombo_get_flag[@btl_ani_scombo_tec_no]] == false && chknewonlyflag == false # 取得済みのスキルのみ

                        return false if $cha_single_attack[$partyc.index(@btl_ani_scombo_cha[x])] == true # && chknewonlyflag == false #Sコンボ使わないフラグがONになっていないか

                        # 大猿チェック
                        if @btl_ani_scombo_chk_flag_oozaru_put == 0
                            return false if $cha_bigsize_on[$partyc.index(@btl_ani_scombo_cha[x])] == true
                        else
                            return false if $cha_bigsize_on[$partyc.index(@btl_ani_scombo_cha[x])] == false
                        end
                    else
                        return false
                    end
                else
                    return false
                end

            end
        end

        return true
    end

    #--------------------------------------------------------------------------
    # ● 攻撃回数確認
    #--------------------------------------------------------------------------
    def chk_attack_num x
        @enenum = $attack_order[x].to_s[1, 1].to_i # 敵キャラNoセット(表示順)
        @enedatenum = $battleenemy[@enenum] # キャラNoセット(データ順)
        if $attack_order[x].to_s.size == 1
            @attack_num = 1
        else
            # 攻撃が強制的に1回フラグがOFFならば設定値、ONならば1にする
            if $game_switches[40] == false
                @attack_num = $data_enemies[@enedatenum].eva
            else
                @attack_num = 1
            end
            if $game_switches[25] == true || $game_switches[28] == true # 一定人数になると攻撃回数増加チェックフラグ
                ene_non_dead_count = 0
                for a in 0..$enedead.size - 1
                    ene_non_dead_count += 1 if $enedead[a] == false
                end

                if $game_switches[25] == true
                    @attack_num += 1 if ene_non_dead_count == 1
                end
                if $game_switches[28] == true
                    @attack_num += 1 if ene_non_dead_count <= 2
                end
            end

            if $game_switches[26] == true # HP30％攻撃回数増加チェックフラグ
                @attack_num += 1 if ($enehp[@enenum] * 100 / $data_enemies[@enedatenum].maxhp) <= 30
            end

            if $game_switches[27] == true # HP40％攻撃回数増加チェックフラグ
                @attack_num += 1 if ($enehp[@enenum] * 100 / $data_enemies[@enedatenum].maxhp) <= 40
            end

            if $game_switches[29] == true # HP50％攻撃回数増加チェックフラグ
                @attack_num += 1 if ($enehp[@enenum] * 100 / $data_enemies[@enedatenum].maxhp) <= 50
            end

            # 戦闘イベントの場合は強制的に攻撃回数を1とする
            if $game_variables[96] != 0
                @attack_num = 1
            end
            if @attack_count > 0
                create_enemy_card(@enenum, false)
                ryuhakakuritu_keisan(@enenum, $battleenemy[@enenum])
            end
        end
    end

    #--------------------------------------------------------------------------
    # ● 必殺技熟練度をデータベースへセット
    #--------------------------------------------------------------------------
    def set_skill_level
        if @attackDir == 0 # 味方
            for x in 0..$Cardmaxnum
                if $cardset_cha_no[x] == @chanum.to_i
                    if $cha_set_action[@chanum] >= 11
                        # 使用回数増加
                        if $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] == nil
                            $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] = 0
                        end
                        $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] += 1 if $game_switches[1305] == false
                        # 使用回数が9999を超えたら9999をセット
                        if $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] > $cha_skill_level_max
                            $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] = $cha_skill_level_max
                        end

                        # 必殺技回数同期
                        if $data_skills[$cha_set_action[@chanum] - 10].message2 != ""

                            # 同期対象の配列取得
                            skillsyncs = $data_skills[$cha_set_action[@chanum] - 10].message2.split(",")

                            # skill最大値
                            skillmax = 0

                            # skill最大値の取得
                            for x in 0..skillsyncs.size - 1
                                # 同期先がnilの場合0セット
                                if $cha_skill_level[skillsyncs[x].to_i] == nil
                                    $cha_skill_level[skillsyncs[x].to_i] = 0
                                end
                                if skillmax < $cha_skill_level[skillsyncs[x].to_i]
                                    skillmax = $cha_skill_level[skillsyncs[x].to_i]
                                end
                            end

                            # 最大値をセット
                            for x in 0..skillsyncs.size - 1
                                # 最大値より小さければセットする
                                if skillmax > $cha_skill_level[skillsyncs[x].to_i]
                                    $cha_skill_level[skillsyncs[x].to_i] = skillmax
                                end
                            end
                        end

                    else # 通常攻撃
                        # nilの初期化
                        $cha_normal_attack_level[$partyc[@chanum]] =
                            0 if $cha_normal_attack_level[$partyc[@chanum]] == nil

                        saiyazinflag = false
                        tuuzyouchanum = 0
                        superchanum = 0

                        # サイヤ人系の通常攻撃の回数同期用の事前処理
                        case $partyc[@chanum]

                        when 3, 14 # 悟空
                            tuuzyouchanum = 3
                            superchanum = 14
                            saiyazinflag = true
                        when 5, 18 # 悟飯
                            tuuzyouchanum = 5
                            superchanum = 18
                            saiyazinflag = true
                        when 12, 19 # ベジータ
                            tuuzyouchanum = 12
                            superchanum = 19
                            saiyazinflag = true
                        when 17, 20 # トランクス
                            tuuzyouchanum = 17
                            superchanum = 20
                            saiyazinflag = true
                        when 16, 32 # バーダック
                            tuuzyouchanum = 16
                            superchanum = 32
                            saiyazinflag = true
                        when 25, 26 # 未来悟飯
                            tuuzyouchanum = 25
                            superchanum = 26
                            saiyazinflag = true
                        end

                        # サイヤ人系の通常攻撃の回数同期用の処理
                        if saiyazinflag == true
                            # nilの初期化
                            $cha_normal_attack_level[tuuzyouchanum] =
                                0 if $cha_normal_attack_level[tuuzyouchanum] == nil
                            # nilの初期化
                            $cha_normal_attack_level[superchanum] = 0 if $cha_normal_attack_level[superchanum] == nil

                            if $cha_normal_attack_level[tuuzyouchanum] > $cha_normal_attack_level[superchanum]
                                $cha_normal_attack_level[superchanum] = $cha_normal_attack_level[tuuzyouchanum]
                            else
                                $cha_normal_attack_level[tuuzyouchanum] = $cha_normal_attack_level[superchanum]
                            end

                        end
                        # p $cha_normal_attack_level

                        # 攻撃回数加算
                        $cha_normal_attack_level[$partyc[@chanum]] += 1 if $game_switches[1305] == false
                        # p $cha_normal_attack_level
                    end
                end
            end
        end
    end

    #--------------------------------------------------------------------------
    # ● 戦闘曲再生
    #--------------------------------------------------------------------------
    def set_battle_bgm
        if $put_battle_bgm == false

            if $battle_escape == true
                set_battle_bgm_name(true)
            else
                # 逃げられないのはイベント戦判定にする。
                set_battle_bgm_name(true, 1)
            end

            if $battle_escape == true
                if $option_battle_bgm_name.include?("_user") == false
                    Audio.bgm_play("Audio/BGM/" + $option_battle_bgm_name) # 効果音を再生する
                else
                    Audio.bgm_play("Audio/MYBGM/" + $option_battle_bgm_name)    # 効果音を再生する
                end
            else
                if $option_evbattle_bgm_name.include?("_user") == false
                    Audio.bgm_play("Audio/BGM/" + $option_evbattle_bgm_name)    # 効果音を再生する
                else
                    Audio.bgm_play("Audio/MYBGM/" + $option_evbattle_bgm_name) # 効果音を再生する
                end
            end

            # $put_battle_bgm = true
        end
    end

    #--------------------------------------------------------------------------
    # ● 通常攻撃セット
    # x:アニメの配列位置
    #--------------------------------------------------------------------------
    def set_def_attack x = 1
        case $attack_anime[x]

        when 1
            @battle_anime_result = anime_pattern(51) # キック　左

        when 2
            @battle_anime_result = anime_pattern(52) # キック　右

        when 3
            @battle_anime_result = anime_pattern(53) # パンチ　左

        when 4
            @battle_anime_result = anime_pattern(54) # パンチ　右
        end
    end

    #--------------------------------------------------------------------------
    # ● 爆発効果音、エフェクトセット
    # x:アニメの配列位置
    #--------------------------------------------------------------------------
    def get_explosion get_flag = false
        # dmg_rate = 100 if dmg_rate > 100
        # p dmg_rate

        # 味方と敵でレートを変更する
        if @attackDir == 0
            dmg_rate = (@battledamage / $data_enemies[@enedatenum].maxhp.prec_f * 100).prec_i

            if $data_enemies[@enedatenum].element_ranks[22] == 1
                dmg_rate = dmg_rate * 5
            end

            case dmg_rate

            when 0..20
                # 小
                explosion_se = "Audio/SE/" + "Z3 光線系ヒット"
                explosion_eff = 101
            when 21..40
                # 中
                explosion_se = "Audio/SE/" + "ZG 光線系ヒット2"
                explosion_eff = 102
            when 41..60
                # 大
                explosion_se = "Audio/SE/" + "ZG 光線系ヒット3"
                explosion_eff = 103
            when 61..99
                # 特大
                explosion_se = "Audio/SE/" + "Z1 爆発1"
                explosion_eff = 104
            else
                # 撃破
                explosion_se = "Audio/SE/" + "DB3 大爆発"
                explosion_eff = 105
            end

        else
            dmg_rate = (@battledamage / $game_actors[$partyc[@chanum.to_i]].maxhp.prec_f * 100).prec_i
            case dmg_rate
            # $game_actors[$partyc[@chanum.to_i]].hp.prec_f / $game_actors[$partyc[@chanum.to_i]].maxhp.prec_f * 100).prec_i

            when 0..15
                # 小
                explosion_se = "Audio/SE/" + "Z3 光線系ヒット"
                explosion_eff = 101
            when 16..30
                # 中
                explosion_se = "Audio/SE/" + "ZG 光線系ヒット2"
                explosion_eff = 102
            when 31..45
                # 大
                explosion_se = "Audio/SE/" + "ZG 光線系ヒット3"
                explosion_eff = 103
            when 46..60
                # 特大
                explosion_se = "Audio/SE/" + "Z1 爆発1"
                explosion_eff = 104
            else
                # 撃破
                explosion_se = "Audio/SE/" + "DB3 大爆発"
                explosion_eff = 105
            end
        end
        return explosion_se, explosion_eff
    end

end  # end of class
