#==============================================================================
# ■ Scene_Db_Gravity_Training
#------------------------------------------------------------------------------
# 　重力の修行表示
#==============================================================================
class Scene_Db_Gravity_Training < Scene_Base
  #カードウインドウ表示位置
  Cardxstr = 10
  Cardystr = 330
  Cardxend = 680
  Cardyend = 210
  Cardsize = 64 #カードサイズ
  Cardoutputkizyun = 102 #カード表示基準位置
  BTL_CARD_X = 10
  BTL_CARD_Y = 258
  TRA_CARD_X = 566
  TRA_CARD_Y = 258
  CHARA_WIN_X =106
  CHARA_WIN_Y =198
  TRA_WIN_X = 360
  TRA_WIN_Y = 220
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
    #$game_variables[40] = 2
    #$game_variables[43] = 23
    create_window
    #シナリオ進行度によってファイル名の頭文字を変える
    if $game_variables[40] == 0
      Audio.bgm_play("Audio/BGM/" + "Z1 修行")    # 効果音を再生する
    elsif $game_variables[40] == 1
      Audio.bgm_play("Audio/BGM/" + "Z2 修行")    # 効果音を再生する
    elsif $game_variables[40] == 2
      Audio.bgm_play("Audio/BGM/" + "Z3 修行")    # 効果音を再生する
    end
    @training_count = 0 #修行回数
    if $training_chara_num == nil
      @window_state = 0 #ウインドウ状態
      @battle_hp = 0
    else
      @window_state = 2 #ウインドウ状態
      @battle_hp = $game_actors[$partyc[$training_chara_num]].hp
    end
    @battle_card_cursor_state = 0 #カーソル位置
    @old_card = nil
    @card_select=[false,false,false,false,false,false]
    @training_carda = []
    @training_cardg = []
    @training_cardi = []
    @total_exp = nil
    @anime_count = 0
    @training_card_num = 0
    @training_card_first_output = false
    @training_card_secand_output = false
    @battle_card_num = 0
    @battle_carda = []
    @battle_cardg = []
    @battle_cardi = []
    @battle_card_result = 1
    @msg_cursor = Sprite.new
    @msg_cursor.bitmap = Cache.picture("アイコン")
    @msg_cursor.visible = true
    @msg_cursor.src_rect = set_tate_cursor_blink
    @msg_cursor.x = 320-8
    @msg_cursor.y = 128 -16#-14
    @msg_cursor.z = 255
    color =set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    if $game_variables[43] == 23
      @training_level = 0
    elsif $game_variables[43] == 25
      @training_level = 1
    elsif $game_variables[43] == 27
      @training_level = 2
    elsif $game_variables[43] == 28
      @training_level = 3
    else
      @training_level = 2
    end
    
    case @training_level
    
    when 0 #20倍
      @training_name = "20倍"
      @training_hp = 20
      @training_mhp = 20
      @training_damage = 20
    when 1 #50倍
      @training_name = "50倍"
      @training_hp = 50
      @training_mhp = 50
      @training_damage = 30
    when 2 #100倍
      @training_name = "100倍"
      @training_hp = 100
      @training_mhp = 100
      @training_damage = 50
    when 3 #10倍(界王)
      @training_name = "10倍"
      @training_hp = 50
      @training_mhp = 50
      @training_damage = 25
    end
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    Graphics.fadein(10)
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_sprite
    dispose_window
    if @window_state != 27 #キャンセル以外なら
      case @training_level
      
      when 0 #20倍
        $game_switches[90] = true
      when 1 #50倍
        $game_switches[91] = true
      when 2 #100倍
        $game_switches[92] = true
      when 3 #10倍(界王)
        $game_switches[100] = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------   
  def dispose_window
    @main_window.dispose
    @main_window = nil
    @msg_window.dispose
    @msg_window = nil
    @card_window.dispose
    @card_window = nil
    #@tra_msg_window.dispose
    #@tra_msg_window = nil
  end 
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    # メインウインドウ
    @main_window = Window_Base.new(-16,-16,672,512)
    @main_window.opacity=0
    @main_window.back_opacity=0
    # メッセージウインドウ
    @msg_window = Window_Base.new(0,0,640,128)
    @msg_window.opacity=255
    @msg_window.back_opacity=255
    @msg_window.contents.font.color.set( 0, 0, 0)
    # カードウインドウ作成(カード用)
    @card_window = Window_Base.new(Cardxstr,Cardystr,Cardxend,Cardyend)
    @card_window.opacity=0
    @card_window.back_opacity=0
  end
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------  
  def pre_update
    @main_window.contents.clear
    @card_window.contents.clear
    @msg_window.contents.clear
    #@tra_msg_window.contents.clear
    
    color =set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    color = Color.new(0,0,0,255)
    @main_window.contents.fill_rect(120-36-42,200-68,128,128,color)
    color =set_skn_color 1
    @main_window.contents.fill_rect(120+128-36,200-44-24,216,64,color)
    @main_window.contents.fill_rect(42+128+42,212,86,48,color)
    @main_window.contents.fill_rect(470-128,212,86,48,color)
    
    picture = Cache.picture("Z2_修行_重力_文字")
    case @training_level
    
    when 0 #20倍
      rect = Rect.new(0 , 44*0, 176, 44)
    when 1 #50倍
      rect = Rect.new(0 , 44*1, 176, 44)
    when 2 #100倍
      rect = Rect.new(0 , 44*2, 176, 44)
    when 3 #10倍
      rect = Rect.new(0 , 44*3, 176, 44)
    else
      rect = Rect.new(0 , 44*2, 176, 44)
    end
    @main_window.contents.blt(120+128-36+20,200-44-24+10,picture,rect)
    
    output_msg            #メッセージ表示
    output_select_battle_card    #バトルカード表示
    output_opponent       #対戦相手表示
    output_cursor if @msg_cursor.visible == false#if @window_state > 6 #&& @window_state != 3
    output_msgcursor if @msg_cursor.visible == true
    output_hp             #HP表示
    if $training_chara_num != nil
      output_character      #キャラクター表示
    end
    output_battle_card    #バトルカード表示
    output_training_card  #トレーニングカード更新
          #@main_window.contents.draw_text( 0, 200, 600, 20, @training_carda)
          #@main_window.update
          #Graphics.update
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    
    pre_update
    @msg_window.update
    @card_window.update
    @main_window.update
    
    if $training_chara_num == nil && @window_state == 1 #キャラクター選択
      chara_select
    end
    if Input.trigger?(Input::B)
      
      case @window_state
      when 0
        @window_state = 27
      when 8,9
        if @window_state == 9
          @card_select[@battle_card_cursor_state] = false
          @battle_card_num = 0
          @battle_card_result = 1
        end
        @window_state = 7
        @battle_card_cursor_state = 0
      end
    end  

    if Input.trigger?(Input::C)
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      case @window_state
      when 0
        @msg_cursor.visible = false
        @window_state += 1
      when 2..5

        if @window_state == 4 
          create_card 2
          @training_card_num = rand(3)
##########################################################################
#テスト用
          #@training_card_num = 1
          #@training_hp = 20
##########################################################################
        elsif @window_state == 5
          create_card 1
        end
        @window_state += 1
      when 6,7,8,9,11
        
        if @window_state == 6
          @msg_cursor.visible = false
        elsif @window_state == 7 && @battle_card_result == -1
          @window_state = 21
          chk_training
          @window_state -= 1
        elsif @window_state == 8
          @battle_carda[1] = $carda[@battle_card_cursor_state]
          @battle_cardg[1] = $cardg[@battle_card_cursor_state]
          @battle_cardi[1] = $cardi[@battle_card_cursor_state]
          @card_select[@battle_card_cursor_state] = true
          @battle_card_num = 1
          if @battle_carda[0]+1+@battle_carda[1]+1 > 10
            @window_state = 21
            chk_training
            @window_state -= 1
          end
        elsif @window_state == 9 && @battle_card_result == -1
          @card_select[@battle_card_cursor_state] = false
          @battle_card_num = 0          
          @window_state = 6
          @battle_card_cursor_state = 0
          @battle_card_result = 1
        end
        @window_state += 1

      when 10
        if @battle_card_result == 1
          @battle_card_num = 2
          @window_state = 21
          chk_training
        else @battle_card_result == -1
          @window_state = 21
          chk_training
        end
      when 12
        @window_state = 21
        chk_training
      when 24
        @window_state = 5
      end
    end
    
    if Input.trigger?(Input::DOWN)

    end
    if Input.trigger?(Input::UP)

    end
    if Input.trigger?(Input::RIGHT)
      
      case @window_state
      when 7,9,10
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @battle_card_result = -@battle_card_result
      when 8
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,1,0,$Cardmaxnum)
      end
    end
    if Input.trigger?(Input::LEFT)
      case @window_state
      when 7,9,10
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @battle_card_result = -@battle_card_result
      when 8
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,2,0,$Cardmaxnum)
      end
    end

    if @window_state >= 25

      if @window_state == 26
        if $game_variables[43] == 23 || 25 || 27 || 28
          $scene = Scene_Gameover.new
        end
      else
        $training_chara_num = nil
        Audio.bgm_stop
        Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
        Graphics.fadeout(20)
        $game_variables[41] = 0       # 実行イベント初期化 
        $scene = Scene_Map.new
        $game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
      end

    end
  end
  
  
  #--------------------------------------------------------------------------
  # ● メッセージウインドウの表示
  #--------------------------------------------------------------------------
  def output_msg

    # メッセージ表示
    if @window_state == 0
      @msg_window.contents.draw_text(0,0, 600, 20, "決定ボタンで　修行する　キャラクターの　選択だ！")
      @msg_window.contents.draw_text(0,25, 600, 20, "修行をしない場合は　キャンセルボタンで　終了だ！")
    elsif @window_state == 2
      @msg_window.contents.draw_text(0,0, 600, 20, "さあ！　修行だ！")
      
      if @training_level != 3
        @msg_window.contents.draw_text(0,25, 600, 20, "カードの数の合計が　重力装置より！")
      else
        @msg_window.contents.draw_text(0,25, 600, 20, "カードの数の合計が　超重力より！")
      end
      @msg_window.contents.draw_text(0,50, 600, 20, "多くなるようにするんだ！")
      @msg_window.contents.draw_text(0,75, 600, 20, "ただし　合計が　10を超えたら失敗だ！")
    elsif @window_state == 3
      @msg_window.contents.draw_text(0,0, 600, 20, "なお　特殊ルールは　次の通りだ！")
      @msg_window.contents.draw_text(0,25, 600, 20, "Ｚ　と　２で　勝つ…もらえる経験値３倍")
      @msg_window.contents.draw_text(0,50, 600, 20, "カード３枚で　勝つ…もらえる経験値２倍")
      @msg_window.contents.draw_text(0,75, 600, 20, "合計が　10で　勝つ…もらえる経験値1.5倍")
    elsif @window_state == 4
      @msg_window.contents.draw_text(0,0, 600, 20, "それでは　超重力の　修行を始めます！")
    elsif @window_state == 5
      @msg_window.contents.draw_text(0,0, 600, 20, "超重力の　カード選択！")
    elsif @window_state == 6
      @msg_window.contents.draw_text(0,0, 600, 20, "カード１枚目！")
    elsif @window_state == 7
      @msg_window.contents.draw_text(0,0, 600, 20, "２枚目は　手持ちのカードから")
      @msg_window.contents.draw_text(0,25, 600, 20, "星の数を　基準に　使えます")
      @msg_window.contents.draw_text(0,50, 600, 20, "２枚目のカードは　いりますか？")
      @msg_window.contents.draw_text(0,75, 600, 20, "　いる　　　いらない")
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      if @battle_card_result == 1
        @msg_window.contents.blt(0,77,picture,rect)
      else
        @msg_window.contents.blt(90,77,picture,rect)
      end
    elsif @window_state == 8
      @msg_window.contents.draw_text(0,0, 600, 20, "それでは　カードを　選んで下さい")
    elsif @window_state == 9
      @msg_window.contents.draw_text(0,0, 600, 20, "このカードで　いいですか？")
      @msg_window.contents.draw_text(0,25, 600, 20, "　はい　　　いいえ")
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      if @battle_card_result == 1
        @msg_window.contents.blt(0,27,picture,rect)
      else
        @msg_window.contents.blt(90,27,picture,rect)
      end
    elsif @window_state == 10
      @msg_window.contents.draw_text(0,0, 600, 20, "３枚目は　オートです")
      @msg_window.contents.draw_text(0,25, 600, 20, "３枚目のカードは　いりますか？")
      @msg_window.contents.draw_text(0,50, 600, 20, "　いる　　　いらない")
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      if @battle_card_result == 1
        @msg_window.contents.blt(0,52,picture,rect)
      else
        @msg_window.contents.blt(90,52,picture,rect)
      end
    elsif @window_state == 11
      @msg_window.contents.draw_text(0,0, 600, 20, "カード３枚目！")
    elsif @window_state == 21
      #@msg_window.contents.draw_text(0,0, 600, 20, "また一歩　修行のコツを　掴んだ！！")
      #@msg_window.contents.draw_text(0,25, 600, 20, "経験値" + @total_exp.to_s + "を得た！")
    elsif @window_state == 22
      @msg_window.contents.draw_text(0,0, 600, 20, "修行　失敗！！")
      @msg_window.contents.draw_text(0,25, 600, 20, (@training_damage*2).to_s + "のダメージを　受けた！")
    elsif @window_state == 23
      @msg_window.contents.draw_text(0,0, 600, 20, "残念ながら　修行の効果は　無かったようだ…")
    elsif @window_state == 24
      @msg_window.contents.draw_text(0,0, 600, 20, "まだまだ！　これからだ！！")
    elsif @window_state == 25
      case @training_level
    
      when 0 #20倍
        @msg_window.contents.draw_text(0,0, 600, 20, "ついに　重力20倍を　克服した！！")
      when 1 #50倍
        @msg_window.contents.draw_text(0,0, 600, 20, "ついに　重力50倍を　克服した！！")
      when 2 #100倍
        @msg_window.contents.draw_text(0,0, 600, 20, "ついに　重力100倍を　克服した！！")
      when 3 #10倍
        @msg_window.contents.draw_text(0,0, 600, 20, "ついに　重力10倍を　克服した！！")
      else #100倍
        @msg_window.contents.draw_text(0,0, 600, 20, "ついに　重力100倍を　克服した！！")
      end
    elsif @window_state == 26
      @msg_window.contents.draw_text(0,0, 600, 20, "重力"+@training_name+"　の修行に　失敗した！！")
    elsif @window_state == 27
      @msg_window.contents.draw_text(0,0, 600, 20, "")
    end
  end
  #--------------------------------------------------------------------------
  # ● HP表示
  #--------------------------------------------------------------------------  
  def output_hp
    pictureb = Cache.picture("数字英語")
    rect = Rect.new(0, 16, 32, 16) #HP
    @main_window.contents.blt(212+8 ,212+6,pictureb,rect)
    @main_window.contents.blt(342+8 ,212+6,pictureb,rect)
    if $training_chara_num != nil
      for y in 1..@battle_hp.to_s.size #HP
        rect = Rect.new(@battle_hp.to_s[-y,1].to_i*16, 0, 16, 16)
        @main_window.contents.blt(212+8+48-(y-1)*16,212+24,pictureb,rect)
      end
    end
    for y in 1..@training_hp.to_s.size #HP
      rect = Rect.new(@training_hp.to_s[-y,1].to_i*16, 0, 16, 16)
      @main_window.contents.blt(342+8+48-(y-1)*16,212+24,pictureb,rect)
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルカード表示
  #--------------------------------------------------------------------------  
  def output_battle_card
      # バトルカード表示
      picture = Cache.picture("カード関係")
      if @window_state >= 6 && @window_state != 24
        for x in 0..@battle_card_num
          recta = set_card_frame 0
          rectb = set_card_frame 2,@battle_carda[x] # 攻撃
          rectc = set_card_frame 3,@battle_cardg[x] # 防御
          if x != 1
            rectd = Rect.new(0 + 32 * 8, 0, 32, 32) # 流派
            if @training_level == 3 #ピッコロの重力修行の場合 流派を魔に変える
              rectd = Rect.new(0 + 32 * 4, 64, 32, 32) # 流派
            end
          else
            rectd = Rect.new(0 + 32 * @battle_cardi[x], 64, 32, 32) # 流派
          end
          @main_window.contents.blt(BTL_CARD_X+x*64,BTL_CARD_Y,picture,recta)
          @main_window.contents.blt(BTL_CARD_X+2+x*64+$output_card_tyousei_x,BTL_CARD_Y+2+$output_card_tyousei_y,picture,rectb)
          @main_window.contents.blt(BTL_CARD_X+30+x*64,BTL_CARD_Y+62,picture,rectc)
          @main_window.contents.blt(BTL_CARD_X+16+x*64,BTL_CARD_Y+32,picture,rectd)
        end
      end
  end
  #--------------------------------------------------------------------------
  # ● トレーニングカード表示
  #--------------------------------------------------------------------------  
  def output_training_card
    x = 0
    picture = Cache.picture("カード関係")
    if @window_state >= 5 && @window_state != 24
      rect = set_card_frame 1
      for x in 0..@training_card_num
        @main_window.contents.blt(TRA_CARD_X-x*Cardsize,TRA_CARD_Y,picture,rect)
        if @training_card_first_output == false
          Graphics.wait(30)
        end
      end
      @training_card_first_output = true
    end
    if @window_state >= 21 && @window_state != 24
      for x in 0..@training_card_num
        recta = set_card_frame 0
        rectb = set_card_frame 2,@training_carda[x] # 攻撃
        rectc = set_card_frame 3,@training_cardg[x] # 防御
        rectd = Rect.new(0 + 32 * 9, 0, 32, 32) # 流派
        
        @main_window.contents.blt(TRA_CARD_X-x*Cardsize,TRA_CARD_Y,picture,recta)
        @main_window.contents.blt(TRA_CARD_X+2-x*Cardsize+$output_card_tyousei_x,TRA_CARD_Y+2+$output_card_tyousei_y,picture,rectb)
        @main_window.contents.blt(TRA_CARD_X+30-x*Cardsize,TRA_CARD_Y+62,picture,rectc)
        @main_window.contents.blt(TRA_CARD_X+16-x*Cardsize,TRA_CARD_Y+32,picture,rectd)
        if @training_card_secand_output == false
          Graphics.wait(30)
        end
      end
      @training_card_secand_output = true
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルカード表示
  #--------------------------------------------------------------------------  
  def output_select_battle_card
      # バトルカード表示
      picture = Cache.picture("カード関係")
      
      for a in 1..6 do
        if @card_select[a-1] == false
          recta = set_card_frame 0
          rectb = set_card_frame 2,$carda[a-1] # 攻撃
          rectc = set_card_frame 3,$cardg[a-1] # 防御
          rectd = Rect.new(0 + 32 * ($cardi[a-1]), 64, 32, 32) # 流派  
          @card_window.contents.blt(Cardoutputkizyun + Cardsize * (a-1),24,picture,recta)
          @card_window.contents.blt(Cardoutputkizyun + 2 + Cardsize * (a-1)+$output_card_tyousei_x,26+$output_card_tyousei_y,picture,rectb)
          @card_window.contents.blt(Cardoutputkizyun + 30 + Cardsize * (a-1),86,picture,rectc)
          @card_window.contents.blt(Cardoutputkizyun + 16 + Cardsize * (a-1),56,picture,rectd)
        else
          recta = set_card_frame 1
          @card_window.contents.blt(102 + Cardsize * (a-1),24,picture,recta)
        end
      end

  end
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------
  def output_cursor
    # メニューカーソル表示
    $cursor_blink_count += 1
    picture = Cache.picture("アイコン")
    #if @window_state == 8 || @window_state == 0
      rect = set_tate_cursor_blink
    #else
    #  rect = Rect.new(1*16, 0, 16, 16) # アイコン
    #end
    @card_window.contents.blt(112 + Cardsize * @battle_card_cursor_state,8,picture,rect)
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
      if @card_select[y] == false then
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
  # ● 修行するキャラクターの選択
  #-------------------------------------------------------------------------- 
  def chara_select
    @window_state = 1
    #Graphics.wait(60)
    Graphics.fadeout(5)
    $training_no = 0
    $scene = Scene_Db_Status.new 4
  end
  #--------------------------------------------------------------------------
  # ● カード生成
  #引数[n:キャラかトレーニング用か]
  #-------------------------------------------------------------------------- 
  def create_card n,card_no = 0
    
    for i in 1..1
        if n == 0 #味方
          createcardval card_no
        elsif n == 1 #トレーニング用
          tra_fix = rand(2) #10を超えないようにするかどうか 0：超えない　0以外：超えても可
          if @training_card_num == 0
            tra_fix = 1
          end
          
          for x in 0..2
            result = 0
            begin
              @training_carda[x] = rand(8)
              @training_cardg[x] = rand(8)
              
              if x == 0 || tra_fix != 0 || x == 2 && @training_card_num == 1 && tra_fix == 0
                result = 1
              elsif x == 1 && tra_fix == 0 && (@training_carda[0]+1 + @training_carda[1]+1).to_i <= 10
                result = 1
                if @training_card_num == 2 && (@training_carda[0]+1 + @training_carda[1]+1).to_i == 10
                  @training_carda[1] -= 1
                end
              elsif x == 2 && tra_fix == 0 && (@training_carda[0]+1 + @training_carda[1]+1 + @training_carda[2]+1).to_i <= 10 
                result = 1
              end
            end while result == 0
          end
        elsif n == 2 #バトルカード用
          for x in 0..2
            @battle_carda[x] = rand(8)
            @battle_cardg[x] = 0
          end
        end
    end
  end
  #--------------------------------------------------------------------------
  # ● カード比較
  #引数[n:キャラかトレーニング用か]
  #-------------------------------------------------------------------------- 
  def chk_training
    pre_update
    @msg_window.update
    @card_window.update
    @main_window.update
    Graphics.update
    battle_card_value = 0
    training_card_value = 0
    stop_flag = false
    for x in 0..@battle_card_num
      battle_card_value += (@battle_carda[x]+1)
    end
    
    for x in 0..@training_card_num
      training_card_value += (@training_carda[x]+1)
    end
    if battle_card_value > 10 || battle_card_value < training_card_value && training_card_value < 11
      @window_state = 22
      Audio.se_play("Audio/SE/" + "Z1 ダメージ")    # 効果音を再生する
      chk_damage 1
      stop_flag = true
      @msg_cursor.visible = true
    elsif training_card_value > 10 || battle_card_value > training_card_value
      Audio.se_play("Audio/SE/" + "Z2 アイテム取得")    # 効果音を再生する
      get_exp
      chk_damage
    elsif battle_card_value == training_card_value
      @window_state = 23
      stop_flag = true
      @msg_cursor.visible = true
    end

    pre_update
    @msg_window.update
    @card_window.update
    @main_window.update
    Graphics.update
    if stop_flag == true
      if $game_variables[38] == 0
        Graphics.wait(60)
      else
        @msg_cursor.visible = true
        input_loop_run
        Graphics.wait(5)
      end
    end
    if @card_select.index(true) != nil
      create_card 0,@card_select.index(true)
      @card_select[@card_select.index(true)] = false
    end
    
    @battle_card_num = 0
    @training_card_first_output = false
    @training_card_secand_output = false
    
    if @window_state != 25 && @window_state != 26
      @window_state = 5
    end
    @anime_count = 0
    create_card 2
    @training_card_num = rand(3)
    @battle_card_result = 1
    @battle_card_cursor_state = 0
    
  end
  #--------------------------------------------------------------------------
  # ● 経験値計算
  #
  #-------------------------------------------------------------------------- 
  def get_exp
    
    exp = 0
    
    battle_card_value = 0
    for x in 0..@battle_card_num
      battle_card_value += (@battle_carda[x]+1)
    end
    
    exp = $game_actors[$partyc[$training_chara_num]].level * 350
    if (@battle_carda[0]+1)==8 && (@battle_carda[1]+1)==2 ||
      (@battle_carda[0]+1)==2 && (@battle_carda[1]+1)==8
      exp = exp * 3
    elsif @battle_card_num == 2
      exp = exp * 2
    elsif battle_card_value == 10
      exp = exp * 1.5
    end
    
    if @training_level == 3
      exp = exp * 2.5
    end
    
    @total_exp = (exp).prec_i
    @msg_window.contents.clear
    text = "経験値" + @total_exp.to_s + "を得た！"
    @msg_window.contents.draw_text(0,0, 600, 20, "また一歩　修行のコツを　掴んだ！！")
    @msg_window.contents.draw_text( 0, 25, 600, 20, text)
    @msg_window.update
    if $game_variables[38] == 0
      Graphics.wait(60)
    else
      @msg_cursor.visible = true
      input_loop_run
      Graphics.wait(5)
    end
    
    old_level = $game_actors[$partyc[$training_chara_num]].level
    $game_actors[$partyc[$training_chara_num]].change_exp($game_actors[$partyc[$training_chara_num]].exp + @total_exp.to_i,false)
    if old_level != $game_actors[$partyc[$training_chara_num]].level
      #Audio.se_play("Audio/SE/" +$BGM_levelup_se)
      run_common_event 188 #レベルアップSEを鳴らす(MEを使うかをコモンイベントで定義)
      @msg_window.contents.clear
      text = $game_actors[$partyc[$training_chara_num]].name + "はレベル" + $game_actors[$partyc[$training_chara_num]].level.to_s + "になった！" 
      @msg_window.contents.draw_text( 0, 0, 600, 20, text)
      @msg_window.update
      if $game_variables[38] == 0
        Graphics.wait(60)
      else
        @msg_cursor.visible = true
        input_loop_run
        Graphics.wait(5)
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # ● ダメージ処理
  # n:ダメージ方向 0:味方⇒敵 1:敵⇒味方
  #-------------------------------------------------------------------------- 
  def chk_damage n=0
    
    if n == 0
      @training_hp -= @training_mhp/5
    else
      @battle_hp -= @training_damage *2
    end

    if @training_hp <= 0
      @training_hp = 0
      @window_state = 25
    end
    
    if @battle_hp <= 0
      @battle_hp = 0
      @window_state = 26
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 対戦相手を表示
  # 通常は重力装置
  #-------------------------------------------------------------------------- 
  def output_opponent
    #@main_window.contents.fill_rect(120,200,128,128,color)
    if @training_level == 3
      picture = Cache.picture("Z2_修行_界王重力_背景")
    else
      picture = Cache.picture("Z2_修行_重力_背景")
    end
    rect = Rect.new(0 , 0, 128, 128)
    @main_window.contents.blt(640-120-128+36+42,200-68,picture,rect)
  end
  #--------------------------------------------------------------------------
  # ● キャラクター表示
  #
  #-------------------------------------------------------------------------- 
  def output_character
    
    picture = Cache.picture($top_file_name + "戦闘_" + $data_actors[$partyc[$training_chara_num]].name)
    
    case @anime_count
    
    when 0..7 
      rect = Rect.new(0 , 0+(96*0), 96, 96)
    when 8..15
      rect = Rect.new(0 , 0+(96*1), 96, 96)
    when 16..23
      rect = Rect.new(0 , 0+(96*0), 96, 96)
    when 24..31
      rect = Rect.new(0 , 0+(96*4), 96, 96)
    when 32..39
      rect = Rect.new(0 , 0+(96*0), 96, 96)
    when 40..47
      rect = Rect.new(0 , 0+(96*2), 96, 96)
    when 48..55
      rect = Rect.new(0 , 0+(96*0), 96, 96)
    when 56..63
      rect = Rect.new(0 , 0+(96*3), 96, 96)
    end
    
    if @window_state >= 6 && @window_state != 22 && @window_state != 24
      if @anime_count != 63
        @anime_count += 1 if @training_hp != 0
      else
        @anime_count = 0
      end
    elsif @window_state == 22
      rect = Rect.new(0 , 0+(96*17), 96, 96)
      @anime_count = 0
    end
    @main_window.contents.blt(CHARA_WIN_X+28-36-42,CHARA_WIN_Y+6-68,picture,rect)
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