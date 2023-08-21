class Scene_Dragon_Radar < Scene_Base

  RADAR_X =264
  RADAR_Y =14
  RADAR_SIZE_SENTER_X =51
  RADAR_SIZE_SENTER_Y =55
  GET_SCOPE = 25
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
    Audio.bgm_play("Audio/BGM/" +"Z2 ドラゴンレーダー")    # 効果音を再生する
    @radar_rate = 1
    @radar_gra_mode = 0
    @back_window = Window_Base.new(-16,-16,672,512)
    @back_window.opacity=0
    @back_window.back_opacity=0
    create_background
    @main_window = Window_Base.new(-16,320,672,176)
    @main_window.opacity=0
    @main_window.back_opacity=0

    my_update
    Graphics.fadein(5)
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_window
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------   
  def dispose_window
    @main_window.dispose
    @main_window = nil
    @back_window.dispose
    @back_window = nil
  end 
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------   
  def my_update
    @main_window.contents.clear
    output_back
    output_radar
    output_ball
    @main_window.update
    Input.update
    Graphics.update
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update

    begin
      result = 0
      
      
      
      begin
        my_update
        
        if Input.trigger?(Input::C)
          Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
          result = 1
          @radar_gra_mode += 1 
          my_update
          Graphics.wait(10)
          @radar_gra_mode += 1 
          @radar_rate += 1
          if @radar_gra_mode == 6
            @radar_gra_mode = 0
            @radar_rate = 1
          end
        end
        
        if Input.trigger?(Input::B)
          result = 2
        end
      end while result == 0

    end while result != 2
    Graphics.fadeout(5)
    @main_window.contents.clear
    Audio.bgm_play("Audio/BGM/" + $map_bgm)    # 効果音を再生する
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # ● ドラゴンレーダー出力
  #--------------------------------------------------------------------------  
  def output_radar
    picture = Cache.picture("ドラゴンレーダー")
    rect = Rect.new(0, @radar_gra_mode*116, 116, 116) # スクロール背景
    @main_window.contents.blt(RADAR_X,RADAR_Y,picture,rect)
  end
  #--------------------------------------------------------------------------
  # ● ドラゴンボール出力
  #--------------------------------------------------------------------------  
  def output_ball
    for x in 1..$game_map.events.size
      #p $game_map.events[x].x,$game_map.events[x].y,$game_map.events[x].walk_anime
      if $game_map.events[x] != nil
        if $game_map.events[x].walk_anime == true
          plaxy = 0
          if $game_map.events[x].x-$game_player.x < 0
            plaxy = -($game_map.events[x].x-$game_player.x)
          else
            plaxy = ($game_map.events[x].x-$game_player.x)
          end
          
          if $game_map.events[x].y-$game_player.y < 0
            plaxy += -($game_map.events[x].y-$game_player.y)
          else
            plaxy += ($game_map.events[x].y-$game_player.y)
          end
          
          if plaxy < GET_SCOPE * @radar_rate
            picture = Cache.picture("ドラゴンレーダー_ドラゴンボール")
            rect = Rect.new(0, 0*8, 8, 8) # スクロール背景
            @main_window.contents.blt(RADAR_X+RADAR_SIZE_SENTER_X+($game_map.events[x].x-$game_player.x)*2/@radar_rate,RADAR_Y+RADAR_SIZE_SENTER_Y+($game_map.events[x].y-$game_player.y)*2/@radar_rate,picture,rect)
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 背景出力
  #--------------------------------------------------------------------------  
  def output_back
    #color = Color.new(128,0,255)
    color = Color.new(0,0,0,255)
    @main_window.contents.fill_rect(0,0,640,200,color)
    #@main_window.contents.fill_rect(RADAR_X,320,656,200,color)
  end
  #--------------------------------------------------------------------------
  # ● メニュー画面系の背景作成
  #--------------------------------------------------------------------------
  def create_background
    rect = Rect.new(0, 0, 640,480)
    @back_window.contents.blt(0,0,$background_bitmap,rect)
  end
end