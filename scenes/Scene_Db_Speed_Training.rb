#==============================================================================
# ■ Scene_Db_Speed_Training
#------------------------------------------------------------------------------
# 　スピードと敏捷性を養う修行表示
#==============================================================================
class Scene_Db_Speed_Training < Scene_Base
  include Share
  #カードウインドウ表示位置
  Cardxstr = 10
  Cardystr = 330
  Cardxend = 680
  Cardyend = 210
  Cardsize = 64 #カードサイズ
  Cardoutputkizyun = 102 #カード表示基準位置
  TRA_CARD_X = 268
  TRA_CARD_Y = 212
  CHARA_WIN_X =106
  CHARA_WIN_Y =200
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
    else
      @window_state = 2 #ウインドウ状態
    end
    @battle_card_cursor_state = 0 #カーソル位置
    @old_card = nil
    @card_select=[false,false,false,false,false,false]
    @training_carda = nil
    @training_cardg = nil
    @training_cardi = nil
    @total_exp = nil
    @anime_count = 0
    @msgno = 0
    @msg_cursor = Sprite.new
    @msg_cursor.bitmap = Cache.picture("アイコン")
    @msg_cursor.visible = true
    @msg_cursor.src_rect = set_tate_cursor_blink
    @msg_cursor.x = 320-8
    @msg_cursor.y = 128 -16#-14
    @msg_cursor.z = 255
    @tra_success = false #修行成功して終わったか
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    Graphics.fadein(10)
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_sprite
    dispose_window
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
    @tra_msg_window.dispose
    @tra_msg_window = nil
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
    # トレーニング結果メッセージウインドウ
    @tra_msg_window = Window_Base.new(TRA_WIN_X,TRA_WIN_Y,250,80)
    @tra_msg_window.opacity=255
    @tra_msg_window.back_opacity=255
    @tra_msg_window.contents.font.color.set( 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------  
  def pre_update
    @main_window.contents.clear
    @card_window.contents.clear
    @msg_window.contents.clear
    @tra_msg_window.contents.clear
    
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    color = Color.new(0,0,0,255)
    @main_window.contents.fill_rect(120,200,120,120,color)
    
    output_training_card  #トレーニングカード更新
    output_msg            #メッセージ表示
    output_battle_card    #バトルカード表示
    output_tra_msg        #トレーニング結果メッセージ表示
    output_cursor if @window_state > 2 && @window_state != 4 && @window_state != 7 #カーソル表示
    output_msgcursor if @msg_cursor.visible == true      #メッセージカーソル表示
    
    if $training_chara_num != nil
      output_character      #キャラクター表示
    end
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
    @tra_msg_window.update
    
    if $training_chara_num == nil && @window_state == 1 #キャラクター選択
      chara_select
    end
    if Input.trigger?(Input::B)
      
      if @window_state == 0
        @window_state = 8
      end
  
      if @window_state == 2 || @window_state == 4
        Audio.se_play("Audio/SE/" + "Z1 完了")    # 効果音を再生する
        @tra_success = true
        @window_state = 6
      end
    end  

    if Input.trigger?(Input::C)
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      if @window_state == 0
        @msg_cursor.visible = false
        @window_state = 1
      elsif @window_state == 2
        
        if @msgno == 0
          @msgno += 1
          
        elsif @msgno == 1
          @msg_cursor.visible = false
          @window_state += 1
          create_card 1
          @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,0,0,$Cardmaxnum)
        end
      elsif @window_state == 3
        @msg_cursor.visible = true
        chk_training
      elsif @window_state == 4
        @msg_cursor.visible = false
        @window_state = 3
        create_card 1
        @battle_card_cursor_state = chk_select_cursor_control(0,0,0,$Cardmaxnum)
      end
      
      
    end
    
    if Input.trigger?(Input::DOWN)

    end
    if Input.trigger?(Input::UP)

    end
    if Input.trigger?(Input::RIGHT)
      
      if @window_state == 3
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,1,0,$Cardmaxnum)
      end
    end
    if Input.trigger?(Input::LEFT)
      if @window_state == 3
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,2,0,$Cardmaxnum)
      end
    end

    if @window_state >= 6
      if @window_state == 6 #修行を途中で止めたときのみ経験値を計算
        get_exp
      end
      
      if @old_card != nil
        create_card 0,@old_card
        #Graphics.wait(50)
      end
      
      $training_chara_num = nil
      Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
      Graphics.fadeout(20)
      $game_variables[41] = 0       # 実行イベント初期化 
      $scene = Scene_Map.new
      $game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
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
      if @msgno == 0
        @msg_window.contents.draw_text(0,0, 600, 20, "スピードと　敏捷性を　養う　修行だ！")
        @msg_window.contents.draw_text(0,25, 600, 20, "流派・星・数字の数　いずれかが　同じカードを出すんだ！")
        @msg_window.contents.draw_text(0,50, 600, 20, "ただし　流派「気」のカードは　どの流派でも大丈夫だ！")
      elsif @msgno ==1
        @msg_window.contents.draw_text(0,0, 600, 20, "沢山クリアすれば　それだけ　経験値が　沢山貰えるぞ！")
        @msg_window.contents.draw_text(0,25, 600, 20, "決定ボタンで　開始　キャンセルボタンで　終了だ！")
      end
    elsif @window_state == 3
      @msg_window.contents.draw_text(0,0, 600, 20, "流派・星・数字の数　いずれかが　同じカードを出すんだ！")
    elsif @window_state == 4
      @msg_window.contents.draw_text(0,0, 600, 20, "決定ボタンで　継続　キャンセルボタンで　終了だ！")
    elsif @window_state == 5
      @msg_window.contents.draw_text(0,0, 600, 20, "修行失敗！！")
    end
  end
  #--------------------------------------------------------------------------
  # ● トレーニング結果ウインドウの表示
  #--------------------------------------------------------------------------
  def output_tra_msg
    text =nil
    
    case @training_count #修行メッセージ
    
    when 0
      text = "これからだ！"
    
    when 1..3
      text = "楽勝！"
    when 4..5
      text = "ファイトだ！"
    when 6..9
      text = "まだまだ！"
    when 10..14
      text = "負けるな！"
    when 15..19
      text = "根性出せ！！"
    else
      text = "行くとこまで行けー！！！"
    end
    
    @tra_msg_window.contents.draw_text(0,0, 600, 20, @training_count.to_s + "回！")
    @tra_msg_window.contents.draw_text(0,25, 600, 20, text)
  end
  
  #--------------------------------------------------------------------------
  # ● トレーニングカード表示
  #--------------------------------------------------------------------------  
  def output_training_card

    picture = Cache.picture("カード関係")
    if @window_state != 3 && @window_state != 5
      rect = set_card_frame 1
      @main_window.contents.blt(TRA_CARD_X,TRA_CARD_Y,picture,rect)
    else
      recta = set_card_frame 0
      rectb = set_card_frame 2,@training_carda
      rectc = set_card_frame 3,@training_cardg # 防御
      rectd = Rect.new(0 + 32 * (@training_cardi), 64, 32, 32) # 流派
      @main_window.contents.blt(TRA_CARD_X,TRA_CARD_Y,picture,recta)
      @main_window.contents.blt(TRA_CARD_X+2+$output_carda_tyousei_x,TRA_CARD_Y+2+$output_carda_tyousei_y,picture,rectb)
      @main_window.contents.blt(TRA_CARD_X+30+$output_cardg_tyousei_x,TRA_CARD_Y+62+$output_cardg_tyousei_y,picture,rectc)
      @main_window.contents.blt(TRA_CARD_X+16+$output_cardi_tyousei_x,TRA_CARD_Y+32+$output_cardi_tyousei_y,picture,rectd)
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルカード表示
  #--------------------------------------------------------------------------  
  def output_battle_card
      # バトルカード表示
      picture = Cache.picture("カード関係")
      
      for a in 1..6 do
        if @card_select[a-1] == false
          recta = set_card_frame 0
          rectb = set_card_frame 2,$carda[a-1] # 攻撃
          rectc = set_card_frame 3,$cardg[a-1] # 防御
          rectd = Rect.new(0 + 32 * ($cardi[a-1]), 64, 32, 32) # 流派  
          @card_window.contents.blt(Cardoutputkizyun + Cardsize * (a-1),24,picture,recta)
          @card_window.contents.blt(Cardoutputkizyun + 2 + Cardsize * (a-1)+$output_carda_tyousei_x,26+$output_carda_tyousei_y,picture,rectb)
          @card_window.contents.blt(Cardoutputkizyun + 30 + Cardsize * (a-1)+$output_cardg_tyousei_x,86+$output_cardg_tyousei_y,picture,rectc)
          @card_window.contents.blt(Cardoutputkizyun + 16 + Cardsize * (a-1)+$output_cardi_tyousei_x,56+$output_cardi_tyousei_y,picture,rectd)
        else
          recta = set_card_frame 1
          @card_window.contents.blt(Cardoutputkizyun + Cardsize * (a-1),24,picture,recta)
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
    rect = set_tate_cursor_blink
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

    if n == 0 #味方
      createcardval card_no
    else #トレーニング用
      @training_carda = rand(8)
      @training_cardg = rand(8)
      @training_cardi = create_card_i 0
      
      case $game_variables[40]
      
      when 0 #Z1
        kicard_rand = 7
      when 1 #Z2
        kicard_rand = 5
      when 2 #Z3以降
        kicard_rand = 4
      else
        kicard_rand = 4
      end
      
      if 1 == rand(kicard_rand) #流派を気に変える
        @training_cardi = 16
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● カード比較
  #引数[n:キャラかトレーニング用か]
  #-------------------------------------------------------------------------- 
  def chk_training
    
    if @training_carda == $carda[@battle_card_cursor_state] ||
      @training_cardg == $cardg[@battle_card_cursor_state] ||
      @training_cardi == $cardi[@battle_card_cursor_state] ||
      @training_cardi == 16 || #トレーニングカードが気カード
      $cardi[@battle_card_cursor_state] == 16 #自分のカードがカードが気カード
      Audio.se_play("Audio/SE/" + "Z2 アイテム取得")    # 効果音を再生する
      if @old_card != nil
        create_card 0,@old_card
        @card_select[@old_card] = false
      end
      
      @card_select[@battle_card_cursor_state] = true
      @old_card = @battle_card_cursor_state
      @training_count += 1
      @window_state = 4
    else
      Audio.se_play("Audio/SE/" + "Z1 ダメージ")    # 効果音を再生する
      @window_state = 7
      
      @old_card = @battle_card_cursor_state
      pre_update
      output_character
      @msg_window.contents.clear
      if @training_count != 0 
        @msg_window.contents.draw_text(0,0, 600, 20, "修行失敗！！　取得経験値半減！")
      else
        @msg_window.contents.draw_text(0,0, 600, 20, "修行失敗！！")
      end
        
      @msg_window.update
      @card_window.update
      @main_window.update
      @tra_msg_window.update
      if $game_variables[38] == 0
        Graphics.wait(60)
      else
        @msg_cursor.visible = true
        input_loop_run
        Graphics.wait(5)
      end
      
      #修行が1回でも成功したら
      if @training_count != 0 
        @window_state = 6
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 経験値計算
  #
  #-------------------------------------------------------------------------- 
  def get_exp
    
    exp = 0
    
    exp = $game_actors[$partyc[$training_chara_num]].level * 2.5
    
    @total_exp = exp*@training_count
    if $game_variables[40] == 0
      exp = exp / 2
      @total_exp = (exp.to_f*@training_count*1.0).to_i
    elsif $game_variables[40] == 1
      @total_exp = (exp.to_f*@training_count*2.5).to_i + $game_actors[$partyc[$training_chara_num]].level * 30
    elsif $game_variables[40] >= 2
      @total_exp = (exp.to_f*@training_count*10).to_i + $game_actors[$partyc[$training_chara_num]].level * 150
    end
    
    #人造人間編までは回数のボーナスを入れない
    if $game_variables[40] >= 2
    
      if @training_count >= 99
        @total_exp = @total_exp*12
      elsif @training_count >= 90
        @total_exp = @total_exp*9
      elsif @training_count >= 80
        @total_exp = @total_exp*8
      elsif @training_count >= 70
        @total_exp = @total_exp*7
      elsif @training_count >= 60
        @total_exp = @total_exp*6
      elsif @training_count >= 50
        @total_exp = @total_exp*5
      elsif @training_count >= 40
        @total_exp = @total_exp*4
      elsif @training_count >= 30
        @total_exp = @total_exp*3
      elsif @training_count >= 20
        @total_exp = @total_exp*2
      elsif @training_count >= 10
        @total_exp = @total_exp*1.5
      end
    end
    
    @total_exp = @total_exp.prec_i
    
    @total_exp = 0 if @training_count == 0
    
    #修行失敗なら取得経験値半減
    if @tra_success == false
      @total_exp = (@total_exp.to_f / 2).ceil.to_i
    end
    
    @total_exp = @total_exp.to_i
    @msg_window.contents.clear
    
    temp_exp = get_exp_add $partyc[$training_chara_num],@total_exp.to_i
    
    $game_variables[305] += temp_exp
    text = "修行終了！　　経験値" + temp_exp.to_s + "を得た！"
    #text = "修行終了！　　経験値" + @total_exp.to_s + "を得た！"
    @msg_window.contents.draw_text( 0, 0, 600, 20, text)
    @msg_window.update
    if $game_variables[38] == 0
      Graphics.wait(60)
    else
      @msg_cursor.visible = true
      input_loop_run
      Graphics.wait(5)
    end
    
    old_level = $game_actors[$partyc[$training_chara_num]].level
    $game_actors[$partyc[$training_chara_num]].change_exp($game_actors[$partyc[$training_chara_num]].exp + temp_exp.to_i,false)
    #$game_actors[$partyc[$training_chara_num]].change_exp($game_actors[$partyc[$training_chara_num]].exp + @total_exp.to_i,false)
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
    
    #divide = 1
    #get_cap = (@training_count.to_f / divide).ceil.to_i
    
    if $game_variables[40] == 0
      divide = 1
    elsif $game_variables[40] == 1
      divide = 0.5
    elsif $game_variables[40] >= 2
      divide = 0.2
    end
    get_cap = (@training_count.to_f / divide).ceil.to_i
    #修行失敗なら取得経験値半減
    if @tra_success == false
      get_cap = (get_cap.to_f / 2).ceil.to_i
    end
    
    text = "キャパシティ　" + get_cap.to_s + "　を得た！"
    @msg_window.contents.clear
    @msg_window.contents.draw_text( 0, 0, 600, 20, text)
    @msg_window.update
    if $game_variables[38] == 0
      Graphics.wait(60)
    else
      Graphics.wait(5)
      @msg_cursor.visible = true
      input_loop_run
      #@msg_cursor.visible = false
      Graphics.wait(5)
    end
    $game_variables[25] += get_cap.to_i
    
    @msg_window.contents.clear
    if $game_variables[40] == 0
      divide = 1
    elsif $game_variables[40] == 1
      divide = 0.5
    elsif $game_variables[40] >= 2
      divide = 0.2
    end
    get_sp = (@training_count.to_f / divide).ceil.to_i
    
    #修行失敗なら取得経験値半減
    if @tra_success == false
      get_sp = (get_sp.to_f / 2).ceil.to_i
    end
    temp_sp = get_sp_add $partyc[$training_chara_num],get_sp.to_i
    text = "スキルポイント　" + temp_sp.to_s + "　を得た！"
    @msg_window.contents.clear
    @msg_window.contents.draw_text( 0, 0, 600, 20, text)
    @msg_window.update
    if $game_variables[38] == 0
      Graphics.wait(60)
    else
      Graphics.wait(5)
      @msg_cursor.visible = true
      input_loop_run
      #@msg_cursor.visible = false
      Graphics.wait(5)
    end
    
    #空欄の時は0をセット
    $cha_typical_skill[$partyc[$training_chara_num]] = [0] if $cha_typical_skill[$partyc[$training_chara_num]] == nil
    
    for x in 0..$cha_typical_skill[$partyc[$training_chara_num]].size-1
              
        #空欄の時は0をセット
        $cha_typical_skill[$partyc[$training_chara_num]][x] = 0 if $cha_typical_skill[$partyc[$training_chara_num]][x] == nil
        
        $cha_skill_spval[$partyc[$training_chara_num]] = [0] if $cha_skill_spval[$partyc[$training_chara_num]] == nil
        $cha_skill_spval[$partyc[$training_chara_num]][$cha_typical_skill[$partyc[$training_chara_num]][x]] = 0 if $cha_skill_spval[$partyc[$training_chara_num]][$cha_typical_skill[$partyc[$training_chara_num]][x]] == nil
        
        #最大値未満なら経験値を増加する
        $cha_skill_spval[$partyc[$training_chara_num]][$cha_typical_skill[$partyc[$training_chara_num]][x]] += temp_sp if $cha_skill_spval[$partyc[$training_chara_num]][$cha_typical_skill[$partyc[$training_chara_num]][x]] < $cha_skill_get_val[$cha_typical_skill[$partyc[$training_chara_num]][x]]
        
        #最大値を超えたら最大値に調整し取得文字を表示する
        if $cha_skill_spval[$partyc[$training_chara_num]][$cha_typical_skill[$partyc[$training_chara_num]][x]] >= $cha_skill_get_val[$cha_typical_skill[$partyc[$training_chara_num]][x]] && $cha_skill_set_flag[$partyc[$training_chara_num]][$cha_typical_skill[$partyc[$training_chara_num]][x]] != 1
          $cha_skill_spval[$partyc[$training_chara_num]][$cha_typical_skill[$partyc[$training_chara_num]][x]] = $cha_skill_get_val[$cha_typical_skill[$partyc[$training_chara_num]][x]]
          #セットしたことがあることにする
          $cha_skill_set_flag[$partyc[$training_chara_num]][$cha_typical_skill[$partyc[$training_chara_num]][x]] = 1
          #取得したフラグをON
          $cha_skill_get_flag[$partyc[$training_chara_num]][$cha_typical_skill[$partyc[$training_chara_num]][x]] = 1
        end
    end
    
    #追加スキル
    skillget_flag = false
    skillget_no = []
    skillget_flag,skillget_no = get_cha_sp_run $partyc[$training_chara_num],temp_sp
  
    #ZP
    divide = 2
    get_zp = (@training_count.to_f / divide).ceil.to_i
    
    #ZPの取得倍率を取得する
    zp_bairitu = get_zp_bairitu
    
    get_zp = get_zp * zp_bairitu
    
    #修行失敗なら取得経験値半減
    if @tra_success == false
      get_zp = (get_zp.to_f / 2).ceil.to_i
    end
    
    text = "ZP　" + get_zp.to_s + "　を得た！"
    @msg_window.contents.clear
    @msg_window.contents.draw_text( 0, 0, 600, 20, text)
    @msg_window.update
    if $game_variables[38] == 0
      Graphics.wait(60)
    else
      Graphics.wait(5)
      @msg_cursor.visible = true
      input_loop_run
      #@msg_cursor.visible = false
      Graphics.wait(5)
    end

    $zp[$partyc[$training_chara_num]] += get_zp.to_i
    
    #必殺技
    divide = 5
    
    get_tecp = (@training_count.to_f / divide).ceil.to_i
    
    #修行失敗なら取得経験値半減
    if @tra_success == false
      get_tecp = (get_tecp.to_f / 2).ceil.to_i
    end
    
    text = "ランダムで必殺技　使用回数が　合計　" + get_tecp.to_s + "　回分　増加した！"
    @msg_window.contents.clear
    @msg_window.contents.draw_text( 0, 0, 600, 20, text)
    @msg_window.update
    if $game_variables[38] == 0
      Graphics.wait(60)
    else
      Graphics.wait(5)
      @msg_cursor.visible = true
      input_loop_run
      #@msg_cursor.visible = false
      Graphics.wait(5)
    end

    #必殺技回数追加
    add_random_skill_num $partyc[$training_chara_num],get_tecp
        
    @msg_window.contents.clear
  end
  
  #--------------------------------------------------------------------------
  # ● キャラクター表示
  #
  #-------------------------------------------------------------------------- 
  def output_character
    
    #picture = Cache.picture($top_file_name + "戦闘_" + $data_actors[$partyc[$training_chara_num]].name)
    picture = Cache.picture(set_battle_character_name $partyc[$training_chara_num],0)
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
    
    if @anime_count != 63
      @anime_count += 1
    else
      @anime_count = 0
    end
    
    if @window_state == 7
      rect = Rect.new(0 , 0+(96*17), 96, 96)
    end
    @main_window.contents.blt(CHARA_WIN_X+28,CHARA_WIN_Y+6,picture,rect)
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