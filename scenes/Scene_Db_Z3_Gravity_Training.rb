#==============================================================================
# ■ Scene_Db_Z3_Gravity_Training
#------------------------------------------------------------------------------
# 　重力の修行表示
#==============================================================================
class Scene_Db_Z3_Gravity_Training < Scene_Base
  #カードウインドウ表示位置
  Chaxtyousei = 32
  Cardxstr = 10
  Cardystr = 330
  Cardxend = 680
  Cardyend = 210
  Cardsize = 64 #カードサイズ
  Cardoutputkizyun = 102 #カード表示基準位置

  CHARA_WIN_X =106+Chaxtyousei
  CHARA_WIN_Y =198-20-64
  TRA_WIN_X = 42+Chaxtyousei
  TRA_WIN_Y = 48
  CARD_WAIT = 30
  BTL_CARD_X = TRA_WIN_X+Cardsize+128-32
  BTL_CARD_Y = TRA_WIN_Y+32
  TRA_CARD_X = 640-TRA_WIN_X-Cardsize-128
  TRA_CARD_Y = TRA_WIN_Y+32
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
    #$partyc = [12]
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
      
    end
    @battle_hp = $game_actors[$partyc[0]].hp
    #@battle_hp = 1
    @battle_card_cursor_state = 0 #カーソル位置
    @old_card = nil
    @wait_count = 0
    @training_carda = []
    @training_cardg = []
    @training_cardi = []
    @training_card_visible = [false,false,false]
    @training_card_open = false
    @total_exp = nil
    @anime_count = 0
    @anime_count_plus_flag = true
    @training_card_num = 0
    @training_card_first_output = false
    @training_card_secand_output = false
    @battle_card_num = 0
    @battle_carda = []
    @battle_cardg = []
    @battle_cardi = []
    @battle_card_visible = [false,false,false]
    @battle_card_result = 1
    @cha_cutin_no = 0
    @msg_cursor = Sprite.new
    @msg_cursor.bitmap = Cache.picture("アイコン")
    @msg_cursor.visible = true
    @msg_cursor.src_rect = set_tate_cursor_blink
    @msg_cursor.x = 320-8
    @msg_cursor.y = 480-16#-14
    @msg_cursor.z = 255
    color =set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    @exp_sum = 0 #経験値合計
    @training_level = 100 #重力
    @kettei_se_flag = true
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
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------   
  def dispose_window
    @main_window.dispose
    @main_window = nil
    @msg_window.dispose
    @msg_window = nil
    @chahp_window.dispose
    @chahp_window = nil
    @trahp_window.dispose
    @trahp_window = nil
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
    @msg_window = Window_Base.new(0,480-128,640,128)
    @msg_window.opacity=255
    @msg_window.back_opacity=255
    @msg_window.contents.font.color.set( 0, 0, 0)
    # 味方HPウインドウ
    @chahp_window =  Window_Base.new(TRA_WIN_X,TRA_WIN_Y+128,128,64)
    # 重力ウインドウ
    @trahp_window =  Window_Base.new(640-TRA_WIN_X-128,TRA_WIN_Y+128,128,64)
  end
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------  
  def pre_update
    @main_window.contents.clear
    @msg_window.contents.clear
    @chahp_window.contents.clear
    @trahp_window.contents.clear
    #@tra_msg_window.contents.clear
    
    color =set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    color = Color.new(0,0,0,255)
    @main_window.contents.fill_rect(TRA_WIN_X,TRA_WIN_Y,128,128,color)
    color =set_skn_color 1
    
    
    output_msg            #メッセージ表示
    output_opponent       #対戦相手表示
    output_msgcursor if @msg_cursor.visible == true
    output_hp             #HP表示
    output_character      #キャラクター表示
    
    output_battle_card    #バトルカード表示
    output_training_card  #トレーニングカード更新
    output_cha_cutin
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
    @main_window.update
    
    if @wait_count != 0 
      @wait_count -= 1
    end
    
    if @window_state == 7 && @wait_count == 0
      @window_state = 10
      @wait_count = CARD_WAIT*3
      @battle_card_result = 1
      chk_add_training_card
    elsif @window_state == 10 && @wait_count == 0
      @training_card_open = true
      @wait_count = CARD_WAIT*2
      @window_state += 1
    elsif @window_state == 11 && @wait_count == 0
      chk_training
    end


    if Input.trigger?(Input::B)
      
    end  

    if Input.trigger?(Input::C)
      Audio.se_play("Audio/SE/" + $BGM_CursorOn) if @kettei_se_flag == true   # 効果音を再生する
      case @window_state
      when 0..3
        #@msg_cursor.visible = false
        @window_state += 1
        if @window_state == 4 
          @kettei_se_flag = false
          @msg_cursor.visible = false
          @wait_count = CARD_WAIT
          create_card 1
          create_card 0
        end
      when 4
        
      when 5
        if @battle_card_result == 1 #もう一枚カードを引く
          @window_state += 1
          @battle_card_visible[1] = true
          @battle_card_result = 1
        else
          @kettei_se_flag = false
          @window_state = 7
          @wait_count = CARD_WAIT*2
        end
      when 6
          @kettei_se_flag = false
          @window_state = 7
          @wait_count = CARD_WAIT*2
        if @battle_card_result == 1 
          @battle_card_visible[2] = true
          chk_training
        end
      when 7
        
      when 22 #負け
        @window_state += 1
        chk_damage
      when 23 #負け初期化
        @window_state = 4
        reset_variable
        @wait_count = CARD_WAIT
      when 24 #引き分け
        @window_state = 4
        reset_variable
        @wait_count = CARD_WAIT
      when 25 #勝ち
        @window_state += 1
        if @training_level == 300
          @window_state = 28
        end
      when 26 #勝ち初期化
        case @training_level
          
        when 100,200
          Audio.se_play("Audio/SE/" + "Z3 経験値取得")
          get_exp
        else
          
        end
        @training_level += 20
        @window_state = 4
        reset_variable
        @wait_count = CARD_WAIT
      when 27 #HP0
        @window_state = 31
      when 28 #修行終了
        @window_state = 30
        Audio.se_play("Audio/SE/" + "Z3 経験値取得")
        get_exp
      end
    end
    
    if Input.trigger?(Input::DOWN)

    end
    if Input.trigger?(Input::UP)

    end
    if Input.trigger?(Input::RIGHT)
      
      case @window_state
      when 5,6
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @battle_card_result = -@battle_card_result
      end
    end
    if Input.trigger?(Input::LEFT)
      case @window_state
      when 5,6
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @battle_card_result = -@battle_card_result
      end
    end

    if @window_state >= 30
      if @window_state == 30 #修行完了ならば
        #if $game_variables[43] == 23 || 25 || 27 || 28
        #$scene = Scene_Gameover.new
        #end
        $game_variables[41] += 1
      end
        $training_chara_num = nil
        #Audio.bgm_stop
        #Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
        Graphics.fadeout(20)
        #$game_variables[41] = 0       # 実行イベント初期化 
        $scene = Scene_Map.new
        #$game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動


    end
  end
  #--------------------------------------------------------------------------
  # ● 変数初期化
  #--------------------------------------------------------------------------
  def reset_variable
    @kettei_se_flag = false
    @anime_count_plus_flag = true
    @msg_cursor.visible = false
    @training_carda = []
    @training_cardg = []
    @training_cardi = []
    @training_card_visible = [false,false,false]
    @training_card_open = false
    @battle_carda = []
    @battle_cardg = []
    @battle_cardi = []
    @battle_card_visible = [false,false,false]
    @battle_card_result = 1
    @cha_cutin_no = 0
    create_card 1
    create_card 0
  end
  #--------------------------------------------------------------------------
  # ● 重力側のカードを追加するかチェック
  #--------------------------------------------------------------------------
  def chk_add_training_card
    
    probability = 0 #追加する確率
    rnd = rand(100)
    tra_carda = (@training_carda[0]+1) + (@training_carda[1]+1)
    
    case tra_carda
    
    when 0..8
      probability = 80 
    when 9
      probability = 70
    when 10
      probability = 60
    when 11
      probability = 40
    when 12
      probability = 20
    when 13
      probability = 15
    when 14
      probability = 10
    when 15
      probability = 5
    end
    
    if probability >= rnd #
      @training_card_visible[2] = true
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージウインドウの表示
  #--------------------------------------------------------------------------
  def output_msg
    cha_name = $game_actors[$partyc[0]].name
    # メッセージ表示
    if @window_state == 0
      @msg_window.contents.draw_text(0,0, 630, 20, cha_name + "の　重力修行だ！")
      @msg_window.contents.draw_text(0,25, 630, 20, "カードの星が　16になるように　うまく　カードを　調整しよう！")
    elsif @window_state == 1
      @msg_window.contents.draw_text(0,0, 630, 20, "２枚まで引けるが　カードは全て　オートだ！")
      @msg_window.contents.draw_text(0,25, 630, 20, "重力装置の　カードより　少なくても　16を超えても　失敗！")
      @msg_window.contents.draw_text(0,50, 630, 20, "ダメージを受けるぞ！")
    elsif @window_state == 2
      @msg_window.contents.draw_text(0,0, 630, 20, "初めは　重力100倍から　スタート！")
      @msg_window.contents.draw_text(0,25, 670, 20, "クリアするごとに　20ずつアップしていき　")
      @msg_window.contents.draw_text(0,50, 630, 20, "300倍を　クリアすると　終了だ！")
      @msg_window.contents.draw_text(0,75, 630, 20, "HPが　０になってしまうと　100倍からやり直しだ！")
    elsif @window_state == 3
      @msg_window.contents.draw_text(0,0, 630, 20, "一気に　クリアしろ！")
      @msg_window.contents.draw_text(0,25, 630, 20, "さあ　修行開始だ！")
    elsif @window_state == 4
      @msg_window.contents.draw_text(0,0, 630, 20, "重力装置が　カードを引いています…")
    elsif @window_state == 5
      text1 = cha_name+ "の番だ！"
      text2 = "もう１枚　カードを引きますか？"
      text3 = "　いる　　　いらない"
      @old_text1 = text1
      @old_text2 = text2
      @old_text3 = text3
      @msg_window.contents.draw_text(0,0, 600, 20, text1)
      @msg_window.contents.draw_text(0,25, 600, 20, text2)
      @msg_window.contents.draw_text(0,50, 600, 20, text3)
      $cursor_blink_count += 1
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      if @battle_card_result == 1
        @msg_window.contents.blt(0,77-25,picture,rect)
      else
        @msg_window.contents.blt(90,77-25,picture,rect)
      end
    elsif @window_state == 6
      text1 = "カードの星は　" + ((@battle_carda[0]+1)+(@battle_carda[1]+1)).to_s + "だ"
      text2 = "もう１枚　カードを引きますか？"
      text3 = "　いる　　　いらない"
      @old_text1 = text1
      @old_text2 = text2
      @old_text3 = text3
      @msg_window.contents.draw_text(0,0, 600, 20, text1)
      @msg_window.contents.draw_text(0,25, 600, 20, text2)
      @msg_window.contents.draw_text(0,50, 600, 20, text3)
      $cursor_blink_count += 1
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      if @battle_card_result == 1
        @msg_window.contents.blt(0,77-25,picture,rect)
      else
        @msg_window.contents.blt(90,77-25,picture,rect)
      end
    elsif @window_state == 7
      @msg_window.contents.draw_text(0,0, 600, 20, @old_text1)
      @msg_window.contents.draw_text(0,25, 600, 20, @old_text2)
      @msg_window.contents.draw_text(0,50, 600, 20, @old_text3)
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      if @battle_card_result == 1
        @msg_window.contents.blt(0,77-25,picture,rect)
      else
        @msg_window.contents.blt(90,77-25,picture,rect)
      end
    elsif @window_state == 10 || @window_state == 11
      @msg_window.contents.draw_text(0,25, 600, 20, "　　　　　　　　　　　　　　　勝負！　　　　　　　　　　　　　　")

    elsif @window_state == 21
      #@msg_window.contents.draw_text(0,0, 600, 20, "また一歩　修行のコツを　掴んだ！！")
      #@msg_window.contents.draw_text(0,25, 600, 20, "経験値" + @total_exp.to_s + "を得た！")
    elsif @window_state == 22
      @msg_window.contents.draw_text(0,0, 600, 20, cha_name + "は　" + @training_level.to_s + "倍の　重力に　耐えられなかった！")
      @msg_window.contents.draw_text(0,25, 600, 20, cha_name + "は　" + (@training_level/10).to_s + "のダメージを　受けた！")
    elsif @window_state == 23
      @msg_window.contents.draw_text(0,0, 600, 20, cha_name + "「くそ…　も　もう一度だ…！")
      @msg_window.contents.draw_text(0,25, 600, 20, "　この程度の　重力など　直ぐに　克服してやる…！」")

    elsif @window_state == 24 #引き分け
      @msg_window.contents.draw_text(0,0, 600, 20, "修行の効果は　得られなかった…")
    elsif @window_state == 25
      @msg_window.contents.draw_text(0,0, 600, 20, cha_name + "は　" + @training_level.to_s + "倍の　重力を　克服した！")
    elsif @window_state == 26 #この後経験値を取得
      @msg_window.contents.draw_text(0,0, 600, 20, "次は　" + (@training_level + 20).to_s + "倍の　重力に　挑戦だ！")
    elsif @window_state == 27
      @msg_window.contents.draw_text(0,0, 600, 20, cha_name + "は　あまりのダメージに　気を　失ってしまった……")
      #原作ではこのあと以下文章へ行き修行再開
      #ベジータ「くっ…　駄目だったか…
      #　だが　必ず　カカロットのヤツを　超えてやるぞ！」
      #@msg_window.contents.draw_text(0,0, 600, 20, cha_name + "は　" + @training_level.to_s + "倍の　重力に　耐えられなかった！")
    elsif @window_state == 28
      @msg_window.contents.draw_text(0,0, 600, 20, "やったぞ！　遂に300倍の　重力を　克服したぞ！")
    elsif @window_state == 31
      @msg_window.contents.draw_text(0,0, 600, 20, cha_name + "は　" + @training_level.to_s + "倍の　重力に　耐えられなかった！")

    end
  end
  #--------------------------------------------------------------------------
  # ● HP表示
  #--------------------------------------------------------------------------  
  def output_hp
    tyouseix = 80
    tyouseiy = 16
    pictureb = Cache.picture("数字英語")
    rect = Rect.new(0, 16, 32, 16) #HP
    @chahp_window.contents.blt(0,tyouseiy,pictureb,rect)
    rect = Rect.new(336, 16, 16, 16) #G
    @trahp_window.contents.blt(tyouseix,tyouseiy,pictureb,rect)

    for y in 1..@battle_hp.to_s.size #HP
      rect = Rect.new(@battle_hp.to_s[-y,1].to_i*16, 0, 16, 16)
      @chahp_window.contents.blt(tyouseix-(y-1)*16,tyouseiy,pictureb,rect)
    end

    for y in 1..@training_level.to_s.size #HP
      rect = Rect.new(@training_level.to_s[-y,1].to_i*16, 0, 16, 16)
      @trahp_window.contents.blt(tyouseix-16-(y-1)*16,tyouseiy,pictureb,rect)
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルカード表示
  #--------------------------------------------------------------------------  
  def output_battle_card
      # バトルカード表示

    picture = Cache.picture("カード関係")
    kasanex = 16
    kasaney = 32
    for x in 0..@battle_card_visible.size - 1
      
      if @battle_card_visible[x] == true
        recta = set_card_frame 0
        rectb = set_card_frame 2,@battle_carda[x] # 攻撃
        rectc = set_card_frame 3,@battle_cardg[x] # 防御
        #rectd = Rect.new(0 + 32 * 11, 0, 32, 32) # 流派
        rectd = Rect.new(32*($game_actors[$partyc[0]].class_id-1), 64, 32, 32) # 流派
        @main_window.contents.blt(BTL_CARD_X-x*kasanex,BTL_CARD_Y+x*kasaney,picture,recta)
        @main_window.contents.blt(BTL_CARD_X+2-x*kasanex+$output_card_tyousei_x,BTL_CARD_Y+2+$output_card_tyousei_y+x*kasaney,picture,rectb)
        @main_window.contents.blt(BTL_CARD_X+30-x*kasanex,BTL_CARD_Y+62+x*kasaney,picture,rectc)
        @main_window.contents.blt(BTL_CARD_X+16-x*kasanex,BTL_CARD_Y+32+x*kasaney,picture,rectd)
      end
      
    end
  end
  #--------------------------------------------------------------------------
  # ● トレーニングカード表示
  #--------------------------------------------------------------------------  
  def output_training_card
    
    if @window_state == 4 && @wait_count == 0
      
      if @training_card_visible[1] == true
        #@wait_count = CARD_WAIT
        @battle_card_visible[0] = true
        @window_state += 1
        @kettei_se_flag = true
      elsif @training_card_visible[0] == false
        @wait_count = CARD_WAIT
        @training_card_visible[0] = true
      else
        @wait_count = CARD_WAIT
        @training_card_visible[1] = true
      end
    end
    
    picture = Cache.picture("カード関係")
    kasanex = 16
    kasaney = 32
    for x in 0..@training_card_visible.size - 1
      
      if @training_card_visible[x] == true
        if @training_card_open == false
          rect = set_card_frame 1
          @main_window.contents.blt(TRA_CARD_X-x*kasanex,TRA_CARD_Y+x*kasaney,picture,rect)
        else
          recta = set_card_frame 0
          rectb = set_card_frame 2,@training_carda[x] # 攻撃
          rectc = set_card_frame 3,@training_cardg[x] # 防御
          rectd = Rect.new(0 + 32 * 11, 0, 32, 32) # 流派
          @main_window.contents.blt(TRA_CARD_X-x*kasanex,TRA_CARD_Y+x*kasaney,picture,recta)
          @main_window.contents.blt(TRA_CARD_X+2-x*kasanex+$output_card_tyousei_x,TRA_CARD_Y+2+$output_card_tyousei_y+x*kasaney,picture,rectb)
          @main_window.contents.blt(TRA_CARD_X+30-x*kasanex,TRA_CARD_Y+62+x*kasaney,picture,rectc)
          @main_window.contents.blt(TRA_CARD_X+16-x*kasanex,TRA_CARD_Y+32+x*kasaney,picture,rectd)
        end
      end
      
    end

  end
  #--------------------------------------------------------------------------
  # ● カットイン表示
  #--------------------------------------------------------------------------
  def output_cha_cutin
    picture = Cache.picture($top_file_name + "味方カットイン")
    rect = Rect.new(640*@cha_cutin_no, 64*($partyc[0]-3), 640, 64) # 背景上
    @main_window.contents.blt(0,480-128-64,picture,rect)
  end

  #--------------------------------------------------------------------------
  # ● カード生成
  #引数[n:キャラかトレーニング用か]
  #-------------------------------------------------------------------------- 
  def create_card n,card_no = 0
    
    if n == 0 #味方
      for x in 0..2
        @battle_carda[x] = rand(8)
        @battle_cardg[x] = 0
      end
    elsif n == 1 #トレーニング用
      for x in 0..2
        @training_carda[x] = rand(8)
        @training_cardg[x] = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● カード比較
  #引数[n:キャラかトレーニング用か]
  #-------------------------------------------------------------------------- 
  def chk_training
    btl_carda = 0
    tra_carda = 0
    result = 0
    if @window_state == 7
      btl_carda = @battle_carda[0]+1 + @battle_carda[1]+1 + @battle_carda[2]+1
      if btl_carda > 16
        result = 2
      end

    else
      if @battle_card_visible[2] == true
        btl_carda = @battle_carda[0]+1 + @battle_carda[1]+1 + @battle_carda[2]+1
      elsif @battle_card_visible[1] == true
        btl_carda = @battle_carda[0]+1 + @battle_carda[1]+1
      else
        btl_carda = @battle_carda[0]+1
      end
      
      if @training_card_visible[2] == true
        tra_carda = @training_carda[0]+1 + @training_carda[1]+1 + @training_carda[2]+1
      else
        tra_carda = @training_carda[0]+1 + @training_carda[1]+1
      end
      
      if tra_carda > 16 || btl_carda > tra_carda
        result = 1
      elsif btl_carda == tra_carda
        result = 3
      elsif btl_carda < tra_carda
        result = 2
      end
    end
    
    if result == 1 #勝ち
      @cha_cutin_no = 2
      @window_state = 25
      @kettei_se_flag = true
      @msg_cursor.visible = true
      @anime_count_plus_flag = false
    elsif result == 2 #負け
      @cha_cutin_no = 1
      @window_state = 22
      @kettei_se_flag = true
      @msg_cursor.visible = true
      Audio.se_play("Audio/SE/" + "Z1 ダメージ")    # 効果音を再生する
    elsif result == 3 #引き分け
      @window_state = 24
      @kettei_se_flag = true
      @msg_cursor.visible = true
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 経験値計算
  #
  #-------------------------------------------------------------------------- 
  def get_exp
    cha_name = $game_actors[$partyc[0]].name
    exp = 100000
    
    exp = exp * (@training_level/100)
    
    @total_exp = (exp).prec_i
    @msg_window.contents.clear
    text = cha_name + "は　" + @total_exp.to_s + "　経験値を得た！"
    @msg_window.contents.draw_text(0,0, 600, 20, text)
    @msg_window.update
    if $game_variables[38] == 0
      Graphics.wait(60)
    else
      @msg_cursor.visible = true
      input_loop_run
      Graphics.wait(5)
    end
    
    #@exp_sum += @total_exp.to_i
    @exp_sum = @total_exp.to_i
    #if @window_state >= 30 #修行終了
      @total_exp = @exp_sum
    
      old_level = $game_actors[$partyc[0]].level
      $game_actors[$partyc[0]].change_exp($game_actors[$partyc[0]].exp + @total_exp.to_i,false)
      if old_level != $game_actors[$partyc[0]].level
        #Audio.se_play("Audio/SE/" +$BGM_levelup_se)
        run_common_event 188 #レベルアップSEを鳴らす(MEを使うかをコモンイベントで定義)
        @msg_window.contents.clear
        text = $game_actors[$partyc[0]].name + "はレベル" + $game_actors[$partyc[0]].level.to_s + "になった！" 
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
    #end
      
  end
  #--------------------------------------------------------------------------
  # ● ダメージ処理
  #-------------------------------------------------------------------------- 
  def chk_damage
    

    @battle_hp -= @training_level/10
    if @battle_hp <= 0
      @battle_hp = 0
      @window_state = 27
    end
    

  end
  #--------------------------------------------------------------------------
  # ● 対戦相手を表示
  # 通常は重力装置
  #-------------------------------------------------------------------------- 
  def output_opponent
    #@main_window.contents.fill_rect(120,200,128,128,color)
    picture = Cache.picture("Z3_修行_重力装置")
    rect = Rect.new(0 , 0, 128, 128)
    @main_window.contents.blt(640-TRA_WIN_X-128,TRA_WIN_Y,picture,rect)
  end
  #--------------------------------------------------------------------------
  # ● キャラクター表示
  #
  #-------------------------------------------------------------------------- 
  def output_character
    
    picture = Cache.picture($top_file_name + "戦闘_" + $data_actors[$partyc[0]].name)
    
    case @anime_count
    
    when 0..15,80..95
      rect = Rect.new(0 , 0+(96*0), 96, 96)
    when 16..31,48..63
      rect = Rect.new(0 , 0+(96*1), 96, 96)
    when 32..47,64..79
      rect = Rect.new(0 , 0+(96*2), 96, 96)
    when 96..111,128..143
      rect = Rect.new(0 , 0+(96*3), 96, 96)
    when 112..127,144..159
      rect = Rect.new(0 , 0+(96*4), 96, 96)
    end
    
    if @anime_count_plus_flag == true
      if @anime_count != 159
        @anime_count += 1
      else
        @anime_count = 0
      end
    end
    if @window_state == 22 || @window_state == 23 || @window_state == 27
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