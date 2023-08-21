class Scene_Db_Battle_Anime < Scene_Base
  include Share
  include Db_Battle_Anime_test_Setup
  include Scene_Db_Battle_Anime_pattern

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
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(anime_event = false)
    #エラー処理用変数初期化
    $err_run_process = "戦闘アニメシーン"
    $err_run_process_d = ""
    $err_run_process_d2 = ""
    $err_run_process_d3 = ""
    @event_damege_result = false #イベント戦でダメージ処理をする
    @event_atc_hit = []          #イベント戦で敵の攻撃をヒットさせるか trueで回避
    @event_cha_atc_hit = []          #イベント戦で味方の攻撃をヒットさせるか trueで回避
    @event_ene_set_chara = []        #イベント戦で敵が何番目を攻撃するか
    @anime_event = anime_event
    @tmp_tec_move = [] #イベント戦闘時の必殺技発動の動き指定

    $one_turn_cha_hit_num = [] #1ターン管理攻撃ヒット回数管理

    for x in 0..$cardset_cha_no.size
      $one_turn_cha_hit_num[x] = 0
    end

    battle_anime_test_setup

    if @anime_event == true #イベント戦の場合はセット
      set_battle_event
    end

    #戦闘高速化デフォ設定
    #if $game_variables[303] == 0
    #  Graphics.frame_rate = 60
    #else
    #  if $game_variables[40] >= 2
    #    Graphics.frame_rate = 100 #90
    #  else
    #    p 1
    #    Graphics.frame_rate = 90
    #  end
    #end

  end

  #--------------------------------------------------------------------------
  # ● イベント用の内容をセット
  #--------------------------------------------------------------------------
  def set_battle_event
    #固定処理
    @tmp_cardi=[]
    @tmp_carda=[]
    @tmp_cardg=[]
    for x in 0..7
      @tmp_cardi[x] = $cardi[x]
      @tmp_carda[x] = $carda[x]
      @tmp_cardg[x] = $cardg[x]
    end


    #$partyc = [20]
    #$game_switches[17] = true
    #$game_switches[129] = true
    #$enehp[0] = 6000        #ここもそのまま
    #$game_variables[40] = 2 #シナリオ進行度
    #set_bgm = 0
    #$game_variables[96] = 1
    case $game_variables[96]

    when 1 #トランクス対フリーザサイボーグ

      $cha_set_action[0] = 187  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 410
      $cardi[0] = 8 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 5 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $battleenemy = [102]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[10,0]    #攻撃順番
      #@set_bgm = 15
    when 2 #ゴクウ対トランクス
      $cha_set_action[0] = 1  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 182
      $cardi[0] = 8 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 5 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $enecardi[1] = 8 #敵流派
      $enecarda[1] = 7 #敵攻撃
      $enecardg[1] = 7 #敵防御
      $battleenemy = [134,134]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[0,10,11]    #攻撃順番
      @set_bgm = 14
      @event_atc_hit[0] = false
      @event_atc_hit[1] = true
    when 3 #ピッコロ対17号
      $cha_set_action[0] = 1  #攻撃アクションNo
      $cha_set_action[1] = 1  #攻撃アクションNo
      $cha_set_action[2] = 45  #攻撃アクションNo
      $cha_set_action[3] = 50  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cardset_cha_no[1] = 1
      $cardset_cha_no[2] = 2
      $cardset_cha_no[3] = 3
      $cha_set_enemy[0] = 0   #味方が何番目の敵を攻撃するか
      $cha_set_enemy[1] = 1
      $cha_set_enemy[2] = 2
      $cha_set_enemy[3] = 3
      @event_ene_set_chara[0] = 0
      @event_ene_set_chara[1] = 1
      @event_ene_set_chara[2] = 2
      @event_ene_set_chara[3] = 3
      @tmp_ene_set_action = 432
      $cardi[0] = 5 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $cardi[1] = 3 #味方流派
      $carda[1] = 7 #味方攻撃
      $cardg[1] = 7 #味方防御
      $cardi[2] = 4 #味方流派
      $carda[2] = 7 #味方攻撃
      $cardg[2] = 7 #味方防御
      $cardi[3] = 4 #味方流派
      $carda[3] = 7 #味方攻撃
      $cardg[3] = 7 #味方防御
      $enecardi[0] = 5 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $enecardi[1] = 5 #敵流派
      $enecarda[1] = 7 #敵攻撃
      $enecardg[1] = 7 #敵防御
      $enecardi[2] = 4 #敵流派
      $enecarda[2] = 7 #敵攻撃
      $enecardg[2] = 7 #敵防御
      $enecardi[3] = 9 #敵流派
      $enecarda[3] = 7 #敵攻撃
      $enecardg[3] = 7 #敵防御
      $battleenemy = [125,125,125,125]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[10,0,11,1,12,2,13,3]    #攻撃順番
      @set_bgm = $bgm_no_ZSB2_pikkoro_for_gb
      @event_atc_hit[0] = false
      @event_atc_hit[1] = false
      @event_atc_hit[2] = false
      @event_atc_hit[3] = false
      @event_cha_atc_hit[0] = false
      @event_cha_atc_hit[1] = false
      @event_cha_atc_hit[2] = true
      @event_cha_atc_hit[3] = false
    when 4 #ピッコロ対セル
      $cha_set_action[0] = 49  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 182
      $cardi[0] = 4 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 8 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $battleenemy = [127]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[0]    #攻撃順番
      @set_bgm = $bgm_no_ZSB2_pikkoro_for_gb
      #@event_cha_atc_hit[0] = false
    when 5 #16号対セル
      $cha_set_action[0] = 1  #攻撃アクションNo
      $cha_set_action[1] = 224  #攻撃アクションNo
      $cha_set_action[2] = 225  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cardset_cha_no[1] = 1
      $cardset_cha_no[2] = 2
      $cha_set_enemy[0] = 0   #味方が何番目の敵を攻撃するか
      $cha_set_enemy[1] = 0
      $cha_set_enemy[2] = 0
      @event_ene_set_chara[0] = 0
      @tmp_ene_set_action = 432
      $cardi[0] = 5 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $cardi[1] = 9 #味方流派
      $carda[1] = 7 #味方攻撃
      $cardg[1] = 7 #味方防御
      $cardi[2] = 9 #味方流派
      $carda[2] = 7 #味方攻撃
      $cardg[2] = 7 #味方防御
      $enecardi[0] = 4 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $battleenemy = [127]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[0,10,1,2]    #攻撃順番
      @set_bgm = $bgm_no_ZSB1_16gou_for_gb
      @event_atc_hit[0] = false
      #@event_atc_hit[1] = false
      #@event_atc_hit[2] = false
      #@event_atc_hit[3] = false
      @event_cha_atc_hit[0] = true
      @event_cha_atc_hit[1] = false
      @event_cha_atc_hit[2] = false
      #@event_cha_atc_hit[3] = false
    when 6 #天津飯　新気功砲
      $cha_set_action[0] = 95  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 182
      $cardi[0] = 1 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 9 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $battleenemy = [128]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[0]    #攻撃順番
      #@set_bgm = $bgm_no_FCJ1_battle2
      #@event_cha_atc_hit[0] = false
    when 7 #ベジータ　ファイナルフラッシュ
      $cha_set_action[0] = 140  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 182
      $cardi[0] = 8 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 9 #敵流派
      $enecarda[0] = 0 #敵攻撃
      $enecardg[0] = 0 #敵防御
      $battleenemy = [129]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[0]    #攻撃順番
      #@set_bgm = $bgm_no_FCJ1_battle2
      #@event_cha_atc_hit[0] = false
    when 8 #セル反撃
      $cha_set_action[0] = 140  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 182
      $cardi[0] = 8 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 9 #敵流派
      $enecarda[0] = 0 #敵攻撃
      $enecardg[0] = 0 #敵防御
      $battleenemy = [129]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      @tmp_ene_set_action = 0
      $attack_order=[10,10,10]    #攻撃順番
      #@set_bgm = $bgm_no_FCJ1_battle2
      #@event_cha_atc_hit[0] = false
    when 9 #サタンダイナマイトキック
      $cha_set_action[0] = 298  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 182
      $cardi[0] = 14 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 9 #敵流派
      $enecarda[0] = 0 #敵攻撃
      $enecardg[0] = 0 #敵防御
      $battleenemy = [129]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[0]    #攻撃順番
      @tmp_tec_move[1] = 2
    when 10 #16号自爆
      $cha_set_action[0] = 227  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 182
      $cardi[0] = 9 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 9 #敵流派
      $enecarda[0] = 0 #敵攻撃
      $enecardg[0] = 0 #敵防御
      $battleenemy = [129]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[0]    #攻撃順番
      #@tmp_tec_move[1] = 2
      #@set_bgm = $bgm_no_FCJ1_battle2
      #@event_cha_atc_hit[0] = false
    when 11 #超悟飯2対セル
      $cha_set_action[0] = 1  #攻撃アクションNo
      $cha_set_action[1] = 1  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cardset_cha_no[1] = 1
      $cha_set_enemy[0] = 0   #ここもそのまま
      $cha_set_enemy[1] = 0
      @tmp_ene_set_action = 0
      $cardi[0] = 4 #味方流派
      $carda[0] = 0 #味方攻撃
      $cardg[0] = 0 #味方防御
      $cardi[1] = 4 #味方流派
      $carda[1] = 0 #味方攻撃
      $cardg[1] = 0 #味方防御
      $enecardi[0] = 8 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $battleenemy = [129]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[10,0,10,1]    #攻撃順番
    when 12 #バーダック編惑星戦士たちとの戦闘

      $cha_set_action[0] = 179  #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 410
      $cardi[0] = 5 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 5 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $battleenemy = [61]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 0
      $attack_order=[0]    #攻撃順番
    when 13 #バーダック編フリーザとの戦闘

      $cha_set_action[0] = 180 #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 410
      $cardi[0] = 5 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 5 #敵流派
      $enecarda[0] = 0 #敵攻撃
      $enecardg[0] = 0 #敵防御
      $battleenemy = [53]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 0
      $attack_order=[0]    #攻撃順番
    when 14 #未来悟飯と人造人間戦闘
      $cha_set_action[0] = 1 #攻撃アクションNo
      $cha_set_action[1] = 1 #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cardset_cha_no[1] = 1
      $cha_set_enemy[0] = 0   #ここもそのまま
      $cha_set_enemy[1] = 1
      @tmp_ene_set_action = 429
      $cardi[0] = 8 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $cardi[1] = 8 #味方流派
      $carda[1] = 7 #味方攻撃
      $cardg[1] = 7 #味方防御
      $enecardi[0] = 9 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $enecardi[1] = 9 #敵流派
      $enecarda[1] = 7 #敵攻撃
      $enecardg[1] = 7 #敵防御
      $battleenemy = [124,125]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[0,1,10]    #攻撃順番
    when 15 #未来トランクスとセル戦闘
      $cha_set_action[0] = 1 #攻撃アクションNo
      $cha_set_action[1] = 1 #攻撃アクションNo
      $cha_set_action[2] = 1 #攻撃アクションNo
      $cha_set_action[3] = 1 #攻撃アクションNo
      $cha_set_action[4] = 1 #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cardset_cha_no[1] = 1
      $cardset_cha_no[2] = 2
      $cardset_cha_no[3] = 3
      $cardset_cha_no[4] = 4
      $cha_set_enemy[0] = 0   #ここもそのまま
      $cha_set_enemy[1] = 0   #ここもそのまま
      $cha_set_enemy[2] = 0   #ここもそのまま
      $cha_set_enemy[3] = 0   #ここもそのまま
      $cha_set_enemy[4] = 0   #ここもそのまま
      @tmp_ene_set_action = 1
      $cardi[0] = 8 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $cardi[1] = 8 #味方流派
      $carda[1] = 7 #味方攻撃
      $cardg[1] = 7 #味方防御
      $cardi[2] = 8 #味方流派
      $carda[2] = 7 #味方攻撃
      $cardg[2] = 7 #味方防御
      $cardi[3] = 8 #味方流派
      $carda[3] = 7 #味方攻撃
      $cardg[3] = 7 #味方防御
      $cardi[4] = 8 #味方流派
      $carda[4] = 7 #味方攻撃
      $cardg[4] = 7 #味方防御
      $enecardi[0] = 9 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $enecardi[1] = 9 #敵流派
      $enecarda[1] = 7 #敵攻撃
      $enecardg[1] = 7 #敵防御
      $battleenemy = [127,127]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[0,1,10,2,3,11,4]    #攻撃順番
    when 16 #未来トランクスとセル戦闘(ヒートドームアタック
      $cha_set_action[0] = 188 #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 429
      $cardi[0] = 8 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 9 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $battleenemy = [127]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 1
      $attack_order=[0]    #攻撃順番
    when 17 #悟空 14、15号戦闘
      $cha_set_action[0] = 1 #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 1
      $cardi[0] = 3 #味方流派
      $carda[0] = 0 #味方攻撃
      $cardg[0] = 0 #味方防御
      $enecardi[0] = 8 #敵流派
      $enecarda[0] = 3 #敵攻撃
      $enecardg[0] = 3 #敵防御
      $enecardi[1] = 8 #敵流派
      $enecarda[1] = 3 #敵攻撃
      $enecardg[1] = 3 #敵防御
      $enecardi[2] = 8 #敵流派
      $enecarda[2] = 3 #敵攻撃
      $enecardg[2] = 3 #敵防御
      $battleenemy = [140,140,141]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 31
      $attack_order=[10,11,12]    #攻撃順番
      @event_atc_hit[0] = true
      @event_atc_hit[1] = true
      @event_atc_hit[2] = false
    when 18 #超バーダックとチルド戦闘(スーパーファイナルリベンジャー
      $cha_set_action[0] = 165 #攻撃アクションNo
      $cardset_cha_no[0] = 0
      $cha_set_enemy[0] = 0   #ここもそのまま
      @tmp_ene_set_action = 429
      $cardi[0] = 8 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 6 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $battleenemy = [238]
      $battleenenum = $battleenemy.size
      $Battle_MapID = 35
      $attack_order=[0]    #攻撃順番
      @set_bgm = $bgm_no_DKN_tyoubardak_btl
    when 19 #Z2フリーザを超元気玉でしとめる
      #悟空が先頭じゃなくても攻撃するように
      gokuno = $partyc.index(3)

      $cha_set_action[gokuno] = 30
      $cha_set_enemy[gokuno] = 0
      $cardset_cha_no[0] = gokuno

      @tmp_ene_set_action = 429
      $cardi[0] = 3 #味方流派
      $carda[0] = 7 #味方攻撃
      $cardg[0] = 7 #味方防御
      $enecardi[0] = 6 #敵流派
      $enecarda[0] = 7 #敵攻撃
      $enecardg[0] = 7 #敵防御
      $battleenemy = [56] #フリーザ
      $battleenenum = $battleenemy.size
      $Battle_MapID = 2
      $attack_order=[0]    #攻撃順番
      #@set_bgm = $bgm_no_DKN_tyoubardak_btl
    end

    #tempの方を使うスキルもあるので、こっちにも格納する
    #2021/8/25現在 気の暴走でエラーの対策
    $temp_cardi = Marshal.load(Marshal.dump($cardi)) #ここもそのまま

    $chadeadchk[0] = false  #ここもそのまま
    for x in 0..$battleenemy.size - 1
      $enedeadchk[x] = false  #ここもそのまま
      $eneselfdeadchk[x] = false  #ここもそのまま
    end

    # HPセット
    for x in 0..$battleenenum -1
      $enehp[x] = $data_enemies[$battleenemy[x]].maxhp #敵hpを代入
    end

    if $game_variables[95] == 0 #指定Noへ移動が0ならば追加1
      $game_variables[41] += 1
    else
      $game_variables[41] = $game_variables[95] #0以外なら指定をセット
    end
    $game_switches[128] = false #戦闘終了後イベントNo追加
    $game_variables[95] = 0     #戦闘終了後指定イベントへ
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
    #@back_window = Window_Base.new(-30,-30,700,540)
    #@back_window = Window_Base.new(-16,-16,672,512)
    #@back_window = Window_Base.new(-16,-16,672,356+32)
    @back_window = Window_Base.new(-16,-16,672,480+32)
    @back_window.opacity=0
    @back_window.back_opacity=0

    # キャラステータスウインドウ表示
    @status_window = Window_Base.new(Chastexstr,Chasteystr,Chastexend,Chasteyend)
    @status_window.opacity=0
    @status_window.back_opacity=0
  end

  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def start
    super

    @chanum = 0 #味方キャラ
    @enenum = 0 #表示順
    @enedatenum = 1 #データ順
    @battle_anime_frame = 0 #戦闘アニメフレーム数
    @anime_frame_format = false #戦闘アニメフレーム数フォーマットフラグ
    @@chastex = 50 #味方キャラステータス表示開始位置
    @@enestex = 310 #敵キャラステータス表示開始位置
    @attackcourse = 0 #攻撃方向 0:味方⇒敵 1:敵⇒味方
    @attack_num = 0   #攻撃回数
    @attack_count = 0 #攻撃回数カウント
    @damage_huttobi = true #ダメージ時吹っ飛ぶか
    @damage_center = false #ダメージを真ん中で受けるか
    @battledamage = 0 #戦闘ダメージ
    @attack_on = nil #攻撃できるかどうか判定
    @attack_any_one_flag = nil #攻撃で誰か一人でも攻撃したか(全体攻撃もここで管理)

    @ene_coerce_target_chanum = nil #敵が味方を強制的にターゲットを決める
    Graphics.fadein(5)
    create_window
    @attack_hit = nil    #攻撃がヒットするか
    @chax = STANDARD_CHAX
    @chay = STANDARD_CHAY
    @enex = STANDARD_ENEX
    @eney = STANDARD_ENEY
    @output_battle_damage_flag = false
    @tec_output_back = false
    @tec_output_back_no = 0 #背景種類
    @chr_cutin = false
    @chr_cutin_mirror_flag = false
    @chr_cutin_flag = false
    @genkitama_kanri_frame = []
    @genkitama_kanri_x = []
    @genkitama_kanri_y = []
    #@chax = -84
    #@chay = 122
    #@enex = 636
    #@eney = 122
    @backx = 0
    @backy = 256
    @tec_non_attack = false #必殺技で攻撃なし(超サイヤ人変身など
    @tec_tyousaiya = false #超サイヤ人変身の技を使った時
    @tec_back = 0
    @tec_back_anime_type = 0
    @tec_back_small = false #必殺技背景縮小フラグ
    @tec_back_color = 0 #背景色
    @battle_anime_result = 0
    @back_anime_frame = 0     #戦闘バックエフェクトのフレーム数
    @back_anime_type = 0      #戦闘バックエフェクトのタイプ
    @ray_anime_type = 0
    @ray_anime_frame = 0
    @ray_spd_up_flag = false #光線の速さアップ
    @ray_spd_up_num = 6 #光線の速さアップ量
    @scombo_cha_anime_frame = 0 #スパーキングコンボ用フレーム
    @scombo_cha1 = 0            #スパーキング用キャラ表示
    @scombo_cha2 = 0
    @scombo_cha3 = 0
    @scombo_cha4 = 0
    @scombo_cha5 = 0
    @scombo_cha6 = 0
    @scombo_cha1_anime_type = 0 #スパーキング用アニメタイプ
    @scombo_cha2_anime_type = 0
    @scombo_cha3_anime_type = 0
    @scombo_cha4_anime_type = 0
    @scombo_cha5_anime_type = 0
    @scombo_cha6_anime_type = 0
    @effect_anime_type = 0    #戦闘エフェクトのタイプ
    @effect_anime_pattern = 0 #戦闘エフェクトのNo ここにNoをいれてメソッドを呼ぶ
    @effect_anime_frame = 0   #戦闘エフェクトのフレーム数
    @effect_anime_mirror = 255  #戦闘エフェクトでエフェクトを逆のタイプを使うか
    @output_anime_type = 0    #キャラチップ変更時に通常・必殺技を読むか？
    @output_anime_type_y = 0  #Y軸を反転するかどうか
    @ray_color = 0            #光線の色
    @tec_power = 0            #必殺技攻撃力
    @all_attack_flag = false
    @all_attack_count = 0
    @ene_set_action = 0
    @scombo_flag = false      #スパーキングコンボ実行フラグ
    @chk_scombo_skill = []    #スパーキングコンボ用必殺技No格納
    @chk_scombo_cha_no = []   #スパーキングコンボ用対象キャラ格納
    #スパーキングコンボチェック用
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
    @one_turntec = [] #1ターンに1回しか使えない技
    @new_tecspark_flag = false #閃き必殺技を取得した際に消費Kiを0にするために使用

    @skill_kiup_flag = false #スキル気をためるが有効になったか

    @tmp_scom_run_skill = [] #Sコンボ時に有効になるskillNo

    if $game_variables[35] == 0 #背景スクロール設定
      @back_scroll_speed = 0
    else
      @back_scroll_speed = 4
    end
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress

    @cha_attack_run = []
    for x in 0..$partyc.size-1 #攻撃済みフラグを初期化
      @cha_attack_run[x] = false
    end

    #発動スキルの表示フレーム数
    @runskill_frame = 0
    #発動スキルの表示位置(横)
    @runskill_putx = []
    #発動スキルの表示が完了したフレーム数
    @runskill_lastput_frame = 9999999

    #連続攻撃回数初期化
    $cha_biattack_count = 0

    if @set_bgm != nil
      $battle_bgm = @set_bgm         #戦闘曲
      set_battle_bgm
    end

    #p "$game_variables[319]:" + $game_variables[319].to_s,"$game_variables[429]:" + $game_variables[429].to_s,"$game_switches[111]:" + $game_switches[111].to_s,"$battle_escape:" + $battle_escape.to_s
    #戦闘前BGM[319],イベント戦前BGM[429],ソリッドステートスカウター固定[111]
    if $game_variables[319] != 0 && $game_switches[111] == false && $battle_escape == true || #通常戦
      $game_laps == 0 && $game_variables[319] != 0 && $game_switches[111] == false && $battle_escape == false || #クリア前イベント戦
      $game_laps >= 1 && $game_variables[429] != 0 && $game_switches[111] == false && $battle_escape == false #クリア後イベント戦
      set_battle_bgm
    end

    #通常攻撃の真ん中へ移動するパターンのランダム値を格納
    @mannakaidouno = 0

    #けん制するかどうか
    @kenseiflag = nil

    #通常攻撃のけん制へ移動するパターンのランダム値を格納
    @keinseino = 0
  end

  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    #Graphics.fadeout(10)
    dispose_window

    #フレームレートを戻す
    if $fast_fps == false
      Graphics.frame_rate = 60
    end
    Graphics.fadein(0)

    for x in 0..$Cardmaxnum+1.to_i #使用したカードを更新
      if $cardset_cha_no[x] != 99

        createcardval x
      end
    end
    $game_switches[12] = true

    #戦闘に参加したキャラのみ フラグ初期化
    #p $cardset_cha_no
    for x in 0..$cardset_cha_no.size-1

      if $cardset_cha_no[x] != 99

        #フルの方も初期化、これをしないとflagがtrueのままになってしまう
        #バトルシーンに戻った時フルから読み込みここで戻したフラグがフルで元に戻される
        #先手カード
        $full_cha_sente_card_flag[$partyc[$cardset_cha_no[x]]] = false
        $cha_sente_card_flag[$cardset_cha_no[x]] = false

        #回避カード
        $full_cha_kaihi_card_flag[$partyc[$cardset_cha_no[x]]] = false
        $cha_kaihi_card_flag[$cardset_cha_no[x]] = false

      end
    end
    #変数初期化
    $cha_set_action = [0,0,0,0,0,0,0,0,0]
    $cardset_cha_no = [99,99,99,99,99,99]
    #@@card_set_no = [99,99,99,99,99,99]
    $cha_set_enemy = [99,99,99,99,99,99,99,99,99]
    $attack_order = Array.new
    $one_turn_cha_defense_up = false
    $run_stop_card = false
    $run_alow_card = false                      #ゴズカードを使用したか？
    $run_glow_card = false                      #メズカードを使用したか？
    $battle_turn_num_chk_flag = false #ターン数カウントフラグ
    #@@chk_attack_order = Array.new

    #イベント戦闘No初期化
    $game_variables[96] = 0
  end

  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    #super
    $err_run_process_d = "アニメ開始"
    for x in 0..$attack_order.size - 1
      #攻撃したかのチェック用のフラグをここで初期化
      @attack_any_one_flag = false

      #攻撃ループ回数を取得
      $btl_attack_count = x
      begin #攻撃回数
        $err_run_process_d2 = "攻撃方向セット"
        chk_attack_course x
        $err_run_process_d2 = "攻撃回数セット"
        chk_attack_num x   #攻撃回数確認
        $err_run_process_d2 = "攻撃敵の攻撃設定"
        ene_action_set  #敵の攻撃を設定

        $err_run_process_d2 = "敵のステータスを表示するか判定"
        chk_output_status #相手のステータスを表示するかチェック(超サイヤ人変身など攻撃がない場合は表示しない
        $err_run_process_d2 = "攻撃可能か判定"
        chk_attack x    #攻撃可能か判定

        #p $attack_on_flag,$attack_on_flag[x]
        #if $fullpower_on_flag[x] == nil
          #攻撃したかチェック
          #@attack_on
        #  $fullpower_on_flag[x] = true
        #end

        $err_run_process_d2 = "通常攻撃のパターン決定"
        for y in 1..$attack_anime_max #攻撃パターンセット
          begin
            temp_attack_anime = rand(4)+1
            #p temp_attack_anime
            #p $attack_anime.index(temp_attack_anime) == 0
          end until $attack_anime.index(temp_attack_anime) == nil
          $attack_anime[y] = temp_attack_anime
        end

        $err_run_process_d2 = "必殺技発動の動作設定"
        @tec_move = []
        for y in 1..2
          @tec_move[y] = rand($tec_move_pattern)+1
          #@tec_move[y] = 3
          #p @tec_move[y]
        end

        #p @attack_num , @attack_count

        #味方が攻撃するときのみチェック 効果変更のためボツ
        #if @attackcourse == 0
        #  @skill_kiup_flag = get_skill_kiup($partyc[@chanum.to_i])
        #end

        begin #全体攻撃
          $err_run_process_d2 = "巨大キャラか判定"
          #巨大キャラかチェック
          if @all_attack_flag == true
            chk_all_attack
          end
          #p @enedatenum#,$data_enemies[@enedatenum]
          if $data_enemies[@enedatenum].element_ranks[23] != 1
            @enerect = Rect.new(0 ,96*0, 96, 96)
          else
            #p @enedatenum
            @enerect = Rect.new(0 ,192*0, 192, 192)
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

            #味方が攻撃される、かつ全体攻撃ではない、かつかばう実行者がいる
            if @attackcourse == 1 && @all_attack_flag == false && $battle_kabau_runcha != nil
              @chanum = $battle_kabau_runcha
              #初期化
              #$battle_kabau_runcha = nil
              #$battle_kabau_runskill = nil
            end

            #試験的に移動
            #移動したら挑発とかが先に発動するようになってダメだった
            #==================================================================================================
            #if $battle_test_flag == false #戦闘テスト時は実行しない(なぜかSコンボ時にエラーになるため)
            #  damage_calculation (@attackcourse)
            #else
            #  @attack_hit = true
            #end
            #==================================================================================================

            #地球育ちのサイヤ人などのスキル発動
            run_battle_start_mae_skill (@attackcourse)
            #ここで個別処理しないとダメだったので

            window_contents_clear
            output_back
            output_status
            @status_window.update
            @back_window.update
            Graphics.update

            #全体攻撃一度でも攻撃した場合はtrueを維持
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
            battle_start #戦闘開始
            if @event_damege_result == true || $game_variables[96] == 0 #戦闘ダメージ結果反映
              chk_battle_damage if @tec_non_attack == false
            end
          end
          @output_battle_damage_flag = false

        end while @all_attack_flag == true

        @attack_count += 1


        @all_attack_flag = false
        @all_attack_count = 0
        @skill_kiup_flag = false #スキル気をためるが有効になったか

        @backx = 0

        #スパーキングコンボを使ったのであれば技を戻す

        scombo_no = 0  #Sコンボの格納用
        if @scombo_flag == true
          #必殺技使用回数増加用に必殺技番号をもとに戻す
          #Sコンボ参加者行動済みに
          #さらにMP消費
          #p $cha_set_action

          scombo_no = $cha_set_action[@chanum] #Sコンボの場合技Noを格納

          #コンボも使用回数を残すようにした。
          #使用回数増加
          #p $cha_skill_level[(scombo_no - 10)]
          if $cha_skill_level[(scombo_no - 10)] == nil
            $cha_skill_level[(scombo_no - 10)] = 0
          end
          $cha_skill_level[(scombo_no - 10)] += 1 if $game_switches[1305] == false #戦闘の練習中は増えない

          #使用回数が9999を超えたら9999をセット
          if $cha_skill_level[(scombo_no - 10)] > $cha_skill_level_max
            $cha_skill_level[(scombo_no - 10)] = $cha_skill_level_max
          end

          for y in 0..@btl_ani_scombo_cha.size - 1
            $cha_set_action[$partyc.index(@btl_ani_scombo_cha[y])] = (@btl_ani_scombo_flag_tec[y] + 10)
            @cha_attack_run[$partyc.index(@btl_ani_scombo_cha[y])] = true

            tec_mp_cost = get_mp_cost @btl_ani_scombo_cha[y],$data_skills[@btl_ani_scombo_flag_tec[y]].id,1

            #戦闘練習中でなければKIを消費する
            if $game_switches[1305] != true
              $game_actors[@btl_ani_scombo_cha[y]].mp -= tec_mp_cost
            end
            $cha_ki_zero[$partyc.index(@btl_ani_scombo_cha[y])] = false

            if $full_cha_ki_zero != nil
              $full_cha_ki_zero[$partyc[$partyc.index(@btl_ani_scombo_cha[y])]] = false
            end
            #$game_actors[@btl_ani_scombo_cha[y]].mp -= $data_skills[@btl_ani_scombo_flag_tec[y]].mp_cost
          end
        end

        #p "@attack_on:" + @attack_on.to_s,
        #"@attack_any_one_flag:" + @attack_any_one_flag.to_s,
        #"@attackcourse:" + @attackcourse.to_s,
        #"@cha_attack_run:" + @cha_attack_run[@chanum].to_s,
        #"@all_attack_flag:" + @all_attack_flag.to_s

        #if @attack_on == true || @attackcourse == 0 && @cha_attack_run[@chanum] == true
        if @attack_any_one_flag == true || @attackcourse == 0 && @cha_attack_run[@chanum] == true
          #p @cha_attack_run[@chanum],@chanum,$cha_set_action[@chanum]
          set_skill_level
        end

        #攻撃したかのチェック用のフラグをここで初期化
        @attack_any_one_flag = false

        #超サイヤ人変身
        if @tec_tyousaiya == true
          if @attackcourse == 0
            case $partyc[@chanum.to_i]

            when 3#,14
              schanum = 1
            when 5#,18
              schanum = 2
            when 12#,19
              schanum = 3
            when 17#,20
              schanum = 4
            when 18
              schanum = 5
            when 25
              schanum = 6
            when 16
              schanum = 7
            end

            #3大スーパーサイヤ人の場合は、発動者ではなく強制的に悟空を超サイヤ人にする
            #schanum = 1 if $goku3dai == true
            schanum = 1 if scombo_no == 748
            on_super_saiyazin schanum
          end
        end

        #大猿変身
        if @tec_oozaru == true
          if @attackcourse == 0
            case $partyc[@chanum.to_i]

            when 27 #トーマ
              schanum = 1
            when 28 #セリパ
              schanum = 2
            when 29 #トテッポ
              schanum = 3
            when 30 #パンブーキン
              schanum = 4
            when 5 #悟飯
              schanum = 5
            end

            on_oozaru schanum
            $cha_bigsize_on[@chanum.to_i] = true
          end
        end

        #敵大猿
        if @ene_tec_oozaru == true
          if $battleenemy[@enenum] == 12 #ベジータを大猿化
            $battleenemy[@enenum] = 26
            $battle_begi_oozaru_run = true
          end

          if $battleenemy[@enenum] == 59 #Z2ターレスを大猿化
            $battleenemy[@enenum] = 70
            $battle_tare_oozaru_run = true
          end

          if $battleenemy[@enenum] == 233 #ZGターレス(強)を大猿化
            $battleenemy[@enenum] = 222
            $battle_tare_oozaru_run = true
          end

          if $battleenemy[@enenum] == 60 #Z2スラッグを巨大化
            $battleenemy[@enenum] = 71
            $battle_sura_big_run = true
          end

          if $battleenemy[@enenum] == 255 #ZGスラッグ(強)を巨大化
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
        $skill_yousumi_runflag = false #様子見flag初期化
        #三大超サイヤ人の素材参照フラグを初期化
        $goku3dai = false

        $battle_kabawareru_runcha = nil #戦闘中かばわれるキャラ
        $battle_kabau_runcha = nil #戦闘中かばうスキルを実行するキャラ
        $battle_kabau_runskill = nil #戦闘中実行するかばうスキルNo
        $battle_kabau_scenerun = false #かばう戦闘シーンを処理したか

        for y in 1..$attack_anime_max
          $attack_anime[y] = 0
        end

      #ここの条件次第が悪い
      #HPを吸収した時に一定HPの割合に行くとループする
        #たまに攻撃回数が少なくなる時がある
        #if @attackcourse == 1
        #  p "@attack_num > @attack_count",
        #    "@attack_num:" + @attack_num.to_s,
        #    "@attack_count:" + @attack_count.to_s
        #end
      end while @attack_num > @attack_count
      #end while @attack_num != @attack_count
      @attack_count = 0
      #スパーキングコンボチェック用
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
      @cha_attack_run[@chanum] = true if @attackcourse == 0 #味方であれば攻撃済み

      @one_turntec = []
      #p @cha_attack_run
    end


    if Input.trigger?(Input::C)
      #window_key_state "C"
    end
    if Input.trigger?(Input::B)
      #window_key_state "B"
    end
    if Input.trigger?(Input::X)
      #window_key_state "X"
    end
    if Input.trigger?(Input::DOWN)
      #window_key_state 2
    end
    if Input.trigger?(Input::UP)
      #window_key_state 8
    end
    if Input.trigger?(Input::RIGHT)
      #window_key_state 6
    end
    if Input.trigger?(Input::LEFT)
      #window_key_state 4
    end

    fadetime = 0
    if ((Input.press?(Input::R) and Input.press?(Input::B)) && $game_variables[96] == 0 && @new_tecspark_flag == false || ($game_switches[860] == true && $game_switches[883] == true) && (Input.press?(Input::R) and Input.press?(Input::B)))
      fadetime = FASTFADEFRAME
    else
      fadetime = 10
    end
    Graphics.fadeout(fadetime)
    if $game_variables[96] == 0
      $scene = Scene_Db_Battle.new ($battle_escape,$battle_bgm,$battle_ready_bgm)
    else

      #戦闘関係のフラグ初期化
      reset_battle_flag
      #スーパーサイヤ人変身を解く
      off_super_saiyazin_all
      #大猿状態を解く
      off_oozaru_all
      #イベントNoを増やすかチェック
      $put_battle_bgm = false
      for x in 0..7
        $cardi[x] = @tmp_cardi[x]
        $carda[x] = @tmp_carda[x]
        $cardg[x] = @tmp_cardg[x]
      end
      $scene = Scene_Map.new
    end
  end
  #--------------------------------------------------------------------------
  # ● 相手のステータスを表示するか判定
  #--------------------------------------------------------------------------
  def chk_output_status

    #必殺技で攻撃する必要があるか
    if @attackcourse == 0
      if $cha_set_action[@chanum] > 10
        #攻撃なしか判定
        if $data_skills[$cha_set_action[@chanum]-10].element_set.index(10) != nil
          @tec_non_attack = true
        end
      end
    else
      if @ene_set_action > 10

        if $data_skills[@ene_set_action-10].element_set.index(10) != nil
          @tec_non_attack = true
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 攻撃方向をセット
  #--------------------------------------------------------------------------
  def chk_attack_course x
    if $attack_order[x].to_s.size == 1
      @attackcourse = 0 #攻撃方向セット
      @chanum = $cardset_cha_no[$attack_order[x]]                   #味方キャラNoセット
      $cha_biattack_count += 1
    else
      @attackcourse = 1 #攻撃方向セット
      $cha_biattack_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 閃き必殺技が使用可能かチェック
  #--------------------------------------------------------------------------
  def chk_tecspark_flag tmp_set_action
 #p $cha_set_action キャラごとの攻撃スキル番号をセット、攻撃しないのであれば値は0
 #p $cardset_cha_no 指定の枚目にキャラ番号が振ってある1人目は0,2人目は1


    if @attackcourse == 1
      x = 0
      card_attack_num = []    #攻撃星の数
      card_gard_num = []    #防御星の数
      cha_skill_level_num = []
    else

        if $partyc.index(@btl_ani_tecspark_cha) != nil #仲間にいる
          if $cardset_cha_no.index($partyc.index(@btl_ani_tecspark_cha)) != nil #攻撃参加している
            #p $tecspark_chk_flag[@btl_ani_tecspark_tec_no],@btl_ani_tecspark_tec_no
            if $tecspark_chk_flag[@btl_ani_tecspark_tec_no] != 0

              if $tecspark_chk_flag[@btl_ani_tecspark_tec_no] == 1 #スイッチ

                return false if $game_switches[$tecspark_chk_flag_no[@btl_ani_tecspark_tec_no]] == false
                #p $tecspark_chk_flag_no[x],$game_switches[$tecspark_chk_flag_no[x]]
              elsif $tecspark_chk_flag[@btl_ani_tecspark_tec_no] == 2 #変数
                #チェック方法 0:一致 1:以上 2:以下
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

            #シナリオ進行度
            return false if $tecspark_chk_scenario_progress[@btl_ani_tecspark_tec_no] > $game_variables[40]
            return false if rand(100) + 1 > $tecspark_chk_acquisition_rate[@btl_ani_tecspark_tec_no] #取得率チェック
            return false if $game_switches[$tecspark_get_flag[@btl_ani_tecspark_tec_no]] == true #取得済みかチェック
            return false if $chadeadchk[$partyc.index(@btl_ani_tecspark_cha)] == true #生きてる
            return false if $cha_stop_num[$partyc.index(@btl_ani_tecspark_cha)] != 0 #超能力にかかってないか
            return false if @cha_attack_run[$partyc.index(@btl_ani_tecspark_cha)] == true #行動済みではない
            return false if $cha_set_action[$partyc.index(@btl_ani_tecspark_cha)]-10 != @btl_ani_tecspark_flag_tec #対象技を使ってるか
            return false if $game_actors[@btl_ani_tecspark_cha].class_id-1 != $cardi[$cardset_cha_no.index($partyc.index(@btl_ani_tecspark_cha))] #流派が一致
            return false if $carda[$cardset_cha_no.index($partyc.index(@btl_ani_tecspark_cha))] < @btl_ani_tecspark_card_attack_num #カードの攻撃星が以上
            return false if $cardg[$cardset_cha_no.index($partyc.index(@btl_ani_tecspark_cha))] < @btl_ani_tecspark_card_gard_num #カードの防御星が以上
            $cha_skill_level[@btl_ani_tecspark_flag_tec] = 0 if $cha_skill_level[@btl_ani_tecspark_flag_tec] == nil #必殺技使用回数がnilかチェックしてnilなら0格納
            return false if $cha_skill_level[@btl_ani_tecspark_flag_tec] < @btl_ani_tecspark_skill_level_num
            return false if $game_switches[1305] == true #戦闘の練習中は覚えない
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

    #Sコンボ配列内に対象技があるかチェック
    #なければループ抜ける
    #あれば
    x = 0
    chk_loop_result = false
    loop do

      for x in 0..tmp_tecspark_count
        chk_loop_result = true if tmp_tecspark_flag_tec[x] == set_action
        #p "最初のループ",chk_loop_result,x,tmp_tecspark_flag_tec[x]
        if chk_loop_result != false || x >= tmp_tecspark_count
          break
        end
        x += 1 if chk_loop_result == false
      end

      #p "最初のループ抜けた",chk_loop_result,x,tmp_tecspark_flag_tec[x]
      if chk_loop_result != false
        #ひらめき技チェック用
        @btl_ani_tecspark_get_flag = tmp_tecspark_get_flag[x]
        @btl_ani_tecspark_new_flag = tmp_tecspark_new_flag[x]
        @btl_ani_tecspark_no = tmp_tecspark_no[x]
        @btl_ani_tecspark_cha = tmp_tecspark_cha[x]
        @btl_ani_tecspark_flag_tec = tmp_tecspark_flag_tec[x]
        @btl_ani_tecspark_skill_level_num = tmp_tecspark_skill_level_num[x]
        @btl_ani_tecspark_card_attack_num = tmp_tecspark_card_attack_num[x]
        @btl_ani_tecspark_card_gard_num = tmp_tecspark_card_gard_num[x]
        @btl_ani_tecspark_tec_no = x
        tmp_tecspark_flag_tec[x] = [0,0] #検索に引っかからないように値を変更
        #tmp_loop_count += 1
        #p @btl_ani_tecspark_cha_count,@btl_ani_tecspark_get_flag,@btl_ani_tecspark_new_flag,@btl_ani_tecspark_no,@btl_ani_tecspark_cha,@btl_ani_tecspark_flag_tec,@btl_ani_tecspark_skill_level_num,@btl_ani_tecspark_card_attack_num,@btl_ani_tecspark_card_gard_num
        #p "スパーキングコンボチェック前",chk_loop_result,x,tmp_tecspark_flag_tec[x]
        chk_result = chk_tecspark_flag @btl_ani_tecspark_no
      end

      if chk_result == true || x >= tmp_tecspark_count
        break

      end
      chk_loop_result = false
    end

    #もし条件が一致するなら合体攻撃を格納
    if chk_result == true
      @new_tecspark_flag = true
      $cha_set_action[@chanum] = @btl_ani_tecspark_no + 10
      chk_new_get_tecspark #@btl_ani_scombo_no
    end
  end
  #--------------------------------------------------------------------------
  # ● 閃き必殺を初めて使用したかチェック
  #--------------------------------------------------------------------------
  def chk_new_get_tecspark #action_no

    if $game_switches[@btl_ani_tecspark_get_flag] == false
      $game_switches[@btl_ani_tecspark_new_flag] = true
      $game_switches[30] = true
    end

  end
  #--------------------------------------------------------------------------
  # ● 攻撃可能か判定
  #--------------------------------------------------------------------------
  def chk_attack x
    @attack_on = true
    if $attack_order[x].to_s.size == 1
      #味方

      #敵が全て撃破状態
      if $enedeadchk.index(false) == nil
        @attack_on = false
        return
      end
      #@attackcourse = 0 #攻撃方向セット
      #@chanum = $cardset_cha_no[$attack_order[x]]                   #味方キャラNoセット
      #自分が死んでないかかつ超能力が掛かっていないかかつSコンボに参加してないか確認
      if $chadeadchk[@chanum] == false && $cha_stop_num[@chanum] == 0 && @cha_attack_run[@chanum] == false
        @enenum = $cha_set_enemy[$cardset_cha_no[$attack_order[x]]]  #敵キャラNoセット(表示順)
        @enedatenum = $battleenemy[@enenum]                            #キャラNoセット(データ順)

        if $cha_set_action[@chanum] > 10
          #使用するスキルが閃きするかチェック
          chk_tecspark $cha_set_action[@chanum]-10

          #使用するスキルが合体攻撃を含むのであれば条件を満たすかチェック
          #優先度をプレイヤーが変更できる機能を入れるため、順番次第でSコンボが発動できなくなるのでその対策として
          #まず未取得分のみチェックする
          chk_scombo_flag_num $cha_set_action[@chanum]-10,true #if $data_skills[$cha_set_action[@chanum] - 10].element_set[0] == 4

          #未取得が見つからなかったら取得済みもチェックする
          if @scombo_flag == false
            chk_scombo_flag_num $cha_set_action[@chanum]-10,false
          end

          if $data_skills[$cha_set_action[@chanum] - 10].element_set.index(10) != nil && $enedeadchk.index(false) != nil
            return
          #else
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
        #戦闘参加で止まるターン数減らす
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

      #敵が死んでないか、かつ敵が皆死んでないかを確認
      if $enedeadchk[@enenum] == false
        return

      #対象の敵が死んでため、対象を選択しなおす
      elsif $enedeadchk[@enenum] == true && $enedeadchk.index(false) != nil

        #作戦がセットされてなかったら低い敵から攻撃をセット
        $cha_tactics[0][$partyc[@chanum]] = 0 if $cha_tactics[0][$partyc[@chanum]] == nil
        case $cha_tactics[0][$partyc[@chanum]]

        when 0 #弱い敵
          if $enehp.min > 0 #HPが低い敵から攻撃していく
            @enenum = $enehp.index($enehp.min)
          else
            set_enehp = 1
            while $enehp.index(set_enehp) == nil
              set_enehp += 1
            end
            @enenum = $enehp.index(set_enehp)
          end

        when 1 #強い敵

          #if $enehp.min != 0 #HPが高い敵から攻撃していく
            enemaxhp = [[],[]]
            for x in 0..$battleenemy.size - 1

              if $enedeadchk[x] == false
                enemaxhp[0][x] = $data_enemies[$battleenemy[x]].maxhp

              else
                enemaxhp[0][x] = 0
              end
              enemaxhp[1][x] = x
            end
            #p enemaxhp[0],enemaxhp[1],enemaxhp[0].max
            @enenum = enemaxhp[1][enemaxhp[0].index(enemaxhp[0].max)]
          #end
        end





        #if $enehp.min != 0 #HPが低い敵から攻撃していく
        #  @enenum = $enehp.index($enehp.min)
        #else
        #  set_enehp = 1
        #  while $enehp.index(set_enehp) == nil
        #    set_enehp += 1
        #  end
        #  @enenum = $enehp.index(set_enehp)
        #end
        #p @enedatenum,$battleenemy[@enenum],@enenum
        #@enenum = $enedeadchk.index(false)
        @enedatenum = $battleenemy[@enenum]
        if @enedatenum.to_i > 5 || @enedatenum.to_i == 0 || @enedatenum.to_i == 3
          #p "敵敵死亡状態:" + $enedeadchk
          #p "敵数:" + $battleenenum.to_s, "攻撃順サイズ:" + $attack_order.size.to_s
        end
        return
      else
        @attack_on = false
        return
      end
    else
      #敵
      #@attackcourse = 1 #攻撃方向セット

      chaalldead = false

      if $enedeadchk[@enenum] == true || $ene_stop_num[@enenum] != 0#敵が死んでないか確認

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

      for y in 0..$Cardmaxnum #死んでいない味方キャラがいるか確認
        @chanum = $cardset_cha_no[y]

        # カードがセットされていてかつ生きているかをチェック
        if @chanum != 99 && $chadeadchk[@chanum] == false
          break
        elsif y == $Cardmaxnum
          @attack_on = false
          chaalldead = true
        end
      end

      #if $data_skills[@ene_set_action - 10].element_set.index(10) != nil && chaalldead == false
      #    return
      #else
      #    #味方が全員死んでるならば
      #    @attack_on = false
      #    return
      #end

      if chaalldead == false #攻撃先の決定
        begin
          begin
            y = rand($Cardmaxnum+1)
            @chanum = $cardset_cha_no[y]
            #必殺技などで強制的にターゲットを決定
            if @ene_coerce_target_chanum != nil
              @chanum = $partyc.index(@ene_coerce_target_chanum)
            end

            #イベント戦
            if @event_ene_set_chara[@enenum] != nil
              @chanum = @event_ene_set_chara[@enenum]
            end

          end while @chanum == 99
        end while $chadeadchk[@chanum] == true

        #イベント戦ではない、ターゲットがかばう候補かつ、
        #かばうスキルの発動条件を満たしている
        if @event_ene_set_chara[@enenum] == nil &&
          chk_kabau($partyc[@chanum]) == true

          #今のところ必要な処理はchk_kabauで出来ているのでここではなにもしない
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
  def chk_all_attack
    @attack_on = true

    if @attackcourse == 0
      @enenum += 1
      @enedatenum = $battleenemy[@enenum]
      if @enenum == $battleenenum - 1 #敵数が最後までループしたか？
        @all_attack_flag = false
      end
      if $enedeadchk[@enenum] != false #死亡確認
        @attack_on = false
        return
      end
    else
      @chanum += 1

      if @chanum == $partyc.size - 1 #味方数が最後までループしたか？
        @all_attack_flag = false
      end

      if $chadeadchk[@chanum] != false #死亡確認
        @attack_on = false
        return
      end

      if $cardset_cha_no.index(@chanum) == nil #カードセット確認
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
    color = set_skn_color 0
    @status_window.contents.fill_rect(0,0,672,156,color)

    color = set_skn_color 1 #味方ステータス枠

    #表示するかチェック
    chk_put_status = true
    if @attackcourse == 1
      chk_put_status = false if @tec_non_attack == true
    end

    if chk_put_status == true
      @status_window.contents.fill_rect(@@chastex+64+tyousei_x ,0+10,118,98,color)

      if $battle_kabau_runcha == nil || $game_switches[884] == true
        putchano = @chanum
      else
        putchano = $partyc.index($battle_kabawareru_runcha)
      end

      #ヘッダ
      picture = Cache.picture("数字英語")
      #HP
      rect = Rect.new(0, 16, 32, 16)
      @status_window.contents.blt(@@chastex+68+tyousei_x,32+tyousei_y,picture,rect)
      #KI
      rect = Rect.new(32, 16, 32, 16)
      @status_window.contents.blt(@@chastex+68+tyousei_x,64+tyousei_y,picture,rect)

      #=======================================================================
      #味方キャラ能力
      #=======================================================================
      #picturea = Cache.picture("名前")
      pictureb = Cache.picture("数字英語")
      #picturec = Cache.picture($btl_top_file_name+"顔味方")
      if ($game_actors[$partyc[putchano]].hp.prec_f / $game_actors[$partyc[putchano]].maxhp.prec_f * 100).prec_i < $hinshi_hp
        rect,picturec = set_character_face 1,$partyc[putchano]-3
        #rect = Rect.new(64, ($partyc[putchano] - 3)*64, 64, 64) # 顔グラ
      else
        rect,picturec = set_character_face 0,$partyc[putchano]-3
        #rect = Rect.new(0, ($partyc[putchano] - 3)*64, 64, 64) # 顔グラ
      end
      @status_window.contents.blt(@@chastex+tyousei_x ,0+tyousei_y,picturec,rect)
      rect = Rect.new(160, 0, 16, 16) # スラッシュ

      if $game_actors[$partyc[putchano]].maxhp.to_s.size <= 4 #HPスラッシュずらすか
        @status_window.contents.blt(@@chastex+100+tyousei_x,48+tyousei_y,pictureb,rect)
      else
        @status_window.contents.blt(@@chastex+100+tyousei_x-16,48+tyousei_y,pictureb,rect)
      end

      if $game_actors[$partyc[putchano]].maxmp.to_s.size <= 4 #MPスラッシュずらすか
        @status_window.contents.blt(@@chastex+100+tyousei_x,80+tyousei_y,pictureb,rect)
      else
        @status_window.contents.blt(@@chastex+100+tyousei_x-16,80+tyousei_y,pictureb,rect)
      end
      for y in 1..$game_actors[$partyc[putchano]].hp.to_s.size #HP
        rect = Rect.new($game_actors[$partyc[putchano]].hp.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(@@chastex+tyousei_x+164-(y-1)*16,32+tyousei_y,pictureb,rect)
      end

      for y in 1..$game_actors[$partyc[putchano]].maxhp.to_s.size #MHP
        rect = Rect.new($game_actors[$partyc[putchano]].maxhp.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(@@chastex+tyousei_x+164-(y-1)*16,48+tyousei_y,pictureb,rect)
      end

      for y in 1..$game_actors[$partyc[putchano]].mp.to_s.size #MP
        rect = Rect.new($game_actors[$partyc[putchano]].mp.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(@@chastex+tyousei_x+164-(y-1)*16,64+tyousei_y,pictureb,rect)
      end

      for y in 1..$game_actors[$partyc[putchano]].maxmp.to_s.size #MMP
        rect = Rect.new($game_actors[$partyc[putchano]].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(@@chastex+tyousei_x+164-(y-1)*16,80+tyousei_y,pictureb,rect)
      end

      #流派_カード
      picture = Cache.picture("カード関係")
      rect = set_card_frame 4 # 流派枠
      @status_window.contents.blt(@@chastex+tyousei_x ,64+tyousei_y,picture,rect)
      rect = Rect.new(32*($game_actors[$partyc[putchano]].class_id-1), 64, 32, 32) # 流派
      @status_window.contents.blt(@@chastex+16+tyousei_x ,64+tyousei_y,picture,rect)
      rect = set_card_frame 0
      @status_window.contents.blt(@@chastex+tyousei_x+182+2 ,0+tyousei_y,picture,rect)

      for x in 0..$Cardmaxnum
        if $cardset_cha_no[x] == putchano.to_i then

          rect = set_card_frame 2,$carda[x] # 攻撃
          @status_window.contents.blt(@@chastex+184+tyousei_x+$output_carda_tyousei_x+2,2+tyousei_y+$output_carda_tyousei_y,picture,rect)
          rect = set_card_frame 3,$cardg[x] # 防御
          @status_window.contents.blt(@@chastex+212+tyousei_x+$output_cardg_tyousei_x+2 ,62+tyousei_y+$output_cardg_tyousei_y,picture,rect)
          rect = Rect.new(0 + 32 * ($cardi[x]), 64, 32, 32) # 流派
          @status_window.contents.blt(@@chastex+198+tyousei_x+$output_cardi_tyousei_x+2 ,32+tyousei_y+$output_cardi_tyousei_y,picture,rect)
          picture = Cache.picture("アイコン")
          #流派が一致かパワーアップフラグがONの時は上アイコン表示
          if $game_actors[$partyc[putchano]].class_id-1 == $cardi[x] || $cha_power_up[putchano] == true || @skill_kiup_flag == true
            #パワーアップ
            rect = Rect.new(32*0, 16, 32, 32)
            @status_window.contents.blt(@@chastex+68-2+tyousei_x,0+tyousei_y,picture,rect)
          end
          #防御力アップ
          if $one_turn_cha_defense_up == true || $cha_defense_up[putchano] == true
            rect = Rect.new(32*1, 16, 32, 32)
            @status_window.contents.blt(@@chastex+96+tyousei_x,0+tyousei_y,picture,rect)
          end

          #超能力
          if $cha_stop_num[putchano] > 0
            rect = Rect.new(32*5, 16, 32, 32)
            @status_window.contents.blt(@@chastex+126+tyousei_x,0+tyousei_y,picture,rect)
          end
        end
      end

    end
    #=======================================================================
    #敵キャラ能力
    #=======================================================================
    top_name = set_ene_str_no @enedatenum
    picturec = Cache.picture(top_name+"顔敵")

    #表示するかチェック
    chk_put_status = true
    if @attackcourse == 0
      chk_put_status = false if @tec_non_attack == true
    end
    if chk_put_status == true
      if @enedatenum < $ene_str_no[1]
        if ($enehp[@enenum].prec_f / $data_enemies[@enedatenum.to_i].maxhp.prec_f * 100).prec_i < $hinshi_hp
          rect = Rect.new(64, (@enedatenum.to_i)*64, 64, 64) # 顔グラ
        else
          rect = Rect.new(0, (@enedatenum.to_i)*64, 64, 64) # 顔グラ
        end
      elsif @enedatenum < $ene_str_no[2]
        if ($enehp[@enenum].prec_f / $data_enemies[@enedatenum.to_i].maxhp.prec_f * 100).prec_i < $hinshi_hp
          rect = Rect.new(64, (@enedatenum-$ene_str_no[1]+1).to_i*64, 64, 64) # 顔グラ
        else
          rect = Rect.new(0, (@enedatenum-$ene_str_no[1]+1).to_i*64, 64, 64) # 顔グラ
        end
      else#if @enedatenum < $ene_str_no[3]
        if ($enehp[@enenum].prec_f / $data_enemies[@enedatenum.to_i].maxhp.prec_f * 100).prec_i < $hinshi_hp
          rect = Rect.new(64, (@enedatenum-$ene_str_no[2]+1).to_i*64, 64, 64) # 顔グラ
        else
          rect = Rect.new(0, (@enedatenum-$ene_str_no[2]+1).to_i*64, 64, 64) # 顔グラ
        end
      #else
      #  if ($enehp[@enenum].prec_f / $data_enemies[@enedatenum.to_i].maxhp.prec_f * 100).prec_i < $hinshi_hp
      #    rect = Rect.new(64, (@enedatenum-$ene_str_no[3]+1).to_i*64, 64, 64) # 顔グラ
      #  else
      #    rect = Rect.new(0, (@enedatenum-$ene_str_no[3]+1).to_i*64, 64, 64) # 顔グラ
      #  end
      end


      @status_window.contents.blt(@@enestex+184+tyousei_x ,0+tyousei_y,picturec,rect)

      #流派_カード
      picture = Cache.picture("カード関係")
      rect = set_card_frame 4 # 流派枠
      @status_window.contents.blt(@@enestex+184+tyousei_x ,64+tyousei_y,picture,rect)
      rect = Rect.new(32*($data_enemies[@enedatenum].hit-1), 64, 32, 32) # 流派
      @status_window.contents.blt(@@enestex+200+tyousei_x ,64+tyousei_y,picture,rect)
      rect = set_card_frame 0 #カード
      @status_window.contents.blt(@@enestex+16 ,0+tyousei_y,picture,rect)
      #CardsetCha = [0,1,2,3,4,5] #カードをセットしたキャラ
      #p $data_enemies[1].hit

      rect = set_card_frame 2,$enecarda[@enenum] # 攻撃
      @status_window.contents.blt(@@enestex+2+tyousei_x+$output_carda_tyousei_x,2+tyousei_y+$output_carda_tyousei_y,picture,rect)
      rect = set_card_frame 3,$enecardg[@enenum] # 防御
      @status_window.contents.blt(@@enestex+30+tyousei_x+$output_cardg_tyousei_x,62+tyousei_y+$output_cardg_tyousei_y,picture,rect)
      rect = Rect.new(0 + 32 * ($enecardi[@enenum]), 64, 32, 32) # 流派
      @status_window.contents.blt(@@enestex+16+tyousei_x+$output_cardi_tyousei_x,32+tyousei_y+$output_cardi_tyousei_y,picture,rect)

      if $run_scouter_ene[@enenum] == true
        color = set_skn_color 1 #味方ステータス枠
        @status_window.contents.fill_rect(@@enestex+66+tyousei_x ,0+tyousei_y,118,98,color)
        #ヘッダ
        picture = Cache.picture("数字英語")

        #HP
        case $data_enemies[@enedatenum.to_i].maxhp.to_s.size

        when 7..100#(100万)
          #HPなど表示しない
        when 6#(10万)
          rect = Rect.new(0, 16*9, 16, 16)
          @status_window.contents.blt(@@enestex+70+tyousei_x,32+tyousei_y,picture,rect)
        else #1万の桁いない
          #HP
          rect = Rect.new(0, 16, 32, 16)
          @status_window.contents.blt(@@enestex+70+tyousei_x,32+tyousei_y,picture,rect)
        end

        #KI(KIだけどHPの桁に合わせて変える)
        case $data_enemies[@enedatenum.to_i].maxhp.to_s.size
        when 7..100#(100万)
          #HPなど表示しない
        when 6#(10万)
          rect = Rect.new(16, 16*9, 16, 16)
          @status_window.contents.blt(@@enestex+70+tyousei_x,64+tyousei_y,picture,rect)
        else #1万の桁いない
          #KI
          rect = Rect.new(32, 16, 32, 16)
          @status_window.contents.blt(@@enestex+70+tyousei_x,64+tyousei_y,picture,rect)
        end


        #picturea = Cache.picture("名前")
        pictureb = Cache.picture("数字英語")
        rect = Rect.new(160, 0, 16, 16) # スラッシュ
        if $data_enemies[@enedatenum.to_i].maxhp.to_s.size < 5
          #HP
          @status_window.contents.blt(@@enestex+102+tyousei_x,48+tyousei_y,pictureb,rect)
          #KI
          @status_window.contents.blt(@@enestex+102+tyousei_x,80+tyousei_y,pictureb,rect)

        elsif $data_enemies[@enedatenum.to_i].maxhp.to_s.size < 7 #10万
          #HP
          @status_window.contents.blt(@@enestex+102+tyousei_x - 16 * ($data_enemies[@enedatenum.to_i].maxhp.to_s.size - 4),48+tyousei_y,pictureb,rect)
          #KI
          @status_window.contents.blt(@@enestex+102+tyousei_x - 16 * ($data_enemies[@enedatenum.to_i].maxhp.to_s.size - 4),80+tyousei_y,pictureb,rect)

        end

        #HP無限
        if $data_enemies[@enedatenum.to_i].element_ranks[57] == 1
          rect = Rect.new(11*16, 16, 16, 16)
          @status_window.contents.blt(@@enestex+tyousei_x+166-(1-1)*16,32+tyousei_y,pictureb,rect)
          @status_window.contents.blt(@@enestex+tyousei_x+166-(1-1)*16,48+tyousei_y,pictureb,rect)
        else
          for y in 1..$enehp[@enenum].to_s.size #HP
            rect = Rect.new($enehp[@enenum].to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(@@enestex+tyousei_x+166-(y-1)*16,32+tyousei_y,pictureb,rect)
          end

          for y in 1..$data_enemies[@enedatenum.to_i].maxhp.to_s.size #MHP
            rect = Rect.new($data_enemies[@enedatenum.to_i].maxhp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(@@enestex+tyousei_x+166-(y-1)*16,48+tyousei_y,pictureb,rect)
          end
        end

        #KI　ーを表示
        rect = Rect.new(11*16, 16, 16, 16)
        @status_window.contents.blt(@@enestex+tyousei_x+166-(1-1)*16,64+tyousei_y,pictureb,rect)
        @status_window.contents.blt(@@enestex+tyousei_x+166-(1-1)*16,80+tyousei_y,pictureb,rect)

        #KIを表示
        #for y in 1..$enemp[@enenum].to_s.size #MP
        #  rect = Rect.new($enemp[@enenum].to_s[-y,1].to_i*16, 0, 16, 16)
        #  @status_window.contents.blt(@@enestex+166-(y-1)*16,64,pictureb,rect)
        #end
        #
        #for y in 1..$data_enemies[@enedatenum.to_i].maxmp.to_s.size #MMP
        #  rect = Rect.new($data_enemies[@enedatenum.to_i].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
        #  @status_window.contents.blt(@@enestex+166-(y-1)*16,80,pictureb,rect)
        #end


        #流派が一致かパワーアップフラグがONの時は上アイコン表示
        picture = Cache.picture("アイコン")
        #パワーアップ
        if $data_enemies[@enedatenum].hit-1 == $enecardi[@enenum] || $ene_power_up[@enenum] == true
          rect = Rect.new(32*0, 16, 32, 32)
          @status_window.contents.blt(@@enestex+tyousei_x+70-2,0+tyousei_y,picture,rect)
        end

        #防御力アップ
        if $ene_defense_up == true
          rect = Rect.new(32*1, 16, 32, 32)
          @status_window.contents.blt(@@enestex+tyousei_x+98,0+tyousei_y,picture,rect)
        end

        #超能力
        if $ene_stop_num[@enenum] > 0
          rect = Rect.new(32*5, 16, 32, 32)
          @status_window.contents.blt(@@enestex+tyousei_x+128,0+tyousei_y,picture,rect)
        end
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● 発動スキル表示
  # type:1:攻撃、防御時の発動スキル　2:ヒットした時の発動スキル
  #--------------------------------------------------------------------------
  def output_runskill type=1

    #実行スキルがあれば表示
    #以下条件
    #・表示する最高フレームまで
    #・戦闘テストフラグが立っていない
    #・味方の全体攻撃は初回のみ表示(敵の全体攻撃はすべて(になっているはず))
    #・攻撃ヒットは全体攻撃でもすべて表示
    if (($tmp_run_skill.size > 0 || $tmp_run_hit_skill.size > 0 || $tmp_run_kabau_skill.size > 0) && @runskill_frame <= 60 && $battle_test_flag != true &&
      (@all_attack_count == 1 && @attackcourse == 0 || @attackcourse == 1 || type == 2)) && $game_variables[96] == 0 && @tec_non_attack == false
      waku_ysize = 28
      waku_picture = Cache.picture("戦闘_Sコンボ表示枠")
      waku_rect = Rect.new(0 ,0, 240, waku_ysize)
      put_skillnum = 3 #表示スキル数
      put_skillsraidx = 32 #スキルスライド
      put_skillsraidxmax = 240
      @runskill_frame += 1
      #@runskill_lastput_frame = 999999
      #発動スキルの表示位置(横)

      #スキル種別
      if type == 1
        #攻撃防御
        if $tmp_run_skill.size > put_skillnum
          put_loop = put_skillnum
        else
          put_loop = $tmp_run_skill.size - 1
        end
      elsif type == 3
        #かばう時
        if $tmp_run_kabau_skill.size > put_skillnum
          put_loop = put_skillnum
        else
          put_loop = $tmp_run_kabau_skill.size - 1
        end
      else
        #ヒット時
        if $tmp_run_hit_skill.size > put_skillnum
          put_loop = put_skillnum
        else
          put_loop = $tmp_run_hit_skill.size - 1
        end
      end
      #スキル表示
      for y in 0..put_loop

        #スキル表示位置を格納
        if @runskill_putx.size != put_loop.size
          @runskill_putx << -put_skillsraidxmax + (y * -48)
        end

        #スライド分追加
        if $game_variables[352] == 0
          #スライドする
          @runskill_putx[y] += put_skillsraidx
        else
          #固定位置
          @runskill_putx[y] = 0
        end

        #スキル表示位置調整
        if @runskill_putx[y] > 0
          @runskill_putx[y] = 0
        end

        mozi = "" #文字変数初期化(殻にする)

        #スキル表示か、etc表示か
        if y != put_skillnum
          #スキル名取得
          if type == 1
            #攻撃防御スキル
            mozi += $cha_skill_mozi_set[$tmp_run_skill[y]]
          elsif type == 3
            #かばうスキル
            mozi += $cha_skill_mozi_set[$tmp_run_kabau_skill[y]]
          else
            mozi += $cha_skill_mozi_set[$tmp_run_hit_skill[y]]
          end
        else
          mozi += "ETC"
        end
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)

        #色を白に変更
        $tec_mozi.change_tone(255,255,255)

        #発動スキル表示
        if $game_variables[351] == 0 || $game_variables[351] == 1 && @attackcourse == 0 ||
          $game_variables[351] == 2 && @attackcourse == 1
          #枠の表示
          @back_window.contents.blt(@runskill_putx[y],waku_ysize*y,waku_picture,waku_rect)

          #スキル名表示
          @back_window.contents.blt(16+@runskill_putx[y],waku_ysize*y,$tec_mozi,rect)
        end
      end
    end
          #もしまだ取得してなければ色を変える
          #if $cha_skill_spval[$partyc[@@cursorstate]][tmp_skill_list_put_skill_no[x]] < $cha_skill_get_val[tmp_skill_list_put_skill_no[x]]
          #  $tec_mozi.change_tone(128,128,128)
          #end

          #もしまだセットしたことなければ色を変える
          #if $cha_skill_set_flag[$partyc[@@cursorstate]][tmp_skill_list_put_skill_no[x]] == 0 && tmp_skill_list_put_skill_no[x] != 0
          #  $tec_mozi.change_tone(255,255,255)
          #end
  end
  #--------------------------------------------------------------------------
  # ● 除外通常戦闘攻撃をセット
  #--------------------------------------------------------------------------
  def set_ok_normalattackpattern

    #一応攻撃と防御側両方のスピードを取得しておく

    aspd = 0
    abig = false
    gspd = 0
    gbig = false

    ok_atk = []

    if @attackcourse == 0
      #味方が攻撃
      aspd = $game_actors[$partyc[@chanum]].agi
      #味方の大きさ状態
      abig = true if $cha_bigsize_on[@chanum.to_i] == true

      #敵が防御
      gspd = $data_enemies[@enedatenum].agi
      gbig = true if $data_enemies[@enedatenum].element_ranks[23] == 1
    else
      #味方が防御
      gspd = $game_actors[$partyc[@chanum]].agi
      gbig = true if $cha_bigsize_on[@chanum.to_i] == true

      #敵が攻撃
      aspd = $data_enemies[@enedatenum].agi
      abig = true if $data_enemies[@enedatenum].element_ranks[23] == 1
    end

    if aspd >= 0
      ok_atk = [1,2,3,4]
    end

    if aspd >= 25
      ok_atk << 14 #Z1 下がって溜めて攻撃
    end

    if aspd >= 30
      ok_atk << 18 #Z1 連打けん制
    end

    if aspd >= 35
      ok_atk << 15 #Z1 上下で何度か攻撃
      ok_atk << 16 #Z1 連打3回
    end

    if aspd >= 40
      ok_atk << 17 #Z2 連打
    end

    if aspd >= 45
      ok_atk << 5 #Z3 下がって攻撃
      ok_atk << 7 #1回ぶつかって攻撃
    end

    if aspd >= 55
      ok_atk << 8 #2回ぶつかる
      ok_atk << 10 #その場で連打
    end

    if aspd >= 65
      ok_atk << 6 #何度かぶつかる
      ok_atk << 9 #下がって連打
    end

    if aspd >= 75
      ok_atk << 11 #連打ぶつかって止め
    end

    if aspd >= 85
      ok_atk << 13 #攻撃側が何度か回避後攻撃
    end

    if aspd >= 95
      ok_atk << 12 #回避しながら連打
    end

    #巨大キャラの場合、戦闘アニメ処理が対応していないので除外する
    if $cha_bigsize_on[@chanum.to_i] == true || $data_enemies[@enedatenum].element_ranks[23] == 1
      #回避アニメが対応していない
      ok_atk.delete(12)
      #移動が下に行き過ぎる
      ok_atk.delete(15)
    end

    #ライチーのような打撃グラがないキャラは、攻撃側が回避を除外
    if @attackcourse == 0 && $data_enemies[@enedatenum].element_ranks[52] == 1
      #p 1,$data_enemies[@enedatenum]
      ok_atk.delete(13)
    end
    return ok_atk
  end
  #--------------------------------------------------------------------------
  # ● 戦闘アニメ処理
  #--------------------------------------------------------------------------
  def battle_start

    $err_run_process_d3 = "戦闘アニメ詳細処理開始"

    if $battle_test_flag == false #戦闘テスト時は実行しない(なぜかSコンボ時にエラーになるため)
      damage_calculation (@attackcourse)
    else
      @attack_hit = true
    end

    chpictureb = Cache.picture("戦闘アニメ")

    if $cha_bigsize_on[@chanum.to_i] != true
      @charect = Rect.new(0 ,96*0, 96, 96)
    else
      @charect = Rect.new(0 ,192*0, 192, 192)
    end
    #@enerect = Rect.new(0 ,96*0, 96, 96)
    ray_x = 0 #必殺技発動時のエネルギー波の位置(Z2以降使ってる)
    ray_y = 0
    damage_pattern = nil    #攻撃ヒット時のアニメパターン
    avoid_anime_no = 20     #攻撃回避時にアニメパターン


    #通常攻撃除外パターン用配列
    ok_normalattackpattern = []


    if @attackcourse == 0

      if $cha_set_action[@chanum] < 11
        attackpattern = $cha_set_action[@chanum]
        #attackpattern = rand($attack_pattern_max) + 1 #味方通常攻撃

        #対象攻撃を格納
        ok_normalattackpattern = set_ok_normalattackpattern

        #通常攻撃をセット
        begin
          $normalattackpattern = rand($attack_pattern_max) + 1 #味方通常攻撃
          #p not_normalattackpattern.index($normalattackpattern),$normalattackpattern
        end until ok_normalattackpattern.index($normalattackpattern) != nil

        #$normalattackpattern = rand($attack_pattern_max) + 1 #味方通常攻撃
      else
        attackpattern = $cha_set_action[@chanum] #味方必殺
        if @all_attack_count == 1
          if $battle_test_flag == false #戦闘テスト時は実行しない(なぜかSコンボ時にエラーになるため)
            tec_mp_cost = get_mp_cost $partyc[@chanum],$data_skills[attackpattern - 10].id,1
          else
            tec_mp_cost = 0
          end
          $cha_ki_zero[@chanum] = false

          if $full_cha_ki_zero != nil
            $full_cha_ki_zero[$partyc[@chanum]] = false
          end

          if @new_tecspark_flag == false #閃き必殺を覚えた際はKiを消費しない
            #戦闘練習中でなければKIを消費する
            if $game_switches[1305] != true
              $game_actors[$partyc[@chanum]].mp -= tec_mp_cost
            end
          else
            #@new_tecspark_flag = false
          end
          #$game_actors[$partyc[@chanum]].mp -= $data_skills[attackpattern - 10].mp_cost
        end
        #$game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState].mp_cost
      end
    elsif ($enecardi[@enenum] == 0 || $enecardi[@enenum] == $data_enemies[@enedatenum].hit-1) && $data_enemies[@enedatenum].actions.size != 0
      attackpattern = @ene_set_action #敵必殺

      #p attackpattern,$data_enemies[@enedatenum].actions.size,@enedatenum
    else
      #elsif $enecardi[@enenum] != 0
      #対象攻撃を格納
      ok_normalattackpattern = set_ok_normalattackpattern

      #p @ene_set_action #必だと 0になる
      attackpattern = @ene_set_action
      #attackpattern = rand($attack_pattern_max) + 1   #敵通常攻撃

      #通常攻撃をセット
      begin
        $normalattackpattern = rand($attack_pattern_max) + 1 #味方通常攻撃
        #p not_normalattackpattern.index($normalattackpattern),$normalattackpattern
      end until ok_normalattackpattern.index($normalattackpattern) != nil
      #$normalattackpattern = rand($attack_pattern_max) + 1 #敵通常攻撃
    end

    @battle_anime_frame = 0

    if @attackcourse == 0 # 戦闘画像用の進行度格納
      chk_scenario_progress $game_variables[40],2   #味方はそのまま進行度を格納
      $btl_progress = $game_variables[40]
    else
      if @enedatenum < $ene_str_no[1] #敵は敵の番号見て格納
        $btl_progress = 0
      elsif @enedatenum < $ene_str_no[2]
        $btl_progress = 1
      else#if @enedatenum < $ene_str_no[3]
        $btl_progress = 2
      end
      #戦闘画像用の進行度格納
      chk_scenario_progress $btl_progress,2

    end

    #戦闘背景用の進行度格納

    if $game_switches[466] != true #戦闘背景を特殊進行度で格納するか
      chk_scenario_progress $game_variables[40],3
    else
      chk_scenario_progress $game_variables[301],3
    end


    #かばう戦闘シーンを表示していない
    $battle_kabau_scenesumi = false
    #かばう戦闘シーン実行中
    $battle_kabau_scenerun = false

    begin
    input_fast_fps
    input_battle_fast_fps if $game_variables[96] == 0
    @back_window.contents.clear
    output_back attackpattern                       # 背景更新

    #発動スキルの表示(かばう用)
    if $battle_kabau_runcha != nil
      output_runskill 3 #引数1で攻撃と判断
    end

    #発動スキルの表示
    if $battle_kabau_runcha == nil
      output_runskill 1 #引数1で攻撃と判断
    end
    #巨大キャラの場合は技背景を小さくする
    if $data_enemies[@enedatenum].element_ranks[23] == 1 || $cha_bigsize_on[@chanum] == true
      @tec_back_small = true
    end

    #真ん中移動を配列に入れランダム動作にする
    arr_mannakaidouno = [1,5,7,8,11,12,15]
    if @mannakaidouno == 0
      @mannakaidouno = arr_mannakaidouno[rand(arr_mannakaidouno.size)]
    end


    #1:普通に真ん中に行く
    #5:上下に揺れて
    #7:両者上から下へ
    #8:両者斜めから攻撃上、防御下
    #11:商社斜め上からから登場味方左上、敵、右上
    #12:両者小さいのでぶつかり上へ移動、上から登場して中央へ
    #15:両者小さいので中央に行き通常の状態でセンターへ移動

    #けん制を配列に入れランダム動作にする
    arr_keinseino = [13,18,100001]
    if @keinseino == 0
      @keinseino = arr_keinseino[rand(arr_keinseino.size)]
    end
    #13:両者小さいので2回ぶつかり左右から中央へ
    #18:両者小さいのでぶつかり左右へ消える
    #100001:小さいのでけん制しあう

    if @kenseiflag == nil
      if rand(2) == 1
        @kenseiflag = true
      else
        @kenseiflag = false
      end
    end
    #戦闘テストの場合自動的にセット
    if $battle_test_flag == true
      attackpattern = $cha_set_action[0]
      $normalattackpattern = $test_normalattackpattern
      @mannakaidouno = 15
      #@keinseino = 1
    end


    begin #例外検知発動

    #かばう戦闘シーンを表示するか

    if $battle_kabau_runcha != nil && $battle_kabau_scenesumi == false && $game_switches[884] == false
      $battle_kabau_scenerun = true
      @battle_anime_result = anime_pattern 39
    elsif ($battle_kabau_scenesumi == true || $game_switches[884] == true) && $battle_kabau_runcha != nil

      #かばう戦闘アニメが表示し終わったら初期化
      #初期化
      $battle_kabau_runskill = nil
      $battle_kabau_runcha = nil
      $battle_kabawareru_runcha = nil

      Graphics.fadeout(10) if $game_switches[884] == false
      output_status
      @status_window.update
      @battle_anime_frame = -1
      @battle_anime_result = 0
      @runskill_frame = -1
      @runskill_putx = []
      Graphics.fadein(10) if $game_switches[884] == false
    else

      case attackpattern

      when 0

      when 1
        case $normalattackpattern
        when 1 #通常攻撃単純(真ん中へ行って蹴り)

          if @battle_anime_result == 0
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 1
            set_def_attack
          elsif @battle_anime_result == 2
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end

        when 2 #通常攻撃単純(両端から出てくる)

          if @battle_anime_result == 0
            #両端から見合い
            @battle_anime_result = anime_pattern 2
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern 1
          elsif @battle_anime_result == 2
            set_def_attack
          elsif @battle_anime_result == 3
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end

        when 3 #通常攻撃単純(真ん中へ回転)

          if @battle_anime_result == 0
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern 1
          elsif @battle_anime_result == 1
            #ぶつかって斜めへ
            @battle_anime_result = anime_pattern 3
          elsif @battle_anime_result == 2
            #回転
            @battle_anime_result = anime_pattern 4
          elsif @battle_anime_result == 3
            set_def_attack
          elsif @battle_anime_result == 4
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 4 #通常攻撃連打
          if @battle_anime_result == 0
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern 1
          elsif @battle_anime_result == 1
            if @battle_anime_frame == 0
              Audio.se_play("Audio/SE/" + "Z1 打撃")    # 効果音を再生する
            end
            #キック　左
            set_def_attack 1
          elsif @battle_anime_result == 2
            if @battle_anime_frame == 0
              Audio.se_play("Audio/SE/" + "Z1 打撃")    # 効果音を再生する
            end
            #パンチ　右
            set_def_attack 2
          elsif @battle_anime_result == 3
            if @battle_anime_frame == 0
              Audio.se_play("Audio/SE/" + "Z1 打撃")    # 効果音を再生する
            end
            #パンチ　左
            set_def_attack 3
          elsif @battle_anime_result == 4
            #キック　右
            set_def_attack 4
          elsif @battle_anime_result == 5
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 5 #通常攻撃 真ん中へ行ってから攻撃側がさがり打撃

          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end

          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #攻撃側後ろへ下がって前へ
            @battle_anime_result = anime_pattern 6
          elsif @battle_anime_result == 3
            set_def_attack
          elsif @battle_anime_result == 4
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 6 #通常攻撃 真ん中へ行ってから3回ぶつかって攻撃
          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end

          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result ==1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #攻撃側後ろへ下がって前へ
            @battle_anime_result = anime_pattern 9
          elsif @battle_anime_result == 3
            set_def_attack
          elsif @battle_anime_result == 4
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 7 #通常攻撃 真ん中へ行ってから1回だけぶつかって攻撃
          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #ぶつかって斜め
            @battle_anime_result = anime_pattern 10
          elsif @battle_anime_result == 3
            set_def_attack
          elsif @battle_anime_result == 4
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 8 #通常攻撃 真ん中へ行ってから1回ぶつかって、1買い下がって攻撃

          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #ぶつかって斜め
            @battle_anime_result = anime_pattern 10
          elsif @battle_anime_result == 3
            #攻撃側後ろへ下がって前へ
            @battle_anime_result = anime_pattern 6
          elsif @battle_anime_result == 4
            set_def_attack
          elsif @battle_anime_result == 5
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 9 #通常攻撃 両者小さいので2回ぶつかり左右から中央へ

          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino #13
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern 8
          elsif @battle_anime_result == 2
            #攻撃が下がって中央連打
            @battle_anime_result = anime_pattern 14
    #      elsif @battle_anime_result == 3
    #        set_def_attack
          elsif @battle_anime_result == 3
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 10 #通常攻撃 中央へ行って連打

          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #攻撃 中央連打
            @battle_anime_result = anime_pattern 16
    #      elsif @battle_anime_result == 3
    #        set_def_attack
          elsif @battle_anime_result == 3
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 11 #通常攻撃 中央へ行って連打、1回ぶつかり、止め

          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #攻撃 中央連打
            @battle_anime_result = anime_pattern 17
          elsif @battle_anime_result == 3
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 12 #通常攻撃 中央へ行って、消えながら連打
          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #消えながら連打
            @battle_anime_result = anime_pattern 19
          elsif @battle_anime_result == 3
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 13 #通常攻撃 回避して近づいて攻撃
          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #回避して近づいて攻撃
            @battle_anime_result = anime_pattern 100101
          elsif @battle_anime_result == 3
            set_def_attack
          elsif @battle_anime_result == 4
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 14 #通常攻撃 Z1 後ろに下がって溜めてから攻撃
          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #回避して近づいて攻撃
            @battle_anime_result = anime_pattern 100102
          elsif @battle_anime_result == 3
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 15 #通常攻撃 Z1中央上下中央で各3回攻撃
          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #回避して近づいて攻撃
            @battle_anime_result = anime_pattern 100103
          elsif @battle_anime_result == 3
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 16 #通常攻撃 Z1連打3回
          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #回避して近づいて攻撃
            @battle_anime_result = anime_pattern 100104
          elsif @battle_anime_result == 3
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 17 #通常攻撃 Z2連打
          #けん制フラグによってけん制を飛ばすかどうか
          if @kenseiflag == false && @battle_anime_result == 0
            @battle_anime_result = 1
          end
          if @battle_anime_result == 0
            #けん制
            @battle_anime_result = anime_pattern @keinseino
          elsif @battle_anime_result == 1
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 2
            #回避して近づいて攻撃
            @battle_anime_result = anime_pattern 100105
          elsif @battle_anime_result == 3
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        when 18 #通常攻撃何度か殴ってけん制(真ん中へ行って)

          if @battle_anime_result == 0
            #攻撃・防御真ん中へ
            @battle_anime_result = anime_pattern @mannakaidouno
          elsif @battle_anime_result == 1
            #通常攻撃何度か殴ってけん制
            @battle_anime_result = anime_pattern 100106
          elsif @battle_anime_result == 2
            #通常ダメージ
            damage_pattern = 21
            battleanimeend = true
          end
        end
      else
        case $btl_progress

        #必殺技
        when 0 #Z1
          case attackpattern
    ##############################################################################
    #
    # Z1必殺技
    #
    ##############################################################################
          when 11 #衝撃波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 101
            elsif @battle_anime_result == 3
              #衝撃波系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end

          when 12 #エネルギー波

            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 102
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 13 #複数エネルギー波

          when 14 #太陽拳

          when 15 #かめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 105
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 16 #界王拳
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 106
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 17 #界王拳・かめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 107
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 28 #元気弾
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 118
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 41 #魔光砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 131
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 42 #連続魔光砲

          when 43 #目から怪光線
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 133
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 44 #口から怪光線
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 134
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 45 #爆裂魔光砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 135
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 46 #魔貫光殺砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 136
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 47 #魔激砲

          when 48 #魔空波

          when 49 #激烈光弾

          when 50 #魔空包囲弾

          when 56 #魔光砲(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 146
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 57 #魔閃光(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 147
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 61 #大猿変身(悟飯)
            @tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 151
            elsif @battle_anime_result == 3
              battleanimeend = true
            end
          when 71 #エネルギー波(クリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 161
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 72 #カメハメ波(クリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 162
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 73 #拡散エネルギー波(クリリン)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 163
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 24
              battleanimeend = true
            end
          when 74 #気円斬(クリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 164
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 81 #狼牙風風拳
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 171
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 82 #かめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 172
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 83 #繰気弾
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 173
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true

            end
          when 91 #エネルギー波(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 181
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 92 #四身の拳(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 182
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 93 #気功砲(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 183
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 94 #四身の拳気功砲(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 184
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 24
              battleanimeend = true
            end
          when 101 #どどんぱ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 191
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 102 #超能力
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 192
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 25
              battleanimeend = true
            end
          when 103 #サイコアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 193
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 29
              battleanimeend = true
            end

          when 111 #衝撃波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 101
            elsif @battle_anime_result == 3
              #衝撃波系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 112 #ビーム
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 202
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 113 #気功スラッガー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 203
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 114 #超気功スラッガー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 204
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 169 #エネルギーは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1221
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 170 #強力エネルギーは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1248
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 171 #爆発波(バーダック)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1249
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 173 #ファイナルリベンジャー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1251
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 174 #スピリッツキャノン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1252
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 235 #残像拳
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 325
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 236 #元祖かめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 326
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 238 #萬國驚天掌
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 328
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 73
              battleanimeend = true
            end
          when 239 #MAXパワーかめはめは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 329
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 711 #師弟の絆(ピッコロとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 801
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 714 #ダブル衝撃波(ゴクウとチチ)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 804
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 715 #捨て身の攻撃(ゴクウとピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 805
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 716 #かめはめ乱舞(ゴクウとクリリンとヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 806
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 717 #操気円斬(クリリンとヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 807
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 718 #願いを込めた元気玉(ゴクウとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 808
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 27
              battleanimeend = true
            end
          when 719 #ダブルどどんぱ(天津飯と餃子)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 809
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 720 #超能力きこうほう(天津飯と餃子)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 810
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 28
              battleanimeend = true
            end
          when 721 #狼鶴相打陣(ヤムチャと天津飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 811
            elsif @battle_anime_result == 3
              @btl_ani_cha_chg_no = 7
              @battle_anime_result = anime_pattern 171
            elsif @battle_anime_result == 4
              #必殺技発動
              @battle_anime_result = anime_pattern 811
            elsif @battle_anime_result == 5
              @battle_anime_result = anime_pattern 182
            elsif @battle_anime_result == 6
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 740 #亀仙流かめはめは(悟空クリリンヤムチャ亀仙人
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 830
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 749 #この世で一番強いヤツ(悟空ピッコロゴハンクリリン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 839
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 758 #もしもヤムチャに(悟空ヤムチャ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 848
            elsif @battle_anime_result == 3
              @btl_ani_cha_chg_no = 7
              @battle_anime_result = anime_pattern 171
            elsif @battle_anime_result == 4
              #必殺技発動
              @battle_anime_result = anime_pattern 848
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
              @battle_anime_result = anime_pattern 105
            elsif @battle_anime_result == 6
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 761 #ありがとうピッコロさん！(ピッコロとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 851
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 762 #行くぞクリリン(ピッコロとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 852
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 829 #ダブルアイビーム(ピッコロと天津飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 919
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 311 #痺れ液(カイワレマン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 401
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 312 #痺れ液(キュウコンマン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 401
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 313 #痺れ液(サイバイマン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 403
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 314 #自爆(サイバイマン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 404
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 315 #エネルギー波(パンプキン系)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 405
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 316 #エネルギー波(パンプキン系)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 406
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 394 #大猿変身(オニオン)

            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 484
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 26
              battleanimeend = true

            end
          when 317 #エネルギー波(ジンジャー系)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 407
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 318 #強力エネルギー波(ジンジャー系)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 408
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 319 #刀攻撃(ジンジャー系)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 409
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 320 #エネルギー波(ラディッツ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 410
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 321 #強力エネルギー波(ラディッツ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 411
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 322 #エネルギー波(ナッパ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 412
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 323 #爆発波(ナッパ)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 413
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 324 #口からエネルギー波(ナッパ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 414
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 325 #衝撃波(ベジータ)

            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 101
            elsif @battle_anime_result == 3
              #衝撃波系ダメージ
              damage_pattern = 22
              battleanimeend = true

            end
          when 326 #エネルギー波(ベジータ)

            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 416
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true

            end
          when 328 #気円斬(ベジータ)

            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 418
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true

            end
          when 329 #爆発波(ベジータ)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 419
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 330 #ギャリック砲(ベジータ)

            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 420
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true

            end
          when 383 #大猿変身(ベジータ)
            @ene_tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 473
            elsif @battle_anime_result == 3
              #光線系ダメージ
              #damage_pattern = 26
              battleanimeend = true

            end
          when 595 #エネルギーは(大猿ベジータ)
            @ene_tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 685
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true

            end
          when 331 #エネルギー波(ニッキー系)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 407
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 332 #強力エネルギー波(ニッキー系)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 408
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 333 #刀攻撃(ニッキー系)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 409
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 334 #エネルギー波(サンショ系)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 424
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 335 #強力エネルギー波(サンショ系)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 425
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 336 #エネルギー弾(ガーリック)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 426
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 338 #強力エネルギー波(ガーリック)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 428
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 339 #強力エネルギー波(ガーリック巨大化)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 429
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 340 #ブラックホール波(ガーリック巨大化)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 430
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 469 #キシーメ電磁ムチ(強
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 559
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 472 #エビ氷結攻撃
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 562
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 70
              battleanimeend = true
            end
          when 473 #ミソ皮伸び攻撃
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 563
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 71
              battleanimeend = true
            end
          when 474 #ミソエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 564
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 475 #ミソ強力エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 565
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 596 #エネルギーは(Drウィロー)
            @ene_tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 686
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true

            end
          when 597 #フォトンストライク(両手エネルギー波(Drウィロー)
            @ene_tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 687
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true

            end
          when 598 #口からエネルギー波(Drウィロー)
            @ene_tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 688
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true

            end
          when 599 #ギガンティックボマー(Drウィロー)
            @ene_tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 689
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 600 #プラネットゲイザー(Drウィロー)
            @ene_tec_oozaru = true
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 690
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true

            end
          end


        when 1 #Z2
          case attackpattern
    ##############################################################################
    #
    # Z2必殺技
    #
    ##############################################################################
          when 11 #衝撃波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1101
            elsif @battle_anime_result == 3
              #衝撃波系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 12 #エネルギー波(悟空)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1102
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 13 #複数エネルギー波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              #@tec_output_back_no = 1
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2494
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 15 #カメハメ波(悟空)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1105
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 16 #界王拳
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1106
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 17 #界王拳・かめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1107
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 28 #元気弾
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1118
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 29 #超元気弾
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1119
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 30 #超元気弾(イベント用)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1120
            elsif @battle_anime_result == 3
              battleanimeend = true
            end
          when 36 #スーパーカメハメ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1126
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              #damage_pattern = 42
              #if $game_variables[40] >= 2
              #  damage_pattern = 42
              #else
              #  damage_pattern = 23
              #end
              battleanimeend = true
            end
          when 41 #魔光砲(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1131
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 43 #目から怪光線(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1133
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 44 #口から怪光線(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1134
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 45 #爆裂魔光砲(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1135
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 46 #魔貫光殺砲(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1136
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 56 #魔光砲(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1146
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 57 #魔閃光(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1147
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 62 #爆裂ラッシュ(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1152
            elsif @battle_anime_result == 3
              #光線系ダメージ

              if $btl_progress >= 2
                damage_pattern = 46
              else
                damage_pattern = 24
              end
              battleanimeend = true
            end
          when 71 #エネルギー波(クリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1146
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 72 #カメハメ波(クリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1162
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 73 #拡散エネルギー波(クリリン)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1163
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 74 #気円斬(クリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1164
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 81 #狼牙風風拳
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 171
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 82 #カメハメ波(ヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1105
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 83 #繰気弾(ヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1173
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 91 #エネルギー波(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1102
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 92 #四身の拳(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1182
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 93 #気功砲(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1183
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 94 #四身の拳気功砲(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1184
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 24
              battleanimeend = true
            end
          when 101 #どどんぱ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1191
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 102 #超能力
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1192
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 25
              battleanimeend = true
            end
          when 103 #サイコアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 193
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 29
              battleanimeend = true
            end
          when 111 #衝撃波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1101
            elsif @battle_anime_result == 3
              #衝撃波系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 112 #ビーム
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1202
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 113 #気功スラッガー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1203
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 114 #超気功スラッガー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1204
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 131 #エネルギーは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1221
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 133 #爆発波(ベジータ)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1223
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 134 #ギャリック砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1224
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 151 #エネルギー波(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1131
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 152 #口から怪光線(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1242
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 153 #強力エネルギー波(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1243
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 154 #ナメック戦士(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1244
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 155 #魔貫光殺砲(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              #@tec_back_color = 1
              #@tec_output_back_no = 3
              @battle_anime_result = anime_pattern 32
              #@tec_output_back = false
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1245
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 157 #エネルギーは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1221
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 158 #強力エネルギーは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1248
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 159 #爆発波(バーダック)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1249
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 161 #ファイナルリベンジャー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1251
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 162 #スピリッツキャノン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1252
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 179 #惑星戦士たちとの戦い(イベント用)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1269
            elsif @battle_anime_result == 3
              battleanimeend = true
            end
          when 180 #フリーザとの戦い(イベント用)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1270
            elsif @battle_anime_result == 3
              battleanimeend = true
            end
          when 235 #残像拳
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 325
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 236 #元祖かめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1326
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 238 #萬國驚天掌
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1328
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 73
              battleanimeend = true
            end
          when 239 #MAXパワーかめはめは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1329
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 256,265,275,283 #エネルギーは(トーマ、セリパ、トテッポ、パンブーキン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              damage_pattern = 42 if $cha_bigsize_on[@chanum] == true
              battleanimeend = true
            end
          #連続エネルギー波(全体)
          when 257,266,276,284
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              #@tec_output_back_no = 1
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2494
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 258,267,277,285 #強力エネルギーは(トーマ、セリパ、トテッポ、パンブーキン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2499
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              damage_pattern = 44 if $cha_bigsize_on[@chanum] == true
              battleanimeend = true
            end
          when 259 #トーマ(エネルギーボール
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1349
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 24
              battleanimeend = true
            end
          when 261,272,280,288 #大猿変身
            @tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1351
            elsif @battle_anime_result == 3
              battleanimeend = true
            end
          when 269 #セリパ(ヒステリックサイヤンレディ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1359
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 278 #トテッポ(アングリーアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1368
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 286 #パンブーキン(マッシブカタパルト
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1376
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 711 #師弟の絆(ピッコロとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1801
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 713 #サイヤンアタック(ゴクウとバーダック)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1803
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 714 #ダブル衝撃波(ゴクウとチチ)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1804
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 715 #捨て身の攻撃(ゴクウとピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1805
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 716 #かめはめ乱舞(ゴクウとクリリンとヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1806
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 717 #操気円斬(クリリンとヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1807
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 718 #願いを込めた元気玉(ゴクウとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1808
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 27
              battleanimeend = true
            end
          when 719 #ダブルどどんぱ(テンシンハンとチャオズ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1809
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 720 #超能力きこうほう(天津飯と餃子)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1810
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 28
              battleanimeend = true
            end
          when 721 #狼鶴相打陣(ヤムチャと天津飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1811
            elsif @battle_anime_result == 3
              @btl_ani_cha_chg_no = 7
              #@tec_output_back = true
              @battle_anime_result = anime_pattern 171
            elsif @battle_anime_result == 4
              #必殺技発動
              @tec_output_back = true
              @battle_anime_result = anime_pattern 1811
            elsif @battle_anime_result == 5
              @tec_output_back = true
              @battle_anime_result = anime_pattern 1182
            elsif @battle_anime_result == 6
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 723 #ギャリックかめはめは(ゴクウとベジータ)
            @damage_huttobi = false
            @damage_center = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1813
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 724 #どどはめは(ヤムチャとテンシンハンとチャオズ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1814
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 732 #気の開放(ゴハンとクリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1822
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 735 #アウトサイダーショット(ピッコロとバーダック)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2825
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 740 #亀仙流かめはめは(悟空クリリンヤムチャ亀仙人
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1830
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 742 #サイヤンアタック(トーマ＆パンブーキン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1832
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 743 #アウトサイダーショット(バーダックとトーマ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1833
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 744 #サイヤンアタック(セリパ＆トテッポ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1834
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 745 #アウトサイダーショット(バーダックとセリパ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1835
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 746 #アウトサイダーショット(バーダックとトテッポ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1836
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 747 #アウトサイダーショット(バーダックとパンブーキン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1837
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 749 #この世で一番強いヤツ(悟空ピッコロゴハンクリリン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1839
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 752 #強襲サイヤ人(トーマたち)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              #@tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1842
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 758 #もしもヤムチャに…(悟空とヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1848
            elsif @battle_anime_result == 3
              @btl_ani_cha_chg_no = 7
              #@tec_output_back = true
              @battle_anime_result = anime_pattern 171
            elsif @battle_anime_result == 4
              #必殺技発動
              @tec_output_back = true
              @battle_anime_result = anime_pattern 1848
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
              @battle_anime_result = anime_pattern 1105
            elsif @battle_anime_result == 6
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end

          when 761 #ありがとうピッコロさん！(ピッコロとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1851
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 762 #行くぞクリリン(ピッコロとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1852
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 766 #油断してやがったな(悟飯とベジータ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1856
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 767 #ありがとうピッコロさん！(若者とゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1857
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 768 #地球の方(若者とクリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1858
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 769 #なぜかいきのあう(若者とヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1859
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 78
              battleanimeend = true
            end
          when 775 #アウトサイダーショット(トーマとセリパ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1865
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 776 #アウトサイダーショット(トーマとトテッポ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1866
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 777 #アウトサイダーショット(セリパとトテッポ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1867
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 778 #アウトサイダーショット(トテッポとパンブーキン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1868
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 814 #絶好のチャンス(ゴハンとクリリンとベジータ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1904
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 815 #オレを半殺しにしろ(クリリン、ベジータ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1905
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 816 #超サイヤ人だ孫悟空(悟空、ピッコロ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1906
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 819 #地球丸ごと超決戦
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1909
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 829 #ダブルアイビーム(ピッコロと天津飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1919
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 886 #決死の超元気玉
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1976
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 48
              battleanimeend = true
            end
          when 341 #(ナップル系)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 342 #(グプレー系)ビームガン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 343 #(アプール系)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 344 #(キュイ系)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 345 #キュイ系爆発波

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1435
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 346 #(キュイ系)連続エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1436
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 347 #(ドドリア系)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1437
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 348 #(ドドリア系)口から怪光線
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1438
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 349 #(ドドリア系)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1439
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 350 #(ザーボン系)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1440
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 351 #(ザーボン系)スーパーエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1441
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 352 #(ザーボン系)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1442
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 353 #(ザーボン変身)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1443
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 354 #(ザーボン変身)スーパーエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1444
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 355 #(ギニュー)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1445
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 356 #(ギニュー)スーパーエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1446
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 357 #(ギニュー)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1447
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 359 #(ジース)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1449
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 360 #(ジース)クラッシャーボール
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1450
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 361 #(バータ)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1451
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 362 #(バータ)スピードアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1452
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 363 #(リクーム)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1453
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 364 #(リクーム)連続エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @tec_back_small = true
              @battle_anime_result = anime_pattern 1454
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 365 #(リクーム)イレイザーガン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1455
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 366 #(グルド)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1456
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 367 #(グルド)タイムストップ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1457
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 25
              battleanimeend = true
            end
          when 368 #(フリーザ)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1458
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 369 #(フリーザ)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1459
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 370 #(フリーザ)スーパーエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1460
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 371 #(フリーザ1)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1461
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 372 #(フリーザ1)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1462
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 373 #(フリーザ1)スーパーエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1463
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 374 #(フリーザ2)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1464
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 375 #(フリーザ2)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1465
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 376 #(フリーザ2)スーパーエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1466
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 377 #(フリーザ3)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1467
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 378 #(フリーザ3)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1468
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 379 #(フリーザ3)スーパーエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1469
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 634 #(フリーザ3)デスボール
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1724
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 704 #(フリーザ3)殺されるべきなんだ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1794
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 380 #(超ベジータ)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 381 #(超ベジータ)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1223
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 382 #(超ベジータ)ギャリック砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1224
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 705 #(超ベジータ)スーパーギャリック砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1795
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 384 #エネルギーは(ターレス
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1474
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 385 #爆発波(ターレス
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1475
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 386 #キルドライバー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1476
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 387 #メテオバースト
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1477
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 654 #大猿変身(ターレス)
            @ene_tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
              @tec_output_back_no = 1 #必殺背景縦
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1744
            elsif @battle_anime_result == 3
              #光線系ダメージ
              #damage_pattern = 26
              battleanimeend = true
            end
          when 388 #エネルギーは(スラッグ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1478
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 389 #爆発波(スラッグ
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1479
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 390 #ビッグスマッシャー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1480
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 391 #メテオバースト
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1481
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 655 #スラッグ巨大化
            @ene_tec_oozaru = true

            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1745
            elsif @battle_anime_result == 3
              #光線系ダメージ
              #damage_pattern = 26
              battleanimeend = true
            end
          when 392,393 #(ジース,バータ)パープルコメットクラッシュ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1482
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 476 #(惑星戦士1)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 477 #(惑星戦士2)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 478 #(惑星戦士3)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 479 #(惑星戦士4)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          #Z2敵汎用エネルギー波
          when 635,639,642,646,649,656,660,663,667,670
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 636 #アモンド気円斬
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1726
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 637 #アモンドプラネットボム
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1727
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 640 #コズミックアタック(カカオ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1730
            elsif @battle_anime_result == 3
              #コズミックアタックダメージ
              damage_pattern = 80
              battleanimeend = true
            end
          when 643 #爆発波(ダイーズ
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1733
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 644 #メテオボール(ダイーズ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1734
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 647,650 #ダブルエネルギー波 レズン、ラカセイ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1740
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 657 #エビルクエーサー アンギラ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1747
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 658 #手が伸びる アンギラ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1748
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 661 #エビルグラビティ ドロダボ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1751
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 664 #エビルコメット メダマッチャ
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1754
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 665 #カエル攻撃 メダマッチャ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1755
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 25 #23
              battleanimeend = true
            end
          when 668 #エビルインパクト ゼエウン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1758
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 671 #アンギラとメダマッチャ腕伸びるカエル攻撃
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1761
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          else
            if $battle_test_flag == true
              damage_pattern = @test_damage_pattern
            else
              damage_pattern = 41
            end
            battleanimeend = true
          end
        when 2 #Z3
          case attackpattern
    ##############################################################################
    #
    # Z3必殺技
    #
    ##############################################################################
          when 11 #衝撃波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1101
            elsif @battle_anime_result == 3
              #衝撃波系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 12 #エネルギー波(悟空)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1102
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 15 #カメハメ波(悟空)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1105
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 16 #界王拳
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true if $btl_progress >= 2
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1106
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 17 #界王拳・かめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true if $btl_progress >= 2
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1107
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 28 #元気弾
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              #@tec_output_back = false
              @tec_output_back_no = 1
              @battle_anime_result = anime_pattern 32
              #@tec_output_back = false
            elsif @battle_anime_result == 2
              #必殺技発動
              #@tec_output_back_no = 1
              #@tec_output_back = true
              @battle_anime_result = anime_pattern 2118
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 29 #超元気弾
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_output_back_no = 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2119
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 36 #スーパーカメハメ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1126
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              #damage_pattern = 44
              battleanimeend = true
            end
          when 37 #瞬間移動カメハメ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2127
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              #damage_pattern = 44
              battleanimeend = true
            end
          when 39,69,143,168,195,255 #超サイヤ人変身
            @tec_tyousaiya = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2129
            elsif @battle_anime_result == 3
              battleanimeend = true
            end
          when 41 #魔光砲(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1131
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 42 #爆裂波(ピッコロ)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              #@tec_output_back_no = 1
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2132
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 43 #目から怪光線(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1133
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 44 #口から怪光線(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1134
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 45 #爆裂魔光砲(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1135
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 46 #魔貫光殺砲(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_color = 1
              @tec_output_back_no = 3
              @battle_anime_result = anime_pattern 32
              @tec_output_back = false
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2136
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 49 #激烈光弾(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_color = 1
              @tec_output_back_no = 0
              @battle_anime_result = anime_pattern 32
              #@tec_output_back = false
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2139
            elsif @battle_anime_result == 3
              #光線系ダメージ

              if $game_variables[96] != 4
                damage_pattern = 42
                battleanimeend = true
              else
                damage_pattern = 49
                battleanimeend = true
              end
            end
          when 50 #魔空包囲弾(ピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_color = 1
              @tec_output_back_no = 0
              @battle_anime_result = anime_pattern 32
              #@tec_output_back = false
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2140
            elsif @battle_anime_result == 3
              #光線系ダメージ

              if $game_variables[96] != 3
                damage_pattern = 42
                battleanimeend = true
              else
                damage_pattern = 50
                battleanimeend = true
              end
            end
          when 56 #魔光砲(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1146
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 57 #魔閃光(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2147
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 58 #カメハメ波(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1148
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 62 #爆裂ラッシュ(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1152
            elsif @battle_anime_result == 3
              #光線系ダメージ
                damage_pattern = 46
              battleanimeend = true
            end
          when 63 #激烈ませんこう
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true

              #@tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2153
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              #damage_pattern = 44
              battleanimeend = true
            end
          when 64 #スーパーかめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2154
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              #damage_pattern = 44
              battleanimeend = true
            end
          when 71 #エネルギー波(クリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1146
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 72 #カメハメ波(クリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1162
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 73 #拡散エネルギー波(クリリン)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_output_back_no = 1
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2163
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 24
              battleanimeend = true
            end
          when 74 #気円斬(クリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2164
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 75 #気円烈斬(クリリン)
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
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2165
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 81 #狼牙風風拳
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 171
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 82 #カメハメ波(ヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1105
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 83 #繰気弾(ヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2173
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 84 #超繰気弾(ヤムチャ)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_output_back_no = 1
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2174
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 85 #新狼牙風風拳(ヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2175
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 91 #エネルギー波(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1102
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 92 #四身の拳(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2182
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 93 #気功砲(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2183
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 94 #四身の拳気功砲(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2184
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 46
              battleanimeend = true
            end
          when 95 #新気功砲(テンシンハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2185
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 47
              battleanimeend = true
            end
          when 101 #どどんぱ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1191
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 102 #超能力
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2192
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 25
              battleanimeend = true
            end
          when 103 #サイコアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 193
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 29
              battleanimeend = true
            end
          when 104 #超能力(全体)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_output_back_no = 1
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2194
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 76
              battleanimeend = true
            end
          when 105 #おもいっきりどどんぱ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2195
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 111 #衝撃波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1101
            elsif @battle_anime_result == 3
              #衝撃波系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 112 #ビーム
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1202
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 113 #気功スラッガー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1203
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 114 #超気功スラッガー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1204
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 117 #芭蕉扇
            if @all_attack_count >= 2 && @battle_anime_result == 0
              #@tec_output_back = false
              #@chr_cutin = true
              #@chr_cutin_flag = true
              #@chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2207
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 131 #エネルギーは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1221
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 133 #爆発波(ベジータ)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2223
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 134 #ギャリック砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1224
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 135 #ビッグバンアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_color = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2225
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 140 #ファイナルフラッシュ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_color = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2230
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 151 #エネルギー波(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1131
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 152 #口から怪光線(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1242
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 153 #強力エネルギー波(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1243
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 154 #ナメック戦士(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1244
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 155 #魔貫光殺砲(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              #@tec_back_color = 1
              #@tec_output_back_no = 3
              @battle_anime_result = anime_pattern 32
              @tec_output_back = false
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1245
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 156 #ミスティックフラッシャー(若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              #@tec_back_color = 1
              #@tec_output_back_no = 3
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
              #@tec_output_back = false
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2246
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 79
              battleanimeend = true
            end

          #バーダック
          when 157 #エネルギーは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1221
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 158 #強力エネルギーは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1248
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 159 #爆発波(バーダック)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1249
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 161 #ファイナルリベンジャー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1251
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 162 #スピリッツキャノン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1252
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 165 #スーパーファイナルリベンジャー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2255
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 181 #エネルギー波(トランクス)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1102
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end

          when 182,417,510 #カタナ攻撃(トランクス、サウザー、ゴクア)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2272
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 183 #爆発波(トランクス)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2273
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 184 #ませんこう(トランクス)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2274
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 186 #バーニングアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_color = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2276
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end

          when 187 #シャイニングソードアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_color = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2277
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true

            end
          when 188 #ヒートドームアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              #@tec_back_color = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2278
            elsif @battle_anime_result == 3
              #光線系ダメージ
              @tec_output_back_no = 1
              damage_pattern = 72
              battleanimeend = true
            end
          when 191 #フィニッシュバスター
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              #@tec_back_color = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2281
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 204 #気円斬(18号
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2294
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 208 #エネルギーウェイブ(18号
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2298
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 218 #エネルギーウェイブ(17号
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2308
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 224 #ロケットパンチ(16号
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2314
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 225 #ヘルズフラッシュ(16号
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2315
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 227 #自爆(16号
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2317
            elsif @battle_anime_result == 3
            #  #何も起きない
              damage_pattern = 0
              battleanimeend = true
            end
          when 235 #残像拳
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 325
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 236 #元祖かめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1326
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 238 #萬國驚天掌
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1328
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 73
              battleanimeend = true
            end
          when 239 #MAXパワーかめはめは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2329
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 240 #魔封波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2330
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 246 #まこうほう(未来悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2336
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 247 #ませんこう
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true

              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2337
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 248 #超爆力波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2338
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 250 #魔貫光殺砲(未来悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              #@tec_back_color = 1
              #@tec_output_back_no = 3
              @battle_anime_result = anime_pattern 32
              @tec_output_back = false
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2340
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 251 #スーパーカメハメ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2341
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 252 #爆裂乱舞
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2342
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 256,265,275,283 #エネルギーは(トーマ、セリパ、トテッポ、パンブーキン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              damage_pattern = 42 if $cha_bigsize_on[@chanum] == true
              battleanimeend = true
            end
          #連続エネルギー波(全体)
          when 257,266,276,284
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              #@tec_output_back_no = 1
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2494
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 258,267,277,285 #強力エネルギーは(トーマ、セリパ、トテッポ、パンブーキン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2499
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              damage_pattern = 44 if $cha_bigsize_on[@chanum] == true
              battleanimeend = true
            end
          when 259 #トーマ(エネルギーボール
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1349
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 24
              battleanimeend = true
            end
          when 260 #トーマ(フルパワーフレイムバレット
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2350
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 261,272,280,288 #大猿変身
            @tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1351
            elsif @battle_anime_result == 3
              battleanimeend = true
            end
          when 269 #セリパ(ヒステリックサイヤンレディ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1359
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 270 #セリパ(ハンティングアロー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2360
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 278 #トテッポ(アングリーアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1368
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 279 #トテッポ(アングリーキャノン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2369
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 286 #パンブーキン(マッシブカタパルト
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1376
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 287 #パンブーキン(マッシブキャノン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2377
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 298 #ダイナマイトキック(イベント用)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2388
            elsif @battle_anime_result == 3
              #何もしないで次へ
              damage_pattern = 40
              battleanimeend = true
            end
          when 711 #師弟の絆(ピッコロとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1801
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 713 #サイヤンアタック(ゴクウとバーダック)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1803
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 714 #ダブル衝撃波(ゴクウとチチ)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1804
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 715 #捨て身の攻撃(ゴクウとピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1805
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 716 #かめはめ乱舞(ゴクウとクリリンとヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1806
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 717 #操気円斬(クリリンとヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1807
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 718 #願いを込めた元気玉(ゴクウとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1808
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 27
              battleanimeend = true
            end
          when 719 #ダブルどどんぱ(テンシンハンとチャオズ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1809
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 720 #超能力きこうほう(天津飯と餃子)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1810
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 28
              battleanimeend = true
            end
          when 721 #狼鶴相打陣(ヤムチャと天津飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1811
            elsif @battle_anime_result == 3
              @btl_ani_cha_chg_no = 7
              #@tec_output_back = true
              @battle_anime_result = anime_pattern 171
            elsif @battle_anime_result == 4

              #必殺技発動
              @tec_output_back = true
              @battle_anime_result = anime_pattern 1811
            elsif @battle_anime_result == 5
              @tec_output_back = true
              @battle_anime_result = anime_pattern 1182
            elsif @battle_anime_result == 6
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 722 #地球人ストライク(クリリン、ヤムチャ、テンシンハン、チャオズ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2812
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 46
              battleanimeend = true
            end
          when 723 #ギャリックかめはめは(ゴクウとベジータ)
            @damage_huttobi = false
            @damage_center = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1813
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 724 #どどはめは(ヤムチャとテンシンハンとチャオズ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1814
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 726 #ノンステップバイオレンス(17号と18号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2816
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 728 #ヘルズスパイラル(16号と17号と18号)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2818
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 729 #ダブル気円斬(クリリンと18号)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2819
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 730 #ギャリックバスター(ベジータとトランクス)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2820
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 732 #気の開放(ゴハンとクリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1822
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 733 #眠れる力(ごはんと16号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2823
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 735 #アウトサイダーショット(ピッコロとバーダック)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2825
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 736 #ダブルませんこう(ゴハンとトランクス)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2826
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 737 #ダブルまかんこうさっぽう(ピッコロと未来ゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2827
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 738 #答えは8だ(クリリンとチャオズ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1828
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 739 #四身の拳・かめはめは(ごくうとテンシンハン)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2829
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 740 #亀仙流かめはめは(悟空クリリンヤムチャ亀仙人
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1830
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 742 #サイヤンアタック(トーマ＆パンブーキン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1832
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 743 #アウトサイダーショット(バーダックとトーマ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1833
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 744 #サイヤンアタック(セリパ＆トテッポ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1834
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 745 #アウトサイダーショット(バーダックとセリパ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1835
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 746 #アウトサイダーショット(バーダックとトテッポ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1836
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 747 #アウトサイダーショット(バーダックとパンブーキン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1837
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 748 #3大超サイヤ人
            $goku3dai = false
            #ゴクウが通常の時は超サイヤ人に変身する
            @tec_tyousaiya = true if $super_saiyazin_flag[1] != true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2838
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 749 #この世で一番強いヤツ(悟空ピッコロゴハンクリリン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2839
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 750 #メタルクラッシュ(超悟空と超ベジータ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2840
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 74
              battleanimeend = true
            end
          when 751 #あっちいってけろ(ヤムチャチチ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2841
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 752 #強襲サイヤ人(トーマたち)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              #@tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1842
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 753 #アウトサイダーショット(ピッコロと17号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2843
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 754 #よけられるハズだべ・・・(チチかめせんにん
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2844
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 755 #うごきをとめろ(亀仙人とテンシンハンとチャオズ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2845
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 756 #ダブル残像拳(ごくうとクリリン)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2846
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 757 #師弟アタック(未来悟飯とトランクス)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2847
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 758 #もしもヤムチャに…(悟空とヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1848
            elsif @battle_anime_result == 3
              @btl_ani_cha_chg_no = 7
              #@tec_output_back = true
              @battle_anime_result = anime_pattern 171
            elsif @battle_anime_result == 4
              #必殺技発動
              @tec_output_back = true
              @battle_anime_result = anime_pattern 1848
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
              @battle_anime_result = anime_pattern 1105
            elsif @battle_anime_result == 6
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 759 #ダブル残像拳(クリリンと亀仙人)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true if $btl_progress >= 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2846
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 760 #打て！悟飯(ピッコロとゴハンとクリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1850
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 761 #ありがとうピッコロさん！(ピッコロとゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1851
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 762 #行くぞクリリン(ピッコロとクリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1852
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 764 #お母さんをいじめるな　悟飯とチチ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2854
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 46
              battleanimeend = true
            end
          when 765 #アウトサイダーショット(ピッコロとベジータ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2855
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 766 #油断してやがったな(悟飯とベジータ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1856
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 767 #ピッコロさん！？(若者とゴハン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1857
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 768 #地球の方(若者とクリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1858
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 769 #なぜかいきのあう(若者とヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1859
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 78
              battleanimeend = true
            end
          when 770 #ダブルまかんこうさっぽう(ピッコロとわかもの)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2860
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 771 #大師匠と孫弟子(ピッコロとトランクス)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2861
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 772 #ダブルスラッシュ(トランクスとクリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2862
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 773 #ギャリックかめはめは(ヤムチャとベジータ)
            @damage_huttobi = false
            @damage_center = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2863
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 774 #親子かめはめ波(悟空と悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2864
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 775 #アウトサイダーショット(トーマとセリパ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1865
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 776 #アウトサイダーショット(トーマとトテッポ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1866
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 777 #アウトサイダーショット(セリパとトテッポ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1867
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 778 #アウトサイダーショット(トテッポとパンブーキン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1868
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 779 #ダブルまかんこうさっぽう(未来悟飯とわかもの)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2869
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 780 #母さんは俺が守る　未来悟飯とチチ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2870
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 781 #ダブルませんこう(未来ゴハンとトランクス)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2871
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 782 #トリプルませんこう(悟飯、未来ゴハンとトランクス)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2872
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 783 #トリプル魔貫光殺法(ピッコロ、未来ゴハンと若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2873
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 784 #アウトサイダーショット(ピッコロと18号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2874
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 785 #アウトサイダーショット(ピッコロと16号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2875
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 786 #アウトサイダーショット(未来悟飯と18号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2876
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 787 #アウトサイダーショット(未来悟飯と17号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2877
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 788 #アウトサイダーショット(未来悟飯と16号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2878
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 789 #アウトサイダーショット(未来悟飯とベジータ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2879
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 790 #超爆力魔波(未来悟飯とピッコロ)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2880
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 791 #ダブルアタック(天津飯とトランクス)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2881
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 792 #ダブルアタック(チャオズとトランクス)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2882
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 793 #悟飯ちゃんを巻き込む出ねえ(チチとピッコロ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2883
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 794 #悟空さを巻き込む出ねえ(チチとベジータ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2884
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 795 #戦闘民族サイヤ人、バーダック、トーマ、セリパたち
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2885
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 796 #ダブルかめはめ波(悟空)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2886
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 797 #ダブルかめはめ波(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2887
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 798 #ダブルかめはめ波(クリリン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2888
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 799 #ダブルかめはめ波(ヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2889
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 800 #ダブルかめはめ波(ヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2890
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 801 #かめはめ乱舞(親子)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2891
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 802 #アンドロイドストライク
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2892
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 803 #あの時の借りを返すよ！(天津飯と18号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2893
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 804 #あの時の借りを返すぞ！(天津飯と16号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2894
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 805 #借りがあるらしいな！(天津飯と17号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2895
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 806 #あんたも助けるよ！(チャオズと18号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2896
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 807 #お前も助けるぞ！(チャオズと16号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2897
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 808 #今度は俺が助けてやる(チャオズと17号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2898
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 809 #流派を超えた連携(天津飯と亀仙人)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2899
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 47
              battleanimeend = true
            end
          when 810 #流派を超えた連携(チャオズと亀仙人)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2900
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 811 #ダブル魔封波(ピッコロと亀仙人)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2901
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 812 #ダブル魔封波(若者と亀仙人)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2902
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 813 #スピリッツかめはめ波(悟空とバーダック)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2903
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 814 #絶好のチャンス(ゴハンとクリリンとベジータ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1904
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 815 #オレを半殺しにしろ(クリリン、ベジータ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1905
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 816 #超サイヤ人だ孫悟空(悟空、ピッコロ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1906
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 817 #俺たちに不可能はない(超悟空、超ベジータ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2907
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 818 #ダブルロイヤルアタック(超ベジータ、チャオズ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2908
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 819 #地球丸ごと超決戦
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1909
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 820 #やっぱり息の合う二人
            @damage_huttobi = false
            @damage_center = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2910
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 821 #足元がお留守だぜ！
            @damage_huttobi = false
            @damage_center = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2911
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 822 #オラにパワーをくれ！
            #@damage_huttobi = false
            #@damage_center = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2912
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 21
              battleanimeend = true
            end
          when 823 #新狼鶴相打陣
            #@damage_huttobi = false
            #@damage_center = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2913
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 824 #超操気円裂斬
            #@damage_huttobi = false
            #@damage_center = true
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2914
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 825 #烈戦人造人間
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2915
            elsif @battle_anime_result == 3
              #光線系ダメージ
              @damage_huttobi = false
              damage_pattern = 44
              battleanimeend = true
            end
          when 828 #ダブルポコペン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2918
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 829 #ダブルアイビーム(ピッコロと天津飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1919
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 830 #超能力きこうほう改(天津飯と餃子)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2920
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 82
              battleanimeend = true
            end
          when 831 #激烈魔閃光弾
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2921
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 832 #ファイナルバスター
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2922
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 833 #ファイナルかめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2923
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 834 #未来のZ戦士
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2924
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 835 #サイコ気円裂斬
            #@damage_huttobi = false
            #@damage_center = true
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2925
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 837 #ダブルエクスプロージョン(ベジータとトランクス)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2927
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 838 #ダブルエクスプロージョン(未来悟飯とトランクス)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2928
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 839 #ダブルエクスプロージョン(ピッコロとトランクス)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2929
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 840 #ダブルエクスプロージョン(ピッコロ、ベジータ)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2930
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 841 #ダブルエクスプロージョン(ベジータ、未来悟飯)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2931
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 842 #ダブルエクスプロージョン(バーダック、ピッコロ)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2932
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 843 #ダブルエクスプロージョン(バーダック、ベジータ)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2933
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 844 #ダブルエクスプロージョン(バーダック、トランクス)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2934
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 845 #ダブルエクスプロージョン(バーダック、未来悟飯)

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
              @tec_back_small = true
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2935
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 846 #ロイヤルガード(ベ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2936
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 847 #ロイヤルガード(ト)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2937
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 849 #親子乱舞(悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2939
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 850 #親子乱舞(未来悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2940
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 851 #信じる心(クリリンと16号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2941
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 852 #月を破壊する者
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2942
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 853 #フルパワーアウトサイダーショット(バ、トー)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2943
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 854 #フルパワーアウトサイダーショット(バ、セ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2944
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 855 #フルパワーアウトサイダーショット(バ、トテ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2945
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 856 #フルパワーアウトサイダーショット(バ、パ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2946
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 857 #フルパワーアウトサイダーショット(トー、セ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2947
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 858 #フルパワーアウトサイダーショット(トー、トテ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2948
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 859 #フルパワーアウトサイダーショット(トー、パ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2949
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 860 #フルパワーアウトサイダーショット(セ、トテ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2950
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 861 #フルパワーアウトサイダーショット(セ、パ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2951
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 862 #フルパワーアウトサイダーショット(トテ、パ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2952
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 863 #フルパワーアウトサイダーショット(ピ、18)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2953
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 864 #フルパワーアウトサイダーショット(ピ、17)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2954
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 865 #フルパワーアウトサイダーショット(ピ、16)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2955
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 866 #フルパワーアウトサイダーショット(未来悟飯、18)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2956
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 867 #フルパワーアウトサイダーショット(未来悟飯、17)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2957
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 868 #フルパワーアウトサイダーショット(未来悟飯、16)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2958
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 869 #フルパワーアウトサイダーショット(未来悟飯、ベジータ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2959
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 870 #師弟アタック改(ピッコロ、未来悟飯)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2960
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 871 #師弟アタック改(ピッコロ、若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2961
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 872 #弟子コンビアタック(未来悟飯、若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2962
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 873 #オメエもピッコロとおなじけ！(チチ&若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2963
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 874 #あっち行ってけろ改(チチ&ヤムチャ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2964
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 875 #悟空さに近づく出ねえ！(チチ&18号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2965
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 876 #悟空さに近づく出ねえ！(チチ&18号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2966
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 877 #悟空さに近づく出ねえ！(チチ&18号)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2967
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 878 #だいじょうぶかチチ！？(悟空とチチ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2968
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 879 #世話焼かせるんじゃねえ！(バーダックとチチ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2969
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 880 #カカロットが世話になったらしいな！(亀仙人とバーダック)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2970
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 881 #フルパワーアウトサイダーショット(未来悟飯、トーマ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2971
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 882 #フルパワーアウトサイダーショット(未来悟飯、セリパ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2972
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 883 #フルパワーアウトサイダーショット(未来悟飯、トテッポ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2973
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 884 #フルパワーアウトサイダーショット(未来悟飯、パ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2974
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 885 #師弟アタック？(悟飯、若者)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2975
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 886 #決死の超元気玉
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2976
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 48
              battleanimeend = true
            end
          when 887 #自然を愛する者
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2977
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 889 #スーパーどどはめは(ヤムチャとテンシンハンとチャオズ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true if $btl_progress >= 2
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2979
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 311 #痺れ液(カイワレマン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 401
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 312 #痺れ液(キュウコンマン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 401
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 313 #痺れ液(サイバイマン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 403
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 314 #自爆(サイバイマン)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 404
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 317 #エネルギー波(ジンジャー系)

            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 407
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 318 #強力エネルギー波(ジンジャー系)
            @tec_back_small = true

            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 408
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 319 #刀攻撃(ジンジャー系)
            @tec_back_small = true

            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 409
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 618 #刀攻撃(ジンジャー系)
            @tec_back_small = true

            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1708
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 331 #エネルギー波(ニッキー系)

            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 407
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 332 #強力エネルギー波(ニッキー系)
            @tec_back_small = true

            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 408
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 333 #刀攻撃(ニッキー系)
            @tec_back_small = true

            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 409
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 619 #刀攻撃(ニッキー系)
            @tec_back_small = true

            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1709
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 334 #エネルギー波(サンショ系)

            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 424
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 335 #強力エネルギー波(サンショ系)
            #@tec_back_small = true

            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 425
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 620 #連続強力エネルギー波(サンショ系)
            #@tec_back_small = true
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @chr_cutin_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1710
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 336 #エネルギー弾(ガーリック)
            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 426
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 338 #強力エネルギー波(ガーリック)
            @tec_back_small = true
            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 428
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 339 #強力エネルギー波(ガーリック巨大化)
            @tec_back_small = true
            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 429
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 340 #ブラックホール波(ガーリック巨大化)
            @tec_back_small = true

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @chr_cutin_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 430
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 345 #キュイ系爆発波

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1435
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 346 #(キュイ系)連続エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1436
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 348 #(ドドリア系)口から怪光線
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true

              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1438
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 349 #(ドドリア系)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1439
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 354 #(ザーボン変身)スーパーエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1444
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 356 #(ギニュー)スーパーエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1446
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 357 #(ギニュー)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1447
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 360 #(ジース)クラッシャーボール
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1450
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 362 #(バータ)スピードアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1452
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 364 #(リクーム)連続エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1454
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 365 #(リクーム)イレイザーガン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1455
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 367 #(グルド)タイムストップ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1457
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 25
              battleanimeend = true
            end
          when 392,393 #(ジース,バータ)パープルコメットクラッシュ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1482
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 621 #デッドゾーン(ガーリック巨大化)
            @tec_back_small = true

            if @all_attack_count >= 2 && @battle_anime_result == 0
              @chr_cutin_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              @tec_output_back_no = 1
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1711
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 75
              battleanimeend = true
            end

          when 469 #キシーメ電磁ムチ(強
            if @battle_anime_result == 0
              @chr_cutin_flag = true
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 559
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 471 #エビ氷結攻撃(全体)
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @chr_cutin_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              @chr_cutin_flag = true
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 561
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 70
              battleanimeend = true
            end
          when 472 #エビ氷結攻撃
            if @battle_anime_result == 0
              @chr_cutin_flag = true
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 562
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 70
              battleanimeend = true
            end
          when 473 #ミソ皮伸び攻撃
            if @battle_anime_result == 0
              @chr_cutin_flag = true
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 563
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 71
              battleanimeend = true
            end
          when 474 #ミソエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 564
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 475 #ミソ強力エネルギー波
            if @battle_anime_result == 0
              @chr_cutin_flag = true
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 565
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 596 #エネルギーは(Drウィロー)
            @ene_tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 686
            elsif @battle_anime_result == 3

              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true

            end
          when 597 #フォトンストライク(両手エネルギー波(Drウィロー)
            @ene_tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 687
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true

            end
          when 598 #口からエネルギー波(Drウィロー)
            @ene_tec_oozaru = true
            @chr_cutin_flag = true
            if @battle_anime_result == 0

              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 688
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true

            end
          when 599 #ギガンティックボマー(Drウィロー)
            @ene_tec_oozaru = true
            @chr_cutin_flag = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 689
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 600 #プラネットゲイザー(Drウィロー)
            @ene_tec_oozaru = true
            @chr_cutin_flag = true
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 690
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true

            end
          when 385 #爆発波(ターレス
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1475
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 386 #キルドライバー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1476
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 387 #メテオバースト
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1477
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 654 #大猿変身(ターレス)
            @ene_tec_oozaru = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
              @tec_output_back_no = 1 #必殺背景縦
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1744
            elsif @battle_anime_result == 3
              #光線系ダメージ
              #damage_pattern = 26
              battleanimeend = true
            end
          when 652 #ターレス大猿 エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 653 #ターレス大猿 強力エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2499
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 388 #エネルギーは(スラッグ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1478
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 389 #爆発波(スラッグ
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1479
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 390 #ビッグスマッシャー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1480
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 391 #メテオバースト
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1481
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 655 #スラッグ巨大化
            @ene_tec_oozaru = true

            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1745
            elsif @battle_anime_result == 3
              #光線系ダメージ
              #damage_pattern = 26
              battleanimeend = true
            end
          when 677 #エネルギーは(スラッグ巨大化
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 678 #爆発波(スラッグ巨大化
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2498
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 679 #ビッグスマッシャー(スラッグ巨大化
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2499
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          #敵汎用エネルギー波
          when 201,211,221,342,343,344,347,350,353,355,359,361,363,366,384,395..401,406,418,422,426,430,434,438,444,449,455,481,486,491,494,497,502,507,512,518,524,529,531,536,552,560,562,565,567,569,571,574,577,581,589,601,605,609,613,635,635,639,642,646,649,656,660,663,667,670,672,681,687,695
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 402,407,575,587 #フリーザ超能力(全体),ライチー
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_output_back_no = 1
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_output_back_no = 1
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2492
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 25
              battleanimeend = true
            end
          when 403,576,584 #フリーザカッター
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_output_back_no = 3
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2493
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          #連続エネルギー波(全体)
          when 13,202,212,222,337,404,412,414,416,421,425,427,431,435,439,445,450,456,466,498,503,508,513,519,525,532,537,553,561,564,566,572,578,582,590,602,606,610,614,628,629,630,682,688,696
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              #@tec_output_back_no = 1
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2494
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 405,410,675 #デスボール
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_output_back_no = 1
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2495
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 634 #(フリーザ3)デスボール
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1724
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 704 #(フリーザ3)殺されるべきなんだ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1794
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 380 #(超ベジータ)エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1431
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 381 #(超ベジータ)爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1223
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 382 #(超ベジータ)ギャリック砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1224
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 705 #(超ベジータ)スーパーギャリック砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1795
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 408,452,488,539,568,570,573,586,591 #爆発波(クウラ,セル完全体,合体13号,ブロリー,ターレス系,スラッグ系,ゴーストライチー,ハッチヒャック
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              #@tec_output_back_no = 1
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2498
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end

          #強力エネルギー波
          when 203,213,223,409,419,423,432,460,461,463,464,482,487,492,495,499,504,509,514,520,526,533,538,554,583,592,603,607,611,615,622,674,686,693,697
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2499
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 411 #マシーナリーレイン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2501
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 413 #ネイズバインドウェーブ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2503
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 73
              battleanimeend = true
            end
          when 415 #ドーレテリブルラッシュ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2505
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 420,424,443,465 #ドレインライフ セルもここに
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2510
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 429,433 #アクセルダンス
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2519
            elsif @battle_anime_result == 3
              #光線系ダメージ
              @tec_output_back_no = 1
              damage_pattern = 24
              battleanimeend = true
            end
          when 462 #サウザーブレードスラッシュ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2552
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 440,446,451,457 #(セル１)かめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2530
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 441,458 #(セル１)魔貫光殺砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @tec_output_back = false
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2531
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 442,448,453 #(セル１)太陽拳
           if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2532
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 30
              battleanimeend = true
            end
          when 447 #ビッグバンアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_output_back_no = 0
              @tec_back_color = 1
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2537
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 454 #超かめはめは
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2544
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 480 #(ジンコウマン)しびれえき
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @tec_output_back_no = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2

              #必殺技発動
              @battle_anime_result = anime_pattern 2570
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 483 #13号)サイレントアサシン13
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2573
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 484 #13号)デッドリィアサルト
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2574
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 485 #13号)SSデッドリィボンバー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_output_back_no = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2575
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 489 #合体13号)SSデッドリィボンバー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_output_back_no = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2579
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 490 #合体13号)フルパワーSSデッドリィボンバー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              #@tec_output_back_no = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2580
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 493 #14号)アンドロイドチャージ14
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2583
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 496 #15号)アンドロイドストライク15
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2586
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 505 #ボーフル)ギャラテクティックタイラント
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2595
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 506 #ボーフル)ギャラテティックバスター
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2596
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 511 #ゴクア)ギャラテクアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2601
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 71
              battleanimeend = true
            end
          when 515 #ザンギャ)スカイザッパー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2605
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 516,521,527 #ザンギャビドーブージン超能力

            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_output_back_no = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2606
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 25
              battleanimeend = true
            end
          when 522 #ビドー)ギャラクティッククラッシュ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              #@tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2612
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 528 #ブージン)合体超能力
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2618
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 534 #ブロ超)イレイザーキャノン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2624
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 540 #イレイザーブロウ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2630
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 541 #ブロフル)イレイザーキャノン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2631
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 542 #ブロフル)スローイングブラスター
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2632
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 543 #ブロフル)オメガブラスター
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2633
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 545 #アラレ)ウンチ攻撃
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2635
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 25
              battleanimeend = true
            end
          when 546 #アラレ)キーン
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              #@chr_cutin = true
              #@chr_cutin_flag = true
              #@chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2636
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 547 #アラレ)岩攻撃
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @tec_output_back_no = 1
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2637
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 548 #アラレ)ブンブン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2638
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 549 #アラレ)んちゃほう
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2639
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 550 #アラレ)プロレスごっこ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2640
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 555 #オゾ)ミストかめはめ波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2645
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 556 #オゾ)ミストばくれつまこうほう
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2646
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 557 #オゾ)ミストませんこう
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2647
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 558 #オゾ)ミストギャリック砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ

              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2648
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 559 #オゾ)ミスト剣攻撃
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2649
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 563 #アービー系)パワードレイン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2653
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 579 #ゴッドガ)テイルザンバー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2669
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 580 #ゴッドガ)ガードンクラッシャー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2670
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 585 #ライチ)ビッグスマッシャー
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2675
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 41
              battleanimeend = true
            end
          when 588 #ライチ)イレイサーショック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_output_back_no = 7
              #@tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2678
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 593 #ハッチ)リベンジャーチャージ
            #@tec_tyousaiya = true
            $battle_ribe_charge = true
            $battle_ribe_charge_turn = true
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@tec_output_back = false
              @tec_output_back_no = 1
              #@chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2683
            elsif @battle_anime_result == 3
              battleanimeend = true
            end
          when 594 #ハッチ)リベンジャーカノン
            $battle_ribe_charge = false
            if @all_attack_count >= 2 && @battle_anime_result == 0
              #@tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@tec_back_small = true
              #@chr_cutin_flag = true
              @tec_output_back_no = 1
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2684
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 604 #ガッシュ)ラッシュ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2694
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 608 #ビネガー)ラッシュ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2698
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 612 #タード)ラッシュ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2702
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 616 #ゾルド)ラッシュ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2706
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 617 #タード&ゾルド)ダブルアタック
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_output_back_no = 1
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2707
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 623 #ロボット兵 バルカン砲
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2713
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 624 #メタルクウラコア エネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2714
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 625 #メタルクウラコア 口からエネルギー波
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @tec_back_small = true
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2715
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 626 #メタルクウラコア エネルギー吸収
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              #@chr_cutin = true
              #@chr_cutin_flag = true
              #@chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2716
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 77
              battleanimeend = true
            end
          when 627 #メタルクウラコア スーパービッグノヴァ
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              #@chr_cutin = true
              #@chr_cutin_flag = true
              #@chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @tec_output_back_no = 3
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2717
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 631 #タオパイパイ)どどんぱ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              #@tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2431 #2721
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 632 #タオパイパイ)スーパーどどんぱ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2499
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 42
              battleanimeend = true
            end
          when 633 #タオパイパイ)カタナ攻撃
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2723
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 636 #アモンド気円斬
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1726
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 637 #アモンドプラネットボム
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1727
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
         when 640 #コズミックアタック(カカオ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1730
            elsif @battle_anime_result == 3
              #コズミックアタックダメージ
              damage_pattern = 80
              battleanimeend = true
            end
          when 643 #爆発波(ダイーズ
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1733
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 644 #メテオボール(ダイーズ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1734
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 647,650 #ダブルエネルギー波 レズン、ラカセイ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1740
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 657 #エビルクエーサー アンギラ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1747
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 658 #手が伸びる アンギラ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1748
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 661 #エビルグラビティ ドロダボ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1751
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 664 #エビルコメット メダマッチャ
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = true
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1754
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 665 #カエル攻撃 メダマッチャ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1755
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 25 #23
              battleanimeend = true
            end
          when 668 #エビルインパクト ゼエウン
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1758
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 671 #アンギラとメダマッチャ腕伸びるカエル攻撃
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 1761
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 673 #チルド爆発波
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2763
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
         when 683 #パイクーハン(超体当たり)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2773
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 685 #パイクーハン(サンダーフラッシュ)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2775
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 689 #かめはめ波 ブウ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2779
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 23
              battleanimeend = true
            end
          when 690 #巻きつき攻撃 ブウ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2780
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 71
              battleanimeend = true
            end
          when 691 #お菓子光線 ブウ
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2781
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 81
              battleanimeend = true
            end
          when 692 #超爆発波 ブウ
            if @all_attack_count >= 2 && @battle_anime_result == 0
              @tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2782
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 698 #ラッシュ オゾット(変身)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2788
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 22
              battleanimeend = true
            end
          when 699,702 #イグナイトビジョン(オゾット、オゾット変身
            if @all_attack_count >= 2 && @battle_anime_result == 0
              #@tec_output_back = false
              @chr_cutin = true
              @chr_cutin_flag = true
              @chr_cutin_mirror_flag = true
              @tec_back_small = true
              @battle_anime_result = 2
            end
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              #@chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2789
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 43
              battleanimeend = true
            end
          when 700 #カオスバースト オゾット(変身)
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2790
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          when 703 #カオスバースト オゾット
            if @battle_anime_result == 0
              #上から左下に移動
              @battle_anime_result = anime_pattern 31
            elsif @battle_anime_result == 1
              #必殺技発動画面へ
              @chr_cutin_flag = true
              @tec_back_small = true
              @battle_anime_result = anime_pattern 32
            elsif @battle_anime_result == 2
              #必殺技発動
              @battle_anime_result = anime_pattern 2793
            elsif @battle_anime_result == 3
              #光線系ダメージ
              damage_pattern = 44
              battleanimeend = true
            end
          else
            if $battle_test_flag == true
              damage_pattern = @test_damage_pattern
            else
              damage_pattern = 22
            end
            battleanimeend = true
          end
        end
      end
    end

    rescue => e
    #$err_run_process_d3
    #set_err_run_process_msg
      # 例外が発生したときの処理

      p "エラー発生　：" + $err_run_process.to_s,
      "--戦闘シーン情報--",
      "　番号　　　：" + attackpattern.to_s,
      "　進行度　　：" + @battle_anime_result.to_s,
      "　フレーム数：" + @battle_anime_frame.to_s,
      "　攻撃方向　：" + @attackcourse.to_s,
      "　味方キャラ：" + @chanum.to_s + "番目 " + $partyc[@chanum].to_s,
      "　敵キャラ　：" + @enenum.to_s + "番目 " + $battleenemy[@enenum].to_s,
      "--スクリプト情報--",
      "　ErrMsg    ：" + e.message.to_s
      exit #強制終了
    else
      # 例外が発生しなかったときに実行される処理
    ensure
      # 例外の発生有無に関わらず最後に必ず実行する処理
    end

    #発動スキルの表示
    #output_runskill 1 #引数1で攻撃と判断

    output_cutin attackpattern
      #if @battle_anime_frame == battleanimeend + 30
      #  battleanimeend = true
      #end
      #output_back attackpattern                       # 背景更新
      #@back_window.update
      #Graphics.update                   # ゲーム画面を更新
      if battleanimeend != true

        if $battle_test_flag == true
          text = "フレーム数：" + @battle_anime_frame.to_s
          @back_window.contents.draw_text( 15, 25, 300, 28, text)
        end

      Graphics.update                   # ゲーム画面を更新


        if @anime_frame_format == false
          @battle_anime_frame += 1
        else
          @battle_anime_frame = 0
          @anime_frame_format = false
        end

        #戦闘途中終了
        Input.update
        #Sコンボチェック
        if @btl_ani_scombo_new_flag != 0
          scombo_new_flag = $game_switches[@btl_ani_scombo_new_flag]
        else
          scombo_new_flag = false
        end
        if (Input.trigger?(Input::B) || (Input.press?(Input::R) and Input.press?(Input::B))) && $game_variables[96] == 0 && @new_tecspark_flag == false && scombo_new_flag == false || ($game_switches[860] == true && $game_switches[883] == true && scombo_new_flag == false) && (Input.trigger?(Input::B) || (Input.press?(Input::R) and Input.press?(Input::B)))
          #必殺技カットイン
          chr_battle_anime_end
          battleanimeend = true
          return
        end
      end
    end while battleanimeend != true

    #p @attack_hit,damage_pattern
    #@attack_hit = true
    battleanimeend = false
    @battle_anime_result = 0
    @battle_anime_frame = 0

    #発動スキルの表示フレーム数
    @runskill_frame = 0

    #必殺技で攻撃する必要があるか
    if @tec_non_attack == true
      battleanimeend = true
    end

    #ヒットか回避か
    begin
      input_fast_fps
      input_battle_fast_fps if $game_variables[96] == 0
      @back_window.contents.clear
      output_back attackpattern                        # 背景更新
      #戦闘途中終了
      Input.update
      #周回プレイ時はイベント戦闘や初回閃きも回避できるように
      if (Input.trigger?(Input::B) || (Input.press?(Input::R) and Input.press?(Input::B))) && $game_variables[96] == 0 && @new_tecspark_flag == false && scombo_new_flag == false || ($game_switches[860] == true && $game_switches[883] == true && scombo_new_flag == false) && (Input.trigger?(Input::B) || (Input.press?(Input::R) and Input.press?(Input::B)))
        chr_battle_anime_end
        battleanimeend = true
        return
      end
      if @battle_anime_result == 0
        if @attack_hit == true

          #爆発変化させる場合(仮)
          #if @anime_event == false && $game_switches[463] == true

          #end

          @battle_anime_result = anime_pattern damage_pattern
        else
          @battle_anime_result = anime_pattern avoid_anime_no
        end
      else
        battleanimeend = true
      end
      if @output_battle_damage_flag == true
        output_battle_damage if $game_variables[96] == 0
      end
      #output_back attackpattern                       # 背景更新

      #発動スキルの表示

      output_runskill 2 #引数1でヒット用の表示と判断

      if $battle_test_flag == true
        text = "フレーム数：" + @battle_anime_frame.to_s
        @back_window.contents.draw_text( 15, 25, 300, 28, text)
      end
      output_cutin attackpattern
      Graphics.update                   # ゲーム画面を更新

      if @anime_frame_format == false
        @battle_anime_frame += 1
      else
        @battle_anime_frame = 0
        @anime_frame_format = false
      end


    end while battleanimeend != true

    chr_battle_anime_end
  end

  def chr_battle_anime_end

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
    @chay = -200 #キャラ画面範囲外へ
    @eney = -200 #キャラ画面範囲外へ
    @ene_coerce_target_chanum = nil #敵が味方を強制的にターゲットを決める
    Audio.se_stop

    #発動スキル表示用の変数初期化
    $tmp_run_skill = []
    $tmp_run_hit_skill = []
    $tmp_run_kabau_skill = []

    #発動スキルの表示フレーム数
    @runskill_frame = 0
    #発動スキルの表示位置(横)
    @runskill_putx = []
    #発動スキルの表示が完了したフレーム数
    @runskill_lastput_frame = 9999999

    if @all_attack_flag == false
      @tec_output_back_no = 0
      @tec_back_anime_type = 0
      @tec_back_color = 0 #背景色
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
  def output_cutin attackpattern = 0

    #必殺技カットイン

    if @chr_cutin_flag == false
      @chr_cutin = false
    end

    if @enedatenum < $ene_str_no[1] #敵は敵の番号見て格納
      enecut_top_file_name = "Z1_"
    elsif @enedatenum < $ene_str_no[2]
      enecut_top_file_name = "Z2_"
      mainasu = $ene_str_no[1]
      tyousei = 0
    else#if @enedatenum < $ene_str_no[3]
      enecut_top_file_name = "Z3_"
      mainasu = $ene_str_no[2]
      tyousei = 0
    #else
    #  enecut_top_file_name = "ZG_"
    #  mainasu = $ene_str_no[3]
    #  tyousei = 4
    end

    #カットイン出力するかチェック
    put_cutin = true

    #出力しない条件
    #敵がZ1
    #
    if enecut_top_file_name == "Z1_" && @attackcourse == 1 ||
      $game_variables[40] == 0 && @attackcourse == 1 && @chr_cutin_mirror_flag == true
      put_cutin = false

    end

    if @chr_cutin == true && put_cutin == true
      if $btl_progress == 0
        #$btl_top_file_name = "Z1_"
      elsif $btl_progress == 1 || $btl_progress == 2
        if @attackcourse == 0

          if @chr_cutin_mirror_flag == false

            rect,picture = set_battle_cutin_name $partyc[@chanum.to_i]

            #picture = Cache.picture($btl_top_file_name + "味方カットイン")
            #rect = Rect.new(0, 64*($partyc[@chanum.to_i]-3), 640, 64) # 背景上
          else

            if enecut_top_file_name != "Z1_"
              picture = Cache.picture(enecut_top_file_name + "敵カットイン")
              rect = Rect.new(0, 64*($battleenemy[@enenum]-mainasu)+tyousei, 640, 64-tyousei) # 背景上
            end
          end

          if enecut_top_file_name != "Z1_" || @chr_cutin_mirror_flag != true
            @back_window.contents.blt(0 , 256+36,picture,rect)
          end
        else
          if @chr_cutin_mirror_flag == false
            if enecut_top_file_name != "Z1_"
              picture = Cache.picture(enecut_top_file_name + "敵カットイン")
              rect = Rect.new(0, 64*($battleenemy[@enenum]-mainasu)+tyousei, 640, 64-tyousei) # 背景上
            end
          else

            rect,picture = set_battle_cutin_name $partyc[@chanum.to_i]
          end

          if (enecut_top_file_name != "Z1_" || @chr_cutin_mirror_flag != false)
            @back_window.contents.blt(0 , 256+36,picture,rect)
          end
        end

      end
=begin
      elsif $btl_progress == 2
        if @attackcourse == 0

          if @chr_cutin_mirror_flag == false
            rect,picture = set_battle_cutin_name $partyc[@chanum.to_i]
            @back_window.contents.blt(0 , 256+36+4,picture,rect)
          else
            if enecut_top_file_name != "Z1_"
              picture = Cache.picture(enecut_top_file_name + "敵カットイン")
              rect = Rect.new(0, 64*($battleenemy[@enenum]-mainasu)+tyousei, 640, 64-tyousei) # 背景上
              @back_window.contents.blt(0 , 256+36+tyousei,picture,rect)
            end
          end
          if enecut_top_file_name != "Z1_" && @chr_cutin_mirror_flag != true
            @back_window.contents.blt(0 , 256+36,picture,rect)
          end
        else
          if @chr_cutin_mirror_flag == false
            if enecut_top_file_name != "Z1_"
              picture = Cache.picture(enecut_top_file_name + "敵カットイン")
              rect = Rect.new(0, 64*($battleenemy[@enenum]-mainasu)+tyousei, 640, 64-tyousei) # 背景上
              @back_window.contents.blt(0 , 256+36+tyousei,picture,rect)
            end
          else
            rect,picture = set_battle_cutin_name $partyc[@chanum.to_i]
            @back_window.contents.blt(0 , 256+36+4,picture,rect)
          end

        end

      end
=end
    end

  end
  #--------------------------------------------------------------------------
  # ● 背景・色表示
  #--------------------------------------------------------------------------
  def output_back attackpattern = 0
      #@back_window.contents.clear

      if @all_attack_count <= 1
        #背景取得
        picture = Cache.picture($btl_map_top_file_name + "戦闘_背景")
        rect = Rect.new(0, $Battle_MapID*100, 640, 100) # 背景

        if @backx <= 320 && @backx >= -320
          @back_window.contents.blt(@backx-320 , @backy,picture,rect)
          @back_window.contents.blt(@backx+320 , @backy,picture,rect)
        elsif @backx >= 320 then
          @back_window.contents.blt(@backx-320 , @backy,picture,rect)
          @back_window.contents.blt(@backx-960 , @backy,picture,rect)
        elsif @backx <= -320 then
          @back_window.contents.blt(@backx+320 , @backy,picture,rect)
          @back_window.contents.blt(@backx+960 , @backy,picture,rect)
        end
      end


    if $btl_progress == 0
      #$top_file_name = "Z1_"
    elsif $btl_progress == 1
      if @tec_output_back == true
        case @tec_output_back_no

        when 0
          hai_max_size_x = 640
          one_frame_pase = 12
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_上")
          rect = Rect.new(0, 0, hai_max_size_x, 64) # 背景上
          #@back_window.contents.blt(0 , 0,picture,rect)
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 0,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 0,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 0,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 0,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 0,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 0,picture,rect)
          end
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_下")
          rect = Rect.new(0, 0, hai_max_size_x, 64) # 背景下
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 256+36,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 256+36,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 256+36,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 256+36,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 256+36,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 256+36,picture,rect)
          end
          #@back_window.contents.blt(0 , 256+36,picture,rect)

          if @attackcourse == 0
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
          #@back_window.contents.blt(0 , 0,picture,rect)

          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(0, @tec_back-hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(0, @tec_back+hai_max_size_x/2,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(0 , @tec_back-hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(0 , @tec_back-(hai_max_size_x+hai_max_size_x/2),picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(0 , @tec_back+hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(0 , @tec_back+hai_max_size_x+hai_max_size_x/2,picture,rect)
          end

          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右")
          rect = Rect.new(0, 0, 92, hai_max_size_x) # 背景右
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(640-64, @tec_back-hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(640-64, @tec_back+hai_max_size_x/2,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(640-64 , @tec_back-hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(640-64 , @tec_back-(hai_max_size_x+hai_max_size_x/2),picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(640-64 , @tec_back+hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(640-64 , @tec_back+hai_max_size_x+hai_max_size_x/2,picture,rect)
          end
          #@back_window.contents.blt(0 , 256+36,picture,rect)

          #if @attackcourse == 0
            @tec_back -= one_frame_pase
          #else
          #  @tec_back += one_frame_pase
          #end

          if @tec_back >= hai_max_size_x
            @tec_back -= hai_max_size_x
          elsif @tec_back <= -hai_max_size_x
            @tec_back += hai_max_size_x
          end
        when 2#左上、右下
          hai_max_size_x = 238
          hai_max_size_y = hai_max_size_x
          #one_frame_pase = 8
          anime_type_max = 2

          picture = Cache.picture("Z3_戦闘_必殺技_背景_左上")
          picture = Cache.picture("Z3_戦闘_必殺技_背景_左上(赤)") if @tec_back_color == 1
          rect = Rect.new(@tec_back_anime_type*hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景左

          @back_window.contents.blt(0, 0,picture,rect)

          hai_max_size_x = 222
          hai_max_size_y = hai_max_size_x
          picture = Cache.picture("Z3_戦闘_必殺技_背景_右下")
          picture = Cache.picture("Z3_戦闘_必殺技_背景_右下(赤)") if @tec_back_color == 1
          rect = Rect.new(@tec_back_anime_type*hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景右
          @back_window.contents.blt(640-hai_max_size_x , 480-hai_max_size_y-124,picture,rect)
          #@back_window.contents.blt(0 , 256+36,picture,rect)

          if @tec_back_anime_type == anime_type_max
            @tec_back_anime_type = 0
          else
            @tec_back_anime_type += 1
          end
        when 3#右上、左下
          hai_max_size_x = 238
          hai_max_size_y = hai_max_size_x
          #one_frame_pase = 8
          anime_type_max = 2

          picture = Cache.picture("Z3_戦闘_必殺技_背景_右上")
          picture = Cache.picture("Z3_戦闘_必殺技_背景_右上(赤)") if @tec_back_color == 1
          rect = Rect.new(@tec_back_anime_type*hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景左

          @back_window.contents.blt(640-hai_max_size_x, 0,picture,rect)

          hai_max_size_x = 222
          hai_max_size_y = hai_max_size_x
          picture = Cache.picture("Z3_戦闘_必殺技_背景_左下")
          picture = Cache.picture("Z3_戦闘_必殺技_背景_左下(赤)") if @tec_back_color == 1
          rect = Rect.new(@tec_back_anime_type*hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景右
          @back_window.contents.blt(0 , 480-hai_max_size_y-124,picture,rect)
          #@back_window.contents.blt(0 , 256+36,picture,rect)

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
          #hai_max_size_y = 110
          one_frame_pase = 8
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_上")
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_上(赤)") if @tec_back_color == 1
          rect = Rect.new(0, 0, hai_max_size_x, 110) # 背景上
          rect = Rect.new(0, 0, hai_max_size_x, 64) if @tec_back_small == true #背景上小さい
          #@back_window.contents.blt(0 , 0,picture,rect)
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 0,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 0,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 0,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 0,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 0,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 0,picture,rect)
          end
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_下(加工)")
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_下(加工)(赤)") if @tec_back_color == 1
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_下")
          #tyousei_y = 30

          if @tec_back_small == false #背景下小さい
            hai_max_size_y = 114
            tyousei_y = 50
            rect = Rect.new(0, 0, hai_max_size_x, hai_max_size_y) # 背景下
          else
            hai_max_size_y = 60
            tyousei_y = -4
            rect = Rect.new(0, 0, hai_max_size_x, hai_max_size_y) # 背景下
          end

          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 256+36-tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 256+36-tyousei_y,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 256+36-tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 256+36-tyousei_y,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 256+36-tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 256+36-tyousei_y,picture,rect)
          end
          #@back_window.contents.blt(0 , 256+36,picture,rect)

          if @attackcourse == 0
            @tec_back -= one_frame_pase
          else
            @tec_back += one_frame_pase
          end

          if @tec_back >= hai_max_size_x
            @tec_back -= hai_max_size_x
          elsif @tec_back <= -hai_max_size_x
            @tec_back += hai_max_size_x
          end
#=end
        when 1#縦
          hai_max_size_x = 360
          one_frame_pase = 16
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左(加工)")

          rect = Rect.new(0, 0, 94, hai_max_size_x) # 背景左
          #@back_window.contents.blt(0 , 0,picture,rect)

          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(0, @tec_back-hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(0, @tec_back+hai_max_size_x/2,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(0 , @tec_back-hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(0 , @tec_back-(hai_max_size_x+hai_max_size_x/2),picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(0 , @tec_back+hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(0 , @tec_back+hai_max_size_x+hai_max_size_x/2,picture,rect)
          end

          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右(加工)")
          rect = Rect.new(0, 0, 92, hai_max_size_x) # 背景右
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(640-94, @tec_back-hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(640-94, @tec_back+hai_max_size_x/2,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(640-94 , @tec_back-hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(640-94 , @tec_back-(hai_max_size_x+hai_max_size_x/2),picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(640-94 , @tec_back+hai_max_size_x/2,picture,rect)
            @back_window.contents.blt(640-94 , @tec_back+hai_max_size_x+hai_max_size_x/2,picture,rect)
          end
          #@back_window.contents.blt(0 , 256+36,picture,rect)

          #if @attackcourse == 0
            @tec_back -= one_frame_pase
          #else
          #  @tec_back += one_frame_pase
          #end

          if @tec_back >= hai_max_size_x
            @tec_back -= hai_max_size_x
          elsif @tec_back <= -hai_max_size_x
            @tec_back += hai_max_size_x
          end

        when 2#左上、右下
          hai_max_size_x = 238
          hai_max_size_y = hai_max_size_x
          #one_frame_pase = 8
          anime_type_max = 2

          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左上")
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左上(赤)") if @tec_back_color == 1
          rect = Rect.new(@tec_back_anime_type*hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景左

          @back_window.contents.blt(0, 0,picture,rect)

          hai_max_size_x = 222
          hai_max_size_y = hai_max_size_x
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右下")
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右下(赤)") if @tec_back_color == 1
          rect = Rect.new(@tec_back_anime_type*hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景右
          @back_window.contents.blt(640-hai_max_size_x , 480-hai_max_size_y-124,picture,rect)
          #@back_window.contents.blt(0 , 256+36,picture,rect)

          if @tec_back_anime_type == anime_type_max
            @tec_back_anime_type = 0
          else
            @tec_back_anime_type += 1
          end
        when 3#右上、左下
          hai_max_size_x = 238
          hai_max_size_y = hai_max_size_x
          #one_frame_pase = 8
          anime_type_max = 2

          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右上")
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_右上(赤)") if @tec_back_color == 1
          rect = Rect.new(@tec_back_anime_type*hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景左

          @back_window.contents.blt(640-hai_max_size_x, 0,picture,rect)

          hai_max_size_x = 222
          hai_max_size_y = hai_max_size_x
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左下")
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_左下(赤)") if @tec_back_color == 1
          rect = Rect.new(@tec_back_anime_type*hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景右
          @back_window.contents.blt(0 , 480-hai_max_size_y-124,picture,rect)
          #@back_window.contents.blt(0 , 256+36,picture,rect)

          if @tec_back_anime_type == anime_type_max
            @tec_back_anime_type = 0
          else
            @tec_back_anime_type += 1
          end
        when 4 #左上、右上
          anime_type_max = 2
          hai_max_size_x = 176
          hai_max_size_y = 320

          rect = Rect.new(@tec_back_anime_type*hai_max_size_x, 0, hai_max_size_x, hai_max_size_y) # 背景左
          picture = Cache.picture("ZG_戦闘_必殺技_背景_超カメハメ波_左")
          picture = Cache.picture("ZG_戦闘_必殺技_背景_超カメハメ波_左(赤)") if @tec_back_color == 1

          @back_window.contents.blt(0, 18,picture,rect)

          picture = Cache.picture("ZG_戦闘_必殺技_背景_超カメハメ波_右")
          picture = Cache.picture("ZG_戦闘_必殺技_背景_超カメハメ波_右(赤)") if @tec_back_color == 1

          @back_window.contents.blt(640-hai_max_size_x, 18,picture,rect)

          if @tec_back_anime_type == anime_type_max
            @tec_back_anime_type = 0
          else
            @tec_back_anime_type += 1
          end
        when 5#2段ファイナルフラッシュ
          hai_max_size_x = 672
          #hai_max_size_y = 110
          one_frame_pase = 8
          picture = Cache.picture("ZG_戦闘_必殺技_背景(赤)")
          rect = Rect.new(0, 0, hai_max_size_x, 46) # 背景上
          #@back_window.contents.blt(0 , 0,picture,rect)
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 0,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 0,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 0,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 0,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 0,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 0,picture,rect)
          end
          #picture = Cache.picture("ZG_戦闘_必殺技_背景_細い(赤)")
          #rect = Rect.new(0, 0, hai_max_size_x, 28) # 背景下
          tyousei_y = 46
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 128+tyousei_y,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
          end
          rect = Rect.new(0, 0, hai_max_size_x, 42) # 背景下
          tyousei_y = 46*2 + 96
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 128+tyousei_y,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
          end
          #@back_window.contents.blt(0 , 256+36,picture,rect)

          if @attackcourse == 0
            @tec_back -= one_frame_pase
          else
            @tec_back += one_frame_pase
          end

          if @tec_back >= hai_max_size_x
            @tec_back -= hai_max_size_x
          elsif @tec_back <= -hai_max_size_x
            @tec_back += hai_max_size_x
          end
        when 6#バーニングアタック
          hai_max_size_x = 672
          #hai_max_size_y = 110
          one_frame_pase = 8
          picture = Cache.picture("ZG_戦闘_必殺技_背景(赤)_バーニングアタック上")
          rect = Rect.new(0, 0, hai_max_size_x, 110) # 背景上
          #@back_window.contents.blt(0 , 0,picture,rect)
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 0+4,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 0+4,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 0+4,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 0+4,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 0+4,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 0+4,picture,rect)
          end
          #picture = Cache.picture("ZG_戦闘_必殺技_背景_細い(赤)")
          #rect = Rect.new(0, 0, hai_max_size_x, 28) # 背景下
          tyousei_y = 114
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 128+tyousei_y,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
          end
          #@back_window.contents.blt(0 , 256+36,picture,rect)

          if @attackcourse == 0
            @tec_back -= one_frame_pase
          else
            @tec_back += one_frame_pase
          end

          if @tec_back >= hai_max_size_x
            @tec_back -= hai_max_size_x
          elsif @tec_back <= -hai_max_size_x
            @tec_back += hai_max_size_x
          end
        when 7#イレイサーショック
          hai_max_size_x = 672
          #hai_max_size_y = 110
          one_frame_pase = 8
          picture = Cache.picture("ZG_戦闘_必殺技_背景(赤)_イレイサーショック上")
          rect = Rect.new(0, 0, hai_max_size_x, 110) # 背景上
          #@back_window.contents.blt(0 , 0,picture,rect)
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 0+4,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 0+4,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 0+4,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 0+4,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 0+4,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 0+4,picture,rect)
          end
          #picture = Cache.picture("ZG_戦闘_必殺技_背景_細い(赤)")
          #rect = Rect.new(0, 0, hai_max_size_x, 28) # 背景下
          tyousei_y = 130
          if @tec_back <= (hai_max_size_x/2) && @tec_back >= -(hai_max_size_x/2)
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
          elsif @tec_back >= (hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back-(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back-(hai_max_size_x+(hai_max_size_x/2)) , 128+tyousei_y,picture,rect)
          elsif @tec_back <= -(hai_max_size_x/2) then
            @back_window.contents.blt(@tec_back+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
            @back_window.contents.blt(@tec_back+hai_max_size_x+(hai_max_size_x/2) , 128+tyousei_y,picture,rect)
          end
          #@back_window.contents.blt(0 , 256+36,picture,rect)

          if @attackcourse == 0
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

    #背景スクロール
    if @attackcourse == 0
      @backx -= @back_scroll_speed
    else
      @backx += @back_scroll_speed
    end

    if @backx >= 640
      @backx -= 640
    elsif @backx <= -640
      @backx += 640
    end

    #フェード時に非表示が気になるのでここでも表示させる
    output_cutin attackpattern
    #ステータス背景色
    #color = set_skn_color 0
    #@back_window.contents.fill_rect(0,356,680,150,color)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘開始前に実行するスキル
  # 同調とか
  #--------------------------------------------------------------------------
  #引数　n:0味方:1敵
  def run_battle_start_mae_skill(n)
    @tmp_scom_run_skill = []
    if n == 0 #味方

      #味方の攻撃
      for x in 0..$Cardmaxnum

        if $cardset_cha_no[x] == @chanum.to_i

          if @scombo_flag == false

          else
#=================================================================================
#スキル開始
#=================================================================================
            run_skill = [] #実行されたスキルを表示するための一時退避用
            sum_scom_naibu_maxaup = 0 #Sコン内部的にあがる最大値

            #同調
            scom_skillno = [363]#[363,364,696]
            scom_maxa = 0
            scom_maxg = 0
            run_skill = []
            run_doutyou_skill = false
            for y in 0..@btl_ani_scombo_flag_tec.size - 1
              for z in 0..scom_skillno.size - 1
                if chk_skill_learn(scom_skillno[z],@btl_ani_scombo_cha[y])[0] == true
                  run_skill << scom_skillno[z]
                  run_doutyou_skill = true
                end
              end

              if run_doutyou_skill == true
                set_cardno = get_chaselcardno @btl_ani_scombo_cha[y]
                scom_maxa = $carda[set_cardno] if scom_maxa < $carda[set_cardno]
                scom_maxg = $cardg[set_cardno] if scom_maxg < $cardg[set_cardno]
              end
            end

            #発動スキルに追加
            if chk_run_scomskillno(scom_skillno,run_skill) != nil
              @tmp_scom_run_skill << chk_run_scomskillno(scom_skillno,run_skill)
            end

            #発動スキルに追加 ここだけ攻防別で認識させたいので、例外的に個別に指定する
            #if chk_run_scomskillno([363,696],run_skill) != nil
            #  @tmp_scom_run_skill << chk_run_scomskillno([363,696],run_skill)
            #end

            #発動スキルに追加 ここだけ攻防別で認識させたいので、例外的に個別に指定する
            #if chk_run_scomskillno([364,696],run_skill) != nil
            #  @tmp_scom_run_skill << chk_run_scomskillno([363,696],run_skill)
            #end

            #星調整
            if scom_maxa != 0 || scom_maxg != 0
              for y in 0..@btl_ani_scombo_flag_tec.size - 1
                set_cardno = get_chaselcardno @btl_ani_scombo_cha[y]
                #if run_skill.index(696) != nil || run_skill.index(363) != nil
                $carda[set_cardno] = scom_maxa
                #end
                #if run_skill.index(696) != nil || run_skill.index(364) != nil
                $cardg[set_cardno] = scom_maxg
                #end
              end
            end

            #Sコンボ発動で星調整の取得
            #地球育ちのサイヤ人
            scom_skillno = [678,679,680,681,682,683,684,685,686]
            scom_aup = 0
            scom_gup = 0
            run_skill = []
            for y in 0..@btl_ani_scombo_flag_tec.size - 1
              for z in 0..scom_skillno.size - 1
                if chk_skill_learn(scom_skillno[z],@btl_ani_scombo_cha[y])[0] == true
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

            #発動スキルに追加
            if chk_run_scomskillno(scom_skillno,run_skill) != nil
              @tmp_scom_run_skill << chk_run_scomskillno(scom_skillno,run_skill)
            end

            #星調整
            if scom_aup != 0 || scom_gup != 0
              for y in 0..@btl_ani_scombo_flag_tec.size - 1
                @btl_ani_scombo_cha[y]
                #Sコンボ参加者の最大攻撃の星に合わせる
                set_cardno = 0 #キャラクターが選択したカードNoを格納
                #キャラクターが選択したカードNoを取得
                set_cardno = get_chaselcardno @btl_ani_scombo_cha[y]
                $carda[set_cardno] += scom_aup
                $cardg[set_cardno] += scom_gup

                $carda[set_cardno] = 7 if $carda[set_cardno] > 7
                $cardg[set_cardno] = 7 if $cardg[set_cardno] > 7
              end
            end

#=================================================================================
#スキル終わり
#=================================================================================
          end
        end
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● ダメージ計算
  #--------------------------------------------------------------------------
  #引数　n:0味方:1敵
  def damage_calculation(n)
    @attack_hit = true
    @tmp_scom_run_skill = []
    if n == 0 #味方

      #味方の攻撃
      for x in 0..$Cardmaxnum

        if $cardset_cha_no[x] == @chanum.to_i

          if $cha_set_action[@chanum] >= 11
            @tec_power = $data_skills[$cha_set_action[@chanum] - 10].base_damage

            #熟練度でのダメージ計算
            #p $game_variables[$data_skills[$cha_set_action[@chanum] - 10].id + 100]
            if $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] != 0 && $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] != nil
            #if $game_variables[$data_skills[$cha_set_action[@chanum] - 10].id + 100] != 0
              skill_level = $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id]
              #ダメージ計算最大数に調整する
              skill_level = $cha_add_dmg_skill_level_max if skill_level >= $cha_add_dmg_skill_level_max
              #skill_level = $game_variables[$data_skills[$cha_set_action[@chanum] - 10].id + 100]
              skill_level = skill_level.prec_f
              skill_level = (100+skill_level)
              skill_level = skill_level/100

              #p skill_level
              #p @tec_power = (@tec_power*skill_level).ceil
              @tec_power = (@tec_power*skill_level).ceil

              #熟練度が1000を超えていた場合
              if $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] > ($cha_add_dmg_skill_level_max + 1)
                skill_level2 = $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] - $cha_add_dmg_skill_level_max
                skill_level2 = skill_level2.prec_f
                skill_level2 = skill_level2/$cha_add_dmg_atk_ratio

                @tec_power = (@tec_power+skill_level2).ceil
              end

              #大猿で必殺技の攻撃力アップ技か
              if $cha_bigsize_on[@chanum.to_i] == true
                @tec_power = (@tec_power.to_i * 2).prec_i
              end
            end
          end

          if @scombo_flag == false

            if $cha_set_action[@chanum] >= 11
              #必殺技
              @battledamage = (($game_actors[$partyc[@chanum.to_i]].atk + @tec_power) * 8 * ($carda[x] + 7 + rand(2) + 1)) / ($data_enemies[@enedatenum].def * ($enecardg[@enenum] + 7)/3)
            else
              #通常攻撃
              #nil対策
              $cha_normal_attack_level[$partyc[@chanum]] = 0 if $cha_normal_attack_level[$partyc[@chanum]] == nil

              @tec_power = 3

              skill_level = $cha_normal_attack_level[$partyc[@chanum]]
              #ダメージ計算最大数に調整する
              skill_level = $cha_add_dmg_skill_level_max if skill_level >= $cha_add_dmg_skill_level_max

              skill_level = skill_level.prec_f
              skill_level = (100+skill_level)
              skill_level = skill_level/100

              @tec_power = (@tec_power*skill_level).ceil

              #熟練度が1000を超えていた場合
              if $cha_normal_attack_level[$partyc[@chanum]] > ($cha_add_dmg_skill_level_max + 1)
                skill_level2 = $cha_normal_attack_level[$partyc[@chanum]] - $cha_add_dmg_skill_level_max
                skill_level2 = skill_level2.prec_f
                skill_level2 = skill_level2/$cha_add_dmg_atk_ratio

                @tec_power = (@tec_power+skill_level2).ceil
              end

              @battledamage = (($game_actors[$partyc[@chanum.to_i]].atk + @tec_power) * 8 * ($carda[x] + 7 + rand(2) + 1)) / ($data_enemies[@enedatenum].def * ($enecardg[@enenum] + 7)/3)
              #p $game_actors[$partyc[@chanum.to_i]].atk,@tec_power,$cha_normal_attack_level[$partyc[@chanum]]
            end
          else
            #スパーキングコンボの場合は全員の攻撃力と技の攻撃力を足してさらに攻撃カードがほしと同じになる
            #さらに、レベル分力をアップ
            chanum_atk = 0
            max_carda = 0 #参加者の最大攻撃星最大値
            #Sコンボのそもそもの攻撃力を追加
            @tec_power = $data_skills[($cha_set_action[@chanum] - 10)].base_damage
            #p @tec_power

#=================================================================================
#スキル開始
#=================================================================================
            run_skill = [] #実行されたスキルを表示するための一時退避用
            sum_scom_naibu_maxaup = 0 #Sコン内部的にあがる最大値

            #スキルで星の数調整
            #武泰斗の教え
            scom_skillno = [687,688,689,690,691,692,693,694,695]
            scom_max_aup = 0
            run_skill = []
            for y in 0..@btl_ani_scombo_flag_tec.size - 1
              for z in 0..scom_skillno.size - 1
                if chk_skill_learn(scom_skillno[z],@btl_ani_scombo_cha[y])[0] == true
                  run_skill << scom_skillno[z]
                  if scom_max_aup < $cha_skill_a_hoshi[scom_skillno[z]]
                    scom_max_aup = $cha_skill_a_hoshi[scom_skillno[z]]
                  end
                end
              end
            end

            #発動スキルに追加
            if chk_run_scomskillno(scom_skillno,run_skill) != nil
              @tmp_scom_run_skill << chk_run_scomskillno(scom_skillno,run_skill)
            end

            #スキルの効果分を加算
            sum_scom_naibu_maxaup += scom_max_aup

            #スキルで星の数調整
            #連携
            scom_skillno = [671,672,673,674,675,676,677]
            scom_max_aup = 0
            run_skill = []
            for y in 0..@btl_ani_scombo_flag_tec.size - 1
              for z in 0..scom_skillno.size - 1
                if chk_skill_learn(scom_skillno[z],@btl_ani_scombo_cha[y])[0] == true
                  run_skill << scom_skillno[z]
                  if scom_max_aup < $cha_skill_a_hoshi[scom_skillno[z]]
                    scom_max_aup = $cha_skill_a_hoshi[scom_skillno[z]]
                  end
                end
              end
            end

            #発動スキルに追加
            if chk_run_scomskillno(scom_skillno,run_skill) != nil
              @tmp_scom_run_skill << chk_run_scomskillno(scom_skillno,run_skill)
            end

            #スキルの効果分を加算
            sum_scom_naibu_maxaup += scom_max_aup

#=================================================================================
#スキル終わり
#=================================================================================

            for y in 0..@btl_ani_scombo_flag_tec.size - 1
              scombo_tec_power = $data_skills[@btl_ani_scombo_flag_tec[y]].base_damage
              if $cha_skill_level[@btl_ani_scombo_flag_tec[y]] != 0 && $cha_skill_level[@btl_ani_scombo_flag_tec[y]] != nil
                skill_level = $cha_skill_level[@btl_ani_scombo_flag_tec[y]]
                #ダメージ計算最大数に調整する
                skill_level = $cha_add_dmg_skill_level_max if skill_level >= $cha_add_dmg_skill_level_max
                skill_level = skill_level.prec_f
                skill_level = (100+skill_level)
                skill_level = skill_level/100
                @tec_power += (scombo_tec_power*skill_level).ceil

                #熟練度が1000を超えていた場合
                if $cha_skill_level[@btl_ani_scombo_flag_tec[y]] > ($cha_add_dmg_skill_level_max + 1)
                  skill_level2 = $cha_skill_level[@btl_ani_scombo_flag_tec[y]] - $cha_add_dmg_skill_level_max
                  skill_level2 = skill_level2.prec_f
                  skill_level2 = skill_level2/$cha_add_dmg_atk_ratio

                  @tec_power = (@tec_power+skill_level2).ceil

                end

              else
                @tec_power += scombo_tec_power
                #p @tec_power
              end
              #攻撃力
              chanum_atk += $game_actors[@btl_ani_scombo_cha[y]].atk
              #レベル
              #chanum_atk += ($game_actors[@btl_ani_scombo_cha[y]].level / 2)
              chanum_atk += ($game_actors[@btl_ani_scombo_cha[y]].level)
              #p "味方攻撃力合計" + chanum_atk.to_s,"必殺技攻撃力合計" + @tec_power.to_s

              #Sコンボ参加者の最大攻撃の星に合わせる
              set_cardno = 0 #キャラクターが選択したカードNoを格納
              #キャラクターが選択したカードNoを取得
              set_cardno = get_chaselcardno @btl_ani_scombo_cha[y]
              if max_carda < $carda[set_cardno]
                max_carda = $carda[set_cardno]
              end
            end

            #Sコンボの使用回数分攻撃力を追加
            if $cha_skill_level[($cha_set_action[@chanum] - 10)] == nil
              $cha_skill_level[($cha_set_action[@chanum] - 10)] = 0
            end
            #回数は人数 / 2 (人数が多いのが損にならないように)
            #人数の係数計算(3人以降は1人に応じて1.2倍ずつ熟練度の効果が増加する)
            tec_size_keisuu = 1.0

            if @btl_ani_scombo_flag_tec.size.to_i > 2
              tec_size_keisuu = 1.0 + ((@btl_ani_scombo_flag_tec.size.to_i - 2) * 0.2)
            end

            @tec_power += ($cha_skill_level[($cha_set_action[@chanum] - 10)].to_f * (@btl_ani_scombo_flag_tec.size.to_i.to_f / 2) * tec_size_keisuu).ceil

            #Sコンボの参加人数で星の数調整
            max_carda += (@btl_ani_scombo_flag_tec.size - 2)

            #スキルの効果分を加算(内部処理のみ変えるもの)
            max_carda += sum_scom_naibu_maxaup

            #Zを超えていたらZにする
            if max_carda > 7
              max_carda = 7
            end

            #ダメージ再集計算
            @battledamage = ((chanum_atk + @tec_power) * 8 * (max_carda + 7 + rand(2) + 1)) / ($data_enemies[@enedatenum].def * ($enecardg[@enenum] + 7)/3)

            #常にZ
            #@battledamage = ((chanum_atk + @tec_power) * 8 * (7 + 7 + rand(2) + 1)) / ($data_enemies[@enedatenum].def * ($enecardg[@enenum] + 7)/3)
          end

          #スーパーサイヤ人ならばダメージ増加
          #Sコンボ用に参加者もチェックする処理
          temp_cha_no = []
          if $data_skills[$cha_set_action[@chanum]-10].element_set.index(33) != nil
            #使用技がSコンボだった
            #p "Sコンボである"
            temp_cha_no.concat($tmp_btl_ani_scombo_cha)
          else
            #通常攻撃または一人の必殺技だった
            #p "Sコンボじゃない"
            temp_cha_no.concat([$partyc[@chanum.to_i]])
          end

          attacksupersaiyairu = false
          for z in 0..temp_cha_no.size - 1
            if $game_actors[temp_cha_no[z]].class_id == 9
              attacksupersaiyairu = true
            end
          end

          if attacksupersaiyairu == true
          #if $game_actors[$partyc[@chanum.to_i]].class_id == 9
          ###if $partyc[@chanum.to_i] == 14 || $partyc[@chanum.to_i] == 17 || $partyc[@chanum.to_i] == 18 || $partyc[@chanum.to_i] == 19
            @battledamage = (@battledamage.to_i * 1.3).prec_i
          end

          #大猿ならばダメージ増加
          #if $partyc[@chanum.to_i] == 5 || $partyc[@chanum.to_i] == 27 || $partyc[@chanum.to_i] == 28 || $partyc[@chanum.to_i] == 29 || $partyc[@chanum.to_i] == 30

            if $cha_bigsize_on[@chanum.to_i] == true
              @battledamage = (@battledamage.to_i * 1.5).prec_i
            end
          #end

          #流派がそろったときの処理
          if $game_actors[$partyc[@chanum.to_i]].class_id-1 == $cardi[x] || $cha_power_up[@chanum] == true || @skill_kiup_flag == true #スキル気をためるが有効になったか
            @battledamage = (@battledamage.to_i * 1.3).prec_i
          end

          if $ene_defense_up == true #防御力がアップしていればダメージ減少
            @battledamage = (@battledamage*0.7).prec_i
          end

          #スキルのダメージ調整
          @battledamage = set_damage_add $partyc[@chanum.to_i],@enedatenum,@battledamage,0,$cha_set_action[@chanum],@enenum

          #Sコンボのスキル表示を追加
          $tmp_run_skill += @tmp_scom_run_skill

          #必殺技でかつダメージなしの技であればダメージを0に
          if $cha_set_action[@chanum] > 10
            if $data_skills[$cha_set_action[@chanum]-10].element_set.index(11) != nil
            #if $cha_set_action[@chanum] == ENE_STOP_TEC #超能力の場合 ダメージなし
              @battledamage = 0
            end
          end
          #p (($data_enemies[@enedatenum].agi * 1.6 + $enecardg[@enenum]) - ($game_actors[$partyc[@chanum.to_i]].agi * 1.1 + $carda[x])).prec_i
          avoid = ((($data_enemies[@enedatenum].agi * 1.2 + $enecardg[@enenum])/3) - (($game_actors[$partyc[@chanum.to_i]].agi * 1.1 + $carda[x])/3)).prec_i
          #p $data_skills[$cha_set_action[@chanum]-10].element_set.index(29),$cha_set_action[@chanum]-10
          if 0 < avoid
            #p (($data_enemies[@enedatenum].agi * 1.2 + $enecardg[@enenum]) - ($game_actors[$partyc[@chanum.to_i]].agi * 1.1 + $carda[x])).prec_i
            #味方の攻撃が必ず当たるフラグがONの場合は必ず当たる　回避優先
            #かつ必中スキルを覚えていない
            if rand(100)+1 < avoid && $game_switches[129] == false && $data_skills[$cha_set_action[@chanum]-10].element_set.index(29) == nil && chk_skill_learn(389,$partyc[@chanum.to_i])[0] == false
              @attack_hit = false
              @battledamage = 0
            end
          end


          #敵攻撃回避フラグがONの場合は必ず回避
          if $game_switches[18] == true || @event_cha_atc_hit[@chanum] == true
            @attack_hit = false
            @battledamage = 0
          end

          #変数味方攻撃力n倍が0以外なら倍率をかける
          @battledamage = (@battledamage * $game_variables[81]).prec_i if $game_variables[81] != 0
        end
      end

      #ヒットスキルを取得(味方)
      get_attack_hit_skill @chanum.to_i,@enenum,@attack_hit,@attackcourse,$cha_set_action[@chanum],@battledamage

      #@battledamage
    else
      #テキの攻撃
      for x in 0..$Cardmaxnum
        if $cardset_cha_no[x] == @chanum.to_i
          tmp_tec_power = 0
          @tec_power = 0
          if @ene_set_action >= 11

            tmp_tec_power = $data_skills[@ene_set_action-10].base_damage
            @tec_power = ($data_enemies[@enedatenum].atk.prec_f * (tmp_tec_power.prec_f / 100)).prec_i - $data_enemies[@enedatenum].atk
            #p @tec_power,$data_enemies[@enedatenum].atk,tmp_tec_power
            #p ($data_enemies[@enedatenum].atk.prec_f * (@tec_power.prec_f / 100)).prec_i,$data_enemies[@enedatenum].atk,@tec_power
          end

          #p $data_enemies[@enedatenum].atk,@enedatenum
          #p @tec_power
          @battledamage = (($data_enemies[@enedatenum].atk + @tec_power) * 8 * ($enecarda[@enenum] + 7 + rand(2) + 1)) / ($game_actors[$partyc[@chanum.to_i]].def * ($cardg[x] + 7)/3)
          #流派がそろったときの処理
          if $data_enemies[@enedatenum].hit-1 == $enecardi[@enenum] || $ene_power_up[@enenum] == true
            @battledamage = (@battledamage.to_i * 1.2).prec_i
          end

          #p $game_actors[$partyc[@chanum.to_i]]
          #スーパーサイヤ人ならばダメージ減少
          #p $game_actors[$partyc[@chanum.to_i]].class_id
          if $game_actors[$partyc[@chanum.to_i]].class_id == 9
          #if $partyc[@chanum.to_i] == 14 || $partyc[@chanum.to_i] == 17 || $partyc[@chanum.to_i] == 18 || $partyc[@chanum.to_i] == 19
            @battledamage = (@battledamage*0.85).prec_i
          end

          #大猿ならばダメージ減少
          #if $partyc[@chanum.to_i] == 27 || $partyc[@chanum.to_i] == 28 || $partyc[@chanum.to_i] == 29 || $partyc[@chanum.to_i] == 30

            if $cha_bigsize_on[@chanum.to_i] == true
              @battledamage = (@battledamage.to_i * 0.7).prec_i
            end
          #end

          #防御アップ状態であれば
          if $one_turn_cha_defense_up == true || $cha_defense_up[@chanum.to_i] == true #防御力がアップしていればダメージ減少
            @battledamage = (@battledamage*0.7).prec_i
          end

          #スキルのダメージ調整
          @battledamage = set_damage_add $partyc[@chanum.to_i],@enedatenum,@battledamage,1,0,@enenum

          #必殺技でかつダメージなしの技であればダメージを0に
          if @ene_set_action > 10
            if $data_skills[@ene_set_action-10].element_set.index(11) != nil
            #if $cha_set_action[@chanum] == ENE_STOP_TEC #超能力の場合 ダメージなし
              @battledamage = 0
            end
          end

          #p (($game_actors[$partyc[@chanum.to_i]].agi * 1.6 + $cardg[x]) - ($data_enemies[@enedatenum].agi * 1.1 + $enecarda[@enenum]) ).prec_i
          avoid = ((($game_actors[$partyc[@chanum.to_i]].agi * 1.2 + $cardg[x])/3) - (($data_enemies[@enedatenum].agi * 1.1 + $enecarda[@enenum]))/3).prec_i
          avoid = get_avoid_add $partyc[@chanum.to_i],avoid
          if 0 < avoid
            #p (($game_actors[$partyc[@chanum.to_i]].agi * 1.2 + $cardg[x]) - ($data_enemies[@enedatenum].agi * 1.1 + $enecarda[@enenum]) ).prec_i
            #敵の攻撃が必ず当たるフラグがONの場合は必ず当たる　回避優先
            if rand(100)+1 < avoid && $game_switches[130] == false && $data_skills[@ene_set_action-10].element_set.index(29) == nil
              @attack_hit = false
              #@battledamage = 0
            end
          end

          #不惜身命====================================================
          if chk_skill_learn(642,$partyc[@chanum.to_i])[0] == true || #不惜身命9
            chk_skill_learn(641,$partyc[@chanum.to_i])[0] == true || #不惜身命8
            chk_skill_learn(640,$partyc[@chanum.to_i])[0] == true || #不惜身命7
            chk_skill_learn(639,$partyc[@chanum.to_i])[0] == true || #不惜身命6
            chk_skill_learn(638,$partyc[@chanum.to_i])[0] == true || #不惜身命5
            chk_skill_learn(637,$partyc[@chanum.to_i])[0] == true || #不惜身命4
            chk_skill_learn(636,$partyc[@chanum.to_i])[0] == true || #不惜身命3
            chk_skill_learn(635,$partyc[@chanum.to_i])[0] == true || #不惜身命2
            chk_skill_learn(634,$partyc[@chanum.to_i])[0] == true #不惜身命1
            @attack_hit = true
          end

          #カードでの回避
          if $cha_kaihi_card_flag[@chanum] == true
            @attack_hit = false
            #@battledamage = 0
          end

          #味方攻撃回避フラグがONの場合は必ず回避
          if $game_switches[17] == true || @event_atc_hit[@enenum] == true
            @attack_hit = false
            #@battledamage = 0
          end

          #攻撃回避ならダメージ0
          if @attack_hit == false
            @battledamage = 0
          end
          #変数味方攻撃力n倍が0以外なら倍率をかける
          @battledamage = (@battledamage * $game_variables[82]).prec_i if $game_variables[82] != 0
          #ヒットスキルを取得(敵)
          #get_attack_hit_skill @chanum.to_i,@enenum,@attack_hit,@attackcourse,0
          #敵の攻撃も送るようにしてみる
          get_attack_hit_skill @chanum.to_i,@enenum,@attack_hit,@attackcourse,@ene_set_action,@battledamage
        end

      end



    end
    #強襲サイヤ人ダメージ
    #攻撃力×8×(星の数＋７)＋0.799X))÷((漢数字＋7)×防御側BP×防御力

    @tec_power = 0  #必殺技攻撃力初期化



  end

  #--------------------------------------------------------------------------
  # ● 戦闘ダメージ処理(死亡したかも判定)
  #--------------------------------------------------------------------------
  def chk_battle_damage
    if @attackcourse == 0
      # 敵がダメージ
      #戦闘練習時以外はHPを減らす
      if $game_switches[1305] != true
        $enehp[@enenum] -= @battledamage
      else
        #1ターンのダメージ計算
        $game_variables[425] += @battledamage
      end



      #p $enehp[@enenum],@battledamage

      #味方攻撃ダメージ合計
      $tmp_cha_attack_damege[$partyc[@chanum.to_i]] = 0 if $tmp_cha_attack_damege[$partyc[@chanum.to_i]] == nil
      $tmp_cha_attack_damege[$partyc[@chanum.to_i]] += @battledamage

      #味方攻撃回数
      $tmp_cha_attack_count[$partyc[@chanum.to_i]] = 0 if $tmp_cha_attack_count[$partyc[@chanum.to_i]] == nil
      $tmp_cha_attack_count[$partyc[@chanum.to_i]] += 1

      #最高ダメージ、キャラ一時保存
      if $game_variables[205] < @battledamage
        $game_variables[205] = @battledamage
        $game_variables[206] = $partyc[@chanum.to_i]
        $game_variables[215] = $battleenemy[@enenum]
      end
      if $enehp[@enenum] <= 0 #敵死亡判定
        $enedeadchk[@enenum] = true
        $enehp[@enenum] = 0
        $battle_enedead_cha_no[@enenum] = $partyc[@chanum.to_i] #とどめを刺した味方キャラを格納
      end
      if @attack_hit == true
        if $cha_set_action[@chanum] > 10
          if $data_skills[$cha_set_action[@chanum]-10].element_set.index(12) != nil || $data_skills[$cha_set_action[@chanum]-10].element_set.index(13) != nil || $data_skills[$cha_set_action[@chanum]-10].element_set.index(14) != nil
          #if $cha_set_action[@chanum] == ENE_STOP_TEC || $cha_set_action[@chanum] == ENE_STOP_TEC2 || $cha_set_action[@chanum] == ENE_STOP_TEC + 1
            for x in 0..$Cardmaxnum
              if $cardset_cha_no[x] == @chanum.to_i

                #超能力(太陽拳はコメントアウトした)
                if $data_skills[$cha_set_action[@chanum]-10].element_set.index(12) != nil #|| $data_skills[$cha_set_action[@chanum]-10].element_set.index(14) != nil
                  $ene_stop_num[@enenum] += STOP_TURN

                  #流派一致でさらに止める
                  if $game_actors[$partyc[@chanum.to_i]].class_id-1 == $cardi[x]
                    $ene_stop_num[@enenum] += STOP_TURN
                  end
                end

                #流派一致で止める技
                if $game_actors[$partyc[@chanum.to_i]].class_id-1 == $cardi[x] && $data_skills[$cha_set_action[@chanum]-10].element_set.index(13) != nil
                  $ene_stop_num[@enenum] += STOP_TURN
                end

                #太陽拳
                if $data_skills[$cha_set_action[@chanum]-10].element_set.index(14) != nil
                  $ene_stop_num[@enenum] += STOP_TURN
                end
              end
            end
          end
        end

        #大ざる解除用 大猿 シッポ 尻尾 気円斬 刀
        if $data_skills[$cha_set_action[@chanum]-10].element_set.index(25) != nil

          #ベジータ
          $battleenemy[@enenum] = 12 if $battleenemy[@enenum] == 26

          #ターレス
          $battleenemy[@enenum] = 233 if $battleenemy[@enenum] == 222
          $battleenemy[@enenum] = 59 if $battleenemy[@enenum] == 70

        end
      end

    else
      # 味方がダメージ
      $game_actors[$partyc[@chanum.to_i]].hp -= @battledamage

      #HPが0以下かつ、やせがまんが有効の場合はHPを1にする。
      if $game_actors[$partyc[@chanum.to_i]].hp <= 0 && $btl_yasegaman_on_flag == true
        $game_actors[$partyc[@chanum.to_i]].hp = 1
      end

      # ダメージが0以外ならヒットしたと判定
      if @battledamage != 0
        $one_turn_cha_hit_num[$cardset_cha_no.index(@chanum.to_i)] += 1
      end
      #吸収
      if $data_skills[@ene_set_action-10].element_set.index(15) != nil
        $enehp[@enenum] += @battledamage

        #最大値を超えたら最大値にあわせる
        $enehp[@enenum] = $data_enemies[@enedatenum].maxhp if $data_enemies[@enedatenum].maxhp < $enehp[@enenum]
      end

      if @attack_hit == true

        #スキル鋼の意思か慈愛の心を取得していなければ、超能力効果を実行する
        #動きを止める
        if (chk_haganenoishirun($partyc[@chanum]) != true && chk_ziairun($partyc[@chanum]) != true)
          if $data_skills[@ene_set_action-10].element_set.index(12) != nil || $data_skills[@ene_set_action-10].element_set.index(14) != nil

            $cha_stop_num[@chanum] += STOP_TURN
            if $full_cha_stop_num == nil || $full_cha_stop_num == [] || $full_cha_stop_num[$partyc[@chanum]] == nil
              $full_cha_stop_num[$partyc[@chanum]] = 0
            end
            $full_cha_stop_num[$partyc[@chanum]] += STOP_TURN
          end
        end

        #流派一致で動きを止める
        if (chk_haganenoishirun($partyc[@chanum]) != true && chk_ziairun($partyc[@chanum]) != true)
          if $data_enemies[@enedatenum].hit-1 == $enecardi[@enenum] && $data_skills[@ene_set_action-10].element_set.index(13) != nil
            $cha_stop_num[@chanum] += STOP_TURN
            if $full_cha_stop_num == nil || $full_cha_stop_num == [] || $full_cha_stop_num[$partyc[@chanum]] == nil
              $full_cha_stop_num[$partyc[@chanum]] = 0
            end
            $full_cha_stop_num[$partyc[@chanum]] += STOP_TURN
          end
        end

        #尻尾切る
        if $data_skills[@ene_set_action-10].element_set.index(25) != nil
          case $partyc[@chanum]

          when 27 #トーマ
            oozarucha = 1
          when 28 #セリパ
            oozarucha = 2
          when 29 #トテッポ
            oozarucha = 3
          when 30 #パンブーキン
            oozarucha = 4
          when 5 #悟飯
            oozarucha = 5
          end
          $cha_bigsize_on[@chanum] = false
          off_oozaru oozarucha

        end

        #自爆
        if $data_skills[@ene_set_action-10].element_set.index(60) != nil
          $enedeadchk[@enenum] = true
          $eneselfdeadchk[@enenum] = true
          $enehp[@enenum] = 0
        end
      end
      #味方防御ダメージ合計
      $tmp_cha_gard_damege[$partyc[@chanum.to_i]] = 0 if $tmp_cha_gard_damege[$partyc[@chanum.to_i]] == nil
      $tmp_cha_gard_damege[$partyc[@chanum.to_i]] += @battledamage

      #味方防御回数
      $tmp_cha_gard_count[$partyc[@chanum.to_i]] = 0 if $tmp_cha_gard_count[$partyc[@chanum.to_i]] == nil
      $tmp_cha_gard_count[$partyc[@chanum.to_i]] += 1

      #最高ダメージ、キャラ一時保存
      if $game_variables[209] < @battledamage
        $game_variables[209] = @battledamage
        $game_variables[210] = $battleenemy[@enenum]
        $game_variables[217] = $partyc[@chanum.to_i]
      end
      if $game_actors[$partyc[@chanum.to_i]].hp <= 0 #味方死亡判定
        $chadeadchk[@chanum] = true
      end
    end

    #get_attack_hit_skill $partyc[@chanum.to_i],@enenum,@attack_hit,@attackcourse
    #get_attack_hit_skill @chanum.to_i,@enenum,@attack_hit,@attackcourse
  end

  #--------------------------------------------------------------------------
  # ● 攻撃アニメ変更
  #--------------------------------------------------------------------------
  # 引数：aord:攻撃か防御か n:戦闘アニメNo
  def battle_anime_change aord,n

    if aord == 0
      if @attackcourse == 0 then
        if $cha_bigsize_on[@chanum.to_i] != true
          @charect = Rect.new(0 , 0+(96*n), 96, 96)
        else
          @charect = Rect.new(0 ,192*n, 192, 192)
        end
      else
        #@enerect = Rect.new(0 , 0+(96*n), 96, 96)
        #巨大キャラかチェック
        if $data_enemies[@enedatenum].element_ranks[23] != 1
          @enerect = Rect.new(0 ,96*n, 96, 96)
        else
          @enerect = Rect.new(0 ,192*n, 192, 192)
        end
      end
    else
      if @attackcourse == 0 then
        if $data_enemies[@enedatenum].element_ranks[23] != 1
          @enerect = Rect.new(0 ,96*n, 96, 96)
        else
          @enerect = Rect.new(0 ,192*n, 192, 192)
        end
      else
        #@charect = Rect.new(0 , 0+(96*n), 96, 96)
        if $cha_bigsize_on[@chanum.to_i] != true
          @charect = Rect.new(0 , 0+(96*n), 96, 96)
        else
          @charect = Rect.new(0 ,192*n, 192, 192)
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
  def put_kaihianime ag,put_x,put_y

    tyousei_x = 0
    if @attackcourse == 0 && ag == "g" || @attackcourse == 1 && ag == "a"

      if ag == "a"
        tyousei_x = -24
      else
        tyousei_x = 24
      end

      #敵側取得表示
      if $data_enemies[@enedatenum].element_ranks[23] != 1
        picture = Cache.picture("戦闘アニメ") #ダメージ表示
        rect = Rect.new(0,48, 64, 64)
        @back_window.contents.blt(put_x,put_y,picture,rect)
      else
        picture = Cache.picture("戦闘アニメ96×96用回避") #ダメージ表示
        rect = Rect.new(0,0, 128, 128)
        @back_window.contents.blt(put_x+tyousei_x,put_y-32,picture,rect)
      end

    else
      if ag == "a"
        tyousei_x = 72
      else
        tyousei_x = 72
      end
      #味方側取得表示
      if $cha_bigsize_on[@chanum] != true
        picture = Cache.picture("戦闘アニメ") #ダメージ表示
        rect = Rect.new(0,48, 64, 64)
        @back_window.contents.blt(put_x,put_y,picture,rect)
      else
        picture = Cache.picture("戦闘アニメ96×96用回避") #ダメージ表示
        rect = Rect.new(0,0, 128, 128)
        #@back_window.contents.blt(@chax+8-64,@chay+16+500-32,picture,rect)
        @back_window.contents.blt(put_x-tyousei_x,put_y-32,picture,rect)
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● 戦闘キャラ画面範囲外へ
  #--------------------------------------------------------------------------
  def set_chr_display_out
    if @attackcourse == 0
      @output_anime_type = 0
      @chay = -200 #キャラ画面範囲外へ
      @enex = CENTER_ENEX
      @eney = STANDARD_ENEY
    else
      @eney = -200 #キャラ画面範囲外へ
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
  def back_anime_pattern n ,back_x=0,back_y=0,mirror_pattern=@attackcourse

    case n

    when 1 #衝撃波系横

      if @attackcourse == 0 && $data_enemies[@enedatenum].element_ranks[23] == 1 || @attackcourse == 1 && $cha_bigsize_on[@chanum] == true #|| @attackcourse == 1 && $data_enemies[@enedatenum].element_ranks[23] == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_衝撃波系") #ダメージ表示用
        rect = Rect.new(0, @back_anime_type*180,640,42)
        @back_window.contents.blt(0,80-48,picture,rect)
        rect = Rect.new(0, 138+@back_anime_type*180,640,42)
        @back_window.contents.blt(0,80+180-42+48,picture,rect)
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_衝撃波系") #ダメージ表示用
        rect = Rect.new(0, @back_anime_type*180,640,180)
        @back_window.contents.blt(0,80,picture,rect)
      end
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end

    when 2 #必殺技発動時縦

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_魔族系(縦)") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*480,640,356)
      @back_window.contents.blt(0,0,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 3 #必殺技発動時横

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_魔族系(横)") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*304,640,304)
      @back_window.contents.blt(0,0,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 4 #気を溜める(小)？
      if @ray_color == 0
        picture = Cache.picture("Z1_戦闘_必殺技_気を溜める") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z1_戦闘_必殺技_気を溜める(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture("Z1_戦闘_必殺技_気を溜める(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture("Z1_戦闘_必殺技_気を溜める") #ダメージ表示用
      end

      if back_x == 0 || back_x == nil

        back_x = 234
        back_y = 70
      end
      rect = Rect.new(0,@back_anime_type*222,160,222)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 5 #気を溜める(中)？

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*192,128,192)
      @back_window.contents.blt(250,56,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 6 #気を溜める(魔閃光)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*160,160,160)

      if back_x == 0 || back_x == nil

        back_x = 234
        back_y = 112
      end

      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 7 #気を溜める(気功砲)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める4") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*360,640,356)
      @back_window.contents.blt(0,0,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 8 #気を溜める(四身の拳気功砲)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(四身の拳気功砲)") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*360,640,360)
      @back_window.contents.blt(0,0,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 9 #四身の拳気功砲系縦

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_背景_気功砲系") #ダメージ表示用

      if @attackcourse == 0 && $data_enemies[@enedatenum].element_ranks[23] == 1 || @attackcourse == 1 && $cha_bigsize_on[@chanum] == true
        if @attackcourse == 0
          rect = Rect.new(0, @back_anime_type*360,142,356)
          @back_window.contents.blt(170-14,0,picture,rect)
          rect = Rect.new(242, @back_anime_type*360,142,356)
          @back_window.contents.blt(170-14+142+200,0,picture,rect)
        else
          rect = Rect.new(0, @back_anime_type*360,142,356)
          @back_window.contents.blt(-20,0,picture,rect)
          rect = Rect.new(242, @back_anime_type*360,142,356)
          @back_window.contents.blt(-20+142+200,0,picture,rect)
        end
      else
        if @attackcourse == 0
          rect = Rect.new(0, @back_anime_type*360,384,356)
          @back_window.contents.blt(170,0,picture,rect)
        else
          rect = Rect.new(0, @back_anime_type*360,384,356)
          @back_window.contents.blt(90,0,picture,rect)
        end
      end
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 10 #気を溜める(超能力)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_超能力") #ダメージ表示用

      rect = Rect.new(0, @back_anime_type*160,128,160)
      @back_window.contents.blt(248,110,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 11 #気を溜める(ラディッツ)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_手に気を溜める_片手") #ダメージ表示用

      rect = Rect.new(0, @back_anime_type*48,40,48)
      @back_window.contents.blt(266,116,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 9
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 12 #気を溜める両手(ラディッツ)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_手に気を溜める_両手") #ダメージ表示用

      rect = Rect.new(0, @back_anime_type*48,100,48)
      @back_window.contents.blt(266,116,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 9
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 13 #気を溜める(ブラックホール波)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める5") #ダメージ表示用
      if $btl_progress >= 2
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める10") #ダメージ表示用
      end
      rect = Rect.new(0,@back_anime_type*378,640,356)
      @back_window.contents.blt(0,0,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 14 #気を溜める(ナッパエネルギー波)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める6") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*178,190,178)
      @back_window.contents.blt(220,100,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 15 #気を溜める(ナッパ口からエネルギー波)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める7") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*256,256,256)
      @back_window.contents.blt(190,60,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 16 #気を溜める(ギャリック砲)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める8") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*380,640,356)
      @back_window.contents.blt(0,0,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 17 #気を溜める(界王拳カメハメは)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める9") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*378,640,356)
      @back_window.contents.blt(0,0,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 18 #捨て身攻撃まかんこうさっぽうため

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*192,128,192)
      @back_window.contents.blt(250-120-36,56,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 19 #捨て身悟空現れる
      picture = Cache.picture(set_battle_character_name 3,1)
      picture = Cache.picture(set_battle_character_name 14,1) if $super_saiyazin_flag[1] == true
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用

      if $btl_progress == 0
        rect = Rect.new(0,11*96,96,96)
        @back_window.contents.blt(CENTER_ENEX+12,STANDARD_ENEY-90,picture,rect)
      elsif $btl_progress == 1 || $btl_progress == 2
        rect = Rect.new(0,16*96,96,96)
        @back_window.contents.blt(CENTER_ENEX+12,STANDARD_ENEY-90+6,picture,rect)
      end
    when 20 #捨て身悟空離れる
      picture = Cache.picture(set_battle_character_name 3,1)
      picture = Cache.picture(set_battle_character_name 14,1) if $super_saiyazin_flag[1] == true
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用

      rect = Rect.new(0,10*96,96,96)
      rect = Rect.new(0,7*96,96,96) if $btl_progress == 1
      if @back_anime_type == 0
        #rect = Rect.new(0,10*96,96,96)
        @back_window.contents.blt(CENTER_ENEX+12+@back_anime_frame*8,STANDARD_ENEY-6,picture,rect)
      else
        rect = Rect.new(0,11*96,96,96)
        rect = Rect.new(0,16*96,96,96) if $btl_progress == 1 || $btl_progress == 2
        @back_window.contents.blt(CENTER_ENEX+12+8*4,STANDARD_ENEY+6-6-(@back_anime_frame-8)*16,picture,rect)
      end

      if @back_anime_frame == 8 #  && @back_anime_type != 2
        @back_anime_type += 1
      end
    when 21 #気を溜める(小)(操気円斬ヤムチャ
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(緑)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める") #ダメージ表示用
      end
      rect = Rect.new(0,@back_anime_type*222,160,222)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 22 #気を溜める(小)(操気円斬ヤムチャ自身
      picture = Cache.picture(set_battle_character_name 7,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
      rect = Rect.new(0, 3*96,96,96)
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
    when 23 #気を溜める(小)(操気円斬ヤムチャ自身
      picture = Cache.picture(set_battle_character_name 7,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
      rect = Rect.new(0, 4*96,96,96)
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
    when 24 #気を溜める(小)(操気円斬ヤムチャ自身
      picture = Cache.picture(set_battle_character_name 7,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
      rect = Rect.new(0, 5*96,96,96)
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
    when 25 #気を溜める(小)(操気円斬ヤムチャ自身
      picture = Cache.picture(set_battle_character_name 7,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
      rect = Rect.new(0, 6*96,96,96)
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
    when 26 #気を溜める(小)(操気円斬ヤムチャ自身
      picture = Cache.picture(set_battle_character_name 7,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
      rect = Rect.new(0, 7*96,96,96)
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
    when 27 #気を溜める(小)(操気円斬クリリン自身
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
    when 28 #気を溜める(小)(操気円斬クリリン自身
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      rect = Rect.new(0, 7*96,96,96)
      @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
    when 29 #気を溜める(小)(操気円斬クリリン自身
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      rect = Rect.new(0, 8*96,96,96)
      @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
    when 30 #繰気弾

      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end

      rect = Rect.new(256, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-450+@back_anime_frame*16,-290+@back_anime_frame*8,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end
    when 31 #操気円斬
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
    when 32 #操気円斬
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      rect = Rect.new(0, 5*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
    when 33 #操気円斬
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      rect = Rect.new(0, 6*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
    when 34 #操気円斬
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      rect = Rect.new(0, 7*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
    when 35 #操気円斬
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      rect = Rect.new(0, 1*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
    when 36 #ダブルどどんぱ_キャラ現れる

      if $partyc[@chanum.to_i] == 8
        picture = Cache.picture(set_battle_character_name 9,0)
        picture = Cache.picture(set_battle_character_name 9,1) if @back_anime_frame >= 31
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ") if @back_anime_frame >= 31
        #picture = Cache.picture($btl_top_file_name + "戦闘_チャオズ") #ダメージ表示用
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ") if @back_anime_frame >= 31
      else

        picture = Cache.picture(set_battle_character_name 8,0) #ダメージ表示用
        picture = Cache.picture(set_battle_character_name 8,1) if @back_anime_frame >= 31
        #picture = Cache.picture($btl_top_file_name + "戦闘_テンシンハン") #ダメージ表示用
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") if @back_anime_frame >= 31

      end
      #attack_se = "Z3 打撃"
      case @back_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
      when 31..40
        rect = Rect.new(0, 0*96,96,96)
      else
        rect = Rect.new(0, 0*96,96,96)
      end
      if $partyc[@chanum.to_i] == 8
        @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
      else
        @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
      end
    when 37 #ダブルどどんぱ_ゆびたて
      rect = Rect.new(0, 2*96,96,96)
      picture = Cache.picture(set_battle_character_name 9,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)

      rect = Rect.new(0, 7*96,96,96)
      picture = Cache.picture(set_battle_character_name 8,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
      @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
    when 38 #ダブルどどんぱ_ゆびまえ
      rect = Rect.new(0, 3*96,96,96)
      picture = Cache.picture(set_battle_character_name 9,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)

      rect = Rect.new(0, 8*96,96,96)
      picture = Cache.picture(set_battle_character_name 8,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
      @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
    when 39 #ダブルどどんぱ(Z2)_キャラ現れる
        if $partyc[@chanum.to_i] == 8
          picture = Cache.picture(set_battle_character_name 9,1)
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
        elsif $partyc[@chanum.to_i] == 9
          picture = Cache.picture(set_battle_character_name 8,1)
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
        end
        rect = Rect.new(0, 0*96,96,96)
        ushirox=0
        idouryou = 8
        if $partyc[@chanum.to_i] == 8
          @back_window.contents.blt(STANDARD_CHAX+@back_anime_frame*idouryou+30,STANDARD_CHAY-50,picture,rect)
          #p STANDARD_CHAX+@effect_anime_frame*idouryou,TEC_CENTER_CHAX if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7
        else
          @back_window.contents.blt(STANDARD_CHAX+@back_anime_frame*idouryou+30,STANDARD_CHAY+50,picture,rect)
        end
    when 40 #ダブルどどんぱ(Z2)_キャラ現れる(放置)
      rect = Rect.new(0, 0*96,96,96)
      picture = Cache.picture(set_battle_character_name 8,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
      picture = Cache.picture(set_battle_character_name 9,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY-50,picture,rect)
    when 41 #ダブルどどんぱ(Z2)_放つ
      rect = Rect.new(0, 5*96,96,96)
      picture = Cache.picture(set_battle_character_name 8,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
      rect = Rect.new(0, 1*96,96,96)
      picture = Cache.picture(set_battle_character_name 9,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY-50,picture,rect)
    when 42 #超能力きこうほう
      rect = Rect.new(0, 1*96,96,96)
      picture = Cache.picture(set_battle_character_name 9,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)

      rect = Rect.new(0, 2*96,96,96)
      picture = Cache.picture(set_battle_character_name 8,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
      @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
    when 43 #気を溜める(超能力きこうほう)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_超能力") #ダメージ表示用

      rect = Rect.new(0, @back_anime_type*160,128,160)
      @back_window.contents.blt(back_x,back_y,picture,rect)

      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 44 #Z2超能力きこうほう
      rect = Rect.new(0, 0*96,96,96)
      picture = Cache.picture(set_battle_character_name 8,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
      if $btl_progress == 2
        rect = Rect.new(0, 6*96,96,96)
      else
        rect = Rect.new(0, 2*96,96,96)
      end
      picture = Cache.picture(set_battle_character_name 9,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY-50,picture,rect)
    when 45 #Z2超能力きこうほう
      rect = Rect.new(0, 2*96,96,96)
      picture = Cache.picture(set_battle_character_name 8,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
      if $btl_progress == 2
        rect = Rect.new(0, 6*96,96,96)
      else
        rect = Rect.new(0, 2*96,96,96)
      end
      picture = Cache.picture(set_battle_character_name 9,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY-50,picture,rect)
    when 46 #師弟の絆_キャラ現れる

      if $partyc[@chanum.to_i] == 4
        picture = Cache.picture(set_battle_character_name 5,0)
        #picture = Cache.picture(set_battle_character_name 5,1)
        #if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
        #  picture = Cache.picture(set_battle_character_name 18,0)
        #  picture = Cache.picture(set_battle_character_name 18,1)
        #end
        picture = Cache.picture(set_battle_character_name 5,1) if @back_anime_frame >= 31
        #if ($super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true) && @back_anime_frame >= 31
        #  picture = Cache.picture(set_battle_character_name 18,1)
        #end
        #picture = Cache.picture($btl_top_file_name + "戦闘_ゴハン") #ダメージ表示用
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン") if @back_anime_frame >= 31
      else
        picture = Cache.picture(set_battle_character_name 4,0)
        picture = Cache.picture(set_battle_character_name 4,1) if @back_anime_frame >= 31
        #picture = Cache.picture($btl_top_file_name + "戦闘_ピッコロ") #ダメージ表示用
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") if @back_anime_frame >= 31

      end
      #attack_se = "Z3 打撃"
      case @back_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
      when 31..40
        rect = Rect.new(0, 0*96,96,96)
      else
        rect = Rect.new(0, 0*96,96,96)
      end
      if $partyc[@chanum.to_i] == 4
        @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
      else
        @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
      end
    when 47 #師弟の絆_キャラ現れる(ゴハンのみ表示
      picture = Cache.picture(set_battle_character_name 5,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
      rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)

    when 48 #師弟の絆_高速移動
      if @back_anime_frame % 4 == 0
        picture = Cache.picture("戦闘アニメ") #ダメージ表示用
        rect = Rect.new(0,48, 64, 64)
        @back_window.contents.blt(back_x,back_y,picture,rect)
      end
    when 49 #師弟の絆_技溜

      rect = Rect.new(0, 2*96,96,96)
      picture = Cache.picture(set_battle_character_name 5,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)

      rect = Rect.new(0, 5*96,96,96)
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
      @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)

     when 50 #師弟の絆_技発動

      rect = Rect.new(0, 3*96,96,96)
      picture = Cache.picture(set_battle_character_name 5,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)

      rect = Rect.new(0, 6*96,96,96)
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
      @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)

    when 51 #師弟の絆_気を溜める
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(緑)") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*222,160,222)
      @back_window.contents.blt(234-90,70,picture,rect)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*160,160,160)
      @back_window.contents.blt(234+96,112,picture,rect)

      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 52 #Z2師弟の絆_気を溜める
      rect = Rect.new(0, 2*96,96,96)
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
      rect = Rect.new(0, 2*96,96,96)
      picture = Cache.picture(set_battle_character_name 5,1)
      if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
        picture = Cache.picture(set_battle_character_name 18,1)
      end
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY-50,picture,rect)
    when 53 #Z2師弟の絆_発動
      rect = Rect.new(0, 3*96,96,96)
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
      rect = Rect.new(0, 3*96,96,96)
      picture = Cache.picture(set_battle_character_name 5,1)
      if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
        picture = Cache.picture(set_battle_character_name 18,1)
      end
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY-50,picture,rect)
    when 54 #狼鶴相打陣_ヤムチャ表示
      picture = Cache.picture(set_battle_character_name 7,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
      rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(CENTER_CHAX,STANDARD_CHAY,picture,rect)
    when 55 #師弟の絆_キャラ現れる

      if $partyc[@chanum.to_i] == 4
        picture = Cache.picture(set_battle_character_name 6,0)
        picture = Cache.picture(set_battle_character_name 6,1) if @back_anime_frame >= 31
        #picture = Cache.picture($btl_top_file_name + "戦闘_ゴハン") #ダメージ表示用
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン") if @back_anime_frame >= 31
      else
        picture = Cache.picture(set_battle_character_name 4,0)
        picture = Cache.picture(set_battle_character_name 4,1) if @back_anime_frame >= 31
        #picture = Cache.picture($btl_top_file_name + "戦闘_ピッコロ") #ダメージ表示用
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") if @back_anime_frame >= 31

      end
      #attack_se = "Z3 打撃"
      case @back_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
      when 31..40
        rect = Rect.new(0, 0*96,96,96)
      else
        rect = Rect.new(0, 0*96,96,96)
      end
      if $partyc[@chanum.to_i] == 4
        @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
      else
        @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
      end
    when 56 #行くぞ！クリリン_技溜

      rect = Rect.new(0, 1*96,96,96)
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)

      rect = Rect.new(0, 5*96,96,96)
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
      @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
    when 57 #行くぞ！クリリン_気を溜める
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(緑)") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*222,160,222)
      @back_window.contents.blt(234-90,70,picture,rect)

      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3") #ダメージ表示用

      #rect = Rect.new(0,@back_anime_type*160,160,160)
      #@back_window.contents.blt(234+96,112,picture,rect)

      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
     when 58 #師弟の絆_技発動

      rect = Rect.new(0, 2*96,96,96)
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)

      rect = Rect.new(0, 6*96,96,96)
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
      @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
    when 59 #ダブルアイビーム_キャラ現れる(ピッコロ、天津飯
      if $partyc[@chanum.to_i] == 8
        picture = Cache.picture(set_battle_character_name 4,0)
        picture = Cache.picture(set_battle_character_name 4,1) if @back_anime_frame >= 31
      else
        picture = Cache.picture(set_battle_character_name 8,0)
        picture = Cache.picture(set_battle_character_name 8,1) if @back_anime_frame >= 31

      end

      case @back_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
      when 31..40
        rect = Rect.new(0, 0*96,96,96)
      else
        rect = Rect.new(0, 0*96,96,96)
      end
      if $partyc[@chanum.to_i] == 4
        @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
      else
        @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
      end

##########################################################
# Z2
##########################################################

    when 101 #気を溜める(大)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める3(赤)") #ダメージ表示用
      end

      rect = Rect.new(@back_anime_type*184,0,184,240)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 102 #気を溜める(特大)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める4") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める4(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める4(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める4(赤)") #ダメージ表示用
      end
      rect = Rect.new(@back_anime_type*224,0,224,288)
      @back_window.contents.blt(back_x,back_y-36,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 103 #気を溜める(元気弾)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める5") #ダメージ表示用

      rect = Rect.new(@back_anime_type*236,0,236,254)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 8  && @back_anime_type != 11
        @back_anime_type += 1
        @back_anime_frame = 0
      #elsif @back_anime_frame >= 6
        #@back_anime_type = 0
        #@back_anime_frame = 0
      end
    when 104 #気を溜める(超元気弾)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める6") #ダメージ表示用

      rect = Rect.new(@back_anime_type*512,0,256,320)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 8  && @back_anime_type != 11
        @back_anime_type += 1
        @back_anime_frame = 0
      #elsif @back_anime_frame >= 6
        #@back_anime_type = 0
        #@back_anime_frame = 0
      end
    when 105 #気を溜める(中)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める2(赤)") #ダメージ表示用
      end

      rect = Rect.new(@back_anime_type*152,0,152,192)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 106 #背景スーパーカメハメ波
      if @attackcourse == 0 && mirror_pattern == 0
        picture = Cache.picture("Z3_必殺技_超カメハメ波(バック上)") #ダメージ表示用
        rect = Rect.new(0,128*@back_anime_type,384,128)
        @back_window.contents.blt(0,0,picture,rect)
        picture = Cache.picture("Z3_必殺技_超カメハメ波(バック下)") #ダメージ表示用
        rect = Rect.new(0,64*@back_anime_type,192,64)
        @back_window.contents.blt(0,292,picture,rect)
      else
        picture = Cache.picture("Z3_必殺技_超カメハメ波(バック上)_反転") #ダメージ表示用
        rect = Rect.new(0,128*@back_anime_type,384,128)
        @back_window.contents.blt(640-384,0,picture,rect)
        picture = Cache.picture("Z3_必殺技_超カメハメ波(バック下)_反転") #ダメージ表示用
        rect = Rect.new(0,64*@back_anime_type,192,64)
        @back_window.contents.blt(640-192,292,picture,rect)
      end
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 107 #気を溜める(パープルコメットクラッシュ)


      if @back_anime_type == 0
        if @ray_color == 3
          picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
        elsif @ray_color == 4
          picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(赤)") #ダメージ表示用
        end
        rect = Rect.new(5*128,0,128,128)
        @back_window.contents.blt(back_x,back_y,picture,rect)
      else
        if @ray_color == 3
          picture = Cache.picture("Z2_戦闘_必殺技_敵_バータ") #ダメージ表示用
        else
          picture = Cache.picture("Z2_戦闘_必殺技_敵_ジース") #ダメージ表示用
        end
        rect = Rect.new(0 , 0+(96*2), 96, 96)
        @back_window.contents.blt(@enex,STANDARD_ENEY,picture,rect)
      end

      if @back_anime_frame >= 2  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 2
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 108 #気が交わる(パープルコメットクラッシュ)
      picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      rect = Rect.new(5*128,0,128,128)
      @back_window.contents.blt(STANDARD_CHAX + @back_anime_frame*10,STANDARD_ENEY,picture,rect)

      picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(赤)") #ダメージ表示用
      @back_window.contents.blt(STANDARD_ENEX - @back_anime_frame*10 +60,STANDARD_ENEY,picture,rect)
    when 109 #気が交わる青赤(パープルコメットクラッシュ)
      if @back_anime_type == 0
        picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      else
        picture = Cache.picture("Z2_戦闘_必殺技_エネルギー弾(赤)") #ダメージ表示用
      end
      rect = Rect.new(5*128,0,128,128)

      @back_window.contents.blt(CENTER_ENEX,STANDARD_ENEY,picture,rect)
      if @back_anime_frame >= 2  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 2
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 110 #合体攻撃発動者
      picture = Cache.picture(set_battle_character_name 3,1)
      picture = Cache.picture(set_battle_character_name 14,1) if $super_saiyazin_flag[1] == true
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用
      rect = Rect.new(0,@scombo_cha1_anime_type*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY,picture,rect)
    when 111 #ピッコロ後ろの現れる
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") #ダメージ表示用
      rect = Rect.new(0,@scombo_cha2_anime_type*96,96,96)
      @back_window.contents.blt(STANDARD_CHAX+@scombo_cha_anime_frame*8,STANDARD_CHAY,picture,rect)
    when 112 #悟空前に現れる
      picture = Cache.picture(set_battle_character_name 3,1)
      picture = Cache.picture(set_battle_character_name 14,1) if $super_saiyazin_flag[1] == true
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用
      rect = Rect.new(0,@scombo_cha2_anime_type*96,96,96)
      @back_window.contents.blt(STANDARD_CHAX+@scombo_cha_anime_frame*16,STANDARD_CHAY,picture,rect)
    when 113 #合体攻撃発動者
      picture = Cache.picture(set_battle_character_name $partyc[@chanum.to_i],1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha1_anime_type*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX-@scombo_cha_anime_frame*8,STANDARD_CHAY,picture,rect)
    when 114 #ヤムチャ前に現れる
      picture = Cache.picture(set_battle_character_name 7,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ") #ダメージ表示用
      rect = Rect.new(0,@scombo_cha2_anime_type*96,96,96)
      @back_window.contents.blt(STANDARD_CHAX+@scombo_cha_anime_frame*16,STANDARD_CHAY,picture,rect)
    when 115 #スパーキング用1人目
      picture = Cache.picture(set_battle_character_name @scombo_cha1,0)
      #picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha1].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha1_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 116 #スパーキング用1人目必殺技
      picture = Cache.picture(set_battle_character_name @scombo_cha1,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha1].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha1_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 117 #スパーキング用2人目
      picture = Cache.picture(set_battle_character_name @scombo_cha2,0)
      #picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha2].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha2_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 118 #スパーキング用2人目必殺技
      picture = Cache.picture(set_battle_character_name @scombo_cha2,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha2_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 119 #スパーキング用3人目
      picture = Cache.picture(set_battle_character_name @scombo_cha3,0)
      #picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha3_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 120 #スパーキング用3人目必殺技
      picture = Cache.picture(set_battle_character_name @scombo_cha3,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha3_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 121 #スパーキング用4人目
      picture = Cache.picture(set_battle_character_name @scombo_cha4,0)
      #picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha4_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 122 #スパーキング用4人目必殺技
      picture = Cache.picture(set_battle_character_name @scombo_cha4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha4_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 123 #スパーキング用5人目
      picture = Cache.picture(set_battle_character_name @scombo_cha5,0)
      #picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha5_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 124 #スパーキング用5人目必殺技
      picture = Cache.picture(set_battle_character_name @scombo_cha5,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha5_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 125 #スパーキング用6人目
      picture = Cache.picture(set_battle_character_name @scombo_cha6,0)
      #picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha6_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 126 #スパーキング用6人目必殺技
      picture = Cache.picture(set_battle_character_name @scombo_cha6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha3].name) #ダメージ表示用
      rect = Rect.new(0,@scombo_cha6_anime_type*96,96,96)
      @back_window.contents.blt(back_x,back_y,picture,rect)
    when 127 #ヤムチャ前に現れる
      picture = Cache.picture(set_battle_character_name 7,1)
      rect = Rect.new(0,@scombo_cha2_anime_type*96,96,96)
      @back_window.contents.blt(STANDARD_CHAX+@scombo_cha_anime_frame*16,STANDARD_CHAY,picture,rect)
    when 128 #発動キャラ前に現れる(汎用)
      picture = Cache.picture(set_battle_character_name @scombo_cha1,1)
      rect = Rect.new(0,@scombo_cha1_anime_type*96,96,96)
      @back_window.contents.blt(STANDARD_CHAX+@scombo_cha_anime_frame*16,STANDARD_CHAY,picture,rect)
    when 129 #気を溜める(超元気弾)溜め続ける

      picture = Cache.picture("Z2_戦闘_必殺技_気を溜める(超元気玉全開)") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*320,816,320)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 2
        @back_anime_type += 1
        @back_anime_frame = 0
        if @back_anime_type == 3
          @back_anime_type = 0
        end
      #elsif @back_anime_frame >= 6
        #@back_anime_type = 0
        #@back_anime_frame = 0
      end
##########################################################
# Z3
##########################################################
    when 201 #気を溜める(Z3)

      if @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める(青)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める") #ダメージ表示用
      end

      rect = Rect.new(@back_anime_type*136,0,136,142)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 16  && @back_anime_type != 1
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 16
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 202 #気を溜める(ZG)

      picture = Cache.picture("ZG_戦闘_必殺技_気を溜める") #ダメージ表示用

      rect = Rect.new(@back_anime_type*156,0,156,144)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 8  && @back_anime_type != 1
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 8
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 211 #17号バリア
      picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾(青)")
      rect = Rect.new(5*128,0,128,128)

      if @back_anime_frame <= 2
        @back_window.contents.blt(CENTER_ENEX,STANDARD_ENEY,picture,rect)
      elsif @back_anime_frame >= 4
        @back_anime_frame = 0
      end
    when 212 #超元気玉吸収
      picture = Cache.picture("Z3_戦闘_必殺技_超元気玉_弾")
      rect = Rect.new(@back_anime_type*126,0,126,126)
      @back_window.contents.blt(back_x,back_y,picture,rect)

      if @back_anime_frame >= 8  && @back_anime_type != 1
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 8
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 213 #気を溜める(#超元気玉吸収)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気を溜める9") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*378,640,378)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 214 #ロボット兵手先発動
      scllorspd = 12
      picture = Cache.picture("Z3_戦闘_必殺技_ロボット兵腕1") #ダメージ表示用
      rect = Rect.new(0, 0,@back_anime_frame*scllorspd,24)
      @back_window.contents.blt(back_x,back_y,picture,rect)

    when 215 #ロボット兵手先発動前に移動
      scllorspd = 12
      picture = Cache.picture("Z3_戦闘_必殺技_ロボット兵腕1") #ダメージ表示用
      rect = Rect.new(0, 0,1280,24)
      @back_window.contents.blt(back_x-@back_anime_frame*scllorspd,back_y,picture,rect)

    when 216 #アンギラ手が伸びる
      picture = Cache.picture("Z2_戦闘_必殺技_アンギラ手が伸びる") #ダメージ表示用
      rect = Rect.new(0, 0,26+@back_anime_frame*RAY_SPEED,24)
      @back_window.contents.blt(back_x-@back_anime_frame*RAY_SPEED,back_y,picture,rect)
    when 217 #アンギラ手を縮める
      picture = Cache.picture("Z2_戦闘_必殺技_アンギラ手が伸びる") #ダメージ表示用
      rect = Rect.new(0, 0,640-@back_anime_frame*RAY_SPEED,24)
      @back_window.contents.blt(back_x+@back_anime_frame*RAY_SPEED,back_y,picture,rect)

    when 218 #気を溜める 11
      if @ray_color == 0
        picture = Cache.picture("Z3_戦闘_必殺技_気を溜める11(赤)") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_戦闘_必殺技_気を溜める11(赤)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture("Z3_戦闘_必殺技_気を溜める11(赤)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture("Z3_戦闘_必殺技_気を溜める11(赤)") #ダメージ表示用
      end

      rect = Rect.new(@back_anime_type*156,0,156,144)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 8  && @back_anime_type != 1
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 8
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 219 #気を溜めるブウ超爆発波
      picture = Cache.picture("Z3_必殺技_超爆発波_気を溜める")
      rect = Rect.new(0,@back_anime_type*300,300,300)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 8  && @back_anime_type != 1
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 8
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 220 #気を溜めるブウ超爆発波必殺技発動時縦

      picture = Cache.picture("Z3_戦闘_必殺技_背景_ブウ_超爆発波") #ダメージ表示用

      rect = Rect.new(0,@back_anime_type*356,640,356)
      @back_window.contents.blt(0,0,picture,rect)
      if @back_anime_frame >= 4  && @back_anime_type != 2
        @back_anime_type += 1
        @back_anime_frame = 0
      elsif @back_anime_frame >= 4
        @back_anime_type = 0
        @back_anime_frame = 0
      end
    when 221 #気を溜める 12
      if @ray_color == 0
        picture = Cache.picture("Z3_戦闘_必殺技_気を溜める12(赤)") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_戦闘_必殺技_気を溜める12(赤)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture("Z3_戦闘_必殺技_気を溜める12(赤)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture("Z3_戦闘_必殺技_気を溜める12(赤)") #ダメージ表示用
      end

      rect = Rect.new(@back_anime_type*300,0,300,300)
      @back_window.contents.blt(back_x,back_y,picture,rect)
      if @back_anime_frame >= 8  && @back_anime_type != 1
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
  # ● エフェクトアニメパターン：エネルギー弾、爆発等
  #mirror_pattern:強制的に逆のモードにする
  #--------------------------------------------------------------------------
  def effect_pattern n,ray_x=0,ray_y=0,mirror_pattern=@attackcourse

    case n

    when 1 #エネルギー弾系(正面)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if ray_x == 0 || ray_x == nil
        ray_x = 240
        ray_y = 100
      end
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end

    when 2 #カメハメ波系(正面)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if ray_x == 0 || ray_x == nil
        ray_x = 240
        ray_y = 110
      end
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 3 #エネルギー弾系(正面)緑(手の位置)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(240,110,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 4 #エネルギー弾系(正面)緑_双方向
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(240-@effect_anime_frame*2,122-@effect_anime_frame*2,picture,rect)
      @back_window.contents.blt(262+@effect_anime_frame*2,122-@effect_anime_frame*2,picture,rect)
      if @effect_anime_frame % 15 == 0
        @effect_anime_type += 1
      end
    when 5 #エネルギー弾系(正面)緑(口の位置)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      end

      if ray_x == 0 || ray_x == nil
        ray_x = 250
        ray_y = 140
      end

      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 6 #エネルギー弾系(正面)緑(中心の位置)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(桃)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(250,114,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 7 #魔貫光殺砲(正面)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_魔貫光殺砲系(緑)") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(238,124,picture,rect)
      if @effect_anime_frame >= 6
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 8 #エネルギー弾系(正面)(悟飯センター)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(桃)") #ダメージ表示用
      end
      if ray_x == 0 || ray_x == nil
        ray_x = 252
        ray_y = 130
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 9 #気円斬(クリリン)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") #ダメージ表示用

      rect = Rect.new(@effect_anime_type*128, 0,128,28)
      if @effect_anime_frame >= 0 && @effect_anime_frame <= 30
          #@back_window.contents.blt(252,120,picture,rect)
      elsif @effect_anime_frame == 31
          @effect_anime_type += 1
      elsif @effect_anime_frame == 41
          @effect_anime_type += 1
      elsif @effect_anime_frame == 51
          @effect_anime_type += 1
      end
      @back_window.contents.blt(252,120,picture,rect)
    when 10 #繰気弾(ヤムチャ)
      if ray_x == 0 || ray_x == nil
        ray_x = 230
        ray_y = 66
      end
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
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
    when 11 #エネルギー弾系(正面)(テンシンハンの手)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(230,114,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 12 #四身の拳系(正面)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") #ダメージ表示用
      case @effect_anime_frame

      when 0..30
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(@chax - 2 * @effect_anime_frame,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 2 * @effect_anime_frame,STANDARD_CHAY,picture,rect)
      when 31..59

        rect = Rect.new(0 , 0+(96*3), 96, 96)
        @back_window.contents.blt(@chax - 60,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 60,STANDARD_CHAY,picture,rect)
        if @effect_anime_frame == 59
          Audio.se_play("Audio/SE/" + "Z1 分身")    # 効果音を再生する
        end
      when 60..120
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(@chax - 60,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 60,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax - 60 - 2 * (@effect_anime_frame-60),STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 60 + 2 * (@effect_anime_frame-60),STANDARD_CHAY,picture,rect)
      else
        if @effect_anime_frame == 121
          Audio.se_play("Audio/SE/" + "Z1 エネルギー波2")    # 効果音を再生する
        end
        rect = Rect.new(0 , 0+(96*6), 96, 96)
        @back_window.contents.blt(@chax - 60,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 60,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax - 180,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 180,STANDARD_CHAY,picture,rect)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(紫)") #ダメージ表示用
        rect = Rect.new(@effect_anime_type*128, 0,128,128)
        @back_window.contents.blt(68,114,picture,rect)
        @back_window.contents.blt(68+120,114,picture,rect)
        @back_window.contents.blt(68+240,114,picture,rect)
        @back_window.contents.blt(68+360,114,picture,rect)
        if @effect_anime_frame == 130
          @effect_anime_type += 1
        elsif @effect_anime_frame == 140
          @effect_anime_type += 1
        elsif @effect_anime_frame == 150
          @effect_anime_type += 1
        end
      end
    when 13 #四身の拳気功砲(正面)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") #ダメージ表示用
      case @effect_anime_frame

      when 0..30
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(@chax - 2 * @effect_anime_frame,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 2 * @effect_anime_frame,STANDARD_CHAY,picture,rect)
      when 31..59

        rect = Rect.new(0 , 0+(96*3), 96, 96)
        @back_window.contents.blt(@chax - 60,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 60,STANDARD_CHAY,picture,rect)
        if @effect_anime_frame == 59
          Audio.se_play("Audio/SE/" + "Z1 分身")    # 効果音を再生する
        end
      when 60..120
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(@chax - 60,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 60,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax - 60 - 2 * (@effect_anime_frame-60),STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 60 + 2 * (@effect_anime_frame-60),STANDARD_CHAY,picture,rect)
      else
        if @effect_anime_frame == 121
          Audio.se_play("Audio/SE/" + "Z1 ザー")    # 効果音を再生する
          Audio.se_play("Audio/SE/" + "Z1 気を溜める4")    # 効果音を再生する
        end
        rect = Rect.new(0 , 0+(96*2), 96, 96)
        @back_window.contents.blt(@chax - 60,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 60,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax - 180,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(@chax + 180,STANDARD_CHAY,picture,rect)
        back_anime_pattern 8
      end
    when 14 #エネルギー弾系(正面)(ラディッツ)手の位置
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾_敵") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾_敵(黄)") #ダメージ表示用
      elsif @ray_color == 2
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾_敵(赤)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(228,102,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 15 #エネルギー弾系(正面)(ラディッツ)正面
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾_敵") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(248,112,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 16 #エネルギー弾系(正面)(カイワレマン系頭)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(赤)") #ダメージ表示
      end

      if ray_x == 0 || ray_x == nil
        ray_x = 249
        ray_y = 112
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 17 #貫光線(正面)(ラディッツ)手の位置
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_貫光線_正面") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(228,102,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 18 #エネルギー弾系(正面)(サンショ手の位置)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(桃)") #ダメージ表示用
      end
      if ray_x == 0 || ray_x == nil
        ray_x = 230
        ray_y = 104
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 19 #エネルギー弾系(正面)(ベジータ)手の位置
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾_敵") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(238,122,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 20 #元気弾

      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(230,76,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 21 #パワーボール(べジータ)
      #p ray_x,ray_y
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(ray_x.to_i,ray_y.to_i,picture,rect)
    when 31 #エネルギー波系(小)横
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波(緑)") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,400,28)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,150,picture,rect)
      else
        rect = Rect.new(0, 28,400,28)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,150,picture,rect)
      end

    when 32 #かめはめ波系(中)横
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中(緑)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中(桃)") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,60)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,140,picture,rect)
      else
        rect = Rect.new(0, 60,400,60)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,140,picture,rect)
      end
    when 33 #爆裂魔光砲系(大)横
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大(緑)") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,92)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,124,picture,rect)
      else
        rect = Rect.new(0, 92,400,92)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,124,picture,rect)
      end
    when 35 #エネルギー波系(小)横x2(目から怪光線)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波(緑)") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,28)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,144,picture,rect)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,174,picture,rect)
      else
        rect = Rect.new(0, 28,400,28)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,144,picture,rect)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,174,picture,rect)
      end
    when 36 #魔貫光殺砲

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_魔貫光殺砲") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,32)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,150,picture,rect)
      else
        rect = Rect.new(0, 32,400,32)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,150,picture,rect)
      end
    when 37 #エネルギー波縦

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_縦") #ダメージ表示用
      rect = Rect.new(60, 0,60,400)
      @back_window.contents.blt(330,-600+@effect_anime_frame*RAY_SPEED/2,picture,rect)
    when 38 #気円斬

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") #ダメージ表示用
      rect = Rect.new(128, 0,128,28)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,150,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,150,picture,rect)
      end

    when 39 #狼牙風風拳

      end_frame = 85
      if @btl_ani_cha_chg_no == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
      end
      attack_se = "Z3 打撃"
      case @effect_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
      when 31..35
        rect = Rect.new(0, 0*96,96,96)
      when 36..39
        rect = Rect.new(0, 3*96,96,96)
      when 40..43
        rect = Rect.new(0, 1*96,96,96)
      when 44..46
        rect = Rect.new(0, 2*96,96,96)
      when 47..50
        rect = Rect.new(0, 4*96,96,96)
      when 51..53
        rect = Rect.new(0, 2*96,96,96)
      when 54..56
        rect = Rect.new(0, 1*96,96,96)
      when 57..60
        rect = Rect.new(0, 2*96,96,96)
      when 61..80
        rect = Rect.new(0, 16*96,96,96)
      else
        #when 81..85

        if @btl_ani_cha_chg_no == 0
          if $cha_set_action[@chanum] == 758
            picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
            rect = Rect.new(0, 3*96,96,96)
          elsif $btl_progress >= 2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
            rect = Rect.new(0, 3*96,96,96)
          else
            picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
            rect = Rect.new(0, 2*96,96,96)
          end
        else

          if $cha_set_action[@chanum] == 758
            picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
            rect = Rect.new(0, 3*96,96,96)
          elsif $btl_progress >= 2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
            rect = Rect.new(0, 3*96,96,96)
          else
            picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
            rect = Rect.new(0, 2*96,96,96)
          end

        end
      #else

        #if @btl_ani_cha_chg_no == 0
        #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
        #else
        #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
        #end
        #if $btl_progress >= 2
        #  rect = Rect.new(0, 3*96,96,96)
        #else
        #  rect = Rect.new(0, 3*96,96,96)
        #end
      end

      if @effect_anime_frame >= 36 && @effect_anime_frame % 5 == 0 && end_frame > @effect_anime_frame
        Audio.se_play("Audio/SE/" + attack_se)    # 効果音を再生する
      end

      if @effect_anime_frame >= 61 && @effect_anime_frame <= 80
        @back_window.contents.blt(CENTER_CHAX-(@effect_anime_frame-60)*8,STANDARD_CHAY,picture,rect)
      elsif @effect_anime_frame >= 81 && @effect_anime_frame <= 84
        @back_window.contents.blt(80+(@effect_anime_frame-80)*16,STANDARD_CHAY,picture,rect)
      else #if @effect_anime_frame < 86
        @back_window.contents.blt(CENTER_CHAX,STANDARD_CHAY,picture,rect)
      end

    when 40 #繰気弾

      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end

      rect = Rect.new(256, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,120,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end

    when 41 #四身の拳用エネルギー波系(小)横
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波(緑)") #ダメージ表示用
      elsif @ray_color == 2
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波(紫)") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,400,28)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,120,picture,rect)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,120+30,picture,rect)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,120+60,picture,rect)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,120+90,picture,rect)
      else
        rect = Rect.new(0, 28,400,28)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,150,picture,rect)
      end
    when 42 #エネルギー波中横(敵)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_敵_中") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_敵_中(黄)") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,60)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,150,picture,rect)
      else
        rect = Rect.new(0, 60,400,60)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,150,picture,rect)
      end
    when 43 #エネルギー波大横(敵)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_敵_大") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,88)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,134,picture,rect)
      else
        rect = Rect.new(0, 88,400,88)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,134,picture,rect)
      end
    when 44 #エネルギー液横(敵)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(緑)") #ダメージ表示用
      elsif @ray_color == 2
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(水色)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(桃)") #ダメージ表示用
      end
      if @attackcourse == 0 && mirror_pattern == 0
        rect = Rect.new(0, 0,400,32)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,150,picture,rect)
      else
        rect = Rect.new(0, 32,400,32)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,150,picture,rect)
      end
    when 45 #貫光線

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_貫光線_横") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,32)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,150,picture,rect)
      else
        rect = Rect.new(0, 32,400,32)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,150,picture,rect)
      end
    when 46 #刀攻撃
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_敵_" + $data_enemies[@enedatenum].name) #ダメージ表示用
      attack_se = "Z1 刀攻撃"
      case @effect_anime_frame

      when 0..10
        rect = Rect.new(0, 4*96,96,96)
      when 11..20
        rect = Rect.new(0, 5*96,96,96)
      when 21..30
        rect = Rect.new(0, 6*96,96,96)
      when 31..40
        rect = Rect.new(0, 7*96,96,96)
      when 41..50
        rect = Rect.new(0, 8*96,96,96)
      when 51..60
        rect = Rect.new(0, 9*96,96,96)
      when 61..70
        rect = Rect.new(0, 10*96,96,96)
      else
        rect = Rect.new(0, 10*96,96,96)
      end

      if @effect_anime_frame == 55
        Audio.se_play("Audio/SE/" + attack_se)    # 効果音を再生する
      end

      @back_window.contents.blt(CENTER_ENEX,STANDARD_ENEY,picture,rect)
    when 47 #かめはめ波系(中)円つき横
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中(緑)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_円_中(桃)") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,60)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,140,picture,rect)
      else
        rect = Rect.new(0, 60,400,60)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,140,picture,rect)
      end
    when 48 #かめはめ波系(特大)横
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_緑") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_青") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,192)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,76,picture,rect)
      else
        rect = Rect.new(0, 192,400,192)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,76,picture,rect)
      end
    when 49 #界王拳

      end_frame = 85
      picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
      attack_se = "Z1 打撃"
      case @effect_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
      when 31..35
        rect = Rect.new(0, 0*96,96,96)
      when 36..39
        rect = Rect.new(0, 1*96,96,96)
      when 40..43
        rect = Rect.new(0, 2*96,96,96)
      when 44..46
        rect = Rect.new(0, 1*96,96,96)
      when 47..50
        rect = Rect.new(0, 2*96,96,96)
      when 51..53
        rect = Rect.new(0, 3*96,96,96)
      when 54..56
        rect = Rect.new(0, 4*96,96,96)
      when 57..60
        rect = Rect.new(0, 3*96,96,96)
      when 61..63
        rect = Rect.new(0, 1*96,96,96)
      when 64..66
        rect = Rect.new(0, 2*96,96,96)
      when 67..70
        rect = Rect.new(0, 1*96,96,96)
      when 71..73
        rect = Rect.new(0, 2*96,96,96)
      else
        rect = Rect.new(0, 2*96,96,96)
      end

      if @effect_anime_frame >= 36 && @effect_anime_frame % 4 == 0 && end_frame > @effect_anime_frame
        Audio.se_play("Audio/SE/" + attack_se)    # 効果音を再生する
      end

      if @effect_anime_frame >= 61 && @effect_anime_frame <= 80
        @back_window.contents.blt(CENTER_CHAX-(@effect_anime_frame-60)*8,STANDARD_CHAY,picture,rect)
      elsif @effect_anime_frame >= 81 && @effect_anime_frame <= 84
        @back_window.contents.blt(80+(@effect_anime_frame-80)*16,STANDARD_CHAY,picture,rect)
      else #if @effect_anime_frame < 86
        @back_window.contents.blt(CENTER_CHAX,STANDARD_CHAY,picture,rect)
      end
    when 50 #ダブル衝撃波_キャラ現れる

      end_frame = 85

      if $partyc[@chanum.to_i] == 3
        picture = Cache.picture(set_battle_character_name 10,0)
        #picture = Cache.picture($btl_top_file_name + "戦闘_チチ") #ダメージ表示用
      else
        picture = Cache.picture(set_battle_character_name 3,0)
        #picture = Cache.picture($btl_top_file_name + "戦闘_ゴクウ") #ダメージ表示用
      end
      #attack_se = "Z3 打撃"
      case @effect_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
      when 31..40
        rect = Rect.new(0, 8*96,96,96)
      else
        rect = Rect.new(0, 8*96,96,96)
      end

      @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
    when 51 #ダブル衝撃波発動

      end_frame = 85
      if $partyc[@chanum.to_i] == 3
        picture = Cache.picture(set_battle_character_name 10,1)
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チチ") #ダメージ表示用
      else
        picture = Cache.picture(set_battle_character_name 3,1)
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用
      end
        #attack_se = "Z3 打撃"
      rect = Rect.new(0, 1*96,96,96)

      @back_window.contents.blt(CENTER_CHAX+120-16,STANDARD_CHAY,picture,rect)
    when 52 #捨て身攻撃_キャラ現れる

      end_frame = 85

      if $partyc[@chanum.to_i] == 3
        picture = Cache.picture(set_battle_character_name 4,0)
        #picture = Cache.picture($btl_top_file_name + "戦闘_ピッコロ") #ダメージ表示用
      else
        picture = Cache.picture(set_battle_character_name 3,0)
        #picture = Cache.picture($btl_top_file_name + "戦闘_ゴクウ") #ダメージ表示用
      end


      #attack_se = "Z3 打撃"
      case @effect_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
      when 31..40
        rect = Rect.new(0, 8*96,96,96)
      else
        rect = Rect.new(0, 8*96,96,96)
      end

      if $partyc[@chanum.to_i] == 3
        @back_window.contents.blt(CENTER_CHAX-120+6,STANDARD_CHAY,picture,rect)
      else
        @back_window.contents.blt(CENTER_CHAX+180,STANDARD_CHAY,picture,rect)
      end
    when 53 #捨て身攻撃_エネルギー波発動

      picture = Cache.picture(set_battle_character_name 3,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") #ダメージ表示用
      rect = Rect.new(0, 2*96,96,96)
      if $partyc[@chanum.to_i] == 3
        @back_window.contents.blt(CENTER_CHAX+180-2,STANDARD_CHAY,picture,rect)
      else
        @back_window.contents.blt(CENTER_CHAX+180-12,STANDARD_CHAY,picture,rect)
      end
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") #ダメージ表示用
      rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(CENTER_CHAX-120-10,STANDARD_CHAY,picture,rect)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(240+158-10,100,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 54 #捨て身攻撃_悟空ダッシュ発動
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") #ダメージ表示用
      rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(CENTER_CHAX-120-10,STANDARD_CHAY,picture,rect)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(240+158-10,100,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 55 #捨て身攻撃_ピッコロ_まかんこうさっぽうため1
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ") #ダメージ表示用
      rect = Rect.new(0, 5*96,96,96)
      @back_window.contents.blt(CENTER_CHAX-120-10,STANDARD_CHAY,picture,rect)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(240+158,100,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 56 #捨て身攻撃_ピッコロ_まかんこうさっぽうため2ゆびあたま
      picture = Cache.picture(set_battle_character_name 4,1) #ダメージ表示用
      rect = Rect.new(0, 7*96,96,96)
      @back_window.contents.blt(CENTER_CHAX-120-10,STANDARD_CHAY,picture,rect)

      #if @effect_anime_frame % 4 == 0
      #  picture = Cache.picture("戦闘アニメ") #ダメージ表示用
      #  rect = Rect.new(0,48, 64, 64)
      #  @back_window.contents.blt(CENTER_ENEX+64,STANDARD_ENEY+32,picture,rect)
      #end
    when 57 #捨て身攻撃_ピッコロ_まかんこうさっぽうため2ゆびまえ
      picture = Cache.picture(set_battle_character_name 4,1) #ダメージ表示用
      rect = Rect.new(0, 8*96,96,96)
      @back_window.contents.blt(CENTER_CHAX-120-10,STANDARD_CHAY,picture,rect)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_魔貫光殺砲系(緑)") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(238-120-30,124,picture,rect)
      if @effect_anime_frame >= 6
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 58 #捨て身攻撃_悟空敵の後ろに出現
      if @effect_anime_frame % 4 == 0
        picture = Cache.picture("戦闘アニメ") #ダメージ表示用
        rect = Rect.new(0,48, 64, 64)
        @back_window.contents.blt(CENTER_ENEX+64,STANDARD_ENEY-60,picture,rect)
      end
    when 59 #捨て身攻撃_Z2悟空敵の後ろに出現
      if @effect_anime_frame % 4 == 0
        picture = Cache.picture("戦闘アニメ") #ダメージ表示用
        rect = Rect.new(0,48, 64, 64)
        @back_window.contents.blt(TEC_CENTER_CHAX+16,STANDARD_CHAY+16,picture,rect)
      end
    when 60 #かめはめ乱舞_キャラ現れる

      x = 0

      for x in 0..1
        if $partyc[@chanum.to_i] == 3 || $partyc[@chanum.to_i] == 14
          picture = Cache.picture(set_battle_character_name 6,0) if x == 0#ダメージ表示用
          picture = Cache.picture(set_battle_character_name 7,0) if x == 1#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_クリリン") if x == 0#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_ヤムチャ") if x == 1#ダメージ表示用
        elsif $partyc[@chanum.to_i] == 6
          picture = Cache.picture(set_battle_character_name 3,0) if x == 0#ダメージ表示用
          picture = Cache.picture(set_battle_character_name 7,0) if x == 1#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_ゴクウ") if x == 0#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_ヤムチャ") if x == 1#ダメージ表示用
        elsif $partyc[@chanum.to_i] == 7
          picture = Cache.picture(set_battle_character_name 3,0) if x == 0#ダメージ表示用
          picture = Cache.picture(set_battle_character_name 6,0) if x == 1#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_ゴクウ") if x == 0#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_クリリン") if x == 1#ダメージ表示用
        end

        #attack_se = "Z3 打撃"
        case @effect_anime_frame

        when 0..10
          rect = Rect.new(0, 14*96,96,96)
        when 11..20
          rect = Rect.new(0, 13*96,96,96)
        when 21..30
          rect = Rect.new(0, 12*96,96,96)
        when 31..40
          rect = Rect.new(0, 8*96,96,96)
        else
          rect = Rect.new(0, 8*96,96,96)
        end

        if x == 0
          @back_window.contents.blt(CENTER_CHAX-120+8,STANDARD_CHAY,picture,rect) if $partyc[@chanum.to_i] == 3
          @back_window.contents.blt(TEC_CENTER_CHAX+18,STANDARD_CHAY,picture,rect) if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7

        else
          @back_window.contents.blt(CENTER_CHAX+180+38,STANDARD_CHAY,picture,rect) if $partyc[@chanum.to_i] == 3 || $partyc[@chanum.to_i] == 6
          @back_window.contents.blt(CENTER_CHAX-120+8,STANDARD_CHAY,picture,rect) if $partyc[@chanum.to_i] == 7
        end
      end
    when 61 #かめはめ乱舞_発動
      tameframe = 120
      hatudouframe = 30
      picture = Cache.picture(set_battle_character_name 3,1) #ダメージ表示用
      case @effect_anime_frame

      when 0..tameframe
          rect = Rect.new(0, 3*96,96,96)
      else
          rect = Rect.new(0, 4*96,96,96)
      end
      @back_window.contents.blt(TEC_CENTER_CHAX+4,STANDARD_CHAY,picture,rect)

      picture = Cache.picture(set_battle_character_name 6,1) #ダメージ表示用
      case @effect_anime_frame

      when 0..tameframe
          rect = Rect.new(0, 1*96,96,96)
      else
          rect = Rect.new(0, 2*96,96,96)
      end
      @back_window.contents.blt(CENTER_CHAX-120+8-28,STANDARD_CHAY+2,picture,rect)

      picture = Cache.picture(set_battle_character_name 7,1) #ダメージ表示用
      @back_window.contents.blt(CENTER_CHAX+180+38-20,STANDARD_CHAY-2,picture,rect)

      if @effect_anime_frame >= tameframe + hatudouframe
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
        rect = Rect.new(@effect_anime_type*128, 0,128,128)
        @back_window.contents.blt(242,114,picture,rect)
        @back_window.contents.blt(-18+CENTER_CHAX-120+8-28,-2+STANDARD_CHAY+2,picture,rect)
        @back_window.contents.blt(-24+CENTER_CHAX+180+38-20,-6+STANDARD_CHAY-2,picture,rect)
        if @effect_anime_frame >= tameframe + hatudouframe + (@effect_anime_type+1)*10
          @effect_anime_type += 1
        end
      end
    when 62 #かめはめ波乱舞横
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_カメハメ乱舞エネルギー波") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0, 0,400,152)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,100,picture,rect)
      else
        rect = Rect.new(0, 192,400,192)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,76,picture,rect)
      end
    when 63 #かめはめ乱舞(Z2)_キャラ現れる

      x = 0

      for x in 0..1
        if $partyc[@chanum.to_i] == 3 || $partyc[@chanum.to_i] == 14
          picture = Cache.picture(set_battle_character_name 6,1) if x == 0#ダメージ表示用
          picture = Cache.picture(set_battle_character_name 7,1) if x == 1#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン") if x == 0#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ") if x == 1#ダメージ表示用
        elsif $partyc[@chanum.to_i] == 6
          picture = Cache.picture(set_battle_character_name 3,1) if x == 0#ダメージ表示用
          picture = Cache.picture(set_battle_character_name 14,1) if x == 0 && $super_saiyazin_flag[1] == true
          picture = Cache.picture(set_battle_character_name 7,1) if x == 1#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") if x == 0#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ") if x == 1#ダメージ表示用
        elsif $partyc[@chanum.to_i] == 7
          picture = Cache.picture(set_battle_character_name 3,1) if x == 0#ダメージ表示用
          picture = Cache.picture(set_battle_character_name 14,1) if x == 0 && $super_saiyazin_flag[1] == true
          picture = Cache.picture(set_battle_character_name 6,1) if x == 1#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ") if x == 0#ダメージ表示用
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン") if x == 1#ダメージ表示用
        end

        rect = Rect.new(0, 0*96,96,96)
        ushirox=0
        idouryou = 8
        if x == 0
          @back_window.contents.blt(STANDARD_CHAX-ushirox+@effect_anime_frame*idouryou,STANDARD_CHAY+64,picture,rect) if $partyc[@chanum.to_i] == 3 || $partyc[@chanum.to_i] == 14
          @back_window.contents.blt(STANDARD_CHAX+@effect_anime_frame*idouryou+30,STANDARD_CHAY,picture,rect) if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7
          #p STANDARD_CHAX+@effect_anime_frame*idouryou,TEC_CENTER_CHAX if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7
        else
          @back_window.contents.blt(STANDARD_CHAX-ushirox+@effect_anime_frame*idouryou,STANDARD_CHAY-64,picture,rect) if $partyc[@chanum.to_i] == 3 || $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 14
          @back_window.contents.blt(STANDARD_CHAX-ushirox+@effect_anime_frame*idouryou,STANDARD_CHAY+64,picture,rect) if $partyc[@chanum.to_i] == 7
        end
      end
      #p STANDARD_CHAX-ushirox+@effect_anime_frame*idouryou
    when 64 #かめはめ乱舞(Z2)_キャラ現れたあと放置
      ushirox=0
      idougo = 212+24
      rect = Rect.new(0, 0*96,96,96)
      picture = Cache.picture(set_battle_character_name 3,1)
      picture = Cache.picture(set_battle_character_name 14,1) if $super_saiyazin_flag[1] == true
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY,picture,rect)
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      @back_window.contents.blt(idougo,STANDARD_CHAY+64,picture,rect)
      picture = Cache.picture(set_battle_character_name 7,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
      @back_window.contents.blt(idougo,STANDARD_CHAY-64,picture,rect)

    when 65 #かめはめ乱舞(Z2)_キャラ現れたあと発動
      ushirox=0
      idougo = 212+24
      tameframe = 120
      hatudouframe = 30

      case @effect_anime_frame

      when 0..tameframe
          rect = Rect.new(0, 2*96,96,96)
      else
          rect = Rect.new(0, 3*96,96,96)
      end
      picture = Cache.picture(set_battle_character_name 3,1)
      picture = Cache.picture(set_battle_character_name 14,1) if $super_saiyazin_flag[1] == true
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ")
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY,picture,rect)
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      @back_window.contents.blt(idougo,STANDARD_CHAY+64,picture,rect)
      picture = Cache.picture(set_battle_character_name 7,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
      @back_window.contents.blt(idougo,STANDARD_CHAY-64,picture,rect)

      if @effect_anime_frame > tameframe
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_カメハメ乱舞エネルギー波")
        #p 168+(@effect_anime_frame - tameframe)*RAY_SPEED
        rect = Rect.new(0,0,168+(@effect_anime_frame - tameframe)*RAY_SPEED,204)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      end
    when 66 #かめはめ乱舞(Z2)_キャラ現れたあと発動ヒット
      picture = Cache.picture("Z1_戦闘_必殺技_カメハメ乱舞エネルギー波") #ダメージ表示用
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴクウ")
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,152)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,100,picture,rect)
      else
        rect = Rect.new(0, 192,400,192)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,76,picture,rect)
      end
    when 67 #元気玉受け系(正面)(悟飯センター)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(桃)") #ダメージ表示用
      end
      rect = Rect.new((5-@effect_anime_type)*128, 0,128,128)
      @back_window.contents.blt(252,130,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 68 #元気玉はじく系(正面)(悟飯センター)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(桃)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(252,130-@effect_anime_frame*4,picture,rect)
      if @effect_anime_frame >= (@effect_anime_type+1) * 5
        @effect_anime_type += 1
        #@effect_anime_frame = 0
      end
    when 69 #元気玉はじく(ヒット)
      @effect_anime_type = 2
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      #if @attackcourse == 0
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y-@effect_anime_frame*4,picture,rect)
      #else
        #@back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      #end
    when 70 #操気円斬_キャラ現れる

      if $partyc[@chanum.to_i] == 6
        picture = Cache.picture(set_battle_character_name 7,0)
        #picture = Cache.picture($btl_top_file_name + "戦闘_ヤムチャ") #ダメージ表示用
        picture = Cache.picture(set_battle_character_name 7,1) if @effect_anime_frame >= 31
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ") if @effect_anime_frame >= 31
      else
        picture = Cache.picture(set_battle_character_name 6,0)
        picture = Cache.picture(set_battle_character_name 6,1) if @effect_anime_frame >= 31
        #picture = Cache.picture($btl_top_file_name + "戦闘_クリリン") #ダメージ表示用
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン") if @effect_anime_frame >= 31

      end
      #attack_se = "Z3 打撃"
      case @effect_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
      when 31..40
        rect = Rect.new(0, 0*96,96,96)
      else
        rect = Rect.new(0, 0*96,96,96)
      end
      if $partyc[@chanum.to_i] == 6
        @back_window.contents.blt(CENTER_CHAX+120,STANDARD_CHAY,picture,rect)
      else
        @back_window.contents.blt(CENTER_CHAX-66,STANDARD_CHAY,picture,rect)
      end
    when 71 #繰気弾(ヤムチャ)

      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @effect_anime_frame >= 0 && @effect_anime_frame <= 30
      elsif @effect_anime_frame == 51
          @effect_anime_type += 1
      elsif @effect_anime_frame == 71
          @effect_anime_type += 1
      elsif @effect_anime_frame == 91
          @effect_anime_type += 1
        end
    when 72 #繰気弾

      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end

      rect = Rect.new(256, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,40+@effect_anime_frame*2,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end
    when 73 #繰気弾

      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end

      rect = Rect.new(256, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(450-@effect_anime_frame*2,278-@effect_anime_frame*RAY_SPEED,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end

    when 74 #繰気弾

      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end

      rect = Rect.new(256, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(320-@effect_anime_frame*2,-100+@effect_anime_frame*RAY_SPEED,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end

    when 75 #繰気弾

      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end

      rect = Rect.new(256, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(200+@effect_anime_frame*16,278-@effect_anime_frame*RAY_SPEED,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end
    when 76 #繰気弾

      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(桃)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      end

      rect = Rect.new(256, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(660-@effect_anime_frame*20,110-@effect_anime_frame*2,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end
    when 77 #気円斬(クリリン)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") #ダメージ表示用

      rect = Rect.new(@effect_anime_type*128, 0,128,28)
      if @effect_anime_frame >= 0 && @effect_anime_frame <= 30
          #@back_window.contents.blt(252,120,picture,rect)
      elsif @effect_anime_frame == 31
          @effect_anime_type += 1
      elsif @effect_anime_frame == 41
          @effect_anime_type += 1
      elsif @effect_anime_frame == 51
          @effect_anime_type += 1
      end
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
    when 78 #操気円斬(Z2)_キャラ現れる


        if $partyc[@chanum.to_i] == 6
          picture = Cache.picture(set_battle_character_name 7,1)
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ")
        elsif $partyc[@chanum.to_i] == 7
          picture = Cache.picture(set_battle_character_name 6,1)
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
        end
        rect = Rect.new(0, 0*96,96,96)
        ushirox=0
        idouryou = 8
        if $partyc[@chanum.to_i] == 6
          @back_window.contents.blt(STANDARD_CHAX+@effect_anime_frame*idouryou+30,STANDARD_CHAY-50,picture,rect)
          #p STANDARD_CHAX+@effect_anime_frame*idouryou,TEC_CENTER_CHAX if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7
        else
          @back_window.contents.blt(STANDARD_CHAX+@effect_anime_frame*idouryou+30,STANDARD_CHAY+50,picture,rect)
        end
    when 79 #操気円斬(Z2)_キャラ現れる(放置)
      picture = Cache.picture(set_battle_character_name 6,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_クリリン")
      rect = Rect.new(0, 0*96,96,96)
      #ushirox=0
      #idouryou = 8
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
    when 80 #ダブルどどんぱ(正面)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(240+96,120,picture,rect)
      @back_window.contents.blt(240-98,110,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 81 #ダブルどどんぱエネルギー波系(小)横x2

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,28)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,144,picture,rect)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,174,picture,rect)
      else
        rect = Rect.new(0, 28,400,28)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,144,picture,rect)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,174,picture,rect)
      end
    when 82 #師弟の絆発動たま
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(250-94,114,picture,rect)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(252+96,130,picture,rect)

      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 83 #師弟の絆発動たま横
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大(師弟の絆)") #ダメージ表示用
      rect = Rect.new(0, @ray_anime_type*92,400,92)
      @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,124,picture,rect)

      if @ray_anime_frame >= 8  && @ray_anime_type == 0
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 8
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 84 #師弟の絆(Z2)_キャラ現れる


        if $partyc[@chanum.to_i] == 4
          picture = Cache.picture(set_battle_character_name 5,1)
          if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
            picture = Cache.picture(set_battle_character_name 18,1)
          end
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
        else
          picture = Cache.picture(set_battle_character_name 4,1)
          #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
        end
        rect = Rect.new(0, 0*96,96,96)
        ushirox=0
        idouryou = 8
        if $partyc[@chanum.to_i] == 4
          @back_window.contents.blt(STANDARD_CHAX+@effect_anime_frame*idouryou+30,STANDARD_CHAY-50,picture,rect)
          #p STANDARD_CHAX+@effect_anime_frame*idouryou,TEC_CENTER_CHAX if $partyc[@chanum.to_i] == 6 || $partyc[@chanum.to_i] == 7
        else
          @back_window.contents.blt(STANDARD_CHAX+@effect_anime_frame*idouryou+30,STANDARD_CHAY+50,picture,rect)
        end
    when 85 #師弟の絆(Z2)_キャラ現れる(放置)
      picture = Cache.picture(set_battle_character_name 4,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ピッコロ")
      rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
      picture = Cache.picture(set_battle_character_name 5,1)
      if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
        picture = Cache.picture(set_battle_character_name 18,1)
      end
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
      rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY-50,picture,rect)
    when 86 #師弟の絆(Z2)_キャラ現れる(放置)
      picture = Cache.picture(set_battle_character_name 5,1)
      if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
        picture = Cache.picture(set_battle_character_name 18,1)
      end
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ゴハン")
      rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY-50,picture,rect)

    when 87 #界王拳

      end_frame = 41
      picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
      attack_se = "Z1 打撃"
      case @effect_anime_frame
      when 0..4
        battle_anime_change 0,7
        battle_anime_change 0,11 if $super_saiyazin_flag[1] == true
      when 5..8
        battle_anime_change 0,9
        battle_anime_change 0,13 if $super_saiyazin_flag[1] == true
      when 9..12
        battle_anime_change 0,10
        battle_anime_change 0,14 if $super_saiyazin_flag[1] == true
      when 13..16
        battle_anime_change 0,9
        battle_anime_change 0,13 if $super_saiyazin_flag[1] == true
      when 17..20
        battle_anime_change 0,10
        battle_anime_change 0,14 if $super_saiyazin_flag[1] == true
      when 21..23
        battle_anime_change 0,11
        battle_anime_change 0,15 if $super_saiyazin_flag[1] == true
      when 24..26
        battle_anime_change 0,12
        battle_anime_change 0,16 if $super_saiyazin_flag[1] == true
      when 27..30
        battle_anime_change 0,11
        battle_anime_change 0,15 if $super_saiyazin_flag[1] == true
      when 31..33
        battle_anime_change 0,9
        battle_anime_change 0,13 if $super_saiyazin_flag[1] == true
      when 34..36
        battle_anime_change 0,10
        battle_anime_change 0,14 if $super_saiyazin_flag[1] == true
      when 37..40
        battle_anime_change 0,12
        battle_anime_change 0,16 if $super_saiyazin_flag[1] == true
      when 41..43
        battle_anime_change 0,11
        battle_anime_change 0,15 if $super_saiyazin_flag[1] == true
      else
        battle_anime_change 0,10
        battle_anime_change 0,14 if $super_saiyazin_flag[1] == true
      end

      if @effect_anime_frame % 4 == 0 && end_frame > @effect_anime_frame
        Audio.se_play("Audio/SE/" + attack_se)    # 効果音を再生する
      end
    when 88 #サイコアタック
      if @btl_ani_cha_chg_no == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
      end
      rect = Rect.new(0, 4*96,96,96)

      rect = Rect.new(0, 5*96,96,96) if @effect_anime_frame > 21
      if @effect_anime_frame <= 21
        @back_window.contents.blt(STANDARD_ENEX+60-@effect_anime_frame*RAY_SPEED,STANDARD_CHAY-24,picture,rect)
      else
        @back_window.contents.blt(STANDARD_ENEX+74-21*RAY_SPEED,STANDARD_CHAY-8,picture,rect)
      end
    when 89 #スパーキングコンボキャラ現れる2人目上
        picture = Cache.picture(set_battle_character_name @scombo_cha2,1)
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)

        rect = Rect.new(0, 0*96,96,96)
        ushirox=0
        idouryou = 8
        @back_window.contents.blt(STANDARD_CHAX+@effect_anime_frame*idouryou+30,STANDARD_CHAY-50,picture,rect)
    when 90 #スパーキングコンボキャラ現れる2人目下
        picture = Cache.picture(set_battle_character_name @scombo_cha2,1)
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)

        rect = Rect.new(0, 0*96,96,96)
        ushirox=0
        idouryou = 8
        @back_window.contents.blt(STANDARD_CHAX+@effect_anime_frame*idouryou+30,STANDARD_CHAY+50,picture,rect)
    when 91 #スパーキングコンボキャラ現れる2人目放置(上)
      picture = Cache.picture(set_battle_character_name @scombo_cha2,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)
        rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY-50,picture,rect)
    when 92 #スパーキングコンボキャラ現れる2人目放置(下)
      picture = Cache.picture(set_battle_character_name @scombo_cha2,1)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)
        rect = Rect.new(0, 0*96,96,96)
      @back_window.contents.blt(TEC_CENTER_CHAX,STANDARD_CHAY+50,picture,rect)
    when 93 #ダイナマイトキック

      end_frame = 50
      end_frame2 = 150
      tyousei_x = 0
      tyousei_y = 0
      if @btl_ani_cha_chg_no == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
      end
      attack_se = "Z1 打撃"
      case @effect_anime_frame

      when 0..7
        rect = Rect.new(0, 1*96,96,96)
      when 8..15
        rect = Rect.new(0, 2*96,96,96)
      when 16..23
        rect = Rect.new(0, 1*96,96,96)
      when 24..31
        rect = Rect.new(0, 2*96,96,96)
      when 32..39
        rect = Rect.new(0, 1*96,96,96)
      when 40..47
        rect = Rect.new(0, 2*96,96,96)
      when 51..60
        rect = Rect.new(0, 3*96,96,96)
        tyousei_x -= (@effect_anime_frame-end_frame) * 8
        tyousei_y -= (@effect_anime_frame-end_frame) * 4
      when 61..70
        rect = Rect.new(0, 4*96,96,96)
        tyousei_x -= (@effect_anime_frame-end_frame) * 8
        tyousei_y -= (@effect_anime_frame-end_frame) * 4
      when 71..80
        rect = Rect.new(0, 5*96,96,96)
        tyousei_x -= (@effect_anime_frame-end_frame) * 8
        tyousei_y -= (@effect_anime_frame-end_frame) * 4
      else
        rect = Rect.new(0, 0*96,96,96)
=begin
        when 44..46
        rect = Rect.new(0, 2*96,96,96)
      when 47..50
        rect = Rect.new(0, 4*96,96,96)
      when 51..53
        rect = Rect.new(0, 2*96,96,96)
      when 54..56
        rect = Rect.new(0, 1*96,96,96)
      when 57..60
        rect = Rect.new(0, 2*96,96,96)
      when 61..80
        rect = Rect.new(0, 16*96,96,96)
      else
        #when 81..85

        if @btl_ani_cha_chg_no == 0
          if $btl_progress >= 2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
            rect = Rect.new(0, 3*96,96,96)
          else
            picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
            rect = Rect.new(0, 2*96,96,96)
          end
        else
          if $btl_progress >= 2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
            rect = Rect.new(0, 3*96,96,96)
          else
            picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
            rect = Rect.new(0, 2*96,96,96)
          end

        end
=end
      #else

        #if @btl_ani_cha_chg_no == 0
        #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
        #else
        #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
        #end
        #if $btl_progress >= 2
        #  rect = Rect.new(0, 3*96,96,96)
        #else
        #  rect = Rect.new(0, 3*96,96,96)
        #end
      end

      if @effect_anime_frame % 8 == 0 && end_frame > @effect_anime_frame
        Audio.se_play("Audio/SE/" + attack_se)    # 効果音を再生する
      end

      #if @effect_anime_frame >= 61 && @effect_anime_frame <= 80
      #  @back_window.contents.blt(CENTER_CHAX-(@effect_anime_frame-60)*8,STANDARD_CHAY,picture,rect)
      #elsif @effect_anime_frame >= 81 && @effect_anime_frame <= 84
      #  @back_window.contents.blt(80+(@effect_anime_frame-80)*16,STANDARD_CHAY,picture,rect)
      #else #if @effect_anime_frame < 86
        #@back_window.contents.blt(CENTER_CHAX,STANDARD_CHAY,picture,rect)

        @back_window.contents.blt(TEC_CENTER_CHAX+tyousei_x,STANDARD_CHAY+tyousei_y,picture,rect)
      if end_frame == @effect_anime_frame
        #@enerect = Rect.new(0 , 0+(96*1), 96, 96)
        Audio.se_play("Audio/SE/" + "ZG 打撃2")
      end
      #end
    when 94 #氷結攻撃
      if ray_x == 0 || ray_x == nil
        ray_x = 230
        ray_y = 120
      end
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_氷(FF3)") #ダメージ表示用

      rect = Rect.new(@effect_anime_type*96, 0,96,96)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @effect_anime_frame == 8
          @effect_anime_type += 1
        elsif @effect_anime_frame == 16
          @effect_anime_type += 1
        #elsif @effect_anime_frame == 76
        #  @effect_anime_type += 1
      end
    when 95 #亀仙流かめはめは_発動Z1
     picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
        rect = Rect.new(@effect_anime_type*128, 0,128,128)
        @back_window.contents.blt(-44+CENTER_CHAX-120+8-28,-2+STANDARD_CHAY+4,picture,rect) #クリリン
        @back_window.contents.blt(172,116,picture,rect)
        @back_window.contents.blt(310,126,picture,rect)

        @back_window.contents.blt(-8+CENTER_CHAX+180+38-20,-6+STANDARD_CHAY+4,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 96 #亀仙流かめはめは_発動Z2
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大") #ダメージ表示用
        rect = Rect.new(0, 192,192+@effect_anime_frame*RAY_SPEED,192)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
    when 97 #エネルギー弾系(正面)フォトンストライク
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      end

      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(212,102,picture,rect)
      @back_window.contents.blt(288,102,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 98 #エネルギー波大横(敵)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_敵_大") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,88)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,134-44,picture,rect)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,134+44,picture,rect)
      else
        rect = Rect.new(0, 88,400,88)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,134+44,picture,rect)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,134-44,picture,rect)
      end
    when 99 #師弟の絆発動たま
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(250-94,114,picture,rect)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(252+90,122,picture,rect)

      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
    when 101 #爆発小
      picture = Cache.picture("戦闘アニメ_爆発1") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*96, 0,96,96)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end

      if @damage_center == false
        if @attackcourse == 0
          @back_window.contents.blt(320,120,picture,rect)
        else
          @back_window.contents.blt(230,120,picture,rect)
        end
      else
        if @attackcourse == 0
          @back_window.contents.blt(320-64,120,picture,rect)
        else
          @back_window.contents.blt(230,120,picture,rect)
        end
      end
    when 102 #爆発中
      picture = Cache.picture("戦闘アニメ_爆発3") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*112, 0,112,120)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
      if @damage_center == false
        if @attackcourse == 0
          @back_window.contents.blt(318,120,picture,rect)
        else
          @back_window.contents.blt(230,120,picture,rect)
        end
      else
        if @attackcourse == 0
          @back_window.contents.blt(254,120,picture,rect)
        else
          @back_window.contents.blt(254,120,picture,rect)
        end
      end
    when 103 #爆発大
      picture = Cache.picture("戦闘アニメ_爆発4") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*176, 0,176,144)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
      if @damage_center == false
        if @attackcourse == 0
          @back_window.contents.blt(298,120,picture,rect)
        else
          @back_window.contents.blt(204,120,picture,rect)
        end
      else
        if @attackcourse == 0
          @back_window.contents.blt(234,120,picture,rect)
        else
          @back_window.contents.blt(234,120,picture,rect)
        end
      end
    when 104 #爆発大Z2
      picture = Cache.picture("戦闘アニメ_爆発5") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*158, 0,158,160)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
      if @damage_center == false
        if @attackcourse == 0
          @back_window.contents.blt(298-16,120-16,picture,rect)
        else
          @back_window.contents.blt(204-16,120-16,picture,rect)
        end
      else
        if @attackcourse == 0
          @back_window.contents.blt(298-16-64,120-16,picture,rect)
        else
          @back_window.contents.blt(204-16,120-16,picture,rect)
        end
      end
    when 105 #爆発特大Z2
      picture = Cache.picture("戦闘アニメ_爆発6") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*256, 0,256,256)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
      if @damage_center == false
        if @attackcourse == 0
          @back_window.contents.blt(298-64,110-64,picture,rect)
        else
          @back_window.contents.blt(204-56,110-64,picture,rect)
        end
      else
        if @attackcourse == 0
          @back_window.contents.blt(298-64-64,110-64,picture,rect)
        else
          @back_window.contents.blt(204-56,110-64,picture,rect)
        end
      end
    when 106 #爆発大(縦センター
      picture = Cache.picture("戦闘アニメ_爆発4") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*176, 0,176,144)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
        if @attackcourse == 0
          @back_window.contents.blt(270,88,picture,rect)
          #@back_window.contents.blt(234,88,picture,rect)
        else
          @back_window.contents.blt(200,88,picture,rect)
          #@back_window.contents.blt(214,88,picture,rect)
        end
    when 107 #巻きつく

      if $cha_bigsize_on[@chanum] == true
        picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル") #ダメージ表示用
        rect = Rect.new(146,38, 640,26)
        @back_window.contents.blt(ray_x+48,ray_y+6,picture,rect)

        picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル_巻きつく(大)") #ダメージ表示用
        rect = Rect.new(0, 0,128,80)
        @back_window.contents.blt(ray_x-72,ray_y-12,picture,rect)

      else
        picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル") #ダメージ表示用
        rect = Rect.new(146,38, 640,26)
        @back_window.contents.blt(ray_x+56,ray_y+6,picture,rect)

        picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル_巻きつく") #ダメージ表示用
        rect = Rect.new(0, 0,64,40)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)

      end
    when 118 #攻撃回避(任意位置攻撃側を巨大判定)

      if @effect_anime_frame % 4 == 0
        if @attackcourse == 0
          if $cha_bigsize_on[@chanum] != true
            picture = Cache.picture("戦闘アニメ") #ダメージ表示
            rect = Rect.new(0,48, 64, 64)
            @back_window.contents.blt(ray_x,ray_y,picture,rect)
          else
            picture = Cache.picture("戦闘アニメ96×96用回避") #ダメージ表示
            rect = Rect.new(0,0, 128, 128)
            @back_window.contents.blt(ray_x-32,ray_y-32,picture,rect)
          end

          #@back_window.contents.blt(@chax+96,@chay+32,picture,rectb)
          #@back_window.contents.blt(@enex+32,@eney+16+500,picture,rect)
        else
          if $data_enemies[@enedatenum].element_ranks[23] != 1
            picture = Cache.picture("戦闘アニメ") #ダメージ表示
            rect = Rect.new(0,48, 64, 64)
            @back_window.contents.blt(ray_x,ray_y,picture,rect)
          else
            picture = Cache.picture("戦闘アニメ96×96用回避") #ダメージ表示
            rect = Rect.new(0,0, 128, 128)
            @back_window.contents.blt(ray_x-32,ray_y-32,picture,rect)
          end

          #@back_window.contents.blt(@enex-96,@chay+32,picture,rectb)

        end

      end
    when 119 #攻撃回避(任意位置防御側を巨大判定)

      if @effect_anime_frame % 4 == 0
        if @attackcourse == 0

          if $data_enemies[@enedatenum].element_ranks[23] != 1
            picture = Cache.picture("戦闘アニメ") #ダメージ表示
            rect = Rect.new(0,48, 64, 64)
            @back_window.contents.blt(ray_x,ray_y,picture,rect)
          else
            picture = Cache.picture("戦闘アニメ96×96用回避") #ダメージ表示
            rect = Rect.new(0,0, 128, 128)
            @back_window.contents.blt(ray_x-32,ray_y-32,picture,rect)
          end
          #@back_window.contents.blt(@chax+96,@chay+32,picture,rectb)
          #@back_window.contents.blt(@enex+32,@eney+16+500,picture,rect)
        else

          if $cha_bigsize_on[@chanum] != true
            picture = Cache.picture("戦闘アニメ") #ダメージ表示
            rect = Rect.new(0,48, 64, 64)
            @back_window.contents.blt(ray_x,ray_y,picture,rect)
          else
            picture = Cache.picture("戦闘アニメ96×96用回避") #ダメージ表示
            rect = Rect.new(0,0, 128, 128)
            @back_window.contents.blt(ray_x-32,ray_y-32,picture,rect)
          end
          #@back_window.contents.blt(@enex-96,@chay+32,picture,rectb)

        end

      end
    when 120 #攻撃回避

      if @effect_anime_frame % 4 == 0
        if @attackcourse == 0

          if $data_enemies[@enedatenum].element_ranks[23] != 1
            picture = Cache.picture("戦闘アニメ") #ダメージ表示
            rect = Rect.new(0,48, 64, 64)
            @back_window.contents.blt(@enex+32,@eney+16+500,picture,rect)
          else
            picture = Cache.picture("戦闘アニメ96×96用回避") #ダメージ表示
            rect = Rect.new(0,0, 128, 128)
            @back_window.contents.blt(@enex+32,@eney+16+500-32,picture,rect)
          end
          #@back_window.contents.blt(@chax+96,@chay+32,picture,rectb)
          #@back_window.contents.blt(@enex+32,@eney+16+500,picture,rect)
        else

          if $cha_bigsize_on[@chanum] != true
            picture = Cache.picture("戦闘アニメ") #ダメージ表示
            rect = Rect.new(0,48, 64, 64)
            @back_window.contents.blt(@chax+8,@chay+16+500,picture,rect)
          else
            picture = Cache.picture("戦闘アニメ96×96用回避") #ダメージ表示
            rect = Rect.new(0,0, 128, 128)
            @back_window.contents.blt(@chax+8-64,@chay+16+500-32,picture,rect)
          end
          #@back_window.contents.blt(@enex-96,@chay+32,picture,rectb)

        end

      end
    when 121 #攻撃ヒット
      picture = Cache.picture("戦闘アニメ") #ダメージ表示用
      rectb = Rect.new(32*0,16, 32, 32)
      rectc = Rect.new(32,0, 32, 16)
      if @effect_anime_frame >= 0 && @effect_anime_frame <= 4
        if @attackcourse == 0
          @back_window.contents.blt(@chax+96,@chay+32,picture,rectb)
          if $data_enemies[@enedatenum].element_ranks[23] != 1
            @back_window.contents.blt(@enex,@eney,picture,rectc)
          else
            @back_window.contents.blt(@enex,@eney-48,picture,rectc)
          end
        else
          @back_window.contents.blt(@enex-32,@eney+32,picture,rectb)
          @back_window.contents.blt(@chax+64,@chay,picture,rectc)
        end
      elsif @effect_anime_frame >= 5 && @effect_anime_frame <= 10
        rectb = Rect.new(32*1,16, 32, 32)
        if @attackcourse == 0
          @back_window.contents.blt(@chax+96,@chay+32,picture,rectb)
          if $data_enemies[@enedatenum].element_ranks[23] != 1
            @back_window.contents.blt(@enex,@eney,picture,rectc)
          else
            @back_window.contents.blt(@enex,@eney-48,picture,rectc)
          end
        else
          @back_window.contents.blt(@enex-32,@chay+32,picture,rectb)
          @back_window.contents.blt(@chax+64,@chay,picture,rectc)
        end

      end
    when 122 #キャラぶつかる(センター)
      picture = Cache.picture("戦闘アニメ") #ダメージ表示用
      rectb = Rect.new(32,16, 32, 32)
      @back_window.contents.blt(640/2-16,480/2-90,picture,rectb)
    when 123 #キャラぶつかる自由位置
      picture = Cache.picture("戦闘アニメ") #ダメージ表示用

      if @effect_anime_frame >= 0 && @effect_anime_frame <= 4
        rectb = Rect.new(32*0,16, 32, 32)
      elsif @effect_anime_frame >= 5 #&& @effect_anime_frame <= 10
        rectb = Rect.new(32*1,16, 32, 32)
      end
      @back_window.contents.blt(ray_x,ray_y,picture,rectb)
    when 124 #キラーン自由位置
      picture = Cache.picture("戦闘アニメ_キラーン") #ダメージ表示用

      if @effect_anime_frame >= 0 && @effect_anime_frame <= 7
        rect = Rect.new(32*0,0, 32, 32)
      elsif @effect_anime_frame >= 8 && @effect_anime_frame <= 15
        rect = Rect.new(32*1,0, 32, 32)
      elsif @effect_anime_frame >= 16 && @effect_anime_frame <= 23
        rect = Rect.new(32*2,0, 32, 32)
      elsif @effect_anime_frame >= 24 && @effect_anime_frame <= 31
        rect = Rect.new(32*1,0, 32, 32)
      elsif @effect_anime_frame >= 32 && @effect_anime_frame <= 39
        rect = Rect.new(32*0,0, 32, 32)
      else
        rect = Rect.new(0,0,0,0)
      end
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
    when 125 #攻撃ヒット自由位置
      picture = Cache.picture("戦闘アニメ") #ダメージ表示用
      rectb = Rect.new(32*0,16, 32, 32)
      rectc = Rect.new(32,0, 32, 16)
      if @effect_anime_frame >= 0 && @effect_anime_frame <= 4
        if @attackcourse == 0
          @back_window.contents.blt(ray_x,ray_y,picture,rectb)
          #if $data_enemies[@enedatenum].element_ranks[23] != 1
          #  @back_window.contents.blt(ray_x,ray_y,picture,rectc)
          #else
          #  @back_window.contents.blt(ray_x,ray_y-48,picture,rectc)
          #end
        else
          @back_window.contents.blt(ray_x,ray_y,picture,rectb)
          #@back_window.contents.blt(ray_x+64,ray_y,picture,rectc)
        end
      elsif @effect_anime_frame >= 5 && @effect_anime_frame <= 10
        rectb = Rect.new(32*1,16, 32, 32)
        if @attackcourse == 0
          @back_window.contents.blt(ray_x,ray_y,picture,rectb)
          #if $data_enemies[@enedatenum].element_ranks[23] != 1
          #  @back_window.contents.blt(ray_x,ray_y,picture,rectc)
          #else
          #  @back_window.contents.blt(ray_x,ray_y-48,picture,rectc)
          #end
        else
          @back_window.contents.blt(ray_x,ray_y,picture,rectb)
          #@back_window.contents.blt(ray_x+64,ray_y,picture,rectc)
        end

      end
#Z2
    when 201 #エネルギー弾系(発動)
      @effect_anime_type = 2
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        if @ray_spd_up_flag == false
          @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
        else
          @back_window.contents.blt(ray_x+@effect_anime_frame*(RAY_SPEED+@ray_spd_up_num),ray_y,picture,rect)
        end
      else
        if @ray_spd_up_flag == false
          @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
        else
          @back_window.contents.blt(ray_x-@effect_anime_frame*(RAY_SPEED+@ray_spd_up_num),ray_y,picture,rect)
        end
      end

      #if @effect_anime_frame >= 10
      #  @effect_anime_type += 1
      #  @effect_anime_frame = 0
      #end
    when 202 #エネルギー弾系(ヒット)
      @effect_anime_type = 2
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,96,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,96,picture,rect)
      end
    when 203 #かめはめ波系(発動)
      #@effect_anime_type = 2
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2(青)") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,96,64)
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 64,96,64)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 204 #かめはめ波系(ヒット)
      #@effect_anime_type = 2
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2(青)") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 0,96,64)
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,144,picture,rect)
      else
        rect = Rect.new(0, 64,96,64)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,144,picture,rect)
      end
    when 205 #界王拳系(ヒット)
      #@effect_anime_type = 2
      if @ray_color == 0

        if $super_saiyazin_flag[1] == true
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_界王拳(超悟空)") #ダメージ表示用
        else
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_界王拳") #ダメージ表示用
        end
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_スピードアタック") #ダメージ表示用
      end
      #if @effect_anime_frame >= 10 && @effect_anime_type == 0
        #@effect_anime_type += 1
        #@effect_anime_frame = 0
      #elsif @effect_anime_frame >= 10 && @effect_anime_type == 1
        #@effect_anime_type = 0
        #@effect_anime_frame = 0
      #end
      if @attackcourse == 0
        rect = Rect.new(0, 0,236,122)
        @back_window.contents.blt(-236+@effect_anime_frame*RAY_SPEED,120,picture,rect)
      else
        rect = Rect.new(0, 0,236,122)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end
    when 206 #界王拳かめはめ波系(発動)
      #@effect_anime_type = 2

      if $btl_progress < 2
        if @ray_color == 0

          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3") #ダメージ表示用
        elsif @ray_color == 1
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(緑)") #ダメージ表示用
        elsif @ray_color == 3
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(青)") #ダメージ表示用
        #elsif @ray_color == 4
        #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(桃)") #ダメージ表示用
        end
      else
        if @ray_color == 0

          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") #ダメージ表示用
        elsif @ray_color == 1
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(緑)") #ダメージ表示用
        elsif @ray_color == 3
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(青)") #ダメージ表示用
        elsif @ray_color == 4
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(桃)") #ダメージ表示用
        end
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,222,134)
        rect = Rect.new(0, 0,190,126) if $btl_progress >= 2
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 128,192,128)
        rect = Rect.new(0, 126,190,126) if $btl_progress >= 2
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 207 #界王拳かめはめ波系(ヒット)
      #@effect_anime_type = 2
      if $btl_progress < 2
        if @ray_color == 0

          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3") #ダメージ表示用
        elsif @ray_color == 1
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(緑)") #ダメージ表示用
        elsif @ray_color == 3
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(青)") #ダメージ表示用
        end
      else
        if @ray_color == 0
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") #ダメージ表示用
        elsif @ray_color == 1
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(緑)") #ダメージ表示用
        elsif @ray_color == 3
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(青)") #ダメージ表示用
        elsif @ray_color == 4
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(桃)") #ダメージ表示用
        end
      end
      if @attackcourse == 0
        rect = Rect.new(0, 0,222,134)
        rect = Rect.new(0, 0,190,126) if $btl_progress >= 2
        @back_window.contents.blt(-192+@effect_anime_frame*RAY_SPEED,96,picture,rect)
      else
        rect = Rect.new(0, 128,192,128)
        rect = Rect.new(0, 126,190,126) if $btl_progress >= 2
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,96,picture,rect)
      end
    when 208 #元気弾系(発動)
      @effect_anime_type = 3
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 209 #元気弾系(ヒット)
      @effect_anime_type = 3
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,112,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,112,picture,rect)
      end
    when 210 #超元気弾系(発動)
      @effect_anime_type = 5
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 211 #超元気弾系(ヒット)
      @effect_anime_type = 5
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,112,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,112,picture,rect)
      end
    when 212 #目から怪光線系(発動)
      @effect_anime_type = 1
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end

    when 213 #目から怪光線系(ヒット)
      @effect_anime_type = 1
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,96,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,96,picture,rect)
      end
    when 214 #魔貫光殺砲系(発動)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_魔貫光殺砲") #ダメージ表示用
      rect = Rect.new(0, 46,54+@effect_anime_frame*RAY_SPEED,46)
      if @attackcourse == 0
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      end

    when 215 #魔貫光殺砲系(ヒット)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_魔貫光殺砲") #ダメージ表示用
      rect = Rect.new(0, 0,400,46)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,140,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,140,picture,rect)
      end
    when 216 #拡散エネルギー波系(発動)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") #ダメージ表示用
      rect = Rect.new(0, 112,54+@effect_anime_frame*RAY_SPEED,112)
      if @attackcourse == 0
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      end

    when 217 #拡散エネルギー波系(ヒット)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") #ダメージ表示用
      rect = Rect.new(0, 0,400,112)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,122,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,122,picture,rect)
      end
    when 218 #気円斬系(発動)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") #ダメージ表示用
      picture = Cache.picture("Z2_戦闘_必殺技_気円斬") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, 0,128,44)
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 0,128,44)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 219 #気円斬系(ヒット)
      #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") #ダメージ表示用
      picture = Cache.picture("Z2_戦闘_必殺技_気円斬") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, 0,192,128)
        @back_window.contents.blt(-192+@effect_anime_frame*RAY_SPEED,150,picture,rect)
      else
        rect = Rect.new(0, 0,192,128)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,150,picture,rect)
      end
    when 220 #繰気弾系(発動)
      @effect_anime_type = 2
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 221 #繰気弾系(ヒット)
      @effect_anime_type = 2
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,120,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end
    when 222 #四身の拳

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") #ダメージ表示用
      case @effect_anime_frame

      when 0..30
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * @effect_anime_frame+26,ray_y-1* @effect_anime_frame,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * @effect_anime_frame+26,ray_y+1* @effect_anime_frame,picture,rect)
      when 31..59

        rect = Rect.new(0 , 0+(96*3), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        if @effect_anime_frame == 59
          Audio.se_play("Audio/SE/" + "Z1 分身")    # 効果音を再生する
        end
      when 60..120
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        @back_window.contents.blt(ray_x+0.5 * (@effect_anime_frame-30)+26,ray_y-1* (@effect_anime_frame-30),picture,rect)
        @back_window.contents.blt(ray_x-0.5 * (@effect_anime_frame-30)+26,ray_y+1* (@effect_anime_frame-30),picture,rect)
      when 121..150
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        @back_window.contents.blt(ray_x+0.5 * 90+26,ray_y-1* 90,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 90+26,ray_y+1* 90,picture,rect)
      else
        if @effect_anime_frame == 151
          #Audio.se_play("Audio/SE/" + "Z1 ザー")    # 効果音を再生する
          Audio.se_play("Audio/SE/" + "Z3 エネルギー波")    # 効果音を再生する
        end
        rect = Rect.new(0 , 0+(96*1), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 90+26,ray_y-1* 90,picture,rect)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 90+26,ray_y+1* 90,picture,rect)
        @effect_anime_type = 2
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
        rect = Rect.new(@effect_anime_type*128, 0,128,128)
        if @attackcourse == 0
          @back_window.contents.blt(ray_x+0.5 * 90+26+(@effect_anime_frame-150)*RAY_SPEED,ray_y-20-1* 90,picture,rect)
          @back_window.contents.blt(ray_x+0.5 * 30+26+(@effect_anime_frame-150)*RAY_SPEED,ray_y-20-1*30,picture,rect)
          @back_window.contents.blt(ray_x-0.5 * 30+26+(@effect_anime_frame-150)*RAY_SPEED,ray_y-20+1*30,picture,rect)
          @back_window.contents.blt(ray_x-0.5 * 90+26+(@effect_anime_frame-150)*RAY_SPEED,ray_y-20+1* 90,picture,rect)
        else
          @back_window.contents.blt(ray_x-@effect_anime_frame-150*RAY_SPEED,ray_y,picture,rect)
        end
      end
    when 223 #エネルギー弾系(ヒット)
      @effect_anime_type = 2
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,STANDARD_CHAY-20-1* 90+@effect_anime_frame*3,picture,rect)
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,STANDARD_CHAY-20-1*30+@effect_anime_frame*1,picture,rect)
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,STANDARD_CHAY-20+1*30-@effect_anime_frame*1,picture,rect)
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,STANDARD_CHAY-20+1* 90-@effect_anime_frame*3,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,STANDARD_CHAY,picture,rect)
      end
    when 224 #四身の拳

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") #ダメージ表示用
      case @effect_anime_frame

      when 0..30
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * @effect_anime_frame+26,ray_y-1* @effect_anime_frame,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * @effect_anime_frame+26,ray_y+1* @effect_anime_frame,picture,rect)
      when 31..59

        rect = Rect.new(0 , 0+(96*3), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        if @effect_anime_frame == 59
          Audio.se_play("Audio/SE/" + "Z1 分身")    # 効果音を再生する
        end
      when 60..120
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        @back_window.contents.blt(ray_x+0.5 * (@effect_anime_frame-30)+26,ray_y-1* (@effect_anime_frame-30),picture,rect)
        @back_window.contents.blt(ray_x-0.5 * (@effect_anime_frame-30)+26,ray_y+1* (@effect_anime_frame-30),picture,rect)
      when 121..150
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        @back_window.contents.blt(ray_x+0.5 * 90+26,ray_y-1* 90,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 90+26,ray_y+1* 90,picture,rect)
      else
        if @effect_anime_frame == 151
          Audio.se_play("Audio/SE/" + "Z1 ザー")    # 効果音を再生する
          #Audio.se_play("Audio/SE/" + "Z3 エネルギー波")    # 効果音を再生する
        end
        rect = Rect.new(0 , 0+(96*2), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 90+26,ray_y-1* 90,picture,rect)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 90+26,ray_y+1* 90,picture,rect)
        @effect_anime_type = 2
      end
    when 225 #エネルギー波_小系(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      end

      rect = Rect.new(0, 48,54+@effect_anime_frame*RAY_SPEED,48)
      if @attackcourse == 0
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
        @back_window.contents.blt(ray_x-92-@effect_anime_frame*RAY_SPEED,ray_y-10,picture,rect)
      end

    when 226 #エネルギー波_小系(ヒット)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      end
      rect = Rect.new(0, 0,400,48)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,148,picture,rect)
      else
        rect = Rect.new(0, 48,400,48)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,148,picture,rect)
      end
    when 227 #エネルギー波_小系(発動)敵
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_緑") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_赤") #ダメージ表示用
      end
      #rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
      if @attackcourse == 0
        rect = Rect.new(0, 48,54+@effect_anime_frame*RAY_SPEED,48)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
        @back_window.contents.blt(ray_x-92-@effect_anime_frame*RAY_SPEED,ray_y-10,picture,rect)
      end
    when 228 #エネルギー波_小系(ヒット敵)敵
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_緑") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_赤") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,400,48)
        @back_window.contents.blt(-450+@effect_anime_frame*RAY_SPEED,148,picture,rect)
      else
        rect = Rect.new(0, 48,400,48)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED+64,148,picture,rect)
      end
    when 229 #衝撃波系(発動)敵
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系_赤") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,30,116)
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 116,30,116)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 230 #衝撃波系(ヒット)敵
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_衝撃系_赤") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,30,116)
        @back_window.contents.blt(-64+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 116,30,116)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 231 #拡散エネルギー波系(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_青_敵") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_赤_敵") #ダメージ表示用
      end
      rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 112,54+@effect_anime_frame*RAY_SPEED,112)
      if @attackcourse == 0
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end

    when 232 #拡散エネルギー波系(ヒット)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_青_敵") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_赤_敵") #ダメージ表示用
      end

      rect = Rect.new(0, 0,400,112)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,122,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,122,picture,rect)
      end
    when 233 #口から怪光線ドドリア系(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 234 #口から怪光線ドドリア系(ヒット)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_緑") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,400,80)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 80,400,80)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 235 #スーパーカメハメ波ため
      if @ray_color == 3
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)(青)") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)(緑)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)(赤)") #ダメージ表示用
      else
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)") #ダメージ表示用
      end
      rect = Rect.new(32*@ray_anime_type, 0,32,32)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @ray_anime_frame >= 4  && @ray_anime_type != 4
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 4
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 236 #スーパーカメハメ波発動
      if @attackcourse == 0 && mirror_pattern == 0
        if @ray_color == 0
          picture = Cache.picture("Z3_必殺技_超カメハメ波") #ダメージ表示用
        elsif @ray_color == 3
          picture = Cache.picture("Z3_必殺技_超カメハメ波_青") #ダメージ表示用
        end
      else
        if @ray_color == 0
          picture = Cache.picture("Z3_必殺技_超カメハメ波_反転") #ダメージ表示用
        elsif @ray_color == 3
          picture = Cache.picture("Z3_必殺技_超カメハメ波_青_反転") #ダメージ表示用
        end
      end

      if @attackcourse == 0 && mirror_pattern == 0
        rect = Rect.new(0, 0,54+@effect_anime_frame*RAY_SPEED,350)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        if 500-54-@effect_anime_frame*RAY_SPEED <= 500
          rect = Rect.new(500-54-@effect_anime_frame*RAY_SPEED, 0,500-54+@effect_anime_frame*RAY_SPEED,350)
        else
          rect = Rect.new(0, 0,500,350)
        end
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      end
    when 237 #ファイナルリベンジャーため(小)
      if @ray_color == 3
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅小)(青)") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅小)(緑)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅小)(赤)") #ダメージ表示用
      else
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅小)") #ダメージ表示用
      end
      rect = Rect.new(16*@ray_anime_type, 0,16,16)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @ray_anime_frame >= 4  && @ray_anime_type != 4
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 4
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 238
      #@effect_anime_type = 2

      if $super_saiyazin_flag[7] == true
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ファイナルリベンジャー_超") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ファイナルリベンジャー") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(236*@ray_anime_type, 0,236,122)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new(0, 0,236,122)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end
      if @ray_anime_frame >= 8  && @ray_anime_type == 0
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 8
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 239 #エネルギーは大(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        if @ray_color == 0
          rect = Rect.new(0, 92,144+@effect_anime_frame*RAY_SPEED,92)
        elsif @ray_color == 1
          rect = Rect.new(0, 92,144+@effect_anime_frame*RAY_SPEED,92)
        elsif @ray_color == 3
          rect = Rect.new(0, 122,144+@effect_anime_frame*RAY_SPEED,122)
        elsif @ray_color == 4
          rect = Rect.new(0, 122,144+@effect_anime_frame*RAY_SPEED,122)
        end
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        if @ray_color == 0
          rect = Rect.new(256-@effect_anime_frame*RAY_SPEED, 0,144+@effect_anime_frame*RAY_SPEED,92)
        elsif @ray_color == 1
          rect = Rect.new(256-@effect_anime_frame*RAY_SPEED, 0,144+@effect_anime_frame*RAY_SPEED,92)
        elsif @ray_color == 3
          rect = Rect.new(256-@effect_anime_frame*RAY_SPEED, 0,144+@effect_anime_frame*RAY_SPEED,122)
        elsif @ray_color == 4
          rect = Rect.new(256-@effect_anime_frame*RAY_SPEED, 0,144+@effect_anime_frame*RAY_SPEED,122)
        end
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 240 #エネルギーは大(ヒット)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_大_敵_赤") #ダメージ表示用
      end

      if @attackcourse == 0
        if @ray_color == 0
          rect = Rect.new(0, 0,400,92)
        elsif @ray_color == 1
          rect = Rect.new(0, 0,400,92)
        elsif @ray_color == 3
          rect = Rect.new(0, 0,400,122)
        elsif @ray_color == 4
          rect = Rect.new(0, 0,400,122)
        end

        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        if @ray_color == 0
          rect = Rect.new(0, 92,400,92)
        elsif @ray_color == 1
          rect = Rect.new(0, 92,400,92)
        elsif @ray_color == 3
          rect = Rect.new(0, 122,400,122)
        elsif @ray_color == 4
          rect = Rect.new(0, 122,400,122)
        end

        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 241 #拡散エネルギー波系(発動)
      if @ray_anime_type == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_青_敵") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_赤_敵") #ダメージ表示用
      end

      rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 112,54+@effect_anime_frame*RAY_SPEED,112)

      if @attackcourse == 0
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end

      if @ray_anime_frame >= 2  && @ray_anime_type != 2
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 2
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end

    when 242 #拡散エネルギー波系(ヒット)
      if @ray_anime_type == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_青_敵") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_拡散エネルギー波_赤_敵") #ダメージ表示用
      end

      rect = Rect.new(0, 0,400,112)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,122,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,122,picture,rect)
      end

      if @ray_anime_frame >= 2  && @ray_anime_type != 2
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 2
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 243 #気円斬系(ヒット)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_気円斬") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0, 0,192,128)
        @back_window.contents.blt(-192-220+@effect_anime_frame*RAY_SPEED,150,picture,rect)
      else
        rect = Rect.new(0, 128,192,128)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,150,picture,rect)
      end
    when 244 #ダブルどどんぱ(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      end

      #rect = Rect.new(0, 48,54+@effect_anime_frame*RAY_SPEED,48)
      if @attackcourse == 0
        rect = Rect.new(0, 48,54+@effect_anime_frame*(RAY_SPEED+2),48)
        if $btl_progress < 2
          @back_window.contents.blt(328,148-50,picture,rect)
        else
          @back_window.contents.blt(322,148-42,picture,rect)
        end
        rect = Rect.new(0, 48,54+@effect_anime_frame*RAY_SPEED,48)
        if $btl_progress < 2
          @back_window.contents.blt(350,148+32,picture,rect)
        else
          @back_window.contents.blt(366,148+34,picture,rect)
        end
      else
        rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
        @back_window.contents.blt(ray_x-92-@effect_anime_frame*RAY_SPEED,ray_y-10,picture,rect)
      end

    when 245 #ダブルどどんぱ(ヒット)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      end
      rect = Rect.new(0, 0,400,48)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,148+24,picture,rect)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,148-24,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,148,picture,rect)
      end
    when 246 #師弟の絆(発動)
      #@effect_anime_type = 2

      if $btl_progress < 2
        rect = Rect.new(0, 0,192,128)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,96-46+1*@effect_anime_frame,picture,rect)


        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(緑)") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,96+42-1*@effect_anime_frame,picture,rect)

      else
        rect = Rect.new(0, 0,190,126)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,98-46+1*@effect_anime_frame,picture,rect)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(緑)") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,98+50-1*@effect_anime_frame,picture,rect)

      end
    when 247 #師弟の絆(ヒット)
      if $btl_progress < 2
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(師弟の絆)") #ダメージ表示用
        rect = Rect.new(0, @ray_anime_type*134,222,134)
        @back_window.contents.blt(-192+@effect_anime_frame*RAY_SPEED,104,picture,rect)
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(師弟の絆)") #ダメージ表示用
        rect = Rect.new(0, @ray_anime_type*126,190,126)
        @back_window.contents.blt(-192+@effect_anime_frame*RAY_SPEED,126,picture,rect)

      end
      if @ray_anime_frame >= 8  && @ray_anime_type == 0
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 8
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 248 #サイヤンアタック界王拳系(追いかけ)
      #@effect_anime_type = 2
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_界王拳") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_スピードアタック") #ダメージ表示用
      end
      #if @effect_anime_frame >= 10 && @effect_anime_type == 0
        #@effect_anime_type += 1
        #@effect_anime_frame = 0
      #elsif @effect_anime_frame >= 10 && @effect_anime_type == 1
        #@effect_anime_type = 0
        #@effect_anime_frame = 0
      #end
      if @attackcourse == 0
        rect = Rect.new(0, 0,236,122)
        @back_window.contents.blt(-236+@effect_anime_frame*RAY_SPEED*3,120-20-@effect_anime_frame*2,picture,rect)
      else
        rect = Rect.new(0, 0,236,122)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,120,picture,rect)
      end
    when 249 #ギャリックカメハメは(発動)Z2
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") #ダメージ表示用
        rect = Rect.new(0, 80,80+@effect_anime_frame*(RAY_SPEED+2),80)
        rect = Rect.new(0, 80,80+5*(RAY_SPEED+2),80) if @effect_anime_frame >= 5
        @back_window.contents.blt(160,118,picture,rect)

        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
        if @effect_anime_frame < 5
          rect = Rect.new(314-@effect_anime_frame*RAY_SPEED, 0,86+@effect_anime_frame*RAY_SPEED,80)
          @back_window.contents.blt(396-@effect_anime_frame*RAY_SPEED,118,picture,rect)
        else
          rect = Rect.new(314-5*RAY_SPEED, 0,86+5*RAY_SPEED,80)
          @back_window.contents.blt(396-5*RAY_SPEED,118,picture,rect)
        end
        #p @effect_anime_frame
    when 250 #ギャリックカメハメは(発動2)Z2
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") #ダメージ表示用
        rect = Rect.new(0, 0,400,80)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,76,picture,rect)
        rect = Rect.new(80, 80,320,80)
        @back_window.contents.blt(-720+@effect_anime_frame*RAY_SPEED,76,picture,rect)
        @back_window.contents.blt(-1040+@effect_anime_frame*RAY_SPEED,76,picture,rect)
        @back_window.contents.blt(-1360+@effect_anime_frame*RAY_SPEED,76,picture,rect)

        rect = Rect.new(0, 80,400,80)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,160,picture,rect)
        rect = Rect.new(112, 80,288,80)
        @back_window.contents.blt(928-@effect_anime_frame*RAY_SPEED,160,picture,rect)
        @back_window.contents.blt(1216-@effect_anime_frame*RAY_SPEED,160,picture,rect)
        @back_window.contents.blt(1504-@effect_anime_frame*RAY_SPEED,160,picture,rect)
        #p @effect_anime_frame
    when 251 #ギャリックカメハメは(発動2)Z2
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") #ダメージ表示用
        rect = Rect.new(0, 0,400,80)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,134,picture,rect)

        rect = Rect.new(0, 80,400,80)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,134,picture,rect)

        #p @effect_anime_frame
    when 252 #元気玉ため
      if @ray_color == 3
        picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)(青)") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)(緑)") #ダメージ表示用
      else
        picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)") #ダメージ表示用
      end
      rect = Rect.new(64*@ray_anime_type, 0,64,64)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @ray_anime_frame >= 4 && @ray_anime_type != 3
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 4
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 253 #超元気玉ため

      picture = Cache.picture("Z3_戦闘_必殺技_超元気玉_溜め") #ダメージ表示用

      rect = Rect.new(0, @ray_anime_type*110,246,110)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @ray_anime_frame >= 20 && @ray_anime_type != 5
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 4 && @ray_anime_type == 5
        @ray_anime_type = 4
        @ray_anime_frame = 0
      end
    when 254 #まかんこうさっぽう発動

      picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲(発動)") #ダメージ表示用

      rect = Rect.new(@ray_anime_type*166,0,166,176)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @ray_anime_frame >= 2 && @ray_anime_type != 1
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 2 && @ray_anime_type == 1
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 255 #Z3まかんこうさっぽう(ヒット)
      picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") #ダメージ表示用

      rect = Rect.new(0, 0,400,64)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 64,400,64)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 256 #Z3エネルギー波半円発動
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(青)") #ダメージ表示用
      elsif @ray_color == 9
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(紫)") #ダメージ表示用
      end

      if @attackcourse == 0 && mirror_pattern == 0
        rect = Rect.new(0, 0,@effect_anime_frame*RAY_SPEED,128)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new(700-@effect_anime_frame*RAY_SPEED, 128,@effect_anime_frame*RAY_SPEED,128)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 257 #エネルギー波縦発動

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_縦") #ダメージ表示用
      rect = Rect.new(0, 0,60,@effect_anime_frame*RAY_SPEED+56)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
    when 258 #エネルギー波縦ヒット

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_縦") #ダメージ表示用
      rect = Rect.new(60, 0,60,400)
      @back_window.contents.blt(ray_x,ray_y+@effect_anime_frame*RAY_SPEED,picture,rect)
    when 259 #エネルギー波縦ヒット

      picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)") #ダメージ表示用
      rect = Rect.new(0, 0,32,32)
      @back_window.contents.blt(ray_x,ray_y+@effect_anime_frame*RAY_SPEED/2,picture,rect)
    when 260 #Z3気円斬系(ヒット)
      picture = Cache.picture("Z3_戦闘_必殺技_気円斬") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0, 30*4,126,30)
        @back_window.contents.blt(-192+@effect_anime_frame*RAY_SPEED,160,picture,rect)
      else
        rect = Rect.new(0, 30*4,192,30)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,160,picture,rect)
      end
    when 261 #そうきだんため
      if @ray_color == 3
        picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)(青)") #ダメージ表示用
      else
        picture = Cache.picture("Z3_必殺技_繰気弾(球点滅中)") #ダメージ表示用
      end
      rect = Rect.new(64*@ray_anime_type, 0,64,64)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
    when 262 #そうきだん(ヒット)
      if @ray_color == 3
        picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)(青)") #ダメージ表示用
        rect = Rect.new(64*3, 0,64,64)
      elsif @ray_color == 1
        picture = Cache.picture("Z3_必殺技_元気玉(球点滅中)(緑)") #ダメージ表示用
        rect = Rect.new(64*3, 0,64,64)
      else
        picture = Cache.picture("Z3_必殺技_繰気弾(球点滅中)") #ダメージ表示用
        rect = Rect.new(64*5, 0,64,64)
      end

      if @attackcourse == 0
        @back_window.contents.blt(-192+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else

        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 263 #四身の拳

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") #ダメージ表示用
      case @effect_anime_frame

      when 0..15
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+4 * @effect_anime_frame+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-4 * @effect_anime_frame+26,ray_y,picture,rect)
      when 16..29

        rect = Rect.new(0 , 0+(96*3), 96, 96)
        @back_window.contents.blt(ray_x+4 * 15+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-4 * 15+26,ray_y,picture,rect)
        #if @effect_anime_frame == 59
        #  Audio.se_play("Audio/SE/" + "Z1 分身")    # 効果音を再生する
        #end
      when 30..60
        #p @effect_anime_frame
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+4 * 15+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-4 * 15+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x+4 * (@effect_anime_frame-15)+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-4 * (@effect_anime_frame-15)+26,ray_y,picture,rect)
      when 61..75
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+4 * 15+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-4 * 15+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x+4 * 45+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-4 * 45+26,ray_y,picture,rect)
      when 76..110
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+4 * 15+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x+4 * 45+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-4 * 45+26,ray_y,picture,rect)
        rect = Rect.new(0 , 0+(96*6), 96, 96)
        @back_window.contents.blt(ray_x-4 * 15+26-2*(@effect_anime_frame-75) ,ray_y-8*(@effect_anime_frame-75),picture,rect)
      when 111..145
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+4 * 45+26,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-4 * 45+26,ray_y,picture,rect)
        rect = Rect.new(0 , 0+(96*0), 96, 96)
        @back_window.contents.blt(ray_x+4 * 15+26+2*(@effect_anime_frame-111),ray_y-8*(@effect_anime_frame-111),picture,rect)
      when 146..180
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+4 * 45+26,ray_y,picture,rect)
        rect = Rect.new(0 , 0+(96*6), 96, 96)
        @back_window.contents.blt(ray_x-4 * 45+26-2*(@effect_anime_frame-146),ray_y-8*(@effect_anime_frame-146),picture,rect)
      when 181..215
        rect = Rect.new(0 , 0+(96*0), 96, 96)
        @back_window.contents.blt(ray_x+4 * 45+26+2*(@effect_anime_frame-181),ray_y-8*(@effect_anime_frame-181),picture,rect)
      end
    when 264 #ビッグバンアタック
      if @ray_color == 3
        if @attackcourse == 0
          picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動(青)") #ダメージ表示用
        else
          picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動(青)_反転") #ダメージ表示用
        end
      elsif @ray_color == 1
        if @attackcourse == 0
          picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動(緑)") #ダメージ表示用
        else
          picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動(緑)_反転") #ダメージ表示用
        end
      else
        if @attackcourse == 0
          picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動") #ダメージ表示用
        else
          picture = Cache.picture("Z3_必殺技_ビッグバンアタック発動_反転") #ダメージ表示用
        end
      end
      if @attackcourse == 0
        rect = Rect.new(302*@ray_anime_type, 0,302,200)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new(302*@ray_anime_type, 0,302,200)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      end
      if @ray_anime_frame >= 4 && @ray_anime_type != 1
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 4 && @ray_anime_type == 1
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 265 #Z3エネルギー波半円ヒット
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(青)") #ダメージ表示用
      elsif @ray_color == 9
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(紫)") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 128,700,128)
        @back_window.contents.blt(-700+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 0,700,128)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 266 #Z3エネルギー弾ヒット
      if @ray_color == 0
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(桃)") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,190,126)
        @back_window.contents.blt(-162+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 126,190,126)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 267 #Z3_戦闘_必殺技_剣攻撃
      if @attackcourse == 0
        picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃") #ダメージ表示用
      else
        picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(左右反転)") #ダメージ表示用
      end

      rect = Rect.new(160*@ray_anime_type, 0,160,96)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)

      if @ray_anime_frame >= 2 #&& @ray_anime_type != 6
        @ray_anime_type += 1
        @ray_anime_frame = 0
      end
    when 268 #Z3_戦闘_必殺技_剣攻撃上下反転
      if @attackcourse == 0
        picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(上下反転)") #ダメージ表示用
      else
        picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(上下左右反転)") #ダメージ表示用
      end

      rect = Rect.new(160*@ray_anime_type, 0,160,96)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)

      if @ray_anime_frame >= 2 #&& @ray_anime_type != 6
        @ray_anime_type += 1
        @ray_anime_frame = 0
      end
    when 269 #Z3_戦闘_必殺技_剣攻撃縦
      if @attackcourse == 0
        picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(縦)") #ダメージ表示用
      else
        picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(左右反転)") #ダメージ表示用
      end

      rect = Rect.new(96*@ray_anime_type, 0,96,160)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)

      if @ray_anime_frame >= 2 #&& @ray_anime_type != 6
        @ray_anime_type += 1
        @ray_anime_frame = 0
      end
    when 270 #Z3_戦闘_必殺技_剣攻撃縦上下反転
      if @attackcourse == 0
        picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(縦上下反転)") #ダメージ表示用
      else
        picture = Cache.picture("Z3_戦闘_必殺技_剣攻撃(上下左右反転)") #ダメージ表示用
      end

      rect = Rect.new(96*@ray_anime_type, 0,96,160)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)

      if @ray_anime_frame >= 2 #&& @ray_anime_type != 6
        @ray_anime_type += 1
        @ray_anime_frame = 0
      end
    when 271 #デスボール系(ヒット)

      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,112,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,112,picture,rect)
      end
    when 272 #Z3まかんこうさっぽう(発動横)
      picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") #ダメージ表示用

      rect = Rect.new(0, 0,400,64)
      if @attackcourse == 0
        rect = Rect.new(0, 64,64+@effect_anime_frame*RAY_SPEED,64)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new((400-64)-@effect_anime_frame*RAY_SPEED, 0,(400-64)+@effect_anime_frame*RAY_SPEED,64)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 273 #ロケットパンチ(発動)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ロケットパンチ") #ダメージ表示用

      shake_dot = 4
      shakex,shakey = pic_shake_cal shake_dot

      if @effect_anime_frame != 0
        shakex,shakey = 0,0
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,24,14)
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED+shakex,ray_y+shakey,picture,rect)
      else
        rect = Rect.new(0, 14,24,14)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED+shakex,ray_y+shakey,picture,rect)
      end
    when 274 #ロケットパンチ(ヒット)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ロケットパンチ") #ダメージ表示用


      if @attackcourse == 0
        rect = Rect.new(0, 0,24,14)
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,144,picture,rect)
      else
        rect = Rect.new(0, 14,24,14)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,144,picture,rect)
      end
    when 275 #ヘルズフラッシュ発動
      if @attackcourse == 0
        if @ray_color == 0
          picture = Cache.picture("Z3_必殺技_超カメハメ波") #ダメージ表示用
        elsif @ray_color == 3
          picture = Cache.picture("Z3_必殺技_超カメハメ波_青") #ダメージ表示用
        end
      else
        if @ray_color == 0
          picture = Cache.picture("Z3_必殺技_超カメハメ波_反転") #ダメージ表示用
        elsif @ray_color == 3
          picture = Cache.picture("Z3_必殺技_超カメハメ波_青_反転") #ダメージ表示用
        end
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,54+@effect_anime_frame*RAY_SPEED,350)
        #@back_window.contents.blt(ray_x-76,ray_y-50,picture,rect)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)

      else
        if 500-54-@effect_anime_frame*RAY_SPEED <= 500
          rect = Rect.new(500-54-@effect_anime_frame*RAY_SPEED, 0,500-54+@effect_anime_frame*RAY_SPEED,350)
        else
          rect = Rect.new(0, 0,500,350)
        end
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      end
    when 276 #Z3そうきえんざん(発動)
      picture = Cache.picture("Z3_戦闘_必殺技_気円斬") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0, 30*4,126,30)
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 30*4,192,30)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 277 #Z3そうきえんざん(ヒット)
      picture = Cache.picture("Z3_戦闘_必殺技_気円斬") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0, 30*4,126,30)
        @back_window.contents.blt(-192-220+@effect_anime_frame*RAY_SPEED,160,picture,rect)
      else
        rect = Rect.new(0, 30*4,192,30)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,160,picture,rect)
      end
    when 278 #ファイナルフラッシュため
      picture = Cache.picture("ZG_戦闘_必殺技_ファイナルフラッシュ弾") #ダメージ表示用
      rect = Rect.new(32*@ray_anime_type, 0,32,32)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @ray_anime_frame >= 4  && @ray_anime_type != 4
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 4  && @ray_anime_type == 4
        #@ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 279 #気の開放エネルギー弾(発動)
      @effect_anime_type = 2
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        if @ray_spd_up_flag == false
          @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
          @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y+64,picture,rect)
        else
          @back_window.contents.blt(ray_x+@effect_anime_frame*(RAY_SPEED+@ray_spd_up_num),ray_y,picture,rect)
          @back_window.contents.blt(ray_x+@effect_anime_frame*(RAY_SPEED+@ray_spd_up_num),ray_y+64,picture,rect)
        end
      else
        if @ray_spd_up_flag == false
          @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
        else
          @back_window.contents.blt(ray_x-@effect_anime_frame*(RAY_SPEED+@ray_spd_up_num),ray_y,picture,rect)
        end
      end

      #if @effect_anime_frame >= 10
      #  @effect_anime_type += 1
      #  @effect_anime_frame = 0
      #end
    when 280 #気の開放エネルギー弾(ヒット)
      @effect_anime_type = 2
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,32+54,picture,rect)
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,32+40+54,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,96,picture,rect)
      end
    when 281 #どどはめは(発動)
      picture = Cache.picture("Z3_戦闘_必殺技_どどはめはエネルギー波") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0, 0,144+@effect_anime_frame*RAY_SPEED,204)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new(256-@effect_anime_frame*RAY_SPEED, 0,144+@effect_anime_frame*RAY_SPEED,122)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 282 #どどはめは(ヒット)
      picture = Cache.picture("Z3_戦闘_必殺技_どどはめはエネルギー波_ヒット") #ダメージ表示用

      rect = Rect.new(0, 0,400,128)
      if @attackcourse == 0
        @back_window.contents.blt(-20-400+@effect_anime_frame*RAY_SPEED,32+54+24,picture,rect)
        #@back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,32+40+54,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,96,picture,rect)
      end

    when 283 #Z2_エネルギー液発動
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(緑)") #ダメージ表示用
      elsif @ray_color == 2
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(水色)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー液(桃)") #ダメージ表示用
      end

      if @attackcourse == 0 && mirror_pattern == 0
        rect = Rect.new(0, 32,24+@effect_anime_frame*RAY_SPEED,32)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new(400-@effect_anime_frame*RAY_SPEED, 0,@effect_anime_frame*RAY_SPEED,32)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 284 #エネルギー波_小系(発動)敵(イベント用強制敵側)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_緑") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_赤") #ダメージ表示用
      end
      #rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
        rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
        @back_window.contents.blt(ray_x-92-@effect_anime_frame*RAY_SPEED,ray_y-10,picture,rect)
    when 285 #エネルギー波_小系(ヒット敵)敵(イベント用強制敵側)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_緑") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_赤") #ダメージ表示用
      end

        rect = Rect.new(0, 48,400,48)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED+64,148,picture,rect)
    when 286 #爆発大(イベント用強制味方側)
      picture = Cache.picture("戦闘アニメ_爆発4") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*176, 0,176,144)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end
      if @damage_center == false
          @back_window.contents.blt(204,120,picture,rect)
      else
          @back_window.contents.blt(234,120,picture,rect)
        end
    when 287 #爆発大Z2(イベント用強制味方側)
      picture = Cache.picture("戦闘アニメ_爆発5") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*158, 0,158,160)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1
        @effect_anime_frame = 0
      end

      @back_window.contents.blt(ray_x,ray_y,picture,rect)
    when 288 #高速移動(イベント用)
      if @effect_anime_frame % 4 == 0
        picture = Cache.picture("戦闘アニメ") #ダメージ表示用
        rect = Rect.new(0,48, 64, 64)
        @back_window.contents.blt(CENTER_ENEX-66,STANDARD_ENEY+26,picture,rect)
      end
    when 289 #スピリッツキャノン一枚絵用
      if @ray_color == 3
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅大)(青)") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅大)(緑)") #ダメージ表示用
      else
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅大)") #ダメージ表示用
      end
      rect = Rect.new(64*@ray_anime_type, 0,64,64)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @ray_anime_frame >= 4  && @ray_anime_type != 4
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 4
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 290 #アクセルダンスエネルギー波ため
      if @ray_color == 3
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)(青)") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)(緑)") #ダメージ表示用
      else
        picture = Cache.picture("Z3_必殺技_超カメハメ波(球点滅)") #ダメージ表示用
      end
      rect = Rect.new(32*@ray_anime_type, 0,32,32)
      @back_window.contents.blt(270,164,picture,rect)
      @back_window.contents.blt(340,164,picture,rect)
      if @ray_anime_frame >= 4  && @ray_anime_type != 4
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 4
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 291 #ヒートドームアタック(発動
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_緑") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_赤") #ダメージ表示用
      end

        rect = Rect.new(0,800-140-@effect_anime_frame*RAY_SPEED,192,140+@effect_anime_frame*RAY_SPEED)
        @back_window.contents.blt(ray_x,ray_y-@effect_anime_frame*RAY_SPEED,picture,rect)
    when 292 #ヒートドームアタック(ヒット
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_緑") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_縦_赤") #ダメージ表示用
      end
        rect = Rect.new(0,0,192,400)
        @back_window.contents.blt(ray_x,ray_y-@effect_anime_frame*RAY_SPEED,picture,rect)
    when 293 #Z3エネルギー弾発動
      if @ray_color == 0
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(桃)") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 0,190,126)
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 126,190,126)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 294 #繰気弾系(ヒット)
      @effect_anime_type = 4
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾") #ダメージ表示用
      #elsif @ray_color == 1
      #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_繰気弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,114,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,114,picture,rect)
      end
    when 295 #Z3エネルギー波_特大発動
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_緑") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_特大_青") #ダメージ表示用
      end

      if @attackcourse == 0
        rect = Rect.new(0, 192,192+@effect_anime_frame*RAY_SPEED,192)

        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        #p @effect_anime_frame,400-192-@effect_anime_frame*RAY_SPEED
        #rect = Rect.new(400-192-@effect_anime_frame*RAY_SPEED, 0,400-192-@effect_anime_frame*RAY_SPEED,192)
        rect = Rect.new(400-192-@effect_anime_frame*RAY_SPEED, 0,400-192+@effect_anime_frame*RAY_SPEED,192)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 296 #エネルギー波_中Z2以降(発動)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 297 #エネルギー波_中Z2以降(ヒット)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0, 0,400,80)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 80,400,80)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 298 #ノンステップバイオレンスエネルギー波_小系(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      end

      rect = Rect.new(0, 48,54+@effect_anime_frame*RAY_SPEED,48)
      if @attackcourse == 0
        @back_window.contents.blt(@chax + 72,@chay + 16,picture,rect)
        @back_window.contents.blt(@chax + 80,@chay + 112,picture,rect)
      else
        rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
        @back_window.contents.blt(ray_x-92-@effect_anime_frame*RAY_SPEED,ray_y-10,picture,rect)
      end
    when 299 #ノンステップバイオレンスエネルギー波_小系(ヒット)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      end
      rect = Rect.new(0, 0,400,48)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,148-24,picture,rect)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,148+24,picture,rect)
      else
        rect = Rect.new(0, 48,400,48)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,148,picture,rect)
      end
    when 300 #ダブルZ3気円斬系(発動)
      picture = Cache.picture("Z3_戦闘_必殺技_気円斬") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0, 30*4,126,30)
        @back_window.contents.blt(338+@effect_anime_frame*RAY_SPEED,144-50,picture,rect)
        @back_window.contents.blt(338+@effect_anime_frame*RAY_SPEED,144+50,picture,rect)
      else
        rect = Rect.new(0, 30*4,192,30)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,160,picture,rect)
      end
    when 301 #ダブルZ3気円斬系(ヒット)
      picture = Cache.picture("Z3_戦闘_必殺技_気円斬") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0, 30*4,126,30)
        @back_window.contents.blt(-192+@effect_anime_frame*RAY_SPEED,160-40,picture,rect)
        @back_window.contents.blt(-192+@effect_anime_frame*RAY_SPEED,160+40,picture,rect)
      else
        rect = Rect.new(0, 30*4,192,30)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,160,picture,rect)
      end
    when 302 #ギャリックバスター(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+2,ray_y-124,picture,rect)
        @back_window.contents.blt(ray_x+4,ray_y-32,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 303 #アウトサイダーショット(ピ&バ)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+18,ray_y-134,picture,rect)
        @back_window.contents.blt(ray_x+2,ray_y-36,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 304 #アウトサイダーショット(ピ&17号)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+2,ray_y-138,picture,rect)
        @back_window.contents.blt(ray_x+6,ray_y-34,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 305 #ダブルませんこう(ゴハン＆トランクス)発動
      if @ray_color == 0
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(青)") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(桃)") #ダメージ表示用
      end

      if @attackcourse == 0
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4")
        rect = Rect.new(0, 0,190,126)
        @back_window.contents.blt(ray_x-10+@effect_anime_frame*RAY_SPEED,ray_y-146,picture,rect)
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー弾4(青)")
        rect = Rect.new(0, 0,190,126)
        @back_window.contents.blt(ray_x+4+@effect_anime_frame*RAY_SPEED,ray_y-54,picture,rect)
      else
        rect = Rect.new(0, 126,190,126)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 306 #ダブルませんこう(ゴハン＆トランクス)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(ダブルませんこう_ゴハン_トランクス)") #ダメージ表示用
      rect = Rect.new(0, @ray_anime_type*126,190,126)
      @back_window.contents.blt(-192+@effect_anime_frame*RAY_SPEED,126,picture,rect)

      if @ray_anime_frame >= 8  && @ray_anime_type == 0
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 8
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 307 #Z3まかんこうさっぽう(発動横)
      picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") #ダメージ表示用

      rect = Rect.new(0, 0,400,64)
      if @attackcourse == 0
        rect = Rect.new(0, 64,64+@effect_anime_frame*RAY_SPEED,64)
        @back_window.contents.blt(ray_x+20,ray_y-132,picture,rect)
        @back_window.contents.blt(ray_x+18,ray_y-28,picture,rect)
      else
        rect = Rect.new((400-64)-@effect_anime_frame*RAY_SPEED, 0,(400-64)+@effect_anime_frame*RAY_SPEED,64)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 308 #Z3まかんこうさっぽう(ヒット)
      picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") #ダメージ表示用

      rect = Rect.new(0, 0,400,64)
      if @attackcourse == 0
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,ray_y-32,picture,rect)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,ray_y+32,picture,rect)
      else
        rect = Rect.new(0, 64,400,64)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 309 #サイヤンアタック(ピ&バ)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      end

      rect = Rect.new(0, 48,54+@effect_anime_frame*RAY_SPEED,48)
      if @attackcourse == 0
        @back_window.contents.blt(@chax + 74,@chay + 18,picture,rect)
        @back_window.contents.blt(@chax + 92,@chay + 86,picture,rect)
      else
        rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
        @back_window.contents.blt(ray_x-92-@effect_anime_frame*RAY_SPEED,ray_y-10,picture,rect)
      end
    when 310 #アウトサイダーショット(バーダック&トーマ)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+18,ray_y-134,picture,rect)
        @back_window.contents.blt(ray_x+14,ray_y-32,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 311 #アウトサイダーショット(バーダック&セリパ)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+18,ray_y-134,picture,rect)
        @back_window.contents.blt(ray_x+0,ray_y-28,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 312 #アウトサイダーショット(バーダック&トテッポ)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+18,ray_y-134,picture,rect)
        @back_window.contents.blt(ray_x+12,ray_y-40,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 313 #アウトサイダーショット(バーダック&パンブーキン)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+18,ray_y-134,picture,rect)
        @back_window.contents.blt(ray_x+14,ray_y-20,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 314 #地球人ストライク 四身の拳
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") #ダメージ表示用

      x_idou = 1.5
      x_tyousei = 14
      case @effect_anime_frame

      when 0..30
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+x_idou * @effect_anime_frame-x_tyousei,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-x_idou * @effect_anime_frame-x_tyousei,ray_y,picture,rect)
      when 31..59

        rect = Rect.new(0 , 0+(96*3), 96, 96)
        @back_window.contents.blt(ray_x+x_idou * 30-x_tyousei,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-x_idou * 30-x_tyousei,ray_y,picture,rect)
        if @effect_anime_frame == 59
          Audio.se_play("Audio/SE/" + "Z1 分身")    # 効果音を再生する
        end
      when 60..120
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+x_idou * 30-x_tyousei,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-x_idou * 30-x_tyousei,ray_y,picture,rect)
        @back_window.contents.blt(ray_x+x_idou * (@effect_anime_frame-30)-x_tyousei,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-x_idou * (@effect_anime_frame-30)-x_tyousei,ray_y,picture,rect)
      else
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+x_idou * 30-x_tyousei,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-x_idou * 30-x_tyousei,ray_y,picture,rect)
        @back_window.contents.blt(ray_x+x_idou * 90-x_tyousei,ray_y,picture,rect)
        @back_window.contents.blt(ray_x-x_idou * 90-x_tyousei,ray_y,picture,rect)
      end
    when 315 #地球人ストライク サイコアタックと狼牙

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_チャオズ") #ダメージ表示用
      rect = Rect.new(0, 5*96,96,96)
      @back_window.contents.blt(STANDARD_ENEX+74-21*RAY_SPEED,STANDARD_CHAY-8,picture,rect)
      end_frame = 85

      if @btl_ani_cha_chg_no == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
      end
      attack_se = "Z3 打撃"
      case @effect_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
      when 31..35
        rect = Rect.new(0, 0*96,96,96)
      when 36..39
        rect = Rect.new(0, 3*96,96,96)
      when 40..43
        rect = Rect.new(0, 1*96,96,96)
      when 44..46
        rect = Rect.new(0, 2*96,96,96)
      when 47..50
        rect = Rect.new(0, 4*96,96,96)
      when 51..53
        rect = Rect.new(0, 2*96,96,96)
      when 54..56
        rect = Rect.new(0, 1*96,96,96)
      when 57..60
        rect = Rect.new(0, 2*96,96,96)
      when 61..80
        rect = Rect.new(0, 16*96,96,96)
      else
        #when 81..85

        if @btl_ani_cha_chg_no == 0
          if $btl_progress >= 2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
            rect = Rect.new(0, 3*96,96,96)
          else
            picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
            rect = Rect.new(0, 2*96,96,96)
          end
        else
          if $btl_progress >= 2
            picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
            rect = Rect.new(0, 3*96,96,96)
          else
            picture = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
            rect = Rect.new(0, 2*96,96,96)
          end

        end
      #else

        #if @btl_ani_cha_chg_no == 0
        #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
        #else
        #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
        #end
        #if $btl_progress >= 2
        #  rect = Rect.new(0, 3*96,96,96)
        #else
        #  rect = Rect.new(0, 3*96,96,96)
        #end
      end

      if @effect_anime_frame >= 36 && @effect_anime_frame % 5 == 0 && end_frame > @effect_anime_frame
        Audio.se_play("Audio/SE/" + attack_se)    # 効果音を再生する
      end

      if @effect_anime_frame >= 61 && @effect_anime_frame <= 80
        @back_window.contents.blt(CENTER_CHAX-(@effect_anime_frame-60)*8,STANDARD_CHAY,picture,rect)
      elsif @effect_anime_frame >= 81 && @effect_anime_frame <= 84
        @back_window.contents.blt(80+(@effect_anime_frame-80)*16,STANDARD_CHAY,picture,rect)
      else #if @effect_anime_frame < 86
        @back_window.contents.blt(CENTER_CHAX,STANDARD_CHAY,picture,rect)
      end
    when 316 #エネルギー波_小系(発動)敵
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
      rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
      @back_window.contents.blt(ray_x-92+84-@effect_anime_frame*RAY_SPEED,ray_y-10-96,picture,rect)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      @back_window.contents.blt(ray_x-92+100-@effect_anime_frame*RAY_SPEED,ray_y-10-16,picture,rect)

    when 317 #メタルクラッシュ
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小") #ダメージ表示用
        rect = Rect.new(0, 48,400,48)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED+64,148-24,picture,rect)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
        #rect = Rect.new(0, 48,400,48)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED+64,148+24,picture,rect)
    when 318 #四身の拳かめはめは(発動)

      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_テンシンハン") #ダメージ表示用
      if @btl_ani_cha_chg_no == 0
        picture2 = Cache.picture(set_battle_character_name $partyc[@chanum.to_i],1)
        #picture2 = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
      else
        picture2 = Cache.picture(set_battle_character_name @btl_ani_cha_chg_no,1)
        #picture2 = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
      end

      tasux = 160
      case @effect_anime_frame

      when 0..30
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * @effect_anime_frame+26,ray_y-1* @effect_anime_frame,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * @effect_anime_frame+26,ray_y+1* @effect_anime_frame,picture,rect)

        rect = Rect.new(0 , 0+(96*0), 96, 96)
        if @battle_anime_frame % 2 == 0
          @back_window.contents.blt(ray_x+0.5 * 30+26+tasux,ray_y-1*30,picture2,rect)
        else
          @back_window.contents.blt(ray_x-0.5 * 30+26+tasux,ray_y+1*30,picture2,rect)
        end
      when 31..59

        rect = Rect.new(0 , 0+(96*3), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)

        rect = Rect.new(0 , 0+(96*0), 96, 96)
        if @battle_anime_frame % 2 == 0
          @back_window.contents.blt(ray_x+0.5 * 30+26+tasux,ray_y-1*30,picture2,rect)
        else
          @back_window.contents.blt(ray_x-0.5 * 30+26+tasux,ray_y+1*30,picture2,rect)
        end
        if @effect_anime_frame == 59
          Audio.se_play("Audio/SE/" + "Z1 分身")    # 効果音を再生する
        end
      when 60..120
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        @back_window.contents.blt(ray_x+0.5 * (@effect_anime_frame-30)+26,ray_y-1* (@effect_anime_frame-30),picture,rect)
        @back_window.contents.blt(ray_x-0.5 * (@effect_anime_frame-30)+26,ray_y+1* (@effect_anime_frame-30),picture,rect)


        rect = Rect.new(0 , 0+(96*0), 96, 96)
        if @battle_anime_frame % 4 == 0
          @back_window.contents.blt(ray_x+0.5 * 30+26+tasux,ray_y-1*30,picture2,rect)
        elsif @battle_anime_frame % 4 == 1
          @back_window.contents.blt(ray_x-0.5 * 30+26+tasux,ray_y+1*30,picture2,rect)
        elsif @battle_anime_frame % 4 == 2
          @back_window.contents.blt(ray_x-0.5 * 90+26+tasux,ray_y+1* 90,picture2,rect)
        else
          @back_window.contents.blt(ray_x+0.5 * 90+26+tasux,ray_y-1* 90,picture2,rect)
        end
      when 121..150
        rect = Rect.new(0 , 0+(96*4), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        @back_window.contents.blt(ray_x+0.5 * 90+26,ray_y-1* 90,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 90+26,ray_y+1* 90,picture,rect)

        rect = Rect.new(0 , 0+(96*0), 96, 96)
        if @battle_anime_frame % 4 == 0
          @back_window.contents.blt(ray_x+0.5 * 30+26+tasux,ray_y-1*30,picture2,rect)
        elsif @battle_anime_frame % 4 == 1
          @back_window.contents.blt(ray_x-0.5 * 30+26+tasux,ray_y+1*30,picture2,rect)
        elsif @battle_anime_frame % 4 == 2
          @back_window.contents.blt(ray_x-0.5 * 90+26+tasux,ray_y+1* 90,picture2,rect)
        else
          @back_window.contents.blt(ray_x+0.5 * 90+26+tasux,ray_y-1* 90,picture2,rect)
        end
      else
        if @effect_anime_frame == 151
          #Audio.se_play("Audio/SE/" + "Z1 ザー")    # 効果音を再生する
          #Audio.se_play("Audio/SE/" + "Z3 エネルギー波")    # 効果音を再生する
        end
        rect = Rect.new(0 , 0+(96*0), 96, 96)
        @back_window.contents.blt(ray_x+0.5 * 90+26,ray_y-1* 90,picture,rect)
        @back_window.contents.blt(ray_x+0.5 * 30+26,ray_y-1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 30+26,ray_y+1*30,picture,rect)
        @back_window.contents.blt(ray_x-0.5 * 90+26,ray_y+1* 90,picture,rect)

        rect = Rect.new(0 , 0+(96*0), 96, 96)
        if @battle_anime_frame % 4 == 0
          @back_window.contents.blt(ray_x+0.5 * 30+26+tasux,ray_y-1*30,picture2,rect)
        elsif @battle_anime_frame % 4 == 1
          @back_window.contents.blt(ray_x-0.5 * 30+26+tasux,ray_y+1*30,picture2,rect)
        elsif @battle_anime_frame % 4 == 2
          @back_window.contents.blt(ray_x-0.5 * 90+26+tasux,ray_y+1* 90,picture2,rect)
        else
          @back_window.contents.blt(ray_x+0.5 * 90+26+tasux,ray_y-1* 90,picture2,rect)
        end
      end
    when 319 #四身の拳かめはめは(ヒット)
      @effect_anime_type = 2
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if @attackcourse == 0
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,STANDARD_CHAY-20-1* 90+@effect_anime_frame*3,picture,rect)
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,STANDARD_CHAY-20-1*30+@effect_anime_frame*1,picture,rect)
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,STANDARD_CHAY-20+1*30-@effect_anime_frame*1,picture,rect)
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,STANDARD_CHAY-20+1* 90-@effect_anime_frame*3,picture,rect)
      else
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,STANDARD_CHAY,picture,rect)
      end

        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾2") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0, 0,96,64)
        @back_window.contents.blt(-128+@effect_anime_frame*RAY_SPEED,144,picture,rect)
      else
        rect = Rect.new(0, 64,96,64)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,144,picture,rect)
      end
    when 320 #行くぞクリリン(発動)
      #@effect_anime_type = 2

      if $btl_progress < 2
        rect = Rect.new(0, 0,222,134)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3(緑)") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,96-58+1*@effect_anime_frame,picture,rect)

        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾3") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,96+60-1*@effect_anime_frame,picture,rect)

      else
        rect = Rect.new(0, 0,190,126)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(緑)") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,98-56+1*@effect_anime_frame,picture,rect)

        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,98+60-1*@effect_anime_frame,picture,rect)


      end
    when 321 #アウトサイダーショット(ピ&ベ)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+2,ray_y-136,picture,rect)
        @back_window.contents.blt(ray_x+2,ray_y-28,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 322
      picture = Cache.picture("Z3_戦闘_必殺技_ロボット兵腕2") #ダメージ表示用
      rect = Rect.new(0, 0,32,18)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
    when 323
      picture = Cache.picture("Z3_戦闘_必殺技_ロボット兵腕3") #ダメージ表示用
      rect = Rect.new(0, 0,30,24)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @battle_anime_frame >= 379
        picture = Cache.picture("Z3_必殺技_爆発") #ダメージ表示用
        rect = Rect.new(0, 0,32,32)
        tempx = @chax + (rand(18) * 2)
        tempy = @chay + (rand(16) * 2)
        @back_window.contents.blt(tempx,tempy,picture,rect)
      end
    when 324 #超元気玉ため(逆)

      picture = Cache.picture("Z3_戦闘_必殺技_超元気玉_溜め(逆)") #ダメージ表示用

      rect = Rect.new(0, @ray_anime_type*110,246,110)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @ray_anime_frame >= 20 && @ray_anime_type != 5
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 4 && @ray_anime_type == 5
        @ray_anime_type = 4
        @ray_anime_frame = 0
      end
    when 325 #スーパービッグノヴァ発動

      picture = Cache.picture("Z3_戦闘_必殺技_デスボール(極大玉縦)(オレンジ)") #ダメージ表示用

      rect = Rect.new(0, 0,512,250)
      @back_window.contents.blt(ray_x - (@effect_anime_frame * 8),ray_y + (@effect_anime_frame * 2),picture,rect)
    when 326 #スーパービッグノヴァ発動(ヒット)

      picture = Cache.picture("Z3_戦闘_必殺技_デスボール(極大玉)(オレンジ)") #ダメージ表示用

      rect = Rect.new(0, 0,900,512)
      @back_window.contents.blt(ray_x - (@effect_anime_frame * 8),ray_y + (@effect_anime_frame * 2),picture,rect)
    when 327 #メタルクウラコア(ケーブル)発動

      picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル") #ダメージ表示用

      rect = Rect.new(0, 80*@ray_anime_type, 64 + @effect_anime_frame * 8,80)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)

      if @ray_anime_frame >= 4
        @ray_anime_type += 1
        @ray_anime_frame = 0
      end

      if @ray_anime_type >= 3
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 328 #メタルクウラコア(ケーブル)伸びる

      picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル") #ダメージ表示用

      rect = Rect.new(0, 80*@ray_anime_type, 1400,80)
      @back_window.contents.blt(ray_x - @effect_anime_frame * 8,ray_y,picture,rect)

      if @ray_anime_frame >= 4
        @ray_anime_type += 1
        @ray_anime_frame = 0
      end

      if @ray_anime_type >= 3
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 329 #メタルクウラコア(ケーブル)ヒット

      picture = Cache.picture("Z3_戦闘_必殺技_メタルクウラ・コア_ケーブル") #ダメージ表示用

      rect = Rect.new(0, 80*@ray_anime_type, 1400,80)
      @back_window.contents.blt(ray_x - @effect_anime_frame * 8,ray_y,picture,rect)

      if @ray_anime_frame >= 4
        @ray_anime_type += 1
        @ray_anime_frame = 0
      end

      if @ray_anime_type >= 3
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 330 #Z3気円斬系(発動)
      picture = Cache.picture("Z3_戦闘_必殺技_気円斬") #ダメージ表示用

      rect = Rect.new(0, 30*@ray_anime_type,126,30)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @ray_anime_frame >= 4
        @ray_anime_type += 1
        @ray_anime_frame = 0
      end

      if @ray_anime_type >= 4
        @ray_anime_type = 4
        @ray_anime_frame = 0
      end
    when 331 #ナメック戦士発動
      #if @ray_color == 0
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中") #ダメージ表示用
      #elsif @ray_color == 1
      #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中(緑)") #ダメージ表示用
      #elsif @ray_color == 4
      #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中(桃)") #ダメージ表示用
      #end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(326,116,picture,rect)
        @back_window.contents.blt(282,42,picture,rect)
        @back_window.contents.blt(282,172,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 332 #狼牙風風拳 ヤムチャとわかもの

      end_frame = 85
      picture = Cache.picture($btl_top_file_name + "戦闘_ヤムチャ") #ダメージ表示用
      picture2 = Cache.picture($btl_top_file_name + "戦闘_必殺技_わかもの") #ダメージ表示用
      attack_se = "Z3 打撃"
      case @effect_anime_frame

      when 0..10
        rect = Rect.new(0, 14*96,96,96)
        rect2 = Rect.new(0, 26*96,96,96)
      when 11..20
        rect = Rect.new(0, 13*96,96,96)
        rect2 = Rect.new(0, 25*96,96,96)
      when 21..30
        rect = Rect.new(0, 12*96,96,96)
        rect2 = Rect.new(0, 24*96,96,96)
      when 31..35
        rect = Rect.new(0, 0*96,96,96)
        rect2 = Rect.new(0, 19*96,96,96)
      when 36..39
        rect = Rect.new(0, 3*96,96,96)
        rect2 = Rect.new(0, 22*96,96,96)
      when 40..43
        rect = Rect.new(0, 1*96,96,96)
        rect2 = Rect.new(0, 20*96,96,96)
      when 44..46
        rect = Rect.new(0, 2*96,96,96)
        rect2 = Rect.new(0, 21*96,96,96)
      when 47..50
        rect = Rect.new(0, 4*96,96,96)
        rect2 = Rect.new(0, 23*96,96,96)
      when 51..53
        rect = Rect.new(0, 2*96,96,96)
        rect2 = Rect.new(0, 21*96,96,96)
      when 54..56
        rect = Rect.new(0, 1*96,96,96)
        rect2 = Rect.new(0, 20*96,96,96)
      when 57..60
        rect = Rect.new(0, 2*96,96,96)
        rect2 = Rect.new(0, 21*96,96,96)
      when 61..80
        rect = Rect.new(0, 16*96,96,96)
        rect2 = Rect.new(0, 18*96,96,96)
      else
        if $btl_progress >= 2
          picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_ヤムチャ") #ダメージ表示用
          picture2 = Cache.picture($btl_top_file_name + "戦闘_必殺技_わかもの") #ダメージ表示用
          rect = Rect.new(0, 3*96,96,96)
          rect2 = Rect.new(0, 21*96,96,96)
        else
          picture = Cache.picture($btl_top_file_name + "戦闘_ヤムチャ") #ダメージ表示用
          picture2 = Cache.picture($btl_top_file_name + "戦闘_必殺技_わかもの") #ダメージ表示用
          rect = Rect.new(0, 2*96,96,96)
          rect2 = Rect.new(0, 21*96,96,96)
        end

      end
      #else

        #if @btl_ani_cha_chg_no == 0
        #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name) #ダメージ表示用
        #else
        #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@btl_ani_cha_chg_no].name) #ダメージ表示用
        #end
        #if $btl_progress >= 2
        #  rect = Rect.new(0, 3*96,96,96)
        #else
        #  rect = Rect.new(0, 3*96,96,96)
        #end

      if @effect_anime_frame >= 36 && @effect_anime_frame % 5 == 0 && end_frame > @effect_anime_frame
        Audio.se_play("Audio/SE/" + attack_se)    # 効果音を再生する
      end
      yamux = 10
      wakamonox = 154

      if @effect_anime_frame >= 61 && @effect_anime_frame <= 80
        @back_window.contents.blt(CENTER_CHAX + yamux,STANDARD_CHAY-(@effect_anime_frame-60)*4,picture,rect)
        @back_window.contents.blt(CENTER_CHAX + wakamonox,STANDARD_CHAY-(@effect_anime_frame-60)*4,picture2,rect2)
      elsif @effect_anime_frame >= 81 && @effect_anime_frame <= 85
        @back_window.contents.blt(CENTER_CHAX + yamux,STANDARD_CHAY - 80 +(@effect_anime_frame-80)*16,picture,rect)
        @back_window.contents.blt(CENTER_CHAX + wakamonox,STANDARD_CHAY - 80 +(@effect_anime_frame-80)*16,picture2,rect2)
      else #if @effect_anime_frame < 86
        @back_window.contents.blt(CENTER_CHAX + yamux,STANDARD_CHAY,picture,rect)
        @back_window.contents.blt(CENTER_CHAX + wakamonox,STANDARD_CHAY,picture2,rect2)
      end
    when 333 #エネルギー弾系(正面)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if ray_x == 0 || ray_x == nil
        ray_x = 240
        ray_y = 100
      end
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1 if @effect_anime_type != 5
        @effect_anime_frame = 0
      end
    when 334 #アウトサイダーショット(トーマ&セリパ)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+12,ray_y-130,picture,rect)
        @back_window.contents.blt(ray_x+0,ray_y-28,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 335 #アウトサイダーショット(トーマ&トテッポ)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+12,ray_y-130,picture,rect)
        @back_window.contents.blt(ray_x+18,ray_y-40,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 336 #アウトサイダーショット(セリパ&パンブーキン)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+0,ray_y-128,picture,rect)
        @back_window.contents.blt(ray_x+6,ray_y-32,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 337 #アウトサイダーショット(トテッポ&パンブーキン)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x+18,ray_y-142,picture,rect)
        @back_window.contents.blt(ray_x+6,ray_y-32,picture,rect)
      else
        rect = Rect.new(346-@effect_anime_frame*RAY_SPEED, 0,54+@effect_anime_frame*RAY_SPEED,80)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 338 #ダブルエネルギー波_小系(発動)敵
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      rect = Rect.new(352-@effect_anime_frame*RAY_SPEED, 0,48+@effect_anime_frame*RAY_SPEED,48)
      @back_window.contents.blt(ray_x-92+84-@effect_anime_frame*RAY_SPEED,ray_y-10-96+2,picture,rect)
      @back_window.contents.blt(ray_x-92+84-@effect_anime_frame*RAY_SPEED,ray_y-10-96+2+100,picture,rect)
    when 339 #ダブルエネルギー波_小系(ヒット)敵
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      rect = Rect.new(0, 48,640,48)
      @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y-10-96+2+24,picture,rect)
      @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y-10-96+2+100-24,picture,rect)
    when 340 #エビルコメットヒット
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_小_敵_青") #ダメージ表示用
      rect = Rect.new(0, 48,640,48)
      @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y-24*1,picture,rect)
      @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y+24*1,picture,rect)
      @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y-24*2,picture,rect)
      @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y+24*2,picture,rect)

    when 341 #カエル攻撃ヒット
      picture = Cache.picture("Z2_戦闘_必殺技_敵_メダマッチャ") #ダメージ表示用

      if @effect_anime_frame < 16
        rect = Rect.new(0, 96*12,96,96)
      else
        rect = Rect.new(0, 96*11,96,96)
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
      @back_window.contents.blt(kkx-8+7*2-kx,kky-34-7*2-ky,picture,rect)
      @back_window.contents.blt(kkx-16-kx,kky-42-7*2-ky,picture,rect)
      @back_window.contents.blt(kkx-32-kx,kky-42-7*2-ky,picture,rect)
      @back_window.contents.blt(kkx-40-7*2-kx,kky-34-7*2-ky,picture,rect)
    when 342 #Z3まかんこうさっぽう(発動横)
      picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") #ダメージ表示用

      rect = Rect.new(0, 0,400,64)
      if @attackcourse == 0
        rect = Rect.new(0, 64,64+@effect_anime_frame*RAY_SPEED,64)
        @back_window.contents.blt(ray_x+20,ray_y-132,picture,rect)
        @back_window.contents.blt(ray_x+22,ray_y-36,picture,rect)
      else
        rect = Rect.new((400-64)-@effect_anime_frame*RAY_SPEED, 0,(400-64)+@effect_anime_frame*RAY_SPEED,64)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 343 #Z3トリプル魔閃光(発動横)
      picture = Cache.picture("Z3_戦闘_必殺技_トリプル魔閃光") #ダメージ表示用

        rect = Rect.new(0, 0,64+@effect_anime_frame*RAY_SPEED,204)
        #@back_window.contents.blt(ray_x+20,ray_y-132,picture,rect)
        @back_window.contents.blt(ray_x-8,ray_y-10,picture,rect)
    when 344 #Z3トリプルまかんこうさっぽう(発動横)
      picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") #ダメージ表示用

      rect = Rect.new(0, 64,64+@effect_anime_frame*RAY_SPEED,64)
      @back_window.contents.blt(ray_x-10,ray_y-144,picture,rect)
      @back_window.contents.blt(ray_x+22,ray_y-86,picture,rect)
      @back_window.contents.blt(ray_x-8,ray_y-20,picture,rect)
    when 345 #Z3トリプルまかんこうさっぽう(ヒット)
      picture = Cache.picture("Z3_戦闘_必殺技_魔貫光殺砲") #ダメージ表示用
      rect = Rect.new(0, 0,400,64)
      @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,ray_y-32-32+8,picture,rect)
      @back_window.contents.blt(-340+@effect_anime_frame*RAY_SPEED,ray_y+0,picture,rect)
      @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,ray_y+32+32-8,picture,rect)
    when 346 #アウトサイダーショット(ピ&16号)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end

      rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
      @back_window.contents.blt(ray_x+2,ray_y-138,picture,rect)
      @back_window.contents.blt(ray_x+26,ray_y-34,picture,rect)
    when 347 #アウトサイダーショット(未来悟飯&17号)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end

      rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
      @back_window.contents.blt(ray_x+24,ray_y-132,picture,rect)
      @back_window.contents.blt(ray_x+6,ray_y-36,picture,rect)
    when 348 #アウトサイダーショット(未来悟飯&16号)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end

      rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
      @back_window.contents.blt(ray_x+24,ray_y-132,picture,rect)
      @back_window.contents.blt(ray_x+26,ray_y-34,picture,rect)

    when 349 #アウトサイダーショット(未来悟飯&ベジータ)(発動)
      if @ray_color == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 3
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_青") #ダメージ表示用
      elsif @ray_color == 4
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_中_敵_赤") #ダメージ表示用
      end

      rect = Rect.new(0, 80,54+@effect_anime_frame*RAY_SPEED,80)
      @back_window.contents.blt(ray_x+24,ray_y-132,picture,rect)
      @back_window.contents.blt(ray_x+2,ray_y-28,picture,rect)
    when 350 #超体当たり(ヒット)
      picture = Cache.picture("Z3_必殺技_超体当たり(パイクーハン)") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(190*@ray_anime_type, 0,190,126)
        @back_window.contents.blt(-236+@effect_anime_frame*RAY_SPEED,100,picture,rect)
      else
        rect = Rect.new(190*@ray_anime_type, 0,190,126)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,100,picture,rect)
      end

      if @ray_anime_frame >= 8  && @ray_anime_type == 0
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 8
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 351 #巻きつき攻撃 引き抜く
      picture = Cache.picture("Z3_戦闘_必殺技_ブウ_巻きつく") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0,@effect_anime_type * 96,96,96)
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0,@effect_anime_type * 96,96,96)
        @back_window.contents.blt(ray_x-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end

    when 352 #光線
      picture = Cache.picture("Z3_戦闘_必殺技_お菓子光線_前中後繋ぎ") #ダメージ表示用

      if @attackcourse == 0
        rect = Rect.new(0,@effect_anime_type * 96,96,96)
        @back_window.contents.blt(ray_x+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 0,608,52)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end

    when 353 #かめはめ波系(特大_加工)横 ヒット
      if @ray_color == 0
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_加工") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_緑_加工") #ダメージ表示用
      else
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_青_加工") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 0,400,192)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,76,picture,rect)
      else
        rect = Rect.new(0, 192,400,192)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,76,picture,rect)
      end
    when 354 #ブウ巻きつきヒット

      picture = Cache.picture("Z3_戦闘_必殺技_ブウ_巻きつく(巨大)") #ダメージ表示用

      rect = Rect.new(192*@effect_anime_type, 0, 192,192)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
    when 355 #ダブルアタック(天津飯とトランクス)(発動)
      #@effect_anime_type = 2

        rect = Rect.new(0, 0,190,126)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,98-56+1*@effect_anime_frame,picture,rect)

        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(青)") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,98+50-1*@effect_anime_frame,picture,rect)

    when 356 #ダブルアタック(天津飯とトランクス)(ヒット)
      if @ray_anime_type == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4")
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(青)")
      end#ダメージ表示用
      rect = Rect.new(0, 0,190,126)
      @back_window.contents.blt(-192+@effect_anime_frame*RAY_SPEED,126,picture,rect)

      if @ray_anime_frame >= 8  && @ray_anime_type == 0
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 8
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 357 #ダブルアタック(チャオズとトランクス)(発動)
      #@effect_anime_type = 2

        rect = Rect.new(0, 0,190,126)
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,98-46+1*@effect_anime_frame,picture,rect)

        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾4(青)") #ダメージ表示用
        @back_window.contents.blt(340+@effect_anime_frame*RAY_SPEED,98+50-1*@effect_anime_frame,picture,rect)
    when 358 #かめはめ波系(特大_加工)横 発動
      if @ray_color == 0
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_加工") #ダメージ表示用
      elsif @ray_color == 1
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_緑_加工") #ダメージ表示用
      else
        picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_青_加工") #ダメージ表示用
      end

      rey_kizyunx = 54 + @effect_anime_frame * RAY_SPEED
      if @attackcourse == 0
        rect = Rect.new(0, 192,rey_kizyunx,192)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)

      else
        rect = Rect.new(400 - rey_kizyunx,0, rey_kizyunx,192)
        @back_window.contents.blt(ray_x - rey_kizyunx,ray_y,picture,rect)
      end
    when 359 #ダブルかめはめ波(悟空、亀仙人)
      picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_大") #ダメージ表示用

      rect = Rect.new(0, 92,54+@effect_anime_frame*RAY_SPEED,92)
      if $super_saiyazin_flag[1] == true
        @back_window.contents.blt(ray_x+14,ray_y-132,picture,rect)
      else
        @back_window.contents.blt(ray_x+4,ray_y-126,picture,rect)
      end
      @back_window.contents.blt(ray_x-10,ray_y-20,picture,rect)
    when 360 #ダブルかめはめ波(悟飯／クリリン、亀仙人)
      picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_大") #ダメージ表示用

      rect = Rect.new(0, 92,54+@effect_anime_frame*RAY_SPEED,92)
      #if $super_saiyazin_flag[1] == true
      #  @back_window.contents.blt(ray_x+14,ray_y-132,picture,rect)
      #else
      #  @back_window.contents.blt(ray_x+4,ray_y-126,picture,rect)
      #end
      @back_window.contents.blt(ray_x-10,ray_y-122,picture,rect)
      @back_window.contents.blt(ray_x-10,ray_y-20,picture,rect)
    when 361 #ダブルかめはめ波(ヤムチャ、亀仙人)
      picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_大") #ダメージ表示用

      rect = Rect.new(0, 92,54+@effect_anime_frame*RAY_SPEED,92)
      #if $super_saiyazin_flag[1] == true
      #  @back_window.contents.blt(ray_x+14,ray_y-132,picture,rect)
      #else
      #  @back_window.contents.blt(ray_x+4,ray_y-126,picture,rect)
      #end
      @back_window.contents.blt(ray_x+ 6 ,ray_y-130,picture,rect)
      @back_window.contents.blt(ray_x-10,ray_y-20,picture,rect)
    when 362 #ダブルかめはめ波(未来悟飯、亀仙人)
      picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_大") #ダメージ表示用

      rect = Rect.new(0, 92,54+@effect_anime_frame*RAY_SPEED,92)
      #if $super_saiyazin_flag[1] == true
      #  @back_window.contents.blt(ray_x+14,ray_y-132,picture,rect)
      #else
      #  @back_window.contents.blt(ray_x+4,ray_y-126,picture,rect)
      #end
      @back_window.contents.blt(ray_x+ 22 ,ray_y-134,picture,rect)
      @back_window.contents.blt(ray_x-10,ray_y-20,picture,rect)
    when 363 #スパーキングコンボキャラ現れる2人目右
        picture = Cache.picture(set_battle_character_name @scombo_cha2,1)
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)

        rect = Rect.new(0, 0*96,96,96)
        ushirox=0
        idouryou = 12
        @back_window.contents.blt(STANDARD_CHAX+@effect_anime_frame*idouryou-30 + 12,STANDARD_CHAY,picture,rect)
    when 364 #スパーキングコンボキャラ現れる2人目左
        picture = Cache.picture(set_battle_character_name @scombo_cha2,1)
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[@scombo_cha2].name)

        rect = Rect.new(0, 0*96,96,96)
        ushirox=0
        idouryou = 8
        @back_window.contents.blt(STANDARD_CHAX+@effect_anime_frame*idouryou-48,STANDARD_CHAY,picture,rect)
    when 365 #スピリッツかめはめ波系(特大_加工)横 ヒット
      picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_加工(スピリッツかめはめ波)") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, @ray_anime_type*192,400,192)
        @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,76,picture,rect)
      else
        rect = Rect.new(0, 192,400,192)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,76,picture,rect)
      end
      if @ray_anime_frame >= 8  && @ray_anime_type == 0
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 8
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 366 #エネルギー弾系(正面:スピリッツかめはめ波系)
      if @ray_anime_type == 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(青)") #ダメージ表示用
      end
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      if ray_x == 0 || ray_x == nil
        ray_x = 240
        ray_y = 100
      end
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
      if @effect_anime_frame >= 10
        @effect_anime_type += 1 if @effect_anime_type != 5
        @effect_anime_frame = 0
      end

      if @ray_anime_frame >= 8  && @ray_anime_type == 0
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 8
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    when 367 #絶好のチャンス(悟飯／クリリン)
      picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_大") #ダメージ表示用

      rect = Rect.new(0, 92,54+@effect_anime_frame*RAY_SPEED,92)
      #if $super_saiyazin_flag[1] == true
      #  @back_window.contents.blt(ray_x+14,ray_y-132,picture,rect)
      #else
      #  @back_window.contents.blt(ray_x+4,ray_y-126,picture,rect)
      #end
      @back_window.contents.blt(ray_x-14,ray_y-128,picture,rect)
      @back_window.contents.blt(ray_x-10,ray_y-22,picture,rect)
    when 368 #界王拳系(自由)
      if $super_saiyazin_flag[1] == true
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_界王拳(超悟空)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_界王拳") #ダメージ表示用
      end
      if @effect_anime_frame >= 10 && @effect_anime_type == 0
        @effect_anime_type += 1
        @effect_anime_frame = 0
      elsif @effect_anime_frame >= 10 && @effect_anime_type == 1
        @effect_anime_type = 0
        @effect_anime_frame = 0
      end
      rect = Rect.new(236*@effect_anime_type, 0,236,122)
      @back_window.contents.blt(ray_x,ray_y,picture,rect)
    when 369 #Z3エネルギー波半円ヒット(赤、青斑点)
      #if @ray_color == 0
      #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円") #ダメージ表示用
      #elsif @ray_color == 1
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(緑)") #ダメージ表示用
      #elsif @ray_color == 3
      #  picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(青)") #ダメージ表示用
      #elsif @ray_color == 9
        #picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(紫)") #ダメージ表示用
      #end


      if @ray_anime_frame >= 4 && @effect_anime_type == 0
        @effect_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 4 && @effect_anime_type == 1
        @effect_anime_type = 0
        @ray_anime_frame = 0
      end

      case @effect_anime_type

      when 0
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円") #ダメージ表示用
      when 1
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円(青)") #ダメージ表示用
      else
        picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波_半円") #ダメージ表示用
      end
      if @attackcourse == 0
        rect = Rect.new(0, 128,700,128)
        @back_window.contents.blt(-700+@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      else
        rect = Rect.new(0, 0,700,128)
        @back_window.contents.blt(640-@effect_anime_frame*RAY_SPEED,ray_y,picture,rect)
      end
    when 370 #Z1ダブルアイビーム発動
      #ピッコロ
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾(緑)") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(160-(@effect_anime_frame)*2,100-(@effect_anime_frame)*2,picture,rect)
      @back_window.contents.blt(166+(@effect_anime_frame)*2,100-(@effect_anime_frame)*2,picture,rect)

      #天津飯
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー弾") #ダメージ表示用
      rect = Rect.new(@effect_anime_type*128, 0,128,128)
      @back_window.contents.blt(342,98-(@effect_anime_frame)*2,picture,rect)
    when 371 #Z1ダブルアイビームヒット
      rect = Rect.new(0, 0,400,28)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波(緑)") #ダメージ表示用
      @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,129,picture,rect)
      @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,189,picture,rect)
      picture = Cache.picture($btl_top_file_name + "戦闘_必殺技_エネルギー波") #ダメージ表示用
      @back_window.contents.blt(-400+@effect_anime_frame*RAY_SPEED,159,picture,rect)
    when 372 #ファイナルかめはめ波(特大_加工)横 発動
      picture = Cache.picture("Z3_戦闘_必殺技_エネルギー波_特大_加工(スピリッツかめはめ波)_発動") #ダメージ表示用
      if @attackcourse == 0
        rect = Rect.new(0, @ray_anime_type*192,@effect_anime_frame*RAY_SPEED,192)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      else
        rect = Rect.new(0, @ray_anime_type*192,@effect_anime_frame*RAY_SPEED,192)
        @back_window.contents.blt(ray_x,ray_y,picture,rect)
      end
      if @ray_anime_frame >= 8  && @ray_anime_type == 0
        @ray_anime_type += 1
        @ray_anime_frame = 0
      elsif @ray_anime_frame >= 8
        @ray_anime_type = 0
        @ray_anime_frame = 0
      end
    else
    end
    @ray_anime_frame +=1
    @effect_anime_frame += 1
  end
  #--------------------------------------------------------------------------
  # ● ダメージ表示
  #--------------------------------------------------------------------------
  def output_battle_damage

    tyousei_x = 16
    tyousei_y = 10
    picturez = Cache.picture("数字英語") #ダメージ表示用
    for y in 1..@battledamage.to_s.size #HP
      rect = Rect.new(@battledamage.to_s[-y,1].to_i*16, 32, 16, 16)
      if @attackcourse == 0 # 味方
        if $game_variables[29] == 0 || $game_variables[29] == 2 #下
          @status_window.contents.blt(@@enestex+tyousei_x+232-(y-1)*16,48+tyousei_y,picturez,rect)
        end

        if $game_variables[29] == 1 || $game_variables[29] == 2 #上
          if @damage_center == false
            @back_window.contents.blt(CENTER_ENEX+72-(y-1)*16,100,picturez,rect)
          else
            @back_window.contents.blt((CENTER_ENEX+72-50)-(y-1)*16,100,picturez,rect)
          end
        end
      else
        if $game_variables[29] == 0 || $game_variables[29] == 2 #下
          @status_window.contents.blt(@@chastex+tyousei_x+48-(y-1)*16,48+tyousei_y,picturez,rect)
        end



        if $game_variables[29] == 1 || $game_variables[29] == 2 #上
          if @damage_center == false
            @back_window.contents.blt(CENTER_CHAX+40-(y-1)*16,100,picturez,rect)
          else
            @back_window.contents.blt((CENTER_CHAX+40-50)-(y-1)*16,100,picturez,rect)
          end
        end

        #吸収
        if $data_skills[@ene_set_action-10].element_set.index(15) != nil#下
          rect = Rect.new(@battledamage.to_s[-y,1].to_i*16, 64, 16, 16)
          @status_window.contents.blt(@@enestex+tyousei_x+232-(y-1)*16,48+tyousei_y,picturez,rect)
        end
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● 戦闘アニメ表示(キャラ)
  #引数n[キャラチップの種類 0:通常攻撃 1:必殺技],y[y軸も反転 0:する 1:しない]
  #--------------------------------------------------------------------------
  def output_battle_anime n=0,y=0,cha_chg_no=0

    top_name = set_ene_str_no @enedatenum

    if n == 0
      if cha_chg_no == 0
        #chpicturea = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name)
        chpicturea = Cache.picture(set_battle_character_name $partyc[@chanum.to_i],n)
      else
        #chpicturea = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[cha_chg_no].name)
        chpicturea = Cache.picture(set_battle_character_name cha_chg_no,n)
      end
      enpicturea = Cache.picture(top_name + "戦闘_敵_" + $data_enemies[@enedatenum].name)
    end
    if n == 1 && @attackcourse == 0 #味方が必殺
      if cha_chg_no == 0
        #chpicturea = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[$partyc[@chanum.to_i]].name)
        chpicturea = Cache.picture(set_battle_character_name $partyc[@chanum.to_i],n)
      else
        #chpicturea = Cache.picture($btl_top_file_name + "戦闘_必殺技_" + $data_actors[cha_chg_no].name)
        chpicturea = Cache.picture(set_battle_character_name cha_chg_no,n)
      end
      enpicturea = Cache.picture(top_name + "戦闘_敵_" + $data_enemies[@enedatenum].name)
    elsif n == 1 && @attackcourse == 1 #敵が必殺
      #chpicturea = Cache.picture($btl_top_file_name + "戦闘_" + $data_actors[$partyc[@chanum.to_i]].name)
      chpicturea = Cache.picture(set_battle_character_name $partyc[@chanum.to_i])
      enpicturea = Cache.picture(top_name + "戦闘_必殺技_敵_" + $data_enemies[@enedatenum].name)
    end

    #結果反映
    if @attackcourse == 0
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

      #敵巨大キャラ
      if $data_enemies[@enedatenum].element_ranks[23] != 1
        @back_window.contents.blt(@enex,@eney,enpicturea,@enerect)
      else
        @back_window.contents.blt(@enex,@eney-48,enpicturea,@enerect)
      end

      #味方巨大キャラ
      if $cha_bigsize_on[@chanum.to_i] != true
        @back_window.contents.blt(@chax,@chay,chpicturea,@charect)
      else
        @back_window.contents.blt(@chax-96,@chay-48,chpicturea,@charect)
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

      #味方巨大キャラ
      if $cha_bigsize_on[@chanum.to_i] != true
        @back_window.contents.blt(@chax,@chay,chpicturea,@charect)
      else
        @back_window.contents.blt(@chax-96,@chay-48,chpicturea,@charect)
      end

      #敵巨大キャラ
      if $data_enemies[@enedatenum].element_ranks[23] != 1
        @back_window.contents.blt(@enex,@eney,enpicturea,@enerect)
      else
        @back_window.contents.blt(@enex-48,@eney-48,enpicturea,@enerect)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘アニメパターンで使用する変数の初期化
  #--------------------------------------------------------------------------
  def anime_pattern_fromat
    output_battle_anime @output_anime_type,@output_anime_type_y,@btl_ani_cha_chg_no
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

    #必殺をもっていないケースを想定していないIF分のため変更
    #if $enecardi[@enenum] == 0 || $enecardi[@enenum] == $data_enemies[@enedatenum].hit-1

    if ($enecardi[@enenum] == 0 || $enecardi[@enenum] == $data_enemies[@enedatenum].hit-1) && $data_enemies[@enedatenum].actions.size != 0
      if $data_enemies[@enedatenum].actions.size != 0
        #必殺技
        #@ene_set_action = $data_enemies[@enedatenum].actions[rand($data_enemies[@enedatenum].actions.size)].skill_id + 10 #敵必殺
        begin
          ene_action_ok = false
          tmp_ene_set_action = rand($data_enemies[@enedatenum].actions.size)


          #通常技
          if $data_enemies[@enedatenum].actions[tmp_ene_set_action].condition_type == 0
              ene_action_ok = true
              if $data_skills[$data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id].element_set[0] == 4
                ene_action_ok = chk_scombo_flag $data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id
              end
          elsif $data_enemies[@enedatenum].actions[tmp_ene_set_action].condition_type == 2
              #p $data_enemies[@enedatenum].actions[tmp_ene_set_action].condition_param2
              #p ($enehp[@enenum]*100/ $data_enemies[@enedatenum].maxhp),$data_enemies[@enedatenum].actions[tmp_ene_set_action].condition_param2.to_i
              if ($enehp[@enenum]*100 / $data_enemies[@enedatenum].maxhp) <= $data_enemies[@enedatenum].actions[tmp_ene_set_action].condition_param2.to_i
                ene_action_ok = true
                #合体攻撃
                #合体攻撃属性を持っているかチェック
                #p $data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id,$data_skills[$data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id].element_set

                if $data_skills[$data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id].element_set[0] == 4
                  ene_action_ok = chk_scombo_flag $data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id
                end
              end
          end

          #1ターンに1回しか使えない技を選択していないか
          if @one_turntec.index($data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id) != nil
            ene_action_ok = false
          end
        end until ene_action_ok == true


        if $data_skills[$data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id].element_set.index(24) != nil
          @one_turntec << $data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id
        end
        #p @one_turntec
        if $game_variables[96] == 0
          @ene_set_action = $data_enemies[@enedatenum].actions[tmp_ene_set_action].skill_id + 10 #敵必殺
        else
          @ene_set_action = @tmp_ene_set_action
        end
      else
        @ene_set_action = 1
      end
    else
      #elsif $enecardi[@enenum] != 0

      @ene_set_action = 1   #敵通常攻撃
    end
  end
  #--------------------------------------------------------------------------
  # ● 合体攻撃を初めて使用したかチェック
  #--------------------------------------------------------------------------
  def chk_new_get_scombo #action_no

    if $game_switches[@btl_ani_scombo_get_flag] == false
      $game_switches[@btl_ani_scombo_new_flag] = true
      $game_switches[30] = true
    end

  end
  #--------------------------------------------------------------------------
  # ● 合体攻撃対象の技を探し使用可能かチェックする
  #　set_action:確認対象必殺技No
  #  chknewonlyflag:未取得のスキルのみチェックするフラグ
  #--------------------------------------------------------------------------
  def chk_scombo_flag_num set_action,chknewonlyflag
    #$cha_set_action[@chanum] - 10
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

    #Sコンボの並びを自分で変えるときだけ処理する
    if $game_variables[358] == 1
      #処理用に再格納
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

      #Sコンボが一つもないかどうかで処理を変える
      if $player_scombo_priority[$partyc[@chanum]] == nil
        scomsize = 0
      else
        scomsize = $player_scombo_priority[$partyc[@chanum]].size
      end

      #配列系はサイズを縮める
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

      #初期化
      for x in 0..scomsize - 1
        tmp_scombo_renban[x] = ttmp_scombo_renban[$player_scombo_priority[$partyc[@chanum]][x]]
        tmp_scombo_cha_count[x] = ttmp_scombo_cha_count[$player_scombo_priority[$partyc[@chanum]][x]]
        tmp_scombo_get_flag[x] = ttmp_scombo_get_flag[$player_scombo_priority[$partyc[@chanum]][x]]
        tmp_scombo_new_flag[x] = ttmp_scombo_new_flag[$player_scombo_priority[$partyc[@chanum]][x]]

        tmp_scombo_no[x] = ttmp_scombo_no[$player_scombo_priority[$partyc[@chanum]][x]]
        tmp_scombo_cha[x] = ttmp_scombo_cha[$player_scombo_priority[$partyc[@chanum]][x]]
        tmp_scombo_flag_tec[x] = ttmp_scombo_flag_tec[$player_scombo_priority[$partyc[@chanum]][x]]
        tmp_scombo_skill_level_num[x] = ttmp_scombo_skill_level_num[$player_scombo_priority[$partyc[@chanum]][x]]
        tmp_scombo_card_attack_num[x] = ttmp_scombo_card_attack_num[$player_scombo_priority[$partyc[@chanum]][x]]
        tmp_scombo_card_gard_num[x] = ttmp_scombo_card_gard_num[$player_scombo_priority[$partyc[@chanum]][x]]
        tmp_scombo_chk_flag_oozaru_put[x] = ttmp_scombo_chk_flag_oozaru_put[$player_scombo_priority[$partyc[@chanum]][x]]
      end

      #p tmp_scombo_no,$player_scombo_priority[$partyc[@chanum]]
    end

    #Sコンボ配列内に対象技があるかチェック
    #なければループ抜ける
    #あれば
    x = 0
    loop do

      for x in 0..tmp_scombo_count
        chk_loop_result = tmp_scombo_flag_tec[x].index(set_action)
        #p "最初のループ",chk_loop_result,x,tmp_scombo_flag_tec[x]
        if chk_loop_result != nil || x >= tmp_scombo_count
          break
        end
        x += 1 if chk_loop_result == nil
      end

      #p "最初のループ抜けた",chk_loop_result,x,tmp_scombo_flag_tec[x]
      if chk_loop_result != nil
        #スパーキングコンボチェック用
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
        #@btl_ani_scombo_tec_no = x
        @btl_ani_scombo_tec_no = tmp_scombo_renban[x]
        tmp_scombo_flag_tec[x] = [0,0] #検索に引っかからないように値を変更
        #tmp_loop_count += 1
        #p @btl_ani_scombo_cha_count,@btl_ani_scombo_get_flag,@btl_ani_scombo_new_flag,@btl_ani_scombo_no,@btl_ani_scombo_cha,@btl_ani_scombo_flag_tec,@btl_ani_scombo_skill_level_num,@btl_ani_scombo_card_attack_num,@btl_ani_scombo_card_gard_num
        #p "スパーキングコンボチェック前",chk_loop_result,x,tmp_scombo_flag_tec[x]
        chk_result = chk_scombo_flag @btl_ani_scombo_no,chknewonlyflag
      end

      if chk_result == true || x >= tmp_scombo_count
        break

      end
    end

    #もし条件が一致するなら合体攻撃を格納
    if chk_result == true
      @scombo_flag = true
      $cha_set_action[@chanum] = @btl_ani_scombo_no + 10
      $tmp_btl_ani_scombo_cha =@btl_ani_scombo_cha
      chk_new_get_scombo #@btl_ani_scombo_no
    end
  end
  #--------------------------------------------------------------------------
  # ● 合体攻撃が使用可能かチェック
  # tmp_set_action:チェック対象のSコンボNo
  # newonlyflag:未取得のSコンボのみ対象とする
  #--------------------------------------------------------------------------
  def chk_scombo_flag tmp_set_action,chknewonlyflag = false
 #p $cha_set_action キャラごとの攻撃スキル番号をセット、攻撃しないのであれば値は0
 #p $cardset_cha_no 指定の枚目にキャラ番号が振ってある1人目は0,2人目は1

    #p @attackcourse,tmp_set_action
    if @attackcourse == 1

      x = 0
      card_attack_num = []    #攻撃星の数
      card_gard_num = []    #防御星の数
      cha_skill_level_num = []
      case tmp_set_action

      when 304 #自爆(サイバイマン
        #ヤムチャ以外には使わない
        #return false if $partyc[@chanum] != 7

        chkchanum = 7

        if get_chabtljoin_dead (chkchanum) == true
          return false
        else
          @ene_coerce_target_chanum = chkchanum
        end
      when 373 #大猿変身(べジータ

        return false if $battle_begi_oozaru_run == true

      when 644 #大猿変身(ターレス

        return false if $battle_tare_oozaru_run == true

      when 645 #巨大化(スラッグ

        return false if $battle_sura_big_run == true

      when 382,383 #パープルコメットクラッシュ
        #ジースが生きてる

        #ジースバータ
        if $battleenemy.index(49) != nil
          enenum = [49,50]
        else
          enenum = [248,249]
        end

        for x in 0..enenum.size - 1
          #p $battleenemy.index(enenum[x]),$enedeadchk[$battleenemy.index(enenum[x])-1],$ene_stop_num[$battleenemy.index(enenum[x])-1]
          return false if $battleenemy.index(enenum[x]) == nil
          return false if $enedeadchk[$battleenemy.index(enenum[x])-1] == true #生きてるか
          return false if $ene_stop_num[$battleenemy.index(enenum[x])-1] != 0 #超能力にかかってないか
        end
      when 518 #ブージン)合体超能力

        enenum = [145,146,147]

        for x in 0..enenum.size - 1
          #p $battleenemy.index(enenum[x]),$enedeadchk[$battleenemy.index(enenum[x])-1],$ene_stop_num[$battleenemy.index(enenum[x])-1]
          return false if $battleenemy.index(enenum[x]) == nil
          return false if $enedeadchk[$battleenemy.index(enenum[x])-1] == true #生きてるか
          return false if $ene_stop_num[$battleenemy.index(enenum[x])-1] != 0 #超能力にかかってないか
        end
      when 583 #リベンジャーチャージ
        return false if $battle_ribe_charge == true #リベンジャーチャージ管理用
      when 584 #リベンジャーカノン
        return false if $battle_ribe_charge == false #リベンジャーチャージ管理用
        return false if $battle_ribe_charge_turn == true #リベンジャーチャージしたターンか
      when 607 #タード&ゾルト)ダブルアタック

        enenum = [178,180]

        for x in 0..enenum.size - 1
          #p $battleenemy.index(enenum[x]),$enedeadchk[$battleenemy.index(enenum[x])-1],$ene_stop_num[$battleenemy.index(enenum[x])-1]
          return false if $battleenemy.index(enenum[x]) == nil
          return false if $enedeadchk[$battleenemy.index(enenum[x])-1] == true #生きてるか
          return false if $ene_stop_num[$battleenemy.index(enenum[x])-1] != 0 #超能力にかかってないか
        end
      when 637,640 #レズン、ラカセイ)ダブルエネルギー波

        #レズン、ラカセイ
        if $battleenemy.index(68) != nil
          enenum = [68,69]
        else
          enenum = [220,221]
        end

        for x in 0..enenum.size - 1
          #p $battleenemy.index(enenum[x]),$enedeadchk[$battleenemy.index(enenum[x])-1],$ene_stop_num[$battleenemy.index(enenum[x])-1]
          return false if $battleenemy.index(enenum[x]) == nil
          return false if $enedeadchk[$battleenemy.index(enenum[x])-1] == true #生きてるか
          return false if $ene_stop_num[$battleenemy.index(enenum[x])-1] != 0 #超能力にかかってないか
        end
      end
    else
      for x in 0..@btl_ani_scombo_cha_count-1

        if $partyc.index(@btl_ani_scombo_cha[x]) != nil #仲間にいる
          if $cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x])) != nil #攻撃参加している
          #if $cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x])) != nil #攻撃参加している 20140203コメントアウト
            #p $scombo_chk_flag[@btl_ani_scombo_tec_no],@btl_ani_scombo_tec_no
            if $scombo_chk_flag[@btl_ani_scombo_tec_no] != 0



              if $scombo_chk_flag[@btl_ani_scombo_tec_no] == 1 #スイッチ

                return false if $game_switches[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] == false
                #p $scombo_chk_flag_no[x],$game_switches[$scombo_chk_flag_no[x]]
              elsif $scombo_chk_flag[@btl_ani_scombo_tec_no] == 2 #変数
                #チェック方法 0:一致 1:以上 2:以下
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

            #スキルでSコンボの必要な星を調整
            scmb_mainasu_a = 0
            scmb_mainasu_g = 0

            scmb_mainasu_a,scmb_mainasu_g = chk_doutyou_run @btl_ani_scombo_cha[x]

            #シナリオ進行度
            return false if $scombo_chk_scenario_progress[@btl_ani_scombo_tec_no] > $game_variables[40]
            return false if chk_skill_learn(430,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
            return false if chk_skill_learn(644,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
            return false if chk_skill_learn(645,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
            return false if chk_skill_learn(646,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
            return false if chk_skill_learn(647,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
            return false if chk_skill_learn(648,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
            return false if chk_skill_learn(649,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
            return false if chk_skill_learn(650,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
            return false if chk_skill_learn(651,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
            return false if chk_skill_learn(476,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
            return false if chk_skill_learn(477,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
            return false if chk_skill_learn(478,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
            return false if chk_skill_learn(479,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
            return false if chk_skill_learn(480,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
            return false if chk_skill_learn(481,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
            return false if chk_skill_learn(482,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
            return false if chk_skill_learn(483,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
            return false if chk_skill_learn(484,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
            return false if $chadeadchk[$partyc.index(@btl_ani_scombo_cha[x])] == true #生きてる
            return false if $cha_stop_num[$partyc.index(@btl_ani_scombo_cha[x])] != 0 #超能力にかかってないか
            return false if @cha_attack_run[$partyc.index(@btl_ani_scombo_cha[x])] == true #行動済みではない
            return false if $cha_set_action[$partyc.index(@btl_ani_scombo_cha[x])]-10 != @btl_ani_scombo_flag_tec[x] #対象技を使ってるか
            return false if $game_actors[@btl_ani_scombo_cha[x]].class_id-1 != $cardi[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] #流派が一致
            return false if $carda[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] < (@btl_ani_scombo_card_attack_num[x] - scmb_mainasu_a) #カードの攻撃星が以上
            return false if $cardg[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] < (@btl_ani_scombo_card_gard_num[x] - scmb_mainasu_g) #カードの防御星が以上
            $cha_skill_level[@btl_ani_scombo_flag_tec[x]] = 0 if $cha_skill_level[@btl_ani_scombo_flag_tec[x]] == nil #必殺技使用回数がnilかチェックしてnilなら0格納
            return false if $cha_skill_level[@btl_ani_scombo_flag_tec[x]] < @btl_ani_scombo_skill_level_num[x]
            if $game_switches[1305] == false #戦闘の練習中は覚えない
              return false if $game_switches[$scombo_get_flag[@btl_ani_scombo_tec_no]] == true && chknewonlyflag == true #未取得のスキルのみ
            else
              return false if $game_switches[$scombo_get_flag[@btl_ani_scombo_tec_no]] == false && chknewonlyflag == true #未取得のスキルのみだとしても
            end
            return false if $game_switches[$scombo_get_flag[@btl_ani_scombo_tec_no]] == false && chknewonlyflag == false #取得済みのスキルのみ

            return false if $cha_single_attack[$partyc.index(@btl_ani_scombo_cha[x])] == true #&& chknewonlyflag == false #Sコンボ使わないフラグがONになっていないか

            #大猿チェック
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
    @enenum = $attack_order[x].to_s[1,1].to_i #敵キャラNoセット(表示順)
    @enedatenum = $battleenemy[@enenum] #キャラNoセット(データ順)
    if $attack_order[x].to_s.size == 1
      @attack_num = 1
    else
      #攻撃が強制的に1回フラグがOFFならば設定値、ONならば1にする
      if $game_switches[40] == false
        @attack_num = $data_enemies[@enedatenum].eva
      else
        @attack_num = 1
      end
      if $game_switches[25] == true || $game_switches[28] == true #一定人数になると攻撃回数増加チェックフラグ
        ene_non_dead_count = 0
        for a in 0..$enedead.size-1
          ene_non_dead_count += 1 if $enedead[a] == false
        end

        if $game_switches[25] == true
          @attack_num +=1 if ene_non_dead_count == 1
        end
        if $game_switches[28] == true
          @attack_num +=1 if ene_non_dead_count <= 2
        end
      end

      if $game_switches[26] == true #HP30％攻撃回数増加チェックフラグ
        @attack_num +=1 if ($enehp[@enenum]*100 / $data_enemies[@enedatenum].maxhp) <= 30
      end

      if $game_switches[27] == true #HP40％攻撃回数増加チェックフラグ
        @attack_num +=1 if ($enehp[@enenum]*100 / $data_enemies[@enedatenum].maxhp) <= 40
      end

      if $game_switches[29] == true #HP50％攻撃回数増加チェックフラグ
        @attack_num +=1 if ($enehp[@enenum]*100 / $data_enemies[@enedatenum].maxhp) <= 50
      end

      #戦闘イベントの場合は強制的に攻撃回数を1とする
      if $game_variables[96] != 0
        @attack_num =1
      end
      if @attack_count > 0
        create_enemy_card (@enenum,false)
        ryuhakakuritu_keisan @enenum,$battleenemy[@enenum]
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● 必殺技熟練度をデータベースへセット
  #--------------------------------------------------------------------------
  def set_skill_level
    if @attackcourse == 0 #味方
      for x in 0..$Cardmaxnum
        if $cardset_cha_no[x] == @chanum.to_i
          if $cha_set_action[@chanum] >= 11
            #使用回数増加
            if $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] == nil
              $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] = 0
            end
            $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] += 1 if $game_switches[1305] == false
            #使用回数が9999を超えたら9999をセット
            if $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] > $cha_skill_level_max
              $cha_skill_level[$data_skills[$cha_set_action[@chanum] - 10].id] = $cha_skill_level_max
            end

            #必殺技回数同期
            if $data_skills[$cha_set_action[@chanum] - 10].message2 != ""

              #同期対象の配列取得
              skillsyncs = $data_skills[$cha_set_action[@chanum] - 10].message2.split(",")

              #skill最大値
              skillmax = 0

              #skill最大値の取得
              for x in 0..skillsyncs.size-1
                #同期先がnilの場合0セット
                if $cha_skill_level[skillsyncs[x].to_i] == nil
                    $cha_skill_level[skillsyncs[x].to_i] = 0
                end
                if skillmax < $cha_skill_level[skillsyncs[x].to_i]
                  skillmax = $cha_skill_level[skillsyncs[x].to_i]
                end
              end

              #最大値をセット
              for x in 0..skillsyncs.size-1
                #最大値より小さければセットする
                if skillmax > $cha_skill_level[skillsyncs[x].to_i]
                  $cha_skill_level[skillsyncs[x].to_i] = skillmax
                end
              end
            end

          else #通常攻撃
            #nilの初期化
            $cha_normal_attack_level[$partyc[@chanum]] = 0 if $cha_normal_attack_level[$partyc[@chanum]] == nil

            saiyazinflag = false
            tuuzyouchanum = 0
            superchanum = 0

            #サイヤ人系の通常攻撃の回数同期用の事前処理
            case $partyc[@chanum]

            when 3,14 #悟空
              tuuzyouchanum = 3
              superchanum = 14
              saiyazinflag = true
            when 5,18 #悟飯
              tuuzyouchanum = 5
              superchanum = 18
              saiyazinflag = true
            when 12,19 #ベジータ
              tuuzyouchanum = 12
              superchanum = 19
              saiyazinflag = true
            when 17,20 #トランクス
              tuuzyouchanum = 17
              superchanum = 20
              saiyazinflag = true
            when 16,32 #バーダック
              tuuzyouchanum = 16
              superchanum = 32
              saiyazinflag = true
            when 25,26 #未来悟飯
              tuuzyouchanum = 25
              superchanum = 26
              saiyazinflag = true
            end

            #サイヤ人系の通常攻撃の回数同期用の処理
            if saiyazinflag == true
              #nilの初期化
              $cha_normal_attack_level[tuuzyouchanum] = 0 if $cha_normal_attack_level[tuuzyouchanum] == nil
              #nilの初期化
              $cha_normal_attack_level[superchanum] = 0 if $cha_normal_attack_level[superchanum] == nil

              if $cha_normal_attack_level[tuuzyouchanum] > $cha_normal_attack_level[superchanum]
                $cha_normal_attack_level[superchanum] = $cha_normal_attack_level[tuuzyouchanum]
              else
                $cha_normal_attack_level[tuuzyouchanum] = $cha_normal_attack_level[superchanum]
              end

            end
            #p $cha_normal_attack_level

            #攻撃回数加算
            $cha_normal_attack_level[$partyc[@chanum]] += 1 if $game_switches[1305] == false
            #p $cha_normal_attack_level
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
        set_battle_bgm_name true
      else
        #逃げられないのはイベント戦判定にする。
        set_battle_bgm_name true,1
      end

      if $battle_escape == true
        if $option_battle_bgm_name.include?("_user") == false
          Audio.bgm_play("Audio/BGM/" + $option_battle_bgm_name)    # 効果音を再生する
        else
          Audio.bgm_play("Audio/MYBGM/" + $option_battle_bgm_name)    # 効果音を再生する
        end
      else
        if $option_evbattle_bgm_name.include?("_user") == false
          Audio.bgm_play("Audio/BGM/" + $option_evbattle_bgm_name)    # 効果音を再生する
        else
          Audio.bgm_play("Audio/MYBGM/" + $option_evbattle_bgm_name)    # 効果音を再生する
        end
      end

      #$put_battle_bgm = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃セット
  # x:アニメの配列位置
  #--------------------------------------------------------------------------
  def set_def_attack x=1
    case $attack_anime[x]

    when 1
      @battle_anime_result = anime_pattern 51 #キック　左

    when 2
      @battle_anime_result = anime_pattern 52 #キック　右

    when 3
      @battle_anime_result = anime_pattern 53 #パンチ　左

    when 4
      @battle_anime_result = anime_pattern 54 #パンチ　右
    end
  end

  #--------------------------------------------------------------------------
  # ● 爆発効果音、エフェクトセット
  # x:アニメの配列位置
  #--------------------------------------------------------------------------
  def get_explosion get_flag = false


      #dmg_rate = 100 if dmg_rate > 100
      #p dmg_rate

      #味方と敵でレートを変更する
      if @attackcourse == 0
        dmg_rate = (@battledamage / $data_enemies[@enedatenum].maxhp.prec_f * 100).prec_i

        if $data_enemies[@enedatenum].element_ranks[22] == 1
          dmg_rate = dmg_rate * 5
        end

        case dmg_rate

        when 0..20
          #小
          explosion_se = "Audio/SE/" + "Z3 光線系ヒット"
          explosion_eff = 101
        when 21..40
          #中
          explosion_se = "Audio/SE/" + "ZG 光線系ヒット2"
          explosion_eff = 102
        when 41..60
          #大
          explosion_se = "Audio/SE/" + "ZG 光線系ヒット3"
          explosion_eff = 103
        when 61..99
          #特大
          explosion_se = "Audio/SE/" + "Z1 爆発1"
          explosion_eff = 104
        else
          #撃破
          explosion_se = "Audio/SE/" + "DB3 大爆発"
          explosion_eff = 105
        end




      else
        dmg_rate = (@battledamage / $game_actors[$partyc[@chanum.to_i]].maxhp.prec_f * 100).prec_i
        case dmg_rate
        #$game_actors[$partyc[@chanum.to_i]].hp.prec_f / $game_actors[$partyc[@chanum.to_i]].maxhp.prec_f * 100).prec_i

          when 0..15
            #小
            explosion_se = "Audio/SE/" + "Z3 光線系ヒット"
            explosion_eff = 101
          when 16..30
            #中
            explosion_se = "Audio/SE/" + "ZG 光線系ヒット2"
            explosion_eff = 102
          when 31..45
            #大
            explosion_se = "Audio/SE/" + "ZG 光線系ヒット3"
            explosion_eff = 103
          when 46..60
            #特大
            explosion_se = "Audio/SE/" + "Z1 爆発1"
            explosion_eff = 104
          else
            #撃破
            explosion_se = "Audio/SE/" + "DB3 大爆発"
            explosion_eff = 105
        end
      end
      return explosion_se,explosion_eff
  end
end