#==============================================================================
# ■ Scene_Map
#------------------------------------------------------------------------------
# 　マップ画面の処理を行うクラスです。
#==============================================================================

class Scene_Map2 < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    Graphics.fadein(5)
    $game_map.refresh
    @spriteset = Spriteset_Map.new
    @message_window = Window_Message.new
    
#=============================================================================
    @player = Sprite.new
    @player.bitmap = Cache.picture("人") 
    #原点を画像の中心に設定
    @player.ox = @player.bitmap.width
    @player.oy = @player.bitmap.height
    @scroll_x = 20
    @move_x = 4
    @move_y = 10
    #@player.x = 320
    #$game_map.refresh
    #@spriteset = Spriteset_Map.new
    #$game_map.setup(4)
    #$game_map.set_display_pos(0,0)
#=============================================================================

  end
  #--------------------------------------------------------------------------
  # ● トランジション実行
  #--------------------------------------------------------------------------
  def perform_transition
    if Graphics.brightness == 0       # 戦闘後、ロード直後など
      fadein(30)
    else                              # メニューからの復帰など
      Graphics.transition(15)
      @player.x = 20
    end
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    if $scene.is_a?(Scene_Battle)     # バトル画面に切り替え中の場合
      @spriteset.dispose_characters   # 背景作成のためにキャラを隠す
    end
    snapshot_for_background
    @spriteset.dispose
    @message_window.dispose
    if $scene.is_a?(Scene_Battle)     # バトル画面に切り替え中の場合
      perform_battle_transition       # 戦闘前トランジション実行
    end
  end
  #--------------------------------------------------------------------------
  # ● 基本更新処理
  #--------------------------------------------------------------------------
  def update_basic

    Graphics.update                   # ゲーム画面を更新
    Input.update                      # 入力情報を更新
    $game_map.update                  # マップを更新
    @spriteset.update                 # スプライトセットを更新

  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    $game_map.interpreter.update      # インタプリタを更新
    $game_map.update                  # マップを更新
    #$game_player.update               # プレイヤーを更新
    $game_system.update               # タイマーを更新
    @spriteset.update                 # スプライトセットを更新
    @message_window.update            # メッセージウィンドウを更新


  if Input.press?(Input::C)
    x = (@player.x/32).to_i
    y = ((@player.y - @move_y-32)/32).to_i
    if $game_map.passable? (x,y) == true
      @player.y -= @move_y #if Input.press?(Input::UP)
    end
  else
    x = ((@player.x-31)/32).to_i
    y = ((@player.y + @move_y)/32).to_i
    if $game_map.passable? (x,y) == true
      @player.y += @move_y #if Input.press?(Input::DOWN)
    end
  end
  if Input.press?(Input::B)
    if Input.press?(Input::LEFT)
      $game_map.scroll_left @scroll_x +15
    elsif Input.press?(Input::RIGHT)
      $game_map.scroll_right @scroll_x +15
    end
  else
    
    if Input.press?(Input::LEFT)
      x = ((@player.x - @move_x)/32).to_i
      y = (@player.y/32).to_i
      if $game_map.passable? (x,y) == true
        @player.x -= @move_x
      end
    elsif Input.press?(Input::RIGHT)
      x = ((@player.x + @move_x)/32).to_i
      y = (@player.y/32).to_i
      if $game_map.passable? (x,y) == true
        if @player.x >= 320
          @player.x = 320
          $game_map.scroll_right @scroll_x
        else
          @player.x += @move_x
        end
      end
    end
  end
  
  #画面外に出たら座標を画面内に強制する
  @player.x = 640 if @player.x > 640
  @player.x = 0 if @player.x < 0
  @player.y = 480 if @player.y > 480
  @player.y = 0 if @player.y < 0
  end


end
