#==============================================================================
#　（元ネタ）隠しセーブスクリプト
#　　Script by kassyi
#　　http://www.tekepon.net/fsm/
#==============================================================================

module DDS
  module Auto_Save

  def self.save()
    file = File.open("Save_Auto.rvdata", "wb")
    #$game_variables[21] = false
    characters = []
    for actor in $game_party.members
      characters.push([actor.character_name, actor.character_index])
    end
    $game_system.save_count += 1
    $game_system.version_id = $data_system.version_id
    @last_bgm = RPG::BGM::last
    @last_bgs = RPG::BGS::last
    Marshal.dump(characters,           file)
    Marshal.dump(Graphics.frame_count, file)
    Marshal.dump(@last_bgm,            file)
    Marshal.dump(@last_bgs,            file)
    Marshal.dump($game_system,         file)
    Marshal.dump($game_message,        file)
    Marshal.dump($game_switches,       file)
    Marshal.dump($game_variables,      file)
    Marshal.dump($game_self_switches,  file)
    Marshal.dump($game_actors,         file)
    Marshal.dump($game_party,          file)
    Marshal.dump($game_troop,          file)
    Marshal.dump($game_map,            file)
    Marshal.dump($game_player,         file)
    Marshal.dump($carda,               file) #味方カード攻撃
    Marshal.dump($cardg,               file) #味方カード防御
    Marshal.dump($cardi,               file) #味方カード流派
    Marshal.dump($cardi_max,           file) #流派種類最大数
    Marshal.dump($partyc,              file) #パーティー
    Marshal.dump($chadead,             file) #パーティーの死亡状態
    Marshal.dump($cha_skill_level,     file) #必殺技熟練度
    Marshal.dump($card_run_num,        file) #カード使用回数
    Marshal.dump($cha_defeat_num,      file) #味方撃破数使用回数
    Marshal.dump($ene_defeat_num,      file) #敵撃破数使用回数
    Marshal.dump($ene_enc_history_flag,file) #敵と遭遇したかフラグ
    Marshal.dump($cha_attack_damege,   file) #与えたダメージ
    Marshal.dump($cha_gard_damege,   file)   #食らったダメージ
    Marshal.dump($cha_attack_count,   file) #与えた回数
    Marshal.dump($cha_gard_count,   file)   #食らった回数
    Marshal.dump($ene_sco_history_flag,file) #敵とスカウター使用したかフラグ
    Marshal.dump($ene_crd_history_flag,file) #敵とカード取得したかフラグ
    Marshal.dump($bgm_btl_random_flag,file) #戦闘BGMランダム時再生するか
    Marshal.dump($cha_skill_set_flag,file) #キャラクタースキルセットフラグ
    Marshal.dump($cha_typical_skill,file) #固有スキル
    Marshal.dump($cha_add_skill,file) #追加スキル
    Marshal.dump($cha_skill_spval,file) #キャラクタースキルap取得
    Marshal.dump($skill_set_get_num,file) #スキルセット可能数と取得数
    Marshal.dump($zp,file) #zp
    Marshal.dump($cha_tactics,file) #作戦
    Marshal.dump($cha_bigsize_on,file) #巨大化状態
    Marshal.dump($oozaru_flag,file) #大猿状態
    Marshal.dump($cha_skill_get_flag,file) #キャラクタースキル取得済みフラグ
    Marshal.dump($story_partyc,file) #時の間用ストーリーパーティー
    Marshal.dump($cha_add_skill_set_num,file) #追加スキルセット可能数
    
    #バーダック編関連
    Marshal.dump($cha_typical_skill_z1bar,file) 
    Marshal.dump($cha_add_skill_z1bar,file) 
    Marshal.dump($cha_skill_set_flag_z1bar,file) 
    Marshal.dump($cha_skill_get_flag_z1bar,file) 
    Marshal.dump($cha_add_skill_set_num_z1bar,file) 
    Marshal.dump($cha_skill_spval_z1bar,file) 
    Marshal.dump($zp_z1bar,file) 
    Marshal.dump($game_actors_z1bar,file) 
    Marshal.dump($cha_defeat_num_z1bar,file) 
    Marshal.dump($game_party_z1bar,file) 
    Marshal.dump($tmp_partyc,file) 
    
    
    Marshal.dump($zp_first_deal,file) #ZP初回割り振りを行ったか？
    Marshal.dump($btl_arena_fight_rank,file) #バトルアリーナエントリー可能フラグ
    Marshal.dump($btl_arena_fight_rank_clear_num,file) #バトルアリーナランククリア回数
    Marshal.dump($cha_set_free_skill,file) #スキルフリーを他のスキルに変えたか
    Marshal.dump($btl_arena_first_item_get,file) #バトルアリーナ初回報酬取得フラグ
    
    Marshal.dump($super_saiyazin_flag,file) #超サイヤ人状態
    Marshal.dump($runzp,file) #使用したZP(回数)
    
    Marshal.dump($bgm_menu_random_flag,file) #メニューBGMランダム時再生するか
    
    Marshal.dump($game_laps,file) #ゲーム周回数

    #特殊エリア移動用
    Marshal.dump($tmp_chadead,file)
    Marshal.dump($tmp_cb,file)
    Marshal.dump($tmp_oz_fg,file)
    Marshal.dump($tmp_sp_saiya_flag,file) #超サイヤ人状態
    
    #時の間からストーリーに戻るため
    Marshal.dump($story_sp_saiya,file) #時の間用ストーリーサイヤ人フラグ
    #悟飯超2から通常に戻る時のスキル保存用
    #Marshal.dump($gohan_mzenkaiskillno,file)
    
    #周回プレイ用に最大LVを保持する
    #Marshal.dump($cha_maxlv,file) #そのキャラの最大レベル
    
    #通常攻撃の熟練度(使用回数カウント)
    Marshal.dump($cha_normal_attack_level,file)
    
    #プレイヤーのSコンボ優先度設定
    Marshal.dump($player_scombo_priority,file)
    #イベント戦闘BGMランダム時再生するか
    Marshal.dump($bgm_evbtl_random_flag,file) 
    #カード合成レシピ
    Marshal.dump($get_card_compo_recipe,file)
    #カード合成レシピの使用回数
    Marshal.dump($card_compo_recipe_run_num,file)
    #優先表示カードNo
    Marshal.dump($priority_card_no,file)
    
    #Iniファイル書き込み
    ini = Ini_File.new("game.ini")
    #進行度
    result = 0
    #$game_progress = ini.write_profile("Game","Progress",$game_variables[40].to_s)
    result = ini.write_profile("Game","Progress",$game_variables[40].to_s)
    #ウインドウスキン
    #$op_game_skin = ini.write_profile("Game","Game_skin",$game_variables[83].to_s)
    result = ini.write_profile("Game","Game_skin",$game_variables[83].to_s)
    #オープニング変更 #1:セルゲーム(悟空)、#2セルゲーム(超悟飯)、#3セルゲーム(超悟飯2)
    #1:Z4から、#2:メタルクウラ編から、#3:セルゲームクリア後
    #if $game_variables[84] != 0
    #$op_change = ini.write_profile("Game","Op_Change",$game_variables[84].to_s)
    result = ini.write_profile("Game","Op_Change",$game_variables[84].to_s)
    #end
    
    #オープニング変更
    #ZG バーダック一味編
    if $game_variables[43] >= 143 && $game_variables[43] <= 149
      result = ini.write_profile("Game","Op_Change","4")
    end
    #ZG 本編
    if $game_variables[43] >= 151 && $game_variables[43] <= 200
      result = ini.write_profile("Game","Op_Change","5")
    end
    #オープニングカットフラグ
    result = ini.write_profile("Game","Op_Cut",$game_variables[302].to_s)
    
    #セーブ数
    save_num = ini.write_profile("Game","save_num",$ini_savedata_num.to_s)
    $EXMNU_INCSF_FILE_MAX = $ini_savedata_num
    file.close
  end
  
  def self.load()
    file = File.open("Save_Auto.rvdata", "rb")
begin
    # 実行する処理
    characters           = Marshal.load(file)
    Graphics.frame_count = Marshal.load(file)
    @last_bgm            = Marshal.load(file)
    @last_bgs            = Marshal.load(file)
    $game_system         = Marshal.load(file)
    $game_message        = Marshal.load(file)
    $game_switches       = Marshal.load(file)
    $game_variables      = Marshal.load(file)
    $game_self_switches  = Marshal.load(file)
    $game_actors         = Marshal.load(file)
    $game_party          = Marshal.load(file)
    $game_troop          = Marshal.load(file)
    $game_map            = Marshal.load(file)
    $game_player         = Marshal.load(file)
    $carda               = Marshal.load(file) #味方カード攻撃
    $cardg               = Marshal.load(file) #味方カード防御
    $cardi               = Marshal.load(file) #味方カード流派
    $cardi_max           = Marshal.load(file) #流派種類最大数
    $partyc              = Marshal.load(file) #パーティー
    $chadead             = Marshal.load(file) #パーティーの死亡状態
    $cha_skill_level     = Marshal.load(file) #必殺技熟練度
    $card_run_num        = Marshal.load(file) #カード使用回数
    $cha_defeat_num      = Marshal.load(file) #味方撃破数使用回数
    $ene_defeat_num      = Marshal.load(file) #敵撃破数使用回数
    $ene_enc_history_flag = Marshal.load(file)#敵と遭遇したかフラグ
    $cha_attack_damege = Marshal.load(file)#与えたダメージ
    $cha_gard_damege = Marshal.load(file)#食らったダメージ
    $cha_attack_count = Marshal.load(file)#与えた回数
    $cha_gard_count = Marshal.load(file)#食らった回数
    $ene_sco_history_flag = Marshal.load(file)#敵スカウター使用したかフラグ
    $ene_crd_history_flag = Marshal.load(file)#敵カード取得したかフラグ
    $bgm_btl_random_flag = Marshal.load(file)#戦闘BGMランダム時再生するか
    $cha_skill_set_flag = Marshal.load(file)#キャラクタースキルセットフラグ
    $cha_typical_skill = Marshal.load(file)#固有スキル
    $cha_add_skill = Marshal.load(file)#追加スキル
    $cha_skill_spval = Marshal.load(file)#キャラクタースキルap取得
    $skill_set_get_num = Marshal.load(file) #スキルセット可能数と取得数
    $zp = Marshal.load(file) #zp
    $cha_tactics= Marshal.load(file) #作戦
    $cha_bigsize_on= Marshal.load(file) #巨大化状態
    $oozaru_flag= Marshal.load(file) #大猿状態
    $cha_skill_get_flag = Marshal.load(file)#キャラクタースキル取得済みフラグ
    $story_partyc = Marshal.load(file)#時の間用ストーリーパーティー
    $cha_add_skill_set_num = Marshal.load(file) #追加スキルセット可能数
    
    #バーダック編関連
    $cha_typical_skill_z1bar = Marshal.load(file) 
    $cha_add_skill_z1bar = Marshal.load(file) 
    $cha_skill_set_flag_z1bar = Marshal.load(file) 
    $cha_skill_get_flag_z1bar = Marshal.load(file) 
    $cha_add_skill_set_num_z1bar = Marshal.load(file) 
    $cha_skill_spval_z1bar = Marshal.load(file) 
    $zp_z1bar = Marshal.load(file) 
    $game_actors_z1bar = Marshal.load(file) 
    $cha_defeat_num_z1bar = Marshal.load(file) 
    $game_party_z1bar = Marshal.load(file) 
    $tmp_partyc = Marshal.load(file)
    
    $zp_first_deal = Marshal.load(file) #ZP初回割り振りを行ったか？
    $btl_arena_fight_rank = Marshal.load(file) #バトルアリーナエントリー可能フラグ
    $btl_arena_fight_rank_clear_num = Marshal.load(file) #バトルアリーナランククリア回数
    $cha_set_free_skill = Marshal.load(file) #スキルフリーを他のスキルに変えたか
    $btl_arena_first_item_get = Marshal.load(file) #バトルアリーナ初回報酬取得フラグ
    
    $super_saiyazin_flag = Marshal.load(file) #超サイヤ人状態
    $runzp = Marshal.load(file) #使用したZP(回数)
    $bgm_menu_random_flag = Marshal.load(file) #メニューBGMランダム時再生するか
    $game_laps = Marshal.load(file) #ゲーム周回数
    #特殊エリア移動用
    $tmp_chadead = Marshal.load(file)
    $tmp_cb = Marshal.load(file)
    $tmp_oz_fg = Marshal.load(file)
    $tmp_sp_saiya_flag = Marshal.load(file) #超サイヤ人状態
    
    #時の間からストーリーに戻るため
    $story_sp_saiya = Marshal.load(file) #時の間用ストーリーサイヤ人フラグ
    
    #悟飯超2から通常に戻る時のスキル保存用
    #$gohan_mzenkaiskillno = Marshal.load(file)
    
    #通常攻撃の熟練度(使用回数カウント)
    $cha_normal_attack_level = Marshal.load(file)
    
    #プレイヤーのSコンボ優先度設定
    $player_scombo_priority = Marshal.load(file)
    
    $bgm_evbtl_random_flag = Marshal.load(file)#イベント戦闘BGMランダム時再生するか
    
    #カード合成レシピ
    $get_card_compo_recipe = Marshal.load(file)
    #カード合成レシピの使用回数
    $card_compo_recipe_run_num = Marshal.load(file)
    
    #優先表示カードNo
    $priority_card_no = Marshal.load(file)
    
    rescue
      # 例外が発生したときの処理
    else
      # 例外が発生しなかったときに実行される処理
    ensure
      # 例外の発生有無に関わらず最後に必ず実行する処理
    end

    if $game_system.version_id != $data_system.version_id
      $game_map.setup($game_map.map_id)
      $game_player.center($game_player.x, $game_player.y)
    end
    
    set_start_val 1
    
    set_start_val 2 #ZP使用量セット
    
    set_start_val 3 #MAXLVセット
    
    set_levelup_se #レベルアップSEのファイル名を取得
    
    #全キャラ次までの経験値セットしなおし
    for x in 1..$data_actors.size - 1
      $game_actors[x].make_exp_list
    end
    #$game_actors[$partyc[@@cursorstate]].next_rest_exp_s
    #全カード取得
    #for x in 1..$data_items.size
    #  $game_party.gain_item ($data_items[x], 1)
    #end
    
    run_common_event 9 #必殺技設定
    run_common_event 34 #後から追加設定
    run_common_event 158 #超サイヤ人不整合修正
    
    #死亡状態配列に不正があった時に調整する
    #原因は不明だがサイズが不正になることがあるっぽいのでその対策
    if $chadead.size != $partyc.size
      $chadead = $chadead[0..$partyc.size-1]
    end
    
    #亀仙人のスキルZ戦士の絆LVを取得済みに変える
    ##バイオ戦士倒したら
    #if $game_switches[502] == true
      get_skill 24,13
    #end
    #トランクスのスキルZ戦士の絆LVを取得済みに変える
    ##20号発見したら
    #if $game_switches[426] == true
      get_skill 17,13
      get_skill 20,13
    #end

    get_full_party
    
    #p "瞬間移動かめはめ波：" + $cha_skill_level[27].to_s,
    #  "魔空包囲弾　　　　：" + $cha_skill_level[40].to_s,
    #  "激烈魔閃光　　　　：" + $cha_skill_level[53].to_s,
    #  "スーパーかめはめ波：" + $cha_skill_level[54].to_s
    
    chk_correction_addskill #追加スキルのデータ補正(取得状況とか)
    
    set_actor_final_level #最終レベルの計算
    
    #カードの最大所持数更新(セーブデータに入れる事も可能だが、データ容量を抑えるために都度処理にした)
    update_max_item_card_num
    
    #Sコンボのプレイヤー発動優先度を最新化する
    update_player_scombo_priority
    
    #メニュー表示のスイッチ初期化
    for i in 2302..2305
      $game_switches[i] = false
    end
    
    #敵のパラメータ取得
    KGC::LimitBreak.set_enemy_parameters
    KGC::LimitBreak.revise_enemy_parameters
    
    RPG::BGM.fade(1000)
    Graphics.fadeout(60)
    Graphics.wait(40)
    
    file.close
    $scene = Scene_Map.new
#~     RPG::BGM.fade(1500)
#~     Graphics.fadeout(60)
#~     Graphics.wait(40)
    @last_bgm.play
    @last_bgs.play
    

    
  end
  
  end
end

=begin
class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ◎ 開始処理
  #--------------------------------------------------------------------------
  alias dds_start start
  def start
    check_autosave
    dds_start
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (再定義)
  #--------------------------------------------------------------------------
  def update
    super
    @command_window.update
    if Input.trigger?(Input::C)
      case @command_window.index
      when 0    # ニューゲーム
        command_new_game
      when 1    # コンティニュー
        command_continue
      when 2    # オートセーブ
        command_autosave
      when 3    # シャットダウン
        command_shutdown
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ オートセーブ有効判定
  #--------------------------------------------------------------------------
  def check_autosave
    @autosave_enabled = (Dir.glob('Auto_Save.rvdata').size > 0)
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成 (再定義)
  #--------------------------------------------------------------------------
  def create_command_window
    s1 = Vocab::new_game
    s2 = Vocab::continue
    s3 = "ＡＵＴＯ ＳＡＶＥ"
    s4 = Vocab::shutdown
    @command_window = Window_Command.new(172, [s1, s2, s3, s4])
    @command_window.x = (544 - @command_window.width) / 2
    @command_window.y = 220
    if @continue_enabled                    # コンティニューが有効な場合
      @command_window.index = 1             # カーソルを合わせる
    else                                    # 無効な場合
      @command_window.draw_item(1, false)   # コマンドを半透明表示にする
    end
    unless @autosave_enabled                # オートセーブが無効な場合
      @command_window.draw_item(2, false)   # コマンドを半透明表示にする
    end
    @command_window.openness = 0
    @command_window.open
  end
  #--------------------------------------------------------------------------
  # ○ コマンド : オートセーブ
  #--------------------------------------------------------------------------
  def command_autosave
    if @autosave_enabled
      Sound.play_decision
      DDS::Auto_Save::load()
    else
      Sound.play_buzzer
    end
  end
end

class Scene_Battle < Scene_Base
#~   #--------------------------------------------------------------------------
#~   # ◎ 終了処理
#~   #--------------------------------------------------------------------------
#~   alias dds_update_terminate terminate
#~   def terminate
#~     dds_update_terminate
#~     DDS::Auto_Save::save()
#~   end
  #--------------------------------------------------------------------------
  # ◎ 戦闘終了
  #     result : 結果 (0:勝利 1:逃走 2:敗北)
  #--------------------------------------------------------------------------
  alias autosave_battle_end battle_end
  def battle_end(result)
    autosave_battle_end(result)
    DDS::Auto_Save::save() unless result == 2
  end
end
=end