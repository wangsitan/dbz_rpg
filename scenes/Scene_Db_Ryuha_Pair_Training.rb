#==============================================================================
# ■ Scene_Db_Ryuha_Pair_Training
#------------------------------------------------------------------------------
# 　スピードと敏捷性を養う修行表示
#==============================================================================
class Scene_Db_Ryuha_Pair_Training < Scene_Base
  include Share
  #カードウインドウ表示位置
  Cardxstr = 10
  Cardystr = 330
  Cardxend = 680
  Cardyend = 210
  Cardsize = 64 #カードサイズ
  Cardoutputkizyun = 70 #カード表示基準位置
  TRA_CARD_X = 268
  TRA_CARD_Y = 212
  CHARA_WIN_X =106-38
  CHARA_WIN_Y =179
  TRA_WIN_X = 360
  TRA_WIN_Y = 220
  BTL_WIN_X = 320
  BTL_WIN_Y = 185
  BTL_CHA_PULS_X = 38
  BTL_CHA_PULS_Y = 32
  BTL_CHA2_PULS_X = 130
  Cardup = 22 #カード選択時に上がる量
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
    $game_variables[40] = 2
    create_window
    @chara_pattern = $game_variables[121] #ゴクウたちか、トランクスたちかなど
    
    #シナリオ進行度によってファイル名の頭文字を変える
    if $game_variables[40] == 0
      Audio.bgm_play("Audio/BGM/" + "Z1 修行")    # 効果音を再生する
    elsif $game_variables[40] == 1
      Audio.bgm_play("Audio/BGM/" + "Z2 修行")    # 効果音を再生する
    elsif $game_variables[40] == 2
      if @chara_pattern == 1 || @chara_pattern == 2 || @chara_pattern == 3
        Audio.bgm_play("Audio/BGM/" + "ZSB1 天界のテーマ(GB音源Ver)")    # 効果音を再生する
      else
        Audio.bgm_play("Audio/BGM/" + "Z3 修行")    # 効果音を再生する
      end
    end
    @training_count = [0,0,0,0] #修行回数

    if @chara_pattern == 0 #ゴクウ、ピッコロ、ゴハン
      @training_chara = [3,5,4]
    elsif @chara_pattern == 1 #ベジータ(超)、トランクス(超)
      @training_chara = [19,20]
    elsif @chara_pattern == 2 #ゴクウ(超)、ゴハン(超)
      @training_chara = [3,5]
    elsif @chara_pattern == 3 #クリリンたち
      @training_chara = $partyc
    end

    if @training_chara.size == 4
      @chara_win_x_chousei = -48
    else
      @chara_win_x_chousei = 0
    end
    #if @chara_pattern == 2
      #@chara_win_x_chousei = 48
    #else
      #@chara_win_x_chousei = 0
    #end
    #if $training_chara_num == nil
      @window_state = 0 #ウインドウ状態
    #else
    #  @window_state = 2 #ウインドウ状態
    #end
    @old_msg = []
    @exp_se = "Audio/SE/" + "Z3 経験値取得"
    @card_chg_count = 0
    @btl_anime_count = 0
    @btl_anime_no = 0
    @card_ryuha_blink_count = 0             #カード点滅カウント
    @set_cardryuha = nil
    @battle_card_cursor_state = 0 #カーソル位置
    @chara_cursor_state = 0 #キャラカーソル位置
    @old_card = nil
    @card_select=[false,false,false,false,false,false,false]
    @card_select_num=[nil,nil]
    @training_select_chara=[nil,nil]
    @total_exp = nil
    @anime_count = 0
    @msg_cursor = Sprite.new
    @msg_cursor.bitmap = Cache.picture("アイコン")
    @msg_cursor.visible = true
    @msg_cursor.src_rect = set_tate_cursor_blink
    @msg_cursor.x = 320-8
    @msg_cursor.y = 128 -16#-14
    @msg_cursor.z = 255
    @btl_chara = []
    @btl_chara[0] = Sprite.new
    #@btl_chara[0].bitmap = Cache.picture("アイコン")
    @btl_chara[0].visible = false
    #@btl_chara[0].src_rect = set_tate_cursor_blink
    @btl_chara[0].x = BTL_WIN_X + BTL_CHA_PULS_X-4
    @btl_chara[0].y = BTL_WIN_Y + BTL_CHA_PULS_Y-24
    @btl_chara[0].z = 254
    @btl_chara[1] = Sprite.new
    #@btl_chara[1].bitmap = Cache.picture("アイコン")
    @btl_chara[1].visible = false
    @btl_chara[1].mirror = true
    #@btl_chara[1].src_rect = set_tate_cursor_blink
    @btl_chara[1].x = BTL_WIN_X + BTL_CHA_PULS_X+60
    @btl_chara[1].y = BTL_WIN_Y + BTL_CHA_PULS_Y-24
    @btl_chara[1].z = 253
    @btl_anime_chg_count = 0 #アニメ変更回数
    @btl_clash = Sprite.new
    @btl_clash.bitmap = Cache.picture("戦闘アニメ")
    @btl_clash.visible = false
    @btl_clash.src_rect = Rect.new(32 , 16, 32, 32)
    @btl_clash.x = BTL_WIN_X + BTL_CHA_PULS_X-4 +64
    @btl_clash.y = BTL_WIN_Y + BTL_CHA_PULS_Y-24 +40
    @btl_clash.z = 255
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
  end 
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    # メインウインドウ
    @main_window = Window_Base.new(-16,-16,672,512)
    @main_window.opacity=0
    @main_window.back_opacity=0
    @main_window.contents.font.color.set( 0, 0, 0)
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
    
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    color = Color.new(0,0,0,255)
    @main_window.contents.fill_rect(BTL_WIN_X,BTL_WIN_Y,224,128,color)
    
    output_character      #キャラクター表示
    output_msg            #メッセージ表示
    output_battle_card    #バトルカード表示
    output_cursor if @msg_cursor.visible == false #カーソル表示
    output_msgcursor if @msg_cursor.visible == true      #メッセージカーソル表示
    output_btl_anime if @btl_anime_no != 0
    output_training_count
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
    

    #if $training_chara_num == nil && @window_state == 1 #キャラクター選択
    #  chara_select
    #end
    if Input.trigger?(Input::B)
      case @window_state
      
      when 3
        @card_select[@card_select_num[0]] = false
        @card_select_num[0] = nil
        @set_cardryuha = nil
        @window_state -= 1
      when 4
        @card_select[@card_select_num[1]] = false
        @card_select_num[1] = nil
        @window_state -= 1
        @chara_cursor_state = 0
        @training_select_chara=[nil,nil]
      when 5
        @window_state -= 1
        @training_select_chara=[nil,nil]
      end
        
      
    end  

    if Input.trigger?(Input::C)
      Audio.se_play("Audio/SE/" + $BGM_CursorOn) if @btl_anime_no == 0 && @window_state != 7 # 効果音を再生する
      if @window_state == 0
        #@msg_cursor.visible = false
        @window_state += 1
      elsif @window_state == 1
        @msg_cursor.visible = false
        @window_state += 1
      elsif @window_state == 2
        @window_state += 1
        @card_select[@battle_card_cursor_state] = true
        @card_select_num[0] = @battle_card_cursor_state
        @set_cardryuha = $cardi[@battle_card_cursor_state]
        @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,0,0,$Cardmaxnum+1)
      elsif @window_state == 3
          @window_state += 1
          @card_select[@battle_card_cursor_state] = true
          @chara_cursor_state = 0
          @card_select_num[1] = @battle_card_cursor_state
        if chk_card_ryuha != true
          @msg_cursor.visible = true
          @window_state = 15
          Audio.se_play("Audio/SE/" + "Z1 完了")    # 効果音を再生する
        end
      elsif @window_state == 4
        @window_state += 1
        @training_select_chara[0] = @chara_cursor_state
        @chara_cursor_state = chk_select_cursor_control(@chara_cursor_state,1,0,@training_select_chara.size-1,1)
        #@battle_card_cursor_state = chk_select_cursor_control(0,0,0,$Cardmaxnum+1)
      elsif @window_state == 5
        @window_state += 1
        @training_select_chara[1] = @chara_cursor_state
        @btl_anime_no = 1
      elsif @window_state == 15
        @window_state += 1
      end
      
      
    end
    
    if Input.trigger?(Input::DOWN)

    end
    if Input.trigger?(Input::UP)

    end
    if Input.trigger?(Input::RIGHT)
      
      if @window_state == 2 || @window_state == 3 #カード選択
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,1,0,$Cardmaxnum+1)
      elsif @window_state == 4 || @window_state == 5 #キャラ選択
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @chara_cursor_state = chk_select_cursor_control(@chara_cursor_state,1,0,@training_chara.size-1,1)
      end
    end
    if Input.trigger?(Input::LEFT)
      if @window_state == 2 || @window_state == 3 #カード選択
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,2,0,$Cardmaxnum+1)
      elsif @window_state == 4 || @window_state == 5 #キャラ選択
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @chara_cursor_state = chk_select_cursor_control(@chara_cursor_state,2,0,@training_chara.size-1,1)
      end
    end

    if @window_state >= 16
      #if @training_count.max != 0 #修行を途中で止めたときのみ経験値を計算
        get_exp
      #end
      
      if @old_card != nil
        create_card 0,@old_card
        #Graphics.wait(50)
      end
      
      $training_chara_num = nil
      #Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
      Graphics.fadeout(20)
      #$game_variables[41] = 0       # 実行イベント初期化
      $scene = Scene_Map.new
      #$game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
    end
  end
  
  #--------------------------------------------------------------------------
  # ● メッセージウインドウの表示
  #--------------------------------------------------------------------------
  def output_btl_anime
    picture = Cache.picture("戦闘アニメ")
    rect = Rect.new(0 , 48, 64, 64)
    btl_reset_flag = false #回数など初期化フラグ
    case @btl_anime_no
    
    when 1 #現れる
      anime_frame = 50
      #@btl_anime_count = anime_frame if @btl_anime_count == 0
      
      if @btl_anime_count % 2 == 0 && @btl_anime_count >= 20
        @main_window.contents.blt(BTL_WIN_X+BTL_CHA_PULS_X,BTL_WIN_Y+BTL_CHA_PULS_Y,picture,rect)
        @main_window.contents.blt(BTL_WIN_X+BTL_CHA2_PULS_X,BTL_WIN_Y+BTL_CHA_PULS_Y,picture,rect)
      end
    
    when 2 #戦う
      anime_frame = 260
      #@btl_anime_count = anime_frame if @btl_anime_count == 0
      chara0 = set_battle_character_name @training_chara[@training_select_chara[0]],0
      chara1 = set_battle_character_name @training_chara[@training_select_chara[1]],0
      #p chara0 , $top_file_name ,$data_actors[@training_chara[0]].name
      #p chara1
      anime_pattern = 0
      case @btl_anime_count
      when 0,28,44,60,76,92,108,116,132,148,164,180,196,212
        @btl_chara[0].bitmap = Cache.picture(chara0)
        @btl_chara[0].src_rect = Rect.new(0 , 96*anime_pattern, 96, 96)
        @btl_chara[0].visible = true
        @btl_chara[1].bitmap = Cache.picture(chara1)
        @btl_chara[1].src_rect = Rect.new(0 , 96*anime_pattern, 96, 96)
        @btl_chara[1].visible = true
        @btl_clash.visible = false
      when 20,156
        @btl_chara[0].src_rect = Rect.new(0 , 96*1, 96, 96)
        @btl_chara[1].src_rect = Rect.new(0 , 96*16, 96, 96)
        @btl_clash.visible = true
      when 36,172
        @btl_chara[0].src_rect = Rect.new(0 , 96*2, 96, 96)
        @btl_chara[1].src_rect = Rect.new(0 , 96*16, 96, 96)
        @btl_clash.visible = true
      when 52,124
        @btl_chara[0].src_rect = Rect.new(0 , 96*16, 96, 96)
        @btl_chara[1].src_rect = Rect.new(0 , 96*1, 96, 96)
      when 68,140
        @btl_chara[0].src_rect = Rect.new(0 , 96*16, 96, 96)
        @btl_chara[1].src_rect = Rect.new(0 , 96*2, 96, 96)
      when 84
        @btl_chara[0].src_rect = Rect.new(0 , 96*3, 96, 96)
        @btl_chara[1].src_rect = Rect.new(0 , 96*16, 96, 96)
        @btl_clash.visible = true
      when 100
        @btl_chara[0].src_rect = Rect.new(0 , 96*4, 96, 96)
        @btl_chara[1].src_rect = Rect.new(0 , 96*16, 96, 96)
        @btl_clash.visible = true
      when 188
        @btl_chara[0].src_rect = Rect.new(0 , 96*16, 96, 96)
        @btl_chara[1].src_rect = Rect.new(0 , 96*3, 96, 96)
      when 204
        @btl_chara[0].src_rect = Rect.new(0 , 96*16, 96, 96)
        @btl_chara[1].src_rect = Rect.new(0 , 96*4, 96, 96)
      when anime_frame
        @btl_chara[0].visible = false
        @btl_chara[1].visible = false
        @btl_clash.visible = false
      end
    end
    
    if @btl_anime_count == anime_frame
      @btl_anime_count = 0
      case @window_state
      
      when 6
        
        if @btl_anime_chg_count == 0
          @btl_anime_no = 2
        elsif @btl_anime_chg_count == 1
          @btl_anime_no = 1
        elsif @btl_anime_chg_count == 2
          btl_reset_flag = true
        end
        @btl_anime_chg_count += 1
      end
    else
      @btl_anime_count += 1
    end
    
    if btl_reset_flag == true
      @btl_anime_no = 0
      @btl_anime_chg_count = 0
      @btl_anime_count = 0
      @window_state += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージウインドウの表示
  #--------------------------------------------------------------------------
  def output_msg

    # メッセージ表示
    case @window_state
    
    when 0
      @msg_window.contents.draw_text(0,0, 600, 20, "カードの中から　流派の　ペアを　作り")
      @msg_window.contents.draw_text(0,25, 600, 20, "組み手を　行う　二人を　選ぼう！")
      @msg_window.contents.draw_text(0,50, 600, 20, "ペアが　出来なくなるまで　続けられるぞ！")
      @msg_window.contents.draw_text(0,75, 600, 20, "ただし　必の流派は　ペアに　出来ないぞ！")
    when 1..5
      #@msg_window.contents.draw_text(0,0, 600, 20, "ただし　Ｚの流派は　ペアに　出来ないぞ！")
      if @training_count.max == 0
        @msg_window.contents.draw_text(0,0, 630, 20, "そして　組み手を　行った分　経験が　得られるぞ！　がんばれ！")
      else
        @msg_window.contents.draw_text(0,0, 630, 20, @old_msg[0])
        @msg_window.contents.draw_text(0,50, 630, 20, @old_msg[1])
      end
      #@msg_window.contents.draw_text(0,50, 600, 20, "沢山クリアすれば　それだけ　経験値が　沢山貰えるぞ！")
    when 6
      
      if @chara_pattern == 0
        #ゴクウとピッコロ
        if @training_chara[@training_select_chara[0]] == 3 && @training_chara[@training_select_chara[1]] == 4 || @training_chara[@training_select_chara[0]] == 4 && @training_chara[@training_select_chara[1]] == 3
          @old_msg[0] = "悟空「ピッコロ！　おめえ　腕を上げたな」" 
          @old_msg[1] = "ピッコロ「てめえだけ　強くなるのは　しゃくだからな！」"

        #ゴクウとゴハン
        elsif @training_chara[@training_select_chara[0]] == 3 && @training_chara[@training_select_chara[1]] == 5 || @training_chara[@training_select_chara[0]] == 5 && @training_chara[@training_select_chara[1]] == 3
          @old_msg[0] = "悟空「どうした悟飯！　動きが　遅いぞ！」"
          @old_msg[1] = "悟飯「やーーーーーっ！」"
        #ピッコロと悟飯
        elsif @training_chara[@training_select_chara[0]] == 4 && @training_chara[@training_select_chara[1]] == 5 || @training_chara[@training_select_chara[0]] == 5 && @training_chara[@training_select_chara[1]] == 4
          @old_msg[0] = "ピッコロ「ふん…　そんな　攻撃では　ハエ１匹　落とせんぞ！」"
          @old_msg[1] = "悟飯「とーーーーーっ！」"
        end
      elsif @chara_pattern == 1
        #ベジータとトランクス
        if @training_chara[@training_select_chara[0]] == 19 && @training_chara[@training_select_chara[1]] == 20
          @old_msg[0] = "トランクス「父さん　すごい気合だ…」"
          @old_msg[1] = "ベジータ「はあーーーーーっ！」"
        #トランクスとベジータ
        elsif @training_chara[@training_select_chara[0]] == 20 && @training_chara[@training_select_chara[1]] == 19
          @old_msg[0] = "ベジータ「そんな事では　超サイヤ人を　超えることは出来んぞ！」"
          @old_msg[1] = "トランクス「てりゃーーーーーっ！」"
        end
      elsif @chara_pattern == 2
        #ゴクウとゴハン
        if @training_chara[@training_select_chara[0]] == 3 && @training_chara[@training_select_chara[1]] == 5
          @old_msg[0] = "悟空「オメーの力は　そんなもんじゃないはずだ　悟飯！」"
          @old_msg[1] = "悟飯「さすが　お父さんだ…　でも　僕も負けないよ！」" 
        #ゴハンとゴクウ
        elsif @training_chara[@training_select_chara[0]] == 5 && @training_chara[@training_select_chara[1]] == 3
          @old_msg[0] = "悟飯「この動き…　お父さんの狙いは！！」"
          @old_msg[1] = "悟空「良い読みだ…　だが　まだまだ　甘いぞ！」"
        end
      elsif @chara_pattern == 3
        #クリリンとヤムチャ
        if @training_chara[@training_select_chara[0]] == 6 && @training_chara[@training_select_chara[1]] == 7
          @old_msg[0] = "クリリン「手かげんなしで　お願いしますよ　ヤムチャさん！」"
          @old_msg[1] = "ヤムチャ「ああ　本気でやろうぜ　クリリン！」" 
        #クリリンとテンシンハン
        elsif @training_chara[@training_select_chara[0]] == 6 && @training_chara[@training_select_chara[1]] == 8
          @old_msg[0] = "クリリン「この動きは　武天老師さまの！？」"
          @old_msg[1] = "テンシンハン「よく分かったな　クリリン！」"
        #クリリンとチャオズ
        elsif @training_chara[@training_select_chara[0]] == 6 && @training_chara[@training_select_chara[1]] == 9
          @old_msg[0] = "クリリン「こうしていると　あの時の　天下一武道会を　思い出すよな」"
          @old_msg[1] = "チャオズ「もうあの手には　引っかからないよ！」"
        #ヤムチャとクリリン
        elsif @training_chara[@training_select_chara[0]] == 7 && @training_chara[@training_select_chara[1]] == 6
          @old_msg[0] = "ヤムチャ「クリリン　ずいぶん強くなったな！」"
          @old_msg[1] = "クリリン「ヤムチャさんだって！！」" 
        #ヤムチャとテンシンハン
        elsif @training_chara[@training_select_chara[0]] == 7 && @training_chara[@training_select_chara[1]] == 8
          @old_msg[0] = "ヤムチャ「今の　実力ならば！　この技で！！」"
          @old_msg[1] = "テンシンハン「何っ！！　いつの間に　ここまでの実力を！！」" 
        #ヤムチャとチャオズ
        elsif @training_chara[@training_select_chara[0]] == 7 && @training_chara[@training_select_chara[1]] == 9
          @old_msg[0] = "ヤムチャ「手加減しないぜ　チャオズ！！」"
          @old_msg[1] = "チャオズ「僕だって！！」" 
        #テンシンハンとクリリン
        elsif @training_chara[@training_select_chara[0]] == 8 && @training_chara[@training_select_chara[1]] == 6
          @old_msg[0] = "テンシンハン「この動きに　ついてこれるかな　クリリン！」"
          @old_msg[1] = "クリリン「初めてみたぞ！　何だこの動きは！？」" 
        #テンシンハンとヤムチャ
        elsif @training_chara[@training_select_chara[0]] == 8 && @training_chara[@training_select_chara[1]] == 7
          @old_msg[0] = "テンシンハン「本気でやり合うのは　あの日　以来だな！」"
          @old_msg[1] = "ヤムチャ「今度は　負けないぜ　テンシンハン！！」" 
        #テンシンハンとチャオズ
        elsif @training_chara[@training_select_chara[0]] == 8 && @training_chara[@training_select_chara[1]] == 9
          @old_msg[0] = "テンシンハン「本気で行くぞ　チャオズ！」"
          @old_msg[1] = "チャオズ「僕もだよ　テンさん！！」" 
        #チャオズとクリリン
        elsif @training_chara[@training_select_chara[0]] == 9 && @training_chara[@training_select_chara[1]] == 6
          @old_msg[0] = "チャオズ「１６＋２７は！？」"
          @old_msg[1] = "クリリン「４３！！　　９－１は！？」" 
        #チャオズとヤムチャ
        elsif @training_chara[@training_select_chara[0]] == 9 && @training_chara[@training_select_chara[1]] == 7
          @old_msg[0] = "チャオズ「足元が　お留守になってるよ！」"
          @old_msg[1] = "ヤムチャ「何でお前が　それを！！」" 
        #チャオズとテンシンハン
        elsif @training_chara[@training_select_chara[0]] == 9 && @training_chara[@training_select_chara[1]] == 8
          @old_msg[0] = "チャオズ「テンさん　僕と勝負だ！」"
          @old_msg[1] = "テンシンハン「ああ　本気で来い　チャオズ！！」" 
        end
      end
      @msg_window.contents.draw_text(0,0, 630, 20, @old_msg[0])
      @msg_window.contents.draw_text(0,50, 630, 20, @old_msg[1])
    when 15
      
      if @chara_pattern == 0
        @msg_window.contents.draw_text(0,0, 630, 20, "悟空「ふう…　このくらいで　ちょっと　休憩しねえか？」")
        @msg_window.contents.draw_text(0,50, 630, 20, "ピッコロ「いいだろう…」")
      elsif @chara_pattern == 1
        @msg_window.contents.draw_text(0,0, 630, 20, "ベジータ「今回は　このくらいに　してやろう」")
        @msg_window.contents.draw_text(0,50, 630, 20, "トランクス「はぁ…　はぁ…　さすが　父さんだ…」")
      elsif @chara_pattern == 2
        @msg_window.contents.draw_text(0,0, 630, 20, "悟空「がんばったな　悟飯！　今日はもう休もう！」")
        @msg_window.contents.draw_text(0,50, 630, 20, "悟飯「はい　お父さん！！」")
      elsif @chara_pattern == 3
        @msg_window.contents.draw_text(0,0, 630, 20, "チャオズ「疲れた…」")
        @msg_window.contents.draw_text(0,25, 630, 20, "クリリン「思った以上に　きついですね」")
        @msg_window.contents.draw_text(0,50, 630, 20, "ヤムチャ「今日は　このぐらいにしておこう！」")
        @msg_window.contents.draw_text(0,75, 630, 20, "テンシンハン「そうだな」")

      end

    end
    
  end

  #--------------------------------------------------------------------------
  # ● 流派チェック
  #--------------------------------------------------------------------------  
  def chk_card_ryuha
    if $cardi[@card_select_num[0]] != $cardi[@card_select_num[1]] || $cardi[@card_select_num[0]] == 0 || $cardi[@card_select_num[1]] == 0
      return false
    else
      return true
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルカード表示
  #--------------------------------------------------------------------------  
  def output_battle_card
      # バトルカード表示
      picture = Cache.picture("カード関係")
      
      for a in 1..7 do
        @card_ryuha_blink_count += 1 if a != 7
        cardup_y = 0
        if @card_select[a-1] == true
          cardup_y = Cardup
        end
        
        if @window_state != 7 || @card_chg_count % 2 != 0 || @card_select[a-1] == false
          recta = set_card_frame 0
          rectb = set_card_frame 2,$carda[a-1] # 攻撃
          rectc = set_card_frame 3,$cardg[a-1] # 防御
          rectd = Rect.new(0 + 32 * ($cardi[a-1]), 64, 32, 32) # 流派
          if @set_cardryuha != nil && @card_ryuha_blink_count <= 20 && @window_state <= 3
            #流派か必殺の場合は点滅させる
            if $cardi[a-1] == @set_cardryuha
              rectd = Rect.new(32 * ($cardi[a-1]), 240, 32, 32) # 流派
            end
          else
            if @card_ryuha_blink_count >= 40
              @card_ryuha_blink_count = 0
            end 
          end
            
          @card_window.contents.blt(Cardoutputkizyun + Cardsize * (a-1),24-cardup_y,picture,recta)
          @card_window.contents.blt(Cardoutputkizyun + 2 + Cardsize * (a-1)+$output_card_tyousei_x,26+$output_card_tyousei_y-cardup_y,picture,rectb)
          @card_window.contents.blt(Cardoutputkizyun + 30 + Cardsize * (a-1),86-cardup_y,picture,rectc)
          @card_window.contents.blt(Cardoutputkizyun + 16 + Cardsize * (a-1),56-cardup_y,picture,rectd)
        else
          recta = set_card_frame 1
          @card_window.contents.blt(Cardoutputkizyun + Cardsize * (a-1),24-cardup_y,picture,recta)
        end
      end
      @card_chg_count += 1 if @window_state == 7
      
      if @card_chg_count == 40
        @card_chg_count = 0
        create_card 0,@card_select_num[0]
        create_card 0,@card_select_num[1]
        @training_count[@training_select_chara[0]] += 1
        @training_count[@training_select_chara[1]] += 1
        #変数初期化
        @card_select_num = [nil,nil]
        @training_select_chara= [nil,nil]
        @card_select=[false,false,false,false,false,false,false]
        @set_cardryuha = nil
        @battle_card_cursor_state = 0
        @window_state = 2
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
    if @window_state < 4
      @card_window.contents.blt(80 + Cardsize * @battle_card_cursor_state,8,picture,rect)
    elsif @window_state <= 6
      @main_window.contents.blt(CHARA_WIN_X + 52+@chara_win_x_chousei + 64 * @chara_cursor_state,CHARA_WIN_Y-10,picture,rect)
      
      if @window_state >= 5
        rect = set_tate_cursor_blink 0
        for a in 0..@training_select_chara.size-1 do
          if @training_select_chara[a] != nil
            
            @main_window.contents.blt(CHARA_WIN_X + 52 + @chara_win_x_chousei + 64 * @training_select_chara[a],CHARA_WIN_Y-10,picture,rect)
          end
        end
      end
    end
    
    
    
  end
  #--------------------------------------------------------------------------
  # ● カーソル数値の最適化
  #--------------------------------------------------------------------------   
  # x:対象の値 ,n:チェック種類 ,min左最小 ,max右最大
  # n:0:その場 1:右へ 2:左へ
  # rubyの使用が参照渡しのようなので年のためxをyへ格納する
  def chk_select_cursor_control(x,n,min,max,z=0)
    
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
      if z == 0
        if @card_select[y] == false then
          return y
        end
      else
        if @training_select_chara[0] != y then
          return y
        end
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
      #@training_carda = rand(8)
      #@training_cardg = rand(8)
      #@training_cardi = create_card_i 0
    end
  end

  #--------------------------------------------------------------------------
  # ● 経験値計算
  #
  #-------------------------------------------------------------------------- 
  def get_exp
    
    for a in 0..@training_chara.size-1 do
      exp = 0
      
      exp = $game_actors[@training_chara[a]].level * 250
      
      @total_exp = exp*@training_count[a]
      if $game_variables[40] == 0
        
      elsif $game_variables[40] == 1
        @total_exp = @total_exp*2
      elsif $game_variables[40] >= 2
        @total_exp = @total_exp*3
        
        if @chara_pattern == 0 #ゴクウ、ピッコロ、ゴハン
          @total_exp += 25000
        elsif @chara_pattern == 1 #ベジータ(超)、トランクス(超)
          @total_exp += 250000
        elsif @chara_pattern == 2 #ゴクウ(超)、ゴハン(超)
          @total_exp += 350000
        elsif @chara_pattern == 3 #クリリンたち
          @total_exp += 450000
        end
      end
      
      @msg_window.contents.clear
      Audio.se_play(@exp_se)
      text = $game_actors[@training_chara[a]].name + "は経験値" + @total_exp.to_s + "を得た！"
      @msg_window.contents.draw_text( 0, 0, 600, 20, text)
      @msg_window.update
      if $game_variables[38] == 0
        Graphics.wait(60)
        @msg_window.contents.clear
      else
        @msg_cursor.visible = true
        input_loop_run
        Graphics.wait(5)
      end
      
      old_level = $game_actors[@training_chara[a]].level
      $game_actors[@training_chara[a]].change_exp($game_actors[@training_chara[a]].exp + @total_exp.to_i,false)
      if old_level != $game_actors[@training_chara[a]].level
        #Audio.se_play("Audio/SE/" +$BGM_levelup_se)
        run_common_event 188 #レベルアップSEを鳴らす(MEを使うかをコモンイベントで定義)
        @msg_window.contents.clear
        text = $game_actors[@training_chara[a]].name + "はレベル" + $game_actors[@training_chara[a]].level.to_s + "になった！" 
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
      
      #熟練度も増やす
      
      
      if @chara_pattern == 0 #ゴクウ、ピッコロ、ゴハン
        get_tecp = 3
      elsif @chara_pattern == 1 #ベジータ(超)、トランクス(超)
        get_tecp = 10
      elsif @chara_pattern == 2 #ゴクウ(超)、ゴハン(超)
        get_tecp = 10
      elsif @chara_pattern == 3 #クリリンたち
        get_tecp = 5
      else
        get_tecp = 3
      end
      
      get_tecp += @training_count[a] / 2
      text = "全ての必殺技　使用回数が　" + get_tecp.to_s + "　回分　増加した！"
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
      for x in 0..$game_actors[@training_chara[a]].skills.size - 1
        
        target_tec = $game_actors[@training_chara[a]].skills[x].id
        #指定の必殺技がnullだったら0をセット(エラー回避)
        set_cha_tec_null_to_zero target_tec
        
        $cha_skill_level[target_tec] += get_tecp
        
        #最大値を超えたら最大値にあわせる
        $cha_skill_level[target_tec] = $cha_skill_level_max if $cha_skill_level[target_tec] > $cha_skill_level_max

      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 修行回数表示
  #
  #-------------------------------------------------------------------------- 
  def output_training_count
    color = set_skn_color 1
    picture = Cache.picture("数字英語")
    #for a in 1..@training_chara.size do
    for a in 1..@training_chara.size do
      @main_window.contents.fill_rect(CHARA_WIN_X+28+@chara_win_x_chousei+64*(a-1)+16,CHARA_WIN_Y+6+16+64,32,32,color)
      for y in 1..@training_count[a-1].to_s.size #HP
        rect = Rect.new(0+@training_count[a-1].to_s[-y,1].to_i*16, 0, 16, 16)
        @main_window.contents.blt(CHARA_WIN_X+28+@chara_win_x_chousei+64*(a-1)+16+16-(y-1)*16,CHARA_WIN_Y+6+32+64,picture,rect)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● キャラクター表示
  #
  #-------------------------------------------------------------------------- 
  def output_character
    #picture = Cache.picture($top_file_name + "顔味方")
    for a in 1..@training_chara.size do
      rect,picture = set_character_face 0,@training_chara[a-1]-3
      #rect = Rect.new(0 , 64*(@training_chara[a-1]-3), 64, 64)
      @main_window.contents.blt(CHARA_WIN_X+28+@chara_win_x_chousei+64*(a-1),CHARA_WIN_Y+6,picture,rect)
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