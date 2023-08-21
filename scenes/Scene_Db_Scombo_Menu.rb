#==============================================================================
# ■ Scene_Db_Scombo_Menu
#------------------------------------------------------------------------------
# 　能力表示画面
#==============================================================================
class Scene_Db_Scombo_Menu < Scene_Base
  include Share
  Party_win_sizex = 274         #パーティーウインドウサイズX
  Party_win_sizey = 272         #パーティーウインドウサイズY
  Status_win_sizex = 640-274    #詳細ステータスウインドウサイズX
  Status_win_sizey = 480        #詳細ステータスウインドウサイズY
  Technique_win_sizex = 274     #必殺技ウインドウサイズX
  Technique_win_sizey = 480-272 #必殺技ウインドウサイズY
  Partyy = 24                   #パーティー表示行空き数
  Partynox = 0                  #パーティー表示基準X
  Partynoy = 32                 #パーティー表示基準Y
  Status_lbx = 16               #詳細ステータス表示基準X
  Status_lby = 0                #詳細ステータス表示基準Y
  Techniquex = 0                #必殺技表示基準X
  Techniquey = 0                #必殺技表示基準Y
  Scombo_makix = 0              #まきもの位置X
  Scombo_makiy = 0              #まきもの位置Y
  Scombo_makitochaaki_x = 32     #まきものからどのくらい離すか
  Scombo_makitochaaki_y = 58    #まきものからどのくらい離すか
  Scombo_chayy = 134             #Sコンボパーティー表示行空き数
  Scombo_chatocardaki_x = 96    #Sコンボでキャラとカードの秋
  Scombo_chatotecakiy = 104      #対象必殺技表示
  Scombo_chatotecakix = 80       #対象必殺技表示
  #Techniquenamex = 184          #必殺技画像取得サイズX
  #Techniquenamey = 24           #必殺技画像取得サイズY
  
  Scombo_slvx = 268              #Sコンボ使用回数位置X
  Scombo_slvy = 0              #Sコンボ使用回数位置Y
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     call_state : どのプログラムから呼ばれたか 1:戦闘 2:マップ 3:カード 4:修行
  #--------------------------------------------------------------------------
  def initialize(call_state = 2)
    @call_state = call_state
    if @call_state == 2
      set_bgm
    end
    
    #スキル名変更
    skill_name_chg
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @window_state = 0         #ウインドウ状態(並び替え時のみ使用) 0:未選択 1:キャラ選択
    @cursor_scombo_select = 0      #Sコンボの選択キャラ
    @cursorstate = 0             #カーソル位置
    @run_card_result = false      #カード使用結果
    @scombo_cha_num = 0    #スパーキングコンボ技数
    @scombo_cha_no = []    #技の番号
    @tecput_page = 0
    @tecput_max = 7
    @chaput_page = 0
    @chaput_max = 3
    @scombo_putmode = 0 #0:通常、1:詳細 
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
    set_up_down_cursor
    
    #優先度変更中
    @sconprioritychgflag = false
    #選択したSコンボ
    @sconprioritychgtecindex = []
    #カーソル位置保存用
    @tmp_fast_selcursor = []
    #プレイヤー優先度の一次処理用
    @tmp_player_scombo_priority = []
    
    #Sコンボ切り替えチェック
    run_common_event 205
    
    #Sコンボプレイヤー発動優先度の最新化
    update_player_scombo_priority
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
      output_technique
      output_status
      
      @status_window.update
      @party_window.update
      @technique_window.update
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
        if @scombo_cha_num > 0
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @window_state = 1
          @cursor_scombo_select = 0
          @tecput_page = 0
          @chaput_page = 0
        else
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        end
      elsif @window_state == 1
        if $game_variables[358] == 1 #Sコン優先度プレイヤー
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          if @scombo_cha_num > 1 #Sコンの数が2以上なら並び替え開始
            #優先度変更中か
            selsconindex = @cursor_scombo_select+@tecput_page * @tecput_max
            if @sconprioritychgflag == false
              @sconprioritychgtecindex = [selsconindex]
              @sconprioritychgflag = true
              @tmp_fast_selcursor = [@cursor_scombo_select,@tecput_page]
              
              #カーソル下に移動
              move_cursor 2 #カーソル移動
              @chaput_page = 0
              @scombo_putmode = 0
            else
              @sconprioritychgtecindex << selsconindex
              #順番入れ替え
              #swap関数は使えないので、手動でやる
              #p $player_scombo_priority[$partyc[@cursorstate]],$player_scombo_priority[$partyc[@cursorstate]][@sconprioritychgtecindex[0]],$player_scombo_priority[$partyc[@cursorstate]][@sconprioritychgtecindex[1]]
              
              #順番入れ替え
              @scombo_cha_no[@sconprioritychgtecindex[0]],@scombo_cha_no[@sconprioritychgtecindex[1]] = @scombo_cha_no[@sconprioritychgtecindex[1]],@scombo_cha_no[@sconprioritychgtecindex[0]]
              
              #表示しなおすときに元から取得しなおすので再定義
              adjust_scombo_list $partyc[@cursorstate] if $game_variables[358] != 0
              #$player_scombo_priority[$partyc[@cursorstate]][@sconprioritychgtecindex[0]],$player_scombo_priority[$partyc[@cursorstate]][@sconprioritychgtecindex[1]] = $player_scombo_priority[$partyc[@cursorstate]][@sconprioritychgtecindex[1]],$player_scombo_priority[$partyc[@cursorstate]][@sconprioritychgtecindex[0]]
              #p $player_scombo_priority[$partyc[@cursorstate]],$player_scombo_priority[$partyc[@cursorstate]][@sconprioritychgtecindex[0]],$player_scombo_priority[$partyc[@cursorstate]][@sconprioritychgtecindex[1]]
              @sconprioritychgflag = false
              @sconprioritychgtecindex = []
              @tmp_fast_selcursor = []
              #順番を入れ替えたので画面更新
              @window_update_flag = true
            end
          end
        end
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
          #優先度変更中か
          if @sconprioritychgflag == false
            #変更中じゃない
            #Sコンボ調整
            adjust_scombo_list $partyc[@cursorstate] if $game_variables[358] != 0
            @c_down_cursor.visible = false
            @c_up_cursor.visible = false
            @window_state = 0
            @tecput_page = 0
            @chaput_page = 0
            @cursor_scombo_select = 0
            @scombo_putmode = 0
            #Sコンボを調整したので、再度取得しなおす
            get_technique
          else
            #変更中
            #カーソル位置元に戻す
            @cursor_scombo_select = @tmp_fast_selcursor[0]
            @tecput_page = @tmp_fast_selcursor[1]
            @sconprioritychgflag = false
            @sconprioritychgtecindex = []
            @tmp_fast_selcursor = []
          end
        end
      else
        if @window_state == 0
          Graphics.fadeout(5)
          Audio.bgm_play("Audio/BGM/" + $map_bgm)    # 効果音を再生する
          $scene = Scene_Map.new
        elsif @window_state == 1
          #優先度変更中か
          if @sconprioritychgflag == false
            #変更中じゃない
            #Sコンボ調整
            adjust_scombo_list $partyc[@cursorstate] if $game_variables[358] != 0
            @c_down_cursor.visible = false
            @c_up_cursor.visible = false
            @window_state = 0
            @tecput_page = 0
            @chaput_page = 0
            @cursor_scombo_select = 0
            @scombo_putmode = 0
            #Sコンボを調整したので、再度取得しなおす
            get_technique
          else
            #変更中
            #カーソル位置元に戻す
            @cursor_scombo_select = @tmp_fast_selcursor[0]
            @tecput_page = @tmp_fast_selcursor[1]
            @sconprioritychgflag = false
            @sconprioritychgtecindex = []
            @tmp_fast_selcursor = []
          end
        end
      end
    end

    if Input.trigger?(Input::X)
      if @window_state == 1 && #Sコンボ一覧かつ選んでいるSコンボが取得済み
        $game_switches[$scombo_get_flag[@scombo_cha_no[@cursor_scombo_select+@tecput_page * @tecput_max]]] == true
        
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        @window_update_flag = true
        if @scombo_putmode == 0
          @scombo_putmode = 1
        else
          @scombo_putmode = 0
        end
      end
      
    end
    
    if Input.trigger?(Input::L)
      if @window_state == 1
        @window_update_flag = true
        set_chapage -1
      end
    end
    
    if Input.trigger?(Input::R)
      if @window_state == 1
        @window_update_flag = true
        set_chapage 1
      end
    end
    
    if Input.trigger?(Input::DOWN)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #chk_up = true
      move_cursor 2 #カーソル移動
      
      #Sコン並び順変更時にもしカーソル位置が被っていたら再度移動
      if @window_state == 1 && @sconprioritychgflag == true && @cursor_scombo_select == @tmp_fast_selcursor[0] && @tecput_page == @tmp_fast_selcursor[1]
        update_cursor_visible
        move_cursor 2 #カーソル移動
      end
      @chaput_page = 0
      #@scombo_putmode = 0
    elsif Input.trigger?(Input::UP)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #chk_up = true
      move_cursor 8 #カーソル移動
      
      #Sコン並び順変更時にもしカーソル位置が被っていたら再度移動
      if @window_state == 1 && @sconprioritychgflag == true && @cursor_scombo_select == @tmp_fast_selcursor[0] && @tecput_page == @tmp_fast_selcursor[1]
        update_cursor_visible
        move_cursor 8 #カーソル移動
      end
      @chaput_page = 0
      #@scombo_putmode = 0
    elsif Input.trigger?(Input::RIGHT)
      if @window_state == 1
        get_technique
        set_tecpage 1
        
        #Sコン並び順変更時にもしカーソル位置が被っていたら再度移動
        if @window_state == 1 && @sconprioritychgflag == true && @cursor_scombo_select == @tmp_fast_selcursor[0] && @tecput_page == @tmp_fast_selcursor[1]
          #このタイミングでカーソル状態を更新しないとエラーになるので追加する
          update_cursor_visible
          move_cursor 2 #カーソル移動
        end
      end
    elsif Input.trigger?(Input::LEFT)
      if @window_state == 1
        get_technique
        set_tecpage -1
        
        #Sコン並び順変更時にもしカーソル位置が被っていたら再度移動
        if @window_state == 1 && @sconprioritychgflag == true && @cursor_scombo_select == @tmp_fast_selcursor[0] && @tecput_page == @tmp_fast_selcursor[1]
          
          #このタイミングでカーソル状態を更新しないとエラーになるので追加する
          update_cursor_visible
          move_cursor 2 #カーソル移動
        end
      end
    end
    
    @window_update_flag = true if Input.dir8 != 0 #何かカーソルを押したら画面を更新フラグをON
    #if chk_up == true #カーソル動かした時のみ画面更新
    pre_update
    #end
    
    
  end
  
  #--------------------------------------------------------------------------
  # ● カーソルの表示状態更新
  #-------------------------------------------------------------------------- 
  def update_cursor_visible
  
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
    
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_window
    @party_window.dispose
    @party_window = nil
    @status_window.dispose
    @status_window = nil
    @technique_window.dispose
    @technique_window = nil
  end 
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def window_contents_clear
    @party_window.contents.clear
    @status_window.contents.clear
    @technique_window.contents.clear
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
    @technique_window = Window_Base.new(0,Party_win_sizey,Technique_win_sizex,Technique_win_sizey)
    @technique_window.opacity=255
    @technique_window.back_opacity=255
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
    
    if @window_state == 1
      @technique_window.contents.blt(Techniquex,8+Techniquey+@cursor_scombo_select*Partyy,picture,rect)
      rect = set_yoko_cursor_blink 0 # アイコン
      @party_window.contents.blt(Partynox,Partynoy+@cursorstate*Partyy,picture,rect)
    
      if @sconprioritychgflag == true
        #@tmp_fast_selcursor = [@cursor_scombo_select,@tecput_page]
        if @tmp_fast_selcursor[1] == @tecput_page
          @technique_window.contents.blt(Techniquex,8+Techniquey+@tmp_fast_selcursor[0]*Partyy,picture,rect)
        end
      end
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
    
    if $game_variables[358] == 0
      #デフォルトの一覧を取得
      for x in 0..$scombo_count
        if $scombo_chk_flag[x] != 0
          #シナリオ進行度
          next if $scombo_chk_scenario_progress[x] > $game_variables[40]

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

          else
            next if $partyc.index($scombo_chk_flag_ssaiya_cha[x]) != nil

          end
          
          
        end
        
        if $partyc.index($partyc[@cursorstate]) != nil
          if $scombo_chk_flag_oozaru_put[x] == 0
            next if $cha_bigsize_on[$partyc.index($partyc[@cursorstate])] == true
          else
            next if $cha_bigsize_on[$partyc.index($partyc[@cursorstate])] == false
          end
        end
      
        
        if $scombo_cha[x].index($partyc[@cursorstate]) != nil
          @scombo_cha_no[@scombo_cha_num] = x
          @scombo_cha_num += 1
        end

      end
    else
      #プレイヤー設定を取得
      #@tmp_player_scombo_priority = Marshal.load(Marshal.dump($player_scombo_priority[$partyc[@cursorstate]]))
      
      #p $player_scombo_priority[$partyc[@cursorstate]]
      #一つもSコンボを覚えていないとエラーになるので、回避処理を入れている
      if $player_scombo_priority[$partyc[@cursorstate]] != nil
        for x in 0..$player_scombo_priority[$partyc[@cursorstate]].size - 1
          
          getx = $player_scombo_priority[$partyc[@cursorstate]][x]
          
          if $scombo_chk_flag[getx] != 0
            #シナリオ進行度
            next if $scombo_chk_scenario_progress[getx] > $game_variables[40]

            if $scombo_chk_flag[getx] == 1 #スイッチ
              next if $game_switches[$scombo_chk_flag_no[getx]] == false
              #p $scombo_chk_flag_no[getx],$game_switches[$scombo_chk_flag_no[getx]]
            elsif $scombo_chk_flag[getx] == 2 #変数
              #チェック方法 0:一致 1:以上 2:以下
              case $scombo_chk_flag_process[getx]
              when 0
                next if $game_variables[$scombo_chk_flag_no[getx]] != $scombo_chk_flag_value[getx]
              when 1
                next if $game_variables[$scombo_chk_flag_no[getx]] < $scombo_chk_flag_value[getx]
              when 2
                next if $game_variables[$scombo_chk_flag_no[getx]] > $scombo_chk_flag_value[getx]
              end
            end
          end
          
          ssaiya_loop_chk = false
          if $scombo_chk_flag_ssaiya[getx] != 0
            scombo_ssaiya_cha = $scombo_chk_flag_ssaiya_cha[getx]

            if $scombo_chk_flag_ssaiya_put[getx] == 0
              next if $partyc.index($scombo_chk_flag_ssaiya_cha[getx]) == nil

            else
              next if $partyc.index($scombo_chk_flag_ssaiya_cha[getx]) != nil

            end
            
            
          end
          
          if $partyc.index($partyc[@cursorstate]) != nil
            if $scombo_chk_flag_oozaru_put[getx] == 0
              next if $cha_bigsize_on[$partyc.index($partyc[@cursorstate])] == true
            else
              next if $cha_bigsize_on[$partyc.index($partyc[@cursorstate])] == false
            end
          end
        
          
          if $scombo_cha[getx].index($partyc[@cursorstate]) != nil
            @scombo_cha_no[@scombo_cha_num] = getx
            @scombo_cha_num += 1
          end
          
        end
      end
    end

  end
  #--------------------------------------------------------------------------
  # ● 必殺技表示
  # 　 カーソル上キャラのスキル一覧を取得する。(表示の詳細は"_detail")
  #-------------------------------------------------------------------------- 
  def output_technique
    if @scombo_cha_num != 0

      #カーソル表示
      tecput_page_strat = @tecput_page * @tecput_max
      #p @scombo_cha_no
      temp_scombo_cha_num = @scombo_cha_no
=begin
      if $game_variables[358] == 1
        #プレイヤー設定
        temp_scombo_cha_num = $player_scombo_priority[$partyc[@cursorstate]]
      else
        #デフォルト
        temp_scombo_cha_num = @scombo_cha_no
      end
=end
      #p tecput_page_strat,tecput_end
      #p @scombo_cha_num,(@tecput_page + 1),@tecput_max
      if @scombo_cha_num <= (@tecput_page + 1) * @tecput_max
        tecput_end = @scombo_cha_num - 1
      else
        tecput_end = (@tecput_max) * (@tecput_page + 1) - 1
      end
      
      update_cursor_visible
      
      for x in tecput_page_strat..tecput_end
        if $game_switches[$scombo_get_flag[temp_scombo_cha_num[x]]] == true
          rect = output_technique_detail $scombo_no[temp_scombo_cha_num[x]]
        else
          #falseの場合は0を指定して0を取得する
          rect = output_technique_detail 0
        end
        picture = $tec_mozi
        @technique_window.contents.blt(Techniquex+18,Techniquey+Techniquenamey * (x-tecput_page_strat),picture,rect)
      end

    end
    
    
  end
  
  #--------------------------------------------------------------------------
  # ● キャラのSコンボの調整
  # 大猿や超サイヤ人のSコンボを追加や移動する
  # chano:対象キャラNo
  #--------------------------------------------------------------------------
  def adjust_scombo_list chano
    
    tmp_scombo_cha_no = Marshal.load(Marshal.dump(@scombo_cha_no))
    
    #通常版、超サイヤ人版の位置調整
    for x in 0..@scombo_cha_no.size - 1
      if $scombo_chk_flag_ssaiya[@scombo_cha_no[x]] != 0
        if $scombo_chk_flag_ssaiya_put[@scombo_cha_no[x]] == 1 #通常時
          #超サイヤ人状態のSコンボも覚えているか
          #前提として1つ後ろのところに超版があること
          if $player_scombo_priority[$partyc[@cursorstate]].index(@scombo_cha_no[x] + 1 ) != nil #超サイヤもあるか
            #覚えていたら追加する
            #追加する位置は通常版の1つ後ろ
            tmp_scombo_cha_no.insert(tmp_scombo_cha_no.index(@scombo_cha_no[x]) + 1, @scombo_cha_no[x] + 1)
          end
        else
          #$scombo_chk_flag_ssaiya_put[@scombo_cha_no[x]] == 0 #超サイヤ時
          #通常状態のSコンボも覚えているか
          #前提として1つ前のところに超版があること

          if $player_scombo_priority[$partyc[@cursorstate]].index(@scombo_cha_no[x] - 1 ) != nil #通常版もあるか
            #覚えていたら追加する
            #追加する位置は通常版の1つ前
            tmp_scombo_cha_no.insert(tmp_scombo_cha_no.index(@scombo_cha_no[x]), @scombo_cha_no[x] - 1)
          end
          
        end
        
      end
    end
      
    #処理結果を格納
    @scombo_cha_no = Marshal.load(Marshal.dump(tmp_scombo_cha_no))
    
    oozaruonflag = 0
    #対象キャラが大猿か確認
    if $cha_bigsize_on[$partyc.index($partyc[@cursorstate])] == true
      #大猿状態であれば通常の技を足す
      oozaruonflag = 1
    else
      #通常状態であれば大猿の技を足す
      oozaruonflag = 0
    end
    
    #通常時と大猿で消えてしまった技を再追加
    for x in 0..$player_scombo_priority[$partyc[@cursorstate]].size - 1
      if $scombo_chk_flag_oozaru_put[$player_scombo_priority[$partyc[@cursorstate]][x]] != oozaruonflag 
        #状態と逆の技があったら追加するこの処理を実装することで順番も変わらない
        @scombo_cha_no << $player_scombo_priority[$partyc[@cursorstate]][x]
      end
    end
    
    #大元の変数にセットしなおし
    $player_scombo_priority[$partyc[@cursorstate]] = @scombo_cha_no
  end
  #--------------------------------------------------------------------------
  # ● Sコンボ必殺技ヘルプ表示
  # 　 カーソル上キャラのスキル一覧を取得する。(表示の詳細は"_detail")
  #    sel_tecid:詳細取得ID
  #-------------------------------------------------------------------------- 
  def output_tec_help sel_tecid #必殺技表示
    #if @tec_help_window != nil
    #  @tec_help_window.contents.clear
    #end
    
    tyouseiy = 64
    tyouseix = 16
    tyouseixmoto = 24
    #発動条件を満たしている or 可能性のあるSコンボ
    get_scombono = []
    #チェック結果の詳細
    get_result = []
    #Sコンボ行
    get_scomborow = []

    #出力行数
    put_liney = 0
    
    #追加効果カウント
    put_add_effect_num = 0
    
    #追加効果出力文字
    put_add_effect_mozi = ""
    
    put_kanashibari_flag = false #%の追加の文言を切替用
    
    #攻撃範囲
    mozi = "・こうげきはんい"
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    output_mozi mozi
    @status_window.contents.blt(tyouseixmoto,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
    put_liney += 1
    
    if $data_skills[sel_tecid].scope == 1
      #単体
      mozi = "たんたいこうげき"
    else
      #全体
      mozi = "ぜんたいこうげき"
    end
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    output_mozi mozi
    @status_window.contents.blt(tyouseixmoto+tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
    put_liney += 1    
    
    #追加効果タイトル
    mozi = "・ついかこうか"
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    output_mozi mozi
    @status_window.contents.blt(tyouseixmoto,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
    put_liney += 1
    
    #追加効果一覧を表示
    
    #必中
    if $data_skills[sel_tecid].element_set.index(29) != nil
      put_add_effect_num += 1
      #put_add_effect_mozi += "／" if put_add_effect_mozi != ""
      mozi = "ひっちゅう"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @status_window.contents.blt(tyouseixmoto+tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
    end
    
    #超能力
    if $data_skills[sel_tecid].element_set.index(12) != nil
      put_add_effect_num += 1
      #mozi = "ちょうのうりょく"
      mozi = "かなしばり"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @status_window.contents.blt(tyouseixmoto+tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
      
      put_add_effect_num += 1
      #mozi = "ちょうのうりょく"
      mozi = "りゅうはいっちでさらにかなしばり"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @status_window.contents.blt(tyouseixmoto+tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
      put_kanashibari_flag = true
    end
        
    #太陽拳
    if $data_skills[sel_tecid].element_set.index(14) != nil
      put_add_effect_num += 1
      #mozi = "たいようけん"
      mozi = "かなしばり"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @status_window.contents.blt(tyouseixmoto+tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1

      put_add_effect_num += 1
      #mozi = "ちょうのうりょく"
      mozi = "りゅうはいっちでさらにかなしばり"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @status_window.contents.blt(tyouseixmoto+tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
      
      put_kanashibari_flag = true
    end
    
    #流派一致で超能力
    if $data_skills[sel_tecid].element_set.index(13) != nil
      put_add_effect_num += 1
      #mozi = "りゅうはいっちでうごきをとめる"
      mozi = "りゅうはいっちでかなしばり"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @status_window.contents.blt(tyouseixmoto+tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
      
      put_kanashibari_flag = true
    end
    
    #一定確率でかなしばり
    if $data_skills[sel_tecid].element_set.index(61) != nil
      put_add_effect_num += 1
      if put_kanashibari_flag == true
        mozi = $data_skills[sel_tecid].variance.to_s + "％でさらにかなしばり"
      else
        mozi = $data_skills[sel_tecid].variance.to_s + "％でかなしばり"
      end
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @status_window.contents.blt(tyouseixmoto+tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
      
      put_kanashibari_flag = true
    end
    
    #尻尾を切る
    if $data_skills[sel_tecid].element_set.index(25) != nil
      put_add_effect_num += 1
      mozi = "しっぽをきる"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @status_window.contents.blt(tyouseixmoto+tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
    end
    
    #追加効果がない場合はなしを出力
    if put_add_effect_num == 0
      mozi = "なし"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @status_window.contents.blt(tyouseixmoto+tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Sコンボ詳細表示
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

    if @window_state == 1
      picture = Cache.picture("スパーキングコンボ巻物")
      rect = Rect.new(0, 0, 266, 52)
      @status_window.contents.blt(Scombo_makix,Scombo_makiy,picture,rect)

      x=@scombo_cha_no[@cursor_scombo_select+@tecput_page * @tecput_max]
=begin
      if $game_variables[358] == 1
        #プレイヤー設定
        x=$player_scombo_priority[$partyc[@cursorstate]][@cursor_scombo_select+@tecput_page * @tecput_max]
      else
        #デフォルト
        x=@scombo_cha_no[@cursor_scombo_select+@tecput_page * @tecput_max]
      end
=end
      

      #覚えている場合はSコンボ名と使用回数を表示する
      if $game_switches[$scombo_get_flag[x]] == true
        #使用回数
        mozi = "かいすう"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @status_window.contents.blt(Scombo_slvx,Scombo_slvy, $tec_mozi,rect)
        
        #nil対策
        if $cha_skill_level[$scombo_no[x]] == nil
          $cha_skill_level[$scombo_no[x]] = 0
        end
        
        if $cha_skill_level[$scombo_no[x]].to_s.size < 5
          output_mozi $cha_skill_level[$scombo_no[x]].to_s
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          @status_window.contents.blt(Scombo_slvx+16*4-($cha_skill_level[$scombo_no[x]].to_s.size*16),Scombo_slvy+20, $tec_mozi,rect)
        else
          #5桁
          
          picture = Cache.picture("数字英語")
          for z in 1..$cha_skill_level[$scombo_no[x]].to_s.size
            case z
            
            when 1..2
              rect = Rect.new($cha_skill_level[$scombo_no[x]].to_s[-z,1].to_i*8, 168, 8, 16)
              @status_window.contents.blt(Scombo_slvx+48-(z-1)*8+8,Scombo_slvy+28,picture,rect)
            else
              rect = Rect.new($cha_skill_level[$scombo_no[x]].to_s[-z,1].to_i*16, 0, 16, 16)
              @status_window.contents.blt(Scombo_slvx+48-(z-1)*16+16,Scombo_slvy+28,picture,rect)
            end
          end
        end
        #Sコンボ名
        rect = output_technique_detail $scombo_no[x]
      else
        #falseの場合は0を指定して0を取得する
        rect = output_technique_detail 0
        #覚えていない場合は詳細表示しない
        @scombo_putmode = 0
      end
      picture = $tec_mozi #必殺技文字列化
      @status_window.contents.blt(Scombo_makix+24,Scombo_makiy+12,picture,rect)
      
      if @scombo_putmode == 1
        output_tec_help $scombo_no[x]
      else
        tmp_scombo_cha = Marshal.load(Marshal.dump($scombo_cha[x]))
        tmp_scombo_card_attack_num = Marshal.load(Marshal.dump($scombo_card_attack_num[x]))
        tmp_scombo_card_gard_num = Marshal.load(Marshal.dump($scombo_card_gard_num[x]))
        tmp_scombo_flag_tec = Marshal.load(Marshal.dump($scombo_flag_tec[x]))
        tmp_scombo_skill_level_num = Marshal.load(Marshal.dump($scombo_skill_level_num[x]))
        
        chaput_page_strat = @chaput_page * @chaput_max
        
        if $scombo_cha_count[x] < (@chaput_page + 1) * @chaput_max
          chaput_end = $scombo_cha_count[x] - 1 
        else
          chaput_end = (@chaput_page+1) * @chaput_max - 1
        end
        
        if $scombo_cha_count[x] > (@chaput_page + 1) * @chaput_max
          @c_down_cursor.visible = true
        else
          @c_down_cursor.visible = false
        end
        
        if @chaput_page > 0
          @c_up_cursor.visible = true
        else
          @c_up_cursor.visible = false
        end
        
        #p chaput_page_strat,chaput_end
        
        #全キャラが回数を満たしてかつ一定以上必殺使っているかチェック      
        all_skill_level_num_clear = false
        for y in 0..$scombo_cha_count[x]-1
          tmp_getno = tmp_scombo_cha.index($partyc[@cursorstate])
          #カーソル合わせた技の回数初期化(エラー対策)
          $cha_skill_level[tmp_scombo_flag_tec[y]] = 0 if $cha_skill_level[tmp_scombo_flag_tec[y]] == nil
          #p "対象必殺技:" + tmp_scombo_flag_tec[tmp_getno].to_s
          
          #対象の技の熟練度と覚えているかチェック
          if (tmp_scombo_skill_level_num[y] + $all_scombo_skill_level_add_num) > $cha_skill_level[tmp_scombo_flag_tec[y]] || #回数
            $game_actors[tmp_scombo_cha[y]].skill_learn?($data_skills[tmp_scombo_flag_tec[y]]) == false #対象の技を覚えていない
            #満たしていない
            #フラグを初期化
            all_skill_level_num_clear = false
            break
          end
          #フラグを有効か
          all_skill_level_num_clear = true
          
        end
        
        #Sコンボ残り回数表示用に範囲無視して表示する(直し方がわからないのでこのまま放置)
        for y in chaput_page_strat..$scombo_cha_count[x]-1#chaput_end
          
          if $game_switches[$scombo_get_flag[x]] == true || all_skill_level_num_clear == true
            #取得済みのケースか未取得だけど、全ての使用回数が条件を満たしてかつ一定以上必殺技を使っている
            #picture = Cache.picture($top_file_name+"顔味方")
            #rect = Rect.new(0, 0+((tmp_scombo_cha[y]-3)*64), 64, 64) # 顔グラ
            rect,picture = set_character_face 0,tmp_scombo_cha[y]-3
            @status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy),picture,rect)
            picture = Cache.picture("カード関係")
            rect = set_card_frame 4 # 流派枠
            @status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+64,picture,rect)
            rect = Rect.new(32*($game_actors[tmp_scombo_cha[y]].class_id-1), 64, 32, 32) # 流派
            @status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x+16,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+64,picture,rect)
            
            #スキルでSコンボの必要な星を調整
            scmb_mainasu_a = 0
            scmb_mainasu_g = 0
            scmb_mainasu_a,scmb_mainasu_g = chk_doutyou_run tmp_scombo_cha[y]
            #p tmp_scombo_card_attack_num[y],scmb_mainasu_a,tmp_scombo_cha[y]
            tmp_scombo_card_attack_num[y] -= scmb_mainasu_a
            #p tmp_scombo_card_attack_num[y],scmb_mainasu_a,tmp_scombo_cha[y]
            #調整の結果0以下になったら0にする
            if tmp_scombo_card_attack_num[y] < 0
              tmp_scombo_card_attack_num[y] = 0
            end
            tmp_scombo_card_gard_num[y] -= scmb_mainasu_g
            #調整の結果0以下になったら0にする
            if tmp_scombo_card_gard_num[y] < 0
              tmp_scombo_card_gard_num[y] = 0
            end
            
            #カード表示
            if $game_switches[$scombo_get_flag[x]] == true
              #取得済み
              picture = Cache.picture("カード関係")
              recta = set_card_frame 0 # カード元格納(共通のため1どのみ)
              rectb = set_card_frame 2,tmp_scombo_card_attack_num[y] # 攻撃
              rectc = set_card_frame 3,tmp_scombo_card_gard_num[y] # 防御
              rectd = Rect.new(0 + 32 * ($game_actors[tmp_scombo_cha[y]].class_id-1), 64, 32, 32) # 流派
              @status_window.contents.blt(0+Scombo_makix + Scombo_makitochaaki_x + Scombo_chatocardaki_x,0+Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy),picture,recta)
              @status_window.contents.blt(2+Scombo_makix + Scombo_makitochaaki_x + Scombo_chatocardaki_x+$output_carda_tyousei_x,2+Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+$output_carda_tyousei_y,picture,rectb)
              @status_window.contents.blt(30+Scombo_makix + Scombo_makitochaaki_x + Scombo_chatocardaki_x+$output_cardg_tyousei_x,62+Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+$output_cardg_tyousei_y,picture,rectc)
              @status_window.contents.blt(16+Scombo_makix + Scombo_makitochaaki_x + Scombo_chatocardaki_x+$output_cardi_tyousei_x,32+Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+$output_cardi_tyousei_y,picture,rectd)
              
            else
              #未取得
              picture = Cache.picture("カード関係")
              recta = set_card_frame 1
              @status_window.contents.blt(0+Scombo_makix + Scombo_makitochaaki_x + Scombo_chatocardaki_x,0+Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy),picture,recta)
            end
            #Scombo_chatotecakiy
            #技表示
            #picture = Cache.picture("文字_必殺技")
            if $game_switches[$scombo_get_flag[x]] == true || tmp_scombo_cha[y] == $partyc[@cursorstate]
              #取得済み
              rect = output_technique_detail tmp_scombo_flag_tec[y]
              picture = $tec_mozi #必殺技文字列化
            else
              #はてな
              rect = output_technique_detail 0
              picture = $tec_mozi #必殺技文字列化
            end
            @status_window.contents.blt(16 + Scombo_makix + Scombo_makitochaaki_x+Scombo_chatotecakix,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy-8,picture,rect)
            #技回数表示
            if $game_switches[$scombo_get_flag[x]] == true
              #取得時
              picture = Cache.picture("数字英語")
              rect = Rect.new(160, 16, 8, 16) #カッコはじまり
              @status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              rect = Rect.new(168, 16, 8, 16) #カッコ終わり
              @status_window.contents.blt(8+46+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)

              for z in 0..tmp_scombo_skill_level_num[y].to_s.size-1 #回数
                rect = Rect.new(tmp_scombo_skill_level_num[y].to_s[tmp_scombo_skill_level_num[y].to_s.size-1-z,1].to_i*16, 0, 16, 16)
                @status_window.contents.blt(40-(16*z)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              end
            else
              #未取得時
              picture = Cache.picture("数字英語")
              rect = Rect.new(160, 16, 8, 16) #カッコはじまり
              @status_window.contents.blt(32 + Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              rect = Rect.new(168, 16, 8, 16) #カッコ終わり
              @status_window.contents.blt(32 + 8+46+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              rect = Rect.new(176, 0, 32, 16) #あと
              @status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              
              #回数0を表示
              rect = Rect.new(0.to_i*16, 0, 16, 16)
              @status_window.contents.blt(32 + 40-(16*0)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
            end
          else
            #未取得かつ選択しているキャラが回数満たしたケース
            #必殺技使用回数初期化エラー対策
            $cha_skill_level[tmp_scombo_flag_tec[y]] = 0 if $cha_skill_level[tmp_scombo_flag_tec[y]] == nil

            #picture = Cache.picture("スカ")
            #rect = Rect.new(0, 0, 64, 64) # 顔グラ
            #@status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+(y*Scombo_chayy),picture,rect)
            
            #顔グラ
            if y == 0
              rect,picture = set_character_face 0,tmp_scombo_cha[tmp_scombo_cha.index($partyc[@cursorstate])]-3
              @status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy),picture,rect)
            else
              color = Color.new(0,0,0,260)
              @status_window.contents.fill_rect(Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy),64,64,color)
            end
            
            picture = Cache.picture("カード関係")
            rect = set_card_frame 4 # 流派枠
            @status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+64,picture,rect)
            
            #流派
            if y == 0
              #一番上は選択キャラの流派
              rect = Rect.new(32*($game_actors[tmp_scombo_cha[tmp_scombo_cha.index($partyc[@cursorstate])]].class_id-1), 64, 32, 32) # 流派
              @status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x+16,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+64,picture,rect)
            else
              #流派Z
              rect = Rect.new(320, 0, 32, 32) # 流派
              @status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x+16,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+64,picture,rect)
            end
            #カード表示
            picture = Cache.picture("カード関係")
            recta = set_card_frame 1 # カード元格納(共通のため1どのみ)
            @status_window.contents.blt(0+Scombo_makix + Scombo_makitochaaki_x + Scombo_chatocardaki_x,0+Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy),picture,recta)
            #技表示
            #picture = Cache.picture("文字_必殺技")
            #技回数を満たしたか
            

            
=begin
            #Sコンボ対象キャラが表示１番のキャラ
            $cha_skill_level[tmp_scombo_flag_tec[y]] = 0 if $cha_skill_level[tmp_scombo_flag_tec[y]] == nil
            if tmp_scombo_cha[0] == $partyc[@cursorstate]
              if (tmp_scombo_skill_level_num[y] - $cha_skill_level[tmp_scombo_flag_tec[y]]) > 0 || tmp_scombo_cha[y] != $partyc[@cursorstate]
                #満たしていない？を表示
                rect = output_technique_detail 0
              else 
                #満たした　対象の技を表示
                rect = output_technique_detail tmp_scombo_flag_tec[y]
              end
            else
              #2番以降
              tmp_scombo_skill_level_num[y] = 0 if tmp_scombo_skill_level_num[y] == nil
              $cha_skill_level[tmp_scombo_flag_tec[tmp_scombo_cha.index($partyc[@cursorstate])]] = 0 if $cha_skill_level[tmp_scombo_flag_tec[tmp_scombo_cha.index($partyc[@cursorstate])]] == nil
              if (tmp_scombo_skill_level_num[y] - $cha_skill_level[tmp_scombo_flag_tec[tmp_scombo_cha.index($partyc[@cursorstate])]]) <= 0
                if @chaput_page == 0 && y == 0
                  #キャラ表示1ページめ
                  rect = output_technique_detail tmp_scombo_flag_tec[tmp_scombo_cha.index($partyc[@cursorstate])]
                else
                  #キャラ表示2ページめ以降
                  rect = output_technique_detail 0
                end
              else
                #条件満たしていない
                rect = output_technique_detail 0
              end
            end
=end
            #技回数表示
            picture = Cache.picture("数字英語")
            
            rect = Rect.new(160, 16, 8, 16) #カッコはじまり
            @status_window.contents.blt(32 + Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
            rect = Rect.new(168, 16, 8, 16) #カッコ終わり
            @status_window.contents.blt(32 + 8+46+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
            rect = Rect.new(176, 0, 32, 16) #あと
            @status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
            
            tmp_tecnumok = false
            if y == 0
              #カーソル合わせたキャラが必殺技回数を満たしているか？
              #カーソル合わせたキャラが何番目にいるか取得
              tmp_getno = tmp_scombo_cha.index($partyc[@cursorstate])
              #カーソル合わせた技の回数初期化(エラー対策)
              $cha_skill_level[tmp_scombo_flag_tec[tmp_getno]] = 0 if $cha_skill_level[tmp_scombo_flag_tec[tmp_getno]] == nil
              #p "対象必殺技:" + tmp_scombo_flag_tec[tmp_getno].to_s
              
              
              
              if tmp_scombo_skill_level_num[tmp_getno] <= $cha_skill_level[tmp_scombo_flag_tec[tmp_getno]] &&
                $game_actors[tmp_scombo_cha[tmp_getno]].skill_learn?($data_skills[tmp_scombo_flag_tec[tmp_getno]]) == true
                #回数条件満たしている かつ技を覚えている
                rect = output_technique_detail tmp_scombo_flag_tec[tmp_getno]
                tmp_tecnumok = true
              else
                #満たしていない
                rect = output_technique_detail 0
                tmp_tecnumok = false
              end
              
              picture = $tec_mozi #必殺技文字列化
              
              #必殺技表示
              @status_window.contents.blt(16 + Scombo_makix + Scombo_makitochaaki_x+Scombo_chatotecakix,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy-8,picture,rect)
              #残り回数表示
              picture = Cache.picture("数字英語")
              
              #ループ回数セット
              if tmp_tecnumok == true
                tmp_num = 0
              else
                #対象技を覚えている時は適切な数字をセット
                if $game_actors[tmp_scombo_cha[tmp_getno]].skill_learn?($data_skills[tmp_scombo_flag_tec[tmp_getno]]) == true
                  tmp_num = tmp_scombo_skill_level_num[tmp_getno] - $cha_skill_level[tmp_scombo_flag_tec[tmp_getno]]
                else
                  #覚えていない場合は、残り回数は最大値をセット
                  tmp_num = tmp_scombo_skill_level_num[tmp_getno]
                end
              end

              for z in 0..tmp_num.to_s.size - 1 #回数
                #p tmp_num.to_s[tmp_num.to_s.size - 1 - z,1]
                rect = Rect.new(tmp_num.to_s[tmp_num.to_s.size - 1 - z,1].to_i*16, 0, 16, 16)
                #@status_window.contents.blt(32 + 40-(16*z)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
                @status_window.contents.blt(32 + 40-(16*z)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+(0*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              end
              
              #for z in 0..tmp_num.to_s.size - 1 #回数
              #  rect = Rect.new(tmp_num.to_s[z,1].to_i*16, 0, 16, 16)
              #  @status_window.contents.blt(32 + 40-(16*z)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              #end
            else
              
              #必殺技
              rect = output_technique_detail 0
              picture = $tec_mozi #必殺技文字列化
              @status_window.contents.blt(16 + Scombo_makix + Scombo_makitochaaki_x+Scombo_chatotecakix,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy-8,picture,rect)
              
              #回数
              picture = Cache.picture("数字英語")
              rect = Rect.new(16*20, 16, 16, 16) #ハテナ
              @status_window.contents.blt(32 + 40-(16*0)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              
              #rect = output_technique_detail $scombo_no[x]
              #picture = $tec_mozi #必殺技文字列化
              #@status_window.contents.blt(32 + 40-(16*0)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              
            end
=begin
            #回数表示を無理やり一番上にする
            if tmp_scombo_cha[y] != $partyc[@cursorstate] 
              rect = Rect.new(16*20, 16, 16, 16) #ハテナ
              if y != 0
                @status_window.contents.blt(32 + 40-(16*0)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              end
            elsif (tmp_scombo_skill_level_num[y] - $cha_skill_level[tmp_scombo_flag_tec[y]]) > 0
              #たぶん回数表示
              for z in 0..(tmp_scombo_skill_level_num[y] - $cha_skill_level[tmp_scombo_flag_tec[y]]).to_s.size-1 #回数
                
                if @chaput_page == 0
                  rect = Rect.new((tmp_scombo_skill_level_num[y] - $cha_skill_level[tmp_scombo_flag_tec[y]]).to_s[(tmp_scombo_skill_level_num[y] - $cha_skill_level[tmp_scombo_flag_tec[y]]).to_s.size-1-z,1].to_i*16, 0, 16, 16)
                  @status_window.contents.blt(32 + 40-(16*z)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+(0*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
                end
                if y != 0
                  rect = Rect.new(16*20, 16, 16, 16) #ハテナ
                  @status_window.contents.blt(32 + 40-(16*0)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
                
                end
              end
            else
              #たぶん回数条件満たした
              #rect = Rect.new(160, 16, 8, 16) #カッコはじまり
              #@status_window.contents.blt(Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+(y*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              #rect = Rect.new(168, 16, 8, 16) #カッコ終わり
              #@status_window.contents.blt(8+46+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+(y*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              
              if @chaput_page == 0
                rect = Rect.new(0, 0, 16, 16) #0
                @status_window.contents.blt(32 + 40-(16*0)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+(0*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              end
              if y != 0
                rect = Rect.new(16*20, 16, 16, 16) #ハテナ
                @status_window.contents.blt(32 + 40-(16*0)+Scombo_makix + Scombo_makitochaaki_x,Scombo_makiy + Scombo_makitochaaki_y+((y - @chaput_page * @chaput_max)*Scombo_chayy)+Scombo_chatotecakiy,picture,rect)
              else
                
              end
            end
=end
          end
        end
      end
    end

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
        @cursor_scombo_select += 1
        if @cursor_scombo_select >= cursor_s_end
          @cursor_scombo_select = 0
          if @s_down_cursor.visible == true
            @tecput_page +=1
          else
            @tecput_page = 0
          end
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
        @cursor_scombo_select -= 1
        if @cursor_scombo_select <= -1
          if @s_up_cursor.visible == true
            @tecput_page -=1
            @cursor_scombo_select = @tecput_max -1
          else
            @tecput_page = (@scombo_cha_num-1) / @tecput_max
            @cursor_scombo_select = @scombo_cha_num - @tecput_page * @tecput_max -1
            #p @tecput_page,cursor_s_end
          end
        end
      end



      
    when 6

    when 4

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