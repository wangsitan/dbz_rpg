#==============================================================================
# ■ Scene_Title
#------------------------------------------------------------------------------
# 　タイトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Title < Scene_Base
  include Share
  include Db_Battle_Anime_test_Setup
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main

    if $BTEST                         # 戦闘テストの場合
      battle_test                     # 戦闘テストの開始処理
    else                              # 通常のプレイの場合
      super                           # 本来のメイン処理
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    
    load_database                     # データベースをロード
    create_game_objects               # ゲームオブジェクトを作成
    check_continue                    # コンティニュー有効判定

      
    if $battle_test_flag == true
      #戦闘テスト用
      $scene = Scene_Db_Battle_Anime.new
      set_start_val
      #set_start_val 3 #MAXLVセット
      
    else
      create_title_graphic              # タイトルグラフィックを作成
      create_command_window             # コマンドウィンドウを作成
      play_title_music                  # タイトル画面の音楽を演奏
    end

  end
  #--------------------------------------------------------------------------
  # ● トランジション実行
  #--------------------------------------------------------------------------
  def perform_transition
    Graphics.transition(20)
  end
  #--------------------------------------------------------------------------
  # ● 開始後処理
  #--------------------------------------------------------------------------
  def post_start
    super
    
    open_command_window if $battle_test_flag != true
 
    #p $op_change,$game_progress
  end
  #--------------------------------------------------------------------------
  # ● 終了前処理
  #--------------------------------------------------------------------------
  def pre_terminate
    super
    close_command_window if @command_window != nil
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_command_window
    snapshot_for_background
    dispose_title_graphic
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @command_window.update if @command_window != nil
    if Input.trigger?(Input::C)
      $data_system.sounds[1].name = "Z3 決定"
      case @command_window.index
      when 0    # ニューゲーム
        command_new_game
      when 1    # コンティニュー
        command_continue
      when 2    # オプション
        command_option
      when 3    # シャットダウン
        command_shutdown
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● データベースのロード
  #--------------------------------------------------------------------------
  def load_database
    $data_actors        = load_data("Data/Actors.rvdata")
    $data_classes       = load_data("Data/Classes.rvdata")
    $data_skills        = load_data("Data/Skills.rvdata")
    $data_items         = load_data("Data/Items.rvdata")
    $data_weapons       = load_data("Data/Weapons.rvdata")
    $data_armors        = load_data("Data/Armors.rvdata")
    $data_enemies       = load_data("Data/Enemies.rvdata")
    $data_troops        = load_data("Data/Troops.rvdata")
    $data_states        = load_data("Data/States.rvdata")
    $data_animations    = load_data("Data/Animations.rvdata")
    $data_common_events = load_data("Data/CommonEvents.rvdata")
    $data_system        = load_data("Data/System.rvdata")
    $data_areas         = load_data("Data/Areas.rvdata")
  end
  #--------------------------------------------------------------------------
  # ● 戦闘テスト用データベースのロード
  #--------------------------------------------------------------------------
  def load_bt_database
    $data_actors        = load_data("Data/BT_Actors.rvdata")
    $data_classes       = load_data("Data/BT_Classes.rvdata")
    $data_skills        = load_data("Data/BT_Skills.rvdata")
    $data_items         = load_data("Data/BT_Items.rvdata")
    $data_weapons       = load_data("Data/BT_Weapons.rvdata")
    $data_armors        = load_data("Data/BT_Armors.rvdata")
    $data_enemies       = load_data("Data/BT_Enemies.rvdata")
    $data_troops        = load_data("Data/BT_Troops.rvdata")
    $data_states        = load_data("Data/BT_States.rvdata")
    $data_animations    = load_data("Data/BT_Animations.rvdata")
    $data_common_events = load_data("Data/BT_CommonEvents.rvdata")
    $data_system        = load_data("Data/BT_System.rvdata")
  end
  #--------------------------------------------------------------------------
  # ● 各種ゲームオブジェクトの作成
  #--------------------------------------------------------------------------
  def create_game_objects
    $game_temp          = Game_Temp.new
    $game_message       = Game_Message.new
    $game_system        = Game_System.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
  end
  #--------------------------------------------------------------------------
  # ● コンティニュー有効判定
  #--------------------------------------------------------------------------
  def check_continue
    @continue_enabled = (Dir.glob('Save*.rvdata').size > 0)
  end
  #--------------------------------------------------------------------------
  # ● タイトルグラフィックの作成
  #--------------------------------------------------------------------------
  def create_title_graphic
    @sprite = Sprite.new
    
    case $game_progress #オープニング
    
    when 0
      @sprite.bitmap = Cache.system("Title")
    when 1
      
      if $op_change == 4 #外伝バーダック一味編
        $z2opchano = rand(4) if $z2opchano == nil
        @sprite.bitmap = Cache.system("Title2_"+ $z2opchano.to_s)
      else
        @sprite.bitmap = Cache.system("Title2")
      end
    when 2
      if $op_change == 1
        #セル完全体になるまで
        @sprite.bitmap = Cache.system("Title3_2")
      elsif  $op_change == 2
        #セル完全体後
        @sprite.bitmap = Cache.system("Title3_3")
      elsif  $op_change == 3
        #クリア後
        @sprite.bitmap = Cache.system("Title3_4")
      elsif  $op_change == 4
        #クリア後 ZGバーダック一味編
        @sprite.bitmap = Cache.system("Title2")
      elsif  $op_change == 5
        #クリア後 ZG本編
        @sprite.bitmap = Cache.system("TitleG")
      else
        @sprite.bitmap = Cache.system("Title3")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● タイトルグラフィックの解放
  #--------------------------------------------------------------------------
  def dispose_title_graphic
    if @sprite != nil
      @sprite.bitmap.dispose
      @sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_command_window
    s1 = Vocab::new_game
    s2 = Vocab::continue
    s3 = Vocab::shutdown
    s4 = "オプション"
    @command_window = Window_Command.new(172, [s1, s2, s4, s3])
    @command_window.back_opacity=255
    @command_window.x = (640 - @command_window.width) / 2
    @command_window.y = 350 - 16
    if @continue_enabled                    # コンティニューが有効な場合
      @command_window.index = 1             # カーソルを合わせる
    else                                    # 無効な場合
      @command_window.draw_item(1, false)   # コマンドを半透明表示にする
    end
    @command_window.openness = 0
    @command_window.open
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの解放
  #--------------------------------------------------------------------------
  def dispose_command_window
    @command_window.dispose if @command_window != nil
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウを開く
  #--------------------------------------------------------------------------
  def open_command_window
    @command_window.open
    begin
      @command_window.update
      Graphics.update
    end until @command_window.openness == 255
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウを閉じる
  #--------------------------------------------------------------------------
  def close_command_window
    @command_window.close
    begin
      @command_window.update
      Graphics.update
    end until @command_window.openness == 0
  end
  #--------------------------------------------------------------------------
  # ● タイトル画面の音楽演奏
  #--------------------------------------------------------------------------
  def play_title_music
    #$data_system.title_bgm.play
    case $game_progress #オープニング
    
    when 0
      Audio.bgm_play("Audio/BGM/" + "Z1 オープニング")    # 効果音を再生する
    when 1
      Audio.bgm_play("Audio/BGM/" + "Z2 オープニング")    # 効果音を再生する
    when 2
      if $op_change == 1 || $op_change == 2 || $op_change == 3
        Audio.bgm_play("Audio/BGM/" +"ZD オープニング")
      elsif $op_change == 5
        Audio.bgm_play("Audio/BGM/" +"ZG オープニング")
      else
        Audio.bgm_play("Audio/BGM/" + "Z3 オープニング")    # 効果音を再生する
      end
    end
    #RPG::BGS.stop
    #RPG::ME.stop
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーの初期位置存在チェック
  #--------------------------------------------------------------------------
  def confirm_player_location
    if $data_system.start_map_id == 0
      print "プレイヤーの初期位置が設定されていません。"
      exit
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド : ニューゲーム
  #--------------------------------------------------------------------------
  def command_new_game
    confirm_player_location
    Sound.play_decision
    set_start_val
    set_start_val 3 #MAXLVセット
    $game_party.setup_starting_members            # 初期パーティ
    $game_map.setup($data_system.start_map_id)    # 初期位置のマップ
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    $game_player.refresh
    
    #普通に遊ぶ場合こちらを有効に
    $scene = Scene_Map.new
    
    #敵のパラメータ取得
    KGC::LimitBreak.set_enemy_parameters
    KGC::LimitBreak.revise_enemy_parameters
    
    RPG::BGM.fade(1500)
    close_command_window
    Graphics.fadeout(60)
    Graphics.wait(40)
    Graphics.frame_count = 0
    RPG::BGM.stop
    
    $game_variables[266] = 150
    for x in 1..$zp.size
      $zp[x] = 0 if $zp[x] == nil
      $runzp[x] = 0 if $runzp[x] == nil
      
      $zp[x] += $runzp[x] * $game_variables[266]
    end
      
    $game_map.autoplay
  end
  #--------------------------------------------------------------------------
  # ● コマンド : コンティニュー
  #--------------------------------------------------------------------------
  def command_continue
    if @continue_enabled
      Sound.play_decision
      $scene = Scene_File.new(false, true, false)
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド : オプション
  #--------------------------------------------------------------------------
  def command_option
      Sound.play_decision
      $scene = Scene_Db_Option.new 9
      Graphics.fadeout(5)
  end
  #--------------------------------------------------------------------------
  # ● コマンド : シャットダウン
  #--------------------------------------------------------------------------
  def command_shutdown
    Sound.play_decision
    RPG::BGM.fade(800)
    RPG::BGS.fade(800)
    RPG::ME.fade(800)
    $scene = nil
  end
  #--------------------------------------------------------------------------
  # ● 戦闘テスト
  #--------------------------------------------------------------------------
  def battle_test
    load_bt_database                  # 戦闘テスト用データベースをロード
    create_game_objects               # ゲームオブジェクトを作成
    Graphics.frame_count = 0          # プレイ時間を初期化
    $game_party.setup_battle_test_members
    $game_troop.setup($data_system.test_troop_id)
    $game_troop.can_escape = true
    $game_system.battle_bgm.play
    snapshot_for_background
    $scene = Scene_Battle.new
  end
end
