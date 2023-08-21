#==============================================================================
# ■ Scene_Db_Tactics_Menu
#------------------------------------------------------------------------------
# 　能力表示画面
#==============================================================================
class Scene_Db_Tactics_Menu < Scene_Base
  include Share
  Party_win_sizex = 180         #パーティーウインドウサイズX
  Party_win_sizey = 480         #パーティーウインドウサイズY
  Status_win_sizex = 640-180    #詳細ステータスウインドウサイズX
  Status_win_sizey = 480        #詳細ステータスウインドウサイズY
  Technique_win_sizex = 180     #必殺技ウインドウサイズX
  Technique_win_sizey = 480-272 #必殺技ウインドウサイズY
  Partyy = 44#24                   #パーティー表示行空き数
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
  #     call_state : どのプログラムから呼ばれたか 1:戦闘 2:マップ 3:カード 4:修行
  #--------------------------------------------------------------------------
  def initialize(call_state = 2)
    @call_state = call_state
    if @call_state == 2
      set_bgm
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
    @taccursorstate = 0             #作戦カーソル位置
    @run_card_result = false      #カード使用結果
    @scombo_cha_num = 0    #スパーキングコンボ技数
    @scombo_cha_no = []    #技の番号
    @tecput_page = 0
    @tecput_max = 7
    @chaput_page = 0
    @chaput_max = 3
    create_window
    #pre_update
    Graphics.fadein(5)
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
    
    #指定の技の必殺技が存在しない場合初期化
    set_tactec_learn $partyc[@cursorstate],$cha_tactics[7][$partyc[@cursorstate]],$game_actors[$partyc[@cursorstate]].skills[0].id
  
=begin
    #指定の技の必殺技が存在しない場合初期化
    if chk_tec_learn($partyc[@cursorstate],$cha_tactics[7][$partyc[@cursorstate]]) == false
      
      tactecno = $cha_tactics[7][$partyc[@cursorstate]]
      
      case tactecno
        
      when 53 #激烈魔閃光
        $cha_tactics[7][$partyc[@cursorstate]] = 54
      when 54 #スーパーかめはめ波
        $cha_tactics[7][$partyc[@cursorstate]] = 53
      else
        $cha_tactics[7][$partyc[@cursorstate]] = $game_actors[$partyc[@cursorstate]].skills[0].id
      end
    end
=end
    set_up_down_cursor
    
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
    @s_up_cursor.y = Party_win_sizey+16#Status_win_sizey+16+32
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
    
      x=@scombo_cha_no[@cursor_scombo_select+@tecput_page * @tecput_max]
      
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
          @tecput_page += 1
          #p @scombo_cha_num -1 ,@cursor_scombo_select + @tecput_page * @tecput_max
          if @scombo_cha_num -1 < @cursor_scombo_select + @tecput_page * @tecput_max
            #p @scombo_cha_num -1 - @tecput_page * @tecput_max
            @cursor_scombo_select = @scombo_cha_num -1 - @tecput_page * @tecput_max
          end
        else
          @tecput_page = 0
        end
      else
        if @s_up_cursor.visible == true
          @tecput_page -= 1

        else
          @tecput_page = (@scombo_cha_num -1) / @tecput_max
          if @scombo_cha_num -1 < @cursor_scombo_select + @tecput_page * @tecput_max
            #p @scombo_cha_num -1 - @tecput_page * @tecput_max
            @cursor_scombo_select = @scombo_cha_num -1 - @tecput_page * @tecput_max
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
      get_technique
      window_contents_clear
      output_party
      output_status
      #output_technique
      @status_window.update
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
        #if @scombo_cha_num > 0
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @window_state = 1
          #@cursor_scombo_select = 0
          #@tecput_page = 0
          #@chaput_page = 0
          @taccursorstate = 0
        #else
        #  Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        #end
      elsif @window_state == 1 #作戦設定
        if @tac_no[@taccursorstate] == @tac_tec_name && $cha_tactics[1][$partyc[@cursorstate]] == 4
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @window_state = 2
        elsif @tac_no[@taccursorstate] == @tac_kiheri_name && $cha_tactics[6][$partyc[@cursorstate]] == 1
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @window_state = 3
        end
      elsif @window_state == 2 #指定の技
        @window_state = 1
      elsif @window_state == 3 #気が減っているとき
        @window_state = 1
      end
    end
    if Input.trigger?(Input::B)
      @window_update_flag = true
      if @call_state == 1 #戦闘
        if @window_state == 0
          $chadeadchk = Marshal.load(Marshal.dump($chadead))
          Graphics.fadeout(5)
          $scene = Scene_Db_Battle.new ($battle_escape,$battle_bgm,$battle_ready_bgm)
        elsif @window_state == 1
          #@c_down_cursor.visible = false
          #@c_up_cursor.visible = false
          @window_state = 0
          #@tecput_page = 0
          #@chaput_page = 0
          #@cursor_scombo_select = 0
          @taccursorstate = 0
        elsif @window_state == 2
          @window_state = 1
        elsif @window_state == 3
          @window_state = 1
        end
      else
        if @window_state == 0
          Graphics.fadeout(5)
          Audio.bgm_play("Audio/BGM/" + $map_bgm)    # 効果音を再生する
          $scene = Scene_Map.new
        elsif @window_state == 1
          #@c_down_cursor.visible = false
          #@c_up_cursor.visible = false
          @window_state = 0
          @taccursorstate = 0
          #@tecput_page = 0
          #@chaput_page = 0
          #@cursor_scombo_select = 0
          #Audio.bgm_play("Audio/BGM/" + $map_bgm)    # 効果音を再生する
          #@cursorstate = @cursor_chara_select
        elsif @window_state == 2
          @window_state = 1
        elsif @window_state == 3
          @window_state = 1
        end
      end
    end

    if Input.trigger?(Input::X)
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      #@display_skill_level = -@display_skill_level
    end
    
    if Input.trigger?(Input::L)
      #if @window_state == 1
      #  @window_update_flag = true
      #  set_chapage -1
      #end
    end
    
    if Input.trigger?(Input::R)
      #if @window_state == 1
      #  @window_update_flag = true
      #  set_chapage 1
      #end
    end
    
    if Input.trigger?(Input::DOWN)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #chk_up = true
      if @window_state == 2 #指定の技
        #for x in 0..$game_actors[$partyc[@cursorstate]].skills.size - 1
        #  chaskillno = x if $cha_tactics[7][$partyc[@cursorstate]] == $game_actors[$partyc[@cursorstate]].skills[x].id
        #end
        #if chaskillno == $game_actors[$partyc[@cursorstate]].skills.size - 1
        #  chaskillno = 0
        #else
        #  chaskillno += 1
        #end
        #
        #$cha_tactics[7][$partyc[@cursorstate]] = $game_actors[$partyc[@cursorstate]].skills[chaskillno].id
        chgcha_tactics 7,@cursorstate,1,1
      elsif @window_state == 3 #KIが減っているとき
        #if $cha_tactics[8][$partyc[@cursorstate]] <= 1
        #  $cha_tactics[8][$partyc[@cursorstate]] = 99
        #else
        #  $cha_tactics[8][$partyc[@cursorstate]] -= 1
        #end
        chgcha_tactics 8,@cursorstate,1,-1
      else
        move_cursor 2 #カーソル移動
        if chk_tec_learn($partyc[@cursorstate],$cha_tactics[7][$partyc[@cursorstate]]) == false
          $cha_tactics[7][$partyc[@cursorstate]] = $game_actors[$partyc[@cursorstate]].skills[0].id
        end
      end
    elsif Input.trigger?(Input::UP)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #chk_up = true
      
      if @window_state == 2
        #for x in 0..$game_actors[$partyc[@cursorstate]].skills.size - 1
        #  chaskillno = x if $cha_tactics[7][$partyc[@cursorstate]] == $game_actors[$partyc[@cursorstate]].skills[x].id
        #end
        #if chaskillno == 0
        #  chaskillno = $game_actors[$partyc[@cursorstate]].skills.size - 1
        #else
        #  chaskillno -= 1
        #end
        
        #$cha_tactics[7][$partyc[@cursorstate]] = $game_actors[$partyc[@cursorstate]].skills[chaskillno].id
        
        chgcha_tactics 7,@cursorstate,1,-1
      elsif @window_state == 3
        #if $cha_tactics[8][$partyc[@cursorstate]] >= 99
        #  $cha_tactics[8][$partyc[@cursorstate]] = 1
        #else
        #  $cha_tactics[8][$partyc[@cursorstate]] += 1
        #end
        chgcha_tactics 8,@cursorstate,1,1
      else
        move_cursor 8 #カーソル移動
        
        if chk_tec_learn($partyc[@cursorstate],$cha_tactics[7][$partyc[@cursorstate]]) == false
          $cha_tactics[7][$partyc[@cursorstate]] = $game_actors[$partyc[@cursorstate]].skills[0].id
        end
      end
    elsif Input.trigger?(Input::RIGHT)
      if @window_state == 1
      #  get_technique
      #  set_tecpage 1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 6 #カーソル移動
      elsif @window_state == 3
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        #$cha_tactics[8][$partyc[@cursorstate]] += 5
        #if $cha_tactics[8][$partyc[@cursorstate]] > 99
        #  $cha_tactics[8][$partyc[@cursorstate]] -= 99
        #end
        chgcha_tactics 8,@cursorstate,5,1
      end
    elsif Input.trigger?(Input::LEFT)
      if @window_state == 1
      #  get_technique
      #  set_tecpage -1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 4 #カーソル移動
      elsif @window_state == 3
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        #$cha_tactics[8][$partyc[@cursorstate]] -= 5
        #if $cha_tactics[8][$partyc[@cursorstate]] < 1
        #  $cha_tactics[8][$partyc[@cursorstate]] += 99
        #end
        
        chgcha_tactics 8,@cursorstate,5,-1
      end
    end
    
    @window_update_flag = true if Input.dir8 != 0 #何かカーソルを押したら画面を更新フラグをON
    #if chk_up == true #カーソル動かした時のみ画面更新
    pre_update
    #end
    
    
  end
  
  #--------------------------------------------------------------------------
  # ● キャラの作戦設定の値を変更します
  #-------------------------------------------------------------------------- 
  def chgcha_tactics no,cursor,value,houkou
    
    case no
    
    when 0 #テキ選択2種類
      if $cha_tactics[no][$partyc[cursor]] == 1
        $cha_tactics[no][$partyc[cursor]] = 0
      else
        $cha_tactics[no][$partyc[cursor]] = 1
      end
    
    when 1  #必殺選択5種類
      
      if houkou == 1
        if $cha_tactics[no][$partyc[cursor]] == 4
          $cha_tactics[no][$partyc[cursor]] = 0
        else
          $cha_tactics[no][$partyc[cursor]] += value
        end
      else
        if $cha_tactics[no][$partyc[cursor]] == 0
          $cha_tactics[no][$partyc[cursor]] = 4
        else
          $cha_tactics[no][$partyc[cursor]] -= value
        end
      end
    
    when 2 #変身技使用2種類
      if $cha_tactics[no][$partyc[cursor]] == 1
        $cha_tactics[no][$partyc[cursor]] = 0
      else
        $cha_tactics[no][$partyc[cursor]] = 1
      end
    
    when 3 #超サイヤ人状態維持2種類
      if $cha_tactics[no][$partyc[cursor]] == 1
        $cha_tactics[no][$partyc[cursor]] = 0
      else
        $cha_tactics[no][$partyc[cursor]] = 1
      end
    
    when 4 #経験値取得2種類
      if $cha_tactics[no][$partyc[cursor]] == 1
        $cha_tactics[no][$partyc[cursor]] = 0
      else
        $cha_tactics[no][$partyc[cursor]] = 1
      end
    
    when 5 #気が足りない
      if $cha_tactics[no][$partyc[cursor]] == 1
        $cha_tactics[no][$partyc[cursor]] = 0
      else
        $cha_tactics[no][$partyc[cursor]] = 1
      end
    
    when 6#気が減る設定
      if $cha_tactics[no][$partyc[cursor]] == 1
        $cha_tactics[no][$partyc[cursor]] = 0
      else
        $cha_tactics[no][$partyc[cursor]] = 1
      end
    
    when 7#指定の技
      for x in 0..$game_actors[$partyc[cursor]].skills.size - 1
        chaskillno = x if $cha_tactics[no][$partyc[cursor]] == $game_actors[$partyc[cursor]].skills[x].id
      end
      
      if houkou == 1 
        if chaskillno == $game_actors[$partyc[cursor]].skills.size - 1
          chaskillno = 0
        else
          chaskillno += value
        end
      else
        if chaskillno == 0
          chaskillno = $game_actors[$partyc[@cursorstate]].skills.size - 1
        else
          chaskillno -= value
        end
      end
      #p $game_actors[$partyc[cursor]].skills[chaskillno].id
      $cha_tactics[no][$partyc[cursor]] = $game_actors[$partyc[cursor]].skills[chaskillno].id
    when 8 #気が減る％
      
      if houkou == 1 
        $cha_tactics[no][$partyc[cursor]] += value
        if $cha_tactics[no][$partyc[cursor]] > 99
          $cha_tactics[no][$partyc[cursor]] -= 99
        end
      else
        $cha_tactics[no][$partyc[cursor]] -= value
        if $cha_tactics[no][$partyc[cursor]] < 1
          $cha_tactics[no][$partyc[cursor]] += 99
        end
      end
    end
    
    synccha = 0
    case $partyc[cursor]
    
    when 3 #ゴクウ
      synccha = 14
      
    when 14 #超ゴクウ
      synccha = 3
      
    when 5 #ゴハン
      synccha = 18
    when 18 #超ゴハン
      synccha = 5
    when 12 #べジータ
      synccha = 19
    when 19 #超べジータ
      synccha = 12
    when 16 #バーダック
      synccha = 32
    when 32 #超バーダック
      synccha = 16
    when 17 #トランクス
      synccha = 20
    when 20 #超トランクス
      synccha = 17
    when 25 #未来ゴハン
      synccha = 26
    when 26 #超未来ゴハン
      synccha = 25
    end
    if synccha != 0
      for x in 0..$cha_tactics.size - 1
        if x != 7 #指定の技以外を同期する 
          $cha_tactics[x][synccha] = $cha_tactics[x][$partyc[cursor]]
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_window
    @party_window.dispose
    @party_window = nil
    @status_window.dispose
    @status_window = nil
    #@technique_window.dispose
    #@technique_window = nil
  end 
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def window_contents_clear
    @party_window.contents.clear
    @status_window.contents.clear
    #@technique_window.contents.clear
  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    Graphics.fadeout(0)
    #@party_window = Window_Base.new(Status_win_sizex,0,Party_win_sizex,Party_win_sizey)
    @party_window = Window_Base.new(0,0,Party_win_sizex,Party_win_sizey)
    @party_window.opacity=255
    @party_window.back_opacity=255
    @status_window = Window_Base.new(Party_win_sizex,0,Status_win_sizex,Status_win_sizey)
    @status_window.opacity=255
    @status_window.back_opacity=255
    #@technique_window = Window_Base.new(0,Party_win_sizey,Technique_win_sizex,Technique_win_sizey)
    #@technique_window.opacity=255
    #@technique_window.back_opacity=255
    Graphics.fadein(10)
  end
 
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------  
  def output_cursor
    $cursor_blink_count += 1
    picture = Cache.picture("アイコン")
    rect = set_yoko_cursor_blink
    @party_window.contents.blt(Partynox,Partynoy+@cursorstate*Partyy,picture,rect)
    tactyouseix = -2
    for z in 0..@tac_no.size - 1
      
      if @taccursorstate == z && @window_state == 2 || @taccursorstate == z && @window_state == 3
        rect = set_yoko_cursor_blink 0,1,1
      elsif @taccursorstate == z && @window_state == 1
        rect = set_yoko_cursor_blink
      else
        rect = set_yoko_cursor_blink 0 # アイコン
      end
      #p @cursortacy[z]

      set_cha_tactics_nil_to_zero $partyc[@cursorstate]
      
      case @tac_no[z]
      
      when @tac_tage_name #テキ選択2種類
        if $cha_tactics[0][$partyc[@cursorstate]] == 1
          @status_window.contents.blt(@cursortacx + tactyouseix + @tac_syousaimoziakix*16,@cursortacy[z] + 8,picture,rect)
        else
          @status_window.contents.blt(@cursortacx + tactyouseix,@cursortacy[z] + 8,picture,rect)
        end
      when @tac_tec_name  #必殺選択5種類
        
        if $cha_tactics[1][$partyc[@cursorstate]] == 0
          @status_window.contents.blt(@cursortacx + tactyouseix,@cursortacy[z] + 8,picture,rect)
        elsif $cha_tactics[1][$partyc[@cursorstate]] == 1
          @status_window.contents.blt(@cursortacx + tactyouseix + @tac_syousaimoziakix*16,@cursortacy[z] + 8,picture,rect)
        elsif $cha_tactics[1][$partyc[@cursorstate]] == 2
          @status_window.contents.blt(@cursortacx + tactyouseix,@cursortacy[z] + 8 + @tac_syousaiy,picture,rect)
        elsif $cha_tactics[1][$partyc[@cursorstate]] == 3
          @status_window.contents.blt(@cursortacx + tactyouseix + @tac_syousaimoziakix*16,@cursortacy[z] + 8 + @tac_syousaiy,picture,rect)
        else
          @status_window.contents.blt(@cursortacx + tactyouseix,@cursortacy[z] + 8 + @tac_syousaiy*2,picture,rect)
        end
        
        #if @window_state == 2 #指定の技
        #  rect = set_yoko_cursor_blink 1 # アイコン
        #  @status_window.contents.blt(@cursortacx + tactyouseix,@cursortacy[z] + 8 + @tac_syousaiy*2,picture,rect)
        #end
      when @tac_tec_nonki_name #気が足りないとき
        if $cha_tactics[5][$partyc[@cursorstate]] == 1
          @status_window.contents.blt(@cursortacx + tactyouseix + @tac_syousaimoziakix*16,@cursortacy[z] + 8,picture,rect)
        else
          @status_window.contents.blt(@cursortacx + tactyouseix,@cursortacy[z] + 8,picture,rect)
        end
      when @tac_hensin_name #変身技使用2種類
        if $cha_tactics[2][$partyc[@cursorstate]] == 1
          @status_window.contents.blt(@cursortacx + tactyouseix + @tac_syousaimoziakix*16,@cursortacy[z] + 8,picture,rect)
        else
          @status_window.contents.blt(@cursortacx + tactyouseix,@cursortacy[z] + 8,picture,rect)
        end
      when @tac_ssaiya_name #超サイヤ人状態維持2種類
        if $cha_tactics[3][$partyc[@cursorstate]] == 1
          @status_window.contents.blt(@cursortacx + tactyouseix + @tac_syousaimoziakix*16,@cursortacy[z] + 8,picture,rect)
        else
          @status_window.contents.blt(@cursortacx + tactyouseix,@cursortacy[z] + 8,picture,rect)
        end
      when @tac_exp_name #経験値取得2種類
        if $cha_tactics[4][$partyc[@cursorstate]] == 1
          @status_window.contents.blt(@cursortacx + tactyouseix + @tac_syousaimoziakix*16,@cursortacy[z] + 8,picture,rect)
        else
          @status_window.contents.blt(@cursortacx + tactyouseix,@cursortacy[z] + 8,picture,rect)
        end
      
      when @tac_kiheri_name #KIが減っているとき
        if $cha_tactics[6][$partyc[@cursorstate]] == 1
          @status_window.contents.blt(@cursortacx + tactyouseix + @tac_syousaimoziakix*16,@cursortacy[z] + 8,picture,rect)
        else
          @status_window.contents.blt(@cursortacx + tactyouseix,@cursortacy[z] + 8,picture,rect)
        end
      end
    end

    if @window_state != 0
      #@technique_window.contents.blt(Techniquex,8+Techniquey+@cursor_scombo_select*Partyy,picture,rect)
      rect = set_yoko_cursor_blink 0 # アイコン
      @party_window.contents.blt(Partynox,Partynoy+@cursorstate*Partyy,picture,rect)
    
    end
    
    
  end
  #--------------------------------------------------------------------------
  # ● Sコンボ取得
  # 　 カーソル上キャラのSコンボ一覧を取得する。
  #-------------------------------------------------------------------------- 
  def get_technique
     #@cursorstate
    @scombo_cha_num = 0
    @scombo_cha_no = []
    scombo_ssaiya_cha = []
    ssaiya_loop_chk = false
    for x in 0..$scombo_count
      if $scombo_chk_flag[x] != 0
        if $scombo_chk_flag[x] == 1 #スイッチ
          next if $game_switches[$scombo_chk_flag_no[x]] == false
          #p $scombo_chk_flag_no[x],$game_switches[$scombo_chk_flag_no[x]]
        elsif $scombo_chk_flag[x] == 2 #変数
          #チェック方法 0:一致 1:以上 2:以下
          case $scombo_chk_flag_process[x]
          when 0
            next if $game_variables[$scombo_chk_flag_no[x]] != $scombo_chk_flag_value[x]
          when 1
            next if $game_variables[$scombo_chk_flag_no[x]] < $scombo_chk_flag_value[x]
          when 2
            next if $game_variables[$scombo_chk_flag_no[x]] > $scombo_chk_flag_value[x]
          end
        end
      end
      
      ssaiya_loop_chk = false
      if $scombo_chk_flag_ssaiya[x] != 0
        scombo_ssaiya_cha = $scombo_chk_flag_ssaiya_cha[x]

        if $scombo_chk_flag_ssaiya_put[x] == 0
          
          
          next if $partyc.index($scombo_chk_flag_ssaiya_cha[x]) == nil
          #if scombo_ssaiya_cha.instance_of?(Array)
          #for y in 0..scombo_ssaiya_cha.size-1
          #  p scombo_ssaiya_cha
          #  if $partyc.index(scombo_ssaiya_cha[y]) == nil
          #    ssaiya_loop_chk = true
          #  else
          #    ssaiya_loop_chk = false
          #    next
          #  end
          #end
          #
          #next if ssaiya_loop_chk == true
        else
          next if $partyc.index($scombo_chk_flag_ssaiya_cha[x]) != nil
         #for y in 0..scombo_ssaiya_cha.size-1
         #   ssaiya_loop_chk = true if $partyc.index(scombo_ssaiya_cha[y]) != nil
         #end
         # 
         #next if ssaiya_loop_chk == true
        end
        
        
      end
      
      if $scombo_chk_flag_oozaru_put[x] == 0
        for y in 0..$scombo_cha[x].size - 1
          #if $scombo_cha[x][y]
        end
      end
      
      if $scombo_cha[x].index($partyc[@cursorstate]) != nil
        @scombo_cha_no[@scombo_cha_num] = x
        @scombo_cha_num += 1
        #picture = Cache.picture("文字_必殺技")
        #if $game_switches[$scombo_get_flag[x]] == true
        #  rect = output_technique_detail $scombo_no[x]
        #else
        #  #falseの場合は0を指定して0を取得する
        #  rect = output_technique_detail 0
        #end
        #picture = $tec_mozi
        #@technique_window.contents.blt(Techniquex+18,Techniquey+Techniquenamey * (@scombo_cha_num - 1),picture,rect)
      end

    end
    #@scombo_cha_numサイズ調整他でも使ってるのでそのままにしておく
    #@scombo_cha_num -= 1
  end
  #--------------------------------------------------------------------------
  # ● 必殺技表示
  # 　 カーソル上キャラのスキル一覧を取得する。(表示の詳細は"_detail")
  #-------------------------------------------------------------------------- 
  def output_technique  
    if @scombo_cha_num != 0
      
      #カーソル表示
      tecput_page_strat = @tecput_page * @tecput_max

      if @scombo_cha_num < (@tecput_page + 1) * @tecput_max
        tecput_end = @scombo_cha_num - 1
      else
        tecput_end = @tecput_max - 1
      end
      
      if @scombo_cha_num > (@tecput_page + 1) * @tecput_max #&& @display_skill_window == -1
        @s_down_cursor.visible = true
      else
        @s_down_cursor.visible = false
      end
      
      if @tecput_page > 0 #&& @display_skill_window == -1
        @s_up_cursor.visible = true
        
      else
        @s_up_cursor.visible = false
      end 
      
      for x in tecput_page_strat..tecput_end
        if $game_switches[$scombo_get_flag[@scombo_cha_no[x]]] == true
          rect = output_technique_detail $scombo_no[@scombo_cha_no[x]]
        else
          #falseの場合は0を指定して0を取得する
          rect = output_technique_detail 0
        end
        picture = $tec_mozi
        #@technique_window.contents.blt(Techniquex+18,Techniquey+Techniquenamey * (x-tecput_page_strat),picture,rect)
      end
      
  
    
    end
    
    
  end
  
  #--------------------------------------------------------------------------
  # ● 能力詳細表示
  #--------------------------------------------------------------------------   
  def output_status
=begin
    $scombo_count = 0
      $scombo_cha_count = []
      $scombo_get_flag = []
      $scombo_new_flag = []
      $scombo_no = []
      $scombo_cha = []
      $scombo_flag_tec = []
      $scombo_skill_level_num = []
      $scombo_card_attack_num = []
      $scombo_card_gard_num = []
=end
    set_cha_tactics_nil_to_zero $partyc[@cursorstate]
    manu_num = 0
    tac_syousaix = 32
    @tac_syousaimoziakix = 9
    @cursortacx = Scombo_makix+tac_syousaix - 16
    @cursortacy = []
    @tac_no = []
    @tac_syousaiy = 28 #詳細空き分
    tac_akiy = 36 #空き分
    @tac_tage_name = "・テキのせんたく"
    tac_tage = ["よわいテキから","つよいテキから"]
    
    @tac_tec_name = "・ひっさつわざのせんたく"
    tac_tec = ["とにかくオート","KIをつかうな","こわざでいけ","おおわざでいけ","していのわざでいけ："]
    
    @tac_kiheri_name = "・KIのしょうひ"
    #p $cha_tactics[8][$partyc[@cursorstate]]
    tac_kiheri = ["きにするな","％いかならKIをつかうな"]
    
    @tac_tec_nonki_name = "・していのわざ／おおわざでKIがたりない"
    tac_tec_nonki = ["KIをつかうな","こわざでいけ"]
    
    @tac_hensin_name = "・へんしんわざ"
    #@tac_hensin_name = "・スーパーサイヤじんへんしん"
    tac_hensin = ["しようする","しようしない"]
    
    @tac_ssaiya_name = "・へんしんじょうたい"
    tac_ssaiya = ["いじする","いじしない"]
    
    @tac_exp_name = "・けいけんちのしゅとく"
    tac_exp = ["しゅとくする","しゅとくしない"]
    tacy = 0
    #テキの選択=================================================================================================================
    mozi = @tac_tage_name
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix,Scombo_makiy+tacy,picture,rect)
    
    #よわいてきつよいてき
    mozi = tac_tage[0]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
    
    tyouseix = @tac_syousaimoziakix*16
    #p tyouseix
    mozi = tac_tage[1]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix + tyouseix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
    @cursortacy << Scombo_makiy+tacy+@tac_syousaiy
    tacy += tac_akiy + @tac_syousaiy
    @tac_no << @tac_tage_name
    
    
    
    #ひっさつわざのせんたく=================================================================================================================
    mozi = @tac_tec_name
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix,Scombo_makiy+tacy,picture,rect)

    
    #とにかくオート","KIをつかうな","こわざでいけ,"おおわざでいけ
    mozi = tac_tec[0]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
    

    #tyouseix = (tac_tec[0].split(//u).size+ @tac_syousaimoziakix)*16
    #p tyouseix
    mozi = tac_tec[1]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix + tyouseix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
    
    mozi = tac_tec[2]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix,Scombo_makiy+tacy+@tac_syousaiy*2,picture,rect)
    
    mozi = tac_tec[3]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix + tyouseix,Scombo_makiy+tacy+@tac_syousaiy*2,picture,rect)
    
    mozi = tac_tec[4]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix,Scombo_makiy+tacy+@tac_syousaiy*3,picture,rect)
    
    #指定の技が設定されてなければ消費0の技を指定
    if $cha_tactics[7][$partyc[@cursorstate]] == 0
      $cha_tactics[7][$partyc[@cursorstate]] = $game_actors[$partyc[@cursorstate]].skills[0].id
    end
    mozi = $data_skills[$cha_tactics[7][$partyc[@cursorstate]]].description
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix+(tac_tec[4].split(//u).size*16),Scombo_makiy+tacy+@tac_syousaiy*3,picture,rect)
    
    @cursortacy << Scombo_makiy+tacy+@tac_syousaiy
    tacy += tac_akiy + @tac_syousaiy*3
    
    
    @tac_no << @tac_tec_name
    
    #KIがたりないとき=================================================================================================================
    mozi = @tac_tec_nonki_name
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix,Scombo_makiy+tacy,picture,rect)
    
    #KIをつかうな
    mozi = tac_tec_nonki[0]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
    
    tyouseix = @tac_syousaimoziakix*16
    #p tyouseix
    mozi = tac_tec_nonki[1]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix + tyouseix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
    @cursortacy << Scombo_makiy+tacy+@tac_syousaiy
    tacy += tac_akiy + @tac_syousaiy
    @tac_no << @tac_tec_nonki_name   
    
    
    #気が減っているときのせんたく=================================================================================================================
    mozi = @tac_kiheri_name
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix,Scombo_makiy+tacy,picture,rect)
    #気が減っているとき
    mozi = tac_kiheri[0]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
    
    tyouseix = @tac_syousaimoziakix*16
    #p tyouseix
    
    #一桁かチェック
    if $cha_tactics[8][$partyc[@cursorstate]].to_i > 9
      mozi = $cha_tactics[8][$partyc[@cursorstate]].to_s + tac_kiheri[1]
    else
      mozi = "　" + $cha_tactics[8][$partyc[@cursorstate]].to_s + tac_kiheri[1]
    end
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix + tyouseix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
    @cursortacy << Scombo_makiy+tacy+@tac_syousaiy
    tacy += tac_akiy + @tac_syousaiy
    @tac_no << @tac_kiheri_name
    
    #$cha_tactics[8][$partyc[@cursorstate]]


    
    #へんしんわざのしよう=================================================================================================================
    puthensin = false
    
    case $partyc[@cursorstate]
    
    when 3 #悟空
      for z in 0..$game_actors[$partyc[@cursorstate]].skills.size - 1
        puthensin = true if $game_actors[$partyc[@cursorstate]].skills[z].id == 29
      end
    when 5 #悟飯
      for z in 0..$game_actors[$partyc[@cursorstate]].skills.size - 1
        puthensin = true if $game_actors[$partyc[@cursorstate]].skills[z].id == 59 || $game_actors[$partyc[@cursorstate]].skills[z].id == 51 || $oozaru_flag[5] == true
      end
    when 14,18,19,32,17,20,25,26,27,28,29,30 #超悟空 #超悟飯 #超べジータ #超バーダック #トランクス #超トランクス #未来悟飯 #超未来悟飯 #トーマ #セリパ #トテッポ #パンブーキン
      puthensin = true
    when 12 #べジータ
      
      for z in 0..$game_actors[$partyc[@cursorstate]].skills.size - 1
        puthensin = true if $game_actors[$partyc[@cursorstate]].skills[z].id == 133
      end
    when 16 #バーダック
      for z in 0..$game_actors[$partyc[@cursorstate]].skills.size - 1
        puthensin = true if $game_actors[$partyc[@cursorstate]].skills[z].id == 158
      end
    end
    
    if puthensin == true
      
      mozi = @tac_hensin_name
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @status_window.contents.blt(Scombo_makix,Scombo_makiy+tacy,picture,rect)

      #しようする、しようしない
      mozi = tac_hensin[0]
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @status_window.contents.blt(Scombo_makix+tac_syousaix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
      

      #tyouseix = (tac_tec[0].split(//u).size+ @tac_syousaimoziakix)*16
      #p tyouseix
      mozi = tac_hensin[1]
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @status_window.contents.blt(Scombo_makix+tac_syousaix + tyouseix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
      @cursortacy << Scombo_makiy+tacy+@tac_syousaiy
      tacy += tac_akiy + @tac_syousaiy
      @tac_no << @tac_hensin_name
      
    end
    
    #超サイヤ人状態=================================================================================================================
    puthensin = false
    
    case $partyc[@cursorstate]
    
    when 3 #悟空
      for z in 0..$game_actors[$partyc[@cursorstate]].skills.size - 1
        puthensin = true if $game_actors[$partyc[@cursorstate]].skills[z].id == 29
      end
    when 5 #悟飯
      for z in 0..$game_actors[$partyc[@cursorstate]].skills.size - 1
        puthensin = true if $game_actors[$partyc[@cursorstate]].skills[z].id == 59 || $game_actors[$partyc[@cursorstate]].skills[z].id == 51 || $oozaru_flag[5] == true
        #puthensin = true if $game_actors[$partyc[@cursorstate]].skills[z].id == 59
      end
    #when 14,18,19,32,17,20,25,26 #超悟空 #超悟飯 #超べジータ #超バーダック #トランクス #超トランクス #未来悟飯 #超未来悟飯
    when 14,18,19,32,17,20,25,26,27,28,29,30 #超悟空 #超悟飯 #超べジータ #超バーダック #トランクス #超トランクス #未来悟飯 #超未来悟飯 #トーマ #セリパ #トテッポ #パンブーキン
      puthensin = true
    when 12 #べジータ
      
      for z in 0..$game_actors[$partyc[@cursorstate]].skills.size - 1
        puthensin = true if $game_actors[$partyc[@cursorstate]].skills[z].id == 133
      end
    when 16 #バーダック
      for z in 0..$game_actors[$partyc[@cursorstate]].skills.size - 1
        puthensin = true if $game_actors[$partyc[@cursorstate]].skills[z].id == 158
      end
    end
    
    if puthensin == true
      
      mozi = @tac_ssaiya_name
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @status_window.contents.blt(Scombo_makix,Scombo_makiy+tacy,picture,rect)

      #いじする、いじしない
      mozi = tac_ssaiya[0]
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @status_window.contents.blt(Scombo_makix+tac_syousaix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
      

      #tyouseix = (tac_tec[0].split(//u).size+ @tac_syousaimoziakix)*16
      #p tyouseix
      mozi = tac_ssaiya[1]
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @status_window.contents.blt(Scombo_makix+tac_syousaix + tyouseix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
      @cursortacy << Scombo_makiy+tacy+@tac_syousaiy
      tacy += tac_akiy + @tac_syousaiy
      @tac_no << @tac_ssaiya_name
      
    end
=begin  
    #けいけんち=================================================================================================================
    mozi = @tac_exp_name
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix,Scombo_makiy+tacy,picture,rect)

    #しゅとくする、しゅとくしない
    mozi = tac_exp[0]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
    

    #tyouseix = (tac_tec[0].split(//u).size+ @tac_syousaimoziakix)*16
    #p tyouseix
    mozi = tac_exp[1]
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(Scombo_makix+tac_syousaix + tyouseix,Scombo_makiy+tacy+@tac_syousaiy,picture,rect)
    @cursortacy << Scombo_makiy+tacy+@tac_syousaiy
    tacy += tac_akiy + @tac_syousaiy
    @tac_no << @tac_exp_name
=end
    
    
  end

  #--------------------------------------------------------------------------
  # ● パーティー一覧表示
  #-------------------------------------------------------------------------- 
  def output_party
    picturea = Cache.picture("名前")
    pictureb = Cache.picture("数字英語")
    picturec = Cache.picture("アイコン")
    rect = Rect.new(128, 16, 32, 16) #No
    @party_window.contents.blt(Partynox+16 ,Partynoy-32,pictureb,rect)

    for x in 0..$partyc.size-1
      
      rect = Rect.new((x+1)*16, 48, 16, 16) #No
      @party_window.contents.blt(Partynox+16+2,Partynoy+x*Partyy,pictureb,rect)

      rect = Rect.new(0, 0+(($partyc[x]-3)*16), 160, 16) # 名前
      @party_window.contents.blt(Partynox+32+4,Partynoy+x*Partyy,picturea,rect)
      
    end

  end

  #--------------------------------------------------------------------------
  # ● カーソル移動
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def move_cursor n
    
    case n
    
    when 2 #下
      
      if @scombo_cha_num - @tecput_page * @tecput_max < @tecput_max
        cursor_s_end = @scombo_cha_num - @tecput_page * @tecput_max
      else
        cursor_s_end = @tecput_max
      end
      
      if @window_state == 0
        @tecput_page = 0
        @cursorstate +=1
        if @cursorstate >= $partyc.size
          @cursorstate = 0
        end
      else
        @taccursorstate += 1 
        if @taccursorstate >= @tac_no.size
          @taccursorstate = 0
        end
      end

    when 8 #上
      if @scombo_cha_num - @tecput_page * @tecput_max < @tecput_max
        cursor_s_end = @scombo_cha_num - @tecput_page * @tecput_max
      else
        cursor_s_end = @tecput_max
      end
      if @window_state == 0
        @tecput_page = 0
        @cursorstate -=1
        
        if @cursorstate <= -1
          @cursorstate = $partyc.size - 1
        end
      else
        @taccursorstate -= 1
        if @taccursorstate <= -1
          @taccursorstate = @tac_no.size-1
        end
      end

    when 6 #右
      if @window_state == 1

        case @tac_no[@taccursorstate]
        
        when @tac_tage_name #テキ選択2種類
          #if $cha_tactics[0][$partyc[@cursorstate]] == 1
          #  $cha_tactics[0][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[0][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 0,@cursorstate,1,1
        when @tac_tec_name  #必殺選択5種類
          #if $cha_tactics[1][$partyc[@cursorstate]] == 4
          #  $cha_tactics[1][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[1][$partyc[@cursorstate]] += 1
          #end
          chgcha_tactics 1,@cursorstate,1,1
        when @tac_tec_nonki_name #気が足りない
          #if $cha_tactics[5][$partyc[@cursorstate]] == 1
          #  $cha_tactics[5][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[5][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 5,@cursorstate,1,1
        when @tac_hensin_name #変身技使用2種類
          #if $cha_tactics[2][$partyc[@cursorstate]] == 1
          #  $cha_tactics[2][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[2][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 2,@cursorstate,1,1
        when @tac_ssaiya_name #超サイヤ人状態維持2種類
          #if $cha_tactics[3][$partyc[@cursorstate]] == 1
          #  $cha_tactics[3][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[3][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 3,@cursorstate,1,1
        when @tac_exp_name #経験値取得2種類
          #if $cha_tactics[4][$partyc[@cursorstate]] == 1
          #  $cha_tactics[4][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[4][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 4,@cursorstate,1,1
        when @tac_kiheri_name #KIが減っているとき
          #if $cha_tactics[6][$partyc[@cursorstate]] == 1
          #  $cha_tactics[6][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[6][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 6,@cursorstate,1,1
        end

        
      end
    when 4 #左
      if @window_state == 1
        case @tac_no[@taccursorstate]
        
        when @tac_tage_name #テキ選択2種類
          #if $cha_tactics[0][$partyc[@cursorstate]] == 1
          #  $cha_tactics[0][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[0][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 0,@cursorstate,1,1
        when @tac_tec_name  #必殺選択5種類
          #if $cha_tactics[1][$partyc[@cursorstate]] == 0
          #  $cha_tactics[1][$partyc[@cursorstate]] = 4
          #else
          #  $cha_tactics[1][$partyc[@cursorstate]] -= 1
          #end
          chgcha_tactics 1,@cursorstate,1,-1
        when @tac_tec_nonki_name #気が足りない
          #if $cha_tactics[5][$partyc[@cursorstate]] == 1
          #  $cha_tactics[5][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[5][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 5,@cursorstate,1,1
        when @tac_hensin_name #変身技使用2種類
          #if $cha_tactics[2][$partyc[@cursorstate]] == 1
          #  $cha_tactics[2][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[2][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 2,@cursorstate,1,1
        when @tac_ssaiya_name #超サイヤ人状態維持2種類
          #if $cha_tactics[3][$partyc[@cursorstate]] == 1
          #  $cha_tactics[3][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[3][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 3,@cursorstate,1,1
        when @tac_exp_name #経験値取得2種類
          #if $cha_tactics[4][$partyc[@cursorstate]] == 1
          #  $cha_tactics[4][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[4][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 4,@cursorstate,1,1
        when @tac_kiheri_name #KIが減っているとき
          #if $cha_tactics[6][$partyc[@cursorstate]] == 1
          #  $cha_tactics[6][$partyc[@cursorstate]] = 0
          #else
          #  $cha_tactics[6][$partyc[@cursorstate]] = 1
          #end
          chgcha_tactics 6,@cursorstate,1,1
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