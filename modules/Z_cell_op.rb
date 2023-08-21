#==============================================================================
# ■ Title_Anime
#------------------------------------------------------------------------------
# 　タイトルのアニメ表示
#==============================================================================
module Z_cell_op #< Scene_Base

   #--------------------------------------------------------------------------
  # ● Z3セルゲーム編オープニングタイトル表示メイン
  # カットイン暗転(一枚絵)
  #--------------------------------------------------------------------------   
  def z_cell_op_rev5
    @animeframe = 0    #総フレーム数
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    end_frame = 2060
    kasane_flag = false
    kasane_y = 178
    result = 0
    
    color = Color.new(255,255,255,256)
    color2 = Color.new(188,188,188,256)
    color3 = Color.new(127,127,127,256)
    color4 = Color.new(0,0,0,256)
    
    frapic = Sprite.new
    frapic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    frapic.x = 0
    frapic.y = 0
    frapic.z = 200
    rect = Rect.new(0, 0, 640, 480)
    frapic.src_rect = rect
    frapic.bitmap.fill_rect(0,0,640,480,color)
    frapic.visible = false
    
    backpic = Sprite.new
    backpic.x = 0
    backpic.y = 0
    backpic.z = 14
    rect = Rect.new(0, 0, 640, 0)
    backpic.bitmap = Bitmap.new("Graphics/System/Title3_2")
    backpic.src_rect = rect
    
    picture = Sprite.new
    picture.x = 212
    picture.y = 200-56
    picture.z = 3

    rect = Rect.new(0,0, 214, 192) # 顔敵
    picture.bitmap = Bitmap.new("Graphics/Pictures/Z3_背景_エンディング_セル1")
    picture.src_rect = rect
    picx_puls = 0
    picture.opacity = 0

    
    katidou = 120
    fra_kaisi_fre = 30
    fra_fre = 6
    opacity_puls = 8
    opacity_hanten = false
    begin
      if opacity_hanten == false
        picture.opacity += opacity_puls
      else
        picture.opacity -= opacity_puls
      end
      #@anime_window.contents.clear
      if picture != nil
        picture.x += picx_puls
      end
      case @animeframe
      
      when 0
    
        #picx_puls = -16
      when fra_kaisi_fre
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when fra_kaisi_fre+fra_fre*1,fra_kaisi_fre+fra_fre*2,fra_kaisi_fre+fra_fre*3
        frapic.visible = true
        
      when fra_kaisi_fre+fra_fre*1+fra_fre/2,fra_kaisi_fre+fra_fre*2+fra_fre/2,fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
        opacity_hanten = true
      when katidou
        #picture.x = -640
        #picx_puls = 16
        opacity_hanten = false
        picture.bitmap = Bitmap.new("Graphics/Pictures/Z3_背景_エンディング_セル2")
        rect = Rect.new(178*3,0, 178, 192) # 顔敵
        picture.src_rect = rect
            #picture.y = 200-56
            picture.x +=20
      when fra_kaisi_fre+katidou
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when katidou+fra_kaisi_fre+fra_fre*1,katidou+fra_kaisi_fre+fra_fre*2,katidou+fra_kaisi_fre+fra_fre*3
        frapic.visible = true
      when katidou+fra_kaisi_fre+fra_fre*1+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*2+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
        opacity_hanten = true
      when katidou*2
        rect = Rect.new(0, 0, 640, 480)
        backpic.src_rect = rect
        Audio.bgm_play("Audio/BGM/" +"ZD オープニング")
      end
      
      if @animeframe <= katidou*2

      end
      
      

      @animeframe += 1

      
      Input.update
      text = "フレーム数：" + @animeframe.to_s
      @anime_window.contents.draw_text( 0, 0, 300, 28, text)
      @anime_window.update
      
      Graphics.update
      
      if Input.trigger?(Input::C) 
        result = 1 #オープニング終了
      end
    end while result != 1
    if picture != nil
      #picture.bitmap.dispose   # 画像を消去
      picture.dispose          # スプライトを消去
    end
    Cache.clear
    @anime_window.dispose
    @anime_window = nil
  end   
  #--------------------------------------------------------------------------
  # ● Z4セルゲーム編クリア後オープニングタイトル表示メイン
  # ゴクウ、セル対面(悟飯超2)
  #--------------------------------------------------------------------------   
  def z_cell_op_rev4
    @animeframe = 0    #総フレーム数
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    end_frame = 2060
    kasane_flag = false
    kasane_y = 178
    result = 0
    
    color = Color.new(255,255,255,256)
    color2 = Color.new(188,188,188,256)
    color3 = Color.new(127,127,127,256)
    color4 = Color.new(0,0,0,256)
    
    frapic = Sprite.new
    frapic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    frapic.x = 0
    frapic.y = 0
    frapic.z = 200
    rect = Rect.new(0, 0, 640, 480)
    frapic.src_rect = rect
    frapic.bitmap.fill_rect(0,0,640,480,color)
    frapic.visible = false
    
    betauepic = Sprite.new
    betauepic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    betauepic.x = 0
    betauepic.y = 0
    betauepic.z = 19
    rect = Rect.new(0, 0, 640, 124)
    betauepic.bitmap.fill_rect(0,0,640,124,color4)
    betauepic.visible = true
    
    betashitapic = Sprite.new
    betashitapic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    betashitapic.x = 0
    betashitapic.y = 480 + 4 - 120
    betashitapic.z = 19
    rect = Rect.new(0, 0, 640, 120)
    betashitapic.bitmap.fill_rect(0,0,640,120,color4)
    betashitapic.visible = true
    
    backpic = Sprite.new
    backpic.x = 0
    backpic.y = 0
    backpic.z = 20
    rect = Rect.new(0, 0, 640, 0)
    backpic.bitmap = Bitmap.new("Graphics/System/Title3_4")
    backpic.src_rect = rect
    
    chabackpic = Sprite.new
    chabackpic.x = 0
    chabackpic.y = 120
    chabackpic.z = 1
    chabackpic.bitmap = Bitmap.new("Graphics/Pictures/zcellop/タイトル背景(青赤)")
    chabackpic.visible = false
    
    picture1 = Sprite.new
    picture1.x = -214
    picture1.y = 120-60
    picture1.z = 10
    picture1.bitmap = Bitmap.new("Graphics/Pictures/zcellop/ゴクウ(カラー)")
    
    picture2 = Sprite.new
    picture2.x = 644
    picture2.y = 120-90
    picture2.z = 10
    picture2.bitmap = Bitmap.new("Graphics/Pictures/zcellop/セル(カラー)")
    
    picture3 = Sprite.new
    picture3.x = 0
    picture3.y = 0
    picture3.z = 11
    picture3.bitmap = Bitmap.new("Graphics/Pictures/zcellop/ゴハン(超２)")
    picx_puls = 0
    picture3.visible = false
    
    pic2_flag = false
    
    katidou = 120
    fra_kaisi_fre = 20
    fra_fre = 6
    
    fra_zouka_flag = false
    fra_tuika_ryou = 8
    fra_ryou = 0
    color5 = Color.new(fra_ryou,fra_ryou,fra_ryou,256)
    
    begin
      
      #@anime_window.contents.clear
      if picture1 != nil
        
        if pic2_flag != true
          if picture1.x < 448
            picture1.x += picx_puls
          end
        else
          if picture2.x > -60
            picture2.x += picx_puls
          end
        end
        #p picture1.x,picture2.x
      end
      
      if fra_zouka_flag == true
        if fra_ryou > 255
          fra_ryou = 255
          rect = Rect.new(0, 0, 640, 480)
          backpic.src_rect = rect
        else
          fra_ryou += fra_tuika_ryou
        end
        frapic.opacity = fra_ryou
      end
      case @animeframe
      
      when 0
    
        picx_puls = 16
      when fra_kaisi_fre
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when fra_kaisi_fre+fra_fre*1,fra_kaisi_fre+fra_fre*2,fra_kaisi_fre+fra_fre*3
        frapic.visible = true
        
      when fra_kaisi_fre+fra_fre*1+fra_fre/2,fra_kaisi_fre+fra_fre*2+fra_fre/2,fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
      when katidou
        pic2_flag = true
        picx_puls = -16
      when fra_kaisi_fre+katidou
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when katidou+fra_kaisi_fre+fra_fre*1,katidou+fra_kaisi_fre+fra_fre*2,katidou+fra_kaisi_fre+fra_fre*3
        frapic.visible = true
      when katidou+fra_kaisi_fre+fra_fre*1+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*2+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
      when katidou*2
        fra_zouka_flag = true
        frapic.opacity = 0
        frapic.visible = true
      when katidou*2+45
        chabackpic.visible = true
        picture3.visible = true
        fra_tuika_ryou = -8
        #frapic.visible = false
      when katidou*2+90
        #rect = Rect.new(0, 0, 640, 480)
        #backpic.src_rect = rect
        Audio.bgm_play("Audio/BGM/" +"ZD オープニング")
      end
      
      if @animeframe <= katidou*2

      end
      
      

      @animeframe += 1

      
      Input.update
      text = "フレーム数：" + @animeframe.to_s
      #@anime_window.contents.draw_text( 0, 0, 300, 28, text)
      @anime_window.update
      
      Graphics.update
      
      if Input.trigger?(Input::C) 
        result = 1 #オープニング終了
      end
    end while result != 1
    if chabackpic != nil
      #picture.bitmap.dispose   # 画像を消去
      chabackpic.dispose          # スプライトを消去
    end
    if picture1 != nil
      #picture.bitmap.dispose   # 画像を消去
      picture1.dispose          # スプライトを消去
    end
    if picture2 != nil
      #picture.bitmap.dispose   # 画像を消去
      picture2.dispose          # スプライトを消去
    end
    if picture3 != nil
      #picture.bitmap.dispose   # 画像を消去
      picture3.dispose          # スプライトを消去
    end
    
    if betauepic != nil
      betauepic.dispose 
    end
    
    if betashitapic != nil
      betashitapic.dispose 
    end
    
    Cache.clear
    @anime_window.dispose
    @anime_window = nil
  end  
  #--------------------------------------------------------------------------
  # ● Z4セルゲーム編オープニングタイトル表示メイン
  # ゴクウ、セル対面(超悟飯1)
  #--------------------------------------------------------------------------   
  def z_cell_op_rev0
    @animeframe = 0    #総フレーム数
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    end_frame = 2060
    kasane_flag = false
    kasane_y = 178
    result = 0
    
    color = Color.new(255,255,255,256)
    color2 = Color.new(188,188,188,256)
    color3 = Color.new(127,127,127,256)
    color4 = Color.new(0,0,0,256)
    
    frapic = Sprite.new
    frapic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    frapic.x = 0
    frapic.y = 0
    frapic.z = 200
    rect = Rect.new(0, 0, 640, 480)
    frapic.src_rect = rect
    frapic.bitmap.fill_rect(0,0,640,480,color)
    frapic.visible = false
    
    betauepic = Sprite.new
    betauepic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    betauepic.x = 0
    betauepic.y = 0
    betauepic.z = 19
    rect = Rect.new(0, 0, 640, 124)
    betauepic.bitmap.fill_rect(0,0,640,124,color4)
    betauepic.visible = true
    
    betashitapic = Sprite.new
    betashitapic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    betashitapic.x = 0
    betashitapic.y = 480 + 4 - 120
    betashitapic.z = 19
    rect = Rect.new(0, 0, 640, 120)
    betashitapic.bitmap.fill_rect(0,0,640,120,color4)
    betashitapic.visible = true
    
    backpic = Sprite.new
    backpic.x = 0
    backpic.y = 0
    backpic.z = 20
    rect = Rect.new(0, 0, 640, 0)
    backpic.bitmap = Bitmap.new("Graphics/System/Title3_3")
    backpic.src_rect = rect
    
    chabackpic = Sprite.new
    chabackpic.x = 0
    chabackpic.y = 120
    chabackpic.z = 1
    chabackpic.bitmap = Bitmap.new("Graphics/Pictures/zcellop/タイトル背景(青赤)")
    chabackpic.visible = false
    
    picture1 = Sprite.new
    picture1.x = -214
    picture1.y = 120-60
    picture1.z = 10
    picture1.bitmap = Bitmap.new("Graphics/Pictures/zcellop/ゴクウ(カラー)")
    
    picture2 = Sprite.new
    picture2.x = 644
    picture2.y = 120-90
    picture2.z = 10
    picture2.bitmap = Bitmap.new("Graphics/Pictures/zcellop/セル(カラー)")
    
    picture3 = Sprite.new
    picture3.x = 0
    picture3.y = 0
    picture3.z = 11
    picture3.bitmap = Bitmap.new("Graphics/Pictures/zcellop/ゴハン(超１)")
    picx_puls = 0
    picture3.visible = false
    
    pic2_flag = false
    
    katidou = 120
    fra_kaisi_fre = 20
    fra_fre = 6
    
    fra_zouka_flag = false
    fra_tuika_ryou = 8
    fra_ryou = 0
    color5 = Color.new(fra_ryou,fra_ryou,fra_ryou,256)
    
    begin
      
      #@anime_window.contents.clear
      if picture1 != nil
        
        if pic2_flag != true
          if picture1.x < 448
            picture1.x += picx_puls
          end
        else
          if picture2.x > -60
            picture2.x += picx_puls
          end
        end
        #p picture1.x,picture2.x
      end
      
      if fra_zouka_flag == true
        if fra_ryou > 255
          fra_ryou = 255
          rect = Rect.new(0, 0, 640, 480)
          backpic.src_rect = rect
        else
          fra_ryou += fra_tuika_ryou
        end
        frapic.opacity = fra_ryou
      end
      case @animeframe
      
      when 0
    
        picx_puls = 16
      when fra_kaisi_fre
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when fra_kaisi_fre+fra_fre*1,fra_kaisi_fre+fra_fre*2,fra_kaisi_fre+fra_fre*3
        frapic.visible = true
        
      when fra_kaisi_fre+fra_fre*1+fra_fre/2,fra_kaisi_fre+fra_fre*2+fra_fre/2,fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
      when katidou
        pic2_flag = true
        picx_puls = -16
      when fra_kaisi_fre+katidou
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when katidou+fra_kaisi_fre+fra_fre*1,katidou+fra_kaisi_fre+fra_fre*2,katidou+fra_kaisi_fre+fra_fre*3
        frapic.visible = true
      when katidou+fra_kaisi_fre+fra_fre*1+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*2+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
      when katidou*2
        fra_zouka_flag = true
        frapic.opacity = 0
        frapic.visible = true
      when katidou*2+45
        chabackpic.visible = true
        picture3.visible = true
        fra_tuika_ryou = -8
        #frapic.visible = false
      when katidou*2+90
        #rect = Rect.new(0, 0, 640, 480)
        #backpic.src_rect = rect
        Audio.bgm_play("Audio/BGM/" +"ZD オープニング")
      end
      
      if @animeframe <= katidou*2

      end
      
      

      @animeframe += 1

      
      Input.update
      text = "フレーム数：" + @animeframe.to_s
      #@anime_window.contents.draw_text( 0, 0, 300, 28, text)
      @anime_window.update
      
      Graphics.update
      
      if Input.trigger?(Input::C) 
        result = 1 #オープニング終了
      end
    end while result != 1
    if chabackpic != nil
      #picture.bitmap.dispose   # 画像を消去
      chabackpic.dispose          # スプライトを消去
    end    
    if picture1 != nil
      #picture.bitmap.dispose   # 画像を消去
      picture1.dispose          # スプライトを消去
    end
    if picture2 != nil
      #picture.bitmap.dispose   # 画像を消去
      picture2.dispose          # スプライトを消去
    end
    if picture3 != nil
      #picture.bitmap.dispose   # 画像を消去
      picture3.dispose          # スプライトを消去
    end
    
    if betauepic != nil
      betauepic.dispose 
    end
    
    if betashitapic != nil
      betashitapic.dispose 
    end
    
    Cache.clear
    @anime_window.dispose
    @anime_window = nil
  end
  #--------------------------------------------------------------------------
  # ● Z3セルゲーム編オープニングタイトル表示メイン
  # 巨大カットイン左右から
  # 完全体になる前まで(一枚絵悟空)
  # 84が1で使われる
  #--------------------------------------------------------------------------   
  def z_cell_op_rev3
    @animeframe = 0    #総フレーム数
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    end_frame = 2060
    kasane_flag = false
    kasane_y = 178
    result = 0
    
    color = Color.new(255,255,255,256)
    color2 = Color.new(188,188,188,256)
    color3 = Color.new(127,127,127,256)
    color4 = Color.new(0,0,0,256)
    
    frapic = Sprite.new
    frapic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    frapic.x = 0
    frapic.y = 0
    frapic.z = 200
    rect = Rect.new(0, 0, 640, 480)
    frapic.src_rect = rect
    frapic.bitmap.fill_rect(0,0,640,480,color)
    frapic.visible = false
    
    backpic = Sprite.new
    backpic.x = 0
    backpic.y = 0
    backpic.z = 14
    rect = Rect.new(0, 0, 640, 0)
    backpic.bitmap = Bitmap.new("Graphics/System/Title3_2")
    backpic.src_rect = rect
    
    picture = Sprite.new
    picture.x = 640
    picture.y = 200-64
    picture.z = 3
    
    rect = Rect.new(0,0, 214, 192) # 顔敵
    picture.bitmap = Bitmap.new("Graphics/Pictures/Z3_背景_エンディング_セル1")
    picture.src_rect = rect
    picx_puls = 0
    

    
    katidou = 120
    fra_kaisi_fre = 20
    fra_fre = 6
    
    begin
      
      #@anime_window.contents.clear
      if picture != nil
        picture.x += picx_puls
      end
      case @animeframe
      
      when 0
    
        picx_puls = -16
      when fra_kaisi_fre
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when fra_kaisi_fre+fra_fre*1,fra_kaisi_fre+fra_fre*2,fra_kaisi_fre+fra_fre*3
        frapic.visible = true
        
      when fra_kaisi_fre+fra_fre*1+fra_fre/2,fra_kaisi_fre+fra_fre*2+fra_fre/2,fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
      when katidou
        picture.x = -192
        picx_puls = 16
        picture.bitmap = Bitmap.new("Graphics/Pictures/Z3_背景_エンディング_セル2")
        rect = Rect.new(178*3,0, 178, 192) # 顔敵
        picture.src_rect = rect
      when fra_kaisi_fre+katidou
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when katidou+fra_kaisi_fre+fra_fre*1,katidou+fra_kaisi_fre+fra_fre*2,katidou+fra_kaisi_fre+fra_fre*3
        frapic.visible = true
      when katidou+fra_kaisi_fre+fra_fre*1+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*2+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
      when katidou*2
        rect = Rect.new(0, 0, 640, 480)
        backpic.src_rect = rect
        Audio.bgm_play("Audio/BGM/" +"ZD オープニング")
      end
      
      if @animeframe <= katidou*2

      end
      
      

      @animeframe += 1

      
      Input.update
      text = "フレーム数：" + @animeframe.to_s
      #@anime_window.contents.draw_text( 0, 0, 300, 28, text)
      @anime_window.update
      
      Graphics.update
      
      if Input.trigger?(Input::C) 
        result = 1 #オープニング終了
      end
    end while result != 1
    if picture != nil
      #picture.bitmap.dispose   # 画像を消去
      picture.dispose          # スプライトを消去
    end
    Cache.clear
    @anime_window.dispose
    @anime_window = nil
  end
  #--------------------------------------------------------------------------
  # ● Z3セルゲーム編オープニングタイトル表示メイン
  # カットイン暗転
  #--------------------------------------------------------------------------   
  def z_cell_op_rev2
    @animeframe = 0    #総フレーム数
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    end_frame = 2060
    kasane_flag = false
    kasane_y = 178
    result = 0
    
    color = Color.new(255,255,255,256)
    color2 = Color.new(188,188,188,256)
    color3 = Color.new(127,127,127,256)
    color4 = Color.new(0,0,0,256)
    
    frapic = Sprite.new
    frapic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    frapic.x = 0
    frapic.y = 0
    frapic.z = 200
    rect = Rect.new(0, 0, 640, 480)
    frapic.src_rect = rect
    frapic.bitmap.fill_rect(0,0,640,480,color)
    frapic.visible = false
    
    backpic = Sprite.new
    backpic.x = 0
    backpic.y = 0
    backpic.z = 14
    rect = Rect.new(0, 0, 640, 0)
    backpic.bitmap = Bitmap.new("Graphics/System/Title3_2")
    backpic.src_rect = rect
    
    picture = Sprite.new
    picture.x = 0
    picture.y = 200
    picture.z = 3

    teki_x = 26
    rect = Rect.new(0,teki_x*64, 640, 64) # 顔敵
    picture.bitmap = Bitmap.new("Graphics/Pictures/Z3_敵カットイン")
    picture.src_rect = rect
    picx_puls = 0
    picture.opacity = 0

    
    katidou = 120
    fra_kaisi_fre = 30
    fra_fre = 6
    opacity_puls = 8
    opacity_hanten = false
    begin
      if opacity_hanten == false
        picture.opacity += opacity_puls
      else
        picture.opacity -= opacity_puls
      end
      #@anime_window.contents.clear
      if picture != nil
        picture.x += picx_puls
      end
      case @animeframe
      
      when 0
    
        #picx_puls = -16
      when fra_kaisi_fre
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when fra_kaisi_fre+fra_fre*1,fra_kaisi_fre+fra_fre*2,fra_kaisi_fre+fra_fre*3
        frapic.visible = true
        
      when fra_kaisi_fre+fra_fre*1+fra_fre/2,fra_kaisi_fre+fra_fre*2+fra_fre/2,fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
        opacity_hanten = true
      when katidou
        #picture.x = -640
        #picx_puls = 16
        opacity_hanten = false
        teki_x = 27
        rect = Rect.new(0,teki_x*64, 640, 64) # 顔敵
        picture.src_rect = rect
      when fra_kaisi_fre+katidou
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when katidou+fra_kaisi_fre+fra_fre*1,katidou+fra_kaisi_fre+fra_fre*2,katidou+fra_kaisi_fre+fra_fre*3
        frapic.visible = true
      when katidou+fra_kaisi_fre+fra_fre*1+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*2+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
        opacity_hanten = true
      when katidou*2
        rect = Rect.new(0, 0, 640, 480)
        backpic.src_rect = rect
        Audio.bgm_play("Audio/BGM/" +"ZD オープニング")
      end
      
      if @animeframe <= katidou*2

      end
      
      

      @animeframe += 1

      
      Input.update
      text = "フレーム数：" + @animeframe.to_s
      #@anime_window.contents.draw_text( 0, 0, 300, 28, text)
      @anime_window.update
      
      Graphics.update
      
      if Input.trigger?(Input::C) 
        result = 1 #オープニング終了
      end
    end while result != 1
    if picture != nil
      #picture.bitmap.dispose   # 画像を消去
      picture.dispose          # スプライトを消去
    end
    Cache.clear
    @anime_window.dispose
    @anime_window = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Z3セルゲーム編オープニングタイトル表示メイン
  # カットイン左右から
  #--------------------------------------------------------------------------   
  def z_cell_op_rev1
    @animeframe = 0    #総フレーム数
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    end_frame = 2060
    kasane_flag = false
    kasane_y = 178
    result = 0
    
    color = Color.new(255,255,255,256)
    color2 = Color.new(188,188,188,256)
    color3 = Color.new(127,127,127,256)
    color4 = Color.new(0,0,0,256)
    
    frapic = Sprite.new
    frapic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    frapic.x = 0
    frapic.y = 0
    frapic.z = 200
    rect = Rect.new(0, 0, 640, 480)
    frapic.src_rect = rect
    frapic.bitmap.fill_rect(0,0,640,480,color)
    frapic.visible = false
    
    backpic = Sprite.new
    backpic.x = 0
    backpic.y = 0
    backpic.z = 14
    rect = Rect.new(0, 0, 640, 120)
    backpic.bitmap = Bitmap.new("Graphics/System/Title3_2")
    backpic.src_rect = rect
    
    picture = Sprite.new
    picture.x = 640
    picture.y = 200
    picture.z = 3

    teki_x = 26
    rect = Rect.new(0,teki_x*64, 640, 64) # 顔敵
    picture.bitmap = Bitmap.new("Graphics/Pictures/Z3_敵カットイン")
    picture.src_rect = rect
    picx_puls = 0
    

    
    katidou = 120
    fra_kaisi_fre = 30
    fra_fre = 6
    
    begin
      
      #@anime_window.contents.clear
      if picture != nil
        picture.x += picx_puls
      end
      case @animeframe
      
      when 0
    
        picx_puls = -16
      when fra_kaisi_fre
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when fra_kaisi_fre+fra_fre*1,fra_kaisi_fre+fra_fre*2,fra_kaisi_fre+fra_fre*3
        frapic.visible = true
        
      when fra_kaisi_fre+fra_fre*1+fra_fre/2,fra_kaisi_fre+fra_fre*2+fra_fre/2,fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
      when katidou
        picture.x = -640
        picx_puls = 16
        teki_x = 26
        rect = Rect.new(0,teki_x*64, 640, 64) # 顔敵
        picture.src_rect = rect
      when fra_kaisi_fre+katidou
        Audio.se_play("Audio/SE/" +"ZD OPカードセット")
      when katidou+fra_kaisi_fre+fra_fre*1,katidou+fra_kaisi_fre+fra_fre*2,katidou+fra_kaisi_fre+fra_fre*3
        frapic.visible = true
      when katidou+fra_kaisi_fre+fra_fre*1+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*2+fra_fre/2,katidou+fra_kaisi_fre+fra_fre*3+fra_fre/2
        frapic.visible = false
      when katidou*2
        rect = Rect.new(0, 0, 640, 480)
        backpic.src_rect = rect
        Audio.bgm_play("Audio/BGM/" +"ZD オープニング")
      end
      
      if @animeframe <= katidou*2

      end
      
      

      @animeframe += 1

      
      Input.update
      text = "フレーム数：" + @animeframe.to_s
      #@anime_window.contents.draw_text( 0, 0, 300, 28, text)
      @anime_window.update
      
      Graphics.update
      
      if Input.trigger?(Input::C) 
        result = 1 #オープニング終了
      end
    end while result != 1
    if picture != nil
      #picture.bitmap.dispose   # 画像を消去
      picture.dispose          # スプライトを消去
    end
    Cache.clear
    @anime_window.dispose
    @anime_window = nil
  end
  
end