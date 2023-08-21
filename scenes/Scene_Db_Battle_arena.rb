#==============================================================================
# ■ Scene_Db_Battle_arena
#------------------------------------------------------------------------------
# 　闘技場画面
#==============================================================================
class Scene_Db_Battle_arena < Scene_Base
  include Share
  Party_win_sizex = 516         #パーティーウインドウサイズX
  Party_win_sizey = 412         #パーティーウインドウサイズY
  Technique_win_sizex = 180     #必殺技ウインドウサイズX
  Technique_win_sizey = 480-272 #必殺技ウインドウサイズY
  Partyy = 28#24                   #パーティー表示行空き数
  Partynox = 0                  #パーティー表示基準X
  Partynoy = 32                 #パーティー表示基準Y
  Status_lbx = 16               #詳細ステータス表示基準X
  Status_lby = 0                #詳細ステータス表示基準Y
  Techniquex = 0                #必殺技表示基準X
  Techniquey = 0                #必殺技表示基準Y
  Scombo_makix = 0 + 8              #まきもの位置X
  Scombo_makiy = 0              #まきもの位置Y
  Scombo_makitochaaki_x = 32     #まきものからどのくらい離すか
  Scombo_makitochaaki_y = 58    #まきものからどのくらい離すか
  Scombo_chayy = 134             #Sコンボパーティー表示行空き数
  Scombo_chatocardaki_x = 96    #Sコンボでキャラとカードの秋
  Scombo_chatotecakiy = 104      #対象必殺技表示
  Scombo_chatotecakix = 80       #対象必殺技表示
  #Techniquenamex = 184          #必殺技画像取得サイズX
  #Techniquenamey = 24           #必殺技画像取得サイズY
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize()
    
    #初めてアリーナに入った場合のため配列初期化確認
    chk_btl_rank_array 0
    $btl_arena_fight_rank[0] = true
  end
  
  #--------------------------------------------------------------------------
  # ● 配列初期化
  #     no : 配列数
  #--------------------------------------------------------------------------
  def chk_btl_rank_array(no)
    if $btl_arena_fight_rank[no] == nil
      $btl_arena_fight_rank[no] = false
      
    end
    
    if $btl_arena_fight_rank_clear_num[no] == nil
      $btl_arena_fight_rank_clear_num[no] = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    
    @window_state = 0         #ウインドウ状態(並び替え時のみ使用) 0:未選択 1:キャラ選択
    @cursor_scombo_select = 0      #Sコンボの選択キャラ
    
    @cursorstate = 0             #カーソル位置
    @cursorstate = $game_variables[341] if $game_variables[341] != 0
 
    @put_page = 0               #ページ
    @put_page = $game_variables[342] if $game_variables[342] != 0
    @cursorstate_side = 0         #カーソル位置横
    @taccursorstate = 0             #作戦カーソル位置
    @scombo_cha_num = 0    #スパーキングコンボ技数
    @scombo_cha_no = []    #技の番号
     
    @tecput_max = 7
    @chaput_page = 0
    @chaput_max = 3
    @yes_no_result = 0 #はい、いいえ結果
    create_window
    
    #create_menu_background
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    #pre_update
    @display_skill_level = -1
    @window_update_flag = true
    @s_up_cursor = Sprite.new
    @s_down_cursor = Sprite.new
    @c_up_cursor = Sprite.new
    @c_down_cursor = Sprite.new
    @tac_no= []
    set_up_down_cursor
    pre_update
    Graphics.fadein(5)
    
  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_window
    @party_window.dispose
    @party_window = nil
    #@status_window.dispose
    #@status_window = nil
    #@technique_window.dispose
    #@technique_window = nil
    @main_window.dispose
    @main_window = nil
  end 
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def window_contents_clear
    @party_window.contents.clear
    #@status_window.contents.clear
    #@technique_window.contents.clear
    @main_window.contents.clear
    if @result_window != nil
     @result_window.contents.clear
    end 
  end
  #--------------------------------------------------------------------------
  # ● 使用する、しないのウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_result_window
    @result_window.dispose
    @result_window = nil
  end
  #--------------------------------------------------------------------------
  # ● 使用する、しないのウインドウ作成
  #--------------------------------------------------------------------------  
  def create_result_window
    @result_window = Window_Base.new(180,160,300,100)
    @result_window.opacity=255
    @result_window.back_opacity=255
    @result_window.contents.font.color.set( 0, 0, 0)
    output_result
  end
  
  #--------------------------------------------------------------------------
  # ● エントリーはいいいえ表示
  #-------------------------------------------------------------------------- 
  def output_result
    #p @cursorstate + @put_page * 10 + 1
    selrank = @cursorstate + @put_page * 10 + 1
    #@result_window.contents.draw_text(0,0, 300, 40, "このカードを使用しますか？")
    mozi = "ランク" + selrank.to_s + "にエントリーしますか？"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4,2, $tec_mozi,rect)
    mozi = "　はい　　　いいえ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4,34, $tec_mozi,rect)
    #@result_window.contents.draw_text(0,30, 200, 40, "　はい　　　いいえ")
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    Graphics.fadeout(0)
    @main_window = Window_Base.new(-16,-16,672,512)
    @main_window.opacity=0
    @main_window.back_opacity=0
    @party_window = Window_Base.new((640 - Party_win_sizex) / 2,(480 - Party_win_sizey) / 2,Party_win_sizex,Party_win_sizey)
    @party_window.opacity=255
    @party_window.back_opacity=255

    
    Graphics.fadein(10)
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_sprite
    dispose_window
    #$scene = Scene_Map.new
    #$game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動    
  end
  #--------------------------------------------------------------------------
  # ● スプライト開放
  #--------------------------------------------------------------------------
  def dispose_sprite
    @s_up_cursor.bitmap = nil
    @s_down_cursor.bitmap = nil
    @s_up_cursor = nil
    @s_down_cursor = nil
    @c_up_cursor.bitmap = nil
    @c_down_cursor.bitmap = nil
    @c_up_cursor = nil
    @c_down_cursor = nil
  end
  #--------------------------------------------------------------------------
  # ● 上下カーソルの設定
  #-------------------------------------------------------------------------- 
  def set_up_down_cursor
   picture = Cache.picture("アイコン")
    
    #Sコンボ上カーソル
    # スプライトのビットマップに画像を設定
    @s_up_cursor.bitmap = Cache.picture("アイコン")
    @s_up_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @s_up_cursor.x = Technique_win_sizex - Technique_win_sizex/2 - 8
    @s_up_cursor.y = Party_win_sizey+16
    @s_up_cursor.z = 255
    @s_up_cursor.angle = 91
    @s_up_cursor.visible = false
    
    #Sコンボ下カーソル
    # スプライトのビットマップに画像を設定
    @s_down_cursor.bitmap = Cache.picture("アイコン")
    @s_down_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @s_down_cursor.x = Technique_win_sizex - Technique_win_sizex/2 + 8
    @s_down_cursor.y = 480-16
    @s_down_cursor.z = 255
    @s_down_cursor.angle = 269
    @s_down_cursor.visible = false
    
    #キャラ上カーソル
    # スプライトのビットマップに画像を設定
    @c_up_cursor.bitmap = Cache.picture("アイコン")
    @c_up_cursor.src_rect = Rect.new(16*0, 48, 16, 16)
    @c_up_cursor.x = 640-32
    @c_up_cursor.y = 80
    @c_up_cursor.z = 255
    @c_up_cursor.angle = 91
    @c_up_cursor.visible = false
    
    #キャラ下カーソル
    # スプライトのビットマップに画像を設定
    @c_down_cursor.bitmap = Cache.picture("アイコン")
    @c_down_cursor.src_rect = Rect.new(16*1, 48, 16, 16)
    @c_down_cursor.x = 640-32
    @c_down_cursor.y = 480
    @c_down_cursor.z = 255
    @c_down_cursor.angle = 91
    @c_down_cursor.visible = false
  end

  #--------------------------------------------------------------------------
  # ● キャラクター表示ページの設定
  #-------------------------------------------------------------------------- 
  def set_chapage add
    
      x=@scombo_cha_no[@cursor_scombo_select+@put_page * @tecput_max]
      
      if ($scombo_cha_count[x]-1) / @chaput_max > 0
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      end
      if add == 1
        
        if @c_down_cursor.visible == true
          @chaput_page += 1
        else
          @chaput_page = 0
        end
      else
        if @c_up_cursor.visible == true
          @chaput_page -= 1
          
        else
          @chaput_page = ($scombo_cha_count[x]-1) / @chaput_max
          
        end
      end

  end
  #--------------------------------------------------------------------------
  # ● 必殺技表示ページの設定
  #-------------------------------------------------------------------------- 
  def set_tecpage add
    
      if (@scombo_cha_num -1) / @tecput_max > 0
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      end
      if add == 1
        
        if @s_down_cursor.visible == true
          @put_page += 1
          #p @scombo_cha_num -1 ,@cursor_scombo_select + @put_page * @tecput_max
          if @scombo_cha_num -1 < @cursor_scombo_select + @put_page * @tecput_max
            #p @scombo_cha_num -1 - @put_page * @tecput_max
            @cursor_scombo_select = @scombo_cha_num -1 - @put_page * @tecput_max
          end
        else
          @put_page = 0
        end
      else
        if @s_up_cursor.visible == true
          @put_page -= 1

        else
          @put_page = (@scombo_cha_num -1) / @tecput_max
          if @scombo_cha_num -1 < @cursor_scombo_select + @put_page * @tecput_max
            #p @scombo_cha_num -1 - @put_page * @tecput_max
            @cursor_scombo_select = @scombo_cha_num -1 - @put_page * @tecput_max
          end
        end
      end

  end
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------
  def pre_update
    #super
    
    if @window_update_flag == true
      window_contents_clear
      
      color = set_skn_color 0
      @main_window.contents.fill_rect(0,0,656,496,color)
      output_rank
      if @result_window != nil
        output_result
      end
      @main_window.update
      #@status_window.update
      @party_window.update
      
      #@technique_window.update
      @window_update_flag = false
    end
    output_cursor
    
    
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    
    #chk_up = false #更新チェック
    
    #Graphics.update
    #Input.update
    if Input.trigger?(Input::C)
      @window_update_flag = true
      if @window_state == 0
        if @cursorstate >= 0 and @cursorstate <= 9
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          create_result_window
          @yes_no_result = 0
          @window_state = 1
          
        elsif @cursorstate == 10
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)
          chk_put_rank
          
        elsif @cursorstate == 11
          Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
          Graphics.fadeout(20)
          $game_variables[41] = 0       # 実行イベント初期化 
          $scene = Scene_Map.new
          $game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
        else
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        end

      elsif @window_state == 1 #YESNO
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        dispose_result_window
        if @yes_no_result == 0
          $game_variables[282] = @cursorstate + @put_page * 10 + 1 #バトルアリーナ選択ランク
          
          $game_variables[283] = 1 #バトルアリーナ何回戦か
          $game_variables[41] = 90011
          $game_variables[341] = @cursorstate
          $game_variables[342] = @put_page
          $scene = Scene_Map.new
          $game_player.reserve_transfer(7, 1, 1, 0) # 場所移動
          
          #覚醒の敵を選んだかチェック
          case $game_variables[282]
          
          #70:覚醒ガーリック
          when 70..100
            #覚醒キャラ選択フラグを有効に
            $game_switches[876] = true
          end
        else
          @window_state = 0
          #dispose_result_window
        end
      end
    end
    if Input.trigger?(Input::B)
      @window_update_flag = true

      if @window_state == 0
        Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
        Graphics.fadeout(20)
        $game_variables[41] = 0       # 実行イベント初期化 
        $scene = Scene_Map.new
        $game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
      elsif @window_state == 1
        @window_state = 0
        dispose_result_window
      elsif @window_state == 2
        @window_state = 1
      elsif @window_state == 3
        @window_state = 1
      end

    end

    if Input.trigger?(Input::X)
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      #@display_skill_level = -@display_skill_level
    end
    
    if Input.trigger?(Input::L)
      #if @window_state == 0
      #  @window_update_flag = true
      #  Audio.se_play("Audio/SE/" + $BGM_CursorOn)
      #  chk_put_rank
      #end
      
    end
    
    if Input.trigger?(Input::R)
      #if @window_state == 0
      #  @window_update_flag = true
      #  Audio.se_play("Audio/SE/" + $BGM_CursorOn)
      #  chk_put_rank
      #end
    end
    
    if Input.trigger?(Input::DOWN)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #chk_up = true
      if @window_state == 2 #指定の技

      elsif @window_state == 3 #KIが減っているとき

      else
        move_cursor 2 #カーソル移動
      end
    elsif Input.trigger?(Input::UP)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #chk_up = true
      
      if @window_state == 2

      elsif @window_state == 3

      else
        move_cursor 8 #カーソル移動
      end
    elsif Input.trigger?(Input::RIGHT)
      if @window_state == 0
      #  set_tecpage 1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 6 #カーソル移動
      elsif @window_state == 1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if @yes_no_result == 0
          @yes_no_result = 1
        else
          @yes_no_result = 0
        end
      end
    elsif Input.trigger?(Input::LEFT)
      if @window_state == 0
      #  set_tecpage -1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 4 #カーソル移動
      elsif @window_state == 1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if @yes_no_result == 0
          @yes_no_result = 1
        else
          @yes_no_result = 0
        end
      end
    end
    
    @window_update_flag = true if Input.dir8 != 0 #何かカーソルを押したら画面を更新フラグをON
    #if chk_up == true #カーソル動かした時のみ画面更新
    pre_update
    #end
    
    
  end
  #--------------------------------------------------------------------------
  # ● ランク表示チェック
  #-------------------------------------------------------------------------- 
  def chk_put_rank(chkmode=false)

    if @cursorstate_side == 0 #前へ
      @put_page -= 1 if @put_page != 0
    else #次へ
      if $btl_arena_fight_rank.size > (@put_page+1) * 10
        #p $btl_arena_fight_rank.size,(@put_page+1) * 10
        @put_page += 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------  
  def output_cursor
    $cursor_blink_count += 1
    picture = Cache.picture("アイコン")
    rect = set_yoko_cursor_blink
    
    if @cursorstate < 10
      @party_window.contents.blt(Partynox + @cursorstate_side * 288,Partynoy+@cursorstate*Partyy+8,picture,rect)
    else
      @party_window.contents.blt(Partynox + @cursorstate_side * 288,Partynoy+@cursorstate*Partyy+8+8,picture,rect)
    end
     
    if @result_window != nil #カード使用はいいいえ表示
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @result_window.contents.blt(@yes_no_result*80+2,42,picture,rect)
    end
    
  end
 
  #--------------------------------------------------------------------------
  # ● ランク一覧表示
  #-------------------------------------------------------------------------- 
  def output_rank
    #picturea = Cache.picture("名前")
    #pictureb = Cache.picture("数字英語")
    #picturec = Cache.picture("アイコン")
    #rect = Rect.new(128, 16, 32, 16) #No
    #@party_window.contents.blt(Partynox+16 ,Partynoy-32,pictureb,rect)
    mozi = "　ー　ランクのせんたく　ー"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @party_window.contents.blt(Partynox+16 ,Partynoy-32,picture,rect)
    
    mozi = "クリアかいすう"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @party_window.contents.blt(Partynox+368 ,Partynoy-32,picture,rect)
    
    koteimozi_rank = "ランク"
    #p $btl_arena_fight_rank.size
    
    if (@put_page +1) * 10 > $btl_arena_fight_rank.size
      put_end_rank = $btl_arena_fight_rank.size
    else
      put_end_rank = (@put_page +1) * 10
    end
     
    for x in (1+10*@put_page)..put_end_rank
      
      #rect = Rect.new((x+1)*16, 48, 16, 16) #No
      #@party_window.contents.blt(Partynox+16+2,Partynoy+x*Partyy,pictureb,rect)

      #rect = Rect.new(0, 0+(($partyc[x]-3)*16), 160, 16) # 名前
      #@party_window.contents.blt(Partynox+32+4,Partynoy+x*Partyy,picturea,rect)
      
      chk_btl_rank_array x-1
      if $btl_arena_fight_rank[x-1] == true
        #初回報酬取得済みアイコン表示
        if $btl_arena_first_item_get[x-1] == nil
          $btl_arena_first_item_get[x-1] = 0
        end
        
        if $btl_arena_first_item_get[x-1] > 0
          picture = Cache.picture("アイコン")
          #rect = Rect.new(464, 2, 14, 14) #ドラゴンボール中黒
          #rect = Rect.new(480, 2, 14, 14) #ドラゴンボール中赤
          rect = Rect.new(496, 2, 14, 14) #ドラゴンボール外黒
          @party_window.contents.blt(Partynox+32+4-16,Partynoy+(x-1-(10*@put_page))*Partyy+10,picture,rect)
        end
        
        mozi = koteimozi_rank + x.to_s
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @party_window.contents.blt(Partynox+32+4,Partynoy+(x-1-(10*@put_page))*Partyy,picture,rect)
        
        mozi = ($btl_arena_fight_rank_clear_num[x-1].to_s + "かい").to_s
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @party_window.contents.blt(Partynox+432-((mozi.size - 7) * 16),Partynoy+(x-1-(10*@put_page))*Partyy,picture,rect)
        
        if $btl_arena_fight_rank_clear_num[x-1] > 0
          mozi = "：" + (get_btl_arena_fight_name x).to_s
        else
          mozi = "：？？？？？？？？？？？"
        end
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @party_window.contents.blt(Partynox+32+4 + 80,Partynoy+(x-1-(10*@put_page))*Partyy,picture,rect)
        
        #初回報酬済み
        #if $btl_arena_first_item_get[x -1] == 1
        #  mozi = "スミ"
        #  output_mozi mozi
        #  rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        #  picture = $tec_mozi
        #  @party_window.contents.blt(Partynox+432-48-((mozi.size - 7) * 16),Partynoy+(x-1-(10*@put_page))*Partyy,picture,rect)
        #end
      end
      
    end
    
    x = 11
    mozi = "まえへ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @party_window.contents.blt(Partynox+32+4,Partynoy+(x-1)*Partyy+8,picture,rect)
    
    x = 11
    mozi = "つぎへ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @party_window.contents.blt(Partynox+64+4+256,Partynoy+(x-1)*Partyy+8,picture,rect)
    
    
    x = 12
    mozi = "おわる"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @party_window.contents.blt(Partynox+32+4,Partynoy+(x-1)*Partyy+8,picture,rect)

  end

  #--------------------------------------------------------------------------
  # ● カーソル移動
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def move_cursor n
    
    case n
    
    when 2 #下
      
    
      if @window_state == 0
        #@put_page = 0
        @cursorstate +=1
        
        if @cursorstate < 10
          chk_btl_rank_array @cursorstate + @put_page * 10
          if $btl_arena_fight_rank[@cursorstate + @put_page * 10] != true
            @cursorstate = 10
          end
        elsif @cursorstate == 12
          @cursorstate = 0
          @cursorstate_side = 0
        else
          @cursorstate_side = 0
        end
      else
        @taccursorstate += 1 
        if @taccursorstate >= @tac_no.size
          @taccursorstate = 0
        end
      end

    when 8 #上

      if @window_state == 0
        #@put_page = 0
        @cursorstate -=1
        
        if @cursorstate <= -1
          @cursorstate = 11
          @cursorstate_side = 0
        elsif @cursorstate == 10
          
        else
          @cursorstate_side = 0
          if $btl_arena_fight_rank[@cursorstate + @put_page * 10] != true
            ((1 + @put_page) * 10 -1).step(@put_page * 10, -1) do |x|
              chk_btl_rank_array x
              if $btl_arena_fight_rank[x] == true
                @cursorstate = (x - @put_page * 10)
                break
              end
            end
          end
        end
      else
        @taccursorstate -= 1
        if @taccursorstate <= -1
          @taccursorstate = @tac_no.size-1
        end
      end

    when 6 #右
      if @window_state == 0
        
        if @cursorstate == 10
          if @cursorstate_side == 0
            @cursorstate_side = 1
          else
            @cursorstate_side = 0
          end
        end
      end
    when 4 #左
      if @window_state == 0
        if @cursorstate == 10
          if @cursorstate_side == 0
            @cursorstate_side = 1
          else
            @cursorstate_side = 0
          end
        end
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # ● メニュー再生
  #--------------------------------------------------------------------------    
  def set_bgm
      set_menu_bgm_name true
      if $option_menu_bgm_name.include?("_user") == false
        Audio.bgm_play("Audio/BGM/" + $option_menu_bgm_name)    # 効果音を再生する
      else
        Audio.bgm_play("Audio/MYBGM/" + $option_menu_bgm_name)    # 効果音を再生する
      end
  end
end