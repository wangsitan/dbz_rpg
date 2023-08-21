#==============================================================================
# ■ Scene_Story_So_Far
#------------------------------------------------------------------------------
# 　あらすじ表示
#==============================================================================
class Scene_Db_Snake_Road < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize()

  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    Graphics.fadein(0)
    @player = Sprite.new
    @player.bitmap = Cache.picture("人") 
    #原点を画像の中心に設定
    @player.ox = @player.bitmap.width / 2
    @player.oy = @player.bitmap.height / 2
    @move_x = 3
    @move_y = 10
    $game_map.refresh
    @spriteset = Spriteset_Map.new
    $game_map.setup(4)
    $game_map.set_display_pos(0,0)
    p $game_map.data
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super

  end
  #--------------------------------------------------------------------------
  # ● 基本更新処理
  #--------------------------------------------------------------------------
  def update_basic

    #Graphics.update                   # ゲーム画面を更新
    #Input.update                      # 入力情報を更新
    $game_map.update                  # マップを更新
    @spriteset.update                 # スプライトセットを更新

  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    update_basic
    $game_map.interpreter.update      # インタプリタを更新
    #$game_map.update                  # マップを更新
    $game_map.setup_scroll
  if Input.press?(Input::C)
    @player.y -= @move_y #if Input.press?(Input::UP)
  else
    @player.y += @move_y #if Input.press?(Input::DOWN)
  end
  if Input.press?(Input::B)
    @player.x -= @move_x*2 if Input.press?(Input::LEFT)
    @player.x += @move_x*2 if Input.press?(Input::RIGHT)
  else
    @player.x -= @move_x if Input.press?(Input::LEFT)
    @player.x += @move_x if Input.press?(Input::RIGHT)
  end
  #画面外に出たら座標を画面内に強制する
  @player.x = 640 if @player.x > 640
  @player.x = 0 if @player.x < 0
  @player.y = 480 if @player.y > 480
  @player.y = 0 if @player.y < 0

    #@message_window.update            # メッセージウィンドウを更新
  end
  #--------------------------------------------------------------------------
  # ● 文章の表示
  #引数：[text:表示内容,position:ウインドウ表示位置]
  #--------------------------------------------------------------------------
  def put_message text,position = 1
    unless $game_message.busy
      #$game_message.face_name = ""
      #$game_message.face_index = 0
      #$game_message.background = 0         #背景 0:通常 1:背景暗く 2:透明
      $game_message.position = position
      for x in 0..text.size - 1 
        $game_message.texts.push(text[x])
      end
      set_message_waiting                   # メッセージ待機状態にする
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● メッセージ待機中フラグおよびコールバックの設定
  #--------------------------------------------------------------------------
  def set_message_waiting
    @message_waiting = true
    $game_message.main_proc = Proc.new { @message_waiting = false }
  end
end