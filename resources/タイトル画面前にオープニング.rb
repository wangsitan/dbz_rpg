#
#    タイトル画面の前にマップ画面(RGSS2)
#　　(C)2007 TYPE74RX-T
#

# ※：カスタマイズポイント…15～18行目

#==============================================================================
# ★ RX_T
#------------------------------------------------------------------------------
# 　素材用汎用モジュールです。
#==============================================================================

include Db_Battle_Anime_test_Setup
module RX_T

  RX_StartingMapID = 6          # 開始時のマップ ID
  RX_SetupStartingMember = true # 初期パーティーをセットするか否か（※１）
  RX_Party_Members = [1]        # 初期のパーティーメンバー（※２）
  RX_LocationXY = [7, 6]        # パーティーの初期位置（※３）
end


# タイトルに突入する前にマップ画面に行くフラグ。
ini = Ini_File.new("game.ini")
$op_cut = (ini.get_profile("Game","Op_Cut")).to_i

chk_battle_test #戦闘テストスイッチがONか

if $op_cut == 0 && $battle_test_flag == false #OPカットするかどうか
  $rx_top_event_before_title = true
else
  $rx_top_event_before_title = false
end

#==============================================================================
# ※１：true ：RX_Party_Membersで設定したメンバーをセットアップする。
#       false：無人でマップ画面へ。RX_Party_Membersは設定しなくて良い。
#==============================================================================
# ※２：データベースで決めた初期パーティーとは別に初期パーティーを決められる。
#       RX_Party_Membersを２人以上にしたい場合は、以下のように数を増やす。
#　　 　例：[2, 4]（二人）、[1, 5, 2]（三人）、[1, 2, 3, 4]（四人）
#==============================================================================
# ※３：デフォルト（[7, 6]）のうち、7 と記述しているのが X 座標。
#       　　　　　　　　　　　　　　6 と記述しているのが Y 座標。
#==============================================================================

#==============================================================================
# ■ Interpreter
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_System クラ
# スや Game_Event クラスの内部で使用されます。
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ★ 注釈
  #--------------------------------------------------------------------------
  alias rx_rgss2s1_command_108 command_108
  def command_108
    # メモに記入する
    if @parameters[0].include?("タイトルに戻る")
      $rx_top_event_before_title = false
      Sound.play_decision
      #RPG::BGM.fade(800)
      RPG::BGS.fade(800)
      RPG::ME.fade(800)
      
      $scene = Scene_Title.new
      Graphics.fadeout(60)
      # 継続（競合対策）
      return true
    end
    # メソッドを呼び戻す
    rx_rgss2s1_command_108
  end
end

#==============================================================================
# ■ Scene_Title
#------------------------------------------------------------------------------
# 　タイトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias rx_rgss2s1_start start
  def start
    
    if $rx_top_event_before_title
      load_database                     # データベースをロード
      create_game_objects               # ゲームオブジェクトを作成
      rx_command_new_game_before_title  # ★ ニューゲームに直行
      return
    end
    # メソッドを呼び戻す
    rx_rgss2s1_start
  end
  #--------------------------------------------------------------------------
  # ● 開始後処理
  #--------------------------------------------------------------------------
  alias rx_rgss2s1_post_start post_start
  def post_start
    if $rx_top_event_before_title
      return
    end
    # メソッドを呼び戻す
    rx_rgss2s1_post_start
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias rx_rgss2s1_update update
  def update
    if $rx_top_event_before_title
      return
    end
    # メソッドを呼び戻す
    rx_rgss2s1_update
  end
  #--------------------------------------------------------------------------
  # ★ コマンド : ニューゲーム（直行用）
  #--------------------------------------------------------------------------
  def rx_command_new_game_before_title
    confirm_player_location
    if RX_T::RX_SetupStartingMember
      $data_system.party_members = RX_T::RX_Party_Members
      $game_party.setup_starting_members            # 初期パーティ
    end
    $game_map.setup(RX_T::RX_StartingMapID)    # 初期位置のマップ
    $game_player.moveto(RX_T::RX_LocationXY[0], RX_T::RX_LocationXY[1])
    $game_player.refresh
    $scene = Scene_Map.new
    Graphics.frame_count = 0
    $game_map.autoplay
  end
  #--------------------------------------------------------------------------
  # ● タイトルグラフィックの解放
  #--------------------------------------------------------------------------
  alias rx_rgss2s1_dispose_title_graphic dispose_title_graphic
  def dispose_title_graphic
    if $rx_top_event_before_title
      return
    end
    # メソッドを呼び戻す
    rx_rgss2s1_dispose_title_graphic
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの解放
  #--------------------------------------------------------------------------
  alias rx_rgss2s1_dispose_command_window dispose_command_window
  def dispose_command_window
    if $rx_top_event_before_title
      return
    end
    # メソッドを呼び戻す
    rx_rgss2s1_dispose_command_window
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウを閉じる
  #--------------------------------------------------------------------------
  alias rx_rgss2s1_close_command_window close_command_window
  def close_command_window
    if $rx_top_event_before_title
      return
    end
    # メソッドを呼び戻す
    rx_rgss2s1_close_command_window
  end
end
