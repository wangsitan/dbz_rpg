#==============================================================================
# ■ Scene_Db_Card_Concentration
#------------------------------------------------------------------------------
# 　神経衰弱
#==============================================================================
class Scene_Db_Card_Concentration < Scene_Base
  include Icon
  include Share
  CARD_STANDARD_X = 15 #カード開始基準位置X
  CARD_STANDARD_Y = 192  #カード開始基準位置Y
  SCENEX = 224           #上背景位置X
  SCENEY = 46            #上背景位置Y
  ENE_X = SCENEX + 64 #上キャラ表示基準位置X
  ENE_Y = SCENEY + 32 #上キャラ表示基準位置Y
  ERR_NUM = 2             #何回外れたら終了するか？
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

    #$game_variables[38] = 1
    
    @main_window = Window_Base.new(-16,-16,672,512)
    @main_window.opacity=0
    @main_window.back_opacity=0
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    create_msg_window
    Audio.bgm_play("Audio/BGM/" + "DB3 ミニゲーム")    # 効果音を再生する

    @window_state = 0       #ウインドウ状態:[0:開始時 1:1枚目選択時 2:2枚目選択時 3:終了]
    @cursor_state = 0       #カーソル位置
    @hide_card=[]           #神経垂迹のカードid
    @open_hide_card=[false,false,false,false,false,false,false,false]      #カードを開いたかフラグ
    @visible_hide_card=[true,true,true,true,true,true,true,true]      #カードを取得フラグ
    @old_open_card = nil    #1つ前に開いたカードid
    @result = 0             #結果
    @card_id=[]             #取得カード4種類
    @get_card = []          #取得カードid
    @err_count = 0          #はずれカウント
    @card_id[0] = create_get_card($game_variables[44]) #取得カード生成
    @card_id[1] = create_get_card($game_variables[44]) #取得カード生成
    @card_id[2] = create_get_card($game_variables[44]) #取得カード生成
    @card_id[3] = create_get_card($game_variables[44]) #取得カード生成
    @msg_cursor = Sprite.new
    @msg_cursor.bitmap = Cache.picture("アイコン")
    @msg_cursor.visible = false
    @msg_cursor.src_rect = set_tate_cursor_blink
    @msg_cursor.x = 320-8
    @msg_cursor.y = 480 -16#-14
    @msg_cursor.z = 255
    for x in 0..3           #くじのカードidを格納
      z = 0
      begin
        y = rand(8)
        if @hide_card[y] == nil 
          @hide_card[y] = @card_id[x]
          z += 1
        end
      end while z != 2
      
    end
    Graphics.fadein(5)
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
    @msg_window.contents.clear
    
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    color = Color.new(0,0,0,255)
    
    picture = Cache.picture("顔カード")
    rect = Rect.new($game_variables[40]*64, 64*24, 64, 64) # 敵顔
    @main_window.contents.blt(ENE_X,ENE_Y,picture,rect)
    
    output_msg
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
  end 
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    pre_update
    
    
    if Input.trigger?(Input::B)
        
    end  

    if Input.trigger?(Input::C)
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      @open_hide_card[@cursor_state] = true
      
      if @old_open_card == nil
        @window_state = 1
        @old_open_card = @cursor_state
      else
        if $data_items[@hide_card[@old_open_card]].id == $data_items[@hide_card[@cursor_state]].id
          Audio.se_play("Audio/SE/" + "Z1 ピンポン")  # 効果音を再生する
          pre_update
          @main_window.update
          Graphics.wait(20)
          @visible_hide_card[@old_open_card] = false
          @visible_hide_card[@cursor_state] = false
          @old_open_card = nil
          @get_card << $data_items[@hide_card[@cursor_state]].id
          @window_state = 2
        else
          Audio.se_play("Audio/SE/" + "Z1 ブザー")    # 効果音を再生する
          @err_count += 1 
          @window_state = 4
          pre_update
          @main_window.update
          if $game_variables[38] == 0
            Graphics.wait(60)
          else
            @msg_cursor.visible = true
            input_loop_run
            @msg_cursor.visible = false if @err_count == 1
            Graphics.wait(5)
          end
          
          if @err_count < ERR_NUM
            @open_hide_card[@old_open_card] = false
            @open_hide_card[@cursor_state] = false
            @old_open_card = nil
            @window_state = 5
            pre_update
            @main_window.update
            
          end
          
        end
      end
      
      if @visible_hide_card.index(true) != nil
        @cursor_state =chk_select_cursor_control (0,0,0,7)
      else
        #全カード取得時のメッセージを表示
        @window_state = 3
        pre_update
        @main_window.update
        @msg_window.update
          if $game_variables[38] == 0
            Graphics.wait(60)
          else
            @msg_cursor.visible = true
            input_loop_run
            #@msg_cursor.visible = false
            Graphics.wait(5)
          end
      end

    end
    
    if Input.trigger?(Input::DOWN)

    end
    
    if Input.trigger?(Input::UP)

    end
    
    if Input.trigger?(Input::RIGHT)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      @cursor_state = chk_select_cursor_control (@cursor_state,1,0,7)
    end
    if Input.trigger?(Input::LEFT)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      @cursor_state = chk_select_cursor_control (@cursor_state,2,0,7)
    end
    @main_window.update
    @msg_window.update
    if @window_state == 3 || @window_state == 4 && @err_count >= ERR_NUM
      
      if @visible_hide_card.index(false) != nil
        get_item_card
        @main_window.update
          if $game_variables[38] == 0
            Graphics.wait(60)
          else
            @msg_cursor.visible = true
            input_loop_run
            #@msg_cursor.visible = false
            Graphics.wait(5)
          end
      end
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

    
    for x in 0..7
      if @visible_hide_card[x] == true
        picture = Cache.picture("カードミニゲーム素材1")
        rect = Rect.new(0, 120, 64, 96) # イベント
        @main_window.contents.blt(CARD_STANDARD_X+78*x,CARD_STANDARD_Y,picture,rect)
        picture = Cache.picture("カード関係")
        rect = set_card_frame 1
        @main_window.contents.blt(CARD_STANDARD_X+78*x,CARD_STANDARD_Y,picture,rect)
      end
    end
      
    if @window_state >= 1 then
      picture = Cache.picture("顔カード")
      for x in 0..7
        if @open_hide_card[x] == true && @visible_hide_card[x] == true 
          rect = put_icon @hide_card[x]
          @main_window.contents.blt(CARD_STANDARD_X+78*x,CARD_STANDARD_Y+16,picture,rect)
        end
      end
    end

  end
  
  #--------------------------------------------------------------------------
  # ● メッセージウインドウの表示
  #--------------------------------------------------------------------------
  def output_msg
    
    # メッセージ表示
    if @window_state == 0
      @msg_window.contents.draw_text(0,0, 600, 20, "じいちゃん「お前の　心強い　味方を得る　神経衰弱じゃ！")
      @msg_window.contents.draw_text(0,25, 600, 20, "　" + ERR_NUM.to_s + "回ハズレを引くと　終わりじゃ！")
    elsif @window_state == 1
      @msg_window.contents.draw_text(0,0, 600, 20, "じいちゃん「" + $data_items[@hide_card[@old_open_card]].name + "」")
    elsif @window_state == 2
      @msg_window.contents.draw_text(0,0, 600, 20, "じいちゃん「お見事！」")
    elsif @window_state == 3
      @msg_window.contents.draw_text(0,0, 600, 20, "じいちゃん「これは　恐れ入った！」")
    elsif @window_state == 4
      @msg_window.contents.draw_text(0,0, 600, 20, "じいちゃん「残念！　ハズレじゃ！」")
    elsif @window_state == 5
      @msg_window.contents.draw_text(0,0, 600, 20, "じいちゃん「あと" + (ERR_NUM-@err_count).to_s + "回！　がんばるのじゃ！！」")
    end
  end
  
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------
  def output_cursor
    # メニューカーソル表示
    $cursor_blink_count += 1
      picture = Cache.picture("アイコン")
      rect = set_tate_cursor_blink
      @main_window.contents.blt(CARD_STANDARD_X+78*@cursor_state,CARD_STANDARD_Y - 16,picture,rect)
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
      x = 0
      begin
        @card_id[x] = rand(26) + 9 #ブルマからスカウターまで
        x += 1
        if @card_id[x-1] == 16 || @card_id[x-1] == 31 || @card_id[x-1] == 33
          x -= 1
        end
      end while x != 4 #デンデが出なくなるまで繰り返す
    when 1,2,20
      x = 0
      begin
        @card_id[x] = rand(33) + 9 #ブルマからスカウターまで
        x += 1
        if @card_id[x-1] == 16 || @card_id[x-1] == 31 || @card_id[x-1] == 33 || @card_id[x-1] == 35 || @card_id[x-1] == 36 || @card_id[x-1] == 37 || @card_id[x-1] == 38 || @card_id[x-1] == 39
          x -= 1
        end
      end while x != 4 #デンデが出なくなるまで繰り返す
    end
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
      
      #チェック方法
      if @open_hide_card[y] == false && @visible_hide_card[y] = true then
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
  #--------------------------------------------------------------------------
  # ● カード取得処理
  #--------------------------------------------------------------------------  
  def get_item_card
    
    text1 = ""      #取得カード表示1行目
    text2 = ""      #取得カード表示2行目
    text3 = ""      #取得カード表示3行目
    text_flag = 1   #取得カード処理行数フラグ
    
    #アイテムカードを取得したら増加処理と表示処理へ
    for x in 0..@get_card.size - 1
      
      
      #アイテムカード増加 最大数以上は持てないように
      #しようと思ったけどアイテムカード表示時に調整することにする
      #if $game_party.item_number($data_items[@get_card[x]]) < $max_item_card_num
      $game_party.gain_item ($data_items[@get_card[x]], 1) #カード増やす
      #end
      
      #文字数が最大数を超えたら次の行へ
      if text_flag == 1 && text1.split(//u).size + $data_items[@get_card[x]].name.split(//u).size + 1 >= 30
        text_flag = 2
      elsif text_flag == 2 && text2.split(//u).size + $data_items[@get_card[x]].name.split(//u).size + 1 >= 30
        text_flag = 3
      end
      
      #対象の行へアイテムカード名を格納
      if text_flag == 1
        text1 += $data_items[@get_card[x]].name + "　"
      elsif text_flag == 2
        text2 += $data_items[@get_card[x]].name + "　"
      elsif text_flag == 3
        text3 += $data_items[@get_card[x]].name + "　"
      end
    end
    @msg_window.contents.clear
  
    Audio.se_play("Audio/SE/" +"Z1 アイテム取得")
    @msg_window.contents.draw_text( 0, 0, 500, 20, "じいちゃん「以下の　お助けカードを　手に入れたぞ！」")
    @msg_window.contents.draw_text( 0, 25, 500, 20, text1)
    @msg_window.contents.draw_text( 0, 50, 500, 20, text2)
    @msg_window.contents.draw_text( 0, 75, 500, 20, text3)

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