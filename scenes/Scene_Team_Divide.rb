#==============================================================================
# ■ Scene_Team_Divide
#------------------------------------------------------------------------------
# 　チーム分け
#==============================================================================
class Scene_Team_Divide < Scene_Base

  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize()
    @main_window = Window_Base.new(-16,-16,672,512)
    @main_window.opacity=0
    @main_window.back_opacity=0


  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------   
  def dispose_window
    if @main_window != nil
      @main_window.dispose
      @main_window = nil
    end
    
    if @divide_window != nil
      @divide_window.dispose
      @divide_window = nil
    end
  end 
  #--------------------------------------------------------------------------
  # ● 味方側顔表示(パーティーにいる全員を中心から均等に表示する)
  #    dying_flag
  #-------------------------------------------------------------------------- 
  def character_output(dying_flag = 0)
    #picture = Cache.picture("Z1_顔味方")
    for x in 0..$partyc.size - 1
      if @chara_select[x] == false
        rect,picture = set_character_face dying_flag,$partyc[x]-3
        #rect = Rect.new(0, 64*($partyc[x]-3), 64, 64) # 味方顔
        @main_window.contents.blt(@play_x - 32 * ($partyc.size - 1) + 64 * x,@play_y,picture,rect)
      end
    end    
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    Graphics.fadein(0)
    #@message_window = Window_Message.new
    #@msg_output_end = false
    #メッセージ表示
    #text_list=[]
    #text = nil
    #x = 0
    #if @msg_output_end == false
    #  text.each_line {|line| #改行を読み取り複数行表示する
    #    line.sub!("￥n", "") # ￥は半角に直す
    #    line = line.gsub("\r", "")#改行コード？が文字化けするので削除
    #    line = line.gsub("\n", "")#
    #    line = line.gsub(" ", "")#半角スペースも削除
    #    text_list[x]=line
    #    x += 1
    #    }
    #    put_message text_list
    #    @msg_output_end = true
    #end
    $CursorState = 0
    @z1_scenex = 224           #上背景位置X
    @z1_sceney = 46            #上背景位置Y
    @ene1_x = @z1_scenex + 64 #上キャラ表示基準位置X
    @ene1_y = @z1_sceney + 32 #上キャラ表示基準位置Y
    @play_x = @z1_scenex + 64 #下キャラ(味方)表示基準位置X
    @play_y = @z1_scenex + 82 #下キャラ(味方)表示基準位置Y
    @chara_select = [false,false,false,false,false,false]
    @chara_map = [1,1,1,1,1,1]
    $game_actors[1].name = "" #キャラの名前初期化
    @divide_window = Window_Base.new(128,120,384,160)
    @divide_window.opacity=255
    @divide_window.back_opacity=255
    @divide_window.contents.font.color.set( 0, 0, 0)
    @window_state = 0
    #@divide_window.contents.font.shadow = false
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_window
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    @main_window.contents.clear
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)  
    picture = Cache.picture("Z1_顔イベント")
    rect = Rect.new(0, 64*8, 64, 64) # カリン様
    @main_window.contents.blt(@ene1_x,@ene1_y-44,picture,rect)
    character_output
    output_divide_window
    output_cursor
    
    
    if @window_state == 0
      if Input.trigger?(Input::B)
        if @chara_map.index(1) >= 1 
          @chara_select[@chara_map[@chara_map.index(1)-1]-4] = false
          @chara_map[@chara_map.index(1)-1] = 1
        end
      end  

      if Input.trigger?(Input::C)
        Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
        @chara_map[@chara_map.index(1)] = $partyc[$CursorState]
        @chara_select[$CursorState] = true
        
        if @chara_select.index(false) != nil
          $CursorState = chk_select_cursor_control($CursorState,0,0,$partyc.size - 1)
        else
          $CursorState = 0
          @window_state = 1
        end
      end
      
      if Input.trigger?(Input::RIGHT)
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        $CursorState = chk_select_cursor_control($CursorState,1,0,$partyc.size - 1)
      end
      if Input.trigger?(Input::LEFT)
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        $CursorState = chk_select_cursor_control($CursorState,2,0,$partyc.size - 1)
      end
    else
      
      if Input.trigger?(Input::C)
        Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する

        if $CursorState == 0
          
          for x in 0..5
            $game_variables[45+x] = @chara_map[x]
          end
          #p $game_variables[41]
          $scene = Scene_Map.new
          #p $game_message.busy
          #$game_message.clear
        else
          @chara_select[@chara_map[5]-4] = false
          @chara_map[5] = 1
          $CursorState = chk_select_cursor_control($CursorState,0,0,$partyc.size - 1)
          @window_state = 0
        end
      end
      
      if Input.trigger?(Input::B)
        @chara_select[@chara_map[5]-4] = false
        @chara_map[5] = 1
        $CursorState = chk_select_cursor_control($CursorState,0,0,$partyc.size - 1)
        @window_state = 0
      end 
      
      if Input.trigger?(Input::RIGHT) || Input.trigger?(Input::LEFT)
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $CursorState == 0
          $CursorState = 1
        else
          $CursorState = 0
        end
      end
    end
    #@message_window.update            # メッセージウィンドウを更新
  end
  #--------------------------------------------------------------------------
  # ● チーム分けウインドウ表示
  #--------------------------------------------------------------------------  
  def output_divide_window
    @divide_window.contents.clear
    #説明表示
    text = 
    "誰と　誰が　コンビを組むんじゃ？" + "\n" +
    "北・・・" + $game_actors[@chara_map[0]].name + "," + $game_actors[@chara_map[1]].name + "\n" +
    "東・・・" + $game_actors[@chara_map[2]].name + "," + $game_actors[@chara_map[3]].name + "\n" +
    "西・・・" + $game_actors[@chara_map[4]].name + "," + $game_actors[@chara_map[5]].name
    
    if @chara_select.index(false) == nil
      text += "\n" + "これでいいんじゃな　　はい　　いいえ"
    end
      
    y = 0
    text.each_line {|line| #改行を読み取り複数行表示する
      line.sub!("￥n", "") # ￥は半角に直す
      line = line.gsub("\r", "")#改行コード？が文字化けするので削除
      line = line.gsub("\n", "")#
      line = line.gsub(" ","")
      @divide_window.contents.draw_text(0,y, 350, 30, line)
      y += 25
      }
    
  end
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------  
  def output_cursor
    if @window_state == 0
      # メニューカーソル表示
      picture = Cache.picture("アイコン")
      rect = set_tate_cursor_blink # カーソル格納
      @main_window.contents.blt(@play_x-136+$CursorState*64,5+@play_y-22,picture,rect)
    end
    
    if @window_state == 1
      # メニューカーソル表示
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink # カーソル格納
      @divide_window.contents.blt(182+$CursorState*72,107,picture,rect)
    end
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
  #--------------------------------------------------------------------------
  # ● カーソル数値の最適化
  #--------------------------------------------------------------------------   
  # x:対象の値 ,n:チェック種類 ,min左最小 ,max右最大
  # n:0:その場 1:右へ 2:左へ
  # rubyの使用が参照渡しのようなので年のためxをyへ格納する
  def chk_select_cursor_control(x,n,min,max)
    
    y = x
    if n == 1 then #右ならx+1 左ならx-1
      y += 1
    elsif n == 2 then
      y -= 1
    end
    
    
    if y > max then #xがmaxより大きければ一番左へminより小さければ右へ
      y = min 
    elsif x < min then
      y = max
    end
    while y <= max do

      if y > max then
        y = min 
      elsif y < min then
        y = max
      end 

      if @chara_select[y] == false then
        return y
      end    

      if n <= 1 then
        y += 1
      elsif n == 2 then
        y -= 1
      end
      
      if y > max then
        y = min 
      elsif y < min then
        y = max
      end      
    end
  end
end