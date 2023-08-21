#==============================================================================
# ■ Scene_Db_Dajare_Training
#------------------------------------------------------------------------------
# 　界王様ダジャレ表示
#==============================================================================
class Scene_Db_Dajare_Training < Scene_Base
  include Share
  #カードウインドウ表示位置
  Cardxstr = 10
  Cardystr = 330
  Cardxend = 680
  Cardyend = 210
  Cardsize = 62 #カードサイズ
  TRA_WIN_X = 128
  TRA_WIN_Y = 0+11
  CHARA_WIN_X =64
  CHARA_WIN_Y =16+11
  DAJARE_WIN_X = 0
  DAJARE_WIN_Y = 96+11
  
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
      Audio.bgm_play("Audio/BGM/" + "Z3 ミニゲーム")    # 効果音を再生する
    elsif $game_variables[40] == 1
      Audio.bgm_play("Audio/BGM/" + "Z3 ミニゲーム")    # 効果音を再生する
    elsif $game_variables[40] >= 2
      Audio.bgm_play("Audio/BGM/" + "Z3 ミニゲーム")    # 効果音を再生する
    end
    @training_count = 0 #修行回数
    if $training_chara_num == nil
      @window_state = 0 #ウインドウ状態
    else
      @window_state = 2 #ウインドウ状態
    end
    @battle_card_cursor_state = 0 #カーソル位置
    @training_result = 0
    @total_exp = nil
    @roulette_mae_flag = true
    @roulette_count = 0
    @roulette_se_count = 0
    @roulette_se_flag = false
    @roulette_se = "Audio/SE/" + "Z3 カーソル移動"
    
    @roulette_surely_hit_flag = false #ルーレット必ず当たるフラグ
    @roulette_surely_hit_probability = 3 #3なら1/3であたる
    @hazure_se = "Audio/SE/" + "Z3 ハズレ"
    @exp_se = "Audio/SE/" + "Z3 経験値取得"
    @atari_se = "Audio/SE/" + "Z3 アタリ"
    @syare_mae=["お土産には","あなた　運送屋？","布団が","熊に　襲われて","電話に","魚が　オナラした"]
    @syare_ato=["モミアゲを　くれ！","うん　そうや！","吹っ飛んだ！","くまった　くまった！","誰も　出んわ！","ブリッ！"]
    @roulette_mae_result = []
    @roulette_ato_result = []
    @roulette_mae_no = 0
    @roulette_ato_no = 0
    @kettei_se_flag = true
    @msg_cursor = Sprite.new
    @msg_cursor.bitmap = Cache.picture("アイコン")
    @msg_cursor.visible = true
    @msg_cursor.src_rect = set_tate_cursor_blink
    @msg_cursor.x = 320-8
    @msg_cursor.y = 480 -16#-14
    @msg_cursor.z = 255
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
    @roulette_window1.dispose
    @roulette_window1 = nil
    @roulette_window2.dispose
    @roulette_window2 = nil
    @roulette_window3.dispose
    @roulette_window3 = nil
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
    @msg_window = Window_Base.new(0,480-128,640,128)
    @msg_window.opacity=255
    @msg_window.back_opacity=255
    @msg_window.contents.font.color.set( 0, 0, 0)
    # カードウインドウ作成(カード用)
    #@card_window = Window_Base.new(Cardxstr,Cardystr,Cardxend,Cardyend)
    #@card_window.opacity=0
    #@card_window.back_opacity=0
    # トレーニング結果メッセージウインドウ
    @tra_msg_window = Window_Base.new(TRA_WIN_X,TRA_WIN_Y,640-128,96)
    @tra_msg_window.opacity=255
    @tra_msg_window.back_opacity=255
    @tra_msg_window.contents.font.color.set( 0, 0, 0)
    dajare_win_size_y = 26+32+20
    @roulette_window1 = Window_Base.new(DAJARE_WIN_X,DAJARE_WIN_Y,640,dajare_win_size_y)
    @roulette_window2 = Window_Base.new(DAJARE_WIN_X,DAJARE_WIN_Y+dajare_win_size_y,640,dajare_win_size_y)
    @roulette_window3 = Window_Base.new(DAJARE_WIN_X,DAJARE_WIN_Y+dajare_win_size_y*2,640,dajare_win_size_y)
    @roulette_window1.contents.font.color.set( 0, 0, 0)
    @roulette_window2.contents.font.color.set( 0, 0, 0)
    @roulette_window3.contents.font.color.set( 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------  
  def pre_update
    @main_window.contents.clear
    #@card_window.contents.clear
    @msg_window.contents.clear
    @tra_msg_window.contents.clear
    @roulette_window1.contents.clear
    @roulette_window2.contents.clear
    @roulette_window3.contents.clear
    
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    #color = Color.new(0,0,0,255)
    #@main_window.contents.fill_rect(120,200,120,120,color)
    
    #output_training_card  #トレーニングカード更新
    output_msg            #メッセージ表示
    #output_battle_card    #バトルカード表示
    output_tra_msg        #トレーニング結果メッセージ表示
    #output_cursor         #カーソル表示
    output_character @training_result     #キャラクター表示
    output_roulette
    output_msgcursor if @msg_cursor.visible == true
    if @roulette_se_flag == true
      if @roulette_se_count == 2
        Audio.se_play(@roulette_se)    # 効果音を再生する
        @roulette_se_count = 0
      else
        @roulette_se_count += 1
      end
      #Audio.bgs_play(@roulette_se)    # 効果音を再生する
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    
    pre_update
    @msg_window.update
    #@card_window.update
    @main_window.update
    @tra_msg_window.update
    @roulette_window1.update
    @roulette_window2.update
    @roulette_window3.update
    if $training_chara_num == nil && @window_state == 1 #キャラクター選択
      chara_select
    end
    if Input.trigger?(Input::B)
      if @window_state == 0
        @window_state = 8
      end
    end  

    if Input.trigger?(Input::C)
      if @kettei_se_flag == true
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      end
      if @window_state == 0
        @window_state = 1
        @msg_cursor.visible = false
      elsif @window_state == 2
        @window_state += 1
        @msg_cursor.visible = false
        @roulette_se_flag = true
        @roulette_count += 1
        @training_result = 1
      elsif @window_state == 3 #ルーレット
          if @roulette_mae_flag == true
            @roulette_mae_result[@roulette_count] = @roulette_mae_no
            @roulette_mae_flag = false
          else
            @roulette_se_flag = false
            @roulette_ato_result[@roulette_count] = @roulette_ato_no
            
            #必ずあたるフラグの初期化
            @roulette_surely_hit_flag = false
            if rand(@roulette_surely_hit_probability-1) == 0
              @roulette_surely_hit_flag = true
            end
            #@roulette_surely_hit_flag = true
            
            roulette_loop = 3
            i = 0
            begin
              i += 1 
              Graphics.wait(10)
              @roulette_ato_result[@roulette_count] += 1
              @roulette_ato_result[@roulette_count] = 0 if @roulette_ato_result[@roulette_count] == @syare_ato.size
              @roulette_window1.contents.clear
              @roulette_window2.contents.clear
              @roulette_window3.contents.clear
              output_roulette
              Audio.se_play(@roulette_se)
              Graphics.update
              
              #必ずあたる場合は必ず当たるところまでループを繰り返す
              if i == roulette_loop &&
                @roulette_surely_hit_flag == true &&
                @roulette_mae_result[@roulette_count] != @roulette_ato_result[@roulette_count]
                roulette_loop += 1
                #p @roulette_mae_result,@roulette_ato_result,i,roulette_loop
              end
              
            end while i != roulette_loop
            
=begin
            for i in 1..roulette_loop
              Graphics.wait(10)
              @roulette_ato_result[@roulette_count] += 1
              @roulette_ato_result[@roulette_count] = 0 if @roulette_ato_result[@roulette_count] == @syare_ato.size
              @roulette_window1.contents.clear
              @roulette_window2.contents.clear
              @roulette_window3.contents.clear
              output_roulette
              Audio.se_play(@roulette_se)
              Graphics.update
              
              if i == roulette_loop &&
                @roulette_surely_hit_flag == true &&
                @roulette_mae_result[@roulette_count] != @roulette_ato_result[@roulette_count]
                p @roulette_mae_result,@roulette_ato_result
                roulette_loop += 1
              end
            end
=end
            @window_state += 1
            @kettei_se_flag = false
            chk_training_result
          end
          
        
      elsif @window_state == 4
        
        if @training_result == 2
          @training_result = 3
          Audio.se_play(@hazure_se)
        else
          @training_result = 5
          Audio.se_play(@atari_se)
        end
          if @roulette_count != 3
            Graphics.wait(20)
            @roulette_se_flag = true
            @roulette_count += 1
            @kettei_se_flag = true
            @roulette_mae_flag = true
            @window_state = 3
          else
            @roulette_count += 1
            @window_state = 5
            @roulette_window1.contents.clear
            @roulette_window2.contents.clear
            @roulette_window3.contents.clear
            output_roulette
            #output_character
            Graphics.update
            Graphics.wait(60)
          end
      end
      
      
    end
    
    if Input.trigger?(Input::DOWN)

    end
    if Input.trigger?(Input::UP)

    end
    if Input.trigger?(Input::RIGHT)

    end
    if Input.trigger?(Input::LEFT)

    end

    if @window_state >= 5
      if @window_state == 5
        Audio.se_play(@exp_se)
        get_exp
        #Graphics.wait(80)
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
  # ● ルーレット結果チェック
  #--------------------------------------------------------------------------
  def chk_training_result
    if @roulette_mae_result[@roulette_count] == @roulette_ato_result[@roulette_count]
      output_character 9
      Graphics.wait(60)
      @training_result = 4
      @training_count += 1
    else
      @training_result = 2
    end
    
  end
  #--------------------------------------------------------------------------
  # ● ルーレットウインドウの表示
  #--------------------------------------------------------------------------
  def output_roulette
    
    y_aki = 13
    aidamozi = "……"
    hazimemozi_x = 128
    aidamozi_x = 288
    atomozi_x = 352
    if @roulette_count >= 1
      
      @roulette_window1.contents.draw_text(0,y_aki, 600, 20, "１：")
      @roulette_window1.contents.draw_text(aidamozi_x,y_aki, 600, 20, aidamozi)
      if @roulette_mae_result[1] == nil
        @roulette_window1.contents.draw_text(hazimemozi_x,y_aki, 600, 20, @syare_mae[@roulette_mae_no])
        @roulette_mae_no += 1
        @roulette_mae_no = 0 if @roulette_mae_no == @syare_mae.size
      else
        @roulette_window1.contents.draw_text(hazimemozi_x,y_aki, 600, 20, @syare_mae[@roulette_mae_result[1]])
      end
      if @roulette_ato_result[1] == nil
        @roulette_window1.contents.draw_text(atomozi_x,y_aki, 600, 20, @syare_ato[@roulette_ato_no])
        @roulette_ato_no += 1
        @roulette_ato_no = 0 if @roulette_ato_no == @syare_ato.size
      else
        @roulette_window1.contents.draw_text(atomozi_x,y_aki, 600, 20, @syare_ato[@roulette_ato_result[1]])
      end
      
    end
    
    if @roulette_count >= 2
      
      @roulette_window2.contents.draw_text(0,y_aki, 600, 20, "２：")
      @roulette_window2.contents.draw_text(aidamozi_x,y_aki, 600, 20, aidamozi)
      if @roulette_mae_result[2] == nil
        @roulette_window2.contents.draw_text(hazimemozi_x,y_aki, 600, 20, @syare_mae[@roulette_mae_no])
        @roulette_mae_no += 1
        @roulette_mae_no = 0 if @roulette_mae_no == @syare_mae.size
      else
        @roulette_window2.contents.draw_text(hazimemozi_x,y_aki, 600, 20, @syare_mae[@roulette_mae_result[2]])
      end
      if @roulette_ato_result[2] == nil
        @roulette_window2.contents.draw_text(atomozi_x,y_aki, 600, 20, @syare_ato[@roulette_ato_no])
        @roulette_ato_no += 1
        @roulette_ato_no = 0 if @roulette_ato_no == @syare_ato.size
      else
        @roulette_window2.contents.draw_text(atomozi_x,y_aki, 600, 20, @syare_ato[@roulette_ato_result[2]])
      end
      
    end
    
    if @roulette_count >= 3
      
      @roulette_window3.contents.draw_text(0,y_aki, 600, 20, "３：")
      @roulette_window3.contents.draw_text(aidamozi_x,y_aki, 600, 20, aidamozi)
      if @roulette_mae_result[3] == nil
        @roulette_window3.contents.draw_text(hazimemozi_x,y_aki, 600, 20, @syare_mae[@roulette_mae_no])
        @roulette_mae_no += 1
        @roulette_mae_no = 0 if @roulette_mae_no == @syare_mae.size
      else
        @roulette_window3.contents.draw_text(hazimemozi_x,y_aki, 600, 20, @syare_mae[@roulette_mae_result[3]])
      end
      if @roulette_ato_result[3] == nil
        @roulette_window3.contents.draw_text(atomozi_x,y_aki, 600, 20, @syare_ato[@roulette_ato_no])
        @roulette_ato_no += 1
        @roulette_ato_no = 0 if @roulette_ato_no == @syare_ato.size
      else
        @roulette_window3.contents.draw_text(atomozi_x,y_aki, 600, 20, @syare_ato[@roulette_ato_result[3]])
      end
    end
    
    picture = Cache.picture("Z3_修行_界王ダジャレ")
    #当たり外れ判定
    if @roulette_count >= 2
      if @roulette_mae_result[1] == @roulette_ato_result[1]
        rect = Rect.new(128, 0, 32, 32)
      else
        rect = Rect.new(160, 0, 32, 32)
      end
      @roulette_window1.contents.blt(40,0,picture,rect)
    end
    
    if @roulette_count >= 3
      if @roulette_mae_result[2] == @roulette_ato_result[2]
        rect = Rect.new(128, 0, 32, 32)
      else
        rect = Rect.new(160, 0, 32, 32)
      end
      @roulette_window2.contents.blt(40,0,picture,rect)
    end
    
    if @roulette_count >= 4
      if @roulette_mae_result[3] == @roulette_ato_result[3]
        rect = Rect.new(128, 0, 32, 32)
      else
        rect = Rect.new(160, 0, 32, 32)
      end
      @roulette_window3.contents.blt(40,0,picture,rect)
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージウインドウの表示
  #--------------------------------------------------------------------------
  def output_msg

    # メッセージ表示
    
    case @window_state
    when 0,1
      @msg_window.contents.draw_text(0,0, 600, 20, "決定ボタンで　修行する　キャラクターの　選択だ！")
      @msg_window.contents.draw_text(0,25, 600, 20, "修行をしない場合は　キャンセルボタンで　終了だ！")
    when 2
      @msg_window.contents.draw_text(0,0, 600, 20, "言葉の　スロットマシーンだ！")
      @msg_window.contents.draw_text(0,25, 600, 20, "上手く止めて　界王様を　笑わせるような　シャレを　完成させよう！")
    when 3,4
      @msg_window.contents.draw_text(0,0, 600, 20, "３回チャンスが有り　多く笑わせたほうが　もらえる経験値も　多いぞ！")
      @msg_window.contents.draw_text(0,25, 600, 20, "さあ　挑戦だ！")

    end
  end
  #--------------------------------------------------------------------------
  # ● トレーニング結果ウインドウの表示
  #--------------------------------------------------------------------------
  def output_tra_msg
    text = ""
    text2 = ""
    case @training_result #修行メッセージ
    
    when 1
      text = "ふっふっふ…　ワシは　余程の"
      text2 = "シャレでないと　笑わないぞ…"
    when 2
      text = "何だ　それ…　全然ダメ！"
    when 3
      text = "無理だとは　思うが"
      text2 = "もう一度　聞いてやろう…"
    when 4
      text = "うぷぷ…　うはははははは！"
      text2 = "お主　只者では　ないな！"
    when 5
      text = "今度は　笑わんぞ！"
      text2 = "さあ　次だ！"
    else
      
    end
    
    @tra_msg_window.contents.draw_text(0,0, 600, 20, text)
    @tra_msg_window.contents.draw_text(0,25, 600, 20, text2)
  end
  
  #--------------------------------------------------------------------------
  # ● 修行するキャラクターの選択
  #-------------------------------------------------------------------------- 
  def chara_select
    
    #Graphics.wait(60)
    Graphics.fadeout(5)
    @window_state = 1
    $training_no = 0
    $scene = Scene_Db_Status.new 4
  end

  #--------------------------------------------------------------------------
  # ● 経験値計算
  #
  #-------------------------------------------------------------------------- 
  def get_exp
    
    exp = 0
    
    exp = $game_actors[$partyc[$training_chara_num]].level * 100
    
    @total_exp = exp*@training_count
    if $game_variables[40] == 0
      
    elsif $game_variables[40] == 1
      @total_exp = exp*@training_count*2
    elsif $game_variables[40] >= 2
      @total_exp = exp*@training_count*3
    end
    
    $game_variables[305] += @total_exp.to_i
    
    @msg_window.contents.clear
    temp_exp = get_exp_add $partyc[$training_chara_num],@total_exp.to_i
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
  
    divide = $game_actors[$partyc[$training_chara_num]].level / 2
    get_cap = (@training_count.to_f * divide).ceil.to_i
    
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
    divide = $game_actors[$partyc[$training_chara_num]].level / 3
    
    get_sp = (@training_count.to_f * divide).ceil.to_i
    
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
    divide = 8
    get_zp = (@training_count.to_f * divide).ceil.to_i
    
    #ZPの取得倍率を取得する
    zp_bairitu = get_zp_bairitu
    
    get_zp = get_zp * zp_bairitu
    
    #修行失敗なら取得経験値半減
    #if @tra_success == false
    #  get_zp = (get_zp.to_f / 2).ceil.to_i
    #end
    
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
    divide = 1
    
    get_tecp = (@training_count.to_f * divide).ceil.to_i
    
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
  def output_character n=0
    #picture = Cache.picture("Z3_修行_界王ダジャレ")
    

    picture = Cache.picture("Z3_修行_界王ダジャレ")
    
    case n
    
    when 9
      rect = Rect.new(0, 64, 128, 64)
      @main_window.contents.blt(CHARA_WIN_X-64,CHARA_WIN_Y,picture,rect)
    when 4
      rect = Rect.new(64, 0, 64, 64)
      @main_window.contents.blt(CHARA_WIN_X,CHARA_WIN_Y,picture,rect)
    else
      picture = Cache.picture("顔カード")
      rect = Rect.new($game_variables[40]*64, 64*25, 64, 64) #敵顔
      @main_window.contents.blt(CHARA_WIN_X,CHARA_WIN_Y,picture,rect)
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