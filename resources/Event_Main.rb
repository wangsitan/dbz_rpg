#==============================================================================
# ■ Event_Main
#------------------------------------------------------------------------------
# 　イベント時画像処理
#==============================================================================
class Event_Main < Scene_Map #< Field_Main
  include Share
  include Icon
  include Z_ed
  include Z_db3ed
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------  
  def initialize
    @def_main_window_strx = -32
    ##@main_window = Window_Base.new(@def_main_window_strx,-32,704,528)
    ##@main_window.opacity=0
    ##@main_window.back_opacity=0
    @z1_scenex = 224           #上背景位置X
    @z1_sceney = 46            #上背景位置Y
    @z1_scrollscenex = 64      #スクロール用上背景位置X
    @z1_scrollsceney = 46      #スクロール用上背景位置Y
    @ene1_x = @z1_scenex + 64 #上キャラ表示基準位置X
    @ene1_y = @z1_sceney + 32 #上キャラ表示基準位置Y
    @play_x = @z1_scenex + 64 #下キャラ(味方)表示基準位置X
    @play_y = @z1_scenex + 82 #下キャラ(味方)表示基準位置Y
    @msg_output_end = false
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    
    @chr_sprite = []
    @shake_count = 0
    #$game_switches[21] = true
  end
  #--------------------------------------------------------------------------
  # ● 画面系コマンドの対象取得
  #--------------------------------------------------------------------------
  def screen
    if $game_temp.in_battle
      return $game_troop.screen
    else
      return $game_map.screen
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    for i in 0...@chr_sprite.size
      #@chr_sprite[i].update
    end
  end
  #--------------------------------------------------------------------------
  # ● イベントキャラの追加処理
  #--------------------------------------------------------------------------
  def add_chr(x, y,bitmap_name,bitmap_rect)
    i = @chr_sprite.index(nil)
    i = @chr_sprite.size if i == nil
    @chr_sprite[i] = Event_Sprite.new(x, y,bitmap_name,bitmap_rect,i)
  end
  #--------------------------------------------------------------------------
  # ● イベントキャラの削除
  #--------------------------------------------------------------------------
  def clear_chr
    for i in 0...@chr_sprite.size
      
      @chr_sprite[i].dispose if @chr_sprite[i] != nil
      @chr_sprite[i] = nil
    end
    @chr_sprite = []
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------   
  def dispose_main_window
    if @main_window != nil
      #@main_window.dispose
      #@main_window = nil
    end
    $game_switches[21] = false
    screen.start_tone_change(1, 1,2)
    clear_chr
  end 

  #--------------------------------------------------------------------------
  # ● 画面揺らす
  #-------------------------------------------------------------------------- 
  def window_shake_on
    for i in 0...@chr_sprite.size
      @chr_sprite[i].update if @chr_sprite[i] != nil
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 画面揺らす 終了
  #-------------------------------------------------------------------------- 
  def window_shake_off
    $game_switches[21] = false
    #@main_window.x = @def_main_window_strx
  end
  
  def window_flash_on
    $background_bitmap = Graphics.snap_to_bitmap
  end
  #--------------------------------------------------------------------------
  # ● 味方側顔表示(パーティーにいる全員を中心から均等に表示する)
  # dying_flag ピンチ顔表示, adjust_x 表示位置調整 , adjust_y 表示位置調整
  #-------------------------------------------------------------------------- 
  def character_output(dying_flag = 0,adjust_x=0,adjust_y=0)
    #picture = $top_file_name + "顔味方"
    for x in 0..$partyc.size - 1
      #rect = Rect.new(0, 64*($partyc[x]-3), 64, 64) # 味方顔
      rect,pic = set_character_face dying_flag,$partyc[x]-3,1
      #add_chr(@play_x-32*($partyc.size - 1)+64*x,@play_y,$top_file_name + "顔味方",rect)
      add_chr(@play_x-32*($partyc.size - 1)+64*x+adjust_x,@play_y+adjust_y,pic,rect)
    end    
  end

  #--------------------------------------------------------------------------
  # ● 味方側顔表示(パーティーにいる全員を中心から均等に表示する) 10人以上いる場合用
  # dying_flag ピンチ顔表示, adjust_x 表示位置調整 , adjust_y 表示位置調整, mode=キャラのチェック対象を変更
  #-------------------------------------------------------------------------- 
  def character_output_all(dying_flag = 0,adjust_x=0,adjust_y=0,mode=0)
      putpartyc=[]
      putpartyc.push($partyc)
      putpartyc.flatten!
      tempchano = 0
      puttarget_cha = [] #出力対象キャラ
      colmax = 8 #横出力最大 (実数マイナス1)
      
      case mode
      when 1 #ビッグゲテスター編
        puttarget_cha = [3,14,4,5,18,6,7,8,9,10,24,12,19,17,20,15]
      when 2 #ビッグゲテスター編終了後地球に戻った後
        puttarget_cha = [3,14,4,5,18,6,7,8,9,10,24,12,19,17,20]
      when 3 #ドラゴンボール復活して悟空が家に帰る
        puttarget_cha = [4,6,7,8,9,12,19,17,20]
      when 4 #ドラゴンボール復活して悟空が家に帰る、ベジータトランクスも
        puttarget_cha = [4,6,7,8,9]
      when 5 #人造人間13号編 悟空合流前
        puttarget_cha = [4,5,18,6,7,8,9,10,24,12,19,17,20,23]
      when 6 #人造人間13号編 悟空合流後
        puttarget_cha = [3,14,4,5,18,6,7,8,9,10,24,12,19,17,20,23]
      when 7 #セルゲーム編 ベジータ合流前
        puttarget_cha = [3,14,4,5,18,17,20,6,7,8,9,10,24]
      when 8 #セルゲーム編 16号合流前
        puttarget_cha = [3,14,4,5,18,12,19,17,20,6,7,8,9,10,24]
      when 9 #セルゲーム編 16号合流後
        puttarget_cha = [3,14,4,5,18,6,7,8,9,12,19,17,20,10,24,23]
      when 10 #セルゲーム編 悟空がセルと闘っている
        puttarget_cha = [4,5,18,12,19,17,20,6,7,8,9,10,24,23]
      when 11 #セルゲーム編 悟飯がセルと闘っている
        puttarget_cha = [3,14,4,12,19,17,20,6,7,8,9,10,24,23]
      when 12 #セルゲーム編 16号が破壊される
        puttarget_cha = [3,14,4,12,19,17,20,6,7,8,9,10,24]
      when 13 #セルゲーム編 悟空も抜ける
        puttarget_cha = [4,12,19,17,20,6,7,8,9,10,24]
      when 14 #セルゲーム編 悟飯が戻る
        puttarget_cha = [5,18,4,12,19,17,20,6,7,8,9,10,24]
      when 15 #セルゲーム編 18号が仲間にいる
        puttarget_cha = [5,18,4,12,19,17,20,6,7,8,9,10,24,21]
      when 16 #セルゲーム編 18号が仲間にいて悟飯がいない
        puttarget_cha = [4,12,19,17,20,6,7,8,9,10,24,21]
      when 17 #セルゲーム編 セル撃破後、ピッコロとベジータのみ表示
        puttarget_cha = [4,12,19]
      when 21 #ブロリー編 全員集合
        puttarget_cha = [3,14,4,5,18,12,19,17,20,6,7,8,9,10,24]
      when 22 #ボージャック編 全員集合
        puttarget_cha = [4,5,18,12,19,17,20,6,7,8,9,10,24]
      when 26 #外伝編 全員集合
        puttarget_cha = [3,14,4,5,18,12,19,17,20,25,26,6,7,8,9,16,32,27,28,29,30,10,24,15,21,22,23]
      when 27 #外伝編 元の時代に帰る(バーダック一味)
        puttarget_cha = [3,14,4,5,18,12,19,25,26,6,7,8,9,10,24,15,21,22,23]
      when 28 #外伝編 元の時代に帰る(未来悟飯)
        puttarget_cha = [12,19,6,7,8,9,16,32,24,15,21,22,23]
      when 29 #外伝編 元の時代に帰る(バーダック)
        puttarget_cha = [4,5,18,12,19,6,7,8,9,24,15,21,22,23]
      when 30 #パイクーハン、ブウなど番外編 全員集合
        puttarget_cha = [3,14,4,5,18,12,19,17,20,25,26,6,7,8,9,16,32,27,28,29,30,10,24,15,21,22,23]
      end
      
      #表示したくないキャラを消す
      for x in 0..putpartyc.size - 1
       # p "ループ回数:" + x.to_s,"配列中身:" + putpartyc.to_s,"判定結果:" + puttarget_cha.include?(putpartyc[x]).to_s,"判定文字:" + putpartyc[x].to_s
        if puttarget_cha.include?(putpartyc[x]) == false && putpartyc[x] != nil
          #出力対象に表示しないキャラを削除
          putpartyc.delete(putpartyc[x])
          
          redo
        end
      end
      #悟空
      if putpartyc.include?(3) == false && putpartyc.include?(14) == false &&
        puttarget_cha.include?(3) == true && puttarget_cha.include?(14) == true
        if $super_saiyazin_flag[1] == true
          putpartyc.push(14)
        else
          putpartyc.push(3)
        end
      end
      
      #ピッコロ
      tempchano = 4
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end

      #悟飯
      if putpartyc.include?(5) == false && putpartyc.include?(18) == false &&
        puttarget_cha.include?(5) == true && puttarget_cha.include?(18) == true
        if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
          putpartyc.push(18)
        else
          putpartyc.push(5)
        end
      end

      #クリリン
      tempchano = 6
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end

      #ヤムチャ
      tempchano = 7
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end

      #天津飯
      tempchano = 8
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end

      #チャオズ
      tempchano = 9
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end

      #チチ
      tempchano = 10
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end
      
      #亀仙人
      tempchano = 24
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end
      
      #ベジータ
      if putpartyc.include?(12) == false && putpartyc.include?(19) == false &&
        puttarget_cha.include?(12) == true && puttarget_cha.include?(19) == true
        if $super_saiyazin_flag[3] == true
          putpartyc.push(19)
        else
          putpartyc.push(12)
        end
      end

      #トランクス
      if putpartyc.include?(17) == false && putpartyc.include?(20) == false &&
        puttarget_cha.include?(17) == true && puttarget_cha.include?(20) == true
        if $super_saiyazin_flag[4] == true
          putpartyc.push(20)
        else
          putpartyc.push(17)
        end
      end

      #未来悟飯
      if putpartyc.include?(25) == false && putpartyc.include?(26) == false &&
        puttarget_cha.include?(26) == true && puttarget_cha.include?(26) == true
        if $super_saiyazin_flag[6] == true
          putpartyc.push(26)
        else
          putpartyc.push(25)
        end
      end
      
      #バーダック
      if putpartyc.include?(16) == false && putpartyc.include?(32) == false &&
        puttarget_cha.include?(16) == true && puttarget_cha.include?(32) == true
        if $super_saiyazin_flag[7] == true
          putpartyc.push(32)
        else
          putpartyc.push(16)
        end
      end
 
      #トーマ
      tempchano = 27
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end
 
      #セリパ
      tempchano = 28
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end
 
      #トテッポ
      tempchano = 29
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end
 
      #パンブーキン
      tempchano = 30
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end
      
      #若者
      tempchano = 15
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end
      
      #16号
      tempchano = 23
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end

      #17号
      tempchano = 22
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end
      
      #18号
      tempchano = 21
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end

      #サタン
      tempchano = 31
      if putpartyc.include?(tempchano) == false && puttarget_cha.include?(tempchano) == true
        putpartyc.push(tempchano)
      end
      
      #adjust_x = 0
      #adjust_y = 0
      
      if putpartyc.size <= 9
        for x in 0..putpartyc.size - 1
          rect,pic = set_character_face dying_flag,putpartyc[x]-3,1
          add_chr(@play_x-32*(putpartyc.size - 1)+64*x+adjust_x,@play_y+adjust_y,pic,rect)
        end
      elsif putpartyc.size >= 19
        #19人以上
         adjust_y -= 24

        for x in 0..putpartyc.size - 1
          
          rect,pic = set_character_face dying_flag,putpartyc[x]-3,1
          
          if x <= 17
            add_chr(@play_x-32*(colmax)+64*x+adjust_x,@play_y+adjust_y,pic,rect)
          else
            #p tyousei_x * 32+64*(x-18)+adjust_x,@play_y+adjust_y
            #add_chr(@play_x-32*(colmax)+64*(x-18)+adjust_x,@play_y+adjust_y,pic,rect)
            #add_chr(@play_x-tyousei_x * 32+64*(x-18)+adjust_x,@play_y+adjust_y,pic,rect)
            add_chr(@play_x-32*(putpartyc.size - 1 - 18)+64*(x - 18)+adjust_x,@play_y+adjust_y,pic,rect)
            #p @play_x-32*(putpartyc.size - 1 - 18)+64*x+adjust_x
            #add_chr(@play_x-32*(putpartyc.size - 1 - 18)+64*x+adjust_x,@play_y+adjust_y,pic,rect)
          end
          
          adjust_y += 64 if (x + 1) % 9 == 0 && x != 0
          adjust_x -= 64*9 if (x + 1) % 9 == 0 && x != 0 && (x + 1) != 18
          adjust_x += 64*9 if (x + 1) == 18

          #p x,x % 9,adjust_y
        end
        
      else #10人以上
        colmax += 1 if putpartyc.size == 10 && adjust_y > 0
          
        for x in 0..colmax
          rect,pic = set_character_face dying_flag,putpartyc[x]-3,1
          add_chr(@play_x-32*(colmax)+64*x+adjust_x,@play_y+adjust_y,pic,rect)
        end
        putpartyc.slice!(0..colmax)
        adjust_y += 64
        for x in 0..putpartyc.size - 1
          rect,pic = set_character_face dying_flag,putpartyc[x]-3,1
          add_chr(@play_x-32*(putpartyc.size - 1)+64*x+adjust_x,@play_y+adjust_y,pic,rect)
        end
      end
  
  end
  #--------------------------------------------------------------------------
  # ● Z1オープニングイベント
  #-------------------------------------------------------------------------- 
  def z1opening n
    
    #screen.start_tone_change(@params[0], @params[1])
    #@wait_count = @params[1] if @params[2]
    clear_chr
    #color = Color.new(128, 0, 255,255)
    #screen.start_tone_change(color,1)
    screen.start_tone_change(1, 1,1)
    case n
    
    when 1
      #$game_variables[71] = $cha_skill_level_mode_bada[31]
      #$game_variables[73] = $cha_skill_level_mode_bada[33]
      #$game_variables[74] = $cha_skill_level_mode_bada[34]
      #$game_variables[75] = $cha_skill_level_mode_bada[35]
      #$game_variables[76] = $cha_skill_level_mode_bada[36]
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント2")# BGMを再生する
      picture = "Z1_背景_スクロール_山"
      rect = Rect.new(0, 0, 512, 128) # スクロール背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
    when 2
      Audio.se_play("Audio/SE/" + "Z1 宇宙船落下")# 効果音を再生する
      for x in 0..35
        #color = set_skn_color 0
        ##@main_window.contents.fill_rect(0,0,656,512,color)

        picture = "Z1_背景_スクロール_山"
        rect = Rect.new(0, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        
        #if x > 10 
        picture = "Z1_イベント_宇宙船"
        rect = Rect.new(0, 0, 48, 36) # イベント
        add_chr(@z1_scrollscenex+320-(x*6),x*4,picture,rect)
        picture = "z1_bg"
        rect = Rect.new(0, 0, 400, 46) # イベント
        add_chr(120,0,picture,rect)
        @chr_sprite[@chr_sprite.size-1].src_rect = rect
        color = set_skn_color 0
        @chr_sprite[@chr_sprite.size-1].bitmap.fill_rect(0,0,640,480,color)
        
        Graphics.update
        clear_chr
      end
      #@main_window.contents.clear
    when 3
      Audio.se_play("Audio/SE/" + "Z1 高速移動")# 効果音を再生する
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      
    when 4
      suka = 0
      for x in 0..11
        Audio.se_play("Audio/SE/" + "Z1 スカウター音")# 効果音を再生する
        
        if suka == 0
          picture = "Z1_背景_山_スカウター1"
          suka = 1
        else
          picture = "Z1_背景_山_スカウター2"
          suka = 0
        end
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        #@main_window.update
        Graphics.update
        Graphics.wait(5)
       if x != 11
          clear_chr
        end
      end
    when 5
      Audio.se_play("Audio/SE/" + "Z1 飛ぶ")# 効果音を再生する
      for x in 0..100
        picture = "Z1_背景_スクロール_山"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 = "Z1_イベント_ラディッツ"
        rect2 = Rect.new(0, 0, 64, 56) # イベント
        add_chr(@z1_scrollscenex+224,@z1_scrollsceney+20,picture2,rect2)
        #@main_window.update
        Graphics.update
       if x != 100
          clear_chr
        end
      end      
    
    when 6
      Audio.se_play("Audio/SE/" + "Z1 吹っ飛ぶ")# 効果音を再生する
      picture = "Z1_背景_平野"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # 味方顔
      add_chr(@play_x,@play_y,picture,rect)

    when 7
      Audio.se_play("Audio/SE/" + "Z1 飛ぶ")# 効果音を再生する
      picture = "Z1_背景_平野"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # 味方顔
      add_chr(@play_x,@play_y,picture,rect)
 
    when 8
      suka = 0
      for x in 0..11
        Audio.se_play("Audio/SE/" + "Z1 スカウター音")# 効果音を再生する
        
        if suka == 0
          picture = "Z1_背景_平野_スカウター1"
          suka = 1
        else
          picture = "Z1_背景_平野_スカウター2"
          suka = 0
        end
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*1, 64, 64) # 味方顔
        add_chr(@play_x,@play_y,picture,rect) 
        #@main_window.update
        Graphics.update
        Graphics.wait(5)
       if x != 11
          clear_chr
        end
      end
    when 9
      Audio.se_play("Audio/SE/" + "Z1 飛ぶ")# 効果音を再生する
      for x in 0..100
        picture = "Z1_背景_スクロール_山"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_ラディッツ"
        rect2 = Rect.new(0, 0, 64, 56) # イベント
        add_chr(@z1_scrollscenex+224,@z1_scrollsceney+20,picture2,rect2)
        #@main_window.update
        Graphics.update
       if x != 100
          clear_chr
        end
      end   

    when 10
      Graphics.fadeout(30)
      Graphics.fadein(30)

      for x in 0..100
        Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*0, 64, 64) # 味方顔
        add_chr(@play_x-32,@play_y,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*0, 64, 64) # 敵顔
        add_chr(@play_x+32,@play_y,picture,rect)
        picture = "Z1_背景_スクロール_海"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_ゴクウとゴハン"
        rect2 = Rect.new(0, 0, 96, 66) # イベント
        add_chr(@z1_scrollscenex+208,@z1_scrollsceney+14,picture2,rect2)
        #@main_window.update
        Graphics.update
        if x != 100
          clear_chr
        end
      end
      
    when 11
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      
    when 12
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント2")# BGMを再生する
      Audio.se_play("Audio/SE/" + "Z1 ダメージ")# 効果音を再生する
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*1, 64, 64) # 味方顔
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z1_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      
    when 13
      Audio.se_play("Audio/SE/" + "Z1 飛ぶ")# 効果音を再生する

      for x in 0..100
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*0, 64, 64) # 味方顔
        add_chr(@play_x-64,@play_y,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*1, 64, 64) # 味方顔
        add_chr(@play_x+64,@play_y,picture,rect)
        picture = "Z1_背景_スクロール_山"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_ラディッツとゴハン"
        rect2 = Rect.new(0, 0, 64, 56) # イベント
        add_chr(@z1_scrollscenex+224,@z1_scrollsceney+20,picture2,rect2)
        #@main_window.update
        Graphics.update
        if x != 100
          clear_chr
        end
      end
      
    when 14
      Audio.se_play("Audio/SE/" + "Z1 ダメージ")# 効果音を再生する 
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 味方顔
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      
    when 15
      Audio.bgm_play("Audio/BGM/" + "Z1 フィールド1")# BGMを再生する
      for x in 0..100
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*0, 64, 64) # 味方顔
        add_chr(@play_x-32,@play_y,picture,rect)
        rect = Rect.new(0, 64*1, 64, 64) # 味方顔
        add_chr(@play_x+32,@play_y,picture,rect)
        picture = "Z1_背景_スクロール_空"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_ゴクウとピッコロ"
        rect2 = Rect.new(0, 0, 128, 80) # イベント
        add_chr(@z1_scrollscenex+192,@z1_scrollsceney+10,picture2,rect2)
        #@main_window.update
        Graphics.update
        if x != 100
          clear_chr
        end
      end
    end

    ##@main_window.update
    #Graphics.update

  end


  #--------------------------------------------------------------------------
  # ● Z1イベント
  #引数:event_no(実行イベントNO)
  #--------------------------------------------------------------------------   
  def z1field event_no
    clear_chr
    color = set_skn_color 0
    #screen.start_tone_change(color,1)
    screen.start_tone_change(1,1,1)
    #color = set_skn_color 0
    ##@main_window.contents.fill_rect(0,0,688,528,color)    
    case event_no
    
    when 90001,90011,90021,90031,90041,90051 #闘技場
      picture = "顔カード"
      rect = Rect.new(64*$game_variables[40], 64*69, 64, 64) # リングアナ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 90002 #闘技場
      picture = "顔カード"
      rect = Rect.new(64*$game_variables[40], 64*69, 64, 64) # リングアナ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      Graphics.fadeout(5)
      $scene = Scene_Db_Battle_arena.new
    when 90012,90022,90032 #闘技場1回戦
      
      if $game_variables[282] != $game_variables[343] #アラレ以外
        picture = "顔カード"
        rect = Rect.new(64*$game_variables[40], 64*69, 64, 64) # リングアナ
      else
        picture = "Z3_顔敵"
        rect = Rect.new(0, 64*53, 64, 64) # アラレ
      end
      add_chr(@ene1_x,@ene1_y,picture,rect)
      battle_arena_ene_set
      battle_process (event_no)
    when 90013 #覚醒系の敵でポポの注意
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) #ポポ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      
    when 90901
      db3ed #DB3スタッフロール
    when 90911 #アラレと会う
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*53, 64, 64) # アラレ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output_all 0,0,0,30
    when 90912 #アラレ去る
      character_output_all 0,0,0,30
    when 90921 #アラレと会う
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*53, 64, 64) # アラレ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 9052 #時の間 パーティー変更
      Graphics.fadeout(5)
      $scene = Scene_Db_Member_change.new 2
    when 9104 #時の間ラディッツ戦闘処理
      battle_process (event_no)
    when 9113 #時の間ガーリック戦闘処理
      battle_process (event_no)
    when 9114 #時の間ガーリック(変身)、三人衆戦闘処理
      battle_process (event_no)
    when 9123 #時の間界王戦闘処理
      battle_process (event_no)
    when 9133 #時の間ナッパ戦闘処理
      battle_process (event_no)
    when 9134 #時の間ベジータ戦闘処理
      battle_process (event_no)
    when 9143 #時の間バイオ戦士戦闘処理
      battle_process (event_no)
    when 9144 #時の間ウィロー戦闘処理
      battle_process (event_no)
    when 9304 #時の間キュイ戦闘処理
      battle_process (event_no)
    when 9313 #時の間ドドリア戦闘処理
      battle_process (event_no)
    when 9323,9324 #時の間ザーボン戦闘処理
      battle_process (event_no)
    when 9333 #時の間ギニュー戦闘処理
      battle_process (event_no)
    when 9343..9349 #時の間フリーザ～ターレスまで戦闘処理
      battle_process (event_no)
    when 9504 #時の間クラズ戦闘処理
      battle_process (event_no)
    when 9553,9554 #時の間ガーリック戦闘処理
      battle_process (event_no)
    when 9513 #時の間ピラール戦闘処理
      battle_process (event_no)
    when 9523 #時の間カイズ戦闘処理
      battle_process (event_no)
    when 9533..9535 #時の間クウラ機甲戦隊～クウラ(変身)まで戦闘処理
      battle_process (event_no)
    when 9543..9544,9547 #時の間人造人間まで戦闘処理
      battle_process (event_no)
    when 9704,9713,9723,9733,9743,9753..9756,9773 #時の間ウィロー編
      battle_process (event_no)
    when 800 #特典選択

    when 801 #バーダック編OP
      
      $game_progress = 0
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント2")# BGMを再生する
      picture = "Z1_背景_スクロール_山"
      rect = Rect.new(0, 0, 512, 128) # スクロール背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      $game_variables[41] += 1
    when 802
      Audio.se_play("Audio/SE/" + "Z1 宇宙船落下")# 効果音を再生する
      for x in 0..35
        #color = set_skn_color 0
        ##@main_window.contents.fill_rect(0,0,656,512,color)

        picture = "Z1_背景_スクロール_山"
        rect = Rect.new(0, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        
        #if x > 10 
        picture = "Z1_イベント_宇宙船"
        rect = Rect.new(0, 0, 48, 36) # イベント
        add_chr(@z1_scrollscenex+320-(x*6),x*4,picture,rect)
        picture = "z1_bg"
        rect = Rect.new(0, 0, 400, 46) # イベント
        add_chr(120,0,picture,rect)
        @chr_sprite[2].src_rect = rect
        color = set_skn_color 0
        @chr_sprite[2].bitmap.fill_rect(0,0,640,480,color)
        Graphics.update
          clear_chr
      end
      #@main_window.contents.clear
      $game_variables[41] += 1
    when 803
      Audio.se_play("Audio/SE/" + "Z1 高速移動")# 効果音を再生する
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*13, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 804
      $game_variables[41] += 1
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
    when 805
      for x in 0..100
        #Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*0, 64, 64) # 味方顔
        add_chr(@play_x,@play_y,picture,rect)
        #picture = "Z1_顔イベント"
        #rect = Rect.new(0, 64*0, 64, 64) # 敵顔
        #dd_chr(@play_x+32,@play_y,picture,rect)
        picture = "Z1_背景_スクロール_空"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_ゴクウ"
        rect2 = Rect.new(0, 0, 96, 74) # イベント
        add_chr(@z1_scrollscenex+208,@z1_scrollsceney+14,picture2,rect2)
        #@main_window.update
        Graphics.update
        if x != 100
          clear_chr
        end
      end
      $game_variables[41] += 1
    when 806
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 807
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント2")# BGMを再生する
      Audio.se_play("Audio/SE/" + "Z1 ダメージ")# 効果音を再生する
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)

      $game_variables[41] += 1
    when 811
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント2")# BGMを再生する
      #Audio.se_play("Audio/SE/" + "Z1 ダメージ")# 効果音を再生する
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 812
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント2")# BGMを再生する
      #Audio.se_play("Audio/SE/" + "Z1 ダメージ")# 効果音を再生する
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 敵顔
      add_chr(@play_x+32,@play_y,picture,rect)
      $game_variables[41] += 1
    when 813
      $game_variables[41] += 1
    when 814
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 815
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 敵顔
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*13, 64, 64) # 味方顔
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 味方顔
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@play_x+32,@play_y,picture,rect)
      $game_variables[41] += 1
    when 816
      picture = "Z1_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 敵顔
      add_chr(@play_x+64,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 敵顔
      add_chr(@play_x-64,@play_y+64,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*13, 64, 64) # 味方顔
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 味方顔
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 味方顔
      add_chr(@play_x,@play_y+64,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 817
      Audio.se_play("Audio/SE/" + "Z1 飛ぶ")# 効果音を再生する

      for x in 0..100
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*13, 64, 64) # 味方顔
        add_chr(@play_x-32,@play_y,picture,rect)
        rect = Rect.new(0, 64*3, 64, 64) # 味方顔
        add_chr(@play_x+32,@play_y,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*1, 64, 64) # 敵顔
        add_chr(@play_x+64,@play_y+64,picture,rect)
        rect = Rect.new(0, 64*3, 64, 64) # 敵顔
        add_chr(@play_x-64,@play_y+64,picture,rect)
        picture = "Z1_背景_スクロール_山"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_ラディッツとゴハン"
        rect2 = Rect.new(0, 0, 64, 56) # イベント
        add_chr(@z1_scrollscenex+224,@z1_scrollsceney+20,picture2,rect2)
        #@main_window.update
        Graphics.update
        if x != 100
          clear_chr
        end
      end
      $game_variables[41] += 1
    when 818
      #picture = "Z1_背景_カメハウス"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*13, 64, 64) # 味方顔
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 味方顔
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 敵顔
      add_chr(@play_x+64,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 敵顔
      add_chr(@play_x-64,@play_y+64,picture,rect)
      $game_variables[41] += 1
    when 819
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 敵顔
      add_chr(@play_x+64,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 敵顔
      add_chr(@play_x-64,@play_y+64,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*13, 64, 64) # 味方顔
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 味方顔
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*1, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 820
      Audio.bgm_play("Audio/BGM/" + "Z1 フィールド1")# BGMを再生する
      for x in 0..100
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*13, 64, 64) # 味方顔
        add_chr(@play_x-32,@play_y,picture,rect)
        rect = Rect.new(0, 64*1, 64, 64) # 味方顔
        add_chr(@play_x+32,@play_y,picture,rect)
        picture = "Z1_背景_スクロール_空"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_バーダックとピッコロ"
        rect2 = Rect.new(0, 0, 128, 80) # イベント
        add_chr(@z1_scrollscenex+192,@z1_scrollsceney+10,picture2,rect2)
        #@main_window.update
        Graphics.update
        if x != 100
          clear_chr
        end
      end

      $game_variables[41] += 1
    when 821
      for x in 0..100
        #Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*13, 64, 64) # 味方顔
        add_chr(@play_x-32,@play_y,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*0, 64, 64) # 敵顔
        add_chr(@play_x+32,@play_y,picture,rect)
        picture = "Z1_背景_スクロール_海"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_バーダックとゴハン"
        rect2 = Rect.new(0, 0, 96, 66) # イベント
        add_chr(@z1_scrollscenex+208,@z1_scrollsceney+14,picture2,rect2)
        #@main_window.update
        Graphics.update
        if x != 100
          clear_chr
        end
        $game_variables[41] += 1
      end
    when 822
      picture = "Z1_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 敵顔
      add_chr(@play_x+64,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 敵顔
      add_chr(@play_x-64,@play_y+64,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*13, 64, 64) # 味方顔
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 味方顔
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 831
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 832 #ラディッツ戦闘処理
      battle_process (event_no)
    when 833
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 834
      character_output
      $game_variables[41] += 1
    when 835
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 836
      $chadead.delete_at($partyc.index(4))
      $partyc.delete(4)
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 837
      $game_variables[41] += 1
    when 838
      for x in 0..100
        #Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
        #picture = "Z1_顔味方"
        #rect = Rect.new(0, 64*13, 64, 64) # 味方顔
        #add_chr(@play_x-32,@play_y,picture,rect)
        #picture = "Z1_顔イベント"
        #rect = Rect.new(0, 64*0, 64, 64) # 敵顔
        #add_chr(@play_x+32,@play_y,picture,rect)
        picture = "Z1_背景_スクロール_海"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_バーダックとゴハン"
        rect2 = Rect.new(0, 0, 96, 66) # イベント
        add_chr(@z1_scrollscenex+208,@z1_scrollsceney+14,picture2,rect2)
        #@main_window.update
        Graphics.update
        if x != 100
          clear_chr
        end
        $game_variables[41] += 1
      end

    when 841 #カメハウス
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # 敵顔
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # 味方顔
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 851 #ポポとキュウコンマン
      #Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*2, 64, 64) # キュウコンマン
      for x in 0..5
        add_chr(@ene1_x-160+x*64,@ene1_y,picture,rect)
      end
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # ミスターポポ
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      character_output
    when 852 #サイバイマン戦闘処理
        battle_process (event_no)
    when 853 #ポポ救出後
      #Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する

      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # ミスターポポ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 861 #ポポ救出後
      #Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する

      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # ミスターポポ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 881 #ポポとキュウコンマン
      #Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*2, 64, 64) # キュウコンマン
      for x in 0..5
        add_chr(@ene1_x-160+x*64,@ene1_y,picture,rect)
      end
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*3, 64, 64) # サイバイマン
      for x in 2..3
        add_chr(@ene1_x-160+x*64,@ene1_y,picture,rect)
      end
      character_output
    when 882 #サイバイマン戦闘処理
        battle_process (event_no)
    when 11 #フィールド1宿(休み前)
      
      if $game_variables[43] != 23 && $game_variables[43] != 25 && $game_variables[43] != 27
        character_output
      end
      all_charecter_recovery #全キャラ回復
      if $game_variables[43] <= 7 || $game_variables[43] == 101 || $game_variables[43] == 901 || $game_variables[43] == 903 #ジンジャーエリアまでは蛇の宿
        Audio.bgm_play("Audio/BGM/" + "Z1 宿")# 効果音を再生する
        picture = "Z1_背景_ヘビの宿"
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*2, 64, 64) # 敵顔
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] <= 20 || $game_variables[43] == 902 || $game_variables[43] == 904 || $game_variables[43] == 905 #ベジータ撃墜まではカリンの宿
        picture = "Z1_背景_カリン塔"
        Audio.bgm_play("Audio/BGM/" + "DB3 イベント05")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*8, 64, 64) # カリン様
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] <= 21 #ナメック星到着までは宇宙船休憩
        picture = "Z2_背景_惑星_建物"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "顔カード"
        rect = Rect.new(64*1, 64*8, 64, 64) # ブルマ
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] == 22 && $game_switches[97] == true #ナメック星ではメディカルルーム休憩（ブルマ危険）
        picture = "Z2_背景_メディカルルーム"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "Z2_顔イベント"
        rect = Rect.new(64*0, 64*1, 64, 64) # ナメック星人太い
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] == 23 || $game_variables[43] == 25 || $game_variables[43] == 27 #悟空修行では宇宙船で休憩
        picture = "Z2_背景_宇宙船と悟空"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
      elsif $game_variables[43] == 28 #界王修行
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        picture = "Z2_背景_界王星"
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
      elsif $game_variables[43] <= 40 || $game_variables[43] == 911 || $game_variables[43] == 912 || $game_variables[43] == 913 || $game_variables[43] == 914 || $game_variables[43] == 915 #ナメック星ではメディカルルーム休憩
        picture = "Z2_背景_メディカルルーム"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "顔カード"
        rect = Rect.new(64*1, 64*8, 64, 64) # ブルマ
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] == 41 #Z2 バーダック編
        
      elsif $game_variables[43] == 90 || $game_variables[43] == 934 #Z4 ナメック星
        #激突100億パワーの戦士たち
        Audio.bgm_play("Audio/BGM/" + "ZSSD 家2")# 効果音を再生する
        picture = "Z3_背景_ナメック星"
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture = "顔カード"
        rect = Rect.new(64*2, 64*14, 64, 64) # デンデ
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] == 91 || $game_variables[43] == 935 #Z4 ナメック星　ビッグゲテスター
        picture = "Z3_背景_ビッグゲテスター内部"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        picture = "Z3_顔イベント"
        rect = Rect.new(0*64, 64*71, 64, 64) # 誘導ロボット
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] >= 143 && $game_variables[43] <= 149 #ZGバーダック一味編
        picture = "Z2_背景_メディカルルーム"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "Z2_顔イベント"
        rect = Rect.new(64*0, 64*8, 64, 64) # フリーザ軍医者
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] <= 150 || #Z3,ZG本編
        $game_variables[43] >= 151 && $game_variables[43] <= 200 ||
        $game_variables[43] >= 921 && $game_variables[43] <= 926 ||
        $game_variables[43] >= 931 && $game_variables[43] <= 937
        Audio.bgm_play("Audio/BGM/" + "DB3 イベント05")# 効果音を再生する
        picture = "Z3_背景_修行"
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture = "顔カード"
        rect = Rect.new(64*2, 64*13, 64, 64) # カリン様
        add_chr(@ene1_x,@ene1_y,picture,rect)
      end
      
    when 12 #フィールド1ヘビ宿(休み後)
       
      Audio.se_play("Audio/se/" + "Z1 お休み") if $game_switches[111] == false# 効果音を再生する
      Graphics.fadeout(60)
      Graphics.wait(140)
      if $game_variables[43] != 23 && $game_variables[43] != 25 && $game_variables[43] != 27
        character_output
      end
      if $game_variables[43] <= 7 || $game_variables[43] == 101 || $game_variables[43] == 901 || $game_variables[43] == 903 #ジンジャーエリアまでは蛇の宿
        Audio.bgm_play("Audio/BGM/" + "Z1 宿")# 効果音を再生する
        picture = "Z1_背景_ヘビの宿"
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*2, 64, 64) # 敵顔
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] <= 20 || $game_variables[43] == 902 || $game_variables[43] == 904 || $game_variables[43] == 905 #ベジータ撃墜まではカリンの宿
        picture = "Z1_背景_カリン塔"
        Audio.bgm_play("Audio/BGM/" + "DB3 イベント05")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*8, 64, 64) # カリン様
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] <= 21 #ナメック星到着までは宇宙船休憩
        picture = "Z2_背景_惑星_建物"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "顔カード"
        rect = Rect.new(64*1, 64*8, 64, 64) # ブルマ
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] == 22 && $game_switches[97] == true #ナメック星ではメディカルルーム休憩（ブルマ危険）
        picture = "Z2_背景_メディカルルーム"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "Z2_顔イベント"
        rect = Rect.new(64*0, 64*1, 64, 64) # ナメック星人太い
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] == 23 || $game_variables[43] == 25 || $game_variables[43] == 27 #悟空修行では宇宙船で休憩
        picture = "Z2_背景_宇宙船と悟空"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
      elsif $game_variables[43] == 28 #界王修行
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        picture = "Z2_背景_界王星"
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
      elsif $game_variables[43] <= 40 || $game_variables[43] == 911 || $game_variables[43] == 912 || $game_variables[43] == 913 || $game_variables[43] == 914 || $game_variables[43] == 915 #ナメック星ではメディカルルーム休憩
        picture = "Z2_背景_メディカルルーム"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "顔カード"
        rect = Rect.new(64*1, 64*8, 64, 64) # ブルマ
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] == 41 #Z2 バーダック編
        
      elsif $game_variables[43] == 90 || $game_variables[43] == 934 #Z4 ナメック星
        #激突100億パワーの戦士たち
        Audio.bgm_play("Audio/BGM/" + "ZSSD 家2")# 効果音を再生する
        picture = "Z3_背景_ナメック星"
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture = "顔カード"
        rect = Rect.new(64*2, 64*14, 64, 64) # デンデ
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] == 91 || $game_variables[43] == 935  #Z4 ナメック星　ビッグゲテスター
        picture = "Z3_背景_ビッグゲテスター内部"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        picture = "Z3_顔イベント"
        rect = Rect.new(0*64, 64*71, 64, 64) # 誘導ロボット
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] >= 143 && $game_variables[43] <= 149 #ZGバーダック一味編
        picture = "Z2_背景_メディカルルーム"
        Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "Z2_顔イベント"
        rect = Rect.new(64*0, 64*8, 64, 64) # フリーザ軍医者
        add_chr(@ene1_x,@ene1_y,picture,rect)
      elsif $game_variables[43] <= 150 || #Z3,ZG本編
        $game_variables[43] >= 151 && $game_variables[43] <= 200 ||
        $game_variables[43] >= 921 && $game_variables[43] <= 925 ||
        $game_variables[43] >= 931 && $game_variables[43] <= 937  
        Audio.bgm_play("Audio/BGM/" + "DB3 イベント05")# 効果音を再生する
        picture = "Z3_背景_修行"
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture = "顔カード"
        rect = Rect.new(64*2, 64*13, 64, 64) # カリン様
        add_chr(@ene1_x,@ene1_y,picture,rect)
      end
      Graphics.fadein(60)
    when 21 #カードショップ
      Audio.bgm_play("Audio/BGM/" + $BGM_Card_shop)    # 効果音を再生する
    when 22 #カードスピードくじ
      $scene = Scene_Db_Card_lot.new
    when 23 #カード神経衰弱
      $scene = Scene_Db_Card_Concentration.new
    when 31 #修行　スピード敏捷
      $scene = Scene_Db_Speed_Training.new
    when 32 #修行　重力
      $scene = Scene_Db_Gravity_Training.new
    when 33 #修行　界王ダジャレ
      $scene = Scene_Db_Dajare_Training.new
    when 34 #修行　ポポ
      $scene = Scene_Db_Popo_Training.new
    when 35 #修行　チチ
      $scene = Scene_Db_Chi_Chi_Training.new
    when 36 #修行　バブルス
      $scene = Scene_Db_Bubbles_Training.new
    when 37 #修行　グレゴリー
      $scene = Scene_Db_Gregory_Training.new
    when 41 #戦いの記録
      #Audio.bgm_play("Audio/BGM/" + "DB2 イベント04")# 効果音を再生する
      picture = "顔カード"
      rect = Rect.new(64*$game_variables[40], 64*18, 64, 64) # 占いババ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
    when 42 #戦いの記録 詳細
      Graphics.fadeout(10)
      $scene = Scene_Db_battle_history.new
    when 43 #敵の情報
      Graphics.fadeout(10)
      $scene = Scene_Db_enemy_history.new
    when 45 #カード合成
      #Audio.bgm_play("Audio/BGM/" + "DB2 イベント04")# 効果音を再生する
      picture = "ZD_カリン様"
      rect = Rect.new(96*0, 80*0, 96, 80) # カリン様
      add_chr(@ene1_x-16,@ene1_y-8,picture,rect)
      rect = put_icon 1
      add_chr(@play_x-128*1,@play_y+64,"顔カード",rect)
      add_chr(@play_x+128*1,@play_y+64,"顔カード",rect)
      add_chr(@play_x+128*0,@play_y+64,"顔カード",rect)
      add_chr(@play_x+128*0,@play_y+64,"顔カード",rect)
      @chr_sprite[1].visible = false
      @chr_sprite[2].visible = false
      @chr_sprite[3].visible = false
      @chr_sprite[4].visible = false


    when 51 #フィールド1カメハウス
      Audio.bgm_play("Audio/BGM/" + "DB3 カメハウス")# 効果音を再生する
      character_output
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      
    when 52 #ブルマ
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      character_output
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*3, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect) 
    when 53 #ウミガメ
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      character_output
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 54 #パンプキン
      Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する
      character_output
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*5, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 55 #パンプキン戦闘処理
      battle_process (event_no)
    when 56 #ブロッコ
      Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する
      character_output
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*6, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 57 #パンプキン戦闘処理
      battle_process (event_no)
    when 58 #ラディッツ
      Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する
      character_output
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 59 #ラディッツ戦闘処理
      battle_process (event_no)
    when 60 #ラディッツ撃墜
      Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する
      #ラディッツ戦で悟空が死んだかチェック
      if $game_switches[865] == true
        #ピッコロ死んでいる
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*0, 64, 64) # 悟空
        add_chr(@play_x+32,@play_y,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*0, 64, 64) # 悟飯
        add_chr(@play_x-32,@play_y,picture,rect)
      elsif $game_switches[864] == true
        #悟空死んでいる
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
        add_chr(@play_x+32,@play_y,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*0, 64, 64) # 悟飯
        add_chr(@play_x-32,@play_y,picture,rect)
      else
        #両方生きている
        picture = "Z1_顔味方"
        rect = Rect.new(0, 64*0, 64, 64) # 悟空
        add_chr(@play_x,@play_y,picture,rect)
        rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
        add_chr(@play_x+64,@play_y,picture,rect)
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*0, 64, 64) # 悟飯
        add_chr(@play_x-64,@play_y,picture,rect)
      end
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # 敵顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 61 #ベジータとナッパ
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント2")# 効果音を再生する
      picture = "Z1_背景_惑星_ベジータとナッパ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*12, 64, 64) # ベジータ
      add_chr(@z1_scenex-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*11, 64, 64) # ナッパ
      add_chr(@z1_scenex+192,@ene1_y,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 62 #ベジータとナッパ宇宙船
      #Audio.bgm_play("Audio/BGM/" + "Z1 イベント2")# 効果音を再生する
        picture = "Z1_背景_宇宙船_ベジータとナッパ"
        rect = Rect.new(0, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 63 #悟空死亡
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント4")# 効果音を再生する
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 悟飯
      add_chr(@play_x-64,@play_y,picture,rect)
      rect = Rect.new(0, 64*14, 64, 64) # 神様
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # 悟空死に顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 64 #あの世
      #Audio.bgm_play("Audio/BGM/" + "Z1 イベント4")# 効果音を再生する
      picture = "Z1_背景_あの世"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 65 #エンマ様
      #Audio.bgm_play("Audio/BGM/" + "Z1 イベント4")# 効果音を再生する
      picture = "Z1_背景_エンマ様"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # 悟空死に顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*14, 64, 64) # 神様
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 66 #蛇の道
      #Audio.bgm_play("Audio/BGM/" + "Z1 イベント4")# 効果音を再生する
      picture = "Z1_背景_蛇の道"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 67 #ガーリック城
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント07")# 効果音を再生する
      picture = "Z1_背景_ガーリック城"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 68 #ガーリック城
      picture = "Z1_背景_ガーリック城_ガーリックの間"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*16, 64, 64) # ガーリック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ジンジャー
      add_chr(@play_x-64,@play_y,picture,rect)
      rect = Rect.new(0, 64*14, 64, 64) # ニッキー
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # サンショ
      add_chr(@play_x+64,@play_y,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 69 #カリン塔
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント4")# 効果音を再生する
      $partyc = [4,5,6,7,8,9] #パーティー変更
      all_charecter_recovery #全キャラ回復
      picture = "Z1_背景_カリン塔"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*8, 64, 64) # カリン様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 70 #チーム分け
      $game_variables[41] += 1
      $scene = Scene_Team_Divide.new
    when 71 #カリン塔
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント4")# 効果音を再生する
      $partyc = [4,5,6,7,8,9] #パーティー変更
      all_charecter_recovery #全キャラ回復
      picture = "Z1_背景_カリン塔"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*8, 64, 64) # カリン様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 72 #ゴクウあらすじ
      $partyc = [3]
      $chadead = [false]
      all_charecter_recovery #全キャラ回復
      Graphics.fadein(30)
    when 75 #ラディッツ撃破で悟空が生きてた
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント4")# 効果音を再生する
      picture = "Z1_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x+0,@play_y,picture,rect)
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 悟飯
      add_chr(@play_x-64,@play_y,picture,rect)
      rect = Rect.new(0, 64*14, 64, 64) # 神様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      Graphics.fadein(30)
      #あの世イベントに変えて置く
      $game_variables[41] = 64
    when 76 #村人A
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "顔カード"
      rect = Rect.new(0, 64*89, 64, 64) # 村人A
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 77 #村人B
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "顔カード"
      rect = Rect.new(0, 64*102, 64, 64) # 村人B
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 78 #村人C
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "顔カード"
      rect = Rect.new(0, 64*156, 64, 64) # 村人C
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    #===========================================================================
    #蛇の道
    #===========================================================================
    when 80 #じいちゃん
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*11, 64, 64) # じいちゃん
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 81 #ゴズ
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*6, 64, 64) # ゴズ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 82 #メズ
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*9, 64, 64) # メズ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 83 #界王星
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "Z1_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
    when 84 #界王様
      Audio.bgm_play("Audio/BGM/" + "Z1 界王")# 効果音を再生する
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*18, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 85
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント02")# 効果音を再生する
      $game_variables[41] += 1
      $partyc = [$game_variables[45],$game_variables[46]] #パーティー変更
      $game_variables[42] = $game_variables[45] #戦闘キャラNo変更
      $game_variables[43] += 1 #あらすじNo変更
      $chadead = [false,false]
      character_output
      Graphics.fadein(30)
    when 86 #ピッコロと悟飯
      #Audio.bgm_play("Audio/BGM/" + "DB3 イベント02")# 効果音を再生する
      
      if $partyc[0] == 4 && $partyc[1] == 5 || $partyc[0] == 5 && $partyc[1] == 4
        picture = "Z1_背景_ピッコロと悟飯"
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        character_output
        $game_switches[50] = true
        Graphics.fadein(30)
      end
    #===========================================================================
    #サンショエリア
    #===========================================================================
    when 91 #プーアル
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*5, 64, 64) # プーアル
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 92 #サンショ
      Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # サンショ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 93 #サンショ戦闘処理
      battle_process (event_no)
    when 94 #サンショ撃破後
      Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # サンショ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 95 #二星球表示
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*23, 64, 64) # 二星球
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 96 #界王星そのころ
      Audio.bgm_play("Audio/BGM/" + "Z1 界王")# 効果音を再生する
      Graphics.fadein(30)
      $game_variables[41] += 1
      $partyc = [3]
      $chadead = [false]
    when 97 #界王様
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*18, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 98 #バブルス
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # バブルス
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 99 #界王様
      Audio.bgm_play("Audio/BGM/" + "Z1 界王")# 効果音を再生する
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*18, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      #Graphics.fadein(30)
    when 100 #ニッキーエリア前
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント02")# 効果音を再生する
      $partyc = [$game_variables[47],$game_variables[48]] #パーティー変更
      $game_variables[42] = $game_variables[47] #戦闘キャラNo変更
      $game_variables[43] += 1 #あらすじNo変更
      $chadead = [false,false]
      character_output
      $game_variables[41] = 86
      Graphics.fadein(30)
    #===========================================================================
    #ニッキーエリア
    #===========================================================================
    when 101 #ウーロン
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 102 #ニッキー
      Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*14, 64, 64) # サンショ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 103 #ニッキー戦闘処理
      battle_process (event_no)
    when 104 #ニッキー撃破後
      Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*14, 64, 64) # サンショ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 105 #五星球表示
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # 五星球
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 106 #界王星そのころ
      Audio.bgm_play("Audio/BGM/" + "Z1 界王")# 効果音を再生する
      Graphics.fadein(30)
      $game_variables[41] += 1
      $partyc = [3]
      $chadead = [false]
    when 107 #界王様
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*18, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 108 #グレゴリー
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # グレゴリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 109 #界王様
      Audio.bgm_play("Audio/BGM/" + "Z1 界王")# 効果音を再生する
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*18, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      #Graphics.fadein(30)
    when 110 #ジンジャーエリア前
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント02")# 効果音を再生する
      $partyc = [$game_variables[49],$game_variables[50]] #パーティー変更
      $game_variables[42] = $game_variables[49] #戦闘キャラNo変更
      $game_variables[43] += 1 #あらすじNo変更
      $chadead = [false,false]
      character_output
      $game_variables[41] = 86
      Graphics.fadein(30)
    #===========================================================================
    #ジンジャーエリア
    #===========================================================================
    when 111 #牛魔王
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*30, 64, 64) # 牛魔王
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 112 #ジンジャー
      Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) #ジンジャー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 113 #ジンジャー戦闘処理
      battle_process (event_no)
    when 114 #ジンジャー撃破後
      Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) #ジンジャー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 115 #七星球表示
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*28, 64, 64) # 七星球
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 116 #ガーリック城集結
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント3")# 効果音を再生する
      picture = "Z1_背景_ガーリック城"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
      $partyc = [4,5,6,7,8,9]
      $chadead = [false,false,false,false,false,false]
      all_charecter_recovery #全キャラ回復
      character_output
      
    #===========================================================================
    #ガーリックエリア
    #===========================================================================
    
    when 172 #占いババ
      picture = "顔カード"
      rect = Rect.new(0, 64*18, 64, 64) # 占いババ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 117 #ガーリック３人衆
      Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z1_背景_ガーリック三人衆"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) #ジンジャー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 118 #ガーリック３人衆
      #Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z1_背景_ガーリック三人衆"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*14, 64, 64) #ニッキー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 119 #ガーリック３人衆
      #Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z1_背景_ガーリック三人衆"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) #サンショ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 120 #ガーリック３人衆戦闘処理
      battle_process (event_no)
    when 121 #ガーリック
      Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する
      picture = "Z1_背景_ガーリック城_ガーリックの間"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*16, 64, 64) #ガーリック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 122 #ガーリック３人衆戦闘処理
      battle_process (event_no)
    when 123 #ガーリック撃破後
      Audio.bgm_play("Audio/BGM/" + "DB2 イベント02")# 効果音を再生する
      picture = "Z1_背景_ガーリック城_ガーリックの間"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*16, 64, 64) #ガーリック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 124 #ガーリック撃破後
      #Audio.bgm_play("Audio/BGM/" + "DB2 イベント02")# 効果音を再生する
      picture = "Z1_背景_ガーリック城_ガーリックの間"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*17, 64, 64) #ガーリック(巨大化)
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 125 #ガーリック撃破後
      #Audio.bgm_play("Audio/BGM/" + "DB2 イベント02")# 効果音を再生する
      picture = "Z1_背景_ガーリック城_ガーリックの間"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*17, 64, 64) #ガーリック(巨大化)
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) #ジンジャー
      add_chr(@ene1_x-64,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*14, 64, 64) #ニッキー
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) #サンショ
      add_chr(@ene1_x+64,@ene1_y-64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 126 #ガーリック巨大化戦闘処理
      battle_process (event_no)
    when 127 #一星球表示
      Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*22, 64, 64) # 一星球
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 128 #界王星そのころ
      Audio.bgm_play("Audio/BGM/" + "Z1 界王")# 効果音を再生する
      Graphics.fadein(30)
      $game_variables[41] += 1
      $partyc = [3]
      $chadead = [false]
      all_charecter_recovery #全キャラ回復
    when 129 #界王様
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*18, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 130 #界王様修行
      #@main_window.contents.clear
      $game_variables[51] += 1
      battle_process (event_no)
    when 131 #界王様に負けてマップに戻る
      ##@main_window.contents.clear
      #$game_variables[51] += 1
      #battle_process (event_no)
    when 132 #界王様
      all_charecter_recovery #全キャラ回復
      Audio.bgm_play("Audio/BGM/" + "Z1 界王")# 効果音を再生する
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*18, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 133 #カメハウス
      Audio.bgm_play("Audio/BGM/" + "DB3 カメハウス")# 効果音を再生する
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 亀仙人顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 134 #ドラゴンボール
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*22, 64, 64) # 1
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*23, 64, 64) # 2
      add_chr(@ene1_x-64,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 3
      add_chr(@ene1_x-64,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 4
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 5
      add_chr(@ene1_x+64,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*27, 64, 64) # 6
      add_chr(@ene1_x+64,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*28, 64, 64) # 7
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*1, 64, 64) # 亀仙人顔
      add_chr(@play_x-96,@play_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # ブルマ顔
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン顔
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*5, 64, 64) # プーアル顔
      add_chr(@play_x+96,@play_y,picture,rect)
      $game_variables[41] += 1
    when 135 #シェンロン
      #Audio.bgm_play("Audio/BGM/" + "Z1 神龍")# 効果音を再生する
      picture = "Z1_背景_シェンロン"
      rect = Rect.new(0, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      $game_variables[41] += 1
      #Graphics.fadein(30)
    when 136 #界王様
      Audio.bgm_play("Audio/BGM/" + "Z1 フィールド1")# 効果音を再生する
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*18, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 137 #悟空蛇の道を帰る
      Audio.se_play("Audio/SE/" + "Z1 飛ぶ")# 効果音を再生する
      for x in 0..100
        picture = "Z1_背景_スクロール_蛇の道"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_ゴクウ_蛇の道を飛ぶ"
        rect2 = Rect.new(0, 0, 54, 18) # イベント
        add_chr(@z1_scrollscenex+226,@z1_scrollsceney+40,picture2,rect2)
        #@main_window.update
        Graphics.update
      end
      $game_variables[41] += 1
    when 138 #都
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント2")# BGMを再生する
      picture = "Z1_背景_都(長い)"
      rect = Rect.new(0, 0, 512, 128) # スクロール背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 139 #都(宇宙船落下)

      Audio.se_play("Audio/SE/" + "Z1 宇宙船落下")# 効果音を再生する
      for x in 0..35
        color = set_skn_color 0
        #@main_window.contents.fill_rect(0,0,656,496,color)
        picture = "Z1_背景_都(長い)"
        rect = Rect.new(0, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_都に落ちる宇宙船"
        rect2 = Rect.new(0, 0, 80, 76) # イベント
        add_chr(@z1_scrollscenex+320-(x*6),x*4,picture2,rect2)
        picture = "z1_bg"
        rect = Rect.new(0, 0, 400, 46) # イベント
        add_chr(120,0,picture,rect)
        @chr_sprite[@chr_sprite.size-1].src_rect = rect
        color = set_skn_color 0
        @chr_sprite[@chr_sprite.size-1].bitmap.fill_rect(0,0,640,480,color)
        Graphics.update
        clear_chr
      end
      #@main_window.contents.clear
      $game_variables[41] += 1
    when 140 #ベジータとナッパ
      picture = "Z1_背景_都"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*12, 64, 64) # ベジータ
      add_chr(@z1_scenex-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*11, 64, 64) # ナッパ
      add_chr(@z1_scenex+192,@ene1_y,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 141 #ベジータとナッパ
      Audio.se_play("Audio/SE/" + "Z1 都爆発")# 効果音を再生する
      picture = "Z1_背景_爆発"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*12, 64, 64) # ベジータ
      add_chr(@z1_scenex-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*11, 64, 64) # ナッパ
      add_chr(@z1_scenex+192,@ene1_y,picture,rect)
      $game_variables[41] += 1
      Graphics.wait(40)
      #@main_window.contents.clear
    when 142 #ベジータとナッパ
      picture = "Z1_背景_都崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*12, 64, 64) # ベジータ
      add_chr(@z1_scenex-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*11, 64, 64) # ナッパ
      add_chr(@z1_scenex+192,@ene1_y,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
    when 143 #ベジータとナッパ飛ぶ
      Audio.se_play("Audio/SE/" + "Z1 エネルギー波2")# 効果音を再生する
      for x in 0..100
        picture = "Z1_背景_スクロール_山"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_ベジータとナッパ"
        rect2 = Rect.new(0, 0, 126, 54) # イベント
        add_chr(@z1_scrollscenex+194,@z1_scrollsceney+20,picture2,rect2)
        #@main_window.update
        Graphics.update
      end
      $game_variables[41] += 1
    when 144 #神様とZ戦士
      $partyc = [4,5,6,7,8,9]
      $chadead = [false,false,false,false,false,false]
      all_charecter_recovery #全キャラ回復
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント4")# 効果音を再生する
      character_output
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*14, 64, 64) # 神様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      Graphics.fadein(30)

      
    #===========================================================================
    #ベジータエリア
    #===========================================================================
    
    when 145 #チチ
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      if $game_switches[69] == false #チチが仲間になってなければ表示する
        picture = "Z1_顔イベント"
        rect = Rect.new(0, 64*15, 64, 64) # チチ
        add_chr(@ene1_x,@ene1_y,picture,rect)
      end
      character_output
    when 146 #ミスターポポ
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント1")# 効果音を再生する
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # ミスターポポ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 147 #サイバイマン
      Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する
      Audio.se_play("Audio/SE/" + "Z1 怪しい気")# 効果音を再生する
      picture = "Z1_背景_平野_サイバイマン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    when 148 #サイバイマン(発見)
      #Audio.bgm_play("Audio/BGM/" + "Z1 戦闘前")# 効果音を再生する
      Audio.se_play("Audio/SE/" + "Z1 ダメージ")# 効果音を再生する
      picture = "Z1_背景_平野_サイバイマン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*3, 64, 64) # サイバイマン
      for x in 0..5
        add_chr(@ene1_x-160+x*64,@ene1_y,picture,rect)
      end
      character_output
      $game_variables[41] += 1
    when 149 #サイバイマン戦闘処理
        battle_process (event_no)
    when 150 #ナッパ
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント3")# 効果音を再生する
      picture = "Z1_背景_岩場_ナッパ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*11, 64, 64) # ナッパ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 151 #ナッパ戦闘処理
        battle_process (event_no)
    when 152 #悟空到着
      Audio.bgm_play("Audio/BGM/" + "DB3 筋斗雲")# 効果音を再生する
      Audio.se_play("Audio/SE/" + "Z1 飛ぶ")# 効果音を再生する
      for x in 0..100
        picture = "Z1_背景_スクロール_山"
        rect = Rect.new(512-x*4, 0, 512, 128) # スクロール背景
        add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        picture2 ="Z1_イベント_ゴクウ"
        rect2 = Rect.new(0, 0, 96, 74) # イベント
        add_chr(@z1_scrollscenex+210,@z1_scrollsceney+20,picture2,rect2)
        #@main_window.update
        Graphics.update

      end
      $game_variables[41] += 1
    when 153 #ゴクウ到着2
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント4")# 効果音を再生する
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # ゴクウ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $partyc.unshift(3)
      $chadead.unshift(false)
      #悟空の必殺技回数増加
      cha_tec_puls 1,0,3,20 #技使用回数増加
      cha_tec_puls 2,0,3,15 #技使用回数増加
      cha_tec_puls 5,0,3,10 #技使用回数増加
    when 154 #ベジータ
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント3")# 効果音を再生する
      picture = "Z1_背景_岩場_ベジータ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*12, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 155 #ベジータ戦闘処理
        battle_process (event_no)
    when 156 #ベジータ撃破
      Audio.bgm_play("Audio/BGM/" + "Z1 イベント3")# 効果音を再生する
      picture = "Z1_背景_岩場_ベジータ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*12, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 157 #ベジータ逃走
      picture = "Z1_背景_岩場_ベジータ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    when 158 #ベジータ逃走(宇宙船)
      character_output
      Audio.se_play("Audio/SE/" + "Z1 飛ぶ")# 効果音を再生する
      for x in 0..20
        picture = "Z1_背景_岩場_ベジータ"
        rect = Rect.new(0, 0, 512, 128) # 背景
        add_chr(@z1_scenex,@z1_sceney,picture,rect)
        picture = "Z1_イベント_宇宙船(ベジータ逃走)"
        rect = Rect.new(0, 0, 16, 16) # 背景
        add_chr(@ene1_x+24,@ene1_y+54-x*4,picture,rect)
        #@main_window.update
        Graphics.update
      end
      #===以下1行ウィロー編のためコメントアウト
      #$game_progress = 1
      $game_variables[41] += 1
    when 159 #界王様
      Audio.bgm_play("Audio/BGM/" + "Z1 フィールド1")# 効果音を再生する
      picture = "Z1_背景_界王星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*18, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 160 #エンディング前
      Graphics.fadein(30)
      #all_charecter_recovery #全キャラ回復
      $game_variables[41] = 200
      #===以下4行ウィロー編のためコメントアウト
      #$game_variables[40] = 1
      #$game_progress = 1
      #$partyc = [5,6,7,8,9]
      #$chadead = [false,false,false,false,false]
    when 171 #ランチ
      picture = "顔カード"
      rect = Rect.new(0, 64*33, 64, 64) #ランチ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 901 #この世で一番強いやつ イベント(ピッコロ
      picture = "Z1_背景_ツルマイツブリ山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x-0,@play_y,picture,rect)
    when 902 #この世で一番強いやつ イベント(悟飯とウーロン
      picture = "Z1_背景_ツルマイツブリ山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+32,@play_y,picture,rect)
    when 903 #この世で一番強いやつ イベント(コーチン
      picture = "Z1_背景_ツルマイツブリ山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # コーチン
      add_chr(@play_x+0,@play_y,picture,rect)
      picture = "Z1_顔イベント"
      rect = Rect.new(0, 64*22, 64, 64) # 1
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*23, 64, 64) # 2
      add_chr(@ene1_x-64,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 3
      add_chr(@ene1_x-64,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 4
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 5
      add_chr(@ene1_x+64,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*27, 64, 64) # 6
      add_chr(@ene1_x+64,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*28, 64, 64) # 7
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
    when 904 #シェンロン
      picture = "Z1_背景_シェンロン"
      rect = Rect.new(0, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
    when 905 #この世で一番強いやつ イベント(コーチン
      picture = "Z1_背景_ツルマイツブリ山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # コーチン
      add_chr(@play_x+0,@play_y,picture,rect)
    when 906 #この世で一番強いやつ イベント(悟飯とウーロンバイオマンに発見される
      picture = "Z1_背景_ツルマイツブリ山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 907 #この世で一番強いやつ イベント(悟飯とウーロンピッコロ助けに来る
      picture = "Z1_背景_ツルマイツブリ山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-32,@play_y+64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+32,@play_y+64,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 908 #この世で一番強いやつ イベント(悟飯とウーロンピッコロ助けに来るバイオマン倒す
      picture = "Z1_背景_ツルマイツブリ山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-32,@play_y+64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+32,@play_y+64,picture,rect)
    when 909 #この世で一番強いやつ イベント(悟飯とウーロンピッコロバイオ戦士
      picture = "Z1_背景_ツルマイツブリ山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-32,@play_y+64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+32,@play_y+64,picture,rect)  
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # エビフリャー
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # ミソカッツン
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # キシーメ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 910 #この世で一番強いやつ イベント(カメハウス
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x+32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*9, 64, 64) # 亀仙人
      add_chr(@ene1_x-32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@ene1_x+32,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # ウミガメ
      add_chr(@ene1_x-32,@ene1_y-32,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@play_x+96,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@play_x-96,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*21, 64, 64) # コーチン
      add_chr(@play_x+0,@play_y+64,picture,rect)
    when 911 #この世で一番強いやつ イベント(カメハウス
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x+32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*9, 64, 64) # 亀仙人
      add_chr(@ene1_x-32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@ene1_x+32,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # ウミガメ
      add_chr(@ene1_x-32,@ene1_y-32,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # コーチン
      add_chr(@play_x+0,@play_y+64,picture,rect)
    when 912 #この世で一番強いやつ イベント(カメハウス
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x+32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*9, 64, 64) # 亀仙人
      add_chr(@ene1_x-32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@ene1_x+32,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # ウミガメ
      add_chr(@ene1_x-32,@ene1_y-32,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # バイオマン
      add_chr(@play_x+32,@play_y+0,picture,rect)
      add_chr(@play_x+32+64*1,@play_y+0,picture,rect)
      add_chr(@play_x+32+64*2,@play_y+0,picture,rect)
      add_chr(@play_x+32+64*3,@play_y+0,picture,rect)
      add_chr(@play_x-32,@play_y+0,picture,rect)
      add_chr(@play_x-32-64*1,@play_y+0,picture,rect)
      add_chr(@play_x-32-64*2,@play_y+0,picture,rect)
      add_chr(@play_x-32-64*3,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*21, 64, 64) # コーチン
      add_chr(@play_x+0,@play_y+64,picture,rect)
    when 913 #この世で一番強いやつ イベント(カメハウス
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@ene1_x+32,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # ウミガメ
      add_chr(@ene1_x-32,@ene1_y-0,picture,rect)
    when 914 #この世で一番強いやつ イベント(ウィロー要塞
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # コーチン
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 915 #この世で一番強いやつ イベント(ウィロー要塞
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # コーチン
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # ウィロー
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 916 #この世で一番強いやつ イベント(悟空とウーロン
      picture = "顔カード"
      rect = Rect.new(0, 64*20, 64, 64) # ウーロン
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-0,@play_y+0,picture,rect)
    when 917 #この世で一番強いやつ イベント(Z戦士要塞へ向かう
      character_output
    when 918 #この世で一番強いやつ イベント(Z戦士要塞へ向かう ピッコロ現れる
      character_output
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
    when 919 #この世で一番強いやつ イベント(Z戦士要塞へ向かう チチ現れる
      character_output
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
    when 931 #ウィロー要塞到着
      picture = "Z1_背景_ウイロー要塞"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
    when 941 #バイオ戦士
      picture = "顔カード"
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output
      #亀仙人の必殺技回数増加
      cha_tec_puls 225,0,3,60 #技使用回数増加
      cha_tec_puls 226,0,3,50 #技使用回数増加
      cha_tec_puls 228,0,3,40 #技使用回数増加
      cha_tec_puls 229,0,3,30 #技使用回数増加
      $cha_defeat_num[24] = 0 if $cha_defeat_num[24] == nil
      $cha_defeat_num[24] += 50 #撃破数 
    when 942 #バイオ戦士
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # エビフリャー
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # ミソカッツン
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # キシーメ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      character_output
    when 943 #バイオ戦士戦闘処理
      battle_process (event_no)
    when 951 #Dr.ウィローとコーチンのところ到着
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # コーチン
      add_chr(@ene1_x+32,@ene1_y-0,picture,rect)
      #rect = Rect.new(0, 64*20, 64, 64) # ウィロー
      #add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-32,@ene1_y-0,picture,rect)
      character_output
    when 952 #Dr.ウィローとコーチンのところ到着 ウィロー現れる
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # コーチン
      add_chr(@ene1_x+32,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # ウィロー
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-32,@ene1_y-0,picture,rect)
      character_output
    when 953 #Dr.ウィロー戦闘処理
      battle_process (event_no)
    when 961 #Dr.ウィロー撃破後
      character_output
      picture = "顔カード"
      rect = Rect.new(0, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+0,@play_y+64,picture,rect)
    when 962 #Dr.ウィロー撃破後フリーザ編へ
      $game_variables[40] = 1
      $game_progress = 1
      $partyc = [5,6,7,8,9]
      $chadead = [false,false,false,false,false]
################################################################################
#
# Z2
#
################################################################################
    when 201 #Z2あらすじ(いざ！ナメック星へ！)
      #Audio.bgm_play("Audio/BGM/" + "Z2 あらすじ")# 効果音を再生する
      picture = "Z2_あらすじ1_1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
      #Graphics.fadein(30)
    when 202 #Z2あらすじ(いざ！ナメック星へ！)
      picture = "Z2_あらすじ1_2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
    when 203 #Z2あらすじ(いざ！ナメック星へ！)
      picture = "Z2_あらすじ1_3"
      Audio.se_play("Audio/SE/" + "Z2 宇宙船移動")# 効果音を再生する
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
    when 204 #Z2あらすじ(いざ！ナメック星へ！)
      picture = "Z2_あらすじ1_4"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
    when 205 #Z2あらすじ(いざ！ナメック星へ！)
      picture = "Z2_あらすじ1_5"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
    when 206 #Z2あらすじ(いざ！ナメック星へ！)
      picture = "Z2_あらすじ1_6"
      Audio.se_play("Audio/SE/" + "Z2 宇宙船移動")# 効果音を再生する
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
    when 207 #Z2あらすじ(いざ！ナメック星へ！)
      picture = "Z2_あらすじ1_7"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
    when 208 #Z2あらすじ(いざ！ナメック星へ！)
      picture = "Z2_あらすじ1_8"
      Audio.se_play("Audio/SE/" + "Z2 宇宙船移動")# 効果音を再生する
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
    when 211 #Z2あらすじ(いざ！ナメック星へ！)
      $game_variables[41] += 1
    when 212 #Z2あらすじ(いざ！ナメック星へ！)
      #Audio.bgm_play("Audio/BGM/" + "Z2 あらすじ")# 効果音を再生する
      picture = "Z2_あらすじ1_8"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
    when 213 #Z2あらすじ(ドラゴンボールを集めろ！)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 214 #Z2あらすじ(ドラゴンボールを集めろ！)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 215 #Z2あらすじ(悟空出発！)
      picture = "Z2_背景_宇宙船と悟空"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
    when 216 #Z2あらすじ(ドラゴンボールを集めろ！)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 217 #Z2あらすじ(最長老)
      picture = "Z2_背景_最長老の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
    when 218 #Z2あらすじ(フリーザ戦艦)
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 219 #Z2あらすじ(ネイル)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*10, 64, 64) # ネイル
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
     when 220 #あらすじ(ピッコロ)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
     when 221 #あらすじ(ポルンガ)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*31, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 222 #Z2あらすじ(フリーザ第２形態)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 223 #Z2あらすじ(フリーザ第３形態)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 224 #Z2あらすじ(バーダック編)1
      picture = "Z1_背景_都崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*14, 64, 64) # カナッサ星人エネルギー波食らった
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "Z2_顔イベント"
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@play_x+128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@play_x-64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@play_x-128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,27,1 #バンブーキン
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 225 #Z2あらすじ(バーダック編)2
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@play_x+32,@play_y,picture,rect)
    when 226 #Z2あらすじ(バーダック編)3
      picture = "Z2_背景_メディカルルーム"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*8, 64, 64) # メディカルルームの惑星戦士
      add_chr(@play_x,@play_y,picture,rect)
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@play_x+128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@play_x-128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,27,1 #バンブーキン
      add_chr(@play_x-64,@play_y+0,picture,rect)
    when 227 #Z2あらすじ(バーダック編)4
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 228 #Z2あらすじ(バーダック編)5
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      rect,picture = set_character_face 1,24,1 #トーマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 229 #Z2あらすじ(バーダック編)6
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@ene1_x,@ene1_y-0,picture,rect)
    when 230 #Z2あらすじ(バーダック編)7
      picture = "Z3_背景_宇宙_フリーザ宇宙船"
      rect = Rect.new(340, 0, 192, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 231 #Z2あらすじ(バーダック編)8
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 301 #謎の宇宙船
      picture = "Z2_背景_謎の宇宙船"
      Audio.bgm_play("Audio/BGM/" + "DB2 イベント02")# 効果音を再生する
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    when 302 #謎の宇宙船_内部
      picture = "Z2_背景_謎の宇宙船_内部"
      #Audio.se_play("Audio/BGM/" + "DB2 イベント02")# 効果音を再生する
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    when 303 #謎の宇宙船
      picture = "Z2_背景_壁"
      #Audio.bgm_stop
      Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント1")# 効果音を再生する
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    when 304 #謎の宇宙船
      picture = "Z2_背景_謎の宇宙船_内部"
      #Audio.se_stop
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント04")# 効果音を再生する
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    when 305 #謎の惑星
      picture = "Z2_背景_謎の惑星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    when 306 #謎の惑星_内部
      Audio.bgm_play("Audio/BGM/" + "DB2 イベント01",90)# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 異星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 307 #謎の惑星_異星人
      Graphics.fadeout(30)
      Graphics.fadein(30)
      #Audio.se_stop
      Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*2, 64, 64) # 異星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 308 #異星人戦闘処理
        battle_process (event_no)
    when 309 #謎の惑星_異星人
      Audio.bgm_play("Audio/BGM/" + "DB2 イベント01",90)# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*2, 64, 64) # 異星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 310 #ナメック星到着
      picture = "Z2_背景_ナメック星到着"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    when 311 #ナメック星地上
      Graphics.fadeout(30)
      Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント2")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 312 #ナメック星地上_宇宙船落下
      #Graphics.fadeout(30)
      #Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント2")# 効果音を再生する
      picture = "Z2_背景_ナメック星_宇宙船落下"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      #picture = "顔カード"
      #rect = Rect.new(64, 64*8, 64, 64) # ブルマ
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      #Graphics.fadein(30)
    when 313 #ベジータナメック星到着
      Graphics.fadeout(30)
      #Audio.bgs_stop
      Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント4")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 314 #キュイナメック星到着
      Graphics.fadeout(30)
      #Audio.bgm_play("Audio/BGM/" + "DB2 イベント01",90)# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 315 #ベジータナメック星到着
      Graphics.fadeout(30)
      #Audio.bgm_play("Audio/BGM/" + "DB2 イベント01",90)# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 321 #洞窟へ入る
    when 322 #洞窟から出る
      
    when 323 #キュイ
      #Graphics.fadeout(30)
      Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z2_背景_岩場"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # キュイ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      #Graphics.fadein(30)
    when 324 #キュイ戦闘
      battle_process (event_no)
      
    when 325 #ナメック星_家
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント08")# 効果音を再生する
      picture = "Z2_背景_ナメック星_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # ナメック星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 503 #ナメック星_若者仲間に
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント08")# 効果音を再生する
      picture = "Z2_背景_ナメック星_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*7, 64, 64) # ナメック星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      $partyc << 15
      $chadead << false
      $game_variables[41] += 1
      #若者の必殺技回数増加
      cha_tec_puls 141,0,3,80 #技使用回数増加
      cha_tec_puls 142,0,3,50 #技使用回数増加
      cha_tec_puls 143,0,3,30 #技使用回数増加
      cha_tec_puls 144,0,3,10 #技使用回数増加
      $cha_defeat_num[15] = 0 if $cha_defeat_num[12] == nil
      $cha_defeat_num[15] += 50 #撃破数 
    when 326 #フリーザ一味
      Audio.bgm_play("Audio/BGM/" + "ZD イベント1")# 効果音を再生する
      picture = "Z2_背景_フリーザ"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 長老
      add_chr(@play_x-32,@play_y,picture,rect)
      #picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*4, 64, 64) # 長老
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      $game_variables[41] += 1
    when 327 #フリーザ一味
      #フラッシュ用
      #@main_window.contents.clear
      $game_variables[41] += 1
    when 328 #フリーザ一味
      #Audio.bgm_play("Audio/BGM/" + "ZD イベント1")# 効果音を再生する
      picture = "Z2_背景_フリーザ"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 長老
      add_chr(@play_x-32,@play_y,picture,rect)
      #picture = "Z2_顔イベント"
      #rect = Rect.new(0, 64*4, 64, 64) # 長老
      #add_chr(@play_x+32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      $game_variables[41] += 1
    when 329 #フリーザ一味
      #Audio.bgm_play("Audio/BGM/" + "ZD イベント1")# 効果音を再生する
      picture = "Z2_背景_フリーザ"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 長老
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*6, 64, 64) # 6DB
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      $game_variables[41] += 1
    when 330 #フリーザ一味
      #Audio.bgm_play("Audio/BGM/" + "ZD イベント1")# 効果音を再生する
      picture = "Z2_背景_フリーザ"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      $game_variables[41] += 1
    when 331 #フリーザ一味
      #フラッシュ用
      #@main_window.contents.clear
      $game_variables[41] += 1
    when 332 #フリーザ一味
      #Audio.bgm_play("Audio/BGM/" + "ZD イベント1")# 効果音を再生する
      picture = "Z2_背景_フリーザ"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*2, 64, 64) # ごはん
      add_chr(@play_x,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      $game_variables[41] += 1
    when 333 #フリーザ一味
      #Audio.bgm_play("Audio/BGM/" + "ZD イベント1")# 効果音を再生する
      picture = "Z2_背景_フリーザ"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      $game_variables[41] += 1
    when 334 #フリーザ一味
      #Audio.bgm_play("Audio/BGM/" + "ZD イベント1")# 効果音を再生する
      picture = "Z2_背景_フリーザ"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 335 #フリーザ一味
      #Audio.bgm_play("Audio/BGM/" + "ZD イベント1")# 効果音を再生する
      picture = "Z2_背景_フリーザ"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      #rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      #add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 336 #ドドリア逃走後
      Audio.bgm_play("Audio/BGM/" + "GBZ2 戦闘終了")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      #Graphics.fadeout(30)
    when 337 #ドドリア宇宙船へ向かう（キュイ）
      Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z2_背景_岩場"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      #Graphics.fadein(30)
    when 338 #ドドリア宇宙船へ向かう（ナメック星）
      #Audio.bgm_play("Audio/BGM/" + "DB3 戦闘前")# 効果音を再生する
      picture = "Z2_背景_ナメック星_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      #Graphics.fadein(30)
    when 339 #ドドリア
      Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント8")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 340 #ドドリア戦闘
      battle_process (event_no)
    when 341 #ドドリア撃破1
      Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント5")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 342 #ドドリア撃破2
      Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント6")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*8, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 401 #悟空出発
      #Graphics.fadeout(30)
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント03")# 効果音を再生する
      picture = "Z2_背景_病室"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*3, 64, 64) # 味方顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
      #Graphics.fadein(30)
    when 402 #悟空出発
      #Graphics.fadeout(30)
      #Audio.bgm_play("Audio/BGM/" + "DB イベント03")# 効果音を再生する
      picture = "Z2_背景_病室"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*3, 64, 64) # 味方顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*9, 64, 64) # 亀仙人
      add_chr(@play_x,@play_y,picture,rect)
      #character_output
      $game_variables[41] += 1
      #Graphics.fadein(30)
    when 403 #悟空出発
      #Graphics.fadeout(30)
      #Audio.bgm_play("Audio/BGM/" + "DB イベント03")# 効果音を再生する
      picture = "Z2_背景_病室"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*3, 64, 64) # 味方顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*9, 64, 64) # 亀仙人
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*23, 64, 64) # ヤジロベー
      add_chr(@play_x+32,@play_y,picture,rect)
      #character_output
      $game_variables[41] += 1
      #Graphics.fadein(30)
    when 404 #悟空出発
      #Graphics.fadeout(30)
      #Audio.bgm_play("Audio/BGM/" + "DB イベント03")# 効果音を再生する
      picture = "Z2_背景_病室"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(64*0, 64*0, 64, 64) # 味方顔
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*9, 64, 64) # 亀仙人
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*23, 64, 64) # ヤジロベー
      add_chr(@play_x+32,@play_y,picture,rect)
      #character_output
      $game_variables[41] += 1
      #Graphics.fadein(30)
    when 405 #悟空出発
      Graphics.fadeout(30)
      #Audio.bgm_play("Audio/BGM/" + "DB イベント03")# 効果音を再生する
      picture = "Z2_背景_宇宙船と悟空"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      #character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
      $partyc = [3]
      $chadead = [false]
      all_charecter_recovery #全キャラ回復
    when 410 #悟空修行へ移動
      
    when 411 #20倍修行完了
      picture = "Z2_背景_宇宙船と悟空"
      Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント3")# 効果音を再生する
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
      $partyc = [5,6,7,8,9]
      $chadead = [false,false,false,false,false]
      
      if $game_switches[107] == true#若者仲間にしたなら
        $partyc << 15
        $chadead << false
      end 
      all_charecter_recovery #全キャラ回復

    when 412 #ドラゴンボール探し再開
      Graphics.fadeout(30)
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント02")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 504 #ドラゴンボール探し若者仲間から外れる
      $partyc = [5,6,7,8,9]
      $chadead = [false,false,false,false,false]
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*7, 64, 64) # ナメック星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 505 #ドラゴンボール探し若者仲間から外れる
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 515 #ドラゴンボール探し再開
      $partyc = [5,6,7,8,9]
      $chadead = [false,false,false,false,false]
      Graphics.fadeout(30)
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント02")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    
    when 413 #ナメック星_家
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント08")# 効果音を再生する
      picture = "Z2_背景_ナメック星_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*4, 64, 64) # ナメック星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 414 #ナメック星_家
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント08")# 効果音を再生する
      picture = "Z2_背景_ナメック星_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 415 #悟空修行再開1
      Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント3")# 効果音を再生する
      picture = "Z2_背景_宇宙船と悟空"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
      
      $partyc = [3]
      $chadead = [false]
      all_charecter_recovery #全キャラ回復
    when 416 #界王星
      #Audio.bgm_play("Audio/BGM/" + "DB2 イベント01",90)# 効果音を再生する
      picture = "Z2_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] = 411
    when 417 #界王星_ピッコロ
      #Audio.bgm_play("Audio/BGM/" + "DB2 イベント01",90)# 効果音を再生する
      picture = "Z2_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 418 #悟空修行完了 50倍

    when 419 #池のドラゴンボール
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント03")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*0, 64, 64) # ドラゴンレーダー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 420 #池のドラゴンボール
      Audio.bgm_play("Audio/BGM/" + "GBZ2 戦闘終了")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*3, 64, 64) # ドラゴンボール
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 421 #悟空修行再開
    when 422 #カナッサ星
      
      $partyc = [3]
      $chadead = [false]
      all_charecter_recovery #全キャラ回復
      picture = "Z2_背景_謎の惑星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    when 423 #カナッサ星建物内
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント07")# 効果音を再生する
      picture = "Z2_背景_惑星_建物"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 424 #カナッサ星建物内
      picture = "Z2_背景_惑星_建物"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*5, 64, 64) # ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 425 #カナッサ星建物内(戦闘)
      battle_process (event_no)
    when 426 #カナッサ星
      Audio.bgm_play("Audio/BGM/" + "DB2 イベント01",90)# 効果音を再生する
      picture = "Z2_背景_カナッサ星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
      character_output
    when 427 #カナッサ星離脱
      #Audio.bgm_play("Audio/BGM/" + "DB2 イベント01",90)# 効果音を再生する
      picture = "Z2_背景_謎の惑星と宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
      character_output
    when 428 #悟空修行終了
      Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント3")# 効果音を再生する
      picture = "Z2_背景_宇宙船と悟空"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
      $partyc = [4]
      $chadead = [false]
      all_charecter_recovery #全キャラ回復
    when 429 #界王星_界王
      Graphics.fadeout(30)
      Audio.bgm_play("Audio/BGM/" + "GBZ1 界王修行")# 効果音を再生する
      picture = "Z2_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
      character_output
      Graphics.fadein(30)
    when 430 #界王星_界王
      Audio.bgm_play("Audio/BGM/" + "GBZ2 戦闘終了")# 効果音を再生する
      picture = "Z2_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
      character_output
    when 431 #ナメック星地上
      Graphics.fadeout(30)
      Audio.bgm_play("Audio/BGM/" + "DB3 イベント02")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $partyc = [5,6,7,8,9]
      $chadead = [false,false,false,false,false]
      all_charecter_recovery #全キャラ回復
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 432 #フリーザ宇宙船
      $game_variables[41] += 1
      Graphics.fadeout(30)
      Graphics.fadein(30)
      Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント8")# 効果音を再生する
    when 433 #フリーザ宇宙船
      
      #Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント8")# 効果音を再生する
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "顔カード"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@play_x,@play_y,picture,rect)
      $game_variables[41] += 1
      
    when 434 #フリーザ宇宙船
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 601 #ザーボンエリア ナメック星人機能説明
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 長老
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 435 #最長老の家
      Audio.bgm_play("Audio/BGM/" + "DB2 イベント03")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*10, 64, 64) # ネイル
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      $game_variables[41] += 1
    when 436 #最長老の家
      #Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント2")# 効果音を再生する
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 437 #最長老の家_内部
      Graphics.fadeout(30)
      #Audio.bgm_play("Audio/BGM/" + "GBZ2 イベント2")# 効果音を再生する
      picture = "Z2_背景_最長老の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      #picture = "顔カード"
      #rect = Rect.new(64, 64*14, 64, 64) # デンデ
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      Graphics.fadein(30)
    when 438 #最長老の家(ベジータ)
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 439 #最長老の家(ザーボン)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $partyc << 12
      $chadead << false
      character_output
      all_charecter_recovery #全キャラ回復
      $game_variables[41] += 1
      #べジータの必殺技回数増加
      cha_tec_puls 121,0,3,110 #技使用回数増加
      cha_tec_puls 123,0,3,85 #技使用回数増加
      cha_tec_puls 124,0,3,65 #技使用回数増加
      $cha_defeat_num[12] = 0 if $cha_defeat_num[12] == nil
      $cha_defeat_num[12] += 100 #撃破数 
    when 440 #ザーボン戦闘
      battle_process (event_no)
    when 441 #最長老の家(ザーボン)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 442 #最長老の家(ザーボン変身)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*16, 64, 64) # ザーボン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 443 #ザーボン変身戦闘
      battle_process (event_no)
    when 444 #ザーボン変身戦闘後
      $tmp_partyc = Marshal.load(Marshal.dump($partyc))
      $partyc.delete(12)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $partyc = Marshal.load(Marshal.dump($tmp_partyc))
      $chadead = [false,false,false,false,false,false]
      all_charecter_recovery #全キャラ回復
      $game_variables[41] += 1
    when 445 #ベジータドラゴンボール
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*2, 64, 64) # ドラゴンボール
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 446 #フリーザ宇宙船
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 447 #フリーザ宇宙船
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*21, 64, 64) # リクーム
      add_chr(@play_x-128,@play_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # グルド
      add_chr(@play_x-64,@play_y,picture,rect)
      rect = Rect.new(0, 64*18, 64, 64) # ギニュー
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*19, 64, 64) # ジース
      add_chr(@play_x+64,@play_y,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # バータ
      add_chr(@play_x+128,@play_y,picture,rect)
      $game_variables[41] += 1
    when 448 #ベジータとギニュー特選隊
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # リクーム
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # グルド
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*18, 64, 64) # ギニュー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*19, 64, 64) # ジース
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # バータ
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 449 #悟空到着
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 450 #悟空到着再開
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
      $partyc.unshift(3)
      $chadead.unshift(false) 
      all_charecter_recovery #全キャラ回復
      #悟空の必殺技回数増加
      cha_tec_puls 1,0,3,50 #技使用回数増加
      cha_tec_puls 2,0,3,40 #技使用回数増加
      cha_tec_puls 5,0,3,30 #技使用回数増加
      cha_tec_puls 6,0,3,25 #技使用回数増加
      cha_tec_puls 7,0,3,20 #技使用回数増加
      cha_tec_puls 18,0,3,15 #技使用回数増加
    when 451 #ベジータとギニュー特選隊
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # リクーム
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # グルド
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*18, 64, 64) # ギニュー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*19, 64, 64) # ジース
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # バータ
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 452 #ギニュー特選隊戦闘
      battle_process (event_no)
    when 453 #ギニュー特選隊戦闘後
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # リクーム
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # グルド
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*18, 64, 64) # ギニュー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*19, 64, 64) # ジース
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # バータ
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 454 #ギニュー特選隊戦闘後
      picture = "Z1_背景_都崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    when 455 #メディカルルーム休憩
      Graphics.fadeout(30)
      picture = "Z2_背景_メディカルルーム"
      #Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
      all_charecter_recovery #全キャラ回復
      $partyc = [5,6,7,8,9,12]
      $chadead = [false,false,false,false,false,false]
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 456 #ドラゴンボール
      Graphics.fadeout(30)
      #picture = "Z2_背景_ナメック星_地上"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*1, 64, 64) # 1
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(64, 64*2, 64, 64) # 2
      add_chr(@ene1_x-64,@ene1_y-32,picture,rect)
      rect = Rect.new(64, 64*3, 64, 64) # 3
      add_chr(@ene1_x-64,@ene1_y+32,picture,rect)
      rect = Rect.new(64, 64*4, 64, 64) # 4
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(64, 64*5, 64, 64) # 5
      add_chr(@ene1_x+64,@ene1_y-32,picture,rect)
      rect = Rect.new(64, 64*6, 64, 64) # 6
      add_chr(@ene1_x+64,@ene1_y+32,picture,rect)
      rect = Rect.new(64, 64*7, 64, 64) # 7
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 457 #フリーザ
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
     when 458 #最長老の家
      Graphics.fadeout(30)
      picture = "Z2_背景_最長老の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*10, 64, 64) # ネイル
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
     when 459 #最長老の家(フリーザ進入)
      picture = "Z2_背景_最長老の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*10, 64, 64) # ネイル
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@play_x,@play_y,picture,rect)
      $game_variables[41] += 1
     when 460 #最長老の家(フリーザ進入2)
      picture = "Z2_背景_最長老の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $game_variables[41] += 1
     when 461 #最長老の家(まっくら)
      $game_variables[41] += 1 
     when 462 #デンデ到着
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      $partyc = [5,6,7,8,9]
      $chadead = [false,false,false,false,false]
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
     when 463 #ポルンガ呼び出し(まっくら)
      $game_variables[41] += 1
     when 464 #ネイル敗北
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*10, 64, 64) # ネイル
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      Graphics.fadein(30)
      $game_variables[41] += 1
     when 465 #ポルンガ呼び出し
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      #$game_variables[41] += 1
      Graphics.fadein(30)
     when 466 #ポルンガ呼び出し(暗い)
      #Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_暗い"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
      #Graphics.fadein(30)
     when 467 #ポルンガ呼び出し(海王星)
      Graphics.fadeout(30)
      picture = "Z2_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x,@play_y,picture,rect)
      $game_variables[41] += 1
      Graphics.fadein(30)
     when 468 #ポルンガ呼び出し(ピッコロ復活)
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_暗い"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
      Graphics.fadein(30)
     when 469 #ポルンガ呼び出し(ベジータ)
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_暗い"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
     when 470 #ポルンガ呼び出し(最長老死亡)
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
     when 471 #ポルンガ呼び出し(フリーザ発見)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      $partyc = [5,6,7,8,9,12]
      $chadead = [false,false,false,false,false,false]
      all_charecter_recovery #全キャラ回復
      character_output
      $game_variables[41] += 1
    when 472 #フリーザ戦闘
      battle_process (event_no)
      
    when 473 #フリーザ戦闘後
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 474 #フリーザ戦闘後
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*24, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 475 #ピッコロ
      $partyc = [4]
      $chadead = [false]
      all_charecter_recovery #全キャラ回復
      #ピッコロの必殺技回数増加
      cha_tec_puls 31,0,3,20 #技使用回数増加
      cha_tec_puls 33,0,3,20 #技使用回数増加
      cha_tec_puls 34,0,3,20 #技使用回数増加
      cha_tec_puls 35,0,3,10 #技使用回数増加
      cha_tec_puls 36,0,3,30 #技使用回数増加
      $game_variables[41] += 1
    when 476 #ネイル
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*10, 64, 64) # ネイル
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
     when 477 #ネイル同化語
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
      all_charecter_recovery #全キャラ回復
      #ピッコロの必殺技回数増加
      cha_tec_puls 31,0,3,20 #技使用回数増加
      cha_tec_puls 33,0,3,20 #技使用回数増加
      cha_tec_puls 34,0,3,20 #技使用回数増加
      cha_tec_puls 35,0,3,15 #技使用回数増加
      cha_tec_puls 36,0,3,45 #技使用回数増加
      
      #ピッコロがスキルネイルと同化を覚える(神との融合を覚えてたら実行しない)
      if $cha_typical_skill[4][0] != 249
        set_typical_skill 4,0,248
      end
    when 478 #ピッコロ合流
      $game_variables[41] += 1
      $partyc = [4,5,6,7,8,9,12]
      $chadead = [false,false,false,false,false,false,false]
      all_charecter_recovery #全キャラ回復
    when 479 #ピッコロ合流
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*24, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 480 #フリーザ戦闘
      battle_process (event_no)
    when 481 #フリーザ第１形態撃破後
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*24, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 482 #フリーザ第２形態変身
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 483 #フリーザ第２形態変身
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 484 #フリーザ第２形態変身
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 485 #フリーザ第２形態戦闘
      battle_process (event_no)
    when 486 #フリーザ第２形態変身
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64, 64*14, 64, 64) # デンデ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 487 #フリーザ第３形態変身
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      #rect = Rect.new(64, 64*14, 64, 64) # デンデ
      #add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 488 #メディカルルーム休憩
      Graphics.fadeout(30)
      picture = "Z2_背景_メディカルルーム"
      #Audio.bgm_play("Audio/BGM/" + "GBZ1 イベント2")# 効果音を再生する
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $partyc.unshift(3)
      $chadead.unshift(false) 
      Graphics.fadein(30)
      $game_variables[41] += 1
      #悟空の必殺技回数増加
      cha_tec_puls 1,0,3,25 #技使用回数増加
      cha_tec_puls 2,0,3,20 #技使用回数増加
      cha_tec_puls 5,0,3,20 #技使用回数増加
      cha_tec_puls 6,0,3,15 #技使用回数増加
      cha_tec_puls 7,0,3,15 #技使用回数増加
      cha_tec_puls 18,0,3,15 #技使用回数増加
    when 489 #フリーザ第３形態変身
      Graphics.fadeout(30)
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      #rect = Rect.new(64, 64*14, 64, 64) # デンデ
      #add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 490 #フリーザ第３形態変身
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)

      character_output
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*6, 64, 64) # デンデ
      add_chr(@play_x-64*4+32,@play_y,picture,rect)
      $game_variables[41] += 1
    when 491 #フリーザ第３形態変身
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      #rect = Rect.new(64, 64*14, 64, 64) # デンデ
      #add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1

    when 492 #フリーザ第３形態変身
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      #rect = Rect.new(64, 64*14, 64, 64) # デンデ
      #add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1

    when 493 #フリーザ第3形態戦闘
      battle_process (event_no)
    when 494 #フリーザ第３形態変身
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      #rect = Rect.new(64, 64*14, 64, 64) # デンデ
      #add_chr(@play_x,@play_y+64,picture,rect)
      character_output
      $game_variables[41] += 1
    when 495 #フリーザ第３形態変身
      $game_variables[41] += 1
    when 496 #フリーザ第３形態変身
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "顔カード"
      #rect = Rect.new(64, 64*14, 64, 64) # デンデ
      #add_chr(@play_x,@play_y+64,picture,rect)
      on_super_saiyazin 1
      character_output
      $game_variables[41] += 1
    when 497 #フリーザ第3形態戦闘(超サイヤ人)
      $cardi_max = 9
      battle_process (event_no)
    when 498 #フリーザ撃破後
      if $game_switches[105] == true #超ベジータと戦闘する
        
        $chadead.delete_at($partyc.index(12))
        $partyc.delete(12)
        
      end
      character_output
      $game_variables[41] += 1
    when 499 #ベジータ
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 500 #超ベジータ
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # 超ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 501 #ベジータ戦闘(超サイヤ人)
      battle_process (event_no)
    when 502 #フリーザ撃破後
      #picture = "Z2_背景_ナメック星到着"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scenex,@z1_sceney,picture,rect)
      character_output
      $game_variables[41] += 1
    #when 503 上で定義済み #ナメック星_若者仲間に
    #when 504 上で定義済み #ドラゴンボール探し若者仲間から外れる
    #when 505 上で定義済み #ドラゴンボール探し若者仲間から外れる

    when 506 #若者同化
      picture = "Z2_背景_ナメック星_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # ナメック星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      picture = "顔カード"
      #rect = Rect.new(64, 64*14, 64, 64) # デンデ
      #add_chr(@play_x,@play_y+64,picture,rect)
      $game_variables[41] += 1
    when 507 #若者同化
      picture = "Z2_背景_ナメック星_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*7, 64, 64) # ナメック星人若者
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      picture = "顔カード"
      #rect = Rect.new(64, 64*14, 64, 64) # デンデ
      #add_chr(@play_x,@play_y+64,picture,rect)
      $game_variables[41] += 1
      
=begin
      #ピッコロの必殺技回数増加
      cha_tec_puls 31,141,1,1.1 #技使用回数増加
      cha_tec_puls 33,141,2,1.5
      cha_tec_puls 34,141,2,2
      cha_tec_puls 35,142,1,2
      cha_tec_puls 36,142,2,2
=end
      #ピッコロの必殺技回数増加 (周回プレイを考慮し固定に変更)
      cha_tec_puls 31,0,3,40 #技使用回数増加
      cha_tec_puls 33,0,3,30 #技使用回数増加
      cha_tec_puls 34,0,3,30 #技使用回数増加
      cha_tec_puls 35,0,3,25 #技使用回数増加
      cha_tec_puls 36,0,3,20 #技使用回数増加
      
    when 508 #ターレスとスラッグ
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*29, 64, 64) # ターレス
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # スラッグ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 509 #バーダック
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*13, 64, 64) # バーダック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      $partyc << 16
      $chadead << false

      $game_variables[41] += 1
    when 510 #ターレスとスラッグ
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*29, 64, 64) # ターレス
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # スラッグ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      character_output
      $game_variables[41] += 1
    when 511 #ターレスとスラッグ戦闘(ターレスとスラッグ)
      battle_process (event_no)
    when 512 #バーダック別れ
      $chadead.delete_at($partyc.index(16))
      $partyc.delete(16)
      character_output
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*13, 64, 64) # バーダック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 513 #バーダック別れ
      character_output
      $game_variables[41] += 1

      
    when 514 #ターレスとスラッグ(登場)
      $game_variables[41] += 1
    #when 515 上で定義済み #ナメック星_悟飯たちドラゴンボール探し再開
    when 521 #バトルスーツ取得
      character_output
      #picture = "Z2_背景_フリーザ_宇宙船_内部"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scenex,@z1_sceney,picture,rect)
      #picture = "顔カード"
      #rect = Rect.new(0, 64*40, 64, 64) # 戦闘服
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      
      if $game_variables[43] == 33 || $game_variables[43] == 35
        picture = "顔カード"
        rect = Rect.new(64, 64*14, 64, 64) # デンデ
        add_chr(@play_x,@play_y+64,picture,rect)
      end
    when 522 #バトルスーツ取得
      character_output
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*40, 64, 64) # 戦闘服
      add_chr(@ene1_x,@ene1_y,picture,rect)
      
      if $game_variables[43] == 33 || $game_variables[43] == 35
        picture = "顔カード"
        rect = Rect.new(64, 64*14, 64, 64) # デンデ
        add_chr(@play_x,@play_y+64,picture,rect)
      end
    when 531 #フリーザを超元気玉でしとめる(イベント戦闘用
      set_battle_event
    when 541 #超元気玉発動後のイベント(ここに処理は書かないかも)
      
    when 543 #超元気玉発動後(海王星)
      picture = "Z2_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64*1, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 544 #ナメック星
      character_output
    when 545 #フリーザ生きてる
      character_output
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 546 #フリーザ生きてる(クリリンを右に移動)
      character_output
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)  
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
    when 547 #クリリン爆発
      character_output
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 548 #フリーザフルパワー
      character_output
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # フリーザ(フルパワー)
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 556 #フリーザフルパワーとの戦闘
      $cardi_max = 9
      battle_process (event_no)
    when 561 #フルパワーフリーザ撃破後
      character_output
    when 602 #Z2最終エリア ナメック星人スキル説明
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*4, 64, 64) # ナメック星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
################################################################################
#
# Z2バーダック編
#
################################################################################
    when 3001 #Z2バーダック編スタート
      picture = "Z2_背景_惑星ベジータ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      #picture = "Z3_顔味方"
      #rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      #picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      #add_chr(@play_x+48,@play_y,picture,rect)
      #rect = Rect.new(0, 64*29, 64, 64) # トランクス
      #add_chr(@play_x-48,@play_y,picture,rect)
   when 3002 #メディカルルームとカカロット
      picture = "Z2_背景_メディカルルーム"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*8, 64, 64) # メディカルルームの惑星戦士
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3003 #カナッサ星
      picture = "Z2_背景_謎の惑星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
    when 3004 #バーダックカナッサ星制圧
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*5, 64, 64) # カナッサ星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3005 #バーダックカナッサ星制圧後
      picture = "Z1_背景_都崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      #picture = "Z2_顔イベント"
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,27,1 #バンブーキン
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 3006 #バーダックカナッサ星制圧後 カナッサ星人現れる
      picture = "Z1_背景_都崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*5, 64, 64) # カナッサ星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "Z2_顔イベント"
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@play_x+128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@play_x-64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@play_x-128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,27,1 #バンブーキン
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 3007 #バーダックカナッサ星制圧後 カナッサ星人現れバーダックやられる
      picture = "Z1_背景_都崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*5, 64, 64) # カナッサ星人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "Z2_顔イベント"
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@play_x+128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@play_x-64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@play_x-128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,27,1 #バンブーキン
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect,picture = set_character_face 1,13,1 #バーダック
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 3008 #バーダックカナッサ星制圧後 カナッサ星人やられる
      picture = "Z1_背景_都崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      #picture = "Z2_顔イベント"
      #rect = Rect.new(0, 64*14, 64, 64) # カナッサ星人エネルギー波食らった
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "Z2_顔イベント"
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@play_x+128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@play_x-64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@play_x-128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,27,1 #バンブーキン
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect,picture = set_character_face 1,13,1 #バーダック
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 3009 #バーダックカナッサ星制圧後 カナッサ星人現れバーダックおきる
      picture = "Z1_背景_都崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*14, 64, 64) # カナッサ星人エネルギー波食らった
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "Z2_顔イベント"
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@play_x+128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@play_x-64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@play_x-128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,27,1 #バンブーキン
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 3010 #バーダックカナッサ星制圧後 カナッサ星人やられる
      picture = "Z1_背景_都崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      #picture = "Z2_顔イベント"
      #rect = Rect.new(0, 64*14, 64, 64) # カナッサ星人エネルギー波食らった
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "Z2_顔イベント"
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@play_x+128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@play_x-64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@play_x-128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,27,1 #バンブーキン
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 3011 #バーダックカナッサ星制圧後 バーダック気絶
      picture = "Z1_背景_都崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      #picture = "Z2_顔イベント"
      #rect = Rect.new(0, 64*14, 64, 64) # カナッサ星人エネルギー波食らった
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "Z2_顔イベント"
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@play_x+128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@play_x-64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@play_x-128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,27,1 #バンブーキン
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect,picture = set_character_face 1,13,1 #バーダック
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 3021 #ベジータ対サイバイマン
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # ベジータ子ども
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*3, 64, 64) # サイバイマン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
    when 3022 #ベジータ対サイバイマン気絶
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # ベジータ子ども
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(64, 64*3, 64, 64) # サイバイマン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
    when 3023 #ベジータ対サイバイマン激は
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # ベジータ子ども
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 3024 #ベジータとナッパ
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # ベジータ子ども
      add_chr(@play_x+0,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*12, 64, 64) # ナッパ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3031 #フリーザ一味
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@play_x+32,@play_y,picture,rect)
    when 3032 #フリーザ一味とベジータ
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # ベジータ子ども
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 3041 #バーダックメディカルルーム
      picture = "Z2_背景_メディカルルーム"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*8, 64, 64) # メディカルルームの惑星戦士
      add_chr(@play_x,@play_y,picture,rect)
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@play_x+128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@play_x-128,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,27,1 #バンブーキン
      add_chr(@play_x-64,@play_y+0,picture,rect)
    when 3042 #トーマたち惑星ミートへ
      picture = "Z2_背景_惑星ベジータ_出発"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
    when 3043 #バーダックメディカルルームと医師のみ
      picture = "Z2_背景_メディカルルーム"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*8, 64, 64) # メディカルルームの惑星戦士
      add_chr(@play_x,@play_y,picture,rect)
    when 3044 #バーダック意識
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3045 #バーダック意識、悟空とじいちゃん
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(1*64, 64*24, 64, 64) # じいちゃん
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3046 #バーダック意識、トーマ瀕死
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      rect,picture = set_character_face 1,24,1 #トーマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3047 #バーダック意識、悟空とブルマ
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # ゴクウ子ども
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*16, 64, 64) # ブルマ子ども
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3048 #バーダック意識、悟空とクリリン亀仙人
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # ゴクウ子ども
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*17, 64, 64) # クリリン子ども
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*18, 64, 64) # 亀仙人
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 3049 #バーダック意識、悟空とピッコロ大魔王
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # ゴクウ子ども
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(1*64, 64*114, 64, 64) # ピッコロ大魔王
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3050 #バーダック意識、悟空とポポ
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # ゴクウ子ども
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(1*64, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3051 #バーダック意識、悟空大人とマジュニア
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*20, 64, 64) # ゴクウ大人
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*19, 64, 64) # マジュニア
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3052 #バーダック意識
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3053 #バーダックメディカルルームと医師のみ
      picture = "Z2_背景_メディカルルーム"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*8, 64, 64) # メディカルルームの惑星戦士
      add_chr(@play_x,@play_y,picture,rect)
    when 3054 #バーダックメディカルルームと医師　バーダック飛び出す
      picture = "Z2_背景_メディカルルーム"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*8, 64, 64) # メディカルルームの惑星戦士
      add_chr(@play_x,@play_y,picture,rect)
    when 3055 #バーダック走る
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3056 #バーダック走るカカロットを見つける
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3057 #バーダック走る 惑星ベジータ爆発
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_背景_惑星ベジータ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
    when 3061 #ミート星 トーマたち
      rect,picture = set_character_face 1,24,1 #トーマ
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 1,25,1 #セリパ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect,picture = set_character_face 1,26,1 #トテッポ
      add_chr(@play_x+96,@play_y+0,picture,rect)
      rect,picture = set_character_face 1,27,1 #バンブーキン
      add_chr(@play_x-96,@play_y+0,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*31, 64, 64) # 惑星戦士1
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*32, 64, 64) # 惑星戦士2
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*33, 64, 64) # 惑星戦士3
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*34, 64, 64) # 惑星戦士4
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 3062 #ミート星 トーマたち ドドリア現れる
      rect,picture = set_character_face 1,24,1 #トーマ
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 1,25,1 #セリパ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect,picture = set_character_face 1,26,1 #トテッポ
      add_chr(@play_x+96,@play_y+0,picture,rect)
      rect,picture = set_character_face 1,27,1 #バンブーキン
      add_chr(@play_x-96,@play_y+0,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*31, 64, 64) # 惑星戦士1
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*32, 64, 64) # 惑星戦士2
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*33, 64, 64) # 惑星戦士3
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*34, 64, 64) # 惑星戦士4
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
    when 3063 #バーダック惑星ミートに到着
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3064 #バーダック トーマを見つける
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      rect,picture = set_character_face 1,24,1 #トーマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3065 #バーダック トテッポを見つける
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)  
      rect,picture = set_character_face 1,26,1 #トテッポ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3066 #バーダック セリパを見つける
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)  
      rect,picture = set_character_face 1,25,1 #セリパ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3067 #バーダック バンブーキンを見つける
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)  
      rect,picture = set_character_face 1,27,1 #バンブーキン
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3068 #バーダック惑星ミートに到着
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*31, 64, 64) # 惑星戦士1
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*32, 64, 64) # 惑星戦士2
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*33, 64, 64) # 惑星戦士3
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*34, 64, 64) # 惑星戦士4
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 3071 #惑星戦士たちを戦闘
      set_battle_event
    when 3081 #惑星戦士たちを戦闘後
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*31, 64, 64) # 惑星戦士1
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*34, 64, 64) # 惑星戦士4
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
    when 3082 #惑星戦士たちを戦闘後 悟空
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3083 #惑星戦士たちを戦闘後 悟空とベジータ
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*12, 64, 64) # ベジータ
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 3084 #惑星戦士たち撃破
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3085 #惑星戦士たちドドリア登場
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@ene1_x,@ene1_y-0,picture,rect)
    when 3086 #惑星戦士たちドドリア登場 バーダックやられる
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@ene1_x,@ene1_y-0,picture,rect)
    when 3087 #バーダック起き上がる前

    when 3088 #バーダック起き上がる
      rect,picture = set_character_face 1,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3091 #悟空宇宙船に乗せられる
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*1, 64, 64) # ロンメ
      add_chr(@ene1_x,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ネイブル
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@play_x-32,@play_y,picture,rect)
    when 3092 #悟空宇宙船に乗せられる
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*1, 64, 64) # ロンメ
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ネイブル
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@ene1_x,@ene1_y-0,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*7, 64, 64) # 宇宙船
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
    when 3093 #フリーザ一味 ドドリア帰還
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@play_x-32,@play_y,picture,rect)
    when 3094 #フリーザ一味 ドドリア帰還
      picture = "Z2_背景_宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@play_x-32,@play_y,picture,rect)
    when 3095 #バーダックと宇宙船
      picture = "Z3_背景_宇宙_フリーザ宇宙船"
      rect = Rect.new(340, 0, 192, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3101 #バーダックと宇宙船並ぶ
      picture = "Z2_背景_宇宙船並ぶ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@z1_scenex-64,@z1_sceney+32,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@z1_scenex+192,@z1_sceney+32,picture,rect)
    when 3102 #バーダックと宇宙船未来1
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # ゴクウ子ども
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
    when 3103 #バーダックと宇宙船未来2
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*20, 64, 64) # ゴクウ大人
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
    when 3104 #バーダックと宇宙船未来3
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
    when 3111 #バーダック惑星ベジータ到着
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@ene1_x,@ene1_y-0,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*7, 64, 64) # 宇宙船
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
    when 3112 #バーダック惑星ベジータ到着惑星戦士気付く
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*4, 64, 64) # ネイブル
      add_chr(@play_x,@play_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@ene1_x,@ene1_y-0,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*7, 64, 64) # 宇宙船
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
    when 3113 #バーダック惑星ベジータ到着地球
      picture = "Z2_背景_地球"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3114 #バーダック惑星惑星ベジータ爆発
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_背景_惑星ベジータ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
    when 3115 #バーダック惑星惑星ベジータ爆発
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3116 #バーダック惑星ベジータ到着バーダック走る
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*4, 64, 64) # ネイブル
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*7, 64, 64) # 宇宙船
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
    when 3117 #バーダック　通路
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3118 #バーダック意識、悟空とじいちゃん
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(1*64, 64*24, 64, 64) # じいちゃん
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3119 #バーダック意識、悟空とブルマ
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # ゴクウ子ども
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*16, 64, 64) # ブルマ子ども
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3120 #バーダック意識、悟空とクリリン亀仙人
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # ゴクウ子ども
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*17, 64, 64) # クリリン子ども
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*18, 64, 64) # 亀仙人
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 3121 #バーダック意識、悟空とピッコロ大魔王
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # ゴクウ子ども
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(1*64, 64*114, 64, 64) # ピッコロ大魔王
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3122 #バーダック意識、悟空とポポ
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # ゴクウ子ども
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(1*64, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3123 #バーダック意識、悟空大人とマジュニア
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*20, 64, 64) # ゴクウ大人
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*19, 64, 64) # マジュニア
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3124 #バーダックと宇宙船未来1
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # ゴクウ子ども
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
    when 3125 #バーダックと宇宙船未来2
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*20, 64, 64) # ゴクウ大人
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
    when 3126 #バーダックと宇宙船未来3
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z1_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
    when 3127 #バーダック
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3128 #バーダック
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3141 #バーダック酒場
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*21, 64, 64) # サイヤ人女
      add_chr(@ene1_x+32,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # サイヤ人男1
      add_chr(@ene1_x-96,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*23, 64, 64) # サイヤ人男2
      add_chr(@ene1_x+96,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # サイヤ人男3
      add_chr(@ene1_x-32,@ene1_y-0,picture,rect)
    when 3142 #バーダック酒場
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*21, 64, 64) # サイヤ人女
      add_chr(@ene1_x+32,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # サイヤ人男1
      add_chr(@ene1_x-96,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*23, 64, 64) # サイヤ人男2
      add_chr(@ene1_x+96,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # サイヤ人男3
      add_chr(@ene1_x-32,@ene1_y-0,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3143 #バーダック酒場 笑う
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*(21+4), 64, 64) # サイヤ人女
      add_chr(@ene1_x+32,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*(22+4), 64, 64) # サイヤ人男1
      add_chr(@ene1_x-96,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*(23+4), 64, 64) # サイヤ人男2
      add_chr(@ene1_x+96,@ene1_y-0,picture,rect)
      rect = Rect.new(0, 64*(24+4), 64, 64) # サイヤ人男3
      add_chr(@ene1_x-32,@ene1_y-0,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3151 #バーダック
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3152 #バーダック ナメック星で悟空
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x+0,@ene1_y-0,picture,rect)
    when 3153 #バーダック ナメック星で悟空
      picture = "Z2_背景_ナメック星_地上"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3154 #フリーザ一味 惑星ベジータを見る
      picture = "Z2_背景_惑星ベジータ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@play_x+32,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@play_x-32,@play_y+64,picture,rect)
   when 3161 #フリーザ一味
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@play_x-32,@play_y,picture,rect)
    when 3162 #バーダック
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3163 #バーダックとフリーザ
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_背景_フリーザ"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
    when 3164 #バーダックとフリーザ(デスボール)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z2_背景_フリーザ_デスボール"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
    when 3171 #バーダックとフリーザ戦闘
      set_battle_event
    when 3181 #バーダック負ける
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # バーダック
      add_chr(@play_x,@play_y,picture,rect)
    when 3182 #バーダック負ける 悟空とフリーザ
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # バーダック
      add_chr(@play_x,@play_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 3183 #バーダック負ける笑う
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*30, 64, 64) # バーダック笑う
      add_chr(@play_x,@play_y,picture,rect)
    when 3184 #バーダック惑星惑星ベジータ爆発
      picture = "Z2_背景_惑星ベジータ"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
    when 3185 #フリーザ一味
      picture = "Z2_背景_フリーザ_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@play_x-32,@play_y,picture,rect)
    when 3186 #悟空赤ちゃん
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3187 #ベジータ対サイバイマン激は
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # ベジータ子ども
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 3188 #バーダック意識、悟空とじいちゃん
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(1*64, 64*24, 64, 64) # じいちゃん
      add_chr(@play_x,@play_y,picture,rect)
################################################################################
#
# Z3
#
################################################################################
    when 1001 #あらすじ
      #FC原作では草原だったが雪山に変更する
      #picture = "Z3_背景_草原"
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      #picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      #add_chr(@play_x+48,@play_y,picture,rect)
      #rect = Rect.new(0, 64*29, 64, 64) # トランクス
      #add_chr(@play_x-48,@play_y,picture,rect)
      
      #picture = "Z3_背景_タイムマシンp2"
      #rect = Rect.new(0, 0, 128, 128) # タイムマシン
      #add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      #picture = "Z3_顔味方"
      #rect = Rect.new(0, 64*14, 64, 64) # 味方顔
      #add_chr(@play_x,@play_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1002 #あらすじ
      picture = "Z3_背景_宇宙_フリーザ宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1003 #あらすじ
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1004 #あらすじ
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,$partyc[0]-3,1
      add_chr(@ene1_x-200,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,$partyc[1]-3,1
      add_chr(@ene1_x-120,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,$partyc[2]-3,1
      add_chr(@ene1_x-40,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,$partyc[3]-3,1
      add_chr(@ene1_x+40,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,$partyc[4]-3,1
      add_chr(@ene1_x+120,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,$partyc[5]-3,1
      add_chr(@ene1_x+200,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1005 #あらすじ
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1006 #あらすじ
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # 不明
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1007 #あらすじ
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # 19号
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # 20号
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1008 #あらすじ
      picture = "Z3_背景_研究所"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # 20号
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 1009 #あらすじ
      picture = "Z3_背景_研究所"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      $game_variables[41] += 1
    when 1010 #あらすじ
      picture = "Z3_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 1011 #あらすじ
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      if $partyc.size == 2 #悟飯たち以外
        rect,picture = set_character_face 0,$partyc[0]-3,1
        add_chr(@ene1_x-48,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[1]-3,1
        add_chr(@ene1_x+48,@ene1_y,picture,rect)
      else
        rect,picture = set_character_face 0,$partyc[0]-3,1
        add_chr(@ene1_x-80,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[1]-3,1
        add_chr(@ene1_x+0,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[2]-3,1
        add_chr(@ene1_x+80,@ene1_y,picture,rect)
      end
    when 1012 #あらすじ
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      if $partyc.size == 2 #悟飯たち以外
        rect,picture = set_character_face 0,$partyc[0]-3,1
        add_chr(@ene1_x-48,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[1]-3,1
        add_chr(@ene1_x+48,@ene1_y,picture,rect)
      else
        rect,picture = set_character_face 0,$partyc[0]-3,1
        add_chr(@ene1_x-80,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[1]-3,1
        add_chr(@ene1_x+0,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[2]-3,1
        add_chr(@ene1_x+80,@ene1_y,picture,rect)
      end
    when 1013 #あらすじ
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      if $partyc.size == 2 #悟飯たち以外
        rect,picture = set_character_face 0,$partyc[0]-3,1
        add_chr(@ene1_x-48,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[1]-3,1
        add_chr(@ene1_x+48,@ene1_y,picture,rect)
      else
        rect,picture = set_character_face 0,$partyc[0]-3,1
        add_chr(@ene1_x-80,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[1]-3,1
        add_chr(@ene1_x+0,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[2]-3,1
        add_chr(@ene1_x+80,@ene1_y,picture,rect)
      end
    when 1014 #あらすじ
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      if $partyc.size == 2 #悟飯たち以外
        rect,picture = set_character_face 0,$partyc[0]-3,1
        add_chr(@ene1_x-48,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[1]-3,1
        add_chr(@ene1_x+48,@ene1_y,picture,rect)
      else
        rect,picture = set_character_face 0,$partyc[0]-3,1
        add_chr(@ene1_x-80,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[1]-3,1
        add_chr(@ene1_x+0,@ene1_y,picture,rect)
        rect,picture = set_character_face 0,$partyc[2]-3,1
        add_chr(@ene1_x+80,@ene1_y,picture,rect)
      end
    when 1015 #あらすじ
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      character_output
    when 1031 #セルゲーム編開始のあらすじ
      picture = "ZD_セルタイムマシン1"
      rect = Rect.new(0, 0, 128, 128) # セルタイムマシン
      add_chr(@ene1_x-32,@ene1_y-32,picture,rect)
    when 1032 #セルゲーム編開始のあらすじ
      picture = "ZD_セルタイムマシン2"
      rect = Rect.new(0, 0, 128, 128) # セルタイムマシン卵
      add_chr(@ene1_x-32,@ene1_y-32,picture,rect)
    when 1033 #セルゲーム編開始のあらすじ
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*10, 64, 64) # 神様
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*(4-3), 64, 64) #ピッコロ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 1034 #セルゲーム編開始のあらすじ
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1035 #セルゲーム編開始のあらすじ
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # ゴクウ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1036 #セルゲーム編 精神と時の部屋で…
      picture = "Z3_背景_精神と時の部屋"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x - 80,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x + 80,@ene1_y,picture,rect)
    when 1037 #セルゲーム編 忍び寄るセル！
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1038 #無言の戦士16号立つ！！
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1039 #新生ベジータ親子出撃！！
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1040 #悟空と悟飯精神と時の部屋
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(64*1, 64*28, 64, 64) # セル
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,16,1 #ベジータ
      add_chr(@play_x-32,@play_y,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+32,@play_y,picture,rect)
    when 1086 #未来悟飯編あらすじ1
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*24, 64, 64) # 悟空死亡
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1087 #未来悟飯編あらすじ2
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
    when 1088 #未来悟飯編あらすじ2  
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*22, 64, 64) # 悟飯
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 1091 #ブロリー編あらすじ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@play_x+32,@play_y,picture,rect)
    when 1092 #ブロリー編あらすじ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      #rect = Rect.new(64, 64*49, 64, 64) # パラガス
      #add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*48, 64, 64) # 戦闘員
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
    when 1093 #ブロリー編あらすじ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
    when 1094 #ブロリー編あらすじ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 1095 #ブロリー編あらすじ
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-0,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*51, 64, 64) # ブロリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x+64,@play_y+64,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x-64,@play_y+64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x,@play_y+64,picture,rect)
      
    when 1098 #背景とZG全員仲間表示
      character_output_all 0,0,0,26
    when 1099 #背景と仲間表示
      character_output
    when 1100 #背景色表示
      
    when 1101 #Z3オープニング
      all_charecter_recovery #全キャラ回復
      if $super_saiyazin_flag[1] != true
        $partyc = [3]
        $chadead = [false]
        on_super_saiyazin 1
      else
        $partyc = [14]
        $chadead = [false]
      end
      all_charecter_recovery #全キャラ回復
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*1, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1102 #Z3オープニング
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1103 #Z3オープニング
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*31, 64, 64) # ポルンガ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1104 #Z3オープニング
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,11,1 #超悟空
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*1, 64, 64) # フリーザ
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1105 #Z3オープニング
      Graphics.fadeout(0)
      picture = "Z3_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*16, 64, 64) # シェンロン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*31, 64, 64) # ポルンガ
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 1106 #Z3オープニング
      picture = "Z3_背景_ナメック星崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,11,1 #超悟空
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*1, 64, 64) # フリーザ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1107 #フリーザ戦闘()
      battle_process (event_no)
    when 1151 #Z3オープニング
      picture = "Z3_背景_ナメック星崩壊"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,11,1 #超悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1152 #Z3オープニング
      picture = "Z3_背景_宇宙船_内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,11,1 #超悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1153 #Z3オープニング
      picture = "Z3_背景_宇宙"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*1, 64, 64) # フリーザ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1154 #Z3オープニング
      picture = "Z3_背景_宇宙"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1155 #Z3オープニング
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output
      $game_variables[41] += 1
      Graphics.fadein(30)
    when 1156 #Z3オープニング
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*2, 64, 64) # ゴハン
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1157 #Z3オープニング
      picture = "Z3_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
      $game_variables[41] += 1
    when 1158 #Z3オープニング
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*2, 64, 64) # ゴハン
      add_chr(@play_x-96,@play_y,picture,rect)
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x-0,@play_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x+96,@play_y,picture,rect)
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      
      cha_tec_puls 101,0,3,150 #技使用回数増加 衝撃は
      cha_tec_puls 102,0,3,100 #技使用回数増加 ビーム
      cha_tec_puls 103,0,3,80 #技使用回数増加 気功スラッガー
      cha_tec_puls 104,0,3,50 #技使用回数増加 超気功スラッガー
      cha_tec_puls 225,0,3,120 #技使用回数増加 残像拳
      cha_tec_puls 226,0,3,90 #技使用回数増加 元祖かめはめは
      cha_tec_puls 228,0,3,60 #技使用回数増加 萬國驚天掌
      cha_tec_puls 229,0,3,25 #技使用回数増加 MAXパワーかめはめは
      #character_output
    when 1591 #ウミガメ
      picture = "顔カード"
      rect = Rect.new(0, 64*49, 64, 64) # ウミガメ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 
    when 1160 #最初の街
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "顔カード"
      #rect = Rect.new(128, 64*25, 64, 64) # 界王様
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1161 #オジサン
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "顔カード"
      #rect = Rect.new(128, 64*25, 64, 64) # 界王様
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1162 #少年
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 少年
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1163 #謎の男
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*2, 64, 64) # 謎の男
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1164 #薬剤師
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*4, 64, 64) # 薬剤師
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1170 #洞窟
      picture = "Z3_背景_洞窟"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*4, 64, 64) # 薬剤師
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1171 #洞窟(ドラゴンボール取得)
      picture = "Z3_背景_洞窟"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*1, 64, 64) # 1
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1180 #オジサン
      picture = "Z3_背景_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # オジサン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1181 #恐竜
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*3, 64, 64) # オジサン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1182 #ダイナマイト設置場所
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*1, 64, 64) # 少年
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1183 #門番少年　Ｚ戦士出力なし
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 少年
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1185 #ダイナマイト　謎のオジサン
      picture = "Z3_背景_洞窟"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*2, 64, 64) # 謎の男
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1190 #門番少年
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*1, 64, 64) # 少年
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1195 #最初の敵の基地
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "Z3_顔敵"
      #rect = Rect.new(0, 64*15, 64, 64) # 少年
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1196 #最初の敵の基地(敵出現)
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*31, 64, 64) # 少年
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1197 #最初の敵の基地_戦闘
      battle_process (event_no)
    when 1200 #最初の敵の基地(ドラゴンボール)
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*2, 64, 64) # 2
      add_chr(@ene1_x-144,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*3, 64, 64) # 3
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*4, 64, 64) # 4
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*6, 64, 64) # 6
      add_chr(@ene1_x+144,@ene1_y,picture,rect)
      character_output
    when 1201 #雪山
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output
    when 1202,1210,1211,1212,1213 #雪山とキャラクター
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1215 #雪山の敵の基地(敵出現)
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*5, 64, 64) # イール
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1216 #雪山の敵の基地_戦闘
      battle_process (event_no)
    when 1217 #雪山の敵の基地_戦闘後
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1218 #雪山の敵の基地(戦闘後ゴハンたち到着)
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1219 #雪山の敵の基地(戦闘後ゴハンたち到着、ベジータ去る)
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1220 #カプセルコーポレーション、ポルンガ呼ぶ前
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*5, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*30, 64, 64) # ムーリー
      add_chr(@ene1_x-96,@ene1_y,picture,rect)

      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      character_output
############################################################
    #魔凶星編
############################################################
    when 1440 #ピッコロ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1441 #ピッコロと神
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*10, 64, 64) # 神様
      add_chr(@play_x,@play_y,picture,rect)
    when 1442 #神
      picture = "顔カード"
      rect = Rect.new(128, 64*10, 64, 64) # 神様
      add_chr(@play_x,@play_y,picture,rect)
   when 1443 #神殿とポポ
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x,@play_y,picture,rect)
   when 1444 #神殿とポポとガーリックJr
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*81, 64, 64) # ガーリックjr
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1445 #神殿とポポとガーリックJrと四天王
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*81, 64, 64) # ガーリックjr
      add_chr(@ene1_x,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*77, 64, 64) # ガッシュ
      add_chr(@ene1_x-96,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*78, 64, 64) # タード
      add_chr(@ene1_x-32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*79, 64, 64) # ビネガー
      add_chr(@ene1_x+32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*80, 64, 64) # ゾルド
      add_chr(@ene1_x+96,@ene1_y+32,picture,rect)
    when 1446 #カメハウス
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x-64,@ene1_y-32,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@ene1_x-128,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*21, 64, 64) # 亀仙人
      add_chr(@ene1_x-128,@ene1_y+32,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*49, 64, 64) # ウミガメ
      add_chr(@ene1_x-64,@ene1_y+32,picture,rect)
      
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@ene1_x+128,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ヤムチャ
      add_chr(@ene1_x+64,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # チャオズ
      add_chr(@ene1_x+128,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@ene1_x+64,@ene1_y+32,picture,rect)
    when 1447 #カメハウスピッコロ到着
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x-64,@ene1_y-32,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@ene1_x-128,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*21, 64, 64) # 亀仙人
      add_chr(@ene1_x-128,@ene1_y+32,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*49, 64, 64) # ウミガメ
      add_chr(@ene1_x-64,@ene1_y+32,picture,rect)
      
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@ene1_x+128,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ヤムチャ
      add_chr(@ene1_x+64,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # チャオズ
      add_chr(@ene1_x+128,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@ene1_x+64,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x,@play_y,picture,rect)
      
    when 1471 #ガッシュ戦闘前
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*77, 64, 64) # ガッシュ
      add_chr(@ene1_x-0,@ene1_y+0,picture,rect)
      character_output
    when 1472 #ガッシュ戦闘
      battle_process (event_no)
      
    when 1481 #ガッシュ撃破
      character_output     
    when 1491 #ビネガー戦闘前
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*79, 64, 64) # ビネガー
      add_chr(@ene1_x-0,@ene1_y+0,picture,rect)
      character_output
    when 1492 #ビネガー戦闘
      battle_process (event_no)
      
    when 1501 #ビネガー撃破
      character_output     
    when 1511 #ゾルド戦闘前
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*80, 64, 64) # ゾルド
      add_chr(@ene1_x-0,@ene1_y+0,picture,rect)
      character_output
    when 1512 #ゾルド戦闘
      battle_process (event_no)
      
    when 1521 #ゾルド撃破
      character_output
    when 1522 #ピッコロ
      character_output
    when 1523 #ピッコロとベジータ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1531 #タード戦闘前
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*78, 64, 64) # タード
      add_chr(@ene1_x-0,@ene1_y+0,picture,rect)
      character_output
    when 1532 #タード戦闘
      battle_process (event_no)
      
    when 1541 #タード撃破
      character_output
 
    when 1542 #Z戦士たち
      character_output
      
    when 1583 #ヤジロベー
      picture = "顔カード"
      rect = Rect.new(2*64, 64*23, 64, 64) #ヤジロベー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output  
    when 1551 #神の神殿
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1552 #神の神殿(ガーリック
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*81, 64, 64) # ガーリックjr
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1553 #神の神殿(ガーリック、ジンジャー
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*81, 64, 64) # ガーリックjr
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*86, 64, 64) #ジンジャー
      add_chr(@ene1_x-64,@ene1_y-64,picture,rect)
      #rect = Rect.new(0, 64*87, 64, 64) #ニッキー
      #add_chr(@ene1_x,@ene1_y-64,picture,rect)
      #rect = Rect.new(0, 64*88, 64, 64) #サンショ
      #add_chr(@ene1_x+64,@ene1_y-64,picture,rect)
    when 1554 #神の神殿(ガーリック、ジンジャー、ニッキー
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*81, 64, 64) # ガーリックjr
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*86, 64, 64) #ジンジャー
      add_chr(@ene1_x-64,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*87, 64, 64) #ニッキー
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      #rect = Rect.new(0, 64*88, 64, 64) #サンショ
      #add_chr(@ene1_x+64,@ene1_y-64,picture,rect)
    when 1555 #神の神殿(ガーリック、ジンジャー、ニッキー、サンショ
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*81, 64, 64) # ガーリックjr
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*86, 64, 64) #ジンジャー
      add_chr(@ene1_x-64,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*87, 64, 64) #ニッキー
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*88, 64, 64) #サンショ
      add_chr(@ene1_x+64,@ene1_y-64,picture,rect)
    when 1556 #ガーリック戦闘
      battle_process (event_no)
      
    when 1561 #神の神殿(ガーリック
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*81, 64, 64) # ガーリックjr
      add_chr(@ene1_x,@ene1_y,picture,rect)

    when 1562 #神の神殿(ガーリック
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*82, 64, 64) # ガーリック(巨大化)
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1563 #神の神殿(ガーリック魔族四天王
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*82, 64, 64) # ガーリック
      add_chr(@ene1_x,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*77, 64, 64) # ガッシュ
      add_chr(@ene1_x-96,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*78, 64, 64) # タード
      add_chr(@ene1_x-32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*79, 64, 64) # ビネガー
      add_chr(@ene1_x+32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*80, 64, 64) # ゾルド
      add_chr(@ene1_x+96,@ene1_y+32,picture,rect)
    when 1564 #神の神殿(ガーリック魔族四天王
      picture = "Z3_背景_魔凶星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*82, 64, 64) # ガーリック
      add_chr(@ene1_x,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*77, 64, 64) # ガッシュ
      add_chr(@ene1_x-96,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*78, 64, 64) # タード
      add_chr(@ene1_x-32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*79, 64, 64) # ビネガー
      add_chr(@ene1_x+32,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*80, 64, 64) # ゾルド
      add_chr(@ene1_x+96,@ene1_y+32,picture,rect)
    when 1565 #ガーリック戦闘
      battle_process (event_no)
    when 1566 #神の神殿(ガーリック魔族四天王
      picture = "Z3_背景_魔凶星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 1571 #神の神殿(神様、ポポ
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      picture = "顔カード"
      rect = Rect.new(128, 64*10, 64, 64) # 神様
      add_chr(@ene1_x-48,@ene1_y,picture,rect)

      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 1230 #ポルンガイベント終了後草原
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output
      #$game_variables[41] += 1
      #Graphics.fadein(30)      
    when 1231 #ポルンガイベント終了後草原に悟飯
      picture = "Z3_背景_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1232 #ポルンガイベント終了後草原に悟飯味方クリリン
      picture = "ZG_背景_亀仙人の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1233 #界王星界王様
      picture = "Z3_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1234 #フリーザ宇宙船
      picture = "Z3_背景_宇宙_フリーザ宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*2, 64, 64) # フリーザサイボーグ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*6, 64, 64) # コルド
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 1235 #草原フリーザ親子
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*2, 64, 64) # フリーザサイボーグ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*6, 64, 64) # コルド
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 1236 #草原フリーザ親子とＺ戦士
      all_charecter_recovery
      $partyc = [4,12,5,6,7,8,9]
      $chadead =  [false,false,false,false,false,false,false]
      all_charecter_recovery
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*2, 64, 64) # フリーザサイボーグ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*6, 64, 64) # コルド
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      character_output
    when 1237 #フリーザサイボーグ戦闘
      battle_process (event_no)
    when 1240 #Ｚ戦士とフリーザサイボーグ戦終了後
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*2, 64, 64) # フリーザサイボーグ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*6, 64, 64) # コルド
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      character_output
    when 1241
      set_battle_event
    when 1246 #トランクスとフリーザサイボーグ戦終了後
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*6, 64, 64) # コルド
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1247
      picture = "Z3_コルド撃破_修正"
      rect = Rect.new(0, 0*222, 640, 222) # 背景
      y_iti = 129
      add_chr(0,y_iti,picture,rect)
      Graphics.update
      Graphics.wait(60)
      Audio.se_play("Audio/SE/" + "Z3 トランクスエネルギー波")# 効果音を再生する
      
      picture = "z2op/z2_op_001"
      color = Color.new(255,255,255,256)
      rect = Rect.new(0, 0, 960, 720)
      add_chr(0,0,picture,rect)
      @chr_sprite[1].bitmap.fill_rect(0,0,960,720,color)
      Graphics.update
      Graphics.wait(30)
      @chr_sprite[1].visible = false
      
      for x in 0..14
        @chr_sprite[0].src_rect = Rect.new(0, 1*222, 640, 222)
        Graphics.update
        Graphics.wait(8)
        @chr_sprite[0].src_rect = Rect.new(0, 2*222, 640, 222)
        Graphics.update
        Graphics.wait(8)
      end
      Audio.se_stop
    when 1248
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1249
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x,@ene1_y,picture,rect)
      all_charecter_recovery
      $partyc = [4,12,5,6,7,8,9]
      $chadead =  [false,false,false,false,false,false,false]
      all_charecter_recovery
      character_output
    when 1250
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # ゴクウ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*7, 64, 64) # 宇宙船
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      character_output
    when 1251
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*7, 64, 64) # 宇宙船
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # ゴクウ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      character_output
    when 1252
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $partyc = [3]
      $chadead =  [false]
      character_output
    when 1255
      
      set_battle_event
    when 1256
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*17, 64, 64) # トランクス
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1257
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1258
      picture = "Z3_背景_人造人間"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1259 #タイムマシン発進
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      cha_tec_puls 2,0,3,70 #技使用回数増加
      cha_tec_puls 5,0,3,50
      cha_tec_puls 6,0,3,40
      cha_tec_puls 7,0,3,30
      cha_tec_puls 18,0,3,25
      cha_tec_puls 19,0,3,20
      cha_tec_puls 26,0,3,20
      cha_tec_puls 29,0,3,15
    when 1260
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output
    when 1261
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # ゴクウ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      $partyc = [4,12,5,6,7,8,9]
      $chadead =  [false,false,false,false,false,false,false]
      character_output
    when 1262
      picture = "Z3_背景_宇宙"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 1263
      picture = "Z3_背景_宇宙_フリーザ宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*19, 64, 64) # サウザー
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*16, 64, 64) # ドーレ
      add_chr(@play_x-64,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ネイズ
      add_chr(@play_x+64,@play_y+64,picture,rect)
    when 1264
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1265
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*36, 64, 64) # ブリーフ博士
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1266
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*36, 64, 64) # ブリーフ博士
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1270
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*8, 64, 64) # ジーア
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1271
      battle_process (event_no)
    when 1272
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*32, 64, 64) # ピラール
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1273
      battle_process (event_no)
    when 1274
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1275  
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*36, 64, 64) # ブリーフ博士
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 1276
      picture = "Z3_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1280
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1281 #救出指示村人
      picture = "Z3_背景_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # おじさん
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1282 #救出A
      picture = "Z3_背景_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      if $game_switches[422] == true
        picture = "Z3_顔イベント"
        rect = Rect.new(0, 64*0, 64, 64) # おじさん
        add_chr(@ene1_x-96,@ene1_y,picture,rect)
        rect = Rect.new(0, 64*2, 64, 64) # 謎の男
        add_chr(@ene1_x+96,@ene1_y,picture,rect)
      end
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*8, 64, 64) # ジーア
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1283
      battle_process (event_no)
    when 1284,1287,1290 #救出後A
      picture = "Z3_背景_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # おじさん
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 謎の男
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*1, 64, 64) # 少年
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      character_output
    when 1285 #救出B
      picture = "Z3_背景_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      if $game_switches[422] == true
        picture = "Z3_顔イベント"
        rect = Rect.new(0, 64*0, 64, 64) # おじさん
        add_chr(@ene1_x-96,@ene1_y,picture,rect)
        rect = Rect.new(0, 64*2, 64, 64) # 謎の男
        add_chr(@ene1_x+96,@ene1_y,picture,rect)
      end
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*5, 64, 64) # イール
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1286
      battle_process (event_no)
    when 1288 #救出C
      picture = "Z3_背景_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      if $game_switches[422] == true
        picture = "Z3_顔イベント"
        rect = Rect.new(0, 64*0, 64, 64) # おじさん
        add_chr(@ene1_x-96,@ene1_y,picture,rect)
        rect = Rect.new(0, 64*2, 64, 64) # 謎の男
        add_chr(@ene1_x+96,@ene1_y,picture,rect)
      end
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*10, 64, 64) # キース
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1289
      battle_process (event_no)
    when 1295 #カイズ戦闘前
      picture = "Z3_背景_森"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*33, 64, 64) # カイズ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1296 #カイズ
      battle_process (event_no)
    when 1297 #カイズ戦闘後
      picture = "Z3_背景_森"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1298 #ブルマ救出基地
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1299 #ブルマ救出基地
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*5, 64, 64) # ブルマ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)    
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      character_output
    when 1300 #ブルマ救出基地
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*5, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1301,1303,1305,1311 #悟空たち修行
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1302,1304,1306 #悟空たち修行開始
      $scene = Scene_Db_Ryuha_Pair_Training.new
    when 1307,1309 #ベジータ修行 
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1308 #ベジータ修行開始
       $scene = Scene_Db_Z3_Gravity_Training.new
    when 1310 #クウラ到着
      color = set_skn_color 0
      picture = "z2op/z2_op_001"
      rect = Rect.new(0, 0, 640, 480)
      add_chr(0,0,picture,rect)
      @chr_sprite[0].bitmap.fill_rect(0,0,640,480,color)
      for x in 0..160
        rect = Rect.new(0+x*2, 0, 512, 128) # スクロール背景
        if x == 0
          picture = "Z3_背景_宇宙_フリーザ宇宙船"
          add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
        else
          @chr_sprite[1].src_rect = rect
        end
        Graphics.update
        #if x != 160
          #clear_chr
        #end
      end
    when 1312 #ヤムチャたち合流
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*(6-3), 64, 64)
      add_chr(@ene1_x-144,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*(7-3), 64, 64)
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*(8-3), 64, 64)
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*(9-3), 64, 64)
      add_chr(@ene1_x+144,@ene1_y,picture,rect)
      character_output
    when 1313 #亀背人、チチ合流
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      character_output
    when 1314 #亀背人、チチ合流(亀仙人を選択)
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1315 #亀背人、チチ合流(チチを選択)
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1431 #ドラゴンボール見つけた
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      # ドラゴンボールの表示を変数にて可変にする
      picture = "顔カード"
      rect = Rect.new(64*2, 64*$game_variables[240], 64, 64) 
      add_chr(@ene1_x,@ene1_y,picture,rect)

    when 1432 #ドラゴンボール全部見つけたかチェック
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      
      #ドラゴンボールを全部見つけたかチェック
      if $game_party.has_item?($data_items[2]) == true &&
      $game_party.has_item?($data_items[3]) == true &&
      $game_party.has_item?($data_items[4]) == true &&
      $game_party.has_item?($data_items[5]) == true &&
      $game_party.has_item?($data_items[6]) == true &&
      $game_party.has_item?($data_items[7]) == true &&
      $game_party.has_item?($data_items[8]) == true
      
       $game_switches[446] = true
      
      end
    when 1433 #シェンロン呼ぶ
      picture = "Z3_シェンロン呼び出し"
      rect = Rect.new(640*0, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(16)
      rect = Rect.new(640*1, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(16)
      rect = Rect.new(640*2, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(16)
      rect = Rect.new(640*3, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(16)
      rect = Rect.new(640*4, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(120)
      clear_chr
      Audio.se_play("Audio/SE/" + "Z3 稲妻")    # 効果音を再生する
      for x in 0..10
        rect = Rect.new(640*5, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        rect = Rect.new(640*6, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        clear_chr
      end
      rect = Rect.new(640*4, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(20)
      Audio.se_play("Audio/SE/" + "Z3 稲妻")    # 効果音を再生する
      for x in 0..10
        rect = Rect.new(640*5, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        rect = Rect.new(640*6, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        clear_chr
      end
      Audio.se_play("Audio/SE/" + "Z3 シェンロン呼び出し")    # 効果音を再生する
      picture2 = "z2op/z2_op_001"
      color = Color.new(255,255,255,256)
      rect = Rect.new(0, 0, 960, 720)
      add_chr(0,0,picture2,rect)
      @chr_sprite[0].bitmap.fill_rect(0,0,960,720,color)
      Graphics.update
      #@chr_sprite[@chr_sprite.size-1].bitmap.fill_rect(0,0,960,720,color)
      #@chr_sprite[0].bitmap.fill_rect(0,0,960,720,color)
      Graphics.update
      Graphics.wait(120)
      for x in 0..22
        rect = Rect.new(640*7, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        rect = Rect.new(640*8, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        clear_chr
      end
    when 1434 #シェンロン呼び出した
      picture = "Z3_背景_暗い砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      #シェンロン表示する
      picture = "顔カード"
      rect = Rect.new(64*2, 64*16, 64, 64) 
      add_chr(@ene1_x,@ene1_y,picture,rect)
      
    when 1581 #ランチ(金髪)
      picture = "顔カード"
      rect = Rect.new(0, 64*34, 64, 64) #ランチ(金髪)
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output  
    when 1316 #クウラの基地到着
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1317 #クウラの基地到着 サウザーたちのみ
      picture = "Z3_背景_基地"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*19, 64, 64) # サウザー
      add_chr(@ene1_x,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*16, 64, 64) # ドーレ
      add_chr(@ene1_x-64,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ネイズ
      add_chr(@ene1_x+64,@ene1_y+32,picture,rect)
      character_output
    when 1318 #サウザーたちと戦闘
      battle_process (event_no)
    when 1319 #クウラ
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1320 #クウラ ベジータ到着
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*(12-3), 64, 64) #ベジータ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      character_output
    when 1321 #クウラ ベジータ変身後
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*(19-3), 64, 64) #超ベジータ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      character_output
    when 1322 #クウラ戦闘
      battle_process (event_no)
    when 1323 #クウラ撃破後変身前
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1324 #クウラ撃破後変身後
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*21, 64, 64) # クウラ(変身)
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1325 #クウラ(変身)戦闘
      battle_process (event_no)
    when 1326 #クウラ(変身)撃破後
      picture = "Z3_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1327 #人造人間
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect) 
      character_output
    when 1328 #人造人間
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*(7-3), 64, 64)
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*(8-3), 64, 64)
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*(9-3), 64, 64)
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス
      add_chr(@ene1_x-64,@ene1_y,picture,rect)  
      character_output
    when 1329 #人造人間 ヤジロベー登場
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*23, 64, 64) # ヤジロベー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+32,@play_y+64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス
      add_chr(@play_x-32,@play_y+64,picture,rect)  
    when 1330 #人造人間 ヤジロベー、スカイカー
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*23, 64, 64) # ヤジロベー
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*8, 64, 64) # スカイカー
      add_chr(@ene1_x+48,@ene1_y,picture,rect)   
      character_output
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+32,@play_y+64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス
      add_chr(@play_x-32,@play_y+64,picture,rect) 
    when 1331 #人造人間
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+32,@play_y+64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス
      add_chr(@play_x-32,@play_y+64,picture,rect)
    when 1335 #悟空心臓病発症
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*1, 64*0, 64, 64) # ゴクウ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1336 #悟空心臓病発症(悟空抜ける)
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1337 #悟空心臓病発症(悟空抜ける)(チチが仲間に)
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1338 #悟空心臓病発症(悟空抜ける)(亀仙人が仲間に)
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1341 #20号発見
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # 19号
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # 20号
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      character_output
    when 1342 #20号19号戦闘
      battle_process (event_no)
    when 1351 #20号、戦闘後、トランクス到着
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x,@ene1_y,picture,rect)
      cha_tec_puls 171,0,3,300 #技使用回数増加
      cha_tec_puls 172,0,3,150
      cha_tec_puls 173,0,3,150
      cha_tec_puls 174,0,3,100
      cha_tec_puls 176,0,3,50
      cha_tec_puls 177,0,3,30
      cha_tec_puls 185,0,3,10
      #character_output
    when 1352 #20号、逃亡前
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*22, 64, 64) # 20号
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      character_output
    when 1353 #20号、逃亡後
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1354 #20号、戦闘後、トランクス合流
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1356 #研究所到着
      picture = "Z3_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1357 #研究所内部
      picture = "Z3_背景_研究所"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # 20号
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 1358 #研究所内部(20号死亡)
      picture = "Z3_背景_研究所"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*0, 64, 64) # 20号
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 1582 #ウーロン
      picture = "顔カード"
      rect = Rect.new(2*64, 64*20, 64, 64) #ウーロン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output  
    when 1359,1362,1371,1376,1381 #研究所破壊(16号復活)、17号たち発見Ｚ戦士合流
      picture = "Z3_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      character_output
    when 1361 #17号たち発見
      picture = "Z3_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 1363,1372 #17号18号戦闘、16号戦闘
      battle_process (event_no)
    when 1382 #17号たち戦闘後山
      picture = "Z3_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 1383 #神様の神殿
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*10, 64, 64) # 神様
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*(4-3), 64, 64) #ピッコロ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      #character_output
    when 1384 #神様とピッコロ融合
      cha_tec_puls 31,0,3,30 #技使用回数増加
      cha_tec_puls 33,0,3,25
      cha_tec_puls 34,0,3,20
      cha_tec_puls 35,0,3,15
      cha_tec_puls 36,0,3,10
      #ピッコロがスキル神と融合を覚える
      set_typical_skill 4,0,249
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*10, 64, 64) # 神様
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*(4-3), 64, 64) #ピッコロ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      @chr_sprite[2].visible = false
      tone_num = 0
      tone_num -= 85
      @tone_target = Tone.new(tone_num, tone_num, tone_num, 0)
      
      
      @chr_sprite[0].tone = @tone_target
      Graphics.update
      Graphics.wait(20)
      tone_num -= 85
      @tone_target = Tone.new(tone_num, tone_num, tone_num, 0)
      @chr_sprite[0].tone = @tone_target
      Graphics.update
      Graphics.wait(20)
      tone_num -= 85
      @tone_target = Tone.new(tone_num, tone_num, tone_num, 0)
      @chr_sprite[0].tone = @tone_target
      Graphics.update
      Graphics.wait(20)
      
      for x in 0..31
        @chr_sprite[1].x += 2 
        @chr_sprite[3].x -= 2
        #x += 1
        Graphics.update
        Graphics.wait(2)
        @chr_sprite[1].opacity -= 5
        @chr_sprite[3].opacity -= 5
        
      end
      
      #@chr_sprite[1].opacity = 255
      @chr_sprite[3].opacity = 255
      
    when 1385 #融合後気溜め
      
      picture = "Z3_スーパーサイヤ人_バック"
      rect = Rect.new(0,0, 640, 224) #気
      add_chr(0,0,picture,rect)
      @chr_sprite[0].zoom_y = 2.5
      
      ki_tyousei_x=-48
      ki_tyousei_y=0
      back_anime_type = 0
      back_anime_frame = 0
      
      picture = "Z3_戦闘_ピッコロ"
      ki_anino = 0
      rect = Rect.new(0,0, 96, 96) #ピッコロ
      add_chr(@ene1_x+ki_tyousei_x+32,@ene1_y+ki_tyousei_y+32,picture,rect)      
      @chr_sprite[1].z = 255
      
      picture = "Z3_戦闘_必殺技_気を溜める(青)"
      rect = Rect.new(136*back_anime_type,0, 136, 142) #気
      add_chr(@ene1_x+ki_tyousei_x,@ene1_y+ki_tyousei_y,picture,rect)
      @chr_sprite[2].z = 254
      
      picture = "Z3_味方カットイン"
      ki_anino = 0
      rect = Rect.new(0,1*64,640, 64) #カットイン
      add_chr(0,480-192,picture,rect)
      
      for x in 1..120
      
        if back_anime_frame >= 4  && back_anime_type != 1
          back_anime_type += 1
          back_anime_frame = 0
        elsif back_anime_frame >= 4
          back_anime_type = 0
          back_anime_frame = 0
        end
        back_anime_frame += 1
        Graphics.update
        Graphics.wait(2)
        @chr_sprite[2].src_rect = Rect.new(136*back_anime_type,0, 136, 142)
      end
      
    when 1386 #カットインセンター
      
      picture = "Z3_スーパーサイヤ人_バック"
      rect = Rect.new(0,0, 640, 224) #気
      add_chr(0,0,picture,rect)
      @chr_sprite[0].zoom_y = 2.5
      
      picture = "Z3_味方カットイン"
      ki_anino = 0
      rect = Rect.new(0,1*64,640, 64) #カットイン
      add_chr(0,(480-192)/2+16,picture,rect)
      
    when 1387 #融合完了
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1388 #セル探索
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      character_output
    when 1389 #セル発見
      picture = "Z3_スーパーサイヤ人_バック"
      rect = Rect.new(0,0, 640, 224) #気
      add_chr(0,0,picture,rect)
      @chr_sprite[0].zoom_y = 2.5
      
      picture = "ZD_セル登場"
      rect = Rect.new(0,0, 208, 224) #セル
      add_chr(216,480-(178+224-50),picture,rect)
    when 1390 #セル戦闘
      battle_process (event_no)
    when 1401 #セル発見、戦闘後
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 1402 #セル太陽拳準備
      picture = "Z3_スーパーサイヤ人_バック"
      rect = Rect.new(0,0, 640, 224) #気
      add_chr(0,0,picture,rect)
      @chr_sprite[0].zoom_y = 2.5
      
      picture = "Z3_戦闘_必殺技_背景_上(茶)"
      rect = Rect.new(0,0, 640, 110) #必殺技線上
      add_chr(0,0,picture,rect)
      
      picture = "Z3_戦闘_必殺技_背景_下(加工)(茶)"
      rect = Rect.new(0,0, 640, 114) #必殺技線下
      add_chr(0,480-(128+114),picture,rect)
      
      picture = "Z3_戦闘_敵_セル(第１形態)"
      rect = Rect.new(0,0, 96, 96) #セル
      add_chr(640,@ene1_y+32,picture,rect)
      
      for x in 0..92
        
        @chr_sprite[3].x -= 4
        Graphics.update
        #Graphics.wait(1)
      end
      
      #p @chr_sprite[3].x
    when 1403
      picture = "Z3_スーパーサイヤ人_バック"
      rect = Rect.new(0,0, 640, 224) #気
      add_chr(0,0,picture,rect)
      @chr_sprite[0].zoom_y = 2.5
      
      picture = "Z3_戦闘_必殺技_背景_上(茶)"
      rect = Rect.new(0,0, 640, 110) #必殺技線上
      add_chr(0,0,picture,rect)
      
      picture = "Z3_戦闘_必殺技_背景_下(加工)(茶)"
      rect = Rect.new(0,0, 640, 114) #必殺技線下
      add_chr(0,480-(128+114),picture,rect)
      
      picture = "Z3_戦闘_敵_セル(第１形態)"
      rect = Rect.new(0,0, 96, 96) #セル
      add_chr(268,@ene1_y+32,picture,rect)
      
      picture = "Z3_必殺技_カットイン_太陽拳(セル第１形態)"
      rect = Rect.new(0,0, 640, 64) #セル
      add_chr(-648,@ene1_y+32+32,picture,rect)      
      
      for x in 0..53
        @chr_sprite[3].x += 16
        @chr_sprite[4].x += 12
        Graphics.update
        #Graphics.wait(1)
      end
    when 1404
      picture = "Z3_スーパーサイヤ人_バック"
      rect = Rect.new(0,0, 640, 224) #気
      add_chr(0,0,picture,rect)
      @chr_sprite[0].zoom_y = 2.5
      
      picture = "Z3_戦闘_必殺技_背景_上(茶)"
      rect = Rect.new(0,0, 640, 110) #必殺技線上
      add_chr(0,0,picture,rect)
      
      picture = "Z3_戦闘_必殺技_背景_下(加工)(茶)"
      rect = Rect.new(0,0, 640, 114) #必殺技線下
      add_chr(0,480-(128+114),picture,rect)
      
      picture = "Z3_戦闘_敵_セル(第１形態)"
      rect = Rect.new(0,0, 96, 96) #セル
      add_chr(640,@ene1_y+32,picture,rect)
      
      picture = "Z3_必殺技_カットイン_太陽拳(セル第１形態)"
      rect = Rect.new(0,0, 640, 64) #セル
      add_chr(0,@ene1_y+32+32,picture,rect)      
      
      picture = "Z3_スーパーサイヤ人_バック"
      rect = Rect.new(0,0, 640, 224) #気
      add_chr(0,0,picture,rect)
      @chr_sprite[5].zoom_y = 2.5
      @chr_sprite[5].opacity = 0
      @tone_target = Tone.new(255, 255, 255, 0)
      @chr_sprite[5].tone = @tone_target
      
      for x in 0..55
        @chr_sprite[5].opacity += 5
        Graphics.update
      end
    when 1405..1410
      sta_event_no = 1405
      
      picture = "Z3_スーパーサイヤ人_バック"
      rect = Rect.new(0,0, 640, 224) #気
      add_chr(0,0,picture,rect)
      @chr_sprite[0].zoom_y = 2.5
      
      picture = "Z3_敵カットイン"
      tyousei_y = 4
      if event_no == sta_event_no
        picture = "Z3_味方カットイン"
        rect = Rect.new(0,1*64+tyousei_y,640, 64-tyousei_y) #ピッコロ
        
      elsif event_no == sta_event_no +1
        rect = Rect.new(0,24*64+tyousei_y, 640, 64-tyousei_y) #17号
      elsif event_no == sta_event_no +2
        rect = Rect.new(0,23*64+tyousei_y, 640, 64-tyousei_y) #18号
      elsif event_no == sta_event_no +3
        rect = Rect.new(0,25*64+tyousei_y, 640, 64-tyousei_y) #16号
      elsif event_no == sta_event_no +4
        rect = Rect.new(0,26*64+tyousei_y, 640, 64-tyousei_y) #セル
      elsif event_no == sta_event_no +5
        picture = "Z3_味方カットイン"
        rect = Rect.new(0,11*64,640, 64) #超悟空
      end
        
        
      add_chr(0,480-192+tyousei_y,picture,rect)
      picture = "Z3_背景_エンディング_セル1"
      rect = Rect.new(0,0,214, 192) #セル
      add_chr(214,480-(192+192-tyousei_y),picture,rect)
    when 1411
      tyousei_y = 4
      
      picture = "Z3_スーパーサイヤ人_バック"
      rect = Rect.new(0,0, 640, 224) #気
      add_chr(0,0,picture,rect)
      @chr_sprite[0].zoom_y = 2.5
      
      picture = "Z3_味方カットイン"
      rect = Rect.new(0,11*64,640, 64) #超悟空
      add_chr(0,480-192+tyousei_y,picture,rect)
      Graphics.wait(180)
    when 1412
      tyousei_y = 4
      
      picture = "Z3_スーパーサイヤ人_バック"
      rect = Rect.new(0,0, 640, 224) #気
      add_chr(0,0,picture,rect)
      @chr_sprite[0].zoom_y = 2.5
      
      picture = "Z3_味方カットイン"
      rect = Rect.new(0,11*64,640, 64) #超悟空
      add_chr(0,480-192+tyousei_y,picture,rect)
      
      picture = "Z3_背景_エンディング_セル2"
      rect = Rect.new(0*178,0,178, 192) #セル
      add_chr(198,480-(192+192-tyousei_y),picture,rect)
      
      for x in 0..3
        @chr_sprite[2].src_rect = Rect.new(178*x,0,178, 192)#セル
        Graphics.update
        Graphics.wait(8)
      end
      Graphics.wait(1)
      @chr_sprite[1].src_rect = Rect.new(640,11*64,640, 64) #超悟空
      Graphics.update
    when 1421 #人造人間居場所
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      $game_variables[307] = rand(3) + 1
      picture = "Z3_顔イベント"
      
      #人造人間方角計算
      
      #横軸
      if $game_variables[1] == $game_variables[308] #横軸一致
        yokoziku = 5
      elsif $game_variables[1] < $game_variables[308] #人造人間東
        yokoziku = 6
      else #人造人間西
        yokoziku = 4
      end
        
      #縦軸
      if $game_variables[2] == $game_variables[309] #縦軸一致
        tateziku = 5
      elsif $game_variables[2] < $game_variables[309] #人造人間南
        tateziku = 2
      else #人造人間北
        tateziku = 8
      end
      
      case yokoziku
        
      when 5
          $game_variables[310] = tateziku #南 or 北
      when 6
        if tateziku == 5
          $game_variables[310] = 6 #東
        elsif tateziku == 2
          $game_variables[310] = 3 #南東
        else
          $game_variables[310] = 9 #北東
        end
      when 4
        if tateziku == 5
          $game_variables[310] = 4 #西
        elsif tateziku == 2
          $game_variables[310] = 1 #南西
        else
          $game_variables[310] = 7 #北西
        end
      end
      
      
      case $game_variables[307]
      
      when 1 #オジサン
        $game_actors[1].name = "オジサン"
        rect = Rect.new(0, 64*0, 64, 64) 
      when 2 #少年
        $game_actors[1].name = "少年"
        rect = Rect.new(0, 64*1, 64, 64) 
      when 3 #オバサン
        $game_actors[1].name = "オバサン"
        rect = Rect.new(0, 64*4, 64, 64)
      end
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output      
################################################################################
#
# Z3 セルゲーム
#
################################################################################
    when 2000 #キャラクターのみ表示
      character_output
    when 2001 #セル編開始 Z戦士たち
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 2002 #セル編開始 セルジンジャータウン
      picture = "ZD_ジンジャータウン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@ene1_x-32,@ene1_y-32,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@play_x,@play_y,picture,rect)
      
    when 2011 #Dr.ゲロ研究所外
      picture = "Z3_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 2012 #Dr.ゲロ研究所内部
      picture = "ZG_背景_宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 2013 #Dr.ゲロ研究所内部_セル幼虫発見
      picture = "ZG_背景_宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*50, 64, 64) # セル幼虫
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      character_output
    when 2014 #Dr.ゲロ研究所外(ウイローたち)
      picture = "Z3_背景_山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # ウィロー
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      
      rect = Rect.new(0, 64*23, 64, 64) # エビフリャー
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # ミソカッツン
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*22, 64, 64) # キシーメ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 2015 #ウィロー戦闘
      battle_process (event_no)
    when 2016,2096 #カプセルコーポレーション
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*36, 64, 64) # ブリーフ博士
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      character_output
    when 2021 #ピッコロ、セルを追いかける
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "Z3_顔敵"
      #rect = Rect.new(0, 64*27, 64, 64) # セル
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 2022,2094 #ピッコロ、セルを追いかける
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output
    when 2023 #カメハウス内TV視聴
      picture = "ZG_背景_亀仙人の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 2024 #飛行機内
      picture = "Z1_背景_スクロール_空"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture ="Z1_イベント_飛行機"
      rect = Rect.new(0, 0, 60, 52) # イベント
      add_chr(@z1_scrollscenex+224,@z1_scrollsceney+24,picture,rect)
      character_output

    when 2031 #悟空復活_カメハウス内 チチ
      picture = "ZG_背景_亀仙人の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2032 #悟空復活_海_チチと悟空
      picture = "Z1_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2033 #悟空復活_海_チチ_亀仙人と悟空
      picture = "Z1_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@play_x+48,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@play_x-48,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2034 #悟空復活起床後_カメハウス内 チチと亀仙人
      picture = "ZG_背景_亀仙人の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 2035 #悟空復活瞬間移動後_カメハウス内 チチと亀仙人
      picture = "ZG_背景_亀仙人の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 2041 #悟空復活後飛行機へ瞬間移動
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 2042 #悟空復活後飛行機へ瞬間移動_ゴハンと瞬間移動前
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      character_output
    when 2051 #悟空復活後トランクスの元へ
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@play_x,@play_y,picture,rect)
    when 2052 #悟空復活後トランクスの元へ到着
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      #character_output
    when 2053 #悟空復活後ベジータの元へ到着
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2054 #悟空復活後17号たち
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 2061 #精神と時の部屋入る前
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
    when 2062 #精神と時の部屋入る前
      picture = "Z3_背景_精神と時の部屋"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 2071 #精神と時の部屋修行
      $scene = Scene_Db_Ryuha_Pair_Training.new
    when 2081 #精神と時の部屋修行後
      picture = "Z1_背景_スクロール_空"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture ="Z1_イベント_飛行機"
      rect = Rect.new(0, 0, 60, 52) # イベント
      add_chr(@z1_scrollscenex+224,@z1_scrollsceney+24,picture,rect)
      character_output
    when 2082 #精神と時の部屋修行後カメハウスでTV
      picture = "ZG_背景_亀仙人の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 2083 #人造人間到着　カメハウス
      picture = "Z1_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      character_output
    when 2084,2095,2097,2112 #人造人間到着　カメハウス
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      character_output
      
    when 2091,2110 #人造人間戦闘前
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      character_output
    when 2092 #ピッコロ17号戦闘開始
      set_battle_event
    when 2093 #人造人間戦闘後
      picture = "Z3_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      character_output
    when 2098 #精神と時の部屋ピッコロと17号戦闘開始後
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
    when 2111 #セル登場
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@play_x+0,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x-96,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+96,@play_y+64,picture,rect)
      character_output
    when 2113 #人造人間到着　カメハウス
      picture = "Z1_背景_カメハウス"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scenex,@z1_sceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2121 #セル登場(天津飯たち到着
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@play_x+0,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x-96,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+96,@play_y+64,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x,@play_y,picture,rect)
    when 2122 #セル登場(天津飯たち到着
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x-96,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+96,@play_y+64,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x-32,@play_y,picture,rect)
    when 2123 #セル戦闘
      battle_process (event_no)
    when 2131,2136,2138 #セル登場(天津飯たち到着
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x++128,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+32,@play_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2137 #セル登場(天津飯たち到着
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+128,@ene1_y+0,picture,rect)

      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-64,@play_y+0,picture,rect)
    when 2132 #ピッコロげきれつこうだん
      set_battle_event
    when 2139 #セル登場(天津飯たち到着
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+128,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+32,@play_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2140 #セル登場(天津飯たち到着
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+128,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+32,@play_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*1, 64, 64) # ピッコロ
      #add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2151 #セルVS16号
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      #rect = Rect.new(0, 64*26, 64, 64) # 16号
      #add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2152 #セルVS16号
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@play_x+0,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2153 #VSセル
      battle_process (event_no)
    when 2156 #セルVS16号
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2157 #16号ヘルズフラッシュ
      set_battle_event
    when 2161 #セルVS16号後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+96,@ene1_y+0,picture,rect)
    when 2162 #セルVS16号後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+96,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2163 #セルVS16号後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      
      
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+0,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+0,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x+0,@play_y+64,picture,rect)
    when 2164 #セルVS16号後(17号吸収
      
      Audio.se_play("Audio/SE/" + "Z2 変身2")# 効果音を再生する
      shake_y = 4
      shake_houkou = 8
      xcount = 0
      for x in 0..60
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      if shake_houkou == 8
        add_chr(@ene1_x+0,@ene1_y+0-shake_y,picture,rect)
      else
        add_chr(@ene1_x+0,@ene1_y+0+shake_y,picture,rect)
      end
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+0,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x+0,@play_y+64,picture,rect)
      
      
        #@chr_sprite[2].update
        Graphics.update
        clear_chr if x != 60
        xcount += 1
        if xcount == 4
          xcount = 0
          shake_houkou = -shake_houkou
        end
      end
    when 2165 #セルVS16号後(17号吸収後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x+0,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x+0,@play_y+64,picture,rect)
    when 2166 #セルVS16号後(17号吸収後 16号逃げる
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-64,@play_y+0,picture,rect)
    when 2167 #セル17号吸収完了
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2168 #セル17号吸収完了
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*26, 64, 64) # 16号
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x+32,@play_y+0,picture,rect)
    when 2169 #セルVS16号後(17号吸収後 16号逃げる
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-64,@play_y+0,picture,rect)
    when 2170 #セル17号吸収完了
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+192,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2171 #セル17号吸収完了
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+0,@ene1_y-48,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+192,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2172 #新気功砲
      set_battle_event
    when 2173 #セルVS16号後(17号吸収後 16号逃げる
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@ene1_x+0,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-32,@play_y+0,picture,rect)
    when 2181 #新気功砲後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+0,picture,rect)
    when 2182 #新気功砲後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+0,picture,rect)
    when 2183 #新気功砲後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect = Rect.new(1*64, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2184 #新気功砲後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+0,picture,rect)
    when 2185 #新気功砲後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-32,@play_y+0,picture,rect)
    when 2186 #新気功砲後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # チャオズ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ヤムチャ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
    when 2187 #新気功砲後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-64,@play_y+0,picture,rect)
    when 2188 #VSセル2
      battle_process (event_no)
    when 2191 #戦闘後負け
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*1, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect = Rect.new(64*1, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      rect = Rect.new(64*1, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-64,@play_y+0,picture,rect)
    when 2192 #戦闘後負け(悟空到着
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect = Rect.new(64*1, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+64,picture,rect)
      rect = Rect.new(64*1, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+64,@play_y+64,picture,rect)
      rect = Rect.new(64*1, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-64,@play_y+64,picture,rect)
    when 2193 #戦闘後負け(ピッコロ発見
      picture = "ZG_背景_海2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*1, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-0,@play_y+0,picture,rect)
      rect = Rect.new(64*1, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+64,picture,rect)
      rect = Rect.new(64*1, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+64,@play_y+64,picture,rect)
      rect = Rect.new(64*1, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-64,@play_y+64,picture,rect)
    when 2194 #戦闘後負け(セルのみ
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2195 #戦闘後負け(ピッコロ発見
      picture = "ZG_背景_海2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*1, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect = Rect.new(64*1, 64*5, 64, 64) # 天津飯
      add_chr(@play_x-0,@play_y+64,picture,rect)
      rect = Rect.new(64*1, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+64,@play_y+64,picture,rect)
      rect = Rect.new(64*1, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-64,@play_y+64,picture,rect)
    when 2196 #戦闘後負け(ピッコロ発見
      picture = "ZG_背景_海2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2197 #戦闘後負け(ピッコロ発見
      picture = "ZG_背景_海2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*1, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2211 #クリリンとブルマがあう前
      #picture = "ZG_背景_グランドアポロン(青空)"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-0,@play_y+0,picture,rect)
    when 2212 #クリリンとブルマがあう
      #picture = "ZG_背景_グランドアポロン(青空)"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-0,@play_y+0,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      #character_output
    when 2213 #クリリンとブルマがあうコントローラー渡す
      #picture = "ZG_背景_グランドアポロン(青空)"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-32,@play_y+0,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*52, 64, 64) # コントローラー
      add_chr(@play_x+32,@play_y+0,picture,rect)
      #character_output
    when 2221 #セル戦闘後悟空たち
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x-32+0,@ene1_y,picture,rect)
      rect = Rect.new(64*0, 64*5, 64, 64) # 天津飯
      add_chr(@ene1_x+32+0,@ene1_y,picture,rect)
      rect = Rect.new(64*0, 64*6, 64, 64) # チャオズ
      add_chr(@ene1_x+32+64,@ene1_y,picture,rect)
      rect = Rect.new(64*0, 64*4, 64, 64) # ヤムチャ
      add_chr(@ene1_x-32-64,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
    when 2222 #セル戦闘後悟空たち(ポポ現れる
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x-32+0,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x+32+0,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+32+64,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-32-64,@play_y+64,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
    when 2223 #セル戦闘後悟空たち(トランクスたち出てくる
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方_トランクス長髪"
      rect = Rect.new(0, 0*0, 64, 64) # 長髪トランクス
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+32+0,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x-32+0,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x+32+0,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+32+64,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-32-64,@play_y+64,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-64,@play_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
    when 2224 #セル戦闘後悟空たち(トランクスたち出てくる
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方_トランクス長髪"
      rect = Rect.new(0, 0*0, 64, 64) # 長髪トランクス
      add_chr(@play_x-96,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+96,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x+32+64+32,@play_y+64,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x-32+0-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x+32+0-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+32+64-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-32-64-32,@play_y+64,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+0+32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2225 #セル戦闘後悟空たち(トランクスたち出てくる
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方_トランクス長髪"
      rect = Rect.new(0, 64*1, 64, 64) # 長髪トランクス
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x+32+64+32,@play_y+64,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x-32+0-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x+32+0-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+32+64-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-32-64-32,@play_y+64,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-64,@play_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+64+0,@play_y,picture,rect)
    when 2226 #セル戦闘後悟空たち(トランクスたち出てくる
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方_トランクス長髪"
      rect = Rect.new(0, 64*1, 64, 64) # 長髪トランクス
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "Z3_顔味方"
      #rect = Rect.new(64*0, 64*9, 64, 64) # ベジータ
      #add_chr(@ene1_x+32,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x+32+64+32,@play_y+64,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x-32+0-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x+32+0-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+32+64-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-32-64-32,@play_y+64,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-64,@play_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+64+0,@play_y,picture,rect)
    when 2227 #セル戦闘後悟空たち(トランクスたち出てくる
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "Z3_顔味方_トランクス長髪"
      #rect = Rect.new(0, 64*1, 64, 64) # 長髪トランクス
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "Z3_顔味方"
      #rect = Rect.new(64*0, 64*9, 64, 64) # ベジータ
      #add_chr(@ene1_x+32,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x+32+64+32,@play_y+64,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x-32+0-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*5, 64, 64) # 天津飯
      add_chr(@play_x+32+0-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+32+64-32,@play_y+64,picture,rect)
      rect = Rect.new(64*0, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x-32-64-32,@play_y+64,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-64,@play_y,picture,rect)
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+64+0,@play_y,picture,rect)
    when 2231 #セル戦闘後セル18号たち追いかける
      picture = "Z3_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2232 #セル戦闘後セル18号たち
      picture = "Z3_背景_森"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(64, 64*26, 64, 64) # 16号
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@play_x+0,@play_y,picture,rect)
    when 2233 #セル戦闘後セルを追いかけるベジータたち
      #picture = "Z3_背景_天界"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方_トランクス長髪"
      rect = Rect.new(0, 64*1, 64, 64) # 長髪トランクス
      add_chr(@ene1_x+32,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64*0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x-32,@play_y,picture,rect)
    when 2251 #セル追いつく
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      character_output
    when 2256 #セル戦闘
      battle_process (event_no)
    when 2261 #セル第2形態戦闘後
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(64*1, 64*28, 64, 64) # セル
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,16,1 #ベジータ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x+0,@play_y,picture,rect)
    when 2262 #セル第2形態戦闘後18号達発見
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+0-48,@ene1_y,picture,rect)
      rect = Rect.new(1*64, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+0+48,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x+0,@play_y,picture,rect)
    when 2263 #セル追い詰める
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      character_output
    when 2264 #セル第2形態戦闘後18号達発見コントローラー取り出す
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+0-48,@ene1_y,picture,rect)
      rect = Rect.new(1*64, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+0+48,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*52, 64, 64) # コントローラー
      add_chr(@play_x+32,@play_y,picture,rect)
    when 2265 #セル追いつく
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2266 #セル18号たち発見
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*28, 64, 64) # セル
      add_chr(@play_x+0,@play_y,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(1*64, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+96,picture,rect)
    when 2267 #セル18号たち発見
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "Z3_顔敵"
      #rect = Rect.new(0, 64*28, 64, 64) # セル
      #add_chr(@play_x+0,@play_y,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(1*64, 64*26, 64, 64) # 16号
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+96,picture,rect)
    when 2268 #トランクスとベジータ
      picture = "ZG_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "Z3_顔敵"
      #rect = Rect.new(0, 64*28, 64, 64) # セル
      rect,picture = set_character_face 0,16,1 #ベジータ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+96,picture,rect)
    when 2269 #セルとトランクス
      picture = "ZG_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2270 #セルとトランクス太陽拳使用
      picture = "ZG_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 1,17,1 #トランクス
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2271 #18号吸収前
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 1,3,1 #クリリン
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*26, 64, 64) # 16号
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect = Rect.new(1*64, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+0,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
    when 2272 #18号吸収中
      Audio.se_play("Audio/SE/" + "Z2 変身2")# 効果音を再生する
      shake_y = 4
      shake_houkou = 8
      xcount = 0
      for x in 0..60
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*24, 64, 64) # 18号
      if shake_houkou == 8
        add_chr(@ene1_x+0,@ene1_y+0-shake_y,picture,rect)
      else
        add_chr(@ene1_x+0,@ene1_y+0+shake_y,picture,rect)
      end
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y-32,picture,rect)
      rect,picture = set_character_face 1,3,1 #クリリン
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*26, 64, 64) # 16号
      add_chr(@play_x+32,@play_y+0,picture,rect)
      
      
        #@chr_sprite[2].update
        Graphics.update
        clear_chr if x != 60
        xcount += 1
        if xcount == 4
          xcount = 0
          shake_houkou = -shake_houkou
        end
      end
    when 2273 #18号吸収後ベジータ台詞
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,16,1 #ベジータ
      add_chr(@play_x+0,@play_y+96,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*28, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2274 #18号吸収後天界
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+0,@play_y,picture,rect)
    when 2275 #セル吸収完了
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,16,1 #ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+96,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64,@play_y+96,picture,rect)
      rect,picture = set_character_face 1,20,1 #16号
      add_chr(@play_x+64,@play_y+96,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2281 #ベジータファイナルフラッシュ
      set_battle_event
    when 2291 #ファイナルフラッシュ後
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,16,1 #ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+96,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64,@play_y+96,picture,rect)
      rect,picture = set_character_face 1,20,1 #16号
      add_chr(@play_x+64,@play_y+96,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2292 #ファイナルフラッシュ後
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,16,1 #ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+96,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64,@play_y+96,picture,rect)
      rect,picture = set_character_face 1,20,1 #16号
      add_chr(@play_x+64,@play_y+96,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2301 #ベジータボコボコにされる
      set_battle_event
    when 2311 #ベジータボコボコにされた
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 1,9,1 #ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+96,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64,@play_y+96,picture,rect)
      rect,picture = set_character_face 1,20,1 #16号
      add_chr(@play_x+64,@play_y+96,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2321 #ゴクウと悟飯精神と時の部屋(開始前)
      picture = "Z3_背景_精神と時の部屋"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,11,1 #悟空
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2331 #ゴクウと悟飯精神と時の部屋(開始)
      $scene = Scene_Db_Ryuha_Pair_Training.new
    when 2341 #ゴクウと悟飯精神と時の部屋(修行終了後)
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,17,1 #トランクス
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2342 #トランクス超サイヤ人解く
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2343 #セル飛び去る
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+0,@play_y+0,picture,rect)
      #picture = "Z3_顔敵"
      #rect = Rect.new(0*64, 64*29, 64, 64) # セル
      #add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2344 #ベジータボコボコにされた
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x+32,@play_y+0,picture,rect)
      #rect,picture = set_character_face 0,20,1 #16号
      #add_chr(@play_x+64,@play_y+96,picture,rect)
    when 2345 #16号現れる
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect,picture = set_character_face 1,20,1 #16号
      add_chr(@play_x+0,@play_y+64,picture,rect)
    when 2351 #天界悟空たちを待つ
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+96,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,5,1 #テンシンハン
      add_chr(@play_x-96,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x+32,@play_y+64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x-32,@play_y+64,picture,rect)
    when 2352 #天界悟空たちを待つ
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+96,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,5,1 #テンシンハン
      add_chr(@play_x-96,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x+32,@play_y+64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x-32,@play_y+64,picture,rect)
      rect,picture = set_character_face 0,11,1 #超悟空
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2361 #セルリング　セルと悟空話す
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #rect,picture = set_character_face 0,11,1 #超悟空
      #add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2362 #セルリング　セルと悟空話す(悟空到着)
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,11,1 #超悟空
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2363 #悟空戻ってくる
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+96,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,5,1 #テンシンハン
      add_chr(@play_x-96,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x+32,@play_y+64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x-32,@play_y+64,picture,rect)
      #rect,picture = set_character_face 0,11,1 #超悟空
      #add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2364 #悟空戻ってくる
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+96,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,5,1 #テンシンハン
      add_chr(@play_x-96,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x+32,@play_y+64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x-32,@play_y+64,picture,rect)
      rect,picture = set_character_face 0,11,1 #超悟空
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2371 #ビッグゲテスター編が終わって戻ってくる
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,2 

      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)

    when 2372 #悟空　家に帰る
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,3
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)

    when 2373 #悟空　、ベジータ家に帰る
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,4
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
    when 2381 #子ども家
      picture = "Z3_背景_家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # 男の子
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output
    when 2391 #別荘
      picture = "ZG_背景_亀仙人の家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 男の子
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output
    when 2401 #東の泉
      picture = "Z3_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*0, 64, 64) # 男の子
      #add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output
    when 2402 #東の泉
      picture = "Z3_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(0, 64*56, 64, 64) # 薬草
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output
    when 2411 #ドラゴンボールＺ揃った
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      character_output
    when 2412 #Ｚ戦士精神と時の部屋
      picture = "Z3_背景_精神と時の部屋"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 2421 #Ｚ戦士精神と時の部屋(修行開始)
      $scene = Scene_Db_Ryuha_Pair_Training.new
    when 2431 #セルゲーム直前(悟空の家
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*35, 64, 64) # 牛魔王
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2432 #セルゲーム直前(悟空の家　悟空移動
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #rect,picture = set_character_face 0,7,1 #チチ
      #add_chr(@ene1_x-32,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*35, 64, 64) # 牛魔王
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2433 #セルゲーム直前(神の神殿
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,4,1 #ヤムチャ
      add_chr(@ene1_x-64*4,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,5,1 #テンシンハン
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@ene1_x+64*4,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+64*0,@ene1_y-64,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 2434 #セルゲーム直前(神の神殿　悟空、チチ到着
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,4,1 #ヤムチャ
      add_chr(@ene1_x-64*4,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,5,1 #テンシンハン
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@ene1_x+64*4,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+64*0,@ene1_y-64,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x+32,@play_y+0,picture,rect)
    when 2435 #セルゲーム直前(岩山　ベジータのみ
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      #character_output
    when 2436 #セルゲーム直前(岩山　悟空たち到着
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      character_output_all 0,0,0,7
    when 2437 #セルゲーム直前(岩山　ベジータ合流
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,8
    when 2438 #セルゲーム直前(岩山　16号到着
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,20,1 #16号
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      character_output_all 0,0,0,8
=begin #チチ、亀仙人仲間にしないパターン
    when 2432 #セルゲーム直前(悟空の家　悟空移動
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*35, 64, 64) # 牛魔王
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2433 #セルゲーム直前(神の神殿
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,4,1 #ヤムチャ
      add_chr(@ene1_x-64*4,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,5,1 #テンシンハン
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@ene1_x+64*4,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 2434 #セルゲーム直前(神の神殿　悟空到着
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,4,1 #ヤムチャ
      add_chr(@ene1_x-64*4,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,5,1 #テンシンハン
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@ene1_x+64*4,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 2435 #セルゲーム直前(岩山　ベジータのみ
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      #character_output
    when 2436 #セルゲーム直前(岩山　悟空たち到着
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      character_output
=end
    when 2441 #セルリング　サタンたち
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,28,1 #サタン
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # アナウンサー
      add_chr(@ene1_x-96-64-32,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 2442 #セルリング　サタンとZ戦士たち
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,28,1 #サタン
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # アナウンサー
      add_chr(@ene1_x-96-64-32,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      character_output_all 0,0,0,9
    when 2449 #セルたいサタン
      set_battle_event
    when 2451 #セルリング　サタンとZ戦士たち
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #rect,picture = set_character_face 0,28,1 #サタン
      #add_chr(@ene1_x-96,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # アナウンサー
      add_chr(@ene1_x-96-64-32,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      character_output_all 0,0,0,9
    when 2452 #セルリング　サタンとZ戦士たち
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 1,28,1 #サタン
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # アナウンサー
      add_chr(@ene1_x-96-64-32,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      character_output_all 0,0,0,9
    when 2461 #セルリング　サタンとZ戦士たち
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      character_output_all 0,0,0,9
    when 2462 #セルリング　サタンとZ戦士たち セルジュニア
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*4,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*4,@ene1_y,picture,rect)
      character_output_all 0,0,0,9
    when 2463 #セル対悟空
      battle_process (event_no)
    when 2464 #セル対Ｚ戦士全員
      battle_process (event_no)
    when 2471 #セルリング　悟空戦闘終了
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      
      if $super_saiyazin_flag[0] == true
        rect,picture = set_character_face 0,11,1 #超悟空
      else
        rect,picture = set_character_face 0,0,1 #悟空
      end
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      character_output_all 0,0,0,10
    when 2472 #セルリング　悟飯戦闘前
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      character_output_all 0,0,0,11
    when 2473 #セルリング　悟飯戦闘前
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      character_output_all 0,0,0,11
    when 2481 #セル対悟飯戦闘
      battle_process (event_no)
    when 2491 #セルリング　悟飯戦闘後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      character_output_all 0,0,0,11
    when 2492 #セルリング　悟飯戦闘後16号自爆前
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,20,1 #16号
      add_chr(@ene1_x+96+64,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      character_output_all 0,0,0,12
    when 2501 #16号たいセル
      set_battle_event
    when 2511#セルリング　悟飯戦闘後16号自爆後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,20,1 #16号
      add_chr(@ene1_x+96+64,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      character_output_all 0,0,0,12
    when 2512#セルリング　悟飯戦闘後16号自爆後(16号破壊)
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #rect,picture = set_character_face 0,20,1 #16号
      #add_chr(@ene1_x+96+64,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      character_output_all 0,0,0,12
    when 2513 #セルリング　悟飯戦闘後16号自爆後(16号破壊後セルジュニア
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*4,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*4,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x,@ene1_y-72,picture,rect)
      character_output_all 0,0,0,12
    when 2514 #セルリング　悟飯戦闘後16号自爆後(サタンたち
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,28,1 #サタン
      add_chr(@play_x-0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # アナウンサー
      add_chr(@play_x-0,@play_y+64,picture,rect)
   when 2515 #セルリング　悟飯戦闘後16号自爆後(サタンたち
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*55, 64, 64) # 16号破壊
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,28,1 #サタン
      add_chr(@play_x-0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # アナウンサー
      add_chr(@play_x-0,@play_y+64,picture,rect)
    when 2516 #セルリング　悟飯戦闘後16号自爆後(16号破壊後セルジュニア
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*4,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*4,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x,@ene1_y-72,picture,rect)
      character_output_all 0,0,0,12
    when 2517 #セルリング　悟飯戦闘後16号自爆後(16号破壊後セルジュニア
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*4,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*4,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@ene1_x,@ene1_y-72,picture,rect)
      character_output_all 1,0,0,12
    when 2518 #セルリング　16号放り投げる
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*55, 64, 64) # 16号破壊
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
      #character_output
    when 2519 #セルリング　16号破壊
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*55, 64, 64) # 16号破壊
      #add_chr(@ene1_x+96-64,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
    when 2520 #セルリング　16号破壊(悟飯覚醒
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*55, 64, 64) # 16号破壊
      #add_chr(@ene1_x+96-64,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
    when 2521 #セルリング　16号破壊(悟飯覚醒
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*1+32,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2+32,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*3+32,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*4+32,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1-32,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2-32,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*3-32,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*4-32,@ene1_y,picture,rect)
      #picture = "Z3_顔敵"
      #rect = Rect.new(0*64, 64*29, 64, 64) # セル
      #add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
      character_output_all 1,0,64,12
    when 2522 #セルリング　16号破壊(悟飯覚醒セルジュニア撃破1
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*1+32,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2+32,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*3+32,@ene1_y,picture,rect)
      #add_chr(@ene1_x-64*4+32,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1-32,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2-32,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*3-32,@ene1_y,picture,rect)
      #add_chr(@ene1_x+64*4-32,@ene1_y,picture,rect)
      #picture = "Z3_顔敵"
      #rect = Rect.new(0*64, 64*29, 64, 64) # セル
      #add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
      character_output_all 1,0,64,12
    when 2523 #セルリング　16号破壊(悟飯覚醒セルジュニア撃破2
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*1+32,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2+32,@ene1_y,picture,rect)
      #add_chr(@ene1_x-64*3+32,@ene1_y,picture,rect)
      #add_chr(@ene1_x-64*4+32,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1-32,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2-32,@ene1_y,picture,rect)
      #add_chr(@ene1_x+64*3-32,@ene1_y,picture,rect)
      #add_chr(@ene1_x+64*4-32,@ene1_y,picture,rect)
      #picture = "Z3_顔敵"
      #rect = Rect.new(0*64, 64*29, 64, 64) # セル
      #add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
      character_output_all 1,0,64,12
    when 2524 #セルリング　16号破壊(悟飯覚醒セルジュニア撃破3
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      #add_chr(@ene1_x-64*1+32,@ene1_y,picture,rect)
      #add_chr(@ene1_x-64*2+32,@ene1_y,picture,rect)
      #add_chr(@ene1_x-64*3+32,@ene1_y,picture,rect)
      #add_chr(@ene1_x-64*4+32,@ene1_y,picture,rect)
      #add_chr(@ene1_x+64*1-32,@ene1_y,picture,rect)
      #add_chr(@ene1_x+64*2-32,@ene1_y,picture,rect)
      #add_chr(@ene1_x+64*3-32,@ene1_y,picture,rect)
      #add_chr(@ene1_x+64*4-32,@ene1_y,picture,rect)
      #picture = "Z3_顔敵"
      #rect = Rect.new(0*64, 64*29, 64, 64) # セル
      #add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
      character_output_all 1,0,64,12
    when 2525 #セルリング　セルジュニア撃破後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*55, 64, 64) # 16号破壊
      #add_chr(@ene1_x+96-64,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
      character_output_all 1,0,64,12
    when 2531 #超2悟飯たいセル
      set_battle_event
    when 2541 #セルリング　超2悟飯たいセル後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*55, 64, 64) # 16号破壊
      #add_chr(@ene1_x+96-64,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
      character_output_all 0,0,64,12
    when 2542 #セルリング　超2悟飯たいセル後18号吐き出す
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*55, 64, 64) # 16号破壊
      #add_chr(@ene1_x+96-64,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*28, 64, 64) # セル
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
      character_output_all 0,0,64,12
    when 2543 #セルリング　セル爆発巨大化
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_セル自爆"
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
      character_output_all 0,0,64,12
    when 2544 #セルリング　セル爆発巨大化　ゴクウセルの横へ
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_セル自爆"
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      if $super_saiyazin_flag[0] == true
        rect,picture = set_character_face 0,11,1 #超悟空
      else
        rect,picture = set_character_face 0,0,1 #悟空
      end
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,15,1 #超悟飯
      add_chr(@play_x-0,@play_y,picture,rect)
      character_output_all 0,0,64,13
    when 2545 #セル爆発巨大化　界王星
      picture = "Z3_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_セル自爆"
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      if $super_saiyazin_flag[0] == true
        rect,picture = set_character_face 0,11,1 #超悟空
      else
        rect,picture = set_character_face 0,0,1 #悟空
      end
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x+32-50+96+16,@ene1_y,picture,rect)
=begin
    when 2545 #セル爆発巨大化　界王星
      picture = "Z3_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_セル爆発"
      rect = Rect.new(0*64, 64*0, 100, 104) # セル
      add_chr(@ene1_x+32-50,@ene1_y-20,picture,rect)
      rect,picture = set_character_face 0,11,1 #悟空
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x+32-50+96+16,@ene1_y,picture,rect)
=end
      when 2546 #セル爆発後地球
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,14
    when 2547 #セル爆発後　界王星
      #picture = "Z3_背景_界王星"
      picture = "Z3_背景_界王星(なし)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 2548 #セル爆発後地球18号味方側
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,15
    when 2549 #セル爆発後地球18号味方側
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      character_output_all 0,0,0,15
    when 2550 #セル爆発後地球18号味方側
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x-64*4,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*30, 64, 64) # セルジュニア
      add_chr(@ene1_x+64*4,@ene1_y,picture,rect)
      character_output_all 0,0,0,15
    when 2561 #セル(パーフェクト)対Ｚ戦士全員
      battle_process (event_no)
    when 2571 #セル(パーフェクト)戦闘後
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*29, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      character_output_all 0,0,0,15
    when 2591 #セル(パーフェクト)かめはめは打ち合い後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,16
    when 2592 #セル(パーフェクト)かめはめは打ち合い後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,17
    when 2593 #セル(パーフェクト)かめはめは打ち合い後
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 2594 #セル(パーフェクト)かめはめは打ち合い後(サタンたち
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,28,1 #サタン
      add_chr(@play_x-0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # アナウンサー
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 2595 #天界
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      character_output 0,0,0
    when 2596 #天界(18号いない
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+32*1,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      character_output 0,0,0
    when 2597 #天界(シェンロン呼ぶ
      picture = "Z3_シェンロン呼び出し(天界用に編集)"
      rect = Rect.new(640*0, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(16)
      rect = Rect.new(640*1, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(16)
      rect = Rect.new(640*2, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(16)
      rect = Rect.new(640*3, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(16)
      rect = Rect.new(640*4, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(120)
      clear_chr
      Audio.se_play("Audio/SE/" + "Z3 稲妻")    # 効果音を再生する
      for x in 0..10
        rect = Rect.new(640*5, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        rect = Rect.new(640*6, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        clear_chr
      end
      rect = Rect.new(640*4, 0, 640, 480) # 背景
      add_chr(0,0,picture,rect)
      Graphics.wait(20)
      Audio.se_play("Audio/SE/" + "Z3 稲妻")    # 効果音を再生する
      for x in 0..10
        rect = Rect.new(640*5, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        rect = Rect.new(640*6, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        clear_chr
      end
      Audio.se_play("Audio/SE/" + "Z3 シェンロン呼び出し")    # 効果音を再生する
      picture2 = "z2op/z2_op_001"
      color = Color.new(255,255,255,256)
      rect = Rect.new(0, 0, 960, 720)
      add_chr(0,0,picture2,rect)
      @chr_sprite[0].bitmap.fill_rect(0,0,960,720,color)
      Graphics.update
      #@chr_sprite[@chr_sprite.size-1].bitmap.fill_rect(0,0,960,720,color)
      #@chr_sprite[0].bitmap.fill_rect(0,0,960,720,color)
      Graphics.update
      Graphics.wait(120)
      for x in 0..22
        rect = Rect.new(640*7, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        rect = Rect.new(640*8, 0, 640, 480) # 背景
        add_chr(0,0,picture,rect)
        Graphics.wait(4)
        clear_chr
      end
    when 2598 #天界(シェンロン呼び出し
      #picture = "Z3_背景_天界"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@play_x-32,@play_y,picture,rect)
      character_output 0,0,64
      picture = "顔カード"
      rect = Rect.new(128, 64*16, 64, 64) # シェンロン
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2599 #天界(シェンロン呼び出し願い叶えた後
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@play_x-32,@play_y,picture,rect)
      character_output 0,0,64
    when 2600 #天界(シェンロン呼び出し願い叶えた後18号来る
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(128, 64*14, 64, 64) # デンデ
      add_chr(@play_x-32,@play_y,picture,rect)
      character_output 0,0,64
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*24, 64, 64) # 18号
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2601 #悟空の家
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*35, 64, 64) # 牛魔王
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*18, 64, 64) # 占いババ
      add_chr(@play_x+64,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
    when 2602 #ラスト(ブルマの家
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@play_x-0,@play_y+64,picture,rect)
      rect,picture = set_character_face 0,4,1 #ヤムチャ
      add_chr(@play_x-64*4+32,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-64*3+32,@play_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64*2+32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x-64*1+32,@play_y,picture,rect)
      rect = Rect.new(128, 64*37, 64, 64) # ブルマの母
      add_chr(@play_x+64*2-32,@play_y,picture,rect)
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@play_x+64*3-32,@play_y,picture,rect)
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+64*4-32,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス(赤ちゃん)
      add_chr(@play_x+64*1-32,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2603 #ラスト(ブルマの家_タイムマシン
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@play_x-0,@play_y+64,picture,rect)
      rect,picture = set_character_face 0,4,1 #ヤムチャ
      add_chr(@play_x-64*4+32,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-64*3+32,@play_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64*2+32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x-64*1+32,@play_y,picture,rect)
      rect = Rect.new(128, 64*37, 64, 64) # ブルマの母
      add_chr(@play_x+64*2-32,@play_y,picture,rect)
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@play_x+64*3-32,@play_y,picture,rect)
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+64*4-32,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス(赤ちゃん)
      add_chr(@play_x+64*1-32,@play_y,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
    when 2604 #ラスト(ブルマの家_タイムマシン発信
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@play_x-0,@play_y+64,picture,rect)
      rect,picture = set_character_face 0,4,1 #ヤムチャ
      add_chr(@play_x-64*4+32,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-64*3+32,@play_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64*2+32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x-64*1+32,@play_y,picture,rect)
      rect = Rect.new(128, 64*37, 64, 64) # ブルマの母
      add_chr(@play_x+64*2-32,@play_y,picture,rect)
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@play_x+64*3-32,@play_y,picture,rect)
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+64*4-32,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス(赤ちゃん)
      add_chr(@play_x+64*1-32,@play_y,picture,rect)
    when 2611 #シーン補正(ベジータのみ
      picture = "ZG_背景_グランドアポロン(青空)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      if $super_saiyazin_flag[3] == true
        rect,picture = set_character_face 0,16,1 #超ベジータ
      else
        rect,picture = set_character_face 0,9,1 #ベジータ
      end
      
      add_chr(@play_x,@play_y,picture,rect)
      
    when 2621 #セル全員で闘った後
      picture = "Z3_背景_セルゲームリング"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,9
    when 2691 #エンディングスタッフロール
      z_ed_rev1 #スタッフロール
    when 2693 #クリア後もうちっとだけ続く
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@ene1_x,@ene1_y,picture,rect)
    #################################################################
    
                          ####　メタルクウラ編 ####
    
    #################################################################
    when 2701 #悟空新ナメック星につく
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,11,1 #超悟空
      add_chr(@play_x+0,@play_y+0,picture,rect)
      
      picture = "Z2_顔イベント"
      rect = Rect.new(0*64, 64*1, 64, 64) # ナメック星人太い
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*4, 64, 64) # ナメック星人細い
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*7, 64, 64) # ナメック星人若者
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 2702 #悟空新ナメック星につく 最長老現れる
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,11,1 #超悟空
      add_chr(@play_x+0,@play_y+0,picture,rect)
      
      picture = "Z2_顔イベント"
      rect = Rect.new(0*64, 64*1, 64, 64) # ナメック星人太い
      add_chr(@ene1_x,@ene1_y-32,picture,rect)
      rect = Rect.new(0*64, 64*4, 64, 64) # ナメック星人細い
      add_chr(@ene1_x-96,@ene1_y-32,picture,rect)
      rect = Rect.new(0*64, 64*7, 64, 64) # ナメック星人若者
      add_chr(@ene1_x+96,@ene1_y-32,picture,rect)
      picture = "顔カード"
      rect = Rect.new(2*64, 64*30, 64, 64) # ナメック星人最長老
      add_chr(@ene1_x+0,@ene1_y+32,picture,rect)
    when 2703 #悟空新ナメック星 Z戦士集合
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x-32,@play_y+64,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@play_x+32,@play_y+64,picture,rect)
      
      picture = "Z2_顔イベント"
      rect = Rect.new(0*64, 64*1, 64, 64) # ナメック星人太い
      add_chr(@ene1_x,@ene1_y-32,picture,rect)
      rect = Rect.new(0*64, 64*4, 64, 64) # ナメック星人細い
      add_chr(@ene1_x-96,@ene1_y-32,picture,rect)
      rect = Rect.new(0*64, 64*7, 64, 64) # ナメック星人若者
      add_chr(@ene1_x+96,@ene1_y-32,picture,rect)
      picture = "顔カード"
      rect = Rect.new(2*64, 64*30, 64, 64) # ナメック星人最長老
      add_chr(@ene1_x+0,@ene1_y+32,picture,rect)
    when 2704 #悟空新ナメック星 Z戦士集合 デンデ現れる
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x-32,@play_y+64,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@play_x+32,@play_y+64,picture,rect)
      
      picture = "Z2_顔イベント"
      rect = Rect.new(0*64, 64*1, 64, 64) # ナメック星人太い
      add_chr(@ene1_x,@ene1_y-32,picture,rect)
      rect = Rect.new(0*64, 64*4, 64, 64) # ナメック星人細い
      add_chr(@ene1_x-96,@ene1_y-32,picture,rect)
      rect = Rect.new(0*64, 64*7, 64, 64) # ナメック星人若者
      add_chr(@ene1_x+96,@ene1_y-32,picture,rect)
      picture = "顔カード"
      rect = Rect.new(2*64, 64*30, 64, 64) # ナメック星人最長老
      add_chr(@ene1_x-32,@ene1_y+32,picture,rect)
      rect = Rect.new(2*64, 64*14, 64, 64) # ナメック星人デンデ
      add_chr(@ene1_x+32,@ene1_y+32,picture,rect)
    when 2705 #悟空新ナメック星 Z戦士集合 ビッグゲテスター
      picture = "Z3_背景_ビッグゲテスター"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 2711 #悟空新ナメック星 最長老／デンデ
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0

      picture = "顔カード"
      rect = Rect.new(2*64, 64*30, 64, 64) # ナメック星人最長老
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2721 #メタルクウラが居るところに到着
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*36, 64, 64) # メタルクウラ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2726 #メタルクウラ戦
      battle_process (event_no)
    when 2731 #メタルクウラが居るところに到着 クウラ1対一旦撃破
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく
    when 2732 #メタルクウラが居るところに到着 クウラ3対
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*36, 64, 64) # メタルクウラ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 2736 #メタルクウラ戦
      battle_process (event_no)
    when 2741 #メタルクウラ戦後
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく
    when 2742 #メタルクウラ戦後
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく

      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*36, 64, 64) # メタルクウラ
      temptekiput = 9
      for x in 0..temptekiput - 1
        add_chr(@ene1_x-32*(temptekiput - 1)+64*x,@ene1_y,picture,rect)
      end
    when 2751 #ビッグゲテスター内 誘導ロボット
      picture = "Z3_背景_ビッグゲテスター内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく

      picture = "Z3_顔イベント"
      rect = Rect.new(0*64, 64*71, 64, 64) # 誘導ロボット
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2752 #ビッグゲテスター内 誘導ロボット撃破後
      picture = "Z3_背景_ビッグゲテスター内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく

      #picture = "Z3_顔敵"
      #rect = Rect.new(0*64, 64*72, 64, 64) # 誘導ロボット
      #add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2761..2764 #ビッグゲテスター内 ロボット兵A
      picture = "Z3_背景_ビッグゲテスター内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*113, 64, 64) # ロボット兵
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2765 #ロボット兵戦
      battle_process (event_no)
    when 2769 #ロボット兵全て倒す ドアが開く
      picture = "Z3_背景_ビッグゲテスター内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく
    when 2771 #ビッグゲテスター内 ドア
      picture = "Z3_背景_ビッグゲテスター内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく
    when 2781 #ビッグゲテスター内 メタルクウラコア
      picture = "Z3_背景_ビッグゲテスター内部"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*114, 64, 64) # メタルクウラコア
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2782 #メタルクウラコア戦
      battle_process (event_no)
    when 2791 #メタルクウラコア戦後
      #picture = "Z3_背景_ビッグゲテスター内部"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,1 #とりあえずモード1にしておく
    when 2792 #悟空新ナメック星 Z戦士集合 デンデ現れる
      picture = "Z3_背景_ナメック星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,2 #とりあえずモード1にしておく
      
      picture = "Z2_顔イベント"
      rect = Rect.new(0*64, 64*1, 64, 64) # ナメック星人太い
      add_chr(@ene1_x,@ene1_y-32,picture,rect)
      rect = Rect.new(0*64, 64*4, 64, 64) # ナメック星人細い
      add_chr(@ene1_x-96,@ene1_y-32,picture,rect)
      rect = Rect.new(0*64, 64*7, 64, 64) # ナメック星人若者
      add_chr(@ene1_x+96,@ene1_y-32,picture,rect)
      picture = "顔カード"
      rect = Rect.new(2*64, 64*30, 64, 64) # ナメック星人最長老
      add_chr(@ene1_x-32,@ene1_y+32,picture,rect)
      rect = Rect.new(2*64, 64*14, 64, 64) # ナメック星人デンデ
      add_chr(@ene1_x+32,@ene1_y+32,picture,rect)
    #################################################################
    
                          ####　人造人間13号編 ####
    
    #################################################################
    when 2801 #悟空と悟飯
      #picture = "Z3_背景_ビッグゲテスター内部"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+32,@play_y+0,picture,rect)
    when 2802 #悟空と悟飯とチチ
      #picture = "Z3_背景_ビッグゲテスター内部"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+32,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2803 #悟空と悟飯とチチ、亀仙人たち合流 食事
      #picture = "Z3_背景_ビッグゲテスター内部"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-96,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@play_x-32,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+32,@play_y+64,picture,rect)

      picture = "顔カード"
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+96,@play_y+64,picture,rect)
      
      rect = Rect.new(128, 64*74, 64, 64) # ごちそう
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 2804 #悟空と悟飯とチチ、亀仙人たち合流 食事
      #picture = "Z3_背景_ビッグゲテスター内部"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-96,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@play_x-32,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+32,@play_y+64,picture,rect)

      picture = "顔カード"
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+96,@play_y+64,picture,rect)
      
    when 2805 #悟空と悟飯とチチ、亀仙人たち合流 人造人間
      #picture = "Z3_背景_ビッグゲテスター内部"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-96,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@play_x-32,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+32,@play_y+64,picture,rect)

      picture = "顔カード"
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+96,@play_y+64,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*40, 64, 64) # 14号
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*41, 64, 64) # 15号
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2806 #悟空と悟飯とチチ、亀仙人たち合流 人造人間　悟空離れる
      #picture = "Z3_背景_ビッグゲテスター内部"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      #rect,picture = set_character_face 0,0,1 #悟空
      #add_chr(@play_x-64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-96,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@play_x-32,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+32,@play_y+64,picture,rect)

      picture = "顔カード"
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+96,@play_y+64,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*40, 64, 64) # 14号
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*41, 64, 64) # 15号
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2807 #悟空と悟飯とチチ、亀仙人たち合流 人造人間　悟空離れる、14号、15号も離れる
      #picture = "Z3_背景_ビッグゲテスター内部"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      #rect,picture = set_character_face 0,0,1 #悟空
      #add_chr(@play_x-64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-96,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@play_x-32,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+32,@play_y+64,picture,rect)

      picture = "顔カード"
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+96,@play_y+64,picture,rect)
      
      #picture = "Z3_顔敵"
      #rect = Rect.new(0*64, 64*40, 64, 64) # 14号
      #add_chr(@ene1_x-32,@ene1_y,picture,rect)
      #rect = Rect.new(0*64, 64*41, 64, 64) # 15号
      #add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2808 #悟空と14号、15号
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x,@play_y+0,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*40, 64, 64) # 14号
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*41, 64, 64) # 15号
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      
    when 2811 #悟空と人造人間戦闘
      set_battle_event
      
    when 2821 #悟空と人造人間戦闘後
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x,@play_y+0,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*40, 64, 64) # 14号
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*41, 64, 64) # 15号
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2822 #悟空と人造人間戦闘後 悟空離脱
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      #rect,picture = set_character_face 0,0,1 #悟空
      #add_chr(@play_x,@play_y+0,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*40, 64, 64) # 14号
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*41, 64, 64) # 15号
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2823 #悟空と人造人間戦闘後 悟空離脱、人造人間14,15離脱
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
    when 2824 #悟飯、チチ、クリリン、亀仙人、トランクス、ウーロン
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,1 #とりあえずモード1にしておく    
      
      #rect,picture = set_character_face 0,0,1 #悟空
      #add_chr(@play_x-64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x+64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64,@play_y+0,picture,rect)
      
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@play_x-64,@play_y+64,picture,rect)
      
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+0,@play_y+64,picture,rect)

      picture = "顔カード"
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+64,@play_y+64,picture,rect)
    when 2825 #Ｚ戦士合流　悟空と合流前
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,5
    when 2826 #Ｚ戦士合流　悟空と合流後
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,5
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2831 #15号との戦闘前
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,6
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*41, 64, 64) # 15号
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2832 #15号との戦闘開始
      battle_process (event_no)
    when 2841 #14号との戦闘前
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,6
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*40, 64, 64) # 14号
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2842 #14号との戦闘開始
      battle_process (event_no)
    when 2846 #13号復活
      picture = "ZG_背景_宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # 人影
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2851 #13号との戦闘前
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,6
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*38, 64, 64) # 13号
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2852 #13号との戦闘開始
      battle_process (event_no)
    when 2861 #13号との戦闘後
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,6
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*38, 64, 64) # 13号
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2862 #13号との戦闘後　パーツ呼ぶ
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,6
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*38, 64, 64) # 13号
      add_chr(@ene1_x,@ene1_y,picture,rect)

      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*53, 64, 64) # 人造人間パーツ1
      add_chr(@ene1_x-80,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*53, 64, 64) # 人造人間パーツ2
      add_chr(@ene1_x+80,@ene1_y,picture,rect)
    when 2863 #13号との戦闘後　パーツ合体
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,6
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*38, 64, 64) # 13号
      add_chr(@ene1_x,@ene1_y,picture,rect)

      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*53, 64, 64) # 人造人間パーツ1
      add_chr(@ene1_x-80,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*53, 64, 64) # 人造人間パーツ2
      add_chr(@ene1_x+80,@ene1_y,picture,rect)

      for x in 0..39
        @chr_sprite[14].x += 2 
        @chr_sprite[15].x -= 2
        #x += 1
        Graphics.update
        Graphics.wait(2)
        @chr_sprite[14].opacity -= 5
        @chr_sprite[15].opacity -= 5
        
      end
    when 2864 #13号との戦闘後 パーツ取り込み後
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,6
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*38, 64, 64) # 13号
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2865 #13号との戦闘後 合体後
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,6
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*39, 64, 64) # 合体13号
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2871 #合体13号との戦闘開始
      battle_process (event_no)
    when 2881 #13号との戦闘後 合体後
      picture = "Z3_背景_雪山"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,6
    #################################################################
    
                          ####　セルゲームの前 ひらめき技関連 ####
    
    #################################################################    
    when 2901 #悟空、ピッコロ、ヤムチャ
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,6
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,4,1 #ヤムチャ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2911 #クリリン、ベジータ、ブルマ
      picture = "Z3_背景_カプセルコーポレーション"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,6
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x,@play_y+0,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 2921 #天津飯、チャオズ
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,6
      rect,picture = set_character_face 0,5,1 #天津飯、
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      #picture = "顔カード"
      #rect = Rect.new(128, 64*115, 64, 64) # タオパイパイ(サイボーグ)
      #add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2922 #天津飯、チャオズ、タオパイパイ(サイボーグ)
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,6
      rect,picture = set_character_face 0,5,1 #天津飯、
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*115, 64, 64) # タオパイパイ(サイボーグ)
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2923 #天津飯、チャオズ
      picture = "Z3_背景_林"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,6
      rect,picture = set_character_face 0,5,1 #天津飯、
      add_chr(@play_x-32,@play_y+0,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@play_x+32,@play_y+0,picture,rect)
      #picture = "顔カード"
      #rect = Rect.new(128, 64*115, 64, 64) # タオパイパイ(サイボーグ)
      #add_chr(@ene1_x,@ene1_y,picture,rect)
    when 2931 #悟飯、チチ、亀仙人、牛魔王
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #character_output_all 0,0,0,6
      rect,picture = set_character_face 0,2,1 #悟飯、
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@play_x-32,@play_y+0,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*35, 64, 64) # 牛魔王
      add_chr(@play_x+32,@play_y+0,picture,rect)
    #################################################################
    
        ####　地球人　精神と時の部屋に入る ####
    
    #################################################################    
    when 2941 #神殿とZ戦士とポポ
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,5,1 #天津飯
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      #picture = "顔カード"
      #rect = Rect.new(128, 64*12, 64, 64) # ポポ
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 2942 #神殿とポポ
      picture = "Z3_背景_天界"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output
    when 2943 #精神と時の部屋とZ戦士たち
      picture = "Z3_背景_精神と時の部屋"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 2951 #精神と時の部屋修行ます
      $scene = Scene_Db_Ryuha_Pair_Training.new
    #################################################################
    
                          ####　未来編 ####
    
    #################################################################
    when 3501 #悟飯自宅へ向かう
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3502 #悟飯自宅前へ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x-64*4,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # チャオズ
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*5, 64, 64) # 天津飯
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ヤムチャ
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*23, 64, 64) # ヤジロベー
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x+64*4,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス(赤ちゃん)
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
    when 3503 #悟飯自宅前へ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*11, 64, 64) # プーアル
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 3504 #悟空の家
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*35, 64, 64) # 牛魔王
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3505 #悟空の家(ゴクウを見る)
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*24, 64, 64) # 悟空死亡
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*2, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3506 #ピッコロ死亡
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3507 #ベジータ死亡
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3508 #ヤムチャ死亡
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*4, 64, 64) # ヤムチャ
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3509 #天津飯死亡
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*5, 64, 64) # テンシンハン
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3510 #チャオズ死亡
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*6, 64, 64) # チャオズ
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3511 #クリリン死亡
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*3, 64, 64) # クリリン
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3512 #クリリン死亡後
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
    when 3521 #1718号街破壊
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*0, 64, 64) # 男
      add_chr(@play_x+0,@play_y,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # 女
      add_chr(@play_x+64,@play_y,picture,rect)
      rect = Rect.new(0, 64*12, 64, 64) # 老人
      add_chr(@play_x-64,@play_y,picture,rect)
    when 3531 #亀仙人たち潜水艦
      picture = "顔カード"
      rect = Rect.new(128, 64*11, 64, 64) # プーアル
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x-96,@play_y,picture,rect)
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(128, 64*49, 64, 64) # ウミガメ
      add_chr(@play_x+96,@play_y,picture,rect)
    when 3541 #ブルマとトランクス
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x,@play_y,picture,rect)
    when 3542 #ブルマとトランクス(トランクス飛び立つ
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
    when 3543 #1718号 街
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
    when 3544 #1718号 街破壊
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
    when 3551 #トランクス
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x,@play_y,picture,rect)
    when 3552 #トランクスと悟飯
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # 悟飯
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3553 #トランクスと悟飯とブルマ
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # 悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
    when 3554 #トランクスと悟飯とごちそうを出す
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # 悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y-64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*74, 64, 64) # ごちそう
      add_chr(@ene1_x-0,@ene1_y-0,picture,rect)
    when 3555 #トランクスと悟飯とごちそうなくなる
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # 悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y-64,picture,rect)
    when 3561 #トランクスと悟飯修行
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # 悟飯
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3562 #チチと牛魔王
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*28, 64, 64) # 牛魔王
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*27, 64, 64) # チチ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3571 #トランクスと悟飯
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # 悟飯
      add_chr(@play_x-32,@play_y,picture,rect)
    when 3572 #トランクスと悟飯、17号18号
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # 悟飯
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
    when 3573 #悟飯、17号18号
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*30, 64, 64) # 悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
    when 3574 #悟飯、17号
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*30, 64, 64) # 悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
    when 3575 #超悟飯、17号
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*31, 64, 64) # 超悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
    when 3576 #超悟飯、17号　18号援護
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*31, 64, 64) # 超悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
    when 3577 #トランクス
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x,@play_y,picture,rect)
    when 3578 #トランクスと18号
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
    when 3579 #トランクスと18号ダメージ
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(64, 64*24, 64, 64) # 18号
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
    when 3580 #トランクスと18号(トランクスダメージ素材がないためそのままだが念の為用意)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
    when 3581 #トランクスと18号　悟飯助けに入る
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*31, 64, 64) # 超悟飯
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x,@play_y+64,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
    when 3582 #トランクスと18号　17号悟飯を追いかける
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*31, 64, 64) # 超悟飯
      add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x,@play_y+64,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
    when 3583 #18号　17号エネルギー波後
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
    when 3591 #悟飯瀕死
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*22, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3592 #悟飯瀕死仙豆
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*22, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*15, 64, 64) # 仙豆
      add_chr(@ene1_x,@ene1_y+0,picture,rect)
    when 3593 #悟飯瀕死仙豆トランクス
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*22, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*15, 64, 64) # 仙豆
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 3594 #悟飯瀕死トランクス
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*22, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 3601 #ブルマ作業
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 3602 #ブルマ作業トランクス戻る
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*22, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y+64,picture,rect)
    when 3603 #ブルマ作業トランクス
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3604 #トランクス悟飯痛む
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*22, 64, 64) # 悟飯
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3605 #悟飯トランクス修行
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*22, 64, 64) # 悟飯
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3606 #悟飯トランクス気絶させる
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*22, 64, 64) # 悟飯
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 3621 #17号18号見つける
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
    when 3622 #悟飯17号18号見つける
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*22, 64, 64) # 悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
    when 3631 #超悟飯対1718号
      battle_process (event_no)
    when 3641 #超悟飯17号18号見つける
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*23, 64, 64) # 超悟飯
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
    when 3651 #超悟飯たい17号18号
      set_battle_event
    when 3661 #トランクス
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3662 #トランクス悟飯の遺体を見つける
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*29, 64, 64) # トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
      rect = Rect.new(0, 64*25, 64, 64) # 悟飯遺体
      add_chr(@ene1_x+0,@ene1_y+0,picture,rect)
    when 3663 #トランクス超サイヤ人変身(素材がないので空にしておく)
      
    when 3671 #3年後トランクスとブルマ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 3672 #3年後トランクス飛び出す
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 3673 #トランクス
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3674 #超トランクス
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*17, 64, 64) # 超トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3675 #18号と17号
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
    when 3676 #超トランクスと18号と17号
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*17, 64, 64) # 超トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
    when 3677 #超トランクスと18号と17号
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*17, 64, 64) # 超トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3681 #超トランクス
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*17, 64, 64) # 超トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3682 #超トランクスと18号と17号
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*17, 64, 64) # 超トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
    when 3683 #トランクスと18号と17号
      picture = "Z3_顔味方"
      rect = Rect.new(64, 64*14, 64, 64) # トランクス
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
    when 3691 #ブルマとトランクス
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 3692 #タイムマシン発進
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@play_x+0+0,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*14, 64, 64) # トランクス
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 3693 #タイムマシン発進
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@play_x+0+0,@play_y,picture,rect)
    when 3694 #タイムマシン発進
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@play_x+0+0,@play_y,picture,rect)
      
    #################################################################
    
                          ####　未来トランクス編 ####
    
    #################################################################
    when 3801 #未来トランクス編
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+32,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-32,@ene1_y+0,picture,rect)
    when 3802 #タイムマシン到着前
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 3803 #タイムマシン到着
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
    when 3804 #トランクスとブルマ
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output
    when 3805 #トランクスとブルマ
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output
    when 3806 #トランクスとブルマ
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output
    when 3807 #1718号街破壊
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+64,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-64,@ene1_y+0,picture,rect)
    when 3808 #1718号街破壊トランクス到着
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+64,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-64,@ene1_y+0,picture,rect)
      character_output
    when 3809 #1718号街破壊トランクス18号の横へ移動
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+64,@ene1_y+0,picture,rect)
      rect = Rect.new(0, 64*24, 64, 64) # 18号
      add_chr(@ene1_x-64,@ene1_y+0,picture,rect)
      character_output 0,-128,-228
    when 3810 #1718号街破壊トランクス18号破壊
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+64,@ene1_y+0,picture,rect)
      character_output 0,-128,-228
    when 3811 #1718号街破壊トランクス17号ダメージ
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(64, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+64,@ene1_y+0,picture,rect)
      character_output 0,-128,-228
    when 3812 #1718号街破壊トランクス17号ダメージ横に移動
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(64, 64*25, 64, 64) # 17号
      add_chr(@ene1_x+64,@ene1_y+0,picture,rect)
      character_output 0,0,-228
    when 3813 #1718号街破壊トランクス18号の横へ移動
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,-228
    when 3814 #1718号街破壊トランクス18号の横へ移動
      picture = "Z3_背景_街"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,-228
    when 3821 #トランクスとブルマ
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*57, 64, 64) # ブルマ(未来編1718号撃破後)
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output
      #p $partyc[0],$game_switches[0],$game_switches[131],$game_switches[132]
    when 3822 #トランクス
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 3823 #トランクスとセル
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y+0,picture,rect)
      character_output
    when 3824 #トランクスセルふっとばす
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 3825 #トランクス飛び立つ
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 3826 #トランクスとセル草原
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y+0,picture,rect)
      character_output
    when 3827 #トランクスとセル草原(超サイヤ人変身)
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y+0,picture,rect)
      character_output
    when 3828 #トランクスとセルダメージ
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y+0,picture,rect)
      character_output
    when 3831 #トランクスとセルイベントバトル
      set_battle_event
    when 3841 #トランクスとセル
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y+0,picture,rect)
      character_output
    when 3842 #トランクスとセルダメージ
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*27, 64, 64) # セル
      add_chr(@ene1_x+0,@ene1_y+0,picture,rect)
      character_output
    when 3851 #トランクスとセルイベントバトル(ヒートドームアタック
      set_battle_event
    when 3861 #トランクスとセル戦闘後
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
    when 3862 #トランクスとセル戦闘後
      picture = "Z3_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output
      
    #################################################################
    
                       ####　熱戦烈戦超激戦 ####
    
    #################################################################
    when 5001 #界王星
      picture = "Z3_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5002 #悟空とチチ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@play_x+32,@play_y,picture,rect)
    when 5003 #亀仙人皿回し
      picture = "顔カード"
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x-0,@play_y,picture,rect)
      rect = Rect.new(128, 64*36, 64, 64) # ブリーフ博士
      add_chr(@play_x+128,@play_y,picture,rect)
      rect = Rect.new(128, 64*37, 64, 64) # ブルマの母
      add_chr(@play_x+64,@play_y,picture,rect)
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x-32,@play_y+64,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-128,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス(赤ちゃん)
      add_chr(@play_x+32,@play_y+64,picture,rect)
    when 5004 #クリリンカラオケ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64*4-32,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*9, 64, 64) # 亀仙人
      add_chr(@play_x+64*3-32,@play_y,picture,rect)
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@play_x+64*2-32,@play_y,picture,rect)
      rect = Rect.new(128, 64*36, 64, 64) # ブリーフ博士
      add_chr(@play_x-64*1+32,@play_y,picture,rect)
      rect = Rect.new(128, 64*37, 64, 64) # ブルマの母
      add_chr(@play_x-64*2+32,@play_y,picture,rect)
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x-64*4+32,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x+64*1-32,@play_y,picture,rect)
      
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス(赤ちゃん)
      add_chr(@play_x-64*3+32,@play_y,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0,@play_y+64,picture,rect)
      
    when 5005 #戦闘員到着
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      #rect = Rect.new(64, 64*49, 64, 64) # パラガス
      #add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*48, 64, 64) # 戦闘員
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
    when 5006 #パラガス到着
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*48, 64, 64) # 戦闘員
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
    when 5007 #クリリンカラオケ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5008 #悟空とチチ 面接
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*83, 64, 64) # おばさん
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*82, 64, 64) # おじさん
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
    when 5009 #界王星
      #picture = "Z3_背景_界王星"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
    when 5010 #悟空瞬間移動
      #picture = "Z3_顔味方"
      #rect = Rect.new(64, 64*0, 64, 64) # 悟空
      #add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@play_x+32,@play_y,picture,rect)
      rect = Rect.new(0, 64*83, 64, 64) # おばさん
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*82, 64, 64) # おじさん
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
    when 5011 #界王星
      picture = "Z3_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      #picture = "Z3_顔味方"
      #rect = Rect.new(64, 64*0, 64, 64) # 悟空
      #add_chr(@play_x-32,@play_y,picture,rect)
    when 5012 #界王星
      picture = "Z3_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
    when 5013 #パラガス到着
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*48, 64, 64) # 戦闘員
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
    when 5014 #パラガス到着トランクス
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*48, 64, 64) # 戦闘員
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x,@play_y+64,picture,rect)
    when 5015 #悟空惑星に到着
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
    when 5031 #パラガス新惑星ベジータ到着
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5032 #パラガス到着トランクス
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*48, 64, 64) # 戦闘員
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x,@play_y+64,picture,rect)
    when 5033 #パラガス到着トランクス
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x-32,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*50, 64, 64) # ブロリー
      add_chr(@ene1_x+32,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*48, 64, 64) # 戦闘員
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x,@play_y+64,picture,rect)
    when 5041 #悟飯クリリントランクス
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64,@play_y,picture,rect)
    when 5042 #悟飯クリリントランクス シャモ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 5043 #悟飯クリリントランクス シャモ、戦闘員
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x,@play_y+64,picture,rect)
      picture = "Z3_顔敵"
      #rect = Rect.new(0, 64*49, 64, 64) # パラガス
      #add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*48, 64, 64) # 戦闘員
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
    when 5044 #悟飯クリリントランクス シャモ、戦闘員 悟空到着
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x+32,@play_y+64,picture,rect)
      picture = "Z3_顔敵"
      #rect = Rect.new(0, 64*49, 64, 64) # パラガス
      #add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*48, 64, 64) # 戦闘員
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y+64,picture,rect)
    when 5045 #悟飯クリリントランクス シャモ、戦闘員パラガス
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x+32,@play_y+64,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*48, 64, 64) # 戦闘員
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y+64,picture,rect)
    when 5046 #パラガス悟空
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
    when 5047 #悟空
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
    when 5048 #悟飯クリリントランクス シャモ
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@ene1_x-0,@ene1_y-64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*74, 64, 64) # ごちそう
      add_chr(@ene1_x-0,@ene1_y-0,picture,rect)
    when 5049 #パラガス
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5061 #パラガスとベジータ
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x+0,@play_y+0,picture,rect)
    when 5062 #パラガスとベジータと悟空
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@play_x+32,@play_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x-32,@play_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5063 #パラガスとベジータと悟空とブロリー
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@play_x+32,@play_y+0,picture,rect)
      rect = Rect.new(0, 64*50, 64, 64) # ブロリー
      add_chr(@play_x,@play_y+64,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x-32,@play_y+0,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5064 #パラガス
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5065 #悟空赤ちゃんとブロリー赤ちゃん
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # ゴクウ赤ちゃん
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*59, 64, 64) # ブロリー赤ちゃん
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      picture = "Z2_顔敵"
      #rect = Rect.new(0, 64*1, 64, 64) # ロンメ
      #add_chr(@play_x,@play_y,picture,rect)
      rect = Rect.new(0, 64*4, 64, 64) # ネイブル
      add_chr(@play_x,@play_y,picture,rect)
    when 5066 #パラガス
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5067 #ブロリー
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*50, 64, 64) # ブロリー
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5068 #悟空
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
    when 5069 #悟空ブロリー
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*51, 64, 64) # ブロリー(超)
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5070 #悟空ブロリー
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*51, 64, 64) # ブロリー(超)
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5071 #悟空ブロリーパラガス
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*51, 64, 64) # ブロリー(超)
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
    when 5072 #悟空ブロリーパラガス
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*50, 64, 64) # ブロリー
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x+0,@ene1_y-64,picture,rect)
    when 5073 #悟空
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
    when 5081 #悟空ブロリーパラガス
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x,@play_y+0,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*50, 64, 64) # ブロリー
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
    when 5082 #悟空ブロリーパラガス
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*50, 64, 64) # ブロリー
      add_chr(@ene1_x+32,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x-32,@ene1_y-64,picture,rect)
    when 5083 #悟空ブロリーパラガストランクス
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*50, 64, 64) # ブロリー
      add_chr(@ene1_x+32,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x-32,@ene1_y-64,picture,rect)
    when 5084 #悟空ブロリーパラガストランクス
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*50, 64, 64) # ブロリー
      add_chr(@ene1_x+32,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x-32,@ene1_y-64,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x+64,@play_y+64,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x-64,@play_y+64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x,@play_y+64,picture,rect)
    when 5085 #悟空ブロリーパラガストランクス
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-0,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*50, 64, 64) # ブロリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x+64,@play_y+64,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x-64,@play_y+64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x,@play_y+64,picture,rect)
    when 5086 #悟空ブロリー(超)パラガストランクス
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-0,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x-64,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*51, 64, 64) # ブロリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x+64,@play_y+64,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x-64,@play_y+64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x,@play_y+64,picture,rect)
    when 5087 #悟空ブロリー(超)パラガストランクスピッコロ
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect = Rect.new(0, 64*1, 64, 64) # ピッコロ
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*18, 64, 64) # トランクス長髪
      add_chr(@play_x+96,@play_y,picture,rect)
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*9, 64, 64) # ベジータ
      add_chr(@play_x-96,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*51, 64, 64) # ブロリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*3, 64, 64) # クリリン
      add_chr(@play_x+64,@play_y+64,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x-64,@play_y+64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x,@play_y+64,picture,rect)
    when 5101 #ブロリー(超)戦闘前
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*51, 64, 64) # ブロリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output_all 0,0,0,21
    when 5111 #ブロリー(超)戦闘
      battle_process (event_no)
    when 5121 #ブロリー(超)戦闘後
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*51, 64, 64) # ブロリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output_all 0,0,0,21
    when 5122 #ブロリー(フルパワー)変身
      picture = "Z3_背景_パラガスの宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*52, 64, 64) # ブロリー(フルパワー)
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*49, 64, 64) # パラガス
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*58, 64, 64) # シャモ
      add_chr(@play_x,@play_y+64,picture,rect)
      character_output_all 0,0,0,21
    when 5123 #ベジータ王過去回想
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*11, 64, 64) # ベジータ王
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*4, 64, 64) # オニオン
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # ブロッコ
      add_chr(@play_x-64*0,@play_y,picture,rect)
      rect = Rect.new(0, 64*5, 64, 64) # パンプキン
      add_chr(@play_x+64*1,@play_y,picture,rect)
    when 5124 #ベジータ王過去回想(パラガス現れる
      picture = "Z2_顔イベント"
      rect = Rect.new(0, 64*11, 64, 64) # ベジータ王
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z1_顔敵"
      rect = Rect.new(0, 64*4, 64, 64) # オニオン
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect = Rect.new(0, 64*6, 64, 64) # ブロッコ
      add_chr(@play_x-64*0,@play_y,picture,rect)
      rect = Rect.new(0, 64*5, 64, 64) # パンプキン
      add_chr(@play_x+64*1,@play_y,picture,rect)
    when 5131 #ブロリー(フルパワー)戦闘
      battle_process (event_no)
    when 5141 #界王星
      picture = "Z3_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 5142 #悟空と悟飯戻ってくる
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟空
      add_chr(@play_x+32,@play_y,picture,rect)
    when 5143 #悟空と悟飯戻ってくるチチ現れる
      picture = "Z3_顔味方"
      rect = Rect.new(0, 64*0, 64, 64) # 悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      picture = "Z3_顔味方_衣替え"
      rect = Rect.new(0, 64*8, 64, 64) # 悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*17, 64, 64) # チチ
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
      
    #################################################################
    
                       ####　銀河ギリギリ!!ぶっちぎりの凄い奴 ####
    
    #################################################################
    when 5501 #銀河ギリギリ!!ぶっちぎりの凄い奴 サタン
      #picture = "Z3_背景_セルゲームリング"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,28,1 #サタン
      add_chr(@play_x+0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*10, 64, 64) # アナウンサー
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 5502 #悟飯、クリリン、トランクス
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 5503 #悟飯、クリリン、トランクス、Z戦士合流
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64,@play_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+64,@play_y,picture,rect)
      
      rect,picture = set_character_face 0,4,1 #ヤムチャ
      add_chr(@ene1_x-64*3,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,5,1 #天津飯
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@ene1_x+64*3,@ene1_y,picture,rect)
    when 5511 #ブージンとゴクア
      #picture = "Z3_背景_草原"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,22
      
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*47, 64, 64) # ブージン
      add_chr(@ene1_x -48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*44, 64, 64) # ゴクア
      add_chr(@ene1_x +48,@ene1_y,picture,rect)
    when 5516 #ブージンとゴクア戦闘
      battle_process (event_no)
    when 5521 #ブージンとゴクア(撃破)
      #picture = "Z3_背景_草原"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,22
      
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*47, 64, 64) # ブージン
      add_chr(@ene1_x -48,@ene1_y,picture,rect)
      rect = Rect.new(1*64, 64*44, 64, 64) # ゴクア
      add_chr(@ene1_x +48,@ene1_y,picture,rect)
    when 5522 #ブージンとゴクア(撃破)
      character_output_all 0,0,0,22
    when 5531 #ザンギャとビドー
      #picture = "Z3_背景_草原"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,22
      
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*45, 64, 64) # ザンギャ
      add_chr(@ene1_x -48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*46, 64, 64) # ビドー
      add_chr(@ene1_x +48,@ene1_y,picture,rect)
    when 5536 #ザンギャとビドー戦闘
      battle_process (event_no)
    when 5541 #ザンギャとビドー(撃破)
      #picture = "Z3_背景_草原"
      #rect = Rect.new(0, 0, 512, 128) # 背景
      #add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,22
      
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*45, 64, 64) # ザンギャ
      add_chr(@ene1_x -48,@ene1_y,picture,rect)
      rect = Rect.new(1*64, 64*46, 64, 64) # ビドー
      add_chr(@ene1_x +48,@ene1_y,picture,rect)
    when 5542 #ザンギャとビドー(撃破)
      character_output_all 0,0,0,22
    when 5551 #ブージンとゴクア、ザンギャとビドー両方撃破
      character_output_all 0,0,0,22
    when 5571 #ボージャック一味
      character_output_all 0,0,0,22
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*42, 64, 64) # ボージャック
      add_chr(@ene1_x -0,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*45, 64, 64) # ザンギャ
      add_chr(@ene1_x -64,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*44, 64, 64) # ゴクア
      add_chr(@ene1_x -128,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*46, 64, 64) # ビドー
      add_chr(@ene1_x +64,@ene1_y,picture,rect)
      rect = Rect.new(0*64, 64*47, 64, 64) # ブージン
      add_chr(@ene1_x +128,@ene1_y,picture,rect)
    when 5576 #ボージャック一味戦闘
      battle_process (event_no)
    when 5581 #ボージャック一味(撃破)
      character_output_all 0,0,0,22
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*42, 64, 64) # ボージャック
      add_chr(@ene1_x -0,@ene1_y,picture,rect)
    when 5582 #ボージャック一味(撃破)
      character_output_all 0,0,0,22
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*42, 64, 64) # ボージャック
      add_chr(@ene1_x -0,@ene1_y,picture,rect)
    when 5583 #ボージャック一味(撃破)
      character_output_all 0,0,0,22
      picture = "Z3_顔敵"
      rect = Rect.new(0*64, 64*43, 64, 64) # ボージャック(フルパワー)
      add_chr(@ene1_x -0,@ene1_y,picture,rect)
    when 5584 #ボージャック悟空登場
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
    
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x -0,@ene1_y,picture,rect)
    when 5591 #ボージャックフルパワー戦闘
      battle_process (event_no)
    when 5601 #ボージャックフルパワー(撃破)
      picture = "Z3_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x -48,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 5602 #ボージャックフルパワー(撃破)病院
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+64*0,@play_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,5,1 #天津飯
      add_chr(@play_x+64*2,@play_y,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@play_x-64*2,@play_y,picture,rect)
      
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*16, 64, 64) # トランクス(赤ちゃん)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*20, 64, 64) # ウーロン
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
    when 5611 #ボージャック編あらすじ表示用
      character_output_all 0,0,0,22
    when 5612 #ボージャック編あらすじ表示用2
      picture = "Z3_顔敵"
      rect = Rect.new(1*64, 64*45, 64, 64) # ザンギャ
      add_chr(@ene1_x -96,@ene1_y,picture,rect)
      rect = Rect.new(1*64, 64*46, 64, 64) # ビドー
      add_chr(@ene1_x -32,@ene1_y,picture,rect)
      rect = Rect.new(1*64, 64*47, 64, 64) # ブージン
      add_chr(@ene1_x +32,@ene1_y,picture,rect)
      rect = Rect.new(1*64, 64*44, 64, 64) # ゴクア
      add_chr(@ene1_x +96,@ene1_y,picture,rect)
      character_output_all 0,0,0,22
   #################################################################
    
                  ####　エピソードオブバーダック ####
    
    #################################################################
    when 5701 #バーダック対フリーザ
      picture = "Z2_背景_フリーザ"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5702 #バーダック対フリーザ(デスボール)
      picture = "Z2_背景_フリーザ_デスボール"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5703 #バーダック対フリーザ(デスボール)放つ
      picture = "Z2_背景_フリーザ_デスボール"
      rect = Rect.new(0, 0, 216, 170) # 背景
      add_chr(640-432+4,0+4,picture,rect)
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(640-432+4-64,0+4+54,picture,rect)
      #picture = "Z2_顔敵"
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(640-432+4+216,0+4+54,picture,rect)
      #character_output
      rect,picture = set_character_face 1,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5711 #バーダック起きるプラント星
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
    when 5712 #バーダック起きるプラント星イパナとベリー
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
    when 5721 #トビーとキャビラとプラント人
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*73, 64, 64) # キャビラ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*74, 64, 64) # トビー
      add_chr(@ene1_x+48,@ene1_y,picture,rect)

    when 5722 #トビーとキャビラとプラント人、バーダック現れる
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*73, 64, 64) # キャビラ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*74, 64, 64) # トビー
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
    when 5723 #トビーとキャビラとプラント人、バーダック現れる、倒す
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)

    when 5724 #バーダックとプラント人1
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*66, 64, 64) # プラント人大人
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      #add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      #add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      #rect = Rect.new(0, 64*65, 64, 64) # プラント人中ぐらい
      #add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      #add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
    when 5725 #バーダックとプラント人3
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*66, 64, 64) # プラント人大人
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      #rect = Rect.new(0, 64*65, 64, 64) # プラント人中ぐらい
      #add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      #add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
    when 5726 #バーダックとプラント人5
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*66, 64, 64) # プラント人大人
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*65, 64, 64) # プラント人中ぐらい
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
    when 5727 #バーダックとプラント人5、バーダック飛び去る
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      #rect,picture = set_character_face 0,13,1 #バーダック
      #add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*66, 64, 64) # プラント人大人
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*65, 64, 64) # プラント人中ぐらい
      add_chr(@ene1_x+64*2,@ene1_y,picture,rect)
      add_chr(@ene1_x-64*2,@ene1_y,picture,rect)
    when 5741 #バーダックと洞窟
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
    when 5742 #バーダックと洞窟 ベリーとごちそう
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*74, 64, 64) # ごちそう
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 5743 #バーダックと洞窟 ごちそうベリー去る
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      #picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*64, 64, 64) # ベリー
      #add_chr(@ene1_x,@ene1_y-64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*74, 64, 64) # ごちそう
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 5744 #バーダックと洞窟 ごちそう食べきるベリーが見る
      #rect,picture = set_character_face 0,13,1 #バーダック
      #add_chr(@play_x+64*0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*77, 64, 64) # ごちそう空
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5745 #バーダックと洞窟
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5746 #バーダックと洞窟 ベリーとごちそう
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@ene1_x,@ene1_y-64,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*74, 64, 64) # ごちそう
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 5751 #チルド宇宙船 チルドのみ
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 5752 #チルド宇宙船 チルド、チルドの部下
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*72, 64, 64) # チルドの部下(アプールっぽいやつ)
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5753 #プラント星 チルドとプラント人
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*75, 64, 64) # チルドの部下(黄緑魚)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*76, 64, 64) # チルドの部下(エメラルド魚)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x+64*0,@play_y,picture,rect)
      rect = Rect.new(0, 64*66, 64, 64) # プラント人大人
      add_chr(@play_x+64*1,@play_y,picture,rect)
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect = Rect.new(0, 64*65, 64, 64) # プラント人中ぐらい
      add_chr(@play_x+64*2,@play_y,picture,rect)
      add_chr(@play_x-64*2,@play_y,picture,rect)
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@play_x+64*0,@play_y+64,picture,rect)
    when 5761 #バーダックと洞窟
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5762 #バーダックと洞窟ベリー現れる
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 5763 #バーダックと洞窟ベリー現れる
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      rect,picture = set_character_face 1,24,1 #トーマ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect,picture = set_character_face 1,25,1 #セリパ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect,picture = set_character_face 1,26,1 #トテッポ
      add_chr(@ene1_x-32-64,@ene1_y,picture,rect)
      rect,picture = set_character_face 1,27,1 #パンブーキン
      add_chr(@ene1_x+32+64,@ene1_y,picture,rect)
    when 5764 #バーダックと洞窟バーダック飛び立つ
      #rect,picture = set_character_face 0,13,1 #バーダック
      #add_chr(@play_x+64*0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 5771 #プラント星 チルドとイパナ
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*75, 64, 64) # チルドの部下(黄緑魚)
      add_chr(@ene1_x-64*1,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*76, 64, 64) # チルドの部下(エメラルド魚)
      add_chr(@ene1_x+64*1,@ene1_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5772 #プラント星 チルドとイパナ
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      #picture = "Z3_顔敵"
      #rect = Rect.new(0, 64*138, 64, 64) # チルド
      #add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*75, 64, 64) # チルドの部下(黄緑魚)
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*76, 64, 64) # チルドの部下(エメラルド魚)
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5773 #プラント星 チルドとイパナ バーダック現れる
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      #picture = "Z3_顔敵"
      #rect = Rect.new(0, 64*138, 64, 64) # チルド
      #add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*75, 64, 64) # チルドの部下(黄緑魚)
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*76, 64, 64) # チルドの部下(エメラルド魚)
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x+64*0,@play_y+64,picture,rect)
    when 5774 #プラント星 チルドとイパナ　チルドの部下を倒す
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      #picture = "Z3_顔敵"
      #rect = Rect.new(0, 64*138, 64, 64) # チルド
      #add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      #picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*75, 64, 64) # チルドの部下(黄緑魚)
      #add_chr(@ene1_x+48,@ene1_y,picture,rect)
      #rect = Rect.new(0, 64*76, 64, 64) # チルドの部下(エメラルド魚)
      #add_chr(@ene1_x-48,@ene1_y,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x+64*0,@play_y+64,picture,rect)
    when 5775 #プラント星 チルドとイパナ　チルド現れる
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x+64*0,@play_y+64,picture,rect)
    when 5776 #プラント星 チルドとイパナ　チルド現れる フリーザとかぶる
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x+64*0,@play_y+64,picture,rect)
    when 5777 #プラント星 チルドとイパナ　チルド殴られる
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y-32,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x+64*0,@play_y+64,picture,rect)
    when 5778 #プラント星 チルドとイパナ　チルド殴る
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 1,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x+64*0,@play_y+64,picture,rect)
    when 5779 #プラント星 チルドとイパナ　イパナが前に出る
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 1,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y+64,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5780 #プラント星 チルドとイパナ　イパナが殴られる
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 1,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y+64,picture,rect)
      
      #picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*63, 64, 64) # イパナ
      #add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5781 #ベリーがイパナを見る
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*78, 64, 64) # イパナ(殴られる)
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5782 #プラント星 チルドとイパナ　ベリー現れる
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 1,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y+64,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5783 #プラント星 バーダック超サイヤ人変身前
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5791 #プラント星 バーダック超サイヤ人変身後
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,29,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5792 #プラント星 バーダック超チルド攻撃後
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      #rect,picture = set_character_face 0,29,1 #バーダック
      #add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5801 #チルドイベント戦闘
      set_battle_event
    when 5811 #プラント星 イベント戦闘後
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(64, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,29,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5812 #プラント星 イベント戦闘後
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "Z3_顔敵"
      rect = Rect.new(64, 64*138, 64, 64) # チルド
      add_chr(@ene1_x+64*0,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*72, 64, 64) # チルドの部下(アプールっぽいやつ)
      add_chr(@ene1_x+64*0,@ene1_y-64,picture,rect)
      rect,picture = set_character_face 0,29,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5813 #プラント星 チルド逃げる
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      rect,picture = set_character_face 0,29,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5814 #プラント星 チルド逃げる(超サイヤ人解く)
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5815 #ベリーとイパナ
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*78, 64, 64) # イパナ(殴られる)
      add_chr(@ene1_x+64*0-48,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*79, 64, 64) # ベリー(殴られる)
      add_chr(@ene1_x+64*0+48,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 5816 #ベリーとイパナ気が付く
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
   #################################################################
    
                  ####　外伝 サイヤ人絶滅計画 ####
    
    #################################################################
    when 6001 #ライチー(不明)がしゃべる
      picture = "ZG_背景_怨念増幅装置(影)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # 人影
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6002 #悟空の家 悟空、悟飯
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
    when 6003 #悟空の家 悟空、悟飯、ポポ
      picture = "ZG_背景_ゴクウの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6004 #ブルマの家
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 6005 #グランドアポロン
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 6006 #砂漠とピラミッド
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*35, 64, 64) # ピラミッド
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6007 #ブンブク島
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 6008 #氷の大陸
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 6009 #ブルマの家
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 6010 #ブルマの家、ピッコロ現れる
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+32,@play_y,picture,rect)
      
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-80,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+80,@ene1_y,picture,rect)
    when 6011 #ブルマの家、敵が現れる
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
      
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x-32,@play_y+64,picture,rect)
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@play_x+32,@play_y+64,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*59, 64, 64) # アービー
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*55, 64, 64) # キンカーン
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 6012 #草原へ移動
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*59, 64, 64) # アービー
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*55, 64, 64) # キンカーン
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 6013 #草原へ移動、超サイヤ人変身
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,11,1 #悟空(超)
      add_chr(@play_x-64,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+64,@play_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*59, 64, 64) # アービー
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*55, 64, 64) # キンカーン
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 6021 #アービー、キンカーン戦闘
      battle_process (event_no)
    when 6031 #戦闘後
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+64,@play_y,picture,rect)
    when 6032 #ブルマの家、ピッコロ現れる
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+64,@play_y,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
    when 6033 #ブルマの家、トランクス現れる
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+0,@play_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+64,@play_y,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-80,@ene1_y,picture,rect)
      rect = Rect.new(128, 64*12, 64, 64) # ポポ
      add_chr(@ene1_x+80,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+0,@ene1_y,picture,rect)
    when 6034 #ブルマの家、タイムマシン改修完了
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-96,@play_y,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-32,@play_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+32,@play_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+96,@play_y,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      
    when 6035 #ブルマの家、タイムマシン改修乗り込む
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-32,@play_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+32,@play_y,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+0,@play_y+64,picture,rect)
    when 6036 #ブルマの家、タイムマシン使用後
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-32,@play_y,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+32,@play_y,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@play_x+0,@play_y+64,picture,rect)
    when 6041 #プラント星
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 6042 #プラント星 タイムマシン到着
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
    when 6043 #プラント星 タイムマシン到着、タイムマシンから出る
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
    when 6044 #プラント星 タイムマシン到着、タイムマシンから出る、プラント人
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*66, 64, 64) # プラント人大人
      add_chr(@play_x+64*0,@play_y,picture,rect)
    when 6045 #プラント星 タイムマシン到着、タイムマシンから出る、プラント人、イパナ
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*66, 64, 64) # プラント人大人
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x-64*0,@play_y,picture,rect)
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@play_x+64*1,@play_y,picture,rect)
    when 6046 #プラント星 タイムマシン到着、タイムマシンから出る、プラント人、イパナ、ベリー抜ける
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*66, 64, 64) # プラント人大人
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x-64*0,@play_y,picture,rect)
      #rect = Rect.new(0, 64*64, 64, 64) # ベリー
      #add_chr(@play_x+64*1,@play_y,picture,rect)
    when 6047 #バーダックと洞窟ベリー現れる
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6048 #バーダックが悟空たちの前に現れる
      picture = "Z3_背景_惑星プラント"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*66, 64, 64) # プラント人大人
      add_chr(@play_x-64*1,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*63, 64, 64) # イパナ
      add_chr(@play_x-64*0,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*64, 64, 64) # ベリー
      add_chr(@play_x+64*1,@play_y+64,picture,rect)
      rect = Rect.new(0, 64*65, 64, 64) # プラント人中ぐらい
      add_chr(@play_x+64*2,@play_y+64,picture,rect)
      add_chr(@play_x-64*2,@play_y+64,picture,rect)
    when 6061 #バーダック一味
      character_output
    when 6071 #バーダック一味
      character_output
    when 6081 #ターレス軍
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*39, 64, 64) # ラカセイ
      add_chr(@ene1_x-32-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*35, 64, 64) # アモンド
      add_chr(@ene1_x-32-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*29, 64, 64) # ターレス
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*36, 64, 64) # ダイーズ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*37, 64, 64) # カカオ
      add_chr(@ene1_x+32+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*38, 64, 64) # レズン
      add_chr(@ene1_x+32+128,@ene1_y,picture,rect)    
      character_output
    when 6086 #ターレス軍戦闘
      battle_process (event_no)
    when 6091 #ターレス軍撃破
      picture = "Z2_顔敵"
      rect = Rect.new(64, 64*39, 64, 64) # ラカセイ
      add_chr(@ene1_x-32-128,@ene1_y,picture,rect)
      rect = Rect.new(64, 64*35, 64, 64) # アモンド
      add_chr(@ene1_x-32-64,@ene1_y,picture,rect)
      rect = Rect.new(64, 64*29, 64, 64) # ターレス
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(64, 64*36, 64, 64) # ダイーズ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(64, 64*37, 64, 64) # カカオ
      add_chr(@ene1_x+32+64,@ene1_y,picture,rect)
      rect = Rect.new(64, 64*38, 64, 64) # レズン
      add_chr(@ene1_x+32+128,@ene1_y,picture,rect)
      character_output
    when 6092 #ターレスの元飛び立つ
      character_output
    when 6096 #スラッグ軍が居る星に到着
      character_output
    when 6111 #スラッグ軍
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*42, 64, 64) # アンギラ
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*43, 64, 64) # ドロタボ
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # スラッグ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*44, 64, 64) # メダマッチャ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*45, 64, 64) # ゼウエン
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      character_output
    when 6116 #スラッグ軍戦闘
      battle_process (event_no)
    when 6121 #スラッグ軍撃破
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*42, 64, 64) # アンギラ
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*43, 64, 64) # ドロタボ
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # スラッグ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*44, 64, 64) # メダマッチャ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*45, 64, 64) # ゼウエン
      add_chr(@ene1_x+128,@ene1_y,picture,rect)  
      character_output
    when 6122 #スラッグ軍撃破 トーマたち飛び立つ
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*42, 64, 64) # アンギラ
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*43, 64, 64) # ドロタボ
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*30, 64, 64) # スラッグ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*44, 64, 64) # メダマッチャ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*45, 64, 64) # ゼウエン
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
    when 6131 #フリーザのもとに到着
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
    when 6132 #フリーザのもとに到着 トーマたち現れる
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      character_output
    when 6133 #フリーザのもとに到着 ドドリア、ザーボン前に
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x-0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      character_output
    when 6134 #フリーザのもとに到着 バーダックたち到着
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x-0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+64*1,@play_y,picture,rect)
      character_output 0,0,64
    when 6135 #フリーザのもとに到着 ドドリアたちを撃破
      picture = "Z2_顔敵"
      rect = Rect.new(0, 64*23, 64, 64) # フリーザ
      add_chr(@ene1_x-0,@ene1_y-64,picture,rect)
      #rect = Rect.new(0, 64*13, 64, 64) # ドドリア
      #add_chr(@ene1_x-32,@ene1_y,picture,rect)
      #rect = Rect.new(0, 64*15, 64, 64) # ザーボン
      #add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+64*1,@play_y,picture,rect)
      character_output 0,0,64
    when 6136 #フリーザフルパワー
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*1, 64, 64) # フリーザフルパワー
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+64*1,@play_y,picture,rect)
      character_output 0,0,64
    when 6137 #フリーザフルパワー、バーダック超サイヤ人変身
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*1, 64, 64) # フリーザフルパワー
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,29,1 #バーダック
      add_chr(@play_x+64*0,@play_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+64*1,@play_y,picture,rect)
      character_output 0,0,64
    when 6138 #フリーザフルパワー、バーダック超サイヤ人変身、位置変更
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*1, 64, 64) # フリーザフルパワー
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32*1,@play_y+64,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+32*1,@play_y+64,picture,rect)
      character_output 0,0,0
    when 6141 #フリーザ戦闘
      battle_process (event_no)
    when 6151 #フリーザフルパワー撃破後
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32*1,@play_y+64,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+32*1,@play_y+64,picture,rect)
      character_output 0,0,0
    when 6152 #フリーザフルパワー撃破後、元の時代に戻ってくる
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      character_output 0,0,0
    when 6153 #クリリン現れる
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6154 #クリリン現れる、トランクス離れる
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6155 #トランクスとブルマ
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x+0,@play_y,picture,rect)
    when 6156 #悟空とピッコロ
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x+0,@play_y,picture,rect)
    when 6157 #タイムマシンとトランクスと悟空
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x+0,@play_y,picture,rect)
    when 6158 #タイムマシンとトランクスと悟空乗り込む
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)

    when 6159 #タイムマシン動作後
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
    when 6171 #未来に到着  
      character_output 0,0,0
    when 6172 #未来に到着、ブルマの家
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6173 #ブルマの家、悟飯到着
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,22,1 #悟飯
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6174 #ブルマの家、みんな飛び出す
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*26, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6175 #タイムマシン現在到着
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      character_output 0,0,0
    when 6176 #ブルマの家
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,20,1 #16号
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6177 #ブルマの家
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6178 #グランドアポロン 悟空たち
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6181 #グランドアポロン 村
      picture = "ZG_背景_町2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6182 #グランドアポロン 村 おじさん
      picture = "ZG_背景_町2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*12, 64, 64) # おじさん
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6183 #グランドアポロン 村 子ども
      picture = "ZG_背景_町2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # 子ども
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
     when 6201 #グランドアポロン デストロンガス発生装置(卵)
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*36, 64, 64) # 卵
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6202 #グランドアポロン デストロンガス発生装置(卵) 鳥とあった後
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*38, 64, 64) # 岩
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6203 #グランドアポロン デストロンガス発生装置発見
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*37, 64, 64) # デストロンガス発生装置
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6204 #グランドアポロン デストロンガス発生装置発見 ボス現れる
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*37, 64, 64) # デストロンガス発生装置
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*19, 64, 64) # サウザー
      add_chr(@ene1_x,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*16, 64, 64) # ドーレ
      add_chr(@ene1_x-64,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ネイズ
      add_chr(@ene1_x+64,@ene1_y+32,picture,rect)
      
      character_output 0,0,0
    when 6206 #グランドアポロン編ボスと戦闘
      battle_process (event_no)
    when 6211 #グランドアポロン 鳥の巣
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6212 #グランドアポロン 鳥の巣 鳥到着
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*49, 64, 64) # 鳥
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6221 #グランドアポロン ボス撃破 デストロンガス発生装置の破壊
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*37, 64, 64) # デストロンガス発生装置
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6222 #グランドアポロン ボス撃破 デストロンガス発生装置の破壊後
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6223 #西の砂漠の悟飯たち
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6231 #西の砂漠 村
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6232 #西の砂漠 村 お爺さん
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*48, 64, 64) # お爺さん
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6236 #西の砂漠 村 おじさん
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*12, 64, 64) # おじさん
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0

    when 6241 #西の砂漠 ピラミッドの外
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*35, 64, 64) # ピラミッド
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6242 #西の砂漠 ピラミッドの中(暗い)
      picture = "ZG_背景_洞窟6"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6243 #西の砂漠 ピラミッドの中(明るい)のと壁画
      picture = "ZG_背景_洞窟1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*39, 64, 64) # 壁画
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6251 #西の砂漠 ボスがいるピラミッドの外
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6252 #西の砂漠 ボスがいるピラミッドの外
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*35, 64, 64) # ピラミッド
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6253 #西の砂漠 ボスがいるピラミッドの中
      picture = "ZG_背景_洞窟1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6254 #西の砂漠 ボスがいるピラミッドの中 ミイラ女
      picture = "ZG_背景_洞窟1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*34, 64, 64) # ミイラ女
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6255 #西の砂漠 ボスがいるピラミッドの中 女の子元に戻る
      picture = "ZG_背景_洞窟1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*42, 64, 64) # 女の子
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6256 #西の砂漠 ボスがいるピラミッドの外岩発見
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*38, 64, 64) # 岩
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*42, 64, 64) # 女の子
      add_chr(@play_x+0,@play_y+64,picture,rect)
      character_output 0,0,0
    when 6257 #西の砂漠 ボスがいるピラミッドの外デストロンガス発生装置発見
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*37, 64, 64) # デストロンガス発生装置
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*42, 64, 64) # 女の子
      add_chr(@play_x+0,@play_y+64,picture,rect)
      character_output 0,0,0
    when 6258 #西の砂漠 ボスがいるピラミッドの外デストロンガス発生装置発見 ボス発見
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*121, 64, 64) # ラカセイ
      add_chr(@ene1_x-32-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*117, 64, 64) # アモンド
      add_chr(@ene1_x-32-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*133, 64, 64) # ターレス
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*118, 64, 64) # ダイーズ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*119, 64, 64) # カカオ
      add_chr(@ene1_x+32+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*120, 64, 64) # レズン
      add_chr(@ene1_x+32+128,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*42, 64, 64) # 女の子
      add_chr(@play_x+0,@play_y+64,picture,rect)
      character_output 0,0,0
    when 6261 #西の砂漠編ボスと戦闘
      battle_process (event_no)
    when 6271 #西の砂漠 ボスがいるピラミッドの外 ボス撃破
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*37, 64, 64) # デストロンガス発生装置
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*42, 64, 64) # 女の子
      add_chr(@play_x+0,@play_y+64,picture,rect)
      character_output
    when 6272 #西の砂漠 ボスがいるピラミッドの外デストロンガス発生装置破壊後
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*42, 64, 64) # 女の子
      add_chr(@play_x+0,@play_y+64,picture,rect)
      character_output 0,0,0
    when 6273 #西の砂漠 ボスがいるピラミッドの外 女の子帰る
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*42, 64, 64) # 女の子
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6274 #ブンブク島 開始
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6281 #ブンブク島 村
      picture = "ZG_背景_町1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6282 #ブンブク島 村 お姉さん
      picture = "ZG_背景_町1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*33, 64, 64) # お姉さん
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6286 #西の砂漠 村 男の子
      picture = "ZG_背景_町1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # 男の子
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6291 #ブンブク島 洞穴
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6292 #ブンブク島 洞穴中　カワーズ
      picture = "ZG_背景_洞窟4"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*58, 64, 64) # カワーズ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6293 #ブンブク島 洞穴中
      picture = "ZG_背景_洞窟4"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6296 #ブンブク島 鉱山
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6301 #ブンブク島 ピラフの別荘
      picture = "ZG_背景_ピラフの別荘"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6311 #ブンブク島 火山
      picture = "ZG_背景_溶岩"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6312 #ブンブク島 火山 フリーズカプセル後(デストロンガス発生装置発見
      picture = "ZG_背景_溶岩2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*37, 64, 64) # デストロンガス発生装置
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6313 #ブンブク島 火山 フリーズカプセルカワーズ
      picture = "ZG_背景_溶岩2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*58, 64, 64) # カワーズ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6316 #ブンブク島 火山 カワーズ戦闘
      battle_process (event_no)
    when 6321 #ブンブク島 火山 カワーズ撃破後
      picture = "ZG_背景_溶岩2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6322 #ブンブク島 火山 スラッグ登場
      picture = "ZG_背景_溶岩2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*124, 64, 64) # アンギラ
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*125, 64, 64) # ドロタボ
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*155, 64, 64) # スラッグ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*126, 64, 64) # メダマッチャ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*127, 64, 64) # ゼウエン
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6326 #ブンブク島 火山 スラッグ戦闘
      battle_process (event_no)
    when 6331 #ブンブク島 火山 スラッグ撃破後
      picture = "ZG_背景_溶岩2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6332 #氷の大陸(海)
      picture = "ZG_背景_海"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6333 #デンデの神殿
      picture = "ZG_背景_神殿"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(192, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #character_output 0,0,0
    when 6334 #ライチー(不明)がしゃべる
      picture = "ZG_背景_怨念増幅装置(影)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # 人影
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6341 #氷の大陸 洪水マシン
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*40, 64, 64) # 洪水マシン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6342 #氷の大陸 洪水マシン キュイ
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*146, 64, 64) # キュイ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6346 #氷の大陸 洪水マシン キュイ戦闘
      battle_process (event_no)
    when 6351 #氷の大陸 洪水マシン キュイ撃破
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(64, 64*146, 64, 64) # キュイ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6352 #氷の大陸 洪水マシン
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*40, 64, 64) # 洪水マシン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6353 #氷の大陸 洪水マシン破壊
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      character_output 0,0,0
      
    when 6361 #氷の大陸 永久氷壁
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*41, 64, 64) # 永久氷壁
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6362 #氷の大陸 永久氷壁 フリーザとキュイ
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(64, 64*146, 64, 64) # キュイ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*143, 64, 64) # フリーザ
      add_chr(@ene1_x-0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*144, 64, 64) # ドドリア
      add_chr(@ene1_x-64,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*145, 64, 64) # ザーボン
      add_chr(@ene1_x+64,@ene1_y-64,picture,rect)
      
      character_output 0,0,0
    when 6363 #氷の大陸 永久氷壁 フリーザ
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*143, 64, 64) # フリーザ
      add_chr(@ene1_x-0,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*144, 64, 64) # ドドリア
      add_chr(@ene1_x-64,@ene1_y-64,picture,rect)
      rect = Rect.new(0, 64*145, 64, 64) # ザーボン
      add_chr(@ene1_x+64,@ene1_y-64,picture,rect)
      
      character_output 0,0,0
    when 6371 #氷の大陸 永久氷壁 フリーザ戦闘
      battle_process (event_no)
    when 6381 #氷の大陸 永久氷壁 フリーザ撃破
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*41, 64, 64) # 永久氷壁
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6382 #氷の大陸 永久氷壁 永久氷壁破壊
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*37, 64, 64) # デストロンガス発生装置
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output 0,0,0
    when 6383 #氷の大陸 永久氷壁 デストロンガス発生装置の破壊
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output 0,0,0
    when 6391 #デストロンガス発生装置を4つ破壊後合流
      character_output_all 0,0,0,26
    when 6392 #デンデの神殿
      picture = "ZG_背景_神殿"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(192, 64*14, 64, 64) # デンデ
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6401 #西の都 トンガリタワー
      picture = "ZG_背景_都"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*14, 64, 64) # トンガリタワー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6402 #西の都 トンガリタワー フリーザたち登場
      picture = "ZG_背景_都"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*143, 64, 64) # フリーザ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*155, 64, 64) # スラッグ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*133, 64, 64) # ターレス
      add_chr(@ene1_x-32-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x+32+64,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6403 #西の都 トンガリタワー フリーザたち登場 草原に移動
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*143, 64, 64) # フリーザ
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*155, 64, 64) # スラッグ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*133, 64, 64) # ターレス
      add_chr(@ene1_x-32-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x+32+64,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6404 #ライチー(不明)がしゃべる
      picture = "ZG_背景_怨念増幅装置(影)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # 人影
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6405 #界王様
      picture = "ZG_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(64*2, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6411 #西の都フリーザたち戦闘
      battle_process (event_no)
    when 6421 #フリーザたち撃破
      picture = "ZG_背景_都"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*14, 64, 64) # トンガリタワー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      #picture = "Z3_顔敵"
      #rect = Rect.new(64, 64*143, 64, 64) # フリーザ
      #add_chr(@ene1_x-0,@ene1_y,picture,rect)
      #add_chr(@ene1_x-32,@ene1_y,picture,rect)
      #rect = Rect.new(0, 64*123, 64, 64) # スラッグ
      #add_chr(@ene1_x+32,@ene1_y,picture,rect)
      #rect = Rect.new(0, 64*133, 64, 64) # ターレス
      #add_chr(@ene1_x-32-64,@ene1_y,picture,rect)
      #rect = Rect.new(0, 64*20, 64, 64) # クウラ
      #add_chr(@ene1_x+32+64,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6422 #界王様
      picture = "ZG_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(64*2, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6423 #ブルマの家
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*36, 64, 64) # ブリーフ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)

      character_output_all 0,0,0,26
    when 6431 #ブンブク島 村
      picture = "ZG_背景_町1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6432 #ブンブク島 村 お姉さん
      picture = "ZG_背景_町1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*33, 64, 64) # お姉さん
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6436 #ブンブク島 村 男の子
      picture = "ZG_背景_町1"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*13, 64, 64) # 男の子
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6441 #ブンブク島 洞穴
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6451 #ブンブク島 鉱山
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6452 #ブンブク島 鉱山 ピラフ一味
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*72, 64, 64) # ピラフ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*90, 64, 64) # シュウ
      add_chr(@ene1_x-80,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*91, 64, 64) # マイ
      add_chr(@ene1_x+80,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6453 #ブンブク島 鉱山 ピラフ一味
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      #rect = Rect.new(128, 64*72, 64, 64) # ピラフ
      #add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*90, 64, 64) # シュウ
      add_chr(@ene1_x-80,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*91, 64, 64) # マイ
      add_chr(@ene1_x+80,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6454 #ブンブク島 鉱山 ピラフ一味
      picture = "ZG_背景_草原"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      #rect = Rect.new(128, 64*72, 64, 64) # ピラフ
      #add_chr(@ene1_x-0,@ene1_y,picture,rect)
      #rect = Rect.new(64*2, 64*90, 64, 64) # シュウ
      #add_chr(@ene1_x-80,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*91, 64, 64) # マイ
      add_chr(@ene1_x+80,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6461 #ブンブク島 ピラフの別荘
      picture = "ZG_背景_ピラフの別荘"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6462 #ブンブク島 ピラフの別荘 ピラフたち
      picture = "ZG_背景_ピラフの別荘"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*72, 64, 64) # ピラフ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*90, 64, 64) # シュウ
      add_chr(@ene1_x-80,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*91, 64, 64) # マイ
      add_chr(@ene1_x+80,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6463 #ブンブク島 ピラフの別荘 ピラフたち Z戦士飛び去る
      picture = "ZG_背景_ピラフの別荘"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*72, 64, 64) # ピラフ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*90, 64, 64) # シュウ
      add_chr(@ene1_x-80,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*91, 64, 64) # マイ
      add_chr(@ene1_x+80,@ene1_y,picture,rect)
    when 6464 #ブンブク島 ピラフの別荘 ピラフたち Z戦士飛び去る ピラフ着替える
      picture = "ZG_背景_ピラフの別荘"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*19, 64, 64) # ピラフ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      picture = "顔カード"
      rect = Rect.new(64*2, 64*90, 64, 64) # シュウ
      add_chr(@ene1_x-80,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*91, 64, 64) # マイ
      add_chr(@ene1_x+80,@ene1_y,picture,rect)
    when 6471 #ブンブク島 火山
      picture = "ZG_背景_溶岩2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6481 #ブルマの家
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      picture = "顔カード"
      rect = Rect.new(128, 64*8, 64, 64) # ブルマ
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      rect = Rect.new(64*2, 64*36, 64, 64) # ブリーフ
      add_chr(@ene1_x+48,@ene1_y,picture,rect)

      character_output_all 0,0,0,26
    when 6482 #宇宙船
      picture = "ZG_背景_宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)

      character_output_all 0,0,0,26
    when 6483 #界王様
      picture = "ZG_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(64*2, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6491 #パイレの街
      picture = "ZG_背景_町_クーン星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6492 #パイレの街 パイレ人
      picture = "ZG_背景_町_クーン星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*45, 64, 64) # パイレ人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6501 #預言者の塔 預言者不在
      picture = "ZG_背景_洞窟3"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6502 #預言者の塔 預言者いる
      picture = "ZG_背景_洞窟3"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*43, 64, 64) # 預言者
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6511 #遺跡
      picture = "ZG_背景_洞窟2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6512 #遺跡 ギニュー
      picture = "ZG_背景_洞窟2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*43, 64, 64) # 預言者
      add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*150, 64, 64) # リクーム
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*151, 64, 64) # グルド
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*147, 64, 64) # ギニュー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*148, 64, 64) # ジース
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*149, 64, 64) # バータ
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6516 #遺跡 ギニューたち戦闘
      battle_process (event_no)
    when 6521 #遺跡 ギニューたち戦闘後
      picture = "ZG_背景_洞窟2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
      picture = "顔カード"
      rect = Rect.new(128, 64*125, 64, 64) # リング
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
    when 6522 #遺跡 リング取得
      picture = "ZG_背景_洞窟2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6531 #パイレの街から海賊船を見かける
      picture = "ZG_背景_町_クーン星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6532 #オウター星に着いたので会話
      picture = "ZG_背景_海3"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6541 #オウター星 海賊
      picture = "ZG_背景_宇宙船"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*44, 64, 64) # 海賊
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6551 #オウター星 クアーの町
      picture = "ZG_背景_クアーの町"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6552 #オウター星 クアーの町 オクター人
      picture = "ZG_背景_クアーの町"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*46, 64, 64) # オクター人
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6561 #オウター星 渦潮
      picture = "ZG_背景_海3"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6562 #オウター星 渦潮 海の主
      picture = "ZG_背景_海3"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*47, 64, 64) # 海の主
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6563 #オウター星 渦潮 チルド
      picture = "ZG_背景_海3"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*47, 64, 64) # 海の主
      add_chr(@ene1_x-48,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*152, 64, 64) # チルド(強)
      add_chr(@ene1_x+48,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6566 #遺跡 チルド戦闘
      battle_process (event_no)
    when 6571 #オウター星 渦潮 海の主
      picture = "ZG_背景_海3"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*47, 64, 64) # 海の主
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6572 #オウター星 渦潮 海の主
      picture = "ZG_背景_海3"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "顔カード"
      rect = Rect.new(128, 64*124, 64, 64) # 真珠
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6573 #ライチー(不明)がしゃべる
      picture = "ZG_背景_怨念増幅装置(影)"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # 人影
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6574 #暗黒惑星到着
      picture = "ZG_背景_洞窟6"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6601 #暗黒惑星 背景のみ
      picture = "ZG_背景_洞窟6"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6611,6612,6613,6614,6615 #暗黒惑星 ゴッドガードン
      picture = "ZG_背景_洞窟6"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*71, 64, 64) # ゴッドガードン
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6616 #暗黒惑星 ゴッドガードン戦闘
      battle_process (event_no)
    when 6621 #暗黒惑星 背景のみ
      picture = "ZG_背景_洞窟6"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6631 #暗黒惑星 怨念増幅装置
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6632 #暗黒惑星 怨念増幅装置 人影現れる
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # 人影
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6633 #暗黒惑星 怨念増幅装置 ライチー現れる
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*72, 64, 64) # ライチー
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6641 #暗黒惑星 ライチー戦闘
      battle_process (event_no)
    when 6651 #暗黒惑星 怨念増幅装置 ライチー撃破
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6661 #暗黒惑星 怨念増幅装置 ハッチヒャック登場
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*73, 64, 64) # ハッチヒャック
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6662 #界王様
      picture = "ZG_背景_界王星"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "顔カード"
      rect = Rect.new(64*2, 64*25, 64, 64) # 界王様
      add_chr(@ene1_x,@ene1_y,picture,rect)
    when 6671 #暗黒惑星 ハッチヒャック戦闘
      battle_process (event_no)
    when 6681 #暗黒惑星 ハッチヒャック撃破
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6691 #暗黒惑星 ハッチヒャック撃破(オゾットルート)
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6692 #暗黒惑星 オゾット登場
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*54, 64, 64) # オゾット
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6701 #暗黒惑星 オゾット戦闘
      battle_process (event_no)
    when 6711 #暗黒惑星 オゾット撃破
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(64, 64*54, 64, 64) # オゾット
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6712 #暗黒惑星 オゾット撃破
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*153, 64, 64) # オゾット(変身)
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,26
    when 6721 #暗黒惑星 オゾット戦闘(変身)
      battle_process (event_no)
    when 6731 #暗黒惑星 オゾット(変身)撃破
      picture = "ZG_背景_怨念増幅装置"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 6761 #バーダック一味元の時代へ
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@ene1_x-96-80,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,27,1 #パンブーキン
      add_chr(@ene1_x+96+80,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+96+80+80,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x+0,@play_y-24,picture,rect)
      character_output_all 0,0,40,27
    when 6762 #未来悟飯元の時代へ
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      rect,picture = set_character_face 0,22,1 #未来悟飯
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y-24,picture,rect)
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x+32,@play_y-24,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x-32-64,@play_y-24,picture,rect)
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x+32+64,@play_y-24,picture,rect)
      character_output_all 0,0,40,28
    when 6763 #バーダック元の時代へ
      picture = "ZG_背景_ブルマの家"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_背景_タイムマシンp2"
      rect = Rect.new(0, 0, 128, 128) # タイムマシン
      add_chr(@ene1_x-20,@z1_scrollsceney+10,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@ene1_x-96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@ene1_x+96,@ene1_y,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32,@play_y-24,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x+32,@play_y-24,picture,rect)
      character_output_all 0,0,40,29
      
    when 6768 #集合絵表示
      
      @back_pic = Sprite.new
      @back_pic.bitmap = Bitmap.new("Graphics/Pictures/ZG_イベント_宇宙船_01")
      @back_pic.x = 0
      @back_pic.y = 0
      @back_pic.zoom_x = 200
      @back_pic.zoom_y = 200
      @back_pic.visible = true
      @back_pic.opacity = 255
      @back_pic.z = 10
      
      @syuugo_z4_pic = Sprite.new
      @syuugo_z4_pic.bitmap = Bitmap.new("Graphics/Pictures/集合絵_修正")
      @syuugo_z4_pic.x = 0
      @syuugo_z4_pic.y = 0
      @syuugo_z4_pic.visible = true
      @syuugo_z4_pic.opacity = 0
      @syuugo_z4_pic.z = 20
      
      @syuugo_zg_pic = Sprite.new
      @syuugo_zg_pic.bitmap = Bitmap.new("Graphics/Pictures/集合絵_追加")
      @syuugo_zg_pic.x = 0
      @syuugo_zg_pic.y = 0
      @syuugo_zg_pic.visible = true
      @syuugo_zg_pic.opacity = 0
      @syuugo_zg_pic.z = 30
      
      @end_pic = Sprite.new
      @end_pic.bitmap = Bitmap.new("Graphics/Pictures/文字_END")
      @end_pic.x = 320 - 76
      @end_pic.y = 480 - 64
      @end_pic.visible = true
      @end_pic.opacity = 0
      @end_pic.z = 40
      
      anime_frame = 0
      end_frame = 130 + 60 * 6
      
      #背景とZ4集合絵表示
      begin
        anime_frame += 1
        @syuugo_z4_pic.opacity += 2
        Graphics.update
      end while anime_frame != end_frame
      
      anime_frame = 0
      end_frame = 260 + 60 * 5
      
      #Z4からZG集合絵へ切り替え
      begin
        anime_frame += 1
        @syuugo_z4_pic.opacity -= 1
        @syuugo_zg_pic.opacity += 1
        Graphics.update
      end while anime_frame != end_frame
      
      anime_frame = 0
      end_frame = 130 + 60 * 6
      
      #END表示
      begin
        anime_frame += 1
        @end_pic.opacity += 2
        Graphics.update
      end while anime_frame != end_frame
      
      result = 0
      #決定ボタン入力待ち
      begin
        if Input.trigger?(Input::C) 
          result = 1 #End削除
        end
        Input.update
        Graphics.update
      end while result != 1
      
      #スプライトの解放は次のイベントで実行する
      #画面フェードアウトの都合でこうなった
      
    when 6769 #集合絵表示(背景はイベントの方で表示)
      #スプライト解放
      @back_pic.dispose
      @syuugo_z4_pic.dispose
      @syuugo_zg_pic.dispose
      @end_pic.dispose
      
      @back_pic = nil
      @syuugo_z4_pic = nil
      @syuugo_zg_pic = nil
      @end_pic = nil
    when 6771 #あらすじ用 #グランドアポロンフリーザたち
      picture = "ZG_背景_グランドアポロン"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      #picture = "Z3_顔イベント"
      #rect = Rect.new(0, 64*37, 64, 64) # デストロンガス発生装置
      #add_chr(@ene1_x,@ene1_y,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*20, 64, 64) # クウラ
      add_chr(@ene1_x,@ene1_y-32,picture,rect)
      rect = Rect.new(0, 64*19, 64, 64) # サウザー
      add_chr(@ene1_x,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*16, 64, 64) # ドーレ
      add_chr(@ene1_x-64,@ene1_y+32,picture,rect)
      rect = Rect.new(0, 64*13, 64, 64) # ネイズ
      add_chr(@ene1_x+64,@ene1_y+32,picture,rect)
      rect,picture = set_character_face 0,0,1 #悟空
      add_chr(@play_x-32-64*2,@play_y,picture,rect)
      rect,picture = set_character_face 0,13,1 #バーダック
      add_chr(@play_x-32-64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,24,1 #トーマ
      add_chr(@play_x-32-64*0,@play_y,picture,rect)
      rect,picture = set_character_face 0,25,1 #セリパ
      add_chr(@play_x+32+64*0,@play_y,picture,rect)
      rect,picture = set_character_face 0,26,1 #トテッポ
      add_chr(@play_x+32+64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,27,1 #パンブーキン
      add_chr(@play_x+32+64*2,@play_y,picture,rect)
    when 6772 #あらすじ用 西の砂漠 ターレスたち
      picture = "ZG_背景_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*121, 64, 64) # ラカセイ
      add_chr(@ene1_x-32-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*117, 64, 64) # アモンド
      add_chr(@ene1_x-32-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*133, 64, 64) # ターレス
      add_chr(@ene1_x-32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*118, 64, 64) # ダイーズ
      add_chr(@ene1_x+32,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*119, 64, 64) # カカオ
      add_chr(@ene1_x+32+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*120, 64, 64) # レズン
      add_chr(@ene1_x+32+128,@ene1_y,picture,rect)
      
      rect,picture = set_character_face 0,2,1 #悟飯
      add_chr(@play_x-64*2,@play_y,picture,rect)
      rect,picture = set_character_face 0,3,1 #クリリン
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,7,1 #チチ
      add_chr(@play_x-64*0,@play_y,picture,rect)
      rect,picture = set_character_face 0,21,1 #亀仙人
      add_chr(@play_x+64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,12,1 #若者
      add_chr(@play_x+64*2,@play_y,picture,rect)
      
    when 6773 #あらすじ用 ブンブク島 火山 スラッグ登場
      picture = "ZG_背景_溶岩2"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*124, 64, 64) # アンギラ
      add_chr(@ene1_x-128,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*125, 64, 64) # ドロタボ
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*155, 64, 64) # スラッグ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*126, 64, 64) # メダマッチャ
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*127, 64, 64) # ゼウエン
      add_chr(@ene1_x+128,@ene1_y,picture,rect)
      
      rect,picture = set_character_face 0,1,1 #ピッコロ
      add_chr(@play_x-64*2,@play_y,picture,rect)
      rect,picture = set_character_face 0,22,1 #未来悟飯
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,18,1 #18号
      add_chr(@play_x-64*0,@play_y,picture,rect)
      rect,picture = set_character_face 0,19,1 #17号
      add_chr(@play_x+64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,20,1 #16号
      add_chr(@play_x+64*2,@play_y,picture,rect)
    when 6774 #あらすじ用 氷の大陸 永久氷壁 フリーザとキュイ
      picture = "ZG_背景_氷の大陸"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*143, 64, 64) # フリーザ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*144, 64, 64) # ドドリア
      add_chr(@ene1_x-64,@ene1_y,picture,rect)
      rect = Rect.new(0, 64*145, 64, 64) # ザーボン
      add_chr(@ene1_x+64,@ene1_y,picture,rect)
      
      rect,picture = set_character_face 0,14,1 #トランクス
      add_chr(@play_x-64*2,@play_y,picture,rect)
      rect,picture = set_character_face 0,9,1 #ベジータ
      add_chr(@play_x-64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,4,1 #ヤムチャ
      add_chr(@play_x-64*0,@play_y,picture,rect)
      rect,picture = set_character_face 0,5,1 #天津飯
      add_chr(@play_x+64*1,@play_y,picture,rect)
      rect,picture = set_character_face 0,6,1 #チャオズ
      add_chr(@play_x+64*2,@play_y,picture,rect)
    when 6775 #あらすじ用 クーン星Ｚ戦士
      picture = "ZG_背景_クーン星_砂漠"
      rect = Rect.new(0, 0, 512, 128) # 背景
      add_chr(@z1_scrollscenex,@z1_scrollsceney,picture,rect)
      character_output_all 0,0,0,26
    when 7111 #パイクーハン(人影)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # 人影
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,30
    when 7116 #パイクーハン戦闘
      battle_process (event_no)
    when 7121 #パイクーハン
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*115, 64, 64) # パイクーハン
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output_all 0,0,0,30
    when 7122 #パイクーハン去る
      character_output_all 0,0,0,30
    when 7211 #ブウ(人影)
      picture = "Z3_顔イベント"
      rect = Rect.new(0, 64*15, 64, 64) # 人影
      add_chr(@ene1_x,@ene1_y,picture,rect)
      character_output_all 0,0,0,30
    when 7216 #ブウ戦闘
      battle_process (event_no)
    when 7221 #ブウ
      picture = "Z3_顔敵"
      rect = Rect.new(0, 64*154, 64, 64) # ブウ
      add_chr(@ene1_x-0,@ene1_y,picture,rect)
      character_output_all 0,0,0,30
    when 7222 #ブウ去る
      character_output_all 0,0,0,30
    when 9035 #戦闘の練習 (カカシマン)
      battle_process (event_no)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 戦闘アニメイベントへ飛ばす
  #引数:event_no(実行イベントNO)
  #-------------------------------------------------------------------------- 
  def set_battle_event
    $WinState = 0
    set_bgm = 0  #戦闘時にかける曲
    # 敵数初期化
    $battleenenum = 0
    if $game_variables[41] != 497
      if $game_switches[135] == false
        Audio.bgm_stop
        Audio.se_play("Audio/SE/" +$BGM_encount)    # 効果音を再生する
      end
      $enedeadchk = Marshal.load(Marshal.dump($enedead))
      $chadeadchk = Marshal.load(Marshal.dump($chadead))
      $eneselfdeadchk = Marshal.load(Marshal.dump($enedead))
      Graphics.fadeout(120) if $game_switches[135] == false
    end
    $scene = Scene_Db_Battle_Anime.new (true)

  end
  #--------------------------------------------------------------------------
  # ● 戦闘処理へ飛ばす用
  #引数:event_no(実行イベントNO)
  #-------------------------------------------------------------------------- 
  def battle_process event_no
    $WinState = 0
    set_bgm = 0  #戦闘時にかける曲
    set_ready_bgm = 0 #戦闘前にかける曲
    # 敵数初期化
    $battleenenum = 0

    case event_no
    
    #バトルアリーナ時に初期化するとエラーが出るので、バトルアリーナ以外で実行する
    when 90012,90022,90032
      
    else
      $battleenemy = []
      $enehp = []
      $enemp = []
    end
      
    case event_no
    
    when 55 #パンプキン戦闘処理
      # 敵数設定
      $battleenemy[0] = 5
      $Battle_MapID = 0
    when 57 #ブロッコ戦闘処理
      # 敵数設定
      $battleenemy[0] = 6
      $Battle_MapID = 0
    when 59,9104 #ラディッツ戦闘処理
      # 敵数設定
      $battleenemy[0] = 10
      $Battle_MapID = 0
      set_bgm = 10
    when 93 #サンショ戦闘処理
      # 敵数設定
      $battleenemy[0] = 15
      $battleenemy[1] = 7
      $battleenemy[2] = 8
      $Battle_MapID = 2
    when 103 #ニッキー戦闘処理
      # 敵数設定
      $battleenemy[0] = 14
      $battleenemy[1] = 7
      $battleenemy[2] = 9
      $Battle_MapID = 3
    when 113 #ジンジャー戦闘処理
      # 敵数設定
      $battleenemy[0] = 13
      $battleenemy[1] = 8
      $battleenemy[2] = 9
      $Battle_MapID = 4
    when 120 #３人衆戦闘処理
      # 敵数設定
      $battleenemy[0] = 13
      $battleenemy[1] = 14
      $battleenemy[2] = 15
      $Battle_MapID = 7
    when 122,9113 #ガーリック
      # 敵数設定
      $battleenemy[0] = 16
      $Battle_MapID = 7
    when 126,9114 #ガーリックと３人衆
      # 敵数設定
      $battleenemy[0] = 17
      $battleenemy[1] = 13
      $battleenemy[2] = 14
      $battleenemy[3] = 15
      $Battle_MapID = 7
      set_bgm = $bgm_no_ZMove_M814A
    when 130 #界王様
      # 敵数設定
      $game_switches[157] = true
      $battleenemy[0] = 18
      $Battle_MapID = 5
      set_bgm = $bgm_no_ZSSD_training_for_gb
      if $game_switches[61] == false
        $game_variables[52] = $data_enemies[$battleenemy[0]].maxhp
        $game_switches[61] = true
      end
    when 9123 #界王様
      # 敵数設定
      $game_switches[157] = true
      $battleenemy[0] = 18
      $Battle_MapID = 5
      set_bgm = $bgm_no_ZSSD_training_for_gb
    when 149 #サイバイマン
      # 敵数設定
      $battleenemy = [3,3,3,3,3,3]
      $Battle_MapID = 8
    when 151,9133 #ナッパ
      # 敵数設定
      $battleenemy = [11]
      $Battle_MapID = 8
      set_bgm = 10
    when 155,9134 #ベジータ
      # 敵数設定
      $battleenemy = [12]
      $Battle_MapID = 8
      set_bgm = 11
    when 943,9143 #バイオ戦士
      # 敵数設定
      $battleenemy = [23,24,22]
      $Battle_MapID = 10
      set_bgm = $bgm_no_ZMove_M814A 
    when 953,9144 #Dr.ウィロー
      # 敵数設定
      $battleenemy = [20]
      $Battle_MapID = 10
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZMove_ikusa
      else
        set_bgm = $bgm_no_ZMove_ikusa_btl
        set_ready_bgm = $bgm_no_ready_ZMove_ikusa
      end
    when 832 #ラディッツ戦闘処理(バーダック編)
      # 敵数設定
      $battleenemy[0] = 19
      $Battle_MapID = 0
      set_bgm = 10
    when 852 #キュウコンマン ポポ救出
      # 敵数設
      $battleenemy = [2,2,2,2,2,2]
      $Battle_MapID = 0  
    when 882 #キュウコンマンとサイバイマン
      # 敵数設
      $battleenemy = [2,2,3,3,2,2]
      $Battle_MapID = 11 

    when 308 #異星人
      # 敵数設定
      $battleenemy = [37,32,34,37]
      $Battle_MapID = 0
    when 324,9304 #キュイ
      # 敵数設定
      $battleenemy = [40,32,35,38]
      $Battle_MapID = 5
      set_bgm = $bgm_no_ZSSD_battle1
    when 425 #カナッサ星
      # 敵数設定
      $battleenemy = [35,31,37]
      $Battle_MapID = 0
    when 340,9313 #ドドリア
      # 敵数設定
      $battleenemy = [43,35,32,32]
      $Battle_MapID = 2
      set_bgm = $bgm_no_Z2_battle1_arrange1
    when 440,9323 #ザーボン
      # 敵数設定
      $battleenemy = [45,33,36,39]
      $Battle_MapID = 2
      set_bgm = $bgm_no_Z2_battle1_arrange1
    when 443,9324 #ザーボン(変身)
      # 敵数設定
      $battleenemy = [46]
      $Battle_MapID = 2
      set_bgm = $bgm_no_Z2_battle1_arrange1
    when 452,9333 #ギニュー特選隊
      # 敵数設定
      $battleenemy = [51,52,48,49,50]
      $Battle_MapID = 2
      set_bgm = $bgm_no_ZMove_bgm1
    when 472,9343 #フリーザ
      # 敵数設定
      $battleenemy = [53]
      $Battle_MapID = 2
      set_bgm = $bgm_no_ZMove_bgm1
    when 480,9344 #フリーザ第１形態
      # 敵数設定
      $battleenemy = [54]
      $Battle_MapID = 2
      set_bgm = $bgm_no_ZSB1_pikkoro_for_gb
    when 485,9345 #フリーザ第２形態
      # 敵数設定
      $battleenemy = [55]
      $Battle_MapID = 2
      set_bgm = $bgm_no_ZSB1_freezer_for_gxscc
    when 493,9346 #フリーザ第３形態
      # 敵数設定
      $battleenemy = [56]
      $Battle_MapID = 2
      if $game_switches[93] == false || $game_switches[109] == false || $game_variables[42] != 16 #カナッサ星とバーダック仲間とバーダック先頭
        set_bgm = $bgm_no_ZSSD_battle2
      else
        set_bgm = $bgm_no_ZTVSP_sorid
      end
    when 497 #フリーザ第３形態
      # 敵数設定
      $battleenemy = [56]
      $Battle_MapID = 2
      
      if $game_switches[93] == false || $game_switches[109] == false || $game_variables[42] != 16 #カナッサ星とバーダック仲間とバーダック先頭
        set_bgm = $bgm_no_ZSSD_battle2
      else
        set_bgm = $bgm_no_ZTVSP_sorid
      end
    when 556,9347 #フリーザ第３形態(フルパワー)
      # 敵数設定
      $battleenemy = [57]
      $Battle_MapID = 2
      
      set_bgm = 40 #GBZ2バトル5
      
    when 501,9348 #超ベジータ
      # 敵数設定
      $battleenemy = [58]
      $Battle_MapID = 2
      set_bgm = $bgm_no_ZSSD_battle1_for_gb
    when 511,9349 #ターレスとすらっぐ
      # 敵数設定
      $battleenemy = [59,60]
      $Battle_MapID = 2
      set_bgm = 20
    when 1107 #フリーザ
      # 敵数設定
      $battleenemy = [101]
      $Battle_MapID = 0
      set_bgm = 15
    when 1197,9504 #クラズ
      $battleenemy = [131,108,110]
      $Battle_MapID = 4
      set_bgm = 15
    when 1216 #イール
      $battleenemy = [105,108,109]
      $Battle_MapID = 6
      set_bgm = 15
    when 1472 #ガッシュ
      $battleenemy = [183,177,183]
      $Battle_MapID = 4
      set_bgm = 15
    when 1492 #ビネガー
      $battleenemy = [184,179,184]
      $Battle_MapID = 5
      set_bgm = 15
    when 1512 #ゾルド
      $battleenemy = [184,180,184]
      $Battle_MapID = 2
      set_bgm = 15
    when 1532 #タード
      $battleenemy = [185,178,185]
      $Battle_MapID = 6
      set_bgm = 15
    when 1556,9553 #ガーリック
      $battleenemy = [186,181,187,188]
      $Battle_MapID = 30
      set_bgm = $bgm_no_ZMove_M814A
    when 1565,9554 #ガーリック(巨大化)
      $battleenemy = [177,178,182,179,180]
      $Battle_MapID = 30
      set_bgm = $bgm_no_ZMove_bgm1_2
    when 1237 #フリーザサイボーグ
      $battleenemy = [102]
      $Battle_MapID = 1
      set_bgm = 15
    when 1271 #ジーア
      $battleenemy = [108,105,109]
      $Battle_MapID = 4
      set_bgm = 15
    when 1273,9513 #ピラール
      $battleenemy = [132,105,110]
      $Battle_MapID = 4
      set_bgm = 15
    when 1283 #人質救出A
      $battleenemy = [108,105,110]
      $Battle_MapID = 1
      set_bgm = 14
    when 1286 #人質救出B
      $battleenemy = [105,110,108]
      $Battle_MapID = 1
      set_bgm = 14
    when 1289 #人質救出C
      $battleenemy = [110,108,105]
      $Battle_MapID = 1
      set_bgm = 14
    when 1296,9523 #カイズ
      $battleenemy = [133,108,105,112,115,118]
      $Battle_MapID = 2
      set_bgm = 15
    when 1318,9533 #サウザーたち
      $battleenemy = [116,119,113]
      $Battle_MapID = 5
      set_bgm = 15
    when 1322,9534 #クウラ
      $battleenemy = [120]
      $Battle_MapID = 5
      set_bgm = 15
    when 1325,9535 #クウラ(変身)
      $battleenemy = [121]
      $Battle_MapID = 5
      
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZMove_saikyo
      else
        set_bgm = $bgm_no_ZMove_saikyo_btl
        set_ready_bgm = $bgm_no_ready_ZMove_saikyo
      end
    when 1342,9543 #19号20号
      $battleenemy = [123,122]
      $Battle_MapID = 1
      set_bgm = $bgm_no_ZSB1_20gou_for_gxscc
    when 1363,9544 #17号18号
      $battleenemy = [125,124]
      $Battle_MapID = 4
      set_bgm = $bgm_no_ZSB1_18gou_for_gxscc
    when 1372,9547 #16号
      $battleenemy = [126]
      $Battle_MapID = 4
      set_bgm = $bgm_no_ZUB_zetumei
    when 1390 #セル
      $battleenemy = [127]
      $Battle_MapID = 9
      set_bgm = $bgm_no_ZSB1_cell
    when 2015,9704 #ウィロー強
      $battleenemy = [208,209,210,211]
      $Battle_MapID = 2
      set_bgm = $bgm_no_ZMove_ikusa3 #IKUSA3
    when 2123 #セル
      $battleenemy = [127]
      $Battle_MapID = 1
      set_bgm = $bgm_no_ZSB2_pikkoro_for_gb
    when 2153,9713 #セル
      $battleenemy = [127]
      $Battle_MapID = 1
      set_bgm = $bgm_no_ZSB1_16gou_for_gb
      
      if event_no == 9713
        #時の間での戦いの場合ランダムで曲を変える
        if rand(1) == 1
          set_bgm = $bgm_no_ZSB2_pikkoro_for_gb
        end
      end
    when 2188 #セル2
      $battleenemy = [128]
      $Battle_MapID = 1
      set_bgm = $bgm_no_FCJ1_battle2
    when 2256,9723 #セル2
      $battleenemy = [128]
      $Battle_MapID = 1
      set_bgm = $bgm_no_ZSB2_bejita_for_gb
      if event_no == 9723
        #時の間での戦いの場合ランダムで曲を変える
        if rand(1) == 1
          set_bgm = $bgm_no_FCJ1_battle2
        end
      end
    when 2726 #メタルクウラ
      $battleenemy = [136]
      $Battle_MapID = 0
      set_bgm = $bgm_no_ZMove_metarukuura_battlebgm
    when 2736,9733 #メタルクウラ
      $battleenemy = [136,136,136]
      $Battle_MapID = 0
      set_bgm = $bgm_no_ZMove_metarukuura_battlebgm
    when 2765 #ロボット兵
      $battleenemy = [213,213]
      $Battle_MapID = 33
      set_bgm = $bgm_no_ZMove_metarukuura_battlebgm3
    when 2782,9743 #メタルクウラコア
      $battleenemy = [213,214,213]
      $Battle_MapID = 33
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZMove_hero
      else
        set_bgm = $bgm_no_ZMove_hero_btl
        set_ready_bgm = $bgm_no_ready_ZMove_hero
      end
    when 2832,9753 #15号
      $battleenemy = [235,141,236]
      $Battle_MapID = 6
      set_bgm = 15 #Z3ボス戦
    when 2842,9754 #14号
      $battleenemy = [234,140,234]
      $Battle_MapID = 6
      set_bgm = 15 #Z3ボス戦
    when 2852,9755 #13号
      $battleenemy = [237,138,237]
      $Battle_MapID = 6
      set_bgm = $bgm_no_ZMove_zinzouningen_battlebgm
    when 2871,9756 #合体13号
      $battleenemy = [139]
      $Battle_MapID = 6
      
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZMove_girigiri
      else
        set_bgm = $bgm_no_ZMove_girigiri_btl
        set_ready_bgm = $bgm_no_ready_ZMove_girigiri
      end
    when 2463 #セル3 (悟空と一対一)
      $battleenemy = [129]
      $Battle_MapID = 29
      set_bgm = $bgm_no_ZSB3_goku
    when 2464 #セル3とセルジュニア(全員で闘う)
      $battleenemy = [130,130,130,130,129,130,130,130,130]
      $Battle_MapID = 29
      set_bgm = $bgm_no_ZTV_cellgame
    when 2481 #セル3
      $battleenemy = [129]
      $Battle_MapID = 1
      set_bgm = $bgm_no_ZSA1_big_fight_for_gb
    when 2561,9773 #セル(パーフェクト)とセルジュニア
      $battleenemy = [130,130,130,130,135,130,130,130,130]
      $Battle_MapID = 29
      set_bgm = $bgm_no_ZSB2_gohan_for_gxscc
    when 3631 #17号18号
      $battleenemy = [125,124]
      $Battle_MapID = 1
      set_bgm = $bgm_no_ZSA2_bgm01_for_gb
    when 5111 #ブロリー(超)
      $battleenemy = [151]
      $Battle_MapID = 28
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZMove_brori_battlebgm
      else
        set_bgm = $bgm_no_ZMove_brori_battlebgm_btl
        set_ready_bgm = $bgm_no_ready_ZMove_brori_battlebgm
      end

      #$bgm_no_ZSB2_buro_for_gb
      #$bgm_no_ZSB2_buro_for_gxscc
    when 5131 #ブロリー(フルパワー)
      $battleenemy = [152]
      $Battle_MapID = 28
      #set_bgm = $bgm_no_ZSB2_buro_for_gb
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZMove_nessen
      else
        set_bgm = $bgm_no_ZMove_nessen_btl
        set_ready_bgm = $bgm_no_ready_ZMove_nessen
      end
    when 5516 #ブージンとゴクア
      $battleenemy = [147,144]
      $Battle_MapID = 1
      set_bgm = 15
        
    when 5536 #ザンギャとビドー
      $battleenemy = [145,146]
      $Battle_MapID = 6
      set_bgm = 15
    when 5576 #ボージャック一味
      $battleenemy = [144,145,142,146,147]
      $Battle_MapID = 34
      
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZMove_M1619
      else
        set_bgm = $bgm_no_ZMove_M1619_btl
      end
    when 5591 #ボージャックフルパワー
      $battleenemy = [143]
      $Battle_MapID = 34
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZMove_raizing
      else
        set_bgm = $bgm_no_ZMove_raizing_btl
        set_ready_bgm = $bgm_no_ready_ZMove_raizing
      end
    when 6021 #アービーとキンカーン
      $battleenemy = [159,155]
      $Battle_MapID = 14 #ZG平原
      set_bgm = 19 #ZG 中ボス戦
      
    when 6086 #ターレス軍
      $battleenemy = [69,65,59,66,67,68]
      $Battle_MapID = 5 #Z3砂漠
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZMove_marugoto
      else
        set_bgm = $bgm_no_ZMove_marugoto_btl
        set_ready_bgm = $bgm_no_ready_ZMove_marugoto
      end
    when 6116 #スラッグ軍
      $battleenemy = [72,73,60,74,75]
      $Battle_MapID = 2 #Z2ナメック星
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZMove_genkidama
      else
        set_bgm = $bgm_no_ZMove_genkidama_btl
        set_ready_bgm = $bgm_no_ready_ZMove_genkidama
      end
    when 6141 #フリーザフルパワー
      $battleenemy = [101]
      $Battle_MapID = 0 #Z2惑星
      set_bgm = $bgm_no_ZTVSP_sorid_full3
    when 6206 #クウラ一味
      $battleenemy = [239,240,241,242]
      $Battle_MapID = 14 #ZG平原
      set_bgm = 19 #ZG 中ボス戦
      
    when 6261 #ターレス軍
      $battleenemy = [221,217,233,218,219,220]
      $Battle_MapID = 16 #ZG砂漠
      set_bgm = 19 #ZG 中ボス戦
    when 6316 #カワーズ
      $battleenemy = [158]
      $Battle_MapID = 15 #ZG森
      set_bgm = 19 #ZG 中ボス戦
    when 6326 #スラッグ軍
      $battleenemy = [224,225,255,226,227]
      $Battle_MapID = 15 #ZG森
      set_bgm = 19 #ZG 中ボス戦  
    when 6346 #キュイ
      $battleenemy = [246]
      $Battle_MapID = 17 #ZG氷の大陸
      set_bgm = 19 #ZG 中ボス戦
    when 6371 #フリーザ軍
      $battleenemy = [244,243,245]
      $Battle_MapID = 17 #ZG氷の大陸
      set_bgm = 19 #ZG 中ボス戦
    when 6411 #ゴースト戦士一味
      $battleenemy = [233,243,255,239]
      $Battle_MapID = 14 #ZG平原
      set_bgm = 20 #ZG ボス戦
    when 6516 #ギニュー特戦隊
      $battleenemy = [250,251,247,248,249]
      $Battle_MapID = 27 #ZG洞窟
      set_bgm = $bgm_no_ZTV_kyouhug2 #ZG ボス戦
    when 6566 #チルド
      $battleenemy = [252]
      $Battle_MapID = 19 #ZGオウター星海
      set_bgm = $bgm_no_ZTVSP_sorid_2 #ソリッドステートスカウターver2
    when 6616 #ゴッドガードン
      $battleenemy = [213,171,213]
      $Battle_MapID = 18 #ZG暗黒惑星
      set_bgm = 20 #ZG ボス戦
    when 6641 #ライチー
      $battleenemy = [172]
      $Battle_MapID = 18 #ZG暗黒惑星
      set_bgm = 21 #ZG 大ボス戦
    when 6671 #ハッチヒャック
      $battleenemy = [173]
      $Battle_MapID = 18 #ZG暗黒惑星
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZPS3_RB2_boo
      else
        set_bgm = $bgm_no_ZPS3_RB2_boo_btl
        set_ready_bgm = $bgm_no_ready_ZPS3_RB2_boo
      end
    when 6701 #オゾット
      $battleenemy = [154]
      $Battle_MapID = 18 #ZG暗黒惑星
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZPS2_Z2_heart
      else
        set_bgm = $bgm_no_ZPS2_Z2_heart_btl
        set_ready_bgm = $bgm_no_ready_ZPS2_Z2_heart
      end
    when 6721 #オゾット(変身)
      $battleenemy = [253]
      $Battle_MapID = 18 #ZG暗黒惑星
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZPS3_BR_kiseki
      else
        set_bgm = $bgm_no_ZPS3_BR_kiseki_btl
        set_ready_bgm = $bgm_no_ready_ZPS3_BR_kiseki
      end
    when 7116 #パイクーハン
      $battleenemy = [215]
      $Battle_MapID = 5 #Z1あの世
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZPS2_Z3_ore
      else
        set_bgm = $bgm_no_ZPS2_Z3_ore_btl
        set_ready_bgm = $bgm_no_ready_ZPS2_Z3_ore
      end
    when 7216 #ブウ
      $battleenemy = [254]
      $Battle_MapID = 5 #Z1あの世
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        set_bgm = $bgm_no_ZSPM_SSurvivor
      else
        set_bgm = $bgm_no_ZSPM_SSurvivor_btl
        set_ready_bgm = $bgm_no_ready_ZSPM_SSurvivor
      end
    when 9035 #戦闘テスト
      $battleenemy = [27] #カカシマン
      #進行度によって背景を変える #バトルアリーナの背景を使う
      if $game_variables[40] == 0
        $game_variables[301] = 0
        $Battle_MapID = 9
        #set_bgm = $bgm_no_ZSB2_buro_for_gb
      elsif $game_variables[40] == 1
        $game_variables[301] = 1
        $Battle_MapID = 6
      elsif $game_variables[40] == 2
        $game_variables[301] = 2
        $Battle_MapID = 10
      else
        $Battle_MapID = 10
      end
    when 90012,90022,90032 #バトルアリーナ
      set_bgm = $set_btlarn_bgm
      set_ready_bgm = $set_btlarn_ready_bgm
    end
      
    $battleenenum = $battleenemy.size 
    # HPセット
    for x in 0..$battleenenum -1
      $enehp[x] = $data_enemies[$battleenemy[x]].maxhp #敵hpを代入
      $enemp[x] = $data_enemies[$battleenemy[x]].maxmp #敵mpを代入
    end
    
    if event_no == 130 #界王様の場合はHPをセット
      $enehp[0] = $game_variables[52]
    end
    if event_no == 497 #フリーザの場合はHPをセット
      $enehp[0] = $game_variables[56]
    end
    # 敵死亡状態
    $enedead = [nil]
    for x in 0..$battleenenum -1
      $enedead[x] = false
    end
    
      #p "敵キャラ数：" + $battleenenum.to_s,"敵キャラNo：" + $battleenemy[0].to_s,
      #  "敵キャラHP：" + $enehp[0].to_s,"敵キャラMP：" + $enemp[0].to_s,"敵死亡状態：" + $enedead[0].to_s
    
    if $game_variables[41] != 497
      
      if $game_switches[135] == false
        Audio.bgm_stop
        Audio.se_play("Audio/SE/" +$BGM_encount)    # 効果音を再生する
      end 
      $enedeadchk = Marshal.load(Marshal.dump($enedead))
      $chadeadchk = Marshal.load(Marshal.dump($chadead))
      $eneselfdeadchk = Marshal.load(Marshal.dump($enedead))
      Graphics.fadeout(70)
    else
      Graphics.fadeout(30)
    end
    
    #オプションで指定があればイベントバトルBGMの変更をする
    if $game_variables[428] != 0
      set_bgm = $game_variables[428]
    end
    
    #戦闘前BGM
    if $game_variables[429] != 0
      set_ready_bgm = $game_variables[429]
    end
    
    $scene = Scene_Db_Battle.new (false,set_bgm,set_ready_bgm)
    

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
  # ● カード合成を追加する
  #--------------------------------------------------------------------------
  def card_compo_get
    $game_party.gain_item ($data_items[$game_variables[26]], 1) #カード増やす
    $card_compo_no = [] #カード初期化
  end
  #--------------------------------------------------------------------------
  # ● カード合成キャンセル時に元に戻す
  #--------------------------------------------------------------------------
  def card_compo_restore
   for x in 1..$card_compo_no.size-1
     $game_party.gain_item ($data_items[$card_compo_no[x]], 1) #カード増やす
   end
   $card_compo_no = [] #カード初期化
  end
  #--------------------------------------------------------------------------
  # ● カリン様出力
  #引数：[row_no:縦位置 col_no:横位置]
  #--------------------------------------------------------------------------
  def put_carin_card_compo row_no= 0 ,col_no = 0
      #picture = "ZD_カリン様"
      rect = Rect.new(96*col_no, 80*row_no, 96, 80) # カリン様
      @chr_sprite[0].src_rect = rect
  end
  
  #--------------------------------------------------------------------------
  # ● カード合成選択カード画面出力
  #引数：[progress_no:進行状況]
  #--------------------------------------------------------------------------
  def put_card_compo
    for x in 1..$card_compo_no.size-1
      rect = put_icon $card_compo_no[x]
      @chr_sprite[x].src_rect = rect
      #@chr_sprite[x] = Event_Sprite.new(x, y,bitmap_name,bitmap_rect,x)
      @chr_sprite[x].visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● カード合成パターンチェック
  #--------------------------------------------------------------------------
  def chk_card_compo
    
    #恐らく2つのカードを見て処理をしていないので、そこを修正する必用がある
    
    temp_rand = rand(100)+1
    #p temp_rand
    temp_percent = 0
    temp_fail = rand(2)+1
    temp_card_compo_cha = [] #一時格納
    for x in 0..$card_compo_count - 1
      result_card_compo = true
      temp_card_compo_cha = Marshal.load(Marshal.dump($card_compo_cha[x]))
      for y in 1..$card_compo_no.size - 1
        #p $card_compo_cha[x],$card_compo_no[y]
        #p $card_compo_cha[x].index($card_compo_no[y])
        
        if temp_card_compo_cha.index($card_compo_no[y]) == nil #対象カードがあるかないか
        #if $card_compo_cha[x].index($card_compo_no[y]) == nil #対象カード
          result_card_compo = false
        else
          #あった場合はヒットした配列を削除する(同カードの合成対策
          #9,9と9,10があり、9,9を合成した場合後者がヒットしてしまうため
          temp_card_compo_cha.delete_at(temp_card_compo_cha.index($card_compo_no[y]))
        end

      end
      
      if result_card_compo == true #対象カードだった
        $game_switches[37] = true
        
        #新規合成パターン発見
        if $get_card_compo_recipe[x] != true
          $game_switches[35] = true 
          $get_card_compo_recipe[x] = true
        end
        for z in 1..$card_compo_get_cha[x].size
          temp_percent += $card_compo_percent[x]
          #p temp_percent,temp_rand
          if temp_percent >= temp_rand #成功率チェック
            #p "成功"
            $game_variables[26] = $card_compo_get_cha[x]
            #$game_switches[37] = true
            break
          else
            #p "失敗"
            if z == $card_compo_get_cha[x].size
              #合成が完全に失敗した場合
              #p temp_fail,$card_compo_no
              $game_variables[26] = $card_compo_no[temp_fail]
              #$game_switches[37] = false
              
            end
          end
        end
      end
    end

  end
  #--------------------------------------------------------------------------
  # ● カード合成選択カード画面から消去
  #引数：[progress_no:進行状況]
  #--------------------------------------------------------------------------
  def put_cancel_card_compo
    for x in 1..@chr_sprite.size-1
      #rect = put_icon $card_compo_no[x]
      #@chr_sprite[x].src_rect = rect
      #@chr_sprite[x] = Event_Sprite.new(x, y,bitmap_name,bitmap_rect,x)
      @chr_sprite[x].visible = false
      @chr_sprite[x].y = @play_y+64
      tone = Tone.new(0, 0, 0,0)
      @chr_sprite[x].tone = tone
      case x
      
      when 1
        @chr_sprite[x].x = @play_x-128*1
      when 2
        @chr_sprite[x].x = @play_x+128*1
      when 3
        @chr_sprite[x].x = @play_x
      when 4
        @chr_sprite[x].x = @play_x
      end
    end
  end
  
#--------------------------------------------------------------------------
  # ● カード合成作成カード移動(合成パターンがない)
  #--------------------------------------------------------------------------
  def move_create_card_compo_no_match
    move_time = 64
    yoko = 128
    tate = 64
    create_card = 4
    tate_idou = (tate.prec_f/move_time.prec_f).ceil.prec_i
    yoko_idou = (yoko.prec_f/move_time.prec_f).ceil.prec_i
    tone = Tone.new(255, 255, 255,0)
    tone_puls = ((255).prec_f/move_time.prec_f).ceil.prec_i

    @chr_sprite[1].tone = tone
    @chr_sprite[2].tone = tone
    @chr_sprite[3].tone = tone
    @chr_sprite[create_card].tone = tone
    rect = put_icon $game_variables[26]
    if $game_variables[26] == 0
      $game_variables[26] = 9
      rect = put_icon $game_variables[26]
    end
    
    @chr_sprite[1].x = @play_x
    @chr_sprite[2].x = @play_x
    @chr_sprite[3].x = @play_x
    @chr_sprite[1].y -= tate
    @chr_sprite[2].y -= tate
    @chr_sprite[3].y -= tate
    #@chr_sprite[create_card].x = @chr_sprite[1].x
    @chr_sprite[create_card].y -= tate
    @chr_sprite[create_card].src_rect = rect
    #@chr_sprite[create_card].visible = true
    
    @chr_sprite[1].visible = true
    @chr_sprite[2].visible = true
    tone_puls = ((255).prec_f/move_time.prec_f).ceil.prec_i
    for x in 1..move_time
      tone = Tone.new(255-x*tone_puls, 255-x*tone_puls, 255-x*tone_puls,0)
      
      if yoko_idou*(x-1) > yoko
        
      elsif yoko_idou*(x) > yoko
        @chr_sprite[1].x -= yoko - yoko_idou*(x-1)
        @chr_sprite[2].x += yoko - yoko_idou*(x-1)
        @chr_sprite[3].x += yoko - yoko_idou*(x-1)
      else
        @chr_sprite[1].x -= yoko_idou
        @chr_sprite[2].x += yoko_idou
        @chr_sprite[3].x += yoko_idou
      end
      
      
      if tate_idou*(x-1) > tate
        
      elsif tate_idou*(x) > tate
        @chr_sprite[1].y += tate - tate_idou*(x-1)
        @chr_sprite[2].y += tate - tate_idou*(x-1)
        @chr_sprite[3].y += tate - tate_idou*(x-1)
      else
        @chr_sprite[1].y += tate_idou
        @chr_sprite[2].y += tate_idou
        @chr_sprite[3].y += tate_idou
      end
      @chr_sprite[1].tone = tone
      @chr_sprite[2].tone = tone
      @chr_sprite[3].tone = tone
      
      Input.update
      if Input.trigger?(Input::C)
        #p "C押された"
        #移動完了状態にする
        @chr_sprite[1].tone = Tone.new(0.000000, 0.000000, 0.000000, 0.000000)
        @chr_sprite[2].tone = Tone.new(0.000000, 0.000000, 0.000000, 0.000000)
        @chr_sprite[3].tone = Tone.new(0.000000, 0.000000, 0.000000, 0.000000)
        @chr_sprite[4].tone = Tone.new(-1.000000, -1.000000, -1.000000, 0.000000)
        @chr_sprite[1].x = 160
        @chr_sprite[2].x = 416
        @chr_sprite[3].x = 288
        @chr_sprite[4].x = 288
        @chr_sprite[1].y = 370
        @chr_sprite[2].y = 370
        @chr_sprite[3].y = 370
        @chr_sprite[4].y = 370
        break
      end
      
      Graphics.update
    end
    
    #p @chr_sprite[4].tone
    #p @chr_sprite[4].x
    #p @chr_sprite[4].y
  end
  #--------------------------------------------------------------------------
  # ● カード合成作成カード移動
  #--------------------------------------------------------------------------
  def move_create_card_compo
    move_time = 64
    yoko = 128
    tate = 64
    create_card = 4
    tate_idou = (tate.prec_f/move_time.prec_f).ceil.prec_i
    tone = Tone.new(255, 255, 255,0)
    @chr_sprite[create_card].tone = tone
    rect = put_icon $game_variables[26]
    if $game_variables[26] == 0
      $game_variables[26] = 9
      rect = put_icon $game_variables[26]
    end
    #@chr_sprite[create_card].x = @chr_sprite[1].x
    @chr_sprite[create_card].y -= tate
    @chr_sprite[create_card].src_rect = rect
    @chr_sprite[create_card].visible = true
    tone_puls = ((255).prec_f/move_time.prec_f).ceil.prec_i
    for x in 1..move_time
      tone = Tone.new(255-x*tone_puls, 255-x*tone_puls, 255-x*tone_puls,0)
      if tate_idou*(x-1) > tate
        
      elsif tate_idou*(x) > tate
        @chr_sprite[create_card].y += tate - tate_idou*(x-1)
      else
        @chr_sprite[create_card].y += tate_idou
      end
      @chr_sprite[create_card].tone = tone
      
      Input.update
      if Input.trigger?(Input::C)
        #p "C押された"
        #移動完了状態にする
        @chr_sprite[1].tone = Tone.new(0.000000, 0.000000, 0.000000, 0.000000)
        @chr_sprite[2].tone = Tone.new(0.000000, 0.000000, 0.000000, 0.000000)
        @chr_sprite[3].tone = Tone.new(0.000000, 0.000000, 0.000000, 0.000000)
        @chr_sprite[4].tone = Tone.new(-1.000000, -1.000000, -1.000000, 0.000000)
        @chr_sprite[1].x = 160
        @chr_sprite[2].x = 416
        @chr_sprite[3].x = 288
        @chr_sprite[4].x = 288
        @chr_sprite[1].y = 370
        @chr_sprite[2].y = 370
        @chr_sprite[3].y = 370
        @chr_sprite[4].y = 370
        break
      end
      
      Graphics.update
    end
    
    #p @chr_sprite[4].tone
    #p @chr_sprite[4].x
    #p @chr_sprite[4].y
  end
  #--------------------------------------------------------------------------
  # ● カード合成選択カード移動
  #--------------------------------------------------------------------------
  def move_card_compo
    
    move_time = 64
    yoko = 128
    tate = 64
    #tone_puls = (0).prec_f
    #p tone_puls# = tone_puls.prec_f
    yoko_idou = (yoko.prec_f/move_time.prec_f).ceil.prec_i
    tate_idou = (tate.prec_f/move_time.prec_f).ceil.prec_i
    
    tone_puls = ((255).prec_f/move_time.prec_f).ceil.prec_i
    #p tone_puls
    
    for x in 1..move_time
      
      tone = Tone.new(x*tone_puls, x*tone_puls, x*tone_puls,0)
      
      if yoko_idou*(x-1) > yoko
        
      elsif yoko_idou*(x) > yoko
        @chr_sprite[1].x += yoko - yoko_idou*(x-1)
        @chr_sprite[2].x -= yoko - yoko_idou*(x-1)
        @chr_sprite[3].x -= yoko - yoko_idou*(x-1)
      else
        @chr_sprite[1].x += yoko_idou
        @chr_sprite[2].x -= yoko_idou
        @chr_sprite[3].x -= yoko_idou
      end
      
      if tate_idou*(x-1) > tate
        
      elsif tate_idou*(x) > tate
        @chr_sprite[1].y -= tate - tate_idou*(x-1)
        @chr_sprite[2].y -= tate - tate_idou*(x-1)
        @chr_sprite[3].y -= tate - tate_idou*(x-1)
      else
        @chr_sprite[1].y -= tate_idou
        @chr_sprite[2].y -= tate_idou
        @chr_sprite[3].y -= tate_idou
      end
      @chr_sprite[1].tone = tone
      @chr_sprite[2].tone = tone
      @chr_sprite[3].tone = tone
      
      #演出ショートカット
      #if (Input.press?(Input::R) and (Input.press?(Input::B) or Input.press?(Input::C)))
      Input.update
      if Input.trigger?(Input::C)
        #p "C押された"
        #移動完了状態にする
        @chr_sprite[1].tone = Tone.new(255.000000, 255.000000, 255.000000, 0.000000)
        @chr_sprite[2].tone = Tone.new(255.000000, 255.000000, 255.000000, 0.000000)
        @chr_sprite[3].tone = Tone.new(255.000000, 255.000000, 255.000000, 0.000000)
        @chr_sprite[1].x = 288
        @chr_sprite[2].x = 288
        @chr_sprite[3].x = 160
        @chr_sprite[1].y = 306
        @chr_sprite[2].y = 306
        @chr_sprite[3].y = 306
        break
      end
      
      Graphics.update
    end
    
    #p @chr_sprite[1].tone,@chr_sprite[2].tone,@chr_sprite[3].tone
    #p @chr_sprite[1].x,@chr_sprite[2].x,@chr_sprite[3].x
    #p @chr_sprite[1].y,@chr_sprite[2].y,@chr_sprite[3].y
    put_cancel_card_compo
  end
  #--------------------------------------------------------------------------
  # ● カード合成
  #引数：[progress_no:進行状況]
  #--------------------------------------------------------------------------
  def card_compo progress_no
    
    case progress_no
    
    when 0
      Graphics.fadeout(10)
      $scene = Scene_Db_Card.new 4
      #$game_temp.next_scene = "db_card"
      
    end
  end
  
  #--------------------------------------------------------------------------
  # ● メッセージウィンドウで説明の一覧を出力する。
  #--------------------------------------------------------------------------
  def put_infolist_win
    
    
  end
  #--------------------------------------------------------------------------
  # ● メッセージ待機中フラグおよびコールバックの設定
  #--------------------------------------------------------------------------
  def set_message_waiting
    @message_waiting = true
    $game_message.main_proc = Proc.new { @message_waiting = false }
  end
end