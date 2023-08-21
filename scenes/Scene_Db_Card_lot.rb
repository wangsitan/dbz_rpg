#==============================================================================
# ■ Scene_Db_Card_lot
#------------------------------------------------------------------------------
# 　お助けカードくじ
#==============================================================================
class Scene_Db_Card_lot < Scene_Base
  include Icon
  include Share
  CARD_STANDARD_X = 128 #カード開始基準位置X
  CARD_STANDARD_Y = 72  #カード開始基準位置Y

  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize()
    @main_window = Window_Base.new(-16,-16,672,512)
    @main_window.opacity=0
    @main_window.back_opacity=0

  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super

    #Graphics.fadein(5)
    #$game_variables[38] = 1
    Audio.bgm_play("Audio/BGM/" + "Z1 ミニゲーム")    # 効果音を再生する
    @message_window = Window_Message.new
    @card_id1 = create_get_card($game_variables[44]) #取得カード生成
    @card_id2 = create_get_card($game_variables[44]) #取得カード生成

    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    @msg_output_end = false #メッセージを見終わったかフラグ
    @card_state = 0         #選択カード位置
    @cursor_state = 0       #カーソル位置
    @hide_card=[]           #くじのカードid
    @open_hide_card=[]      #カードを開いたかフラグ
    @old_open_card = nil    #1つ前に開いたカードid
    @result = 0             #結果
    @msg_cursor = Sprite.new
    @msg_cursor.bitmap = Cache.picture("アイコン")
    @msg_cursor.visible = false
    @msg_cursor.src_rect = set_tate_cursor_blink
    @msg_cursor.x = 320-8
    @msg_cursor.y = 480 -16#-14
    @msg_cursor.z = 255
    for x in 0..5           #くじのカードidを格納
      @open_hide_card[x] = false
      y = rand(2)
      if y == 0 
        @hide_card[x] = @card_id1
      else
        @hide_card[x] = @card_id2
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_sprite
    dispose_window
    $game_variables[44] = 0
  end
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------  
  def pre_update
    @main_window.contents.clear
    

    
    #メッセージウインドウ作成
    if $game_message.busy == false && @msg_window  == nil && @card_state > 0
      create_msg_window
    end
    
    #メッセージ表示
    if $game_message.busy == false && @msg_window  != nil
      @msg_window.contents.clear
      output_msg
    end
    
    output_msgcursor if @msg_cursor.visible == true
    #カードアイコン表示
    output_card_icon
    
    #カーソル表示
    output_cursor
  end
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ作成
  #--------------------------------------------------------------------------   
  def create_msg_window
    @msg_window = Window_Base.new(0,480-128,640,128)
    @msg_window.opacity=255
    @msg_window.back_opacity=255
    @msg_window.contents.font.color.set( 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------   
  def dispose_window
    @main_window.dispose
    @main_window = nil
    @msg_window.dispose
    @msg_window = nil
    @message_window.dispose
    @message_window = nil
  end 
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    pre_update
    
    if @card_state == 0 #メッセージ表示
      text_list=[]  
      text = nil
      x = 0
      text =
      "お助けカードが　当たる　スピードくじだ！
      左から１枚ずつ　カードをめくって
      ２枚　揃えば　当たり！　３枚　揃えば　大当たり！
      当たり　回数に応じて　お助けカードが　貰えるぞ！"
      #メッセージ表示
      if @msg_output_end == false
        text.each_line {|line| #改行を読み取り複数行表示する
          line.sub!("￥n", "") # ￥は半角に直す
          line = line.gsub("\r", "")#改行コード？が文字化けするので削除
          line = line.gsub("\n", "")#
          line = line.gsub(" ", "")#半角スペースも削除
          text_list[x]=line
          x += 1
          }
          put_message text_list,2
          @msg_output_end = true
          @card_state = 1
      end
    end
    
    if Input.trigger?(Input::B)
        
    end  

    if Input.trigger?(Input::C)
      if $game_message.busy == false && @card_state > 0
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        @msg_window.contents.clear
        @main_window.contents.clear
        if @card_state == 1
          if @cursor_state == 0
            x = 0
          else
            x = 3
          end

        elsif @card_state == 2
          if @cursor_state == 0
            x = 1
          else
            x = 4
          end
        elsif @card_state == 3
          if @cursor_state == 0
            x = 2
          else
            x = 5
          end
        end
        @open_hide_card[x] = true
        
        @msg_window.contents.draw_text(0,0, 600, 30, $data_items[@hide_card[x].to_i].name)
        @cursor_state = 0
        @card_state += 1
        output_card_icon
        @main_window.update
        @msg_window.update
        Graphics.wait(60)
        @msg_window.contents.clear
        if @card_state >= 3 && @old_open_card == $data_items[@hide_card[x].to_i].id
          @old_open_card = $data_items[@hide_card[x].to_i].id
          if @card_state == 4
            @msg_window.contents.draw_text(0,0, 600, 30, "大当たりー！")
            @msg_window.contents.draw_text(0,30, 600, 30, $data_items[@hide_card[x].to_i].name + "を　２枚　手に入れた！")
            Audio.se_play("Audio/SE/" + "Z1 ピンポン")    # 効果音を再生する
            Graphics.wait(30)
            Audio.se_play("Audio/SE/" + "Z1 ピンポン")    # 効果音を再生する
            $game_party.gain_item ($data_items[@old_open_card], 2) #カード増やす
            @result = 1
            if $game_variables[38] == 0
              Graphics.wait(60)
            else
              @msg_cursor.visible = true
              input_loop_run
              Graphics.wait(5)
            end
          end
        elsif @card_state >= 3 && @old_open_card != $data_items[@hide_card[x].to_i].id
          
          
          if @card_state == 3
            Audio.se_play("Audio/SE/" + "Z1 ブザー")    # 効果音を再生する
            @msg_window.contents.draw_text(0,0, 600, 30, "ハズレー！")
            
          else
            Audio.se_play("Audio/SE/" + "Z1 ピンポン")
            @msg_window.contents.draw_text(0,0, 600, 30, "当たりー！")
            @msg_window.contents.draw_text(0,30, 600, 30, $data_items[@old_open_card].name + "を　１枚　手に入れた！")
            $game_party.gain_item ($data_items[@old_open_card], 1) #カード増やす
          end
          
          @result = 1
          if $game_variables[38] == 0
            Graphics.wait(60)
          else
            @msg_cursor.visible = true
            input_loop_run
            Graphics.wait(5)
          end
        end
        @old_open_card = $data_items[@hide_card[x].to_i].id
      end
    end
    
    if Input.trigger?(Input::DOWN)
      if $game_message.busy == false
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @cursor_state +=1 
        if @cursor_state > 1
          @cursor_state =0
        end
      end
    end
    if Input.trigger?(Input::UP)
      if $game_message.busy == false
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @cursor_state -=1
        if @cursor_state < 0
          @cursor_state =1
        end
      end
    end
    if Input.trigger?(Input::RIGHT)

    end
    if Input.trigger?(Input::LEFT)

    end
    @main_window.update
    @message_window.update            # メッセージウィンドウを更新
  
    if @result != 0
      Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
      Graphics.fadeout(20)
      $game_variables[41] = 0       # 実行イベント初期化 
      $scene = Scene_Map.new
      $game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
    end
  end

  #--------------------------------------------------------------------------
  # ● カードアイコン表示
  #--------------------------------------------------------------------------
  def output_card_icon
    
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    color = Color.new(0,0,0,255)
    y = 0
    for x in 0..5
      @main_window.contents.fill_rect(CARD_STANDARD_X+160*x-y*480,CARD_STANDARD_Y+y*112,64 ,96,color)
      if x == 2 
        y += 1
      end
    end
    picture = Cache.picture("カードミニゲーム素材1")
    rect = Rect.new(0, 0, 96, 120) # イベント
    @main_window.contents.blt(CARD_STANDARD_X+64,CARD_STANDARD_Y+44,picture,rect)
    @main_window.contents.blt(CARD_STANDARD_X+224,CARD_STANDARD_Y+44,picture,rect)
    
    if $game_message.busy == false && @card_state > 0
    
      if @card_state > 0 then
        y = 0
        for x in 0..5
          picture = Cache.picture("カードミニゲーム素材1")
          rect = Rect.new(0, 120, 64, 96) # イベント
          @main_window.contents.blt(CARD_STANDARD_X+160*x-y*480,CARD_STANDARD_Y+y*112,picture,rect)
          picture = Cache.picture("カード関係")
          rect = set_card_frame 1
          @main_window.contents.blt(CARD_STANDARD_X+160*x-y*480,CARD_STANDARD_Y+y*112,picture,rect)
          if x == 2 
            y += 1
          end
        end
      end
      
      if @card_state >= 2 then
        picture = Cache.picture("顔カード")
        y = 0
        for x in 0..5
          if @open_hide_card[x] == true
            rect = put_icon @hide_card[x]
            @main_window.contents.blt(CARD_STANDARD_X+160*x-y*480,CARD_STANDARD_Y+y*112+16,picture,rect)

          end
          if x == 2 
            y += 1
          end
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● メッセージウインドウの表示
  #--------------------------------------------------------------------------
  def output_msg
    
    # メッセージ表示
    if @card_state == 1
      @msg_window.contents.draw_text(0,0, 600, 30, "どちらか　カードを　選びなさい！")
    elsif @card_state >= 2
      @msg_window.contents.draw_text(0,0, 600, 30, "次の　カードを　選びなさい！")
    end
  end
  
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------
  def output_cursor
    $cursor_blink_count += 1
    # メニューカーソル表示
    if $game_message.busy == false && @card_state > 0
      picture = Cache.picture("アイコン")
      rect = set_tate_cursor_blink
      @main_window.contents.blt(CARD_STANDARD_X+160*(@card_state-1)+2,CARD_STANDARD_Y+112*@cursor_state - 16,picture,rect)
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
  # ● お助けカード作成
  #--------------------------------------------------------------------------   
  def create_get_card_2
    
    case $game_variables[44] 
    
    when 0,10 #Z1ってことかも
      
      begin
        @card_id1 = rand(26) + 9 #ブルマからじいちゃんまで
        @card_id2 = rand(26) + 9
      end while @card_id1 == 16 || @card_id2 == 16 ||
      @card_id1 == 31 || @card_id2 == 31 ||
      @card_id1 == 33 || @card_id2 == 33 #デンデが出なくなるまで繰り返す
    when 1,2,20 #Z2ってことかも
      begin
        @card_id1 = rand(33) + 9 #ブルマからじいちゃんまで
        @card_id2 = rand(33) + 9
      end while @card_id1 == 16 || @card_id2 == 16 ||
      @card_id1 == 31 || @card_id2 == 31 ||
      @card_id1 == 33 || @card_id2 == 33 ||
      @card_id1 == 35 || @card_id2 == 35 ||
      @card_id1 == 36 || @card_id2 == 36 ||
      @card_id1 == 37 || @card_id2 == 37 ||
      @card_id1 == 38 || @card_id2 == 38 ||
      @card_id1 == 39 || @card_id2 == 39#デンデが出なくなるまで繰り返す
    end
  end
  #--------------------------------------------------------------------------
  # ● スプライト開放
  #--------------------------------------------------------------------------
  def dispose_sprite
    @msg_cursor.bitmap = nil
    @msg_cursor = nil
  end
  #--------------------------------------------------------------------------
  # ● カーソルの表示
  #--------------------------------------------------------------------------
  def output_msgcursor
    $cursor_blink_count += $msg_cursor_blink
    @msg_cursor.src_rect = set_tate_cursor_blink
  end
  #--------------------------------------------------------------------------
  # ● 決定ボタンが押されるまでループ
  #-------------------------------------------------------------------------- 
  def input_loop_run

    Graphics.update
    result = false
    begin
    $cursor_blink_count += $msg_cursor_blink
    @msg_cursor.src_rect = set_tate_cursor_blink
    Input.update
      if Input.trigger?(Input::C) 
        result = true
      end
      input_fast_fps
      Graphics.wait(1)
    end while result == false
    Input.update
  end
end