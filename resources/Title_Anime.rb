#==============================================================================
# ■ Title_Anime
#------------------------------------------------------------------------------
# 　タイトルのアニメ表示
#==============================================================================
class Title_Anime  < Scene_Base
#include TRGSSX
include Z_cell_op
include Z_gaiden_op
include Z_ed
#include Share

  def op
    
    case $game_progress #オープニング
    
    when 0
      z1_op
      
    when 1
      z2_op $op_change
      
    when 2
      if $op_change == 1
        z_cell_op_rev3
      elsif $op_change == 2
        z_cell_op_rev0
      elsif $op_change == 3
        z_cell_op_rev4
      elsif $op_change == 5
        z_gaiden_op_rev1
      elsif $op_change == 9
        z_ed_rev1
      else
        z3_op
      end
    
    when 3
    
    
    else
      z1_op
      
    end
  end


  #--------------------------------------------------------------------------
  # ● Z3オープニングタイトル表示メイン
  #--------------------------------------------------------------------------   
  def z3_op
    
    
    @animeframe = 0    #総フレーム数
    Audio.bgm_play("Audio/BGM/" +"Z3 オープニング")    # 効果音を再生する
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    end_frame = 2060
    fra_frame = 360
    kasane_flag = false
    kasane_y = 178
    result = 0
    rect = Rect.new(0, 0, 640, 480)
    picture = nil
    picture_num = 0
    picture_name = "z3_op_"
    #@color = Color.new(0,0,0,255)
    picture = Sprite.new
    picture.x = 64
    picture.y = 16
    picture.z = 255
    color = Color.new(255,255,255,256)
    color2 = Color.new(188,188,188,256)
    color3 = Color.new(127,127,127,256)
    color4 = Color.new(0,0,0,256)
    begin
      
      #@anime_window.contents.clear
      
      #33
      case @animeframe
      
      when 16,32,48,64,fra_frame+120,fra_frame+128,fra_frame+136,end_frame-40,end_frame-32,end_frame-24
        picture.z = 255
        #@anime_window.contents.clear
        picture_num += 1
        
        if @animeframe == fra_frame+120 
          @anime_window.contents.fill_rect(0,0,656,496,color2)
          kasane_flag = true
        elsif @animeframe == fra_frame+128 
          @anime_window.contents.fill_rect(0,0,656,496,color3)
        elsif @animeframe == fra_frame+136 
          @anime_window.contents.fill_rect(0,0,656,496,color4)
        end
        
        if kasane_flag == true
          picture2 = Cache.picture("z3op/" + picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s) #敵キャラ
          rect = Rect.new(0,kasane_y, 32, 94) # 顔敵
          @anime_window.contents.blt(0,kasane_y+picture.y,picture2,rect)
          @anime_window.contents.blt(32,kasane_y+picture.y,picture2,rect)
          @anime_window.contents.blt(512+64,kasane_y+picture.y,picture2,rect)
          @anime_window.contents.blt(512+64+32,kasane_y+picture.y,picture2,rect)
        end
        picture.bitmap = Bitmap.new("Graphics/Pictures/z3op/" + picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
        #picture = Cache.picture("/z2op/" + picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
        #picture = Cache.op2_picture(picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
      when end_frame-16
        @anime_window.contents.clear
        picture.visible = false
      when fra_frame
        picture.z = 0
        @anime_window.contents.fill_rect(0,0,656,496,color)
        #picture_num = 286
        #if picture.bitmap != nil
        #  picture.bitmap.dispose
        #end
        #picture = nil
        #picture = Cache.picture("/z2op/" + picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
        #picture = Cache.op2_picture(picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
      end
      
      if picture != nil
        #@anime_window.contents.blt(0 ,0,picture,rect)
        #@anime_window.contents.blend_blt(0, 0, picture, rect, TRGSSX::BLEND_ADD)
        #@anime_window.contents.blend_blt(0, 0, picture, rect)
      end
      @animeframe += 1
      if @animeframe == end_frame
        result = 1
      end
      
      Input.update
      #text = "フレーム数：" + @animeframe.to_s
      #@anime_window.contents.draw_text( 0, 0, 300, 28, text)
      #@anime_window.contents.draw_text( 0, 30, 300, 28, picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
      #@anime_window.update
      
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
  # ● Z2オープニングタイトル表示メイン
  #--------------------------------------------------------------------------   
  def z2_op op_change
    @animeframe = 0    #総フレーム数
    picture = nil
    picture = Sprite.new
    picture_num = 0
    picture_name = "z2_op_"
    for x in 1..289
      picture.bitmap = Bitmap.new("Graphics/Pictures/z2op/" + picture_name + "0" *(3-x.to_s.size) + x.to_s)
    end
    Audio.bgm_play("Audio/BGM/" +"Z2 オープニング")    # 効果音を再生する
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    result = 0
    rect = Rect.new(0, 0, 640, 480)

    #@color = Color.new(0,0,0,255)
    
    
    if op_change == 4 #バーダック一味編
      $z2opchano = rand(4) 
      
      chapicture = Sprite.new
      rect = Rect.new(0, 69*$z2opchano, 640, 69)
      chapicture.bitmap = Bitmap.new("Graphics/Pictures/z2op/z2_op_kirikae")
      chapicture.src_rect = rect
      chapicture.x = -640
      chapicture.y = 154
      chapicture.z = 200
      chapicture.visible = false
    end
    
    #カクカク対策で事前にキャッシュに入れてみる

    begin
      
      #@anime_window.contents.clear
      
      #33
      case @animeframe
      
      when 0,4,8,12,45,49,53,57,90,94,98,102,135,139,143,147,180,184,188,192,225,229,233,237,270,274,278,282,313..360,392..424,433..469,560,564,568,572,595..659,767..783,843..859,930..966,974,978,982
        picture_num += 1
        if picture.bitmap != nil && @animeframe < 313 || picture.bitmap != nil && @animeframe > 392
          picture.bitmap.dispose
        end
        picture.bitmap = Bitmap.new("Graphics/Pictures/z2op/" + picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
        #picture = Cache.picture("/z2op/" + picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
        #picture = Cache.op2_picture(picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
      when 470..559
        #picture = nil
      when 986
        picture_num = 286
        #if picture.bitmap != nil
        #  picture.bitmap.dispose
        #end
        picture.bitmap = Bitmap.new("Graphics/Pictures/z2op/" + picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
        #picture = Cache.picture("/z2op/" + picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
        #picture = Cache.op2_picture(picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
      end
      
      if op_change == 4 #バーダック一味編
        #キャラかぶせよう
        case picture_num
        
        when 216..231
          chapicture.x += 40
          chapicture.visible = true

        end
      end
      
      if picture != nil
        #@anime_window.contents.blt(0 ,0,picture,rect)
        #@anime_window.contents.blend_blt(0, 0, picture, rect, TRGSSX::BLEND_ADD)
        #@anime_window.contents.blend_blt(0, 0, picture, rect)
      end
      @animeframe += 1
      if @animeframe == 3720
        result = 1
      end
      
      Input.update
      #text = "フレーム数：" + @animeframe.to_s
      #@anime_window.contents.draw_text( 0, 0, 300, 28, text)
      #@anime_window.contents.draw_text( 0, 30, 300, 28, picture_name + "0" *(3-picture_num.to_s.size) + picture_num.to_s)
      #@anime_window.update
      
      Graphics.update
      
      if Input.trigger?(Input::C) 
        result = 1 #オープニング終了
      end
    end while result != 1
    if op_change == 4 #バーダック一味編
      chapicture.visible = false
    end
    picture.bitmap.dispose   # 画像を消去
    picture.dispose          # スプライトを消去
    Cache.clear
    @anime_window.dispose
    @anime_window = nil
  end

  #--------------------------------------------------------------------------
  # ● Z1オープニングタイトル表示メイン
  #--------------------------------------------------------------------------   
  def z1_op
    @animeframe = 0    #総フレーム数
    @namiframe = 0     #波とスカウターアニメ用
    Audio.bgm_play("Audio/BGM/" +"Z1 オープニング")    # 効果音を再生する
    @anime_window = Window_Base.new(-16,-16,690,530)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    @namirect = Rect.new(0, 0, 640, 85)
    @namipicture = Cache.picture("z1_opnami1")
    @namiy = 395
    @kumopicture = Cache.picture("z1_opkumo")
    @kumoy = 394
    @kumorect = Rect.new(0, 0, 640, 345)
    @picture = Cache.picture("z1_ophikaru1")
    @rect = Rect.new(0, 0, 44, 44)
    @picx = 640/2-63
    @picy = 480/2-55
    @backpicture = Cache.picture("z1_oputyuu1")
    @backrect = Rect.new(0, 0, 640, 480)
    @color = Color.new(96,160,255,255)

    begin
      
      if @animeframe <522 #背景塗り
        @anime_window.contents.fill_rect(0,0,665,505,@color)
      else #背景ピクチャ
        @anime_window.contents.blt(0 ,0,@backpicture,@backrect)
      end
      if @animeframe >=167 #雲
        @anime_window.contents.blt(0 ,@kumoy,@kumopicture,@kumorect)
      end
      
      if @animeframe >=347 && @animeframe <= 362 #光
        @anime_window.contents.blt(640/2-22 ,480/2-22,@picture,@rect)
      end

      if @animeframe >=375 && @animeframe <= 586 #DB
        @anime_window.contents.blt(@picx ,@picy,@picture,@rect)
      elsif @animeframe >=626 && @animeframe <= 767 #宇宙船,光
        @anime_window.contents.blt(@picx ,@picy,@picture,@rect)
      end

      if @animeframe <480 #波 
        @anime_window.contents.blt(0 ,@namiy,@namipicture,@namirect)   
        @namiframe += 1
      elsif @animeframe >=1026 #スカウター点滅
        @namiframe += 1
      else
        @namiframe = 13
      end
      @animeframe += 1
      result = z1_op_update
    
      if @animeframe == 2380
        
        result = 1
      end
    end while result != 1

    Cache.clear
    @anime_window.dispose
    @anime_window = nil
  end
  
  #--------------------------------------------------------------------------
  # ● フレーム更新
  # 戻り値:"1" オープニング終了
  #--------------------------------------------------------------------------  
  def z1_op_update
    #super
    Input.update
    z1_op_picture_control
    #text = "フレーム数：" + @animeframe.to_s
    #@anime_window.contents.draw_text( 0, 0, 300, 28, text)
    #@anime_window.update
    
    Graphics.update
    
    if Input.trigger?(Input::C) 
      return 1 #オープニング終了
    else
      return 0
    end
  end 
  
  #--------------------------------------------------------------------------
  # ● 画像変更・更新処理
  #--------------------------------------------------------------------------   
  def z1_op_picture_control
    case @animeframe
    
    when 0 #背景
      @color = Color.new(96,160,255,255)
    when 167 .. 326 #雲
      @kumoy -= 2
    when 347 #光1
      @picture = Cache.picture("z1_ophikaru1")
    when 351 #光2
      @picture = Cache.picture("z1_ophikaru2")
    when 355 #光3
      @picture = Cache.picture("z1_ophikaru3")
    when 359 #光4
      @picture = Cache.picture("z1_ophikaru4")
    when 375 #DB1
      @picture = Cache.picture("z1_opdb1")
      @rect = Rect.new(0, 0, 126, 110)
    when 379 #DB2
      @picture = Cache.picture("z1_opdb2")
    when 383 #DB3
      @picture = Cache.picture("z1_opdb3")
    when 387 #DB4
      @picture = Cache.picture("z1_opdb4")
    when 391 #DB5
      @picture = Cache.picture("z1_opdb5")
    when 395 #DB6
      @picture = Cache.picture("z1_opdb6")
    when 399 #DB7
      @picture = Cache.picture("z1_opdb7")
    when 408..480
      @namiy += 6
      @kumoy += 6
    when 488 #背景
      @color = Color.new(64,96,248,255)
    when 492 #背景
      @color = Color.new(32,0,176,255)
    when 496 #背景
      @color = Color.new(0,0,0,255)
    when 522 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu1")
    when 526#背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu2")
    when 530#背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu3")
    when 534#背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu4")
    when 538#背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu5")
    when 540..586 #DB移動
      @picy -= 6
    when 626
      @picture = Cache.picture("z1_utyuusen1") 
      @rect = Rect.new(0, 0, 130, 110)
      @picx = 624
      @picy = -80
    when 627..651
      @picx -= 4
      @picy += 3
    when 652..656
      @picture = Cache.picture("z1_utyuusen2") 
      @picx -= 4
      @picy += 3
    when 657..660
      @picture = Cache.picture("z1_utyuusen3") 
      @picx -= 4
      @picy += 3 
    when 661..665
      @picture = Cache.picture("z1_utyuusen4") 
      @picx -= 4
      @picy += 3
    when 666..678
      @picture = Cache.picture("z1_utyuusen1") 
      @picx -= 4
      @picy += 3
    when 679
      @picture = Cache.picture("z1_utyuusen5") 
      @picx -= 12
      @picy += 5
    when 680..699
      @picx -= 4
      @picy += 3
    when 700
      @picture = Cache.picture("z1_utyuusen6") 
      @picx -= 12
      @picy += 5
    when 701..717
      @picx -= 4
      @picy += 3
    when 718
      @picture = Cache.picture("z1_utyuusen7") 
      @picx -= 12
      @picy += 5
    when 719..730
      @picx -= 5
      @picy += 3
    when 731
      @picture = Cache.picture("z1_utyuusen8") 
      @picx -= 12
      @picy += 5
    when 732..739
      @picx -= 5
      @picy += 3
    when 740
      @picture = Cache.picture("z1_utyuusen9") 
      @picx -= 12
      @picy += 5
    when 741..743
      @picx -= 5
      @picy += 3
    when 744
      @picture = Cache.picture("z1_utyuusen10") 
      @picx -= 12
      @picy += 5
    when 745..751
      @picx -= 5
      @picy += 3
    when 752 #光1
      @picx += 32
      @picy += 32
      @picture = Cache.picture("z1_ophikaru1")
    when 756 #光2
      @picture = Cache.picture("z1_ophikaru2")
    when 760 #光3
      @picture = Cache.picture("z1_ophikaru3")
    when 764 #光4
      @picture = Cache.picture("z1_ophikaru4")
    when 872 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu6")
    when 876 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu7")
    when 880 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu8")
    when 884 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu9")
    when 919 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu10")
    when 923 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu11")
    when 927 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu12")
    when 931 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu13")
    when 994 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu14")
    when 1002 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu15")
    when 1010 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu16")
    when 1018 #背景ピクチャに
      @backpicture = Cache.picture("z1_oputyuu17")
    when 1026 #背景ピクチャに
      @namiframe = 0
    when 2380     
    end

    if @animeframe <480 #波
      case @namiframe
      
      when 0
        @namipicture = Cache.picture("z1_opnami1")
      when 4
        @namipicture = Cache.picture("z1_opnami2")
      when 8
        @namipicture = Cache.picture("z1_opnami3")
      when 12
        @namipicture = Cache.picture("z1_opnami1")
        @namiframe = 0
      end
    elsif @animeframe >=1026 #スカウター
      case @namiframe
      when 0
        @backpicture = Cache.picture("z1_oputyuu13")
      when 16
        @backpicture = Cache.picture("z1_oputyuu18")
      when 32
        @backpicture = Cache.picture("z1_oputyuu13")
        @namiframe = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● Z1エンディング表示メイン
  #--------------------------------------------------------------------------   
  def z1_ed
    @animeframe = 0    #総フレーム数
    @backframe = 0
    @frizaframe = 0
    @anime_window = Window_Base.new(-16,-16,690,530)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    @backpicture = Cache.picture("z1_edutyuu1")
    @backrect = Rect.new(0, 0, 640, 480)
    hikaru_strat = 16
    Graphics.fadein(30)
    result = 0
    begin
      Input.update
      @anime_window.contents.clear
      if @animeframe == 8
        @backpicture = Cache.picture("z1_edutyuu2")
      elsif @animeframe > 8 then
        case @backframe
        
        when 0
          @backpicture = Cache.picture("z1_edutyuu3")
        when 16
          @backpicture = Cache.picture("z1_edutyuu4")
        when 32
          @backpicture = Cache.picture("z1_edutyuu3")
          @backframe = 0
        end
        @backframe += 1
      end
      
      
      @anime_window.contents.blt(0 ,0,@backpicture,@backrect)

      case @animeframe - hikaru_strat
      
      when 0
        picture = Cache.picture("z1_ophikaru1")
      when 4
        picture = Cache.picture("z1_ophikaru2")
      when 8
        picture = Cache.picture("z1_ophikaru3")
      when 12
        picture = Cache.picture("z1_ophikaru4")
      when 8*2
        Audio.se_play("Audio/SE/" + "Z1 落下")
        picture = Cache.picture("z1_utyuusen10")
      
      when 8*3
        picture = Cache.picture("z1_utyuusen9")
      when 8*4
        picture = Cache.picture("z1_utyuusen8")
      when 8*5
        picture = Cache.picture("z1_utyuusen7")
      when 8*6
        picture = Cache.picture("z1_utyuusen6")
      when 8*7
        picture = Cache.picture("z1_utyuusen5")
      when 8*8
        picture = Cache.picture("z1_utyuusen4")
      when 8*9
        picture = Cache.picture("z1_utyuusen3")
      when 8*10
        picture = Cache.picture("z1_utyuusen2")
      when 8*11
        picture = Cache.picture("z1_utyuusen1")
        
      when 8*14
        picture = nil
        #Audio.bgm_play("Audio/BGM/" +"Z1 エンディング")    # 効果音を再生する
      end
      
      if picture != nil
        if @animeframe - hikaru_strat < 17
          rect = Rect.new(0, 0, 44, 44)
          @anime_window.contents.blt(296 ,310,picture,rect)
        else
          rect = Rect.new(0, 0, 130, 110)
          @anime_window.contents.blt(256 ,270-(@animeframe - hikaru_strat-16)*4,picture,rect)
        end
      end
      
      if @animeframe == 11600
        Audio.bgm_stop
      end
      if @animeframe > 200  #@animeframe > 11600
        case @frizaframe
        
        when 0
          picture = Cache.picture("z1_edhuri-za")
          
        when 480
          picture = Cache.picture("z1_edhuri-za2")
        when 510
          picture = Cache.picture("z1_edhuri-za")
          @frizaframe = 0
        end
        
        @frizaframe += 1 
        rect = Rect.new(0, 0, 640, 320)
        @anime_window.contents.blt(0 ,0,picture,rect)
        if Input.trigger?(Input::C)
          Cache.clear
          set_skn
          result = 1 #終了
        else
          result = 0
        end
      end
      #text = Input.trigger?(Input::C)
      #text = "フレーム数：" + @animeframe.to_s
      #@anime_window.contents.draw_text( 0, 0, 300, 28, text)
      #@anime_window.update
      
      Graphics.update
      

      @animeframe +=1
    end while result != 1
    @anime_window.contents.clear
    #$scene = Scene_Title.new
    $game_variables[41] = 901
    #====以下1行ウィロー編のためコメントアウト
    #$game_variables[41] = 281
    #$game_player.reserve_transfer(7, 1, 1, 0) # 場所移動
    Graphics.fadeout(30)
  end
end