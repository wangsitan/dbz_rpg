#==============================================================================
# ■ Scene_Db_Bubbles_Training
#------------------------------------------------------------------------------
# 　バブルス修行
#==============================================================================
class Scene_Db_Bubbles_Training < Scene_Base
  
  SCROLL_TIP_SIZE = 1024  #スクロールさせる画像の大きさ
  #カードウインドウ表示位置
  Cardxstr = 10
  Cardystr = 330
  Cardxend = 680
  Cardyend = 210
  Cardsize = 64 #カードサイズ
  Cardoutputkizyun = 102 #カード表示基準位置
  TRA_CARD_X = 288
  TRA_CARD_Y = 14
  CHARA_WIN_X =106
  CHARA_WIN_Y =200
  TRA_WIN_X = 360
  TRA_WIN_Y = 220
  PICTURE = Cache.picture("Z1_顔イベント")
  RECT = Rect.new(0, 64*17, 64, 64) # バブルス
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
    $game_variables[51] += 1
    Audio.bgm_play("Audio/BGM/" + "Z1 界王修行")    # 効果音を再生する
    
    @scene_scroll_count = 0
    @chara_frame_count = 0
    @chara_anime = 0
    @chara_anime_turn = 0
    @z1_scenex = 224           #上背景位置X
    @z1_sceney = 46            #上背景位置Y
    @z1_scrollscenex = 0      #スクロール用上背景位置X
    @z1_scrollsceney = 160      #スクロール用上背景位置Y
    @ene1_x = @z1_scenex + 64 #上キャラ表示基準位置X
    @ene1_y = @z1_sceney + 32 #上キャラ表示基準位置Y
    @play_x = @z1_scenex + 64 #下キャラ(味方)表示基準位置X
    @play_y = @z1_scenex + 82 #下キャラ(味方)表示基準位置Y
    create_window
    @battle_card_cursor_state = 0
    @msgno = 0 #処理を修正するのが大変なので出力メッセージをWindowステート以外でも管理する
    @window_state = 0
    @card_select=[false,false,false,false,false,false]
    @training_carda = nil
    @training_cardg = nil
    @training_cardi = nil
    @total_exp = 0
    create_card 1
    @msg_cursor = Sprite.new
    @msg_cursor.bitmap = Cache.picture("アイコン")
    @msg_cursor.visible = true
    @msg_cursor.src_rect = set_tate_cursor_blink
    @msg_cursor.x = 320-8
    @msg_cursor.y = 128 -16#-14
    @msg_cursor.z = 255
    
    @pic_scroll_on = true #背景するクロールするか
    @pic_back = []
    @pic_back[0] = Sprite.new
    @pic_back[0].bitmap = Cache.picture("Z1_背景_スクロール_界王星")
    @pic_back[0].visible = true
    @pic_back[0].src_rect = Rect.new(0, 0, 1024, 160)
    @pic_back[0].x = @z1_scrollscenex
    @pic_back[0].y = @z1_scrollsceney 
    @pic_back[0].z = 200
    @pic_back[1] = Sprite.new
    @pic_back[1].bitmap = Cache.picture("Z1_背景_スクロール_界王星")
    @pic_back[1].visible = true
    @pic_back[1].src_rect = Rect.new(0, 0, 1024, 160)
    @pic_back[1].x = @z1_scrollscenex + 1024
    @pic_back[1].y = @z1_scrollsceney 
    @pic_back[1].z = 200
    @pic_back_scrollcount = [3,3,3,3,4]
    @pic_back_scrollcountno = 0
    @pic_baburus = []
    
    
    @pic_baburus[0] = Sprite.new
    @pic_baburus[0].bitmap = Cache.picture("Z1_走るバブルス")
    @pic_baburus[0].visible = true
    @pic_baburus[0].src_rect = Rect.new(50*@chara_anime, 0, 50, 36)
    @pic_baburus[0].x = 294 + 166
    @pic_baburus[0].y = @z1_scrollsceney+160-66
    @pic_baburus[0].z = 201
    @pic_baburus_chgcount = []
    @pic_baburus_chgcount[0] = [16,8,8,8,16]
    @pic_baburus_chgcountno = []
    @pic_baburus_chgcountno[0] = 0
    #@pic_baburus_actiontable = []
    #@pic_baburus_actiontable[0] = [0,2,1,2,3]
    
    @pic_baburus[1] = Sprite.new
    @pic_baburus[1].bitmap = Cache.picture("Z1_走るバブルス(ジャンプ)")
    @pic_baburus[1].visible = false
    @pic_baburus[1].src_rect = Rect.new(48*@chara_anime, 0, 48, 52)
    @pic_baburus[1].x = @pic_baburus[0].x + 2
    @pic_baburus[1].y = @pic_baburus[0].y - 16
    @pic_baburus[1].z = 201
    @pic_baburus_chgcount[1] = [16,8,8,8,16,8,8,8,16]
    @pic_baburus_chgcountno[1] = 0
    
    @pic_baburus[2] = Sprite.new
    @pic_baburus[2].bitmap = Cache.picture("Z1_走るバブルス(後ろ向き煽る)")
    @pic_baburus[2].visible = false
    @pic_baburus[2].src_rect = Rect.new(48*@chara_anime, 0, 48, 32)
    @pic_baburus[2].x = @pic_baburus[0].x + 2
    @pic_baburus[2].y = @pic_baburus[0].y + 4
    @pic_baburus[2].z = 201
    @pic_baburus_chgcount[2] = [16,16,16,16,16,16]#[8,8,8,8,8,8]
    @pic_baburus_chgcountno[2] = 0
    
    @pic_baburus[3] = Sprite.new
    @pic_baburus[3].bitmap = Cache.picture("Z1_走るバブルス(尻書き)")
    @pic_baburus[3].visible = false
    @pic_baburus[3].src_rect = Rect.new(48*@chara_anime, 0, 48, 24)
    @pic_baburus[3].x = @pic_baburus[0].x + 2
    @pic_baburus[3].y = @pic_baburus[0].y + 12
    @pic_baburus[3].z = 201
    @pic_baburus_chgcount[3] = [8,8,8,8,8,8,8,8,8,8,8,8]
    @pic_baburus_chgcountno[3] = 0
    
    #バブルス悟空が3回勝利で走り方が変わる
    @pic_baburus[4] = Sprite.new
    @pic_baburus[4].bitmap = Cache.picture("Z1_走るバブルス(普通に走る)")
    @pic_baburus[4].visible = false
    @pic_baburus[4].src_rect = Rect.new(54*@chara_anime, 0, 54, 36)
    @pic_baburus[4].x = @pic_baburus[0].x
    @pic_baburus[4].y = @pic_baburus[0].y
    @pic_baburus[4].z = 201
    @pic_baburus_chgcount[4] = [8,8,8,8,8,8]
    @pic_baburus_chgcountno[4] = 0
    
    #つかまる
    @pic_baburus[8] = Sprite.new
    @pic_baburus[8].bitmap = Cache.picture("Z1_走るバブルス(普通に走る)")
    @pic_baburus[8].visible = false
    @pic_baburus[8].src_rect = Rect.new(54*@chara_anime, 0, 54, 36)
    @pic_baburus[8].x = @pic_baburus[0].x
    @pic_baburus[8].y = @pic_baburus[0].y
    @pic_baburus[8].z = 201
    @pic_baburus_chgcount[8] = [4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]
    @pic_baburus_chgcountno[8] = 0
    
    @pic_baburus_actionend_flag = false
    
    
    @goku_frame_count = 0
    @goku_anime = 0
    @pic_goku = []
    @pic_goku_chgcount = []
    @pic_goku_chgcountno = []
    @pic_goku[0] = Sprite.new
    @pic_goku[0].bitmap = Cache.picture("Z1_走る悟空")
    @pic_goku[0].visible = true
    @pic_goku[0].src_rect = Rect.new(56*@goku_anime, 0, 56, 80)
    @pic_goku[0].x = 294 - 164
    @pic_goku[0].y = @z1_scrollsceney+160-66 - 44
    @pic_goku[0].z = 202
    
    @pic_goku[1] = Sprite.new
    @pic_goku[1].bitmap = Cache.picture("Z1_走る悟空(しゃがむ)")
    @pic_goku[1].visible = false
    @pic_goku[1].src_rect = Rect.new(56*@goku_anime, 0, 56, 80)
    @pic_goku[1].x = @pic_goku[0].x
    @pic_goku[1].y = @pic_goku[0].y
    @pic_goku[1].z = 202
    @pic_goku_chgcount[1] = [16,16,16,16,16,16]
    @pic_goku_chgcountno[1] = 0
    
    #捕まえる時の飛びつき
    @pic_goku[2] = Sprite.new
    @pic_goku[2].bitmap = Cache.picture("Z1_走る悟空(飛びつく)")
    @pic_goku[2].visible = false
    @pic_goku[2].src_rect = Rect.new(72*@goku_anime, 0, 72, 92)
    @pic_goku[2].x = @pic_goku[0].x
    @pic_goku[2].y = @pic_goku[0].y - 12
    @pic_goku[2].z = 202
    @pic_goku_chgcount[2] = [8,16,64]
    @pic_goku_chgcountno[2] = 0
    
    @pic_goku_actionend_flag = false
    gokuwinx = 40
    
    @pic_babukirikawari = 4
    #勝利していたら悟空を横に移動
    if $game_variables[431] != 0
      @pic_goku[0].x += gokuwinx * $game_variables[431]
      @player_win_num = $game_variables[431]
      
      #勝利回数でバブルスの表示も切り替える
      if @player_win_num > (@pic_babukirikawari - 1)
        @pic_baburus[0].visible = false
        @pic_baburus[4].visible = true
      end
    end
    
    @allpic_action_flag = false #カード勝利時の悟空とバブルスがアクション中
    @pic_baburus_action_no = 0 #バブルスのアクションNo
    @pic_goku_action_no = 0 #悟空のアクションNo
    @pic_baburus_action_flag = false #バブルスのアクション中フラグ
    @pic_goku_action_flag = false #悟空のアクション中フラグ
    
    @allpic_action_no = 0 #アクションする種類
    
    @allpic_action_goku_frame_count = 0
    @player_win_num = $game_variables[431] #カード勝利回数
    
    $training_chara_num = 0
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    @updateflag = true #画面更新フラグ
    @animationupdateflag = true #キャラの更新フラグ
    Graphics.fadein(10)
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------   
  def dispose_window
    if @main_window != nil
      @main_window.dispose
      @main_window = nil
    end
    
    if @msg_window != nil
      @msg_window.dispose
      @msg_window = nil
    end
    
    if @card_window != nil
      @card_window.dispose
      @card_window = nil
    end
  end 
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super

    dispose_sprite
    dispose_window
    $training_chara_num = nil
    #最後まで行けなかった時に途中再開するためにどこまで進んだかをセット
    $game_variables[431] = @player_win_num
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    @main_window = Window_Base.new(-16,-16,672,512)
    @main_window.opacity=0
    @main_window.back_opacity=0
    # メッセージウインドウ
    create_msg_window
    # カードウインドウ作成(カード用)
    @card_window = Window_Base.new(Cardxstr,Cardystr,Cardxend,Cardyend)
    @card_window.opacity=0
    @card_window.back_opacity=0
  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_msg_window
    # メッセージウインドウ
    @msg_window = Window_Base.new(0,0,640,128)
    @msg_window.opacity=255
    @msg_window.back_opacity=255
    @msg_window.contents.font.color.set( 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ開放
  #--------------------------------------------------------------------------   
  def dispose_msg_window
    @msg_window.dispose
    @msg_window = nil
  end 
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    
    if @updateflag == true
      @main_window.contents.clear
      @card_window.contents.clear
      if @msg_window != nil
        @msg_window.contents.clear
      end
      color = set_skn_color 0
      @main_window.contents.fill_rect(0,0,656,496,color)

      output_msg 
      output_training_card
      output_battle_card
      @updateflag = false
    end
    output_cursor if @window_state != 0 && @window_state != 3
    output_msgcursor if @msg_cursor.visible == true
    
    #画像更新
    #画面スクロール
    
    if @pic_scroll_on == true
      @scene_scroll_count += 1
      if @pic_back_scrollcount[@pic_back_scrollcountno] == @scene_scroll_count
        @scene_scroll_count = 0
        @pic_back_scrollcountno += 1
        if @pic_back_scrollcount.size == @pic_back_scrollcountno
          @pic_back_scrollcountno = 0
        end
        #背景スクロール
        @pic_back[0].x -= 2
        @pic_back[1].x -= 2
        
        #ループ処理
        if @pic_back[0].x == -1024
          @pic_back[0].x = 0
          @pic_back[1].x = 1024
        end
      end
    end

    
    #悟空更新
    @pic_goku[0].src_rect = Rect.new(56*@goku_anime, 0, 56, 80)

    if @allpic_action_flag == false
      
      if Input.trigger?(Input::C)
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        if @window_state == 0
          if @msgno == 0 || @msgno == 1
            @msgno += 1
          else
            @msg_cursor.visible = false
            dispose_msg_window
            @window_state = 1
          end
        elsif @window_state == 1
          @window_state = 2
          chk_training
        end
        @updateflag = true
      end
      
      if Input.trigger?(Input::RIGHT)
        if @window_state == 1
          Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
          @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,1,0,$Cardmaxnum)
          @updateflag = true
        end
        
      end
      if Input.trigger?(Input::LEFT)
        if @window_state == 1
          Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
          @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,2,0,$Cardmaxnum)
          @updateflag = true
        end
      end
    else
      
      #勝利時のアクションNo
      case @allpic_action_no
      
      when 0 #通常の勝利
        
        if @allpic_action_goku_frame_count / 2 < 20
          @allpic_action_goku_frame_count += 1
          
          if @allpic_action_goku_frame_count % 2 == 0
            #悟空更新
            @pic_goku[0].x += 2
          end
        
        else
          #@pic_scroll_on = false
          @chara_anime = 0
          @chara_frame_count = 0
          @pic_baburus_action_flag = true #バブルスのアクション中フラグ
          @pic_baburus_action_no = rand(2)+1 #バブルス尻書きなし
          @allpic_action_no = 99
          #@pic_goku_action_flag = true
          #@pic_goku_action_no = 0 #前に進むだけ
        end
      when 8 #バブルス君を捕まえる
        if @allpic_action_goku_frame_count / 2 < 20
          @allpic_action_goku_frame_count += 1
          
          if @allpic_action_goku_frame_count % 2 == 0
            #悟空更新
            @pic_goku[0].x += 2
          end
        else
          @chara_anime = 0
          @chara_frame_count = 0
          @pic_baburus_action_flag = true #バブルスのアクション中フラグ
          @pic_baburus_action_no = 8
          @pic_goku_action_flag = true
          @pic_goku_action_no = 8
          @goku_frame_count = 0
          @goku_anime = 0
          @allpic_action_no = 99
        end
      when 9 #負け
        @pic_scroll_on = false
        @chara_anime = 0
        @chara_frame_count = 0
        @pic_baburus_action_flag = true #バブルスのアクション中フラグ
        @pic_baburus_action_no = rand(3)+1
        @pic_goku_action_flag = true
        @pic_goku_action_no = 9
        @goku_frame_count = 0
        @goku_anime = 0
        @allpic_action_no = 99
      when 99 #何もしない
          
        
      end
      
      
    end
    
    if @pic_goku_action_flag != true
      @pic_goku[0].visible = true
      #悟空の歩行アニメ更新
      if @goku_frame_count == 8
        @goku_frame_count = 0
        @goku_anime += 1
        if @goku_anime == 8
          @goku_anime = 0
        end
      end
    else
      #悟空のアクションアニメ表示
      @pic_goku[0].visible = false
      
      case @pic_goku_action_no
      when 8 #捕まえる
        gokuno = 2
        @pic_goku[gokuno].visible = true
        case @pic_goku_chgcountno[gokuno]
        
        when 0
          @pic_scroll_on = false
          @pic_goku[0].visible = false
          @pic_goku[gokuno].x = @pic_goku[0].x
          @pic_goku[gokuno].visible = true
        when 1
          @pic_goku[gokuno].x = @pic_goku[0].x+32
        when 2
          @pic_goku[gokuno].x = @pic_goku[0].x+48
        end
        
        @pic_goku[gokuno].src_rect = Rect.new(72*@goku_anime, 0, 72,92)
        if @goku_frame_count >= @pic_goku_chgcount[gokuno][@goku_anime]
          @goku_frame_count = 0
          
          @pic_goku_chgcountno[gokuno] += 1

          case @pic_goku_chgcountno[gokuno]
          
          when 0..2
            @goku_anime = @pic_goku_chgcountno[gokuno]
          when 3
            @pic_goku_actionend_flag = true
          end
        end

      when 9 #負け(しゃがむ)
        gokuno = 1
        @pic_goku[gokuno].visible = true
        #@pic_baburus_chgcount[1] = [16,8,8,8,16,8,8,8,16]
        
        @pic_goku[gokuno].x = @pic_goku[0].x
        @pic_goku[gokuno].src_rect = Rect.new(56*@goku_anime, 0, 56, 80)
        if @goku_frame_count >= @pic_goku_chgcount[gokuno][@goku_anime]
          @goku_frame_count = 0
          
          @pic_goku_chgcountno[gokuno] += 1

          case @pic_goku_chgcountno[gokuno]
          
          when 0..1
            @goku_anime = @pic_goku_chgcountno[gokuno]
          when 2..3
            @goku_anime = @pic_goku_chgcountno[gokuno] - 2
          when 4..5
            @goku_anime = @pic_goku_chgcountno[gokuno] - 4
          when 6
            @pic_goku_actionend_flag = true
          end
        end
        

      end
      
      if @pic_goku_actionend_flag == true
        @goku_frame_count = 0
        #@pic_goku_chgcountno[0] = 0
        @pic_goku_chgcountno[gokuno] = 0
        @pic_goku[0].visible = true if @player_win_num != 6
        @pic_goku[gokuno].visible = false if @player_win_num != 6
        @pic_goku_action_flag = false
        @goku_anime = 0
        @allpic_action_goku_frame_count = 0
        @pic_goku_actionend_flag = false

        if @pic_baburus_action_flag == false
          #p "悟空側で初期化"
          @updateflag = true 
          @pic_scroll_on = true
          @allpic_action_flag = false
        end
      end
    end
    
    if @pic_baburus_action_flag != true
      #バブルスの歩行アニメ

      if @player_win_num > (@pic_babukirikawari - 1)
        baburusno = 4
        @pic_baburus[0].visible = false
        @pic_baburus[baburusno].visible = true
        @pic_baburus[baburusno].src_rect = Rect.new(54*@chara_anime, 0, 54, 36)
        @pic_baburus[baburusno].x = @pic_baburus[0].x
        
        if @chara_frame_count >= @pic_baburus_chgcount[baburusno][@pic_baburus_chgcountno[baburusno]]
          @chara_frame_count = 0
          
          @pic_baburus_chgcountno[baburusno] += 1
          
          if @pic_baburus_chgcount[baburusno].size == @pic_baburus_chgcountno[baburusno]
            @pic_baburus_chgcountno[baburusno] = 0
          end
          case @pic_baburus_chgcountno[baburusno]
          
          when 0,2,4
            @chara_anime = 0
          when 1,3
            @chara_anime = 1
          when 5
            @chara_anime = 2
          end
        end
      else
        baburusno = 0
        @pic_baburus[baburusno].visible = true
        @pic_baburus[4].visible = false
        #バブルス更新
        @pic_baburus[baburusno].src_rect = Rect.new(50*@chara_anime, 0, 50, 36)
        if @chara_frame_count >= @pic_baburus_chgcount[baburusno][@pic_baburus_chgcountno[baburusno]]
          @chara_frame_count = 0
          
          if @chara_anime == 0
            @chara_anime_turn = +1
          elsif @chara_anime == 3
            @chara_anime_turn = -1
          end

          @pic_baburus_chgcountno[baburusno] += @chara_anime_turn

          case @pic_baburus_chgcountno[baburusno]
          
          when 0
            @chara_anime = 0
          when 1
            @chara_anime = 2
          when 2
            @chara_anime = 1
          when 3
            @chara_anime = 2
          when 4
            @chara_anime = 3
          end
        end
      end
    else
      @pic_baburus[0].visible = false
      @pic_baburus[4].visible = false
      #@pic_baburus_action_no = 3
      case @pic_baburus_action_no
      when 1 #その場でジャンプする
        baburusno = 1
        @pic_baburus[baburusno].visible = true
        #@pic_baburus_chgcount[1] = [16,8,8,8,16,8,8,8,16]
        @pic_baburus[baburusno].src_rect = Rect.new(48*@chara_anime, 0, 48, 52)
        @pic_baburus[baburusno].x = @pic_baburus[0].x + 2
        if @chara_frame_count >= @pic_baburus_chgcount[baburusno][@chara_anime]
          @chara_frame_count = 0
          
          @pic_baburus_chgcountno[baburusno] += 1

          case @pic_baburus_chgcountno[baburusno]
          
          when 0..3
            @chara_anime = @pic_baburus_chgcountno[baburusno]
          when 4..7
            @chara_anime = @pic_baburus_chgcountno[baburusno] - 4
          when 8
            @chara_anime = @pic_baburus_chgcountno[baburusno] - 8
          when 9
            @pic_baburus_actionend_flag = true
          end
        end

      when 2 #後ろ向いて煽る
        baburusno = 2
        @pic_baburus[baburusno].visible = true
        #@pic_baburus_chgcount[1] = [16,8,8,8,16,8,8,8,16]
        @pic_baburus[baburusno].src_rect = Rect.new(48*@chara_anime, 0, 48, 52)
        @pic_baburus[baburusno].x = @pic_baburus[0].x + 2
        if @chara_frame_count >= @pic_baburus_chgcount[baburusno][@chara_anime]
          @chara_frame_count = 0
          
          @pic_baburus_chgcountno[baburusno] += 1

          case @pic_baburus_chgcountno[baburusno]
          
          when 0..1
            @chara_anime = @pic_baburus_chgcountno[baburusno]
          when 2..3
            @chara_anime = @pic_baburus_chgcountno[baburusno] - 2
          when 4..5
            @chara_anime = @pic_baburus_chgcountno[baburusno] - 4
          when 6
            @pic_baburus_actionend_flag = true
          end
        end
      when 3 #寝る(尻書き)
        baburusno = 3
        @pic_baburus[baburusno].visible = true
        #@pic_baburus_chgcount[1] = [16,8,8,8,16,8,8,8,16]
        @pic_baburus[baburusno].src_rect = Rect.new(48*@chara_anime, 0, 48, 24)
        @pic_baburus[baburusno].x = @pic_baburus[0].x + 2
        if @chara_frame_count >= @pic_baburus_chgcount[baburusno][@chara_anime]
          @chara_frame_count = 0
          
          @pic_baburus_chgcountno[baburusno] += 1

          case @pic_baburus_chgcountno[baburusno]
          
          when 0..1
            @chara_anime = @pic_baburus_chgcountno[baburusno]
          when 2..3
            @chara_anime = @pic_baburus_chgcountno[baburusno] - 2
          when 4..5
            @chara_anime = @pic_baburus_chgcountno[baburusno] - 4
          when 6..7
            @chara_anime = @pic_baburus_chgcountno[baburusno] - 6
          when 8..9
            @chara_anime = @pic_baburus_chgcountno[baburusno] - 8
          when 10..11
            @chara_anime = @pic_baburus_chgcountno[baburusno] - 10
          when 12
            @pic_baburus_actionend_flag = true
          end
        end
      when 8 #つかまる
        baburusno = 8
        @pic_baburus[baburusno].visible = true
        @pic_baburus[baburusno].src_rect = Rect.new(54*@chara_anime, 0, 54, 36)
        @pic_baburus[baburusno].x = @pic_baburus[0].x
        
        if @chara_frame_count >= @pic_baburus_chgcount[baburusno][@pic_baburus_chgcountno[baburusno]]
          @chara_frame_count = 0
          @pic_baburus_chgcountno[baburusno] += 1
          
          
          case @pic_baburus_chgcountno[baburusno] % 5
          
          when 0,2,4
            @chara_anime = 0
          when 1,3
            @chara_anime = 1
          when 5
            @chara_anime = 2
          end
          
          if @pic_baburus_chgcount[baburusno].size == @pic_baburus_chgcountno[baburusno]
            @pic_baburus_actionend_flag = true
          end
        end
      end
      
      #アクションが終わったので初期化する
      if @pic_baburus_actionend_flag == true
        @chara_frame_count = 0
        @pic_baburus_chgcountno[0] = 0
        @pic_baburus_chgcountno[4] = 0
        @pic_baburus_chgcountno[baburusno] = 0
        #@pic_baburus[0].visible = true
        @pic_baburus[baburusno].visible = false if @player_win_num != 6
        @pic_baburus_action_flag = false
        @chara_anime = 0
        @pic_baburus_actionend_flag = false
        if @pic_goku_action_flag == false
          #p "バブルス側で初期化"
          @updateflag = true 
          @pic_scroll_on = true
          @allpic_action_flag = false
          @allpic_action_goku_frame_count = 0
        end
      end
    end
    
    @chara_frame_count += 1
    @goku_frame_count += 1

    
    #途中終了処理
    #未選択のカードがない
    #悟空とバブルスのアクションが一通り終わっている
    if @player_win_num == 6 && @allpic_action_flag == false
      @window_state = 3
      #@animationupdateflag = false
    elsif @player_win_num < 6 && @card_select.index(false) == nil && @allpic_action_flag == false #@pic_goku_action_flag == false && @pic_baburus_actionend_flag == false
      @window_state = 4 #失敗で終了
      #@animationupdateflag = false
    end

    
    if @window_state == 3 #修行終了
      Audio.se_play("Audio/se/" + "Z1 完了")# 効果音を再生する
      #Graphics.wait(20)
      create_msg_window
      get_exp
      Graphics.wait(30)
      $game_variables[41] = 99
      Graphics.fadeout(20)
      @main_window.contents.clear
      @card_window.contents.clear
      dispose_window
      $game_player.reserve_transfer(7,1,1, 0) # 場所移動
      $scene = Scene_Map.new
      
    elsif @window_state == 4 #修行失敗
      #Graphics.wait(60)
      Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
      Graphics.fadeout(20)
      $game_variables[41] = 0       # 実行イベント初期化 
      create_card 0,@battle_card_cursor_state
      $scene = Scene_Map.new
      $game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
    end
  end
  
  #--------------------------------------------------------------------------
  # ● メッセージウインドウの表示
  #--------------------------------------------------------------------------
  def output_msg
    
    if @window_state == 0
      if @msgno == 0
        @msg_window.contents.draw_text(0,0, 600, 20, "さあ　バブルス君を　捕まえろ！")
        @msg_window.contents.draw_text(0,25, 600, 20, "６回　バブルス君より　攻撃の星の数が　大きいカードを出すんだ！")
        @msg_window.contents.draw_text(0,50, 600, 20, "バブルス君のカードが　７の時は　１で　８の時は　２でも　勝てるぞ")
        @msg_window.contents.draw_text(0,75, 600, 20, "※プレイヤーの星が　上記の状態でも　負ける事はないぞ！")
      elsif @msgno == 1
        @msg_window.contents.draw_text(0,0, 600, 20, "負けても　カードを使い切るまで　続くぞ！")
        @msg_window.contents.draw_text(0,25, 600, 20, "途中で終わっても　前回終わったところから　再開できるんだ！")
        #@msg_window.contents.draw_text(0,50, 600, 20, "バブルス君のカードが　７の時は　１で　８の時は　２でも　勝てるぞ")
        #@msg_window.contents.draw_text(0,75, 600, 20, "※プレイヤーの星が　上記の状態でも　負ける事はないぞ！")        
      else
        @msg_window.contents.draw_text(0,0, 600, 20, "出来るだけ　早く　捕まえて　次の　修行に　進むんだ！")
        @msg_window.contents.draw_text(0,25, 600, 20, "急げ　悟空！")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● トレーニングカード表示
  #--------------------------------------------------------------------------  
  def output_training_card
    @main_window.contents.blt(TRA_CARD_X-66,TRA_CARD_Y+16,PICTURE,RECT)
    picture = Cache.picture("カード関係")
    if @window_state == 2 || @allpic_action_flag == true
      rect = set_card_frame 1
      @main_window.contents.blt(TRA_CARD_X,TRA_CARD_Y,picture,rect)
    else
      recta = set_card_frame 0
      rectb = set_card_frame 2,@training_carda # 攻撃
      rectc = set_card_frame 3,@training_cardg # 防御
      rectd = Rect.new(0 + 32 * (@training_cardi), 64, 32, 32) # 流派
      @main_window.contents.blt(TRA_CARD_X,TRA_CARD_Y,picture,recta)
      @main_window.contents.blt(TRA_CARD_X+2+$output_card_tyousei_x,TRA_CARD_Y+2+$output_card_tyousei_y,picture,rectb)
      @main_window.contents.blt(TRA_CARD_X+30,TRA_CARD_Y+62,picture,rectc)
      @main_window.contents.blt(TRA_CARD_X+16,TRA_CARD_Y+32,picture,rectd)
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
          @card_window.contents.blt(Cardoutputkizyun + 2 + Cardsize * (a-1)+$output_card_tyousei_x,26++$output_card_tyousei_y,picture,rectb)
          @card_window.contents.blt(Cardoutputkizyun + 30 + Cardsize * (a-1),86,picture,rectc)
          @card_window.contents.blt(Cardoutputkizyun + 16 + Cardsize * (a-1),56,picture,rectd)
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
  # ● カード比較
  #引数[n:キャラかトレーニング用か]
  #-------------------------------------------------------------------------- 
  def chk_training
    
    output_training_card
    @card_window.update
    if @training_carda <= $carda[@battle_card_cursor_state] || #単純に大きい
      @training_carda == 6 && $carda[@battle_card_cursor_state] == 0 || #バブルスが7で悟空が1
      @training_carda == 7 && $carda[@battle_card_cursor_state] == 1 #バブルスが8で悟空が2
      
      #Audio.se_play("Audio/SE/" + "Z2 アイテム取得")    # 効果音を再生する
      #勝利回数によってSEを変える
      case @player_win_num
      
      when 0..2
        Audio.se_play("Audio/SE/" + "Z1 SE111")
      when 2..4
        Audio.se_play("Audio/SE/" + "Z1 SE112")
      when 5..5
        Audio.se_play("Audio/SE/" + "Z1 SE113")
      end
      @card_select[@battle_card_cursor_state] = true
      create_card 1
      create_card 0,@battle_card_cursor_state
      #Graphics.wait(30)
      @window_state = 1
      
      @player_win_num += 1 #カード勝利回数
      
      case @player_win_num
      
      when 1..5
        @allpic_action_no = 0
        @allpic_action_flag = true

      when 6
        @allpic_action_no = 8
        @allpic_action_flag = true
      end

    else
      #負け
      Audio.se_play("Audio/SE/" + "Z1 SE110")
      
      @card_select[@battle_card_cursor_state] = true
      create_card 1
      create_card 0,@battle_card_cursor_state
      #Graphics.wait(30)
      @window_state = 1
      
      @allpic_action_no = 9
      @allpic_action_flag = true
      
    end

    if @player_win_num == 6
      #@window_state = 3
    else
      if @card_select.index(false) != nil
        #まだ未選択のカードがある
        @battle_card_cursor_state = chk_select_cursor_control(@battle_card_cursor_state,0,0,$Cardmaxnum)
      else
        #全てカードを選択した
        
      end
    end
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
    end
  end
  #--------------------------------------------------------------------------
  # ● 経験値計算
  #
  #-------------------------------------------------------------------------- 
  def get_exp
    
    exp = 1000
    
    @total_exp = exp
    @msg_window.contents.clear
    text = "修行終了！　　経験値" + @total_exp.to_s + "を得た！"
    @msg_window.contents.draw_text(0,0, 600, 20, "悟空「とうとう　やったーっ！！　捕まえたぞーっ！！！」")
    #@msg_window.contents.draw_text(0,25, 600, 20, "")
    @msg_window.contents.draw_text(0,50, 600, 20, text)
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
    
    #熟練度も増やす
    get_tecp = 10

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
    for x in 0..$game_actors[$partyc[$training_chara_num]].skills.size - 1
      
      target_tec = $game_actors[$partyc[$training_chara_num]].skills[x].id
      #指定の必殺技がnullだったら0をセット(エラー回避)
      set_cha_tec_null_to_zero target_tec
      
      $cha_skill_level[target_tec] += get_tecp
      
      #最大値を超えたら最大値にあわせる
      $cha_skill_level[target_tec] = $cha_skill_level_max if $cha_skill_level[target_tec] > $cha_skill_level_max

    end
  end
  #--------------------------------------------------------------------------
  # ● スプライト開放
  #--------------------------------------------------------------------------
  def dispose_sprite
    @msg_cursor.bitmap = nil
    @msg_cursor = nil
    
    @pic_back[0].bitmap = nil
    @pic_back[1].bitmap = nil
    @pic_back = nil
    @pic_baburus[0].bitmap = nil
    @pic_baburus[1].bitmap = nil
    @pic_baburus[2].bitmap = nil
    @pic_baburus[3].bitmap = nil
    @pic_baburus[4].bitmap = nil
    @pic_baburus[8].bitmap = nil
    @pic_baburus = nil
    @pic_goku[0].bitmap = nil
    @pic_goku[1].bitmap = nil
    @pic_goku[2].bitmap = nil
    @pic_goku = nil
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