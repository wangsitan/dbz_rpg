#==============================================================================
# ■ Scene_Story_So_Far
#------------------------------------------------------------------------------
# 　あらすじ表示
#==============================================================================
class Scene_Story_So_Far < Scene_Base
  include Share
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize()

  end
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    @main_window = Window_Base.new(-16,-16,672,512)
    @main_window.opacity=0
    @main_window.back_opacity=0
    @titale_window = Window_Base.new(220,48,200,80)
    @titale_window.opacity=255
    @titale_window.back_opacity=255
    @titale_window.contents.font.color.set( 0, 0, 0)
    @titale_window.contents.font.size = 24
    @titale_window.contents.draw_text(40,5, 200, 40, "あらすじ")
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------   
  def dispose_main_window
    @main_window.dispose
    @main_window = nil
    @titale_window.dispose
    @titale_window = nil
  end 
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    Graphics.fadein(20)
    @z1_scenex = 224           #上背景位置X
    @z1_sceney = 46            #上背景位置Y
    @z1_scrollscenex = 64      #スクロール用上背景位置X
    @z1_scrollsceney = 316      #スクロール用上背景位置Y
    @ene1_x = @z1_scenex + 64 #上キャラ表示基準位置X
    @ene1_y = @z1_sceney + 32 #上キャラ表示基準位置Y
    @play_x = @z1_scenex + 64 #下キャラ(味方)表示基準位置X
    @play_y = @z1_scenex + 82 #下キャラ(味方)表示基準位置Y
    @message_window = Window_Message.new
    @bgm_start_time = Time.now
    @end_prelude_flag = false #前奏完了フラグ
    @scene_scroll_count = 0
    @chare_scroll_count = 0
    @chare_shake_count = 0
    @chare_shake_y = -2
    @msg_output_end = false
    @bgm_name = nil
    create_window
    set_bgm
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @message_window.dispose
    dispose_main_window
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  # 戻り値 "1" ：(メニュー画面を抜ける)
  #--------------------------------------------------------------------------   
  def update

    super
    
    case $game_variables[43] #あらすじNo
    
    when 0..20,51..80,101 # 0:ドラゴンレーダー取得前,1:ドラゴンレーダー取得後
      #if Time.now - @bgm_start_time >= 3.94 && @end_prelude_flag == false
      #  @end_prelude_flag = true
      #end
      put_story_scene $game_variables[43] #背景表示
      put_story $game_variables[43]       #メッセージ表示
    
    when 21..50
      $scene = Scene_Map.new
 
    end
    @message_window.update            # メッセージウィンドウを更新
    if $game_message.busy == false && @chare_scroll_count > 900
      Graphics.fadeout(30)
      #Audio.bgm_play("Audio/BGM/" + $map_bgm)
      $scene = Scene_Map.new
    end
  end
  #--------------------------------------------------------------------------
  # ● あらすじメッセージ表示
  # 引数：[story_no:あらすじno]
  #--------------------------------------------------------------------------   
  def put_story story_no
    text_list=[]
    text = nil
    x = 0
    case story_no
    
    when 0 #ドラゴンレーダー取得前
      if @msg_output_end == false
      text =
        "地球に　最大の危機が訪れた！
        悟空の実の兄　サイヤ人のラディッツは
        地球を侵略しに　やって来たのだ！

        ラディッツは　悟空の息子・悟飯を
        人質に取り　悟空を仲間にしようとする！！
        悟空一人では　とても　勝ち目がない！！

        そこに　意外な人物が現れた！　宿命のライバル　ピッコロだ！
        ピッコロにとっても　この恐るべきサイヤ人は彼の野望のジャマになる！
        ついに　地球最強のコンビが　誕生した！！
        早く　ドラゴンレーダーで　悟飯を探せ！！！"
      end
    
    when 1 #ドラゴンレーダー取得後
      if @msg_output_end == false
      text =
        "ブルマから貰った　ドラゴンレーダーで　何とか　悟飯の居所はつかめた！
        悟空とピッコロは　恐るべきパワーを持つ　サイヤ人軍団を
        打ち破り　ラディッツから　悟飯を　救出することが　出来るのか！？"
      end
      
    when 2 #蛇の道
      if @msg_output_end == false
      text =
        "悟空は　界王様に　修行を　してもらうために　
        長い　長い　蛇の道を　急がなくてはならない！
        急げ　悟空！
        さらに　強いサイヤ人が　地球にやって来るのは　１年後だ！"
      end
      
    when 3 #サンショエリア
      if @msg_output_end == false
      text =
        "地球の危機を　救うために　ドラゴンボールを集めなくてはならない！
        しかし　そのドラゴンボールを　新たな敵が　狙っている！
        世界征服を企む　ガーリック軍団だ！
        やつらに　ドラゴンボールを渡してはならない！
        Ｚ戦士は　３方に　別れて旅立った！
        北へ　向かった　Ｚ戦士は・・・"
      end
    when 4 #バブルス修行
      if @msg_output_end == false
      text =
        "界王様の下で　悟空の修行が　始まった！
        まずは　ペットの　バブルス君を捕まえること！
        でも　この界王星は　すごい　重力！　体が　鉛のように　重い！
        悟空よ！　がんばれ！"
      end
    when 5 #ニッキーエリア
      if @msg_output_end == false
      text =
        "Ｚ戦士は　ドラゴンボールを　求めて　東に向かった！
        ドラゴンボールは　絶対ガーリック軍団に　渡せない！"
      end
    when 6 #グレゴリー修行
      if @msg_output_end == false
      text =
        "界王様の修行　第２弾は　界王様の執事をしている
        グレゴリーを　重いハンマーで　叩くこと…
        グレゴリーのスピードは　物凄い！
        悟空！　ファイトだ！！"
      end
    when 7 #ジンジャーエリア
      if @msg_output_end == false
      text =
        "Ｚ戦士は　ドラゴンボールを　求めて　西に向かった！
        地球を　守るため　がんばれ　Ｚ戦士！"
      end
    when 8 #ガーリックエリア
      if @msg_output_end == false
      text =
        "ついに　Ｚ戦士達は　最後の　ドラゴンボールがある
        ガーリック城に　辿り着いた！
        ここは　奴らの　本拠地だ！！
        ガーリックも　必死で　立ち向かってくるはずだ！"
      end
    when 9 #ガーリックエリア(３人衆撃破後)
      if @msg_output_end == false
      text =
        "ジンジャー・ニッキー・サンショの
        ガーリック３人衆を　倒したＺ戦士！
        残るは　ガーリック！！！
        
        最後の　ドラゴンボールを巡って
        壮絶な死闘が　始まろうとしている！"
      end
    when 10 #界王様修行
      if @msg_output_end == false
      text =
        "いよいよ　界王様から　直接　修行を　させてもらえることになった
        厳しい　修行だが　悟空には　地球の　運命が　掛かっている！
        サイヤ人達は　目の前に　迫っている！"
      end
    when 11 #ベジータエリア
      if @msg_output_end == false
      text =
        "とうとう　サイヤ人達が　やってきた！
        Ｚ戦士は　奴らの　侵略を　食い止める事ができるのか！？
        
        
        あの世での　修行を終えた　悟空は　間に合うのか！？"
      end
    when 12 #ベジータエリア(サイバイマン撃破後)
      if @msg_output_end == false
      text =
        "ラディッツの言っていた　もっと強いサイヤ人！
        彼らの　実力は！？　そして　パワーは！？
        Ｚ戦士は　そのパワーに　対抗できるのだろうか！？
        決戦の時は　近い！！！"
      end
    when 13 #ベジータエリア(ナッパ撃破後)
      if @msg_output_end == false
      text =
        "恐るべきパワーを誇った　ナッパを　倒した　Ｚ戦士！
        彼らの　戦いは　クライマックスを　迎えようとしている！
        最後の力を　振り絞れ！　Ｚ戦士！"
      end
      
    when 16 #この世で一番強いやつ(氷原エリア)
      if @msg_output_end == false
      text =
        "天才科学者と　謳われた　Dr.ウィローの助手である
        Dr.コーチンは　ドラゴンボールを集め　永久氷壁の中から
        Dr.ウィローを　50年ぶりに　この世に蘇らせた！

        頭脳のみの　存在である　Dr.ウィローは
        地上で　最も強い人間の　肉体を求めていた！
        彼は　武術の神様と　謳われた　亀仙人こと　武天老師に　目を付け
        ブルマと共に　さらっていったのだった！
        ウーロンの　頼みを受けて　危機に　駆けつけた
        Ｚ戦士たちは　氷に包まれた　ツルマイツブリ山にある
        Dr.ウィローの　要塞へと　向かうのだった！"
      end
    when 17 #この世で一番強いやつ(要塞エリア)
      if @msg_output_end == false
      text =
        "ようやく　Dr.ウィローの　要塞にたどり着いた　Ｚ戦士たち！
        さらわれた　亀仙人と　ブルマは　無事なのだろうか！？
        
        急げ　Ｚ戦士！！"
      end
    when 18 #この世で一番強いやつ(バイオ戦士撃破後エリア)
      if @msg_output_end == false
      text =
        "さらわれていた　亀仙人と　ブルマを　救出し
        Dr.コーチンが　造った　バイオ戦士たちを　倒した　Ｚ戦士！
      　
        何としても　Dr.ウィローの　野望を　くい止めろ！！"
      end  
    when 101 #ラディッツエリア　バーダック編
      if @msg_output_end == false
      text =
        "地球に　最大の危機が訪れた！
        バーダックの息子　ラディッツは
        地球を侵略しに　やって来たのだ！

        ラディッツは　バーダックの孫の悟飯を
        人質に取り　バーダックを仲間にしようとする！！
        バーダック一人では　とても　勝ち目がない！！
        
        そこに　意外な人物が現れた！　悟空の宿命のライバル　ピッコロだ！
        ピッコロにとっても　この恐るべきサイヤ人は彼の野望のジャマになる！
        ついに　異色のコンビが　誕生した！！
        早く　ドラゴンレーダーで　悟飯を探せ！！！"
      end
    end
    
    
    #メッセージ表示
    if @msg_output_end == false
      text.each_line {|line| #改行を読み取り複数行表示する
        line.sub!("￥n", "") # ￥は半角に直す
        line = line.gsub("\r", "")#改行コード？が文字化けするので削除
        line = line.gsub("\n", "")#
        line = line.gsub(" ", "")#半角スペースも削除
        text_list[x]=line
        x += 1
        }
        put_message text_list
        @msg_output_end = true
    end
  end
  #--------------------------------------------------------------------------
  # ● あらすじ画像表示
  # 引数：[story_no:あらすじno]
  #--------------------------------------------------------------------------   
  def put_story_scene story_no
    
    @main_window.contents.clear
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    
    case story_no
    
    when 0..20,51..80,101
      
      #画像表示
      picture = Cache.picture("Z1_背景_スクロール_海")
      rect = Rect.new(512-@scene_scroll_count*4, 0, 512, 128) # スクロール背景
      
      if story_no == 101
        picture2 = Cache.picture("Z1_イベント_バーダックとゴハン")
      else
        picture2 = Cache.picture("Z1_イベント_ゴクウとゴハン")
      end
      rect2 = Rect.new(0, 0, 96, 66) # イベント
      @main_window.contents.blt(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      @main_window.contents.blt(@z1_scrollscenex+560-@chare_scroll_count,@z1_scrollsceney+14+@chare_shake_y,picture2,rect2)
      
      #両端を背景色で消す
      @main_window.contents.fill_rect(0,@z1_scrollsceney,@z1_scrollscenex,128,color) #左
      @main_window.contents.fill_rect(@z1_scrollscenex + 512,@z1_scrollsceney,150,128,color) #右
      @main_window.update
      
      @scene_scroll_count += 0.5  #背景スクロール値加算
      
      if @chare_shake_count < 8
        @chare_shake_count += 1     #キャラスクロール値加算
      else
        @chare_shake_count = 1
      end
      
      #背景スクロール128以上スクロールしたら画像が切れるので元に戻す
      if @scene_scroll_count == 128
        @scene_scroll_count = 0
      end
      
      #悟空上下シェイク
      #@main_window.contents.draw_text(0,0, 200, 40, @chare_shake_count)
      #@main_window.contents.draw_text(0,40, 200, 40, @chare_shake_y)
      
      case @chare_shake_count
      
      when 1..4
        @chare_shake_y = +2
      when 5..8
        @chare_shake_y = 0
      end
      
      #悟空移動、真ん中あたりで止め、メッセージが全て完了したら左端までいく
      if @z1_scrollscenex+216 <= @z1_scrollscenex+560-@chare_scroll_count
        @chare_scroll_count += 4
      elsif $game_message.busy == false
        @chare_scroll_count += 6
      end

    end

  end
  #--------------------------------------------------------------------------
  # ● あらすじ曲再生
  #--------------------------------------------------------------------------  
  def set_bgm
    case $game_variables[43] #あらすじNo
    
    when 0..20,51..80,101
      
      if @end_prelude_flag == false
        @bgm_name = "Z1 あらすじ"
      else
        
      end
    
    when 21..50
      @bgm_name = "Z2 あらすじ"
    when 1
      Audio.bgm_play("Audio/BGM/" +"Z1 戦闘前")
    when 2
      Audio.bgm_play("Audio/BGM/" +"Z1 戦闘1")
    when 3
      Audio.bgm_play("Audio/BGM/" +"Z1 戦闘2")
    when 4
      Audio.bgm_play("Audio/BGM/" +"Z1 戦闘ボス1(中ボス)")
    when 5
      Audio.bgm_play("Audio/BGM/" +"Z1 戦闘ボス2(ベジータ)")
    when 6
      Audio.bgm_play("Audio/BGM/" +"Z2 戦闘1(前奏)")
    when 7
      Audio.bgm_play("Audio/BGM/" +"Z2 戦闘2")
    when 8
      Audio.bgm_play("Audio/BGM/" +"Z3 戦闘1")
    when 9
      Audio.bgm_play("Audio/BGM/" +"Z3 戦闘2(ボス)")
    when 10
      Audio.bgm_play("Audio/BGM/" +"Z3 戦闘3(簡易)")
    when 11
      Audio.bgm_play("Audio/BGM/" +"Z2 戦闘2")
    end
    
    Audio.bgm_play("Audio/BGM/" + @bgm_name)
  end

  #--------------------------------------------------------------------------
  # ● 文章の表示
  #引数：[text:表示内容,position:ウインドウ表示位置]
  #--------------------------------------------------------------------------
  def put_message text,position = 1
    unless $game_message.busy
      #$game_message.face_name = ""
      #$game_message.face_index = 0
      #$game_message.background = 0         #背景 0:通常 1:背景暗く 2:透明
      $game_message.position = position
      for x in 0..text.size - 1 
        $game_message.texts.push(text[x])
      end
      set_message_waiting                   # メッセージ待機状態にする
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● メッセージ待機中フラグおよびコールバックの設定
  #--------------------------------------------------------------------------
  def set_message_waiting
    @message_waiting = true
    $game_message.main_proc = Proc.new { @message_waiting = false }
  end
end