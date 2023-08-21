#==============================================================================
# ■ Title_Anime
#------------------------------------------------------------------------------
# 　タイトルのアニメ表示
#==============================================================================
module Z_db3ed #< Scene_Base
include Share


   #--------------------------------------------------------------------------
  # ● Z3セルゲーム編オープニングタイトル表示メイン
  # カットイン暗転(一枚絵)
  #--------------------------------------------------------------------------   
  def db3ed
    
    #フレームレート初期化
    $fast_fps = false
    Graphics.frame_rate = 60
    
    
    @animeframe = 0    #総フレーム数
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0

    @back_pic = [] #背景画像
    @card_pic = [] #カードの画像
    @put_position = 0 #出力中の位置
    @put_chano = 0 #"出力中の味方キャラを表示" 
    @put_eneno = 0 #"出力中の敵キャラを表示" 
    @put_chaend_flag = false #味方キャラの表示完了
    @put_eneend_flag = false #敵キャラの表示完了
    end_frame = 119000 #12100
    result = 0
    $tmp_ene_order = []
    @chano = [3,4,5,6,7,8,9,10,24,15,12,17,25,21,22,23,16,27,28,29,30]
    @chano = [3,14,4,5,18,6,7,8,9,10,24,15,12,19,17,20,25,26,21,22,23,16,32,27,28,29,30] #超サイヤ人も混み
    update_eneput_flag #敵の出力範囲更新
    get_ene_history_list
    @eneno = Marshal.load(Marshal.dump($tmp_ene_order))
    color = Color.new(255,255,255,256)
    color2 = Color.new(188,188,188,256)
    color3 = Color.new(127,127,127,256)
    color4 = Color.new(0,0,0,256)
    
    pusharare_flag = false #アラレ表示時にボタンを押したか
    @card_back_color = set_skn_color 1
    #p @card_back_color.red
    #カード裏面格納
    @card_pic_filename = "カード関係"
    card_put_sx = 96
    card_put_sy = 48

    x = 0
    y = 0
    x_count = 0
    for x in 0..27
      #p "x:" + x.to_s,"y:" + y.to_s
      @card_pic[x] = Sprite.new
      @card_pic[x].bitmap = Bitmap.new("Graphics/Pictures/" + @card_pic_filename)
      @card_pic[x].src_rect = set_card_frame 1
      @card_pic[x].x = card_put_sx + x_count * 64
      @card_pic[x].y = card_put_sy + y * 96
      @card_pic[x].visible = true
      @card_pic[x].z = 100
      x_count += 1
      
      if x_count == 7
        x_count = 0
        y += 1
      end
    end
    @cha_pic = Sprite.new
    @cha_pic.visible = false
    @cha_pic.z = 110
    card_put_frame = 24 #32 #表示しているフレーム数
    card_noput_frame = 16 #32 #表示していないフレーム数

    card_put_frame_extend = false
    card_frame_count = 0
    card_put_flag = false
    Audio.bgm_play("Audio/BGM/" +"DB3 エンディング")
    
    #デバッグ用
    #@put_chaend_flag = true
    #@put_eneno = 150
    begin
      
      @animeframe += 1
      card_frame_count += 1
      
      #アラレ表示中か
      if ($tmp_ene_order.size) == @put_eneno
        card_put_frame = card_put_frame * 5 if card_put_frame_extend == false
        card_put_frame_extend = true
        if Input.trigger?(Input::C)
          #p card_put_frame
          #Audio.se_play("Audio/SE/" +"Z1 ピンポン") if pusharare_flag == false
          Audio.se_play("Audio/SE/" +"Z3 アタリ") if pusharare_flag == false
          pusharare_flag = true
        end
      end
      
      if card_put_flag == false && card_frame_count == card_noput_frame
        card_put_flag = true
        card_frame_count = 0
        card_put_run
      elsif card_put_flag == true && card_frame_count == card_put_frame
        card_put_flag = false
        card_frame_count = 0
        card_noput_run
      end
      @anime_window.update
      
      Graphics.update
      
      #if Input.trigger?(Input::C) 
      #  result = 1 #オープニング終了
      #end
    Input.update
    #text = "フレーム数：" + @animeframe.to_s
    #@anime_window.contents.draw_text( 0, 0, 300, 28, text)

    end while @put_eneend_flag != true
    Cache.clear
    @cha_pic.dispose
    @cha_pic = nil
    #@card_pic.dispose
    #@card_pic = []
    for x in 0..@card_pic.size-1
      @card_pic[x].dispose
    end
    @card_pic = nil
    
    @anime_window.dispose
    @anime_window = nil
    
    Graphics.fadein(60)
    #Audio.se_stop
    if pusharare_flag == false
      #アラレ表示中にボタンを押さない
      $game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
    else
      $game_variables[41] = 90911
      #イベントマップへ直移動だとなぜかイベントが発生しないで、
      #他のマップを噛ます
      $game_player.reserve_transfer(111, 0, 0, 0)
    end
  end   
  #--------------------------------------------------------------------------
  # ● #カード裏面に戻す
  #--------------------------------------------------------------------------
  def card_noput_run
    @card_pic[@put_position].bitmap = Bitmap.new("Graphics/Pictures/" + @card_pic_filename)
    @card_pic[@put_position].src_rect = set_card_frame 1
    #@card_pic[@put_position].color = Color.new ( 0,0,0,0)
    @card_pic[@put_position].tone = Tone.new (0,0 ,0)
    @cha_pic.visible = false
    
    if $tmp_ene_order.size  == @put_eneno
      @put_eneend_flag = true
    end
  end
  
  #--------------------------------------------------------------------------
  # ● #カードの表面(キャラ)を表示する
  #--------------------------------------------------------------------------
  def card_put_run
    
    #表示位置の更新
    #前回と同じ場所でなければループを抜ける
    begin
      card_put_randx = rand(5) + 1
      card_put_randy = rand(2) + 1
    end while @put_position == card_put_randx + (card_put_randy * 7)

    #表示位置格納
    @put_position = card_put_randx + (card_put_randy * 7)

    #味方と敵どちらを表示しているか？
    if @put_chaend_flag == false
      #味方を表示
      rect,picture = set_character_face 0,@chano[@put_chano] - 3,1 #キャラ格納
      
      #キャラ表示用ピクチャに格納
      @cha_pic.bitmap = Bitmap.new("Graphics/Pictures/" + picture)
      @cha_pic.src_rect = rect
      @cha_pic.x = @card_pic[@put_position].x
      @cha_pic.y = @card_pic[@put_position].y + 16
      @cha_pic.visible = true
      #@card_pic[@put_position].bitmap = Bitmap.new("Graphics/Pictures/" + picture) #Bitmap.new("Graphics/Pictures/" + card_pic_filename)
      #@card_pic[@put_position].src_rect = rect
      
      @put_chano += 1
      if @chano.size == @put_chano
        @put_chaend_flag = true
      end
    else
      #敵を表示
      ene_file_top_name = set_ene_str_no $tmp_ene_order[@put_eneno]
      
      if ene_file_top_name == "Z1_"
        mainasu = 0
      elsif ene_file_top_name == "Z2_"
        mainasu = $ene_str_no[1] - 1
      elsif ene_file_top_name == "Z3_"
        mainasu = $ene_str_no[2] - 1
      end
      picture = Cache.picture(ene_file_top_name + "顔敵") #敵キャラ
      rect = Rect.new(0, ($tmp_ene_order[@put_eneno] - mainasu)*64, 64, 64) # 顔敵
      
      #キャラ表示用ピクチャに格納
      @cha_pic.bitmap = picture
      @cha_pic.src_rect = rect
      @cha_pic.x = @card_pic[@put_position].x
      @cha_pic.y = @card_pic[@put_position].y + 16
      @cha_pic.visible = true
      #@card_pic[@put_position].bitmap = picture#Bitmap.new("Graphics/Pictures/" + picture) #Bitmap.new("Graphics/Pictures/" + card_pic_filename)
      #@card_pic[@put_position].src_rect = rect
      @put_eneno += 1

    end
    #カードは背景表示に切り替え
    uracard_x = 384+64
    uracard_y =272
    @card_pic[@put_position].bitmap.fill_rect(uracard_x +2,uracard_y+4,60,88,@card_back_color)
    @card_pic[@put_position].bitmap.fill_rect(uracard_x +4,uracard_y+2,56,2,@card_back_color)
    @card_pic[@put_position].bitmap.fill_rect(uracard_x +4,uracard_y+96-4,56,2,@card_back_color)
    @card_pic[@put_position].src_rect = Rect.new(384+64, 272, 64, 96)
    #p @card_back_color.red.to_i,@card_back_color.green.to_i,@card_back_color.blue.to_i
    #@card_pic[@put_position].tone = Tone.new (@card_back_color.red.to_i,@card_back_color.green.to_i ,@card_back_color.blue.to_i)
    #@card_pic[@put_position].color = @card_back_color
    #@scouter_cha.color = Color.new ( 0,256,0,160)
    #@scouter_cha.tone = Tone.new ( 0,255,0)
  end
  

end