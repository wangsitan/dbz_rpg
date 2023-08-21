#==============================================================================
# ■ Game_Temp
#------------------------------------------------------------------------------
# 　セーブデータに含まれない、一時的なデータを扱うクラスです。このクラスのイン
# スタンスは $game_temp で参照されます。
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :tboss_p_name            # プレイヤーキャラのファイル名
  attr_accessor :tboss_p_index           # プレイヤーキャラの画像インデックス
  attr_accessor :tboss_bgm               # ゲームで使用するBGM
  attr_accessor :tboss_ground            # ゲームで使用する背景
  attr_accessor :tboss_life              # 初期ライフ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias tboss_game_temp_initialize initialize
  def initialize
    tboss_game_temp_initialize
    @tboss_p_name = "Actor1"
    @tboss_p_index = 0
    @tboss_bgm = "Audio/BGM/GBZ2 ミニゲーム2.OGG"
    @tboss_ground = "Graphic/System/Z2_シューティング背景.png"
    @tboss_life = 30
    $shoot_player_x = 0
    $shoot_player_y = 0
    $shoot_enemy_x = 0
    $shoot_enemy_y = 0
    $shoot_damege_count = 0
    $shoot_end = false
    $shoot_enemy_state = 0
  end
end
