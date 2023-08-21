#==============================================================================
# ■ Title_Anime
#------------------------------------------------------------------------------
# 　タイトルのアニメ表示
#==============================================================================
module Z_gaiden_op #< Scene_Base
  include Share
   #--------------------------------------------------------------------------
  # ● Z3セルゲーム編オープニングタイトル表示メイン
  # カットイン暗転(一枚絵)
  #--------------------------------------------------------------------------   
  def z_gaiden_op_rev1
    @animeframe = 0    #総フレーム数
    @anime_window = Window_Base.new(-16,-16,672,512)
    @anime_window.opacity=0
    @anime_window.back_opacity=0
    
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
    frapic.z = 205
    rect = Rect.new(0, 0, 640, 480)
    frapic.src_rect = rect
    frapic.bitmap.fill_rect(0,0,640,480,color)
    frapic.visible = false
    
    zyougetyouseiy = 20
    iwauepic = Sprite.new
    iwauepic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_岩_上段")
    iwauepic.x = 128
    iwauepic.y = 480 - 128 - 64 - 32 - zyougetyouseiy
    iwauepic.z = 200
    rect = Rect.new(0, 0, 512, 32)
    iwauepic.src_rect = rect
    iwauepic.visible = false
    iwauextbl = [0,2] #横移動量管理テーブル
    iwauextbl_no = 0 #横移動量何番目を読み込むか
    
    iwaue2pic = Sprite.new
    iwaue2pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_岩_上段")
    iwaue2pic.x = 128 - 512
    iwaue2pic.y = iwauepic.y
    iwaue2pic.z = 200
    rect = Rect.new(0, 0, 512, 32)
    iwaue2pic.src_rect = rect
    iwaue2pic.visible = false
    iwaue2xtbl = [0,2] #横移動量管理テーブル
    iwaue2xtbl_no = 0 #横移動量何番目を読み込むか

    hosiuepic = Sprite.new
    hosiuepic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_上段")
    hosiuepic.x = 128 - 512 - 512
    hosiuepic.y = iwauepic.y
    hosiuepic.z = 200
    rect = Rect.new(0, 0, 512, 32)
    hosiuepic.src_rect = rect
    hosiuepic.visible = false
    hosiuextbl = [0,2] #横移動量管理テーブル
    hosiuextbl_no = 0 #横移動量何番目を読み込むか
    
    hosiue2pic = Sprite.new
    hosiue2pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_上段")
    hosiue2pic.x = 128 - 512 - 512 - 512
    hosiue2pic.y = iwauepic.y
    hosiue2pic.z = 200
    rect = Rect.new(0, 0, 512, 32)
    hosiue2pic.src_rect = rect
    hosiue2pic.visible = false
    hosiue2xtbl = [0,2] #横移動量管理テーブル
    hosiue2xtbl_no = 0 #横移動量何番目を読み込むか

    hosiue3pic = Sprite.new
    hosiue3pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_上段")
    hosiue3pic.x = 128 - 512 - 512 - 512 - 512
    hosiue3pic.y = iwauepic.y
    hosiue3pic.z = 200
    rect = Rect.new(0, 0, 512, 32)
    hosiue3pic.src_rect = rect
    hosiue3pic.visible = false
    hosiue3xtbl = [0,2] #横移動量管理テーブル
    hosiue3xtbl_no = 0 #横移動量何番目を読み込むか
    
    iwanakapic = Sprite.new
    iwanakapic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_岩_中段")
    iwanakapic.x = 128
    iwanakapic.y = 480 - 128 - 64 - zyougetyouseiy
    iwanakapic.z = 200
    rect = Rect.new(0, 0, 512, 64)
    iwanakapic.src_rect = rect
    iwanakapic.visible = false
    iwanakaxtbl = [0,2,2,2] #横移動量管理テーブル
    iwanakaxtbl_no = 0 #横移動量何番目を読み込むか

    iwanaka2pic = Sprite.new
    iwanaka2pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_岩_中段")
    iwanaka2pic.x = 128 - 512
    iwanaka2pic.y = iwanakapic.y
    iwanaka2pic.z = 200
    rect = Rect.new(0, 0, 512, 64)
    iwanaka2pic.src_rect = rect
    iwanaka2pic.visible = false
    iwanaka2xtbl = [0,2,2,2] #横移動量管理テーブル
    iwanaka2xtbl_no = 0 #横移動量何番目を読み込むか
    
    hosinakapic = Sprite.new
    hosinakapic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_中段")
    hosinakapic.x = 128 - 512 - 512
    hosinakapic.y = iwanakapic.y
    hosinakapic.z = 200
    rect = Rect.new(0, 0, 512, 64)
    hosinakapic.src_rect = rect
    hosinakapic.visible = false
    hosinakaxtbl = [0,2,2,2] #横移動量管理テーブル
    hosinakaxtbl_no = 0 #横移動量何番目を読み込むか
    
    hosinaka2pic = Sprite.new
    hosinaka2pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_中段")
    hosinaka2pic.x = 128 - 512 - 512 - 512
    hosinaka2pic.y = iwanakapic.y
    hosinaka2pic.z = 200
    rect = Rect.new(0, 0, 512, 64)
    hosinaka2pic.src_rect = rect
    hosinaka2pic.visible = false
    hosinaka2xtbl = [0,2,2,2] #横移動量管理テーブル
    hosinaka2xtbl_no = 0 #横移動量何番目を読み込むか
    
    hosinaka3pic = Sprite.new
    hosinaka3pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_中段")
    hosinaka3pic.x = 128 - 512 - 512 - 512 - 512
    hosinaka3pic.y = iwanakapic.y
    hosinaka3pic.z = 200
    rect = Rect.new(0, 0, 512, 64)
    hosinaka3pic.src_rect = rect
    hosinaka3pic.visible = false
    hosinaka3xtbl = [0,2,2,2] #横移動量管理テーブル
    hosinaka3xtbl_no = 0 #横移動量何番目を読み込むか
    
    hosinaka4pic = Sprite.new
    hosinaka4pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_中段")
    hosinaka4pic.x = 128 - 512 - 512 - 512 - 512 - 512
    hosinaka4pic.y = iwanakapic.y
    hosinaka4pic.z = 200
    rect = Rect.new(0, 0, 512, 64)
    hosinaka4pic.src_rect = rect
    hosinaka4pic.visible = false
    hosinaka4xtbl = [0,2,2,2] #横移動量管理テーブル
    hosinaka4xtbl_no = 0 #横移動量何番目を読み込むか
    
    iwasitapic = Sprite.new
    iwasitapic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_岩_下段")
    iwasitapic.x = 128
    iwasitapic.y = 480  - 128 - zyougetyouseiy
    iwasitapic.z = 200
    rect = Rect.new(0, 0, 512, 128)
    iwasitapic.src_rect = rect
    iwasitapic.visible = false
    iwasitaxtbl = [2,2,2,2,2,2,2,4] #横移動量管理テーブル
    iwasitaxtbl_no = 0 #横移動量何番目を読み込むか

    iwasita2pic = Sprite.new
    iwasita2pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_岩_下段")
    iwasita2pic.x = 128 - 512
    iwasita2pic.y = iwasitapic.y
    iwasita2pic.z = 200
    rect = Rect.new(0, 0, 512, 128)
    iwasita2pic.src_rect = rect
    iwasita2pic.visible = false
    iwasita2xtbl = [2,2,2,2,2,2,2,4] #横移動量管理テーブル
    iwasita2xtbl_no = 0 #横移動量何番目を読み込むか

    hosisitapic = Sprite.new
    hosisitapic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_下段")
    hosisitapic.x = 128 - 512 - 512
    hosisitapic.y = iwasitapic.y
    hosisitapic.z = 200
    rect = Rect.new(0, 0, 512, 128)
    hosisitapic.src_rect = rect
    hosisitapic.visible = false
    hosisitaxtbl = [2,2,2,2,2,2,2,4] #横移動量管理テーブル
    hosisitaxtbl_no = 0 #横移動量何番目を読み込むか
    
    hosisita2pic = Sprite.new
    hosisita2pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_下段")
    hosisita2pic.x = 128 - 512 - 512- 512
    hosisita2pic.y = iwasitapic.y
    hosisita2pic.z = 200
    rect = Rect.new(0, 0, 512, 128)
    hosisita2pic.src_rect = rect
    hosisita2pic.visible = false
    hosisita2xtbl = [2,2,2,2,2,2,2,4] #横移動量管理テーブル
    hosisita2xtbl_no = 0 #横移動量何番目を読み込むか
    
    hosisita3pic = Sprite.new
    hosisita3pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_下段")
    hosisita3pic.x = 128 - 512 - 512 - 512 - 512
    hosisita3pic.y = iwasitapic.y
    hosisita3pic.z = 200
    rect = Rect.new(0, 0, 512, 128)
    hosisita3pic.src_rect = rect
    hosisita3pic.visible = false
    hosisita3xtbl = [2,2,2,2,2,2,2,4] #横移動量管理テーブル
    hosisita3xtbl_no = 0 #横移動量何番目を読み込むか
    
    hosisita4pic = Sprite.new
    hosisita4pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_下段")
    hosisita4pic.x = 128 - 512 - 512 - 512 - 512 - 512
    hosisita4pic.y = iwasitapic.y
    hosisita4pic.z = 200
    rect = Rect.new(0, 0, 512, 128)
    hosisita4pic.src_rect = rect
    hosisita4pic.visible = false
    hosisita4xtbl = [2,2,2,2,2,2,2,4] #横移動量管理テーブル
    hosisita4xtbl_no = 0 #横移動量何番目を読み込むか

    hosisita5pic = Sprite.new
    hosisita5pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_下段")
    hosisita5pic.x = 128 - 512 - 512 - 512 - 512 - 512 - 512
    hosisita5pic.y = iwasitapic.y
    hosisita5pic.z = 200
    rect = Rect.new(0, 0, 512, 128)
    hosisita5pic.src_rect = rect
    hosisita5pic.visible = false
    hosisita5xtbl = [2,2,2,2,2,2,2,4] #横移動量管理テーブル
    hosisita5xtbl_no = 0 #横移動量何番目を読み込むか
    
    hosisita6pic = Sprite.new
    hosisita6pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_下段")
    hosisita6pic.x = 128 - 512 - 512 - 512 - 512 - 512 - 512 - 512
    hosisita6pic.y = iwasitapic.y
    hosisita6pic.z = 200
    rect = Rect.new(0, 0, 512, 128)
    hosisita6pic.src_rect = rect
    hosisita6pic.visible = false
    hosisita6xtbl = [2,2,2,2,2,2,2,4] #横移動量管理テーブル
    hosisita6xtbl_no = 0 #横移動量何番目を読み込むか
    
    hosihaikeipic = Sprite.new
    hosihaikeipic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_背景1")
    hosihaikeipic.x = 128
    hosihaikeipic.y = 0 + zyougetyouseiy
    hosihaikeipic.z = 200
    rect = Rect.new(0, 0, 512, 256)
    hosihaikeipic.src_rect = rect
    hosihaikeipic.visible = false
    hosihaikeixtbl = [0,0,0,2] #横移動量管理テーブル
    hosihaikeixtbl_no = 0 #横移動量何番目を読み込むか

    hosihaikei2pic = Sprite.new
    hosihaikei2pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_背景1")
    hosihaikei2pic.x = 128 - 512
    hosihaikei2pic.y = hosihaikeipic.y
    hosihaikei2pic.z = 200
    rect = Rect.new(0, 0, 512, 256)
    hosihaikei2pic.src_rect = rect
    hosihaikei2pic.visible = false
    hosihaikei2xtbl = [0,0,0,2] #横移動量管理テーブル
    hosihaikei2xtbl_no = 0 #横移動量何番目を読み込むか
    
    hosihaikei3pic = Sprite.new
    hosihaikei3pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_背景2")
    hosihaikei3pic.x = 128 - 512
    hosihaikei3pic.y = hosihaikeipic.y
    hosihaikei3pic.z = 200
    rect = Rect.new(0, 0, 512, 256)
    hosihaikei3pic.src_rect = rect
    hosihaikei3pic.visible = false
    hosihaikei3xtbl = [0,0,0,2] #横移動量管理テーブル
    hosihaikei3xtbl_no = 0 #横移動量何番目を読み込むか
    
    hosihaikei4pic = Sprite.new
    hosihaikei4pic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_星_背景2")
    hosihaikei4pic.x = 128 - 512 - 512
    hosihaikei4pic.y = hosihaikeipic.y
    hosihaikei4pic.z = 200
    rect = Rect.new(0, 0, 512, 256)
    hosihaikei4pic.src_rect = rect
    hosihaikei4pic.visible = false
    hosihaikei4xtbl = [0,0,0,2] #横移動量管理テーブル
    hosihaikei4xtbl_no = 0 #横移動量何番目を読み込むか
    
    tikyupic = Sprite.new
    tikyupic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_地球_まとめ")
    tikyupic.x = -82
    tikyupic.y = 480 - 230
    tikyupic.z = 210
    rect = Rect.new(0, 0, 82, 94)
    tikyupic.src_rect = rect
    tikyupic.visible = true
    tikyuxtbl = [0,2] #横移動量管理テーブル
    tikyuxtbl_no = 0 #横移動量何番目を読み込むか
    tikyuytbl = [2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,2,0,0,2,0,2,0,0,2,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2]
    tikyuytbl_no = 0 #横移動量何番目を読み込むか
    mozipic = Sprite.new
    
    mozi = ""
    output_mozi mozi
    mozipic.bitmap = $tec_mozi
    mozipic.x = 100
    mozipic.y = tikyupic.y + 40
    mozipic.z = 210
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    mozipic.src_rect = rect
    mozipic.visible = false
    mozipic.tone = Tone.new(255,255,255)
    
    mepic = Sprite.new
    mepic.bitmap = Bitmap.new("Graphics/Pictures/zgop/ZG_OP_目_まとめ")
    mepic.x = 240
    mepic.y = 480 - 130
    mepic.z = 210
    rect = Rect.new(0, 0, 160, 30)
    mepic.src_rect = rect
    mepic.visible = false
    
    movestopframe = 1484
    tikyuupframe = 2182
    tikyuupstopframe = 2394
    meputframe = 2478
    tikyumawaruframe = meputframe + 8 + 8 + 440 + 16 + 16 + 36
    
    end_frame = tikyumawaruframe + 108 + 40
    Audio.se_play("Audio/SE/" +"ZG イベント6")
    begin
      
      #if @animeframe == 1204 # 画面サイズが違うため-64フレーム目で動かす
      #  p "地球現れる"
      #elsif @animeframe == 1484
      #  p "地球止まる"
      #end
      
      #音を鳴らす
      if @animeframe == tikyumawaruframe + 84
        Audio.se_play("Audio/SE/" +"ZG SE038")
      end
      #地球回る関連
      case @animeframe
      when tikyumawaruframe
        rect = Rect.new(0, 94*1, 82, 94)
        tikyupic.src_rect = rect
      when tikyumawaruframe + 4
        rect = Rect.new(0, 94*2, 82, 94)
        tikyupic.src_rect = rect
      when tikyumawaruframe + 8
        rect = Rect.new(0, 94*3, 82, 94)
        tikyupic.src_rect = rect
      when tikyumawaruframe + 12
        rect = Rect.new(0, 94*4, 82, 94)
        tikyupic.src_rect = rect
      when tikyumawaruframe + 16
        rect = Rect.new(0, 94*5, 82, 94)
        tikyupic.src_rect = rect
      when tikyumawaruframe + 20
        rect = Rect.new(0, 94*6, 82, 94)
        tikyupic.src_rect = rect
      when tikyumawaruframe + 92
        rect = Rect.new(0, 94*7, 82, 94)
        tikyupic.src_rect = rect
        #フラッシュ用
        frapic.bitmap.fill_rect(0,0,640,480,color3)
        frapic.visible = true
      when tikyumawaruframe + 100
        rect = Rect.new(0, 94*8, 82, 94)
        tikyupic.src_rect = rect
        #フラッシュ用
        frapic.bitmap.fill_rect(0,0,640,480,color2)

      when tikyumawaruframe + 108
        tikyupic.visible = false
        #フラッシュ用
        frapic.bitmap.fill_rect(0,0,640,480,color)
      end
      
      #目表示関係
      case @animeframe
      
      when meputframe,meputframe + 8 + 8 + 440 + 16
        mepic.visible = true
        rect = Rect.new(0, 30*0, 160, 30)
        mepic.src_rect = rect
      when meputframe + 8,meputframe + 8 + 8 + 440
        rect = Rect.new(0, 30*1, 160, 30)
        mepic.src_rect = rect
      when meputframe + 8 + 8
        rect = Rect.new(0, 30*2, 160, 30)
        mepic.src_rect = rect
      when meputframe + 8 + 8 + 440 + 16 + 16
        mepic.visible = false
      end
      #文字表示関係
      case @animeframe
      when movestopframe + 76,movestopframe + 76 + 8 + 8 + 92 + 4
        mozi = "われわれが　ころされてしまうとは…"
        output_mozi mozi
        mozipic.bitmap = $tec_mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        mozipic.src_rect = rect
        mozipic.tone = Tone.new(127,127,127)
        mozipic.x = 174
        mozipic.y = tikyupic.y + 130
        mozipic.visible = true
      when movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92,movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8 + 8 + 92 + 4
        mozi = "おのれ　サイヤじん…"
        output_mozi mozi
        mozipic.bitmap = $tec_mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        mozipic.src_rect = rect
        mozipic.tone = Tone.new(127,127,127)
        mozipic.x = 240
        mozipic.y = tikyupic.y + 130
        mozipic.visible = true
      when movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8 + 8 + 92 + 4 + 4 + 116,movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8 + 8 + 92 + 4 + 4 + 116 + 8 + 64 + 4
        mozi = "もう1ど　チャンスがあれば！"
        output_mozi mozi
        mozipic.bitmap = $tec_mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        mozipic.src_rect = rect
        mozipic.tone = Tone.new(127,127,127)
        mozipic.x = 204
        mozipic.y = tikyupic.y + 130
        mozipic.visible = true
      when meputframe + 8 + 8 + 82,meputframe + 8 + 8 + 82 + 8 + 92 + 4
        mozi = "そのねがい　かなえてやるぞ…"
        output_mozi mozi
        mozipic.bitmap = $tec_mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        mozipic.src_rect = rect
        mozipic.tone = Tone.new(127,127,127)
        mozipic.x = 204
        mozipic.y = tikyupic.y + 150
        mozipic.visible = true
      when meputframe + 8 + 8 + 288,meputframe + 8 + 8 + 440 + 16
        mozi = "サイヤじんを　ほろぼすのだ！"
        output_mozi mozi
        mozipic.bitmap = $tec_mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        mozipic.src_rect = rect
        mozipic.tone = Tone.new(127,127,127)
        mozipic.x = 204
        mozipic.y = tikyupic.y + 150
        mozipic.visible = true
        
      when movestopframe + 76 + 8,movestopframe + 76 + 8 + 8 + 92,
        movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8,movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8 + 8 + 92,
        movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8 + 8 + 92 + 4 + 4 + 116 + 8,movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8 + 8 + 92 + 4 + 4 + 116 + 8 + 64,
        meputframe + 8 + 8 + 82,meputframe + 8 + 8 + 82 + 8 + 92,
        meputframe + 8 + 8 + 288 + 8,meputframe + 8 + 8 + 440
        mozipic.tone = Tone.new(188,188,188)

      when movestopframe + 76 + 8 + 8,
        movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8 + 8,
        movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8 + 8 + 92 + 4 + 4 + 116 + 8 + 8,
        meputframe + 8 + 8 + 82 + 8,
        meputframe + 8 + 8 + 288 + 8 + 8
        mozipic.tone = Tone.new(255,255,255)
      
      when movestopframe + 76 + 8 + 8 + 92 + 4 + 4,
        movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8 + 8 + 92 + 4 + 4,
        movestopframe + 76 + 8 + 8 + 92 + 4 + 4 + 92 + 8 + 8 + 92 + 4 + 4 + 116 + 8 + 64 + 4 + 4,
        meputframe + 8 + 8 + 82 + 8 + 92 + 4 + 4,
        meputframe + 8 + 8 + 440 + 16 + 16
        
        #文字消す
        mozipic.visible = false
      end
        
      if movestopframe > @animeframe
        #ピクチャ移動
        #p iwauextbl[iwauextbl_no],iwauextbl_no.length,iwauextbl_no
        iwauepic.x += iwauextbl[iwauextbl_no]
        iwaue2pic.x += iwauextbl[iwauextbl_no]
        iwanakapic.x += iwanakaxtbl[iwanakaxtbl_no]
        iwanaka2pic.x += iwanaka2xtbl[iwanaka2xtbl_no]
        iwasitapic.x += iwasitaxtbl[iwasitaxtbl_no]
        iwasita2pic.x += iwasita2xtbl[iwasita2xtbl_no]
        hosihaikeipic.x += hosihaikeixtbl[hosihaikeixtbl_no]
        hosihaikei2pic.x += hosihaikei2xtbl[hosihaikei2xtbl_no]
        hosihaikei3pic.x += hosihaikei3xtbl[hosihaikei3xtbl_no]
        hosihaikei4pic.x += hosihaikei4xtbl[hosihaikei4xtbl_no]
        
        hosiuepic.x += hosiuextbl[hosiuextbl_no]
        hosiue2pic.x += hosiue2xtbl[hosiue2xtbl_no]
        hosiue3pic.x += hosiue2xtbl[hosiue3xtbl_no]
        hosinakapic.x += hosinakaxtbl[hosinakaxtbl_no]
        hosinaka2pic.x += hosinaka2xtbl[hosinaka2xtbl_no]
        hosinaka3pic.x += hosinaka3xtbl[hosinaka3xtbl_no]
        hosinaka4pic.x += hosinaka4xtbl[hosinaka4xtbl_no]
        hosisitapic.x += hosisitaxtbl[hosisitaxtbl_no]
        hosisita2pic.x += hosisita2xtbl[hosisita2xtbl_no]
        hosisita3pic.x += hosisita3xtbl[hosisita3xtbl_no]
        hosisita4pic.x += hosisita4xtbl[hosisita4xtbl_no]
        hosisita5pic.x += hosisita5xtbl[hosisita5xtbl_no]
        hosisita6pic.x += hosisita6xtbl[hosisita6xtbl_no]
        
        if @animeframe >= 1125
          tikyupic.x += tikyuxtbl[tikyuxtbl_no]
        end
        #ピクチャ表示管理(処理が重くならないように余計なものは表示しない)
        iwauepic.visible = true if iwauepic.x > -512
        iwaue2pic.visible = true if iwaue2pic.x > -512
        iwanakapic.visible = true if iwanakapic.x > -512
        iwanaka2pic.visible = true if iwanaka2pic.x > -512
        iwasitapic.visible = true if iwasitapic.x > -512
        iwasita2pic.visible = true if iwasita2pic.x > -512
        hosihaikeipic.visible = true if hosihaikeipic.x > -512
        hosihaikei2pic.visible = true if hosihaikei2pic.x > -512
        hosihaikei3pic.visible = true if hosihaikei3pic.x > -512
        hosihaikei4pic.visible = true if hosihaikei4pic.x > -512
        hosiuepic.visible = true if hosiuepic.x > -512
        hosiue2pic.visible = true if hosiue2pic.x > -512
        hosiue3pic.visible = true if hosiue3pic.x > -512
        hosinakapic.visible = true if hosinakapic.x > -512
        hosinaka2pic.visible = true if hosinaka2pic.x > -512
        hosinaka3pic.visible = true if hosinaka3pic.x > -512
        hosinaka4pic.visible = true if hosinaka4pic.x > -512
        hosisitapic.visible = true if hosisitapic.x > -512
        hosisita2pic.visible = true if hosisita2pic.x > -512
        hosisita3pic.visible = true if hosisita3pic.x > -512
        hosisita4pic.visible = true if hosisita4pic.x > -512
        hosisita5pic.visible = true if hosisita5pic.x > -512
        hosisita6pic.visible = true if hosisita6pic.x > -512
        
        iwauepic.visible = false if iwauepic.x > 640
        iwaue2pic.visible = false if iwaue2pic.x > 640
        iwanakapic.visible = false if iwanakapic.x > 640
        iwanaka2pic.visible = false if iwanaka2pic.x > 640
        iwasitapic.visible = false if iwasitapic.x > 640
        iwasita2pic.visible = false if iwasita2pic.x > 640
        hosihaikeipic.visible = false if hosihaikeipic.x > 640
        hosihaikei2pic.visible = false if hosihaikei2pic.x > 640
        hosihaikei3pic.visible = false if hosihaikei3pic.x > 640
        hosihaikei4pic.visible = false if hosihaikei4pic.x > 640
        hosiuepic.visible = false if hosiuepic.x > 640
        hosiue2pic.visible = false if hosiue2pic.x > 640
        hosiue3pic.visible = false if hosiue3pic.x > 640
        hosinakapic.visible = false if hosinakapic.x > 640
        hosinaka2pic.visible = false if hosinaka2pic.x > 640
        hosinaka3pic.visible = false if hosinaka3pic.x > 640
        hosinaka4pic.visible = false if hosinaka4pic.x > 640
        hosisitapic.visible = false if hosisitapic.x > 640
        hosisita2pic.visible = false if hosisita2pic.x > 640
        hosisita3pic.visible = false if hosisita3pic.x > 640
        hosisita4pic.visible = false if hosisita4pic.x > 640
        hosisita5pic.visible = false if hosisita5pic.x > 640
        hosisita6pic.visible = false if hosisita6pic.x > 640
      end
      
      #地球移動
      if tikyuupframe < @animeframe && tikyuupstopframe > @animeframe
        tikyupic.y -= tikyuytbl[tikyuytbl_no]
      end
      
      @animeframe += 1

      
      Input.update
      #@anime_window.contents.clear
      #text = "フレーム数：" + @animeframe.to_s
      #@anime_window.contents.draw_text( 0, 0, 300, 28, text)
      #@anime_window.update
      
      Graphics.update
      
      if movestopframe > @animeframe
        #tbl_no更新
        iwauextbl_no += 1
        iwauextbl_no = 0 if iwauextbl.size <= iwauextbl_no
        iwaue2xtbl_no += 1
        iwaue2xtbl_no = 0 if iwaue2xtbl.size <= iwaue2xtbl_no
        iwanakaxtbl_no += 1
        iwanakaxtbl_no = 0 if iwanakaxtbl.size <= iwanakaxtbl_no
        iwanaka2xtbl_no += 1
        iwanaka2xtbl_no = 0 if iwanaka2xtbl.size <= iwanaka2xtbl_no
        iwasitaxtbl_no += 1
        iwasitaxtbl_no = 0 if iwasitaxtbl.size <= iwasitaxtbl_no
        iwasita2xtbl_no += 1
        iwasita2xtbl_no = 0 if iwasita2xtbl.size <= iwasita2xtbl_no
        hosihaikeixtbl_no += 1
        hosihaikeixtbl_no = 0 if hosihaikeixtbl.size <= hosihaikeixtbl_no
        hosihaikei2xtbl_no += 1
        hosihaikei2xtbl_no = 0 if hosihaikei2xtbl.size <= hosihaikei2xtbl_no
        hosihaikei3xtbl_no += 1
        hosihaikei3xtbl_no = 0 if hosihaikei3xtbl.size <= hosihaikei3xtbl_no
        hosihaikei4xtbl_no += 1
        hosihaikei4xtbl_no = 0 if hosihaikei4xtbl.size <= hosihaikei4xtbl_no
        hosiuextbl_no += 1
        hosiuextbl_no = 0 if hosiuextbl.size <= hosiuextbl_no
        hosiue2xtbl_no += 1
        hosiue2xtbl_no = 0 if hosiue2xtbl.size <= hosiue2xtbl_no
        hosiue3xtbl_no += 1
        hosiue3xtbl_no = 0 if hosiue3xtbl.size <= hosiue3xtbl_no
        hosinakaxtbl_no += 1
        hosinakaxtbl_no = 0 if hosinakaxtbl.size <= hosinakaxtbl_no
        hosinaka2xtbl_no += 1
        hosinaka2xtbl_no = 0 if hosinaka2xtbl.size <= hosinaka2xtbl_no
        hosinaka3xtbl_no += 1
        hosinaka3xtbl_no = 0 if hosinaka3xtbl.size <= hosinaka3xtbl_no
        hosinaka4xtbl_no += 1
        hosinaka4xtbl_no = 0 if hosinaka4xtbl.size <= hosinaka4xtbl_no
        hosisitaxtbl_no += 1
        hosisitaxtbl_no = 0 if hosisitaxtbl.size <= hosisitaxtbl_no
        hosisita2xtbl_no += 1
        hosisita2xtbl_no = 0 if hosisita2xtbl.size <= hosisita2xtbl_no
        hosisita3xtbl_no += 1
        hosisita3xtbl_no = 0 if hosisita3xtbl.size <= hosisita3xtbl_no
        hosisita4xtbl_no += 1
        hosisita4xtbl_no = 0 if hosisita4xtbl.size <= hosisita4xtbl_no
        hosisita5xtbl_no += 1
        hosisita5xtbl_no = 0 if hosisita5xtbl.size <= hosisita5xtbl_no
        hosisita6xtbl_no += 1
        hosisita6xtbl_no = 0 if hosisita6xtbl.size <= hosisita6xtbl_no
        tikyuxtbl_no += 1
        tikyuxtbl_no = 0 if tikyuxtbl.size <= tikyuxtbl_no
      end
      
      if tikyuupframe < @animeframe
        tikyuytbl_no += 1
        tikyuytbl_no = 0 if tikyuytbl.size <= tikyuytbl_no
        #p @animeframe if tikyuytbl.size <= tikyuytbl_no
      end
      if Input.trigger?(Input::C) || end_frame == @animeframe
        result = 1 #オープニング終了
      end
    end while result != 1
    #if picture != nil
    #  #picture.bitmap.dispose   # 画像を消去
    #  picture.dispose          # スプライトを消去
    #end
    Cache.clear
    @anime_window.dispose
    @anime_window = nil
    Audio.se_stop
    frapic.visible = nil
    iwauepic.visible = nil
    iwaue2pic.visible = nil
    hosiuepic.visible = nil
    hosiue2pic.visible = nil
    hosiue3pic.visible = nil
    iwanakapic.visible = nil
    iwanaka2pic.visible = nil
    hosinakapic.visible = nil
    hosinaka2pic.visible = nil
    hosinaka3pic.visible = nil
    hosinaka4pic.visible = nil
    iwasitapic.visible = nil
    iwasita2pic.visible = nil
    hosisitapic.visible = nil
    hosisita2pic.visible = nil
    hosisita3pic.visible = nil
    hosisita4pic.visible = nil
    hosisita5pic.visible = nil
    hosisita6pic.visible = nil
    hosihaikeipic.visible = nil
    hosihaikei2pic.visible = nil
    hosihaikei3pic.visible = nil
    hosihaikei4pic.visible = nil
    tikyupic.visible = nil
    mozipic.visible = nil
    mepic.visible = nil
    
  end   

  
end