#==============================================================================
# ■ Scene_Db_popo_Training
#------------------------------------------------------------------------------
# 　ポポ表示
#==============================================================================
class Scene_Db_Popo_Training < Scene_Base
  include Share
  #カードウインドウ表示位置
  Cardxstr = 10
  Cardystr = 330
  Cardxend = 680
  Cardyend = 210
  Cardsize = 62 #カードサイズ
  Haikeix = 96
  Haikeiy = 48
  #TRA_WIN_X = 128
  #TRA_WIN_Y = 0+11
  #CHARA_WIN_X =64
  #CHARA_WIN_Y =16+11
  #DAJARE_WIN_X = 0
  #DAJARE_WIN_Y = 96+11
  
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
    #@training_result = 0
    @training_result_par = 0
    @total_exp = nil
    @kettei_se_flag = true
    @roulette_se = "Audio/SE/" + "Z3 カーソル移動"
    @hazure_se = "Audio/SE/" + "Z3 ハズレ"
    @exp_se = "Audio/SE/" + "Z3 経験値取得"
    @atari_se = "Audio/SE/" + "Z3 アタリ"
    @msg_cursor = Sprite.new
    @msg_cursor.bitmap = Cache.picture("アイコン")
    @msg_cursor.visible = true
    @msg_cursor.src_rect = set_tate_cursor_blink
    @msg_cursor.x = 320-8
    @msg_cursor.y = 480 -16#-14
    @msg_cursor.z = 255
    @popo_output_frame_count = 0
    @popo_output_kind = 0 #ポポの現れる位置
    @popo_output_kind_pattern = [0,2,4,6,8,51,52,53]
    @popo_output_progres = 0 #出力の進行度、フキダシ中とかを管理
    @touch_result = 0
    @touch_count = 0
    @frame_count = 0 #フレーム間と
    @end_frame_count = 60*20
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    pre_update
    
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
  # ● スプライト開放
  #--------------------------------------------------------------------------
  def dispose_sprite
    @msg_cursor.bitmap = nil
    @msg_cursor = nil
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
  end
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------  
  def pre_update
    @main_window.contents.clear
    @msg_window.contents.clear
    
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    picture = Cache.picture("Z3_修行_神の神殿_背景")
    rect = Rect.new(0, 0, 448, 256)
    @main_window.contents.blt(Haikeix,Haikeiy,picture,rect)
    output_msg            #メッセージ表示
    output_msgcursor if @msg_cursor.visible == true
    output_popo if @window_state == 4 || @window_state == 5
    set_popo_strat if @window_state != 4 #|| @window_state != 5
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    
    pre_update
    @msg_window.update if @window_state != 4
    #@card_window.update
    @main_window.update if @window_state == 4 || @window_state == 5
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
      elsif @window_state == 2
        @window_state += 1
      elsif @window_state == 3
        @msg_cursor.visible = false
        @frame_count = 0
        @kettei_se_flag = false
        @window_state += 1
      elsif @window_state == 4 #開始
        
      end
      
      
    end
    
    if Input.trigger?(Input::DOWN)
      chk_touch_result 2
    end
    if Input.trigger?(Input::UP)
      chk_touch_result 8
    end
    if Input.trigger?(Input::RIGHT)
      chk_touch_result 6
    end
    if Input.trigger?(Input::LEFT)
      chk_touch_result 4
    end

    if @window_state >= 5
      
      if @window_state == 5
        @kettei_se_flag = true
        @msg_cursor.visible = true
        Audio.se_play(@exp_se)
        get_exp
      end
      #Graphics.wait(80)
      $training_chara_num = nil
      Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
      Graphics.fadeout(20)
      $game_variables[41] = 0       # 実行イベント初期化 
      $scene = Scene_Map.new
      $game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
    end
  end
  
  #--------------------------------------------------------------------------
  # ● タッチ結果チェック
  #--------------------------------------------------------------------------
  def chk_touch_result popo_output_kind
      if @popo_output_kind == popo_output_kind && @popo_output_progres == 1 && @touch_result == 0
        Audio.se_play(@atari_se) #アタリ
        @touch_count += 1
      elsif @touch_result == 0 && @window_state == 4
        Audio.se_play(@hazure_se) #ハズレ
        if @popo_output_kind == 51 || @popo_output_kind == 52 || @popo_output_kind == 53
          @training_count += 1
        end
      end
      @touch_result = 1
    
  end
  #--------------------------------------------------------------------------
  # ● カーソルの表示
  #--------------------------------------------------------------------------
  def output_msgcursor
    $cursor_blink_count += $msg_cursor_blink
    @msg_cursor.src_rect = set_tate_cursor_blink
  end
  
  #--------------------------------------------------------------------------
  # ● ポポの最初の表示
  #--------------------------------------------------------------------------
  def set_popo_strat
    @popo_output_frame_count = 5
    @popo_output_kind = 51
    @popo_output_progres = 1
    output_popo
  end
  #--------------------------------------------------------------------------
  # ● ポポの表示
  #--------------------------------------------------------------------------
  def output_popo
    @frame_count += 1

    
    if @popo_output_frame_count == 0 && @popo_output_kind == 0 && @end_frame_count < @frame_count
      @popo_output_kind = 51
    elsif @popo_output_frame_count == 0 && @popo_output_kind == 0
      @touch_result = 0
      
      if @training_count == 0 && @frame_count > 800 #800フレーム経過して全てセンターの場合
        @popo_output_kind = @popo_output_kind_pattern[rand(@popo_output_kind_pattern.size-4)+1]
      else
        @popo_output_kind = @popo_output_kind_pattern[rand(@popo_output_kind_pattern.size-1)+1]
      end
      @training_count += 1 if @popo_output_kind < 10
      #p @popo_output_kind
    end
    
    popo_frame_tomaru_hukidasi = 240
    popo_frame_tomaru_nagai = 80
    popo_frame_tomaru = 26
    popo_frame_arawareru = 4
    popo_frame_idou = 48
    
    put_x = 320
    put_y = 256+Haikeiy-32
    
    

    
    case @popo_output_kind
    
    when 0 #表示しない
      
    when 2 #下
      
      if @popo_output_progres == 1
        picture = Cache.picture("Z3_修行_神の神殿_ポポ_手前")
      else
        picture = Cache.picture("Z3_修行_神の神殿_ポポ移動_手前")
      end
      
      rect = Rect.new(0, 0, 64, 48)
      put_x -= 32
      put_y -= 48
    when 8 #上
      if @popo_output_progres == 1
        picture = Cache.picture("Z3_修行_神の神殿_ポポ_奥")
      else
        picture = Cache.picture("Z3_修行_神の神殿_ポポ移動_奥")
      end
      rect = Rect.new(0, 0, 28, 32)
      put_x -= 14
      put_y -= (32 + 156)
    when 4,6,51,52,53 #左、右、中央、中央止まる、中央フキダシ
      if @popo_output_progres == 1
        picture = Cache.picture("Z3_修行_神の神殿_ポポ_中央")
      else
        picture = Cache.picture("Z3_修行_神の神殿_ポポ移動_中央")
      end
      rect = Rect.new(0, 0, 32, 48)
      put_x -= 16
      put_y -= (48 + 80)
      case @popo_output_kind
      
      when 4
        put_x -=144
      when 6
        put_x +=144
      when 51,52,53
        
        if @popo_output_kind == 53 && @popo_output_frame_count < popo_frame_tomaru_hukidasi-popo_frame_tomaru_nagai && @popo_output_frame_count > popo_frame_arawareru
          picture2 = Cache.picture("Z3_修行_神の神殿_ポポ停止")
          rect2 = Rect.new(0, 0, 30, 48)
          @main_window.contents.blt(put_x+32,put_y-32,picture2,rect2)
        end
      end
    end
    

    
    if @popo_output_kind != 0
      @main_window.contents.blt(put_x,put_y,picture,rect)
      
      case @popo_output_progres
      
      when 0,2
        @popo_output_frame_count = popo_frame_arawareru if @popo_output_frame_count == 0
      when 1
        if @popo_output_kind == 52 
          @popo_output_frame_count = popo_frame_tomaru_nagai if @popo_output_frame_count == 0
        elsif @popo_output_kind == 53
          @popo_output_frame_count = popo_frame_tomaru_hukidasi if @popo_output_frame_count == 0
        else
          @popo_output_frame_count = popo_frame_tomaru if @popo_output_frame_count == 0
        end
      when 3
        @popo_output_frame_count = popo_frame_idou
        @popo_output_kind = 0
        @popo_output_progres = 0
         
      end
    end
    
    @popo_output_frame_count -= 1 if @popo_output_frame_count > 0
    
    if @popo_output_frame_count == 0 && @popo_output_kind != 0
      @popo_output_progres += 1
    end
    
    
    #フレーム数が終了フレームを超えたらオワリ
    if @end_frame_count < @frame_count && @popo_output_kind == 51 && @popo_output_progres == 2
      @window_state = 5
    end

    #@main_window.contents.draw_text(0,0, 600, 20, "総フレーム：" + @frame_count.to_s)
    #@main_window.contents.draw_text(0,25, 600, 20, "ポポ表示位置：" + @popo_output_kind.to_s)
    #@main_window.contents.draw_text(0,50, 600, 20, "ポポ表示残りフレーム：" + @popo_output_frame_count.to_s)
    #@main_window.contents.draw_text(0,75, 600, 20, "ポポ表示進行度：" + @popo_output_progres.to_s)
    #@main_window.contents.draw_text(0,100, 600, 20, "現れた回数：" + @training_count.to_s)
    #@main_window.contents.draw_text(0,125, 600, 20, "触れた回数：" + @touch_count.to_s)
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
      @msg_window.contents.draw_text(0,0, 600, 20, "ミスターポポの修行だ！")
      @msg_window.contents.draw_text(0,25, 600, 20, "ある時は　心を無にし　ある時は　すばやく動く")
      @msg_window.contents.draw_text(0,50, 600, 20, "ポポの　動きをうまく　捕らえろ！")
      @msg_window.contents.draw_text(0,75, 600, 20, "ポポの　動きに合わせて　十字キーを　押せ！")
    when 3
      @msg_window.contents.draw_text(0,0, 600, 20, "真ん中にいる時は　何も　押しちゃダメだぞ！")
      @msg_window.contents.draw_text(0,25, 600, 20, "20秒で　どれだけ　動きを　捕らえるか？")
      @msg_window.contents.draw_text(0,50, 600, 20, "決定ボタンを　押すと　スタートだ！")
    when 4
      @msg_window.contents.draw_text(0,0, 600, 20, "さあ　修行だ！")
    when 5
      @msg_window.contents.draw_text(0,0, 600, 20, "修行終了！")
    when 6
      @msg_window.contents.draw_text(0,0, 600, 20, "ポポの動きを" + @training_result_par +"パーセント　捕らえた！")
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
  # ● 経験値計算
  #
  #-------------------------------------------------------------------------- 
  def get_exp
    
    exp = 0
    
    exp = $game_actors[$partyc[$training_chara_num]].level * 120
    
    @training_result_par = (@touch_count*100/@training_count)
    #p exp,(@touch_count.prec_f/@training_count.prec_f),@training_result_par
    exp = exp * (@touch_count.prec_f/@training_count.prec_f)
    
    #割合によってさらに増加
    case @training_result_par
    when 100
      exp = (exp*2.7)
    when 75..99
      exp = (exp*2.2)
    when 50..74
      exp = (exp*1.9)
    when 25..49
      exp = (exp*1.6)
    when 15..24
      exp = (exp*1.3)
    end

    exp = exp.prec_i

    if $game_variables[40] == 0
      @total_exp = exp
    elsif $game_variables[40] == 1
      @total_exp = exp*2
    elsif $game_variables[40] >= 2
      @total_exp = exp*4
    end
    $game_variables[305] += @total_exp.to_i
    @msg_window.contents.clear
    temp_exp = get_exp_add $partyc[$training_chara_num],@total_exp.to_i
    text = "修行終了！　　経験値" + temp_exp.to_s + "を得た！"
    #text = "修行終了！　　経験値" + @total_exp.to_s + "を得た！"
    @msg_window.contents.draw_text( 0, 0, 600, 20, "ポポの動きを" + @training_result_par.to_s + "パーセント　捕らえた！")
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
 
    divide = $game_actors[$partyc[$training_chara_num]].level
    get_cap = ((@touch_count.prec_f/@training_count.prec_f) * divide).ceil.to_i
    
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
    divide = $game_actors[$partyc[$training_chara_num]].level
    
    get_sp = ((@touch_count.prec_f/@training_count.prec_f) * divide).ceil.to_i
    
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
    divide = 10
    get_zp = ((@touch_count.prec_f/@training_count.prec_f) * divide).ceil.to_i
    
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
    divide = 3
    
    get_tecp = ((@touch_count.prec_f/@training_count.prec_f) * divide).ceil.to_i
    
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