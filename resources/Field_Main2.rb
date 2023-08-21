#==============================================================================
# ■ Field_Main
#------------------------------------------------------------------------------
# 　フィールド時のメイン処理
#==============================================================================
class Field_Main2 < Scene_Map
  include Share

  Countwinsizex = 126
  Countwinsizey = 64
  
  Titlewinsizex = 480 - Countwinsizex
  Titlewinsizey = Countwinsizey

  Menuwinsizex = Countwinsizex + Titlewinsizex
  Menuwinsizey = 320
  
  Menukaigyouy = 32
  Menukaigyoux = 196
  
  Menutyouseix = 18
  Menutyouseiy = 0
  
  Resultwinsizex = 380
  Resultwinsizey = 100
  Resultwintyouseix = (640 - Resultwinsizex) / 2
  Resultwintyouseiy = (480 - Resultwinsizey) / 2


  def initialize
    #$game_map.autoplay
    #$map_bgm = RPG::BGM.last.name
    $game_map.autoplay
    $map_bgm = $option_action_sel_bgm_name
    set_move_list
    set_talk_list
    #get_movelist
    
    #メニューの最大表示数(移動なども共通で使用する)
    @menu_putmax_y = 9
    @menu_putmax_x = 1
    
    @menu_cursor_count = 0
    
    @result_cursor_putx = 0
    @result_cursor_puty = 0
    @result_cursor_count = 0
    #メニューの一覧
    @menu_mozi = ["しゅぎょう","いどう","かいわ","ゆうこうど","のうりょく","Sコンボ","カード","さくせん","たたかいのきろく","オプション","セーブ"]
    
    #修行の一覧(スイッチを見るので別定義)
    @training_mozi = []
    
    #移動場所の一覧(スイッチを見るので別定義)
    @move_mozi = []
    
    #話すの一覧(スイッチを見るので別定義)
    @talk_mozi = []
    
    #Window状態 ボツWindowのアクティブ状態で作ってみる
    #0:メニュー 1:修行 2:移動
    #@windowstate = 0
    
    #メニューcursorの一時保存用
    @old_menu_cursor_putx = 0
    @old_menu_cursor_puty = 0
  end
  
  #--------------------------------------------------------------------------
  # ● 移動場所の名前を設定する
  #--------------------------------------------------------------------------
  def set_move_list
    $move_list_count = 0 #カウント
    $move_listno = [] #連番
    $move_listkanzi = [] #漢字名
    $move_listkana = [] #ひらがな表示名
    $move_game_switch = [] #表示フラグ参照スイッチ番号
    $move_sortno = [] #ソート順
    $move_runeveno = [] #実行イベントNo
    $move_count_var = [] #移動回数カウント
    
    v_count = 0
    fname = "Data/_move_list.rvdata" #ファイル順を上にしたから_残す
    
    kugiri = "`"
    obj = load_data(fname)
    obj.each_with_index do |s,i|
        
      for v in 0..s.size-1
        if s[v].to_s.index(kugiri) != nil
          tmp_arr = []
          for arr in s[v].gsub(kugiri,",").chomp.split(",")
            tmp_arr.push(arr.to_i)
            
          end
          #p tmp_arr
        else
          tmp_arr = s[v]
        end
        #p tmp_arr
        if i > 0
          #p tmp_arr
          case v
            #0はNo、1は漢字を含む名前
            when 0 #連番
              $move_listno[i-1] = tmp_arr
            when 1 #漢字名
              $move_listkanzi[i-1] = tmp_arr
            when 2 #ひらがな表示名
              $move_listkana[i-1] = tmp_arr
            when 3 #表示フラグ参照スイッチ番号
              $move_game_switch[i-1] = tmp_arr
            when 4 #移動回数カウント
              $move_count_var[i-1] = tmp_arr
            when 5 #ソート順
              $move_sortno[i-1] = tmp_arr
            when 6 #実行イベントNo
              $move_runeveno[i-1] = tmp_arr
          end
        end
      end

       $move_list_count += 1
     end
    $move_list_count -= 2
    
  end
  
  #--------------------------------------------------------------------------
  # ● 会話リストを設定する
  #--------------------------------------------------------------------------
  def set_talk_list
    $talk_list_count = 0 #カウント
    $talk_listno = [] #連番
    $talk_listkanzi = [] #漢字名
    $talk_listkana = [] #ひらがな表示名
    $talk_friend_game_ver = [] #友好度の参照変数番号
    $talk_friend_game_switch = [] #仲間にしたフラグ番号
    $talk_getpicfilename = [] #ピクチャの参照種類
    $talk_getpicno = [] #ピクチャの参照縦位置
    $talk_putzyouken_yuukoudo = [] #会話一覧に表示する条件友好度
    $talk_putzyouken_nakamaon = [] #会話一覧に表示する条件仲間にしたか
    $talk_sortno = [] #ソート順
    $talk_runeveno = [] #実行イベントNo
    
    v_count = 0
    fname = "Data/_talk_list.rvdata" #ファイル順を上にしたから_残す
    
    kugiri = "`"
    obj = load_data(fname)
    obj.each_with_index do |s,i|
        
      for v in 0..s.size-1
        if s[v].to_s.index(kugiri) != nil
          tmp_arr = []
          for arr in s[v].gsub(kugiri,",").chomp.split(",")
            tmp_arr.push(arr.to_i)
            
          end
          #p tmp_arr
        else
          tmp_arr = s[v]
        end
        #p tmp_arr
        if i > 0
          #p tmp_arr
          case v
            #0はNo、1は漢字を含む名前
            when 0 #連番
              $talk_listno[i-1] = tmp_arr
            when 1 #漢字名
              $talk_listkanzi[i-1] = tmp_arr
            when 2 #ひらがな表示名
              $talk_listkana[i-1] = tmp_arr
            when 3 #友好度の参照変数番号
              $talk_friend_game_ver[i-1] = tmp_arr
            when 4 #仲間にしたフラグ番号
              $talk_friend_game_switch[i-1] = tmp_arr
            when 5 #ピクチャの参照種類
              $talk_getpicfilename[i-1] = tmp_arr
            when 6 #ピクチャの参照縦位置
              $talk_getpicno[i-1] = tmp_arr
            when 7 #会話一覧に表示する条件友好度
              $talk_putzyouken_yuukoudo[i-1] = tmp_arr
            when 8 #会話一覧に表示する条件仲間にしたか
              $talk_putzyouken_nakamaon[i-1] = tmp_arr
            when 9 #ソート順
              $talk_sortno[i-1] = tmp_arr
            when 10 #実行イベントNo
              $talk_runeveno[i-1] = tmp_arr
          end
        end
      end

       $talk_list_count += 1
     end
    $talk_list_count -= 2
    
  end
  #--------------------------------------------------------------------------
  # ● 話すのが可能なリストを取得
  #-------------------------------------------------------------------------- 
  def get_talklist

    @tmpordermozi = []
    
    for x in 0..$talk_listno.size - 1
      #sortmozi = kanatohira $talk_listkana[x]
      @tmpordermozi << [$talk_listno[x],$talk_listkana[x],(kanatohira $talk_listkana[x]),$talk_friend_game_ver[x],$talk_friend_game_switch[x],$talk_putzyouken_yuukoudo[x],$talk_putzyouken_nakamaon[x],$talk_runeveno[x]]
    end
    
    #ひらがな変換した文字でソートする
    @tmpordermozi = @tmpordermozi.sort_by{|no,mozi,sortmozi,game_ver,game_switch,yuukoudo,nakamaon,talk_runeveno| sortmozi}

    @talk_mozi = []
    
    for x in 0..@tmpordermozi.size - 1

      addchk = false

      if @tmpordermozi[x][6] == 1
        #仲間キャラであることを確認
        if @tmpordermozi[x][4] != 0 
          #仲間になっている
          if $game_switches[@tmpordermozi[x][4]] == true
            addchk = true
          end
        end
      elsif @tmpordermozi[x][5].to_i != -1 &&
        @tmpordermozi[x][5].to_i <= $game_variables[@tmpordermozi[x][3]]
         #仲間フラグを見ていないかつ、友好度変数が指定以下
        addchk = true
      end

      #例外チェック
      #こちらはチェックでNGだった場合はfalseにする
      add_chk_special = true
      
      #チェック後追加対象であるならば追加する。
      #特殊条件があった場合は、特殊条件の結果も見る
      if addchk == true && add_chk_special == true
        @talk_mozi << @tmpordermozi[x]
      end
    end

  end
  
  #--------------------------------------------------------------------------
  # ● 修行可能なリストを取得
  #-------------------------------------------------------------------------- 
  def get_traininglist
    
    @training_mozi = [[0,"いらいをこなす"],[1,"ひとりでしゅぎょう"]]
    
  end
  #--------------------------------------------------------------------------
  # ● 移動可能なリストを取得
  #-------------------------------------------------------------------------- 
  def get_movelist
    
    moveputflag = false
    temp_putmovelist = []
    for i in 0..$move_list_count
      if $game_switches[$move_game_switch[i]] == true
        #表示フラグが立っているなら変数に格納
        temp_putmovelist << [$move_listno[i],$move_listkana[i],$move_sortno[i]]
      end
    end
    
    #p temp_putmovelist
    @move_mozi = temp_putmovelist.sort_by{|renban,mozi,sortno| sortno.to_i}
    #p temp_putmovelist
  end
  #--------------------------------------------------------------------------
  # ● このマップから移動する準備
  #-------------------------------------------------------------------------- 
  def moveready
    #メニュー表示のスイッチ初期化
    for i in 2302..2305
      $game_switches[i] = false
    end
    $menu_cursor_puty = 0
    $menu_cursor_putx = 0
    
    dispose_window
    dispose_sprite
  end  
  #--------------------------------------------------------------------------
  # ● カーソル位置の一時保存
  # mode:0 メインから他の画面、 1:他の画面からメイン
  #--------------------------------------------------------------------------   
  def temp_cursor_position mode
    
    case mode
    
    when 0 #メインから他の画面
      @old_menu_cursor_putx = 0
      @old_menu_cursor_puty = 0
      @old_menu_cursor_putx,$menu_cursor_putx = $menu_cursor_putx,@old_menu_cursor_putx
      @old_menu_cursor_puty,$menu_cursor_puty = $menu_cursor_puty,@old_menu_cursor_puty
          
    when 1 #他の画面からメイン
      @old_menu_cursor_putx,$menu_cursor_putx = $menu_cursor_putx,@old_menu_cursor_putx
      @old_menu_cursor_puty,$menu_cursor_puty = $menu_cursor_puty,@old_menu_cursor_puty
      @old_menu_cursor_putx = 0
      @old_menu_cursor_puty = 0
      
    end
  end
  #--------------------------------------------------------------------------
  # ● 実行するイベントNOを返す
  # actionnum: 1修行 2移動 3会話
  # actionname:ボタンを押した箇所の名前だったりNo
  #--------------------------------------------------------------------------   
  def geteveno actionnum,actionname
    
    eveno = 0
    case actionnum
    when 1 #修行
      case actionname
      
      when 0 #いらいをこなす
        eveno = 0
      when 1 #ひとりでしゅぎょう
        eveno = 0
      end
      
    when 2 #移動
      eveno = $move_runeveno[actionname]
      
    when 3 #会話
      eveno = actionname.to_i
    end
      
    return eveno
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  # 戻り値 "1" ：(メニュー画面を抜ける)
  #--------------------------------------------------------------------------   
  def update
    @menu_cursor.visible = true
    
    #super
    #p 1
    #カード所持数が0のときはキャンセル以外処理しない
    if Input.trigger?(Input::B)
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)
      
      #はい、いいえ選択か
      if @result_window.active == true
        #修行、移動、話す選択中
        @result_window.active = false
        @result_window.visible = false
        @result_cursor.visible = false
        @result_cursor_putx = 0
      else
        if @training_window.active == true
          #メニュー画面に戻る
          @menu_window.active = true
          @training_window.active = false
          @training_window.visible = false
          #メニューcursorの一時保存
          temp_cursor_position 1
          
          pre_output
        end
        
        if @move_window.active == true
          #メニュー画面に戻る
          @menu_window.active = true
          @move_window.active = false
          @move_window.visible = false
          #メニューcursorの一時保存
          temp_cursor_position 1
          
          pre_output
        end
        
        if @talk_window.active == true
          #メニュー画面に戻る
          @menu_window.active = true
          @talk_window.active = false
          @talk_window.visible = false
          #メニューcursorの一時保存
          temp_cursor_position 1

          pre_output
        end
      end
    end  

    #ページ送り前
    if Input.trigger?(Input::L)
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)
    end

    #ページ送り後ろ
    if Input.trigger?(Input::R)
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)

    end
  
    if Input.trigger?(Input::C)
      
            
      if @menu_window.active == true
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)
        @menu_cursor.visible = false
        
        select_no = $menu_cursor_puty + (@menu_putmax_y * $menu_cursor_putx)
        
        case @menu_mozi[select_no]
        when "しゅぎょう"
          #しゅぎょう画面に進む
          @menu_window.active = false
          @training_window.active = true
          @training_window.visible = true
          
          #メニューcursorの一時保存
          temp_cursor_position 0
          
          get_traininglist
          pre_output
        when "いどう"
          #移動画面に進む
          @menu_window.active = false
          @move_window.active = true
          @move_window.visible = true
          
          #メニューcursorの一時保存
          temp_cursor_position 0
          
          get_movelist
          pre_output
        when "かいわ"
          #話す画面に進む
          @menu_window.active = false
          @talk_window.active = true
          @talk_window.visible = true
          #メニューcursorの一時保存
          temp_cursor_position 0

          get_talklist
          pre_output
        when "ゆうこうど"
          $scene = Scene_Db_friendlist.new
          Graphics.fadeout(5)
        when "Sコンボ"
          $scene = Scene_Db_Scombo_Menu.new
          Graphics.fadeout(5)
        when "たたかいのきろく"
          Graphics.fadeout(5)
          moveready
          $game_variables[41] = 41
          $game_player.reserve_transfer(7, 0, 0, 0) # 場所移動
          $scene = Scene_Map.new
        when "さくせん"
          $scene = Scene_Db_Tactics_Menu.new
          Graphics.fadeout(5)
        when "カード"
          $background_bitmap = Graphics.snap_to_bitmap
          Graphics.fadeout(5)
          $game_switches[479] = true
          $game_temp.next_scene = "db_card"
        when "のうりょく"
          $run_item_card_id = 0
          $game_temp.next_scene = "db_status"
        when "オプション"
          $scene = Scene_Db_Option.new
          Graphics.fadeout(5)
        when "セーブ"
          #$scene = Scene_File.new(true, false, true)
          $game_temp.next_scene = "save"
        end
        
      elsif @result_window.active == true
        
        if @result_cursor_putx == 0 #はいを選択
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)
          #選択位置の取得
          arrno = $menu_cursor_putx * @menu_putmax_y + $menu_cursor_puty
          selactionnum = 0
          selactionname = ""
          
          if @training_window.active == true
            selactionname = @training_mozi[arrno][0]
            selactionnum = 1
          end
          
          if @move_window.active == true
            #selactionname = @move_mozi[arrno][1] #名前
            selactionname = @move_mozi[arrno][0] #連番
            selactionnum = 2
            
            varnum = $move_count_var[@move_mozi[arrno][0]]
            #移動回数を1追加する
            $game_variables[varnum] += 1
            #移動回数を汎用回数判定用にsetする
            $game_variables[904] = $game_variables[varnum]
          end
          
          if @talk_window.active == true
            selactionname = @talk_mozi[arrno][7]
            selactionnum = 3
            
            varnum = $talk_friend_game_ver[@talk_mozi[arrno][0]]
            #話すキャラの友好度を汎用回数判定用にsetする
            $game_variables[903] = $game_variables[varnum]
          end
          
          #乱数生成をここで3枠まとめて処理
          randnums = 1
          randnume = 100
          $game_variables[464] = randnums + rand(randnume - randnums + 1)
          $game_variables[465] = randnums + rand(randnume - randnums + 1)
          $game_variables[466] = randnums + rand(randnume - randnums + 1)

          Graphics.fadeout(5)
          #行動回数を＋1にする
          $game_variables[901] += 1

=begin
          p "$game_variables[41]:" + $game_variables[41].to_s,
             "selactionnum" + selactionnum.to_s,
             "selactionname" + selactionname.to_s,
             "$menu_cursor_putx" + $menu_cursor_putx.to_s,
             "$menu_cursor_puty" + $menu_cursor_puty.to_s,
             @talk_mozi
=end
          #移動準備
          moveready
          
          $game_variables[41] = geteveno(selactionnum,selactionname)
          
          #イベント後メニューに戻れるように移動先に固定値をセットする
          run_common_event 345
          
          $game_player.reserve_transfer(7, 0, 0, 0) # 場所移動
          $scene = Scene_Map.new
        else
          #いいえを選択
          #修行、移動、話す選択中
          @result_window.active = false
          @result_window.visible = false
          @result_cursor.visible = false
          @result_cursor_putx = 0
        end
      elsif @training_window.active == true ||
        @move_window.active == true ||
        @talk_window.active
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)
        #修行、移動、話す選択中
        @result_cursor.visible = true
        @result_window.active = true
        @result_window.visible = true
        @result_cursor_putx = 0

        pre_output
      end
      

    end

    
    if Input.trigger?(Input::DOWN)
      if @result_window.active == true
        
      else
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)
        move_cursor 2
      end
    end
    if Input.trigger?(Input::UP)
      if @result_window.active == true
        
      else
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)
        move_cursor 8
      end
    end
    if Input.trigger?(Input::RIGHT)
      if @result_window.active == true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)
        if @result_cursor_putx == 0
          @result_cursor_putx = 1
        else
          @result_cursor_putx = 0
        end
      else
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)
        move_cursor 6
      end
    end
    if Input.trigger?(Input::LEFT)
      if @result_window.active == true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)
        if @result_cursor_putx == 0
          @result_cursor_putx = 1
        else
          @result_cursor_putx = 0
        end
      else
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)
        move_cursor 4
      end
    end

    @menu_cursor_count += 1
    
    if @result_cursor != nil && @result_cursor.visible == true
      @result_cursor_count += 1
    end
    
    if @back_window != nil
      update_cursor
    end
    
    #何かしらの処理中フラグ解除
    $game_switches[2307] = false
  end
  #--------------------------------------------------------------------------
  # ● カーソル移動
  # windowno:
  # directionno:どの方向か
  #--------------------------------------------------------------------------
  def move_cursor direction_no
    
    
    window_no = 0 #どのcursor動かすか
    
    if @menu_window.active == true
      window_no = 0
      size = @menu_mozi.size
    end
    
    if @training_window.active == true
      window_no = 1
      size = @training_mozi.size
    end
    
    if @move_window.active == true
      window_no = 2
      size = @move_mozi.size
    end
    
    if @talk_window.active == true
      window_no = 3
      size = @talk_mozi.size
    end
    
    case window_no #
    
    when 0..3 #メインメニュー、移動
      
      
      case direction_no
      
      when 8 #上
        $menu_cursor_puty -= 1
      when 2 #下
        $menu_cursor_puty += 1
        #p @menu_mozi.size % (@menu_putmax_y * $menu_cursor_putx) rescue 0
      when 4 #左
        $menu_cursor_putx -= 1
      when 6 #右
        $menu_cursor_putx += 1
      end
      
      #横軸
      if $menu_cursor_putx == -1
        $menu_cursor_putx = (@menu_mozi.size - 1) / @menu_putmax_y
        
        #途中の場合
        $menu_cursor_putx = (@menu_mozi.size - 1) / @menu_putmax_y - 1 if $menu_cursor_puty > ((size - 1) - $menu_cursor_putx * @menu_putmax_y)
      elsif $menu_cursor_puty > ((size - 1) - $menu_cursor_putx * @menu_putmax_y)
        $menu_cursor_putx = 0
      elsif $menu_cursor_putx > @menu_putmax_x
        $menu_cursor_putx = 0
      end
      
      #縦横軸
      if $menu_cursor_puty == -1
        #その行の一番下
        $menu_cursor_puty = ((size - 1) - $menu_cursor_putx * @menu_putmax_y)

        #途中までしか無い場合途中の一番下
        $menu_cursor_puty = @menu_putmax_y - 1 if @menu_putmax_y - 1 < $menu_cursor_puty

        #putnumx = @menu_putmax_y
        #putnumy = x - (@menu_putmax_y * putnumx)
      elsif $menu_cursor_puty > (size - 1) && (size - 1) < @menu_putmax_y
        #1列目の途中で終わった
        $menu_cursor_puty = 0
      elsif $menu_cursor_putx >= 1 && $menu_cursor_puty > ((size - 1) - $menu_cursor_putx * @menu_putmax_y)
        #2列目以降で途中で終わった
        $menu_cursor_puty = 0
      elsif $menu_cursor_puty == @menu_putmax_y
        #一番下を超えたら
        #一番下その行の一番上
        $menu_cursor_puty = 0

      end
    


    end
  end
  
  #--------------------------------------------------------------------------
  # ● カーソルピクチャ表示更新
  #--------------------------------------------------------------------------
  def update_cursor
    
    if @menu_cursor != nil
      #get_cursor_pic count=0,tenmetu=1,n=0,blink=0
      #はいいいえWindowを表示している時には点滅しない
      if @result_window.active == false                                           
        @menu_cursor.src_rect,@menu_cursor_count = get_cursor_pic @menu_cursor_count,1
      else
        @menu_cursor.src_rect,@menu_cursor_count = get_cursor_pic @menu_cursor_count,0
      end
      @menu_cursor.x = ($menu_cursor_putx * Menukaigyoux) + Menutyouseix + @menu_window.x - 2
      @menu_cursor.y = ($menu_cursor_puty * Menukaigyouy) + Menutyouseiy + @menu_window.y + 24
    end
    
    if @result_cursor != nil
      if @result_cursor.visible == true
        @result_cursor.src_rect,@result_cursor_count = get_cursor_pic @result_cursor_count,1
        @result_cursor.x = Resultwintyouseix + @result_cursor_putx * 80 + 18
        @result_cursor.y = Resultwintyouseiy + 58
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルピクチャ作成
  #--------------------------------------------------------------------------  
  def create_cursor
    #メニュー選択カーソル
    # スプライトのビットマップに画像を設定
    @menu_cursor = nil
    @menu_cursor = Sprite.new
    @menu_cursor.bitmap = Cache.picture("アイコン")
    @menu_cursor.src_rect,@menu_cursor_count = get_cursor_pic @menu_cursor_count,1
    @menu_cursor.x = $menu_cursor_putx + Menutyouseix + @menu_window.x - 2
    @menu_cursor.y = $menu_cursor_puty + Menutyouseiy + @menu_window.y + 24
    @menu_cursor.z = 255
    @menu_cursor.angle = 0
    @menu_cursor.visible = true
    #@menu_cursor.ox = 0
    
    @result_cursor = nil
    @result_cursor = Sprite.new
    @result_cursor.bitmap = Cache.picture("アイコン")
    @result_cursor.src_rect,@result_cursor_count = get_cursor_pic @result_cursor_count,1
    @result_cursor.x = Resultwintyouseix + @result_cursor_putx * 80 + 18
    @result_cursor.y = Resultwintyouseiy + 58
    @result_cursor.z = 255
    @result_cursor.angle = 0
    @result_cursor.visible = false
    
  end
  #--------------------------------------------------------------------------
  # ● 画面出力
  #--------------------------------------------------------------------------  
  def pre_output
    if @back_window != nil
      
    end
    
    if @title_window != nil && @title_window.active == true
      @title_window.contents.clear
      if @menu_window.active == true
        mozi = "ーこうどうせんたくー"
      end
      if @training_window.active == true
        mozi = "ーしゅぎょうせんたくー"
      end
      if @move_window.active == true
        mozi = "ーいどうばしょせんたくー"
      end
      if @talk_window.active == true
        mozi = "ーかいわせんたくー"
      end
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @title_window.contents.blt(16,0, $tec_mozi,rect)
      
      @title_window.update
    end

    #行動回数表示
    if @count_window != nil && @count_window.active == true
      @count_window.contents.clear
      
      #$game_variables[901] = 99999 
      mozi = $game_variables[901].to_s.rjust(5, " ")  + "T"
      
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @count_window.contents.blt(0,0, $tec_mozi,rect)
      
      @count_window.update
    end
    
    if @training_window != nil && @training_window.active == true
      @training_window.contents.clear
      putnum = 0
      putnumx = 0
      putnumy = 0
      
      for x in 0..@training_mozi.size - 1
        putnumx = x / @menu_putmax_y
        putnumy = x - (@menu_putmax_y * putnumx)
        
        mozi = @training_mozi[x][1].to_s
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @training_window.contents.blt(Menutyouseix + Menukaigyoux * putnumx,Menutyouseiy + Menukaigyouy * putnumy, $tec_mozi,rect)
      end
      
      @training_window.update
    end
    
    if @menu_window != nil && @menu_window.active == true
      @menu_window.contents.clear
      putnum = 0
      putnumx = 0
      putnumy = 0
      
      for x in 0..@menu_mozi.size - 1
        putnumx = x / @menu_putmax_y
        putnumy = x - (@menu_putmax_y * putnumx)
        
        mozi = @menu_mozi[x].to_s
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @menu_window.contents.blt(Menutyouseix + Menukaigyoux * putnumx,Menutyouseiy + Menukaigyouy * putnumy, $tec_mozi,rect)
      end
      
      @menu_window.update
    end
    
    if @move_window != nil && @move_window.active == true
      @move_window.contents.clear
      putnum = 0
      putnumx = 0
      putnumy = 0
      for x in 0..@move_mozi.size - 1
        putnumx = x / @menu_putmax_y
        putnumy = x - (@menu_putmax_y * putnumx)
        
        mozi = @move_mozi[x][1].to_s
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @move_window.contents.blt(Menutyouseix + Menukaigyoux * putnumx,Menutyouseiy + Menukaigyouy * putnumy, $tec_mozi,rect)
      end
      
      @move_window.update
    end
    
    if @talk_window != nil && @talk_window.active == true
      @talk_window.contents.clear
      putnum = 0
      putnumx = 0
      putnumy = 0
      for x in 0..@talk_mozi.size - 1
        putnumx = x / @menu_putmax_y
        putnumy = x - (@menu_putmax_y * putnumx)
        
        mozi = @talk_mozi[x][1].to_s
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @talk_window.contents.blt(Menutyouseix + Menukaigyoux * putnumx,Menutyouseiy + Menukaigyouy * putnumy, $tec_mozi,rect)
      end
      
      @talk_window.update
    end

    if @result_window != nil && @result_window.active == true
      @result_window.contents.clear
      
      #if @menu_window.active == true
      #  #window_no = 0
      #  mozi = "このしゅぎょうを　しますか？"
      #end
      
      if @training_window.active == true
        #window_no = 1
        selectmozi = @training_mozi[$menu_cursor_putx*@menu_putmax_y+$menu_cursor_puty][1]
        mozi = selectmozi.to_s + "　のしゅぎょうをしますか？"
      end
      
      if @move_window.active == true
        window_no = 2
        selectmozi = @move_mozi[$menu_cursor_putx*@menu_putmax_y+$menu_cursor_puty][1]
        mozi = selectmozi.to_s + "　にいどうしますか？"
      end
      
      if @talk_window.active == true
        window_no = 3
        selectmozi = @talk_mozi[$menu_cursor_putx*@menu_putmax_y+$menu_cursor_puty][1]
        mozi = selectmozi.to_s + "　とはなしますか？"
      end
      
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @result_window.contents.blt(4,2, $tec_mozi,rect)
      mozi = "　はい　　　いいえ"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @result_window.contents.blt(4,34, $tec_mozi,rect)
      
      @result_window.update
    end
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ生成
  # 
  #--------------------------------------------------------------------------   
  def create_window
    #背景色
    @back_window = Window_Base.new(-16,-16,672,512)
    @back_window.opacity=0
    @back_window.back_opacity=0
    color = set_skn_color 0
    @back_window.contents.fill_rect(0,0,656,496,color)

    tyousey = 56
    
    #メニュータイトル
    @title_window = Window_Base.new((640-Menuwinsizex)/2,tyousey,Titlewinsizex,Titlewinsizey)
    @title_window.opacity= 255
    @title_window.back_opacity= 255
    
    @title_window.active = true
    
    #行動回数カウント
    @count_window = Window_Base.new(@title_window.x + Titlewinsizex,tyousey,Countwinsizex,Countwinsizey)
    @count_window.opacity= 255
    @count_window.back_opacity= 255
    
    @count_window.active = true
    
    
    #メインメニュー
    @menu_window = Window_Base.new((640-Menuwinsizex)/2,tyousey + Titlewinsizey,Menuwinsizex,Menuwinsizey)
    @menu_window.opacity= 255
    @menu_window.back_opacity= 255
    #@menu_window.active = true
    
    #修行
    @training_window = Window_Base.new((640-Menuwinsizex)/2,tyousey + Titlewinsizey,Menuwinsizex,Menuwinsizey)
    @training_window.opacity= 255
    @training_window.back_opacity= 255
    @training_window.visible = false
    @training_window.active = false
    
    #移動
    @move_window = Window_Base.new((640-Menuwinsizex)/2,tyousey + Titlewinsizey,Menuwinsizex,Menuwinsizey)
    @move_window.opacity= 255
    @move_window.back_opacity= 255
    @move_window.visible = false
    @move_window.active = false
    
    #話す
    @talk_window = Window_Base.new((640-Menuwinsizex)/2,tyousey + Titlewinsizey,Menuwinsizex,Menuwinsizey)
    @talk_window.opacity= 255
    @talk_window.back_opacity= 255
    @talk_window.visible = false
    @talk_window.active = false
    
    #はい、いいえウインドウ
    @result_window = Window_Base.new(Resultwintyouseix,Resultwintyouseiy,Resultwinsizex,Resultwinsizey)
    @result_window.opacity=255
    @result_window.back_opacity=255
    @result_window.visible = false
    @result_window.active = false
    #@result_window.contents.font.color.set( 0, 0, 0)
    
  end
  #--------------------------------------------------------------------------
  # ● スプライト削除
  #--------------------------------------------------------------------------   
  def dispose_sprite
    
    #背景色
    if @menu_cursor != nil
      @menu_cursor.bitmap = nil
      @menu_cursor = nil
    end
    
    #メニュータイトル
    if @result_cursor != nil
      @result_cursor.bitmap = nil
      @result_cursor = nil
    end

  end
  #--------------------------------------------------------------------------
  # ● ウインドウ削除
  #--------------------------------------------------------------------------   
  def dispose_window
    
    #背景色
    if @back_window != nil
      @back_window.dispose
      @back_window = nil
    end
    
    #メニュータイトル
    if @title_window != nil
      @title_window.dispose
      @title_window = nil
    end
    
    #行動カウント
    if @count_window != nil
      @count_window.dispose
      @count_window = nil
    end
    
    #メインメニュー
    if @menu_window != nil
      @menu_window.dispose
      @menu_window = nil
    end

    #修行
    if @training_window != nil
      @training_window.dispose
      @training_window = nil
    end
    
    #移動
    if @move_window != nil
      @move_window.dispose
      @move_window = nil
    end
    
    #話す
    if @talk_window != nil
      @talk_window.dispose
      @talk_window = nil
    end
    
    #はい、いいえウインドウ
    if @result_window != nil
      @result_window.dispose
      @result_window = nil
    end
  end

end