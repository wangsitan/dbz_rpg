#==============================================================================
# ■ Title_Anime
#------------------------------------------------------------------------------
# 　タイトルのアニメ表示
#==============================================================================
module Z_ed #< Scene_Base
include Share

PIC_PUT_START_Y = 480#-16*3
   #--------------------------------------------------------------------------
  # ● Z3セルゲーム編オープニングタイトル表示メイン
  # カットイン暗転(一枚絵)
  #--------------------------------------------------------------------------   
  def z_ed_rev1
    
    #フレームレート初期化
    $fast_fps = false
    Graphics.frame_rate = 60
    
    
    @animeframe = 0    #総フレーム数
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    
    @text_list=[] #スタッフロール文字列テキスト
    @staff_roll_pic = [] #スタッフロール文字列画像
    @staff_roll_end_pic = [] #スタッフロール最後の文字列画像
    @back_pic = [] #背景画像
    end_frame = 11900 #12100
    result = 0

    color = Color.new(255,255,255,256)
    color2 = Color.new(188,188,188,256)
    color3 = Color.new(127,127,127,256)
    color4 = Color.new(0,0,0,256)

    @back_pic[0] = Sprite.new
    @back_pic[1] = Sprite.new
    rect = Rect.new(0, 0,640,480)
    @back_pic[0].src_rect = rect
    @back_pic[0].bitmap = Bitmap.new("Graphics/Pictures/zed/背景1")
    @back_pic[0].x = 0
    @back_pic[0].y = 0
    @back_pic[0].visible = true
    @back_pic[0].opacity = 255
    @back_pic[0].z = 2
    @back_pic[1].src_rect = rect
    @back_pic[1].bitmap = Bitmap.new("Graphics/Pictures/zed/背景2")
    @back_pic[1].x = 0
    @back_pic[1].y = 0
    @back_pic[1].visible = false
    @back_pic[1].opacity = 255
    @back_pic[1].z = 3
    
    color4 = Color.new(0,0,0,256)
    
    frapic = Sprite.new
    frapic.bitmap = Bitmap.new("Graphics/System/Title3_2_dummy")
    frapic.x = 0
    frapic.y = 0
    frapic.z = 1
    rect = Rect.new(0, 0, 640, 480)
    frapic.src_rect = rect
    frapic.bitmap.fill_rect(0,0,640,480,color4)
    frapic.visible = true 
    
    @syuugo_pic = Sprite.new
    @syuugo_pic.bitmap = Bitmap.new("Graphics/Pictures/集合絵_修正")
    @syuugo_pic.x = 0
    @syuugo_pic.y = 0
    @syuugo_pic.visible = false
    @syuugo_pic.opacity = 0
    @syuugo_pic.z = 11
    #@animeframe = 11800
    
    set_staff_roll

    pic_up_dot = 2
    pic_up_frame = 3
    
    #picture.opacity = 255
    Audio.bgm_stop
    Audio.se_play("Audio/BGM/" +"Z1 エンディング")
    begin

      @animeframe += 1
      
      #背景切り替え
      up_date_back_pic
      
      #スタッフロール移動
      if @animeframe % pic_up_frame == 0
        for x in 0..@staff_roll_pic.size-1
          if x == 0
            @staff_roll_pic[x].visible = true
            @staff_roll_pic[x].y -= pic_up_dot
          else
            if @staff_roll_pic[x-1].y < PIC_PUT_START_Y - 16
              @staff_roll_pic[x].visible = true
              
              #p x,@staff_roll_pic.size-1,x -1
              if @staff_roll_pic.size-2 == x #最後センターで止める
                #p 1,@staff_roll_pic[x].y
                if @staff_roll_pic[x].y > 216
                  @staff_roll_pic[x].y -= pic_up_dot
                end
                
                
              elsif @staff_roll_pic.size-1 == x #最後センターで止める
                #p 2,@staff_roll_pic[x].y
                if @staff_roll_pic[x].y > 232
                  @staff_roll_pic[x].y -= pic_up_dot
                end
              else
                @staff_roll_pic[x].y -= pic_up_dot
              end
            end
          end
        end
      end
      #Input.update
      #text = "フレーム数：" + @animeframe.to_s
      #@anime_window.contents.draw_text( 0, 0, 300, 28, text)

      @anime_window.update
      
      Graphics.update
      
      #if Input.trigger?(Input::C) 
      #  result = 1 #オープニング終了
      #end
    end while @animeframe != end_frame #|| result != 1
    
    #最後の文字列用
    
    endmozicount = 0
    chgopcity_num = 2
    begin
      @animeframe += 1
      
      
      #エンドを表示
      if @staff_roll_pic[@staff_roll_pic.size-1].opacity != 0
        for x in 0..@staff_roll_pic.size-1
          @staff_roll_pic[x].opacity -= chgopcity_num
        end
      elsif @back_pic[0].opacity != 0
          @back_pic[0].opacity -= chgopcity_num * 2#* 24
          @back_pic[1].opacity -= chgopcity_num * 2#* 24
      elsif @staff_roll_pic[@staff_roll_pic.size-1].opacity == 0
        for x in 0..@staff_roll_end_pic.size-1
          @staff_roll_end_pic[x].opacity += chgopcity_num
          @syuugo_pic.visible = true
          @syuugo_pic.opacity += chgopcity_num

          #@back_pic[0].visible = false
          #@back_pic[1].visible = false
        end
        
      end
      #背景切り替え
      up_date_back_pic
      @anime_window.update
      Graphics.update
      endmozicount += 1 if @staff_roll_end_pic[@staff_roll_end_pic.size-1].opacity == 255
    end while endmozicount != 300
    
    begin
      @animeframe += 1
      if Input.trigger?(Input::C) 
        result = 1 #エンディング終了
      end
      #背景切り替え
      up_date_back_pic
      Input.update
      @anime_window.update
      Graphics.update
    end while result != 1
    
    begin
      
      @animeframe += 1
      #背景切り替え
      up_date_back_pic
      for x in 0..@staff_roll_end_pic.size-1
        @staff_roll_end_pic[x].opacity -= chgopcity_num
      end
      #@staff_roll_pic[@staff_roll_end_pic.size-1].opacity -= 1
      #@staff_roll_pic[@staff_roll_end_pic.size-2].opacity -= 1
      @anime_window.update
      Graphics.update
    end while @staff_roll_end_pic[@staff_roll_end_pic.size-1].opacity != 0
    #end while @staff_roll_pic[@staff_roll_pic.size-1].opacity != 0
    
    x = 0
    begin
      @animeframe += 1
      x += 1
      #背景切り替え
      up_date_back_pic
      
      @anime_window.update
      Graphics.update
    end while x != 180
    
    Graphics.fadeout(60)
    
    #if picture != nil
      #picture.bitmap.dispose   # 画像を消去
         # スプライトを消去
      for x in 0..@staff_roll_pic.size-1
        @staff_roll_pic[x].dispose
        @staff_roll_pic[x] = nil
      end
      
      for x in 0..@staff_roll_end_pic.size-1
        @staff_roll_end_pic[x].dispose
        @staff_roll_end_pic[x] = nil
      end
      
      @back_pic[0].dispose
      @back_pic[1].dispose
      
      @back_pic[0] = nil
      @back_pic[1] = nil
    #end
    
    @syuugo_pic.dispose
    @syuugo_pic = nil
    
    frapic.dispose
    frapic = nil
    
    Cache.clear
    @anime_window.dispose
    @anime_window = nil
    Graphics.fadein(60)
  end   
  
  def up_date_back_pic
    #背景切り替え
    if @animeframe % 8 == 0
      
      if @back_pic[0].visible == true
        @back_pic[0].visible = false
        @back_pic[1].visible = true
      else
        @back_pic[0].visible = true
        @back_pic[1].visible = false
      end
      
    end
  end
  
  def set_staff_roll #スタッフロールの文字列をセット
    
    #アンスコを空欄扱いにする
    text = "" #結合
    text_head = "" #ヘッダー
    text_foot = "" #フッター
    text_end = ""  #フッターの後の表示
    text_translate = ""#"GREYSS"
    text_adjust = "" #調整
    text_z1 = ""
    text_z2 = ""
    text_z3 = ""
    text_zd = ""
    text_zg = ""
    text_zrpg1 = ""
    text_zrpg2 = ""
    text_interval = "
































"
    
    text_head = "
___________ORIGINALGAME_STAFF___________
___________________||___________________


"

text_adjust = "








___________________||___________________
"

text_foot = "________THANKS_FOR_YOUR_PLAYING_________
___________DRAGONBALL_Z_RPG"

text_end =  "________THANK_YOU！！！_DRAGONBALL！！_______"


text_z1 = "_____________DRAGONBALL_Z_1_____________
__________KYOUSHUU！_SAIYA_JIN__________
            
            
_______________PRODUCTION
            
________DIRECTED_BY__OGINOME_HIROSHI
            
________PRODUCED_BY__BANDAI_CORP.
            
______PROGRAMMED_BY__TRACEY
            
___________STORY_BY__OGINOME_HIROSHI
            
__________EXECUTIVE__TAKASHI_SYOJI
___________PRODUSER
            
___________DESIGNER__H.OGINOME
            
_____________________N.SUGIMOTO
                      
_____________________S.SHIMADA
                      
_____________________S.KASUYA
                      
_____________________M.TAKAHASHI
                      
_____________________K.UDAGAWA
                      
_____________________H.TAMAI
                      
_____________________T.EGUCHI
                      
_____________________R.FUJISAWA
                      
_____________________JR
                      
_____________________A.TOMI
                      
_________PROGRAMMER__TRACEY
            
_____________________TAKAMI_YASUSHI
                        
_______SOUND_DESIGN__H.ADACHI
            
__________ASSISTANT__S.ROBERUTO
            
_____________________E.KOSAKA
                       
_____________________S.HASHIMOTO
                       
_____________________T.SUZUKI
                       
______DESIGN_OFFICE__D＆D_CORP.
            
            
_________@_BIRD_STUDIO／SHUEISHA

_________FUJI_TV.TOEI_ANIMATION
            
_____________@_BANDAI_1990
"

text_z2 ="_____________DRAGONBALL_Z_2_____________
___________GEKISHIN_FREEZA！！__________
            
            
_______________PRODUCTION
            
________DIRECTED_BY__NORIYUKI_SUGIMOTO
            
________PRODUCED_BY__BANDAI_CORP.
            
______PROGRAMMED_BY__TRACEY
            
___________STORY_BY__NORIYUKI_SUGIMOTO
            
__________EXECUTIVE__TAKASHI_SYOJI
___________PRODUSER
_____________________JR

___________DESIGNER__N.SUGIMOTO
            
_____________________T.EGUCHI
                      
_____________________MUGARUTIE
                      
_____________________SOBA

______1CH_ASSISTANT__MAMETA

_____________________MATSUNAGA
                        
______DESIGN_OFFICE__D＆D_CORP.
            
            
_________@_BIRD_STUDIO／SHUEISHA

_________FUJI_TV.TOEI_ANIMATION
            
_____________@_BANDAI_1991
"

text_z3 = "_____________DRAGONBALL_Z_3_____________
__________RESSEN_JINZOUNINGEN___________

_____________NO_END_CREDITS_____________


            
            
_________@_BIRD_STUDIO／SHUEISHA

_________FUJI_TV.TOEI_ANIMATION
            
_____________@_BANDAI_1992
"
#_____________NO_STAFF_ROLL______________

text_zd = "_____________DRAGONBALL_Z_______________
_______GEKITOU_TENKAICHI_BUDOKAI________
___________________||___________________
_____________NO_END_CREDITS_____________


            
            
_________@_BIRD_STUDIO／SHUEISHA

_________FUJI_TV.TOEI_ANIMATION
            
_____________@_BANDAI_1992
"

text_zg = "__________DRAGONBALL_Z_GAIDEN___________
______SAIYAJIN_ZETSUMETSU_KEIKAKU_______


_______________PRODUCTION
            
________DIRECTED_BY__SHOUJI_TAJIMA

_____________________NORIYUKI_SUGIMOTO
            
________PRODUCER_BY__YASUNOBU_OHKUBO
            
_________PROGRAMMER__IWADAI
            
_____________________PROCOROSSO
            
_____________________IWACHU
                        
_____________________OBOCCHI
                        
_____________________IWASHO
                        
_____________________P-SUKE
                        
_____________________IWAPYON
                        
___________STORY_BY__TAKAO KOYAMA
            
___________DESIGNER__MASAYUKI_TAKAHASI
            
_____________________DACKS-AKIKO
                      
_____________________HASUKEY-SOBA
                      
_____________________CHAUCHAU-SHIHO
                      
_____________________PRITTSU-YAE
                      
_______SOUND_DESIGN__U.MIYUKI
            
_____________________KUMAGORO
                       
________________1CH__YOKOYANMA
            
_____________________AMAYAN_SHINCHAN

_____________ASSIST__DRAGON_SUZUKI
            
_____________________YASUOMI_SHIMIZU
                       
_____________________TAKEO_ISOGAI

_______SUB_DESIGNER__TAKEZOU

_____________________KIMUNOJI

_____SPECIAL_THANKS__SHINSAKU_SIMADA

_____________________YUU_KONDOH

_____________________FUYUTO_TAKEDA

_____________________KOZO_MORISHITA

_____________________YASUO_MIYAKAWA

______DESIGN_OFFICE__D＆D_CORP.
            
            
_________@_BIRD_STUDIO／SHUEISHA

_________FUJI_TV.TOEI_ANIMATION
            
_____________@_BANDAI_1993

"

text_zrpg1 = "_____________CLONEGAME_STAFF____________
___________________||___________________

____________DRAGONBALL_Z_RPG_____________
__________CHOUSEN_CELL_GAME！！___________

_______________PRODUCTION

___________DESIGNER__8-GOU
            
_____________________124

_____________________SHIN

_______SOUND_DESIGN__RUSUTAKU

_____________________RITO_MIRION

_____________________RORUMI85

_____________________TN_SISYOU

_____________________QOO

_____________________IKA

_____________________KYURI

_____________________KOJI

_______________________________ETC..



"


#翻訳
if text_translate != ""
  
text_zrpg1 +=  "_____TEXT_TRANSLATE__" + text_translate + "

"

end

text_zrpg2 = "_____SPECIAL_THANKS__CLONEGAMEPARTY

_____________________DAIJIN

_____________________TANAKA

_______________________________ETC..



_________PROGRAMMER__DBZ_◆NQ57XXVZKI
__________CONCEIVED
________PRODUCER_BY
"



#DBZ_◆nq57XXvzKI

      text = text_head + text_z1 + text_interval + text_z2 + text_interval + text_z3 + text_interval + text_zd + text_interval + text_zg + text_interval + text_zrpg1 + text_zrpg2 + text_interval + text_adjust + text_foot
      x = 0
      text.each_line {|line| #改行を読み取り複数行表示する
        line.sub!("￥n", "") # ￥は半角に直す
        line = line.gsub("\r", "")#改行コード？が文字化けするので削除
        line = line.gsub("\n", "")#
        line = line.gsub(" ", "")#半角スペースも削除
        @text_list[x]=line
        output_ed_mozi @text_list[x]
        rect = Rect.new(16*0,16*0, 16*@text_list[x].split(//u).size,16)
        @staff_roll_pic[x] = Sprite.new
        @staff_roll_pic[x].src_rect = rect
        @staff_roll_pic[x].bitmap = $tec_mozi#.blt(0,0,$tec_mozi,rect)
        @staff_roll_pic[x].x = 0
        @staff_roll_pic[x].y = PIC_PUT_START_Y
        @staff_roll_pic[x].visible = false
        @staff_roll_pic[x].opacity = 255
        @staff_roll_pic[x].z = 4
        x += 1
      }

      #最後の文字用
      text = text_end
      x = 0
      text.each_line {|line| #改行を読み取り複数行表示する
        line.sub!("￥n", "") # ￥は半角に直す
        line = line.gsub("\r", "")#改行コード？が文字化けするので削除
        line = line.gsub("\n", "")#
        line = line.gsub(" ", "")#半角スペースも削除
        @text_list[x]=line
        output_ed_mozi @text_list[x]
        rect = Rect.new(16*0,16*0, 16*@text_list[x].split(//u).size,16)
        @staff_roll_end_pic[x] = Sprite.new
        @staff_roll_end_pic[x].src_rect = rect
        @staff_roll_end_pic[x].bitmap = $tec_mozi#.blt(0,0,$tec_mozi,rect)
        @staff_roll_end_pic[x].x = 0
        @staff_roll_end_pic[x].y = 414#224
        @staff_roll_end_pic[x].visible = true
        @staff_roll_end_pic[x].opacity = 0
        @staff_roll_end_pic[x].z = 21
        x += 1
      } 
      #mozi = "ABCDEFGHIJKLMNOPQRSTUVWXYZ／1234567890！＆,.@・"
    #output_ed_mozi mozi
    #picture.src_rect = rect
    #picture.bitmap = $tec_mozi.blt(0,0,$tec_mozi,rect)
  end
end