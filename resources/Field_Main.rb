#==============================================================================
# ■ Field_Main
#------------------------------------------------------------------------------
# 　フィールド時のメイン処理
#==============================================================================

class Field_Main < Scene_Map
    include Share
    #メインウインドウ表示位置
    Mainxstr = 16
    Mainystr = 348
    Mainxend = 128
    Mainyend = 118
    #カードウインドウ表示位置
    Cardxstr = 10
    Cardystr = 330
    Cardxend = 680
    Cardyend = 210
    #メニューウインドウ表示位置
    Msgxstr = 144
    Msgystr = 348
    Msgxend = 470
    Msgyend = 118
    Cardsize = 64
    Cardoutputkizyun = 118
    Cardup = 22 #カード選択時に上がる量
    Cardslidespeed = 10 

    #@bakwin = Game_Picture.new
    #bakwin.pictures[1].show("バックウインドウ", 0,0,270, 1700.0, 500.0, 255, 0)

  def initialize
    $game_map.autoplay
    $map_bgm = RPG::BGM.last.name
  end    

  def moveready
    $game_switches[4] = false
    $game_switches[2] = false
    $game_switches[1] = false
    $game_switches[12] = true
    @backwin.dispose
    @backwin = nil
    @cardwin.dispose
    @cardwin = nil
    @mainwin.dispose
    @mainwin = nil
    if @msgwin != nil
      @msgwin.dispose
      @msgwin = nil
    end
  end
  def clear
   if @mainwin != nil
     @mainwin.contents.clear
   end
   if @cardwin != nil
     @cardwin.contents.clear
   end
   if @msgwin != nil
     @msgwin.contents.clear
   end 
   #@backwin.contents.clear
   #if @backwin.disposed? then

     #@backwin.dispose
     #@backwin = nil
   #end
   #if @mainwin.disposed? then
     #@mainwin.dispose
     #@mainwin = nil
   #end
   
   #if @cardwin.disposed? then
     #@cardwin.dispose
     #@cardwin = nil
   #end

  end
  
  def flycha_muki_sitei
    if $game_variables[6] < $game_variables[2]
     up_flag = true #上
     up_sabun = $game_variables[2] - $game_variables[6]
    else
     up_flag = false #下
     up_sabun = $game_variables[6] - $game_variables[2]
    end
    
    if $game_variables[5] < $game_variables[1]
     left_flag = true #左
     left_sabun = $game_variables[1] - $game_variables[5]
    else
     left_flag = false #右
     left_sabun = $game_variables[5] - $game_variables[1]
    end
   
    if up_flag == true && left_flag == true
      if up_sabun >= left_sabun
        $game_variables[19] = 8
      else
        $game_variables[19] = 4
      end
    elsif up_flag == true && left_flag == false
      if up_sabun >= left_sabun
        $game_variables[19] = 8
      else
        $game_variables[19] = 6
      end
    elsif up_flag == false && left_flag == true  
      if up_sabun >= left_sabun
        $game_variables[19] = 2
      else
        $game_variables[19] = 4
      end
    elsif up_flag == false && left_flag == false
      if up_sabun >= left_sabun
        $game_variables[19] = 2
      else
        $game_variables[19] = 6
      end
    else
        $game_variables[19] = 2
    end
  end
  def Create_window


    # バックウインドウ作成
    @backwin = Window_Base.new(-30,320,700,200)
    @backwin.opacity=0
    @backwin.back_opacity=0
    color = set_skn_color 0
    @backwin.contents.fill_rect(0,0,680,200,color)
      
    #case "1"
    #when 1 then
      
      # カードウインドウ作成
      @cardwin = Window_Base.new(Cardxstr,Cardystr,Cardxend,Cardyend)
      @cardwin.opacity=0
      @cardwin.back_opacity=0

      # メニューウインドウ表示
      @mainwin = Window_Base.new(Mainxstr,Mainystr,Mainxend,Mainyend)
      @mainwin.opacity=255
      @mainwin.back_opacity=255
      
    if @msgwin == nil && $WinState == 4
      @msgwin = Window_Base.new(Msgxstr,Msgystr,Msgxend,Msgyend)
      @msgwin.opacity=255
      @msgwin.back_opacity=255
      #picture = Cache.picture("メニュー文字関係")
      #rect = Rect.new(0, 96, 256, 96) # メニュー文字格納
      #@msgwin.contents.blt(16 ,-2,picture,rect) 
    end
    #when "1" then
    
    #else
    
    #end
  #clear
  end
  def cardupdate
      @cardwin.contents.clear
      # カード表示
      picture = Cache.picture("カード関係")
      recta = set_card_frame 0 # カード元格納(共通のため1どのみ)
      for a in 1..6 do
        rectb = set_card_frame 2,$carda[a-1] # 攻撃
        rectc = set_card_frame 3,$cardg[a-1] # 防御
        rectd = Rect.new(0 + 32 * ($cardi[a-1]), 64, 32, 32) # 流派
        # カード選択、移動処理後はカードを更新するため選択したカードを表示しない
        if $CardCursorState == (a-1) && $WinState == 0 && $game_switches[7] == true then
            # カード表示しない
        elsif $CardCursorState == (a-2) && $WinState == 0 && $game_switches[7] == true then
          
        else    
          #カードが選択された場合は上に挙げる
          if $CardCursorState == (a-1) && $WinState == 2 then
            @cardwin.contents.blt(Cardoutputkizyun + Cardsize * (a-1),24-Cardup,picture,recta)
            @cardwin.contents.blt(Cardoutputkizyun + 2 + Cardsize * (a-1)+$output_card_tyousei_x,26-Cardup+$output_card_tyousei_y,picture,rectb)
            @cardwin.contents.blt(Cardoutputkizyun + 30 + Cardsize * (a-1),86-Cardup,picture,rectc)
            @cardwin.contents.blt(Cardoutputkizyun + 16 + Cardsize * (a-1),56-Cardup,picture,rectd)
          else
            @cardwin.contents.blt(Cardoutputkizyun + Cardsize * (a-1),24,picture,recta)
            @cardwin.contents.blt(Cardoutputkizyun + 2 + Cardsize * (a-1)+$output_card_tyousei_x,26+$output_card_tyousei_y,picture,rectb)
            @cardwin.contents.blt(Cardoutputkizyun + 30 + Cardsize * (a-1),86,picture,rectc)
            @cardwin.contents.blt(Cardoutputkizyun + 16 + Cardsize * (a-1),56,picture,rectd)
          end
        end
      end
     
      # カードカーソル表示
      if $game_switches[3] == true && $WinState == 1 then
        picture = Cache.picture("アイコン")
        rect = set_tate_cursor_blink
        @cardwin.contents.blt(60 + Cardsize * ($CardCursorState+1)  ,8,picture,rect)
      end    
      

  end

  # カードスライド
  def cardslide
    #@cardwin.contents.clear
    $CardCursorState = $game_variables[12]
      picture = Cache.picture("カード関係")
      recta = set_card_frame 0 # カード元格納(共通のため1どのみ)
      rectb = set_card_frame 2,$carda[$CardCursorState+1] # 攻撃
      rectc = set_card_frame 3,$cardg[$CardCursorState+1] # 防御
      rectd = Rect.new(0 + 32 * ($cardi[$CardCursorState+1]), 64, 32, 32) # 流派
      
      # カードスライド
      @cardwin.contents.blt(Cardoutputkizyun + Cardsize * ($CardCursorState)+$game_variables[11]*Cardslidespeed,24,picture,recta)
      @cardwin.contents.blt(Cardoutputkizyun + 2 + Cardsize * ($CardCursorState)+$game_variables[11]*Cardslidespeed+$output_card_tyousei_x,26+$output_card_tyousei_y,picture,rectb)
      @cardwin.contents.blt(Cardoutputkizyun + 30 + Cardsize * ($CardCursorState)+$game_variables[11]*Cardslidespeed,86,picture,rectc)
      @cardwin.contents.blt(Cardoutputkizyun + 16 + Cardsize * ($CardCursorState)+$game_variables[11]*Cardslidespeed,56,picture,rectd)          

      # カードスライド繰り返し回数
      $game_variables[11] -= 1
   
  end
  def Create_obj
    if $game_switches[38] == true
      @mainwin.refresh if @mainwin != nil
      @msgwin.refresh if @msgwin != nil
      color = set_skn_color 0
      @backwin.contents.fill_rect(0,0,680,200,color)
      $game_switches[39] = true
      #Graphics.fadein(5)
    end
      
      clear
      if @mainwin == nil
        #p @mainwin,@backwin,@cardwin,@msgwin
      # バックウインドウ作成
          @backwin = Window_Base.new(-30,320,700,200)
          @backwin.opacity=0
          @backwin.back_opacity=0
          color = set_skn_color 0
          @backwin.contents.fill_rect(0,0,680,200,color)
            
          #case "1"
          #when 1 then
            
            # カードウインドウ作成
            @cardwin = Window_Base.new(Cardxstr,Cardystr,Cardxend,Cardyend)
            @cardwin.opacity=0
            @cardwin.back_opacity=0

            # メニューウインドウ表示
            @mainwin = Window_Base.new(Mainxstr,Mainystr,Mainxend,Mainyend)
            @mainwin.opacity=255
            @mainwin.back_opacity=255
            
          if @msgwin == nil && $WinState == 4
            @msgwin = Window_Base.new(Msgxstr,Msgystr,Msgxend,Msgyend)
            @msgwin.opacity=255
            @msgwin.back_opacity=255
            #picture = Cache.picture("メニュー文字関係")
            #rect = Rect.new(0, 96, 256, 96) # メニュー文字格納
            #@msgwin.contents.blt(16 ,-2,picture,rect) 
          end
      end
        
        
      if $game_switches[9] == false
        # メニュー文字
        picture = Cache.picture("メニュー文字関係")
        if $map_on == true #マップ表示するか
          rect = Rect.new(0, 0, 64, 96) # メニュー文字格納
        else
          rect = Rect.new(0, 0, 64, 64) # メニュー文字格納マップ表示なし
        end
        @mainwin.contents.blt(16 ,-5,picture,rect)   
        
        # メニューカーソル表示
        picture = Cache.picture("アイコン")
        if $WinState == 0
          rect = set_yoko_cursor_blink
        else
          rect = set_yoko_cursor_blink 0 # カーソル格納
        end

        # 0:移動 1:メニュー 2:マップ
        @mainwin.contents.blt(0 ,5+$CursorState*32,picture,rect)
        
        # 0:能力 1:カード 2:セーブ 3:並び替え 4:未使用 5:あらすじ
        if $WinState == 4
          picture = Cache.picture("メニュー文字関係")
          rect = Rect.new(0, 96, 384, 96) # メニュー文字格納
          @msgwin.contents.blt(16 ,-2,picture,rect)
          picture = Cache.picture("アイコン")
          rect = set_yoko_cursor_blink
          if $MenuCursorState <= 2 #左
            @msgwin.contents.blt(0 ,4+$MenuCursorState*32,picture,rect)
          elsif $MenuCursorState <= 5 #中
            @msgwin.contents.blt(128 ,4+$MenuCursorState*32-96,picture,rect)
          elsif $MenuCursorState <= 8 #右
            @msgwin.contents.blt(256 ,4+$MenuCursorState*32-192,picture,rect)
          end
        else
          cardupdate
        end
      end
  end
  # メニューカーソル移動
  def WinKeyState(n)
    
    case n
    
    when "C" # 決定
      
      if $WinState == 0 # メニュー
      Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
        if $CursorState == 0 then
          $game_switches[3] = true # カード選択前
          $WinState = 1
          $CardCursorState = 0
        elsif $CursorState == 1 then
          $WinState = 4 #メニュー詳細
          $MenuCursorState = 0
          @msgwin = Window_Base.new(Msgxstr,Msgystr,Msgxend,Msgyend)
          @msgwin.opacity=255
          @msgwin.back_opacity=255
          #picture = Cache.picture("メニュー文字関係")
          #rect = Rect.new(0, 96, 256, 96) # メニュー文字格納
          #@msgwin.contents.blt(16 ,-2,picture,rect)  
        elsif $CursorState == 2 then
          $WinState = 3 #マップ状態に
          $game_switches[9] = true #MAP移動ON
          @mainwin.contents.clear
          @cardwin.contents.clear
          @backwin.contents.clear
          @mainwin.opacity=0
          @mainwin.back_opacity=0
          #@mainwin.dispose
          #@mainwin = nil
          #@cardwin.dispose
          #@cardwin = nil
          #@backwin.dispose
          #@backwin = nil
          #clear
          $game_variables[14] = $game_map.width-1
          $game_variables[15] = $game_map.height-11
        else
        
        end
      elsif $WinState == 1 # カード選択前
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        $WinState = 2 # カード選択後(移動前)
        $game_switches[5] = true #カード選択済みスイッチON
        $game_variables[7] = $carda[$CardCursorState] +1
        
        #時の間にいるなら移動力を最高にする
        if $game_variables[43] == 999
          $game_variables[7] = 8
        end

        #神龍で移動全て8マスにした
        if $game_switches[1320] == true
          $game_variables[7] = 8
        end
        
        #移動量増加(飛行機)使用状態
        if $game_variables[420] != 0 
          if $game_switches[860] == true
            $game_variables[7] *= 3
          else
            $game_variables[7] *= 2
          end
          #$game_variables[420] -= 1
        else
          #周回プレイ時は常に2倍
          if $game_switches[860] == true
            $game_variables[7] *= 2
          end
        end
        Input.update
      elsif $WinState == 2 # カード選択
        $game_switches[5] = false #カード選択済みスイッチON
        $game_switches[14] = false #1マス移動フラグ
        $game_switches[6] = true #移動後スイッチON
        $game_variables[12] = $CardCursorState #イベント上で選択カード変数を拾いたいので格納
        
        createcardval #追加されるカードの値を作成
        case $CardCursorState
        
        when 5 then
          $game_variables[11] = 20
        else
          $game_variables[11] = 6
        end
      elsif $WinState == 4 #メニュー詳細
        #Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
        $map_bgm = RPG::BGM.last.name
        # 0:能力 1:カード 2:セーブ 3:並び替え 4:Sコンボ 5:あらすじ 8:戦いの記録
        case $MenuCursorState 
        
        when 0 #能力
          #moveready
          Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
          $run_item_card_id = 0
          $game_temp.next_scene = "db_status"
          
        when 1 #カード
          Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
          #$map_bgm = RPG::BGM.last.name
          $background_bitmap = Graphics.snap_to_bitmap
          Graphics.fadeout(5)
          #@mainwin.contents.clear
          #@cardwin.contents.clear
          #@backwin.contents.clear
          #@mainwin.opacity=0
          #@mainwin.back_opacity=0
          #moveready
          #@backwin.dispose
          #@backwin = nil
          #@cardwin.dispose
          #@cardwin = nil
          #@mainwin.dispose
          #@mainwin = nil
          #@msgwin.dispose
          #@msgwin = nil
          #$game_switches[4] = false
          #$game_switches[2] = false
          #$game_switches[1] = false
          #$game_switches[474] = true
          $game_switches[479] = true
          $game_temp.next_scene = "db_card"
          
          moveready
          #$scene = Scene_Db_Card.new
          #p @mainwin,@backwin,@cardwin,@msgwin
        when 2 #セーブ
          #$WinState = 0
          #$CursorState = 0
          Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
          moveready
          $game_temp.next_scene = "save"
          
        when 3 #あらすじ
          
          if $game_variables[43] < 901
            Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
            Graphics.fadeout(30)
            moveready
            
            case $game_variables[43]
            
            when 0..20,101
              $scene = Scene_Story_So_Far.new
            else #Z2,Z3形式あらすじ表示
              $game_variables[41] = 201
              $game_switches[870] = true #あらすじオフにすると見れなくなってしまう対策
              $game_switches[13] = true #あらすじ表示フラグON 
              $game_player.reserve_transfer(7, 0, 0, 0) # 場所移動
              $scene = Scene_Map.new
            end
          else
            Audio.se_play("Audio/SE/" + $BGM_Error) # 効果音を再生する
          end
        when 4 #Sコンボ
          Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
          $scene = Scene_Db_Scombo_Menu.new
          Graphics.fadeout(5)
        when 5 #作戦
          Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
          $scene = Scene_Db_Tactics_Menu.new
          Graphics.fadeout(5)
        when 6 #戦いの記録
          Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
          Graphics.fadeout(5)
          moveready
          
          $game_variables[41] = 41
          $game_player.reserve_transfer(7, 0, 0, 0) # 場所移動
          $scene = Scene_Map.new
        when 7 #カード合成
          Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
          Graphics.fadeout(5)
          moveready
          $game_switches[1319] = false #合成開始フラグ初期化
          $game_variables[27] = 0 #カード合成進行状況初期化
          $game_switches[36] = false #カード合成キャンセルフラグ初期化
          $card_compo_no = {} #合成セットカード初期化
          $game_variables[41] = 45
          $game_player.reserve_transfer(7, 0, 0, 0) # 場所移動
          $scene = Scene_Map.new
        when 8 #オプション
          Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
          #moveready
          $scene = Scene_Db_Option.new
          
          #$scene = Scene_Db_Member_change.new
          Graphics.fadeout(5)
        end
        
      end  
      
    when "B" # キャンセル
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      if $WinState == 0 

      elsif $WinState == 1 #カード選択前
        $game_switches[3] = false
        $WinState = 0
        $CardCursorState = 0
      elsif $WinState == 2 #カード選択後(移動前)
        $WinState = 1 # カード選択後(移動前)
        #$game_switches[5] = false #カード選択済みスイッチOFF イベント側で
        $game_variables[7] = 0
        $game_variables[8] = 0
        $game_switches[14] = false
      elsif $WinState == 3 #マップ表示時
        $WinState = 0
        $CursorState = 0
      elsif $WinState == 4 #メニュー詳細
        $WinState = 0
        if @msgwin != nil
          @msgwin.dispose
          @msgwin = nil
        end
      elsif $WinState == 5 
        $WinState = 4
          @msgwin = Window_Base.new(Msgxstr,Msgystr,Msgxend,Msgyend)
          @msgwin.opacity=255
          @msgwin.back_opacity=255
      end         
    when 2 # 下
      
      if $WinState == 0
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $map_on == true #マップ表示するか
          if $CursorState < 2
            $CursorState += 1
          else
            $CursorState = 0
          end
        else
          if $CursorState < 1
            $CursorState += 1
          else
            $CursorState = 0
          end
        end
      
      elsif $WinState == 2
        #処理が分からないのでマップイベントにて対応
      elsif $WinState == 4
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $MenuCursorState == 2 || $MenuCursorState == 5  || $MenuCursorState == 8
          $MenuCursorState -= 2
        else
          $MenuCursorState += 1
        end
      end 
    when 4 # 左
      if $WinState == 0 then

      elsif  $WinState == 1 then
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $CardCursorState > 0 then
          $CardCursorState -= 1
        else
          $CardCursorState = $Cardmaxnum
        end
      elsif $WinState == 4
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $MenuCursorState >= 3 #左側以外なら
          $MenuCursorState -= 3
        else
          $MenuCursorState += 6
        end
      end
      
    when 6 # 右
      if $WinState == 0

      elsif  $WinState == 1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $CardCursorState < $Cardmaxnum
          $CardCursorState += 1
        else
          $CardCursorState = 0
        end
      elsif $WinState == 4
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $MenuCursorState <= 5  #右側以外なら
          $MenuCursorState += 3
        else
          $MenuCursorState -= 6
        end
      end
      
    when 8 # 上
      
      if $WinState == 0
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する

        if $map_on == true #マップ表示するか
          if $CursorState > 0
            $CursorState -= 1
          else
            $CursorState = 2
          end
        else
          if $CursorState > 0
            $CursorState -= 1
          else
            $CursorState = 1
          end
        end
      elsif $WinState == 4
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $MenuCursorState == 0 || $MenuCursorState == 3 || $MenuCursorState == 6
          $MenuCursorState += 2
        else
          $MenuCursorState -= 1
        end
      end 
      
  
    end
    
      
  end
  
  def encounter
    
    #エンカウント頻度設定
    if $game_variables[31] == 1 #普通
      battle_enc = 1
    elsif $game_variables[31] == 0 #少ない
      battle_enc = 1.5
    else $game_variables[31] == 2 #多い
      battle_enc = 0.5
    end
    
    #p chk_skill_learn (616,0)[0]
    #引き寄せスキルを持っているか
    if chk_skill_learn (616,0)[0] == true
      $encounter_count = 999
    else
      $encounter_count = 0
    end
    encount_run = false
    enc_rand = rand((5*battle_enc).prec_i)
    erea_enemy_no = []
    if $game_variables[39] == 0
      #set_battle_map
      #マップID判定

      case $game_variables[13]
      
      when 1,5,60,65,31 #ラディッツエリと蛇の道 時の間ラディッツエリア
        
        #敵の出やすさ
        enc_rand = rand((5*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          if $partyc.size != 1
            $battleenenum = rand(3)+1
          else
            $battleenenum = rand(2)+1
          end
          #敵配列をセット
          erea_enemy_no = [1,2,4,5]
        end

      when 8,10,12,13,61 #ガーリック系エリア
        #敵の出やすさ
        enc_rand = rand((5*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          if $game_variables[13] == 13 || $game_variables[13] == 61
            $battleenenum = rand(4)+2
          else
            $battleenenum = rand(3)+1
          end
          #敵配列をセット
          erea_enemy_no = [1,2,7,8,9]
        end

      when 15,63 #ベジータエリア
        enc_rand = rand((5*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(5)+2
          #敵配列をセット
          erea_enemy_no = [1,2,3,4,5,6]
        end
      when 50 #Z1ウィロー雪原エリア
        enc_rand = rand((5*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+2
          #敵配列をセット
          erea_enemy_no = [1,2,3,25]
        end
      when 51,64 #Z1ウィロー要塞エリア
        enc_rand = rand((5*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(5)+2
          #敵配列をセット
          erea_enemy_no = [1,2,3,25]
        end

      when 17 #Z2宇宙エリア
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+2
          #敵配列をセット
          erea_enemy_no = [31,34,37]
        end
      when 18,68 #Z2ナメック星エリア
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+2
          #敵配列をセット
          erea_enemy_no = [31,34,37]
        end
      when 22,67 #Z2キュイが居る洞窟
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+3
          #敵配列をセット
          erea_enemy_no = [31,34,37]
        end
      when 23 #Z2宇宙エリア(悟空)
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(2)+1
          #敵配列をセット
          erea_enemy_no = [31,34,37]
        end
      when 24,26,29,69,70,71 #Z2ナメック星エリア２,3,4
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          if $partyc.size != 1
            $battleenenum = rand(3)+3
          else
            $battleenenum = rand(2)+1
          end
          #敵配列をセット
          if $game_variables[43] == 36 || $game_variables[43] == 915 && $game_switches[119] == true
            #フリーザ最終
            erea_enemy_no = [33,36,39,42,44,47]
          else
            erea_enemy_no = [32,35,38,41,42]
          end
        end
      when 54 #Z2バーダック編宇宙エリア
        enc_rand = rand((4*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+1
          #敵配列をセット
          erea_enemy_no = [31,34,37,61,62,63,64]
        end
      when 33,73 #Z3ボールを集めろ
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+2
          #敵配列をセット
          erea_enemy_no = [103,106,109,111,114,117]
        end
      when 34 #Z3ベジータ登場
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(2)+1
          #敵配列をセット
          erea_enemy_no = [103,106,109,111,114,117]
        end
      when 78,79,80,81 #Z3魔凶星編
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          if $partyc.size != 2
            $battleenenum = rand(2)+2
          else
            $battleenenum = rand(2)+1
          end
          #敵配列をセット
          erea_enemy_no = [183,184,185]
        end
      when 82,83 #Z3魔凶星編(カリン塔)
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+4
          
          #敵配列をセット
          erea_enemy_no = [183,184,185]
        end
      when 37,74 #Z3ベジータ出撃
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(2)+1
          $battleenenum = rand(4)+2 if $game_variables[13] == 74 #時の間の場合敵を多くする
          #敵配列をセット
          erea_enemy_no = [104,107,110,112,115,118]
        end
      when 38,75 #Z3ブルマ救出
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+2
          #敵配列をセット
          erea_enemy_no = [104,107,110,112,115,118]
        end
      when 39,76 #Z3クウラ到着
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+2
          #敵配列をセット
          erea_enemy_no = [105,108,110,112,115,118]
        end
      when 40,77 #Z3人造人間
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+2
          #敵配列をセット
          erea_enemy_no = [137,174,175,176]
        end
      when 42,87 #Z4セル誕生の秘密
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+2
          #敵配列をセット
          erea_enemy_no = [137,174,175,176,189,193,207]
        end
      when 43,88 #Z4忍びよるセル！()
         #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          if $partyc.size != 1
            $battleenenum = rand(3)+1
            $battleenenum = rand(4)+2 if $game_variables[13] == 88 #時の間の場合敵を多くする
          else
            $battleenenum = 1
          end
          #敵配列をセット
          erea_enemy_no = [137,174,175,176,189,193,207,212]
        end
      when 46,89 #Z4ベジータ親子
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+1
          $battleenenum = rand(4)+2 if $game_variables[13] == 89 #時の間の場合敵を多くする

          #敵配列をセット
          erea_enemy_no = [137,174,175,176,189,193,207,212]
        end
      when 84,91 #新ナメック星を救え
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+2
          #敵配列をセット
          erea_enemy_no = [229,230,231,232]
        end
      when 90,92 #ビッグゲテスター内
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+3
          #敵配列をセット
          erea_enemy_no = [229,230,231,232]
          #erea_enemy_no = [234,235,236,237]
        end
      when 93,94 #人造人間13号編
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+3
          #敵配列をセット
          erea_enemy_no = [234,235,236,237]
        end
      when 48,95 #セルゲーム編
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+3
          #敵配列をセット
          erea_enemy_no = [197,199,201,203,205]
        end
      when 55 #Z4未来悟飯編
=begin
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(1)+1
          #敵配列をセット
          erea_enemy_no = [148]
        end
=end
      when 56 #Z4ブロリー編
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+3
          #敵配列をセット
          erea_enemy_no = [148]
        end
      when 97..99 #Z4ボージャック編
        #敵出現頻度
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+3
          #敵配列をセット
          
          if $game_variables[13] == 99
            erea_enemy_no = [198,200,202,204,206]
          else
            erea_enemy_no = [198,200,202,204]
          end
        end
      when 100 #ZG宇宙エリア(バーダック一味)
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+3
          #敵配列をセット
          erea_enemy_no = [32,35,38,41,42] #フリーザ最終前
          #erea_enemy_no = [31,34,37,61,62,63,64] #バーダック編と同じ敵
          #erea_enemy_no = [33,36,39,42,44,47]
        end
      when 101 #ZGターレスエリア(バーダック一味)
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+3
          #敵配列をセット
          erea_enemy_no = [33,36,39,42,44,47] #フリーザ最終エリア
        end
      when 102 #ZGスラッグエリア(バーダック一味)
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+3
          #敵配列をセット
          erea_enemy_no = [33,36,39,42,44,47,76] #フリーザ最終エリア
        end
      when 103 #ZGグランドアポロン
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+3
          #敵配列をセット
          erea_enemy_no = [155,159,162] 
        end
      when 104 #ZG西の砂漠
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+3
          #敵配列をセット
          erea_enemy_no = [155,159,162] 
        end
      when 105 #ZGブンブク島
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+3
          #敵配列をセット
          erea_enemy_no = [155,159,162]
          
          #リキニュウムのシナリオ
          if $game_variables[43] == 173
            #敵の数をセット
            $battleenenum = rand(4)+3
            #敵配列をセット
            erea_enemy_no = [156,160,163,228] 
          end
        end
      when 106 #ZG氷の都
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(3)+3
          #敵配列をセット
          erea_enemy_no = [155,159,162] 
        end
      when 107 #ZG西の都 トンガリタワーへ
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+3
          #敵配列をセット
          erea_enemy_no = [156,160,163] 
        end
      when 108 #ZGクーン星
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+3
          #敵配列をセット
          erea_enemy_no = [157,161,164,165,167,228] 
        end
      when 109 #ZGオウター星
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+3
          #敵配列をセット
          erea_enemy_no = [157,161,164,165,166,167,168,228] 
        end
      when 110 #ZG暗黒惑星
        
        enc_rand = rand((6*battle_enc).prec_i)
        if $encounter_count >= enc_rand then
          #エンカウントON
          encount_run = true
          #敵の数をセット
          $battleenenum = rand(4)+3
          $battleenenum = rand(4)+4 if $game_switches[845] == true #護衛ロボ全て倒したら
          #敵配列をセット
          erea_enemy_no = [157,161,164,165,166,167,168]
          erea_enemy_no = [165,166,167,168,169,170] if $game_switches[845] == true #護衛ロボ全て倒したら
        end
      end
    end
    
    if $game_switches[10] == true
        $encounter_count = 0
    else
        #敵に会いやすくする
        #$encounter_count += 1 if $encounter_count == 0
    end
    if $game_variables[39] != 0 #バブルス使用ターンを減らす
      $game_variables[39] -= 1
    end
    
    #p chk_skill_learn (617,0)[0]
    #追い払いスキルを持っているか
    if chk_skill_learn (617,0)[0] == true
      encount_run = false
    end
    
    if encount_run == true
      for x in 0..$battleenenum - 1
      
          #敵をセット
          $battleenemy[x] = erea_enemy_no[rand(erea_enemy_no.size)-1]
          $enehp[x] = $data_enemies[$battleenemy[x]].maxhp #敵hpを代入
          $enemp[x] = $data_enemies[$battleenemy[x]].maxmp #敵mpを代入
      end
      $WinState == 0
      battle_ready
      # 敵死亡状態
      $enedead = [nil]
      for x in 0..$battleenenum -1
        $enedead[x] = false
      end
      $enedeadchk = Marshal.load(Marshal.dump($enedead))
      $eneselfdeadchk = Marshal.load(Marshal.dump($enedead))
    end    
    
    
  end
  
  #背景取得
  def set_battle_map
        tile_id =$game_map.get_tile_id $game_variables[1],$game_variables[2]
        top_tile_id = $game_map.get_tile_id $game_variables[1],$game_variables[2],2
        tile_info = get_event_id_and_graphic $game_variables[1],$game_variables[2]
        
        #p tile_id,top_tile_id,tile_info
        
        #時の間に入っていたら特殊の方を取得
        if $game_switches[466] != true
          scenario_progress = $game_variables[40]
        else
          scenario_progress = $game_variables[301]
        end
        
        if scenario_progress == 0
          case tile_id
        
          when 1537,1545 #最初のフィールド
            $Battle_MapID = 0
          when 1576..1579,1584..1586,1592..1594 #蛇の道
            $Battle_MapID = 5
          when 1538,1546 #サンショエリア,ウィロー雪原
            map_id = rand(2)
            case map_id
            when 0
              $Battle_MapID = 2
            when 1
              $Battle_MapID = 6
            end
          when 1539,1547 #ニッキーエリア
            $Battle_MapID = 3
          when 1540,1548 #ジンジャーエリア
            $Battle_MapID = 4
          when 1541,1549 #ガーリックエリア
            $Battle_MapID = 7
          when 1542       #ベジータエリア
            if $game_variables[13] != 65
              $Battle_MapID = 8
            else
              $Battle_MapID = 11
            end
          when 1560..1574 #海
            $Battle_MapID = 1
          when 1556 #ウィローエリア
            $Battle_MapID = 10
          end
        elsif scenario_progress == 1
          case tile_id
          
          when 2048 #Z2宇宙
            $Battle_MapID = 0
          when 1543,1551,1580,1581,1588,1590,1596,1598  #ナメック星エリア
            $Battle_MapID = 2
          when 1575  #ナメック星海エリア
            $Battle_MapID = 3
          when 1542       #洞窟エリア
            $Battle_MapID = 5
          else
            $Battle_MapID = 0
          end
        elsif scenario_progress >= 2
          #p tile_id,top_tile_id,tile_info
          
          case tile_id
          
          when 1550 #セルゲームリング
            $Battle_MapID = 29
          
          when 1543,1551 #ナメック星エリア
            $Battle_MapID = 0
           when 1575  #ナメック星海エリア
            $Battle_MapID = 32
          when 1552,1555 #平原
            if top_tile_id == 274 || top_tile_id == 275
              $Battle_MapID = 4
            else
              if tile_info == nil
                $Battle_MapID = 1
              else
                if tile_info[0] == "animap1" && tile_info[1] == 0 && tile_info[2] == 2
                  $Battle_MapID = 2 #森
                elsif tile_info[0] == "animap1" && tile_info[1] == 1 && tile_info[2] == 6
                  $Battle_MapID = 9 #林
                else
                  $Battle_MapID = 1
                end
                
              end
            end
          when 1553 #砂漠
            $Battle_MapID = 5
            case top_tile_id
            
            when 556,553,544,540,536,552,512,516,522,524,548 #セルゲームリング
              $Battle_MapID = 29
            end
          
          when 1554 #雪原
            if top_tile_id == 276
              $Battle_MapID = 7
            else
              $Battle_MapID = 6
            end
          when 1600..1602 #崖
            if $game_variables[101] == 0
              $Battle_MapID = 1
            elsif $game_variables[101] == 1
              $Battle_MapID = 6
            else
              $Battle_MapID = 5
            end
          when 1591 #ビッグゲテスター内
            $Battle_MapID = 33
          when 1583  #新惑星ベジータエリア
            $Battle_MapID = 28
          when 1541,1549 #ボージャックエリア(ガーリックエリア)
            $Battle_MapID = 34
          when 1603,1604 #ZGグランドアポロン
            $Battle_MapID = 11
          when 1605 #ZGクーン星砂漠、サボテン廃墟
            if tile_info == nil
              if [930,922,807,938,799,931,936,937,944,954,953,952,925,932,933,955,939,923,940,956,948].index(top_tile_id) == nil
                $Battle_MapID = 24 #砂漠
              else
                $Battle_MapID = 25 #建物
              end
            else
              if tile_info[0] == "animap1" && tile_info[1] == 3 && tile_info[2] == 8
                $Battle_MapID = 23 #森
              else
                $Battle_MapID = 24 #砂漠
              end
            end
          when 1606 #ZG砂漠
            $Battle_MapID = 16
          when 1607 #ZG平原,山,森
            if tile_info == nil
              if top_tile_id == 627 #山
                $Battle_MapID = 12
              else #平原
                $Battle_MapID = 14
              end
            else
              if tile_info[0] == "animap1" && tile_info[1] == 2 && tile_info[2] == 4
                $Battle_MapID = 15 #森
              else
                $Battle_MapID = 14
              end
            end
          when 1611 #ZGオウター星
            if tile_info == nil
              if top_tile_id == 629 #山
                $Battle_MapID = 21
              else #平原
                $Battle_MapID = 20 #平原
              end
            else
              if tile_info[0] == "animap1" && tile_info[1] == 4 && tile_info[2] == 2
                $Battle_MapID = 22 #森
              else
                $Battle_MapID = 20
              end
            end
          when 1612 #ZG暗黒惑星
            $Battle_MapID = 18
          else
            if $game_variables[101] == 0
              $Battle_MapID = 3
            else
              $Battle_MapID = 8
            end
            
            if $game_variables[17] == 3 #海がZG3チップ
              $Battle_MapID = 13
            elsif $game_variables[17] == 4 #氷の大陸
              $Battle_MapID = 17
            elsif $game_variables[17] == 5 #クーン
              $Battle_MapID = 36 #クーン海
            elsif $game_variables[17] == 6 #オウター
              $Battle_MapID = 19
            end
          end
        end
  end
      
  #戦闘準備
  def battle_ready
    set_battle_map
    if $game_switches[111] == false
      Audio.bgm_stop 
      Audio.se_play("Audio/SE/" +$BGM_encount)    # 効果音を再生する
    else
      #Audio.me_play("Audio/SE/" +$BGM_encount)    # 効果音を再生する
      Audio.se_play("Audio/SE/" +$BGM_encount)    # 効果音を再生する
    end
    
    $game_switches[4] = false
    $game_switches[2] = false
    $game_switches[1] = false
    $game_switches[10] = true
    @backwin.dispose
    @backwin = nil
    @cardwin.dispose
    @cardwin = nil
    @mainwin.dispose
    @mainwin = nil
    #最大ダメージ格納を一時最大ダメージに格納
    $game_variables[209] = $game_variables[207]
    $game_variables[205] = $game_variables[203]
    $chadeadchk = Marshal.load(Marshal.dump($chadead))
    
    #パーティーの各フラグ更新
    update_party_detail_status 2
    
    $game_temp.next_scene = "db_battle"
  end
end