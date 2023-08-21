#==============================================================================
# ■ Scene_Db_card_compo_recipe
#------------------------------------------------------------------------------
# 　カード合成レシピ画面
#==============================================================================
class Scene_Db_card_compo_recipe < Scene_Base
  include Share
  include Icon
  Title_win_sizex = 640
  Title_win_sizey = 64
  Recipe_win_sizex = Title_win_sizex         #パーティーウインドウサイズX
  Recipe_win_sizey = 480 - Title_win_sizey         #パーティーウインドウサイズY
  Result_win_sizex = 450
  Result_win_sizey = 240
  Partyy = 28#24                   #パーティー表示行空き数
  Partynox = 0                  #パーティー表示基準X
  Partynoy = 8                 #パーティー表示基準Y
  

  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize()
    
  end
  
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    
    #カード数調整 最大値にあわせる
    set_max_item_card
    
    @window_state = 0         #ウインドウ状態(並び替え時のみ使用) 0:未選択 1:キャラ選択
    @cursorstate = 0             #カーソル位置
    
    
    
    @cursorstate_side = 0         #カーソル位置横

    @select_componu = 0 #選択している合成パターン
    @cardput_max = 13 #1ページの最大出力数
    @put_start = 0 #出力開始位置
    @put_end = @cardput_max - 1 #出力終了位置
    @put_arrmax = 0 #出力したい配列のサイズ
    
    @backup_cursorstate = 0 #作成したいカードから、レシピに移動した時の一時格納用
    @backup_put_start = 0 #作成したいカードから、レシピに移動した時の一時格納用
    
    @create_cardchano = 0 #作成したいカードNo
    @old_put_start = -1 #出力開始位置の一時保存(元と値が違う時のみ画面を更新する)
    @yes_no_result = 0 #はい、いいえ結果
    create_window
    @window_update_flag = true
    @s_up_cursor = Sprite.new
    @s_down_cursor = Sprite.new
    
    if $temp_card_compo_cursorstate != nil
      @cursorstate = $temp_card_compo_cursorstate
      @put_start = $temp_card_compo_put_start
      @create_cardchano = $temp_create_cardchano
      #作りたいカードから合成かつレシピに戻る場合
      if $temp_card_compo_recipe_mode == 1 && $game_variables[463] == 0
        @window_state = 2
      end
    end

    @cardx = []
    @cardx[0] = Partynox+18
    @cardx[1] = Partynox+18 + 200
    @cardx[2] = Partynox+18 + 200 * 2
    
    #レシピに登録されているリスト
    @get_card_compo_recipe_nolist = []
    #レシピの中で実際に作れるカードリスト
    @card_compo_get_cha_list = [] 
    #レシピの中で実際に作れるカードリストの並び順
    @card_compo_get_cha_list_order_id = []
    #レシピに登録されている作成したいカードの対象リスト
    @card_compo_recipe_chalist = []
    #作成可能な合成リストの取得
    create_get_card_compo_recipe_list
    set_up_down_cursor
    pre_update
    
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    @main_window.update
    Graphics.fadein(10)

    #run_common_event 262
  end

  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_window
    @recipe_window.dispose
    @recipe_window = nil
    @title_window.dispose
    @title_window = nil
    @main_window.dispose
    @main_window = nil
  end 
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def window_contents_clear
    if @put_start != @old_put_start
      @recipe_window.contents.clear
    end
    @title_window.contents.clear
  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def result_window_contents_clear
    @result_window.contents.clear
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
    @result_window = Window_Base.new((640 - Result_win_sizex) / 2,(480 - Result_win_sizey) / 2,Result_win_sizex,Result_win_sizey)
    @result_window.opacity=255
    @result_window.back_opacity=255
    @result_window.contents.font.color.set( 0, 0, 0)
    output_result
  end
  
  #--------------------------------------------------------------------------
  # ● エントリーはいいいえ表示
  #-------------------------------------------------------------------------- 
  def output_result

    #@result_window.contents.draw_text(0,0, 300, 40, "このカードを使用しますか？")
    mozi = "いかのカードを　ごうせいしますか？"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4,2, $tec_mozi,rect)
    
    tyouseix = 14
    picture = Cache.picture("顔カード")
    #1枚目
    rect = put_icon $data_items[$card_compo_cha[@select_componu][0]].id
    @result_window.contents.blt(4 + 96*0,2+Partyy+8, picture,rect)
    
    #所持枚数
    mozi = $game_party.item_number($data_items[$card_compo_cha[@select_componu][0]]).to_s + "まい"
    output_mozi mozi
    if $game_party.item_number($data_items[$card_compo_cha[@select_componu][0]]) == (get_havemax_card $card_compo_get_cha[@select_componu])
      $tec_mozi.change_tone(255,120,48) #オレンジ
    end
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4 + 96*0+16,2+Partyy+8+60, $tec_mozi,rect)
    
    #2枚目
    rect = put_icon $data_items[$card_compo_cha[@select_componu][1]].id
    @result_window.contents.blt(4 + 96*1+tyouseix*2,2+Partyy+8, picture,rect)

    #所持枚数
    mozi = $game_party.item_number($data_items[$card_compo_cha[@select_componu][1]]).to_s + "まい"
    output_mozi mozi
    if $game_party.item_number($data_items[$card_compo_cha[@select_componu][1]]) == (get_havemax_card $card_compo_get_cha[@select_componu])
      $tec_mozi.change_tone(255,120,48) #オレンジ
    end
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4 + 96*1+16+tyouseix*2,2+Partyy+8+60, $tec_mozi,rect)
    
    #合成
    rect = put_icon $data_items[$card_compo_get_cha[@select_componu]].id
    @result_window.contents.blt(4 + 96*2+tyouseix*4,2+Partyy+8, picture,rect)
    
    #所持枚数
    mozi = $game_party.item_number($data_items[$card_compo_get_cha[@select_componu]]).to_s + "まい"
    output_mozi mozi
    
    if $game_party.item_number($data_items[$card_compo_get_cha[@select_componu]]) == (get_havemax_card $card_compo_get_cha[@select_componu])
      $tec_mozi.change_tone(255,120,48) #オレンジ
    end
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4 + 96*2+16+tyouseix*4,2+Partyy+8+60, $tec_mozi,rect)
    
    mozi = "＋"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4 + 96 * 0 + 72 + tyouseix*1,2+Partyy+8 + 14, $tec_mozi,rect)
    
    mozi = "＝"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4 + 96 * 1 + 72+tyouseix*3,2+Partyy+8 + 14, $tec_mozi,rect)
    
    #合成で出来るカードの所持数が最大
    if $game_party.item_number($data_items[$card_compo_get_cha[@select_componu]]) == (get_havemax_card $card_compo_get_cha[@select_componu])
      mozi = "※ごうせいごのカードの　しょじすうに　あきがないため"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @result_window.contents.blt(4,126, $tec_mozi,rect)
      mozi = "　ごうせいしても　じどうばいきゃくされます！"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @result_window.contents.blt(4,126+Partyy, $tec_mozi,rect)
    else
      mozi = "※ごうせいごのカードの　しょじすうに"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @result_window.contents.blt(4,126, $tec_mozi,rect)
      mozi = "　もんだいはありません"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @result_window.contents.blt(4,126+Partyy, $tec_mozi,rect)
    end
    
    mozi = "　はい　　　いいえ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4,180, $tec_mozi,rect)
    #@result_window.contents.draw_text(0,30, 200, 40, "　はい　　　いいえ")
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    #Graphics.fadeout(0)
    @main_window = Window_Base.new(-16,-16,672,512)
    @main_window.opacity=0
    @main_window.back_opacity=0
    @recipe_window = Window_Base.new((640 - Recipe_win_sizex) / 2,Title_win_sizey ,Recipe_win_sizex,Recipe_win_sizey)
    @recipe_window.opacity=255
    @recipe_window.back_opacity=255
    
    @title_window = Window_Base.new((640 - Title_win_sizex) / 2,0 ,Title_win_sizex,Title_win_sizey)
    @title_window.opacity=255
    @title_window.back_opacity=255
    #Graphics.fadein(0)
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
    @s_up_cursor.x = Recipe_win_sizex - Recipe_win_sizex/2 - 8
    @s_up_cursor.y = Title_win_sizey+16
    @s_up_cursor.z = 255
    @s_up_cursor.angle = 91
    @s_up_cursor.visible = false
    
    #Sコンボ下カーソル
    # スプライトのビットマップに画像を設定
    @s_down_cursor.bitmap = Cache.picture("アイコン")
    @s_down_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @s_down_cursor.x = Recipe_win_sizex - Recipe_win_sizex/2 + 8
    @s_down_cursor.y = 480-16
    @s_down_cursor.z = 255
    @s_down_cursor.angle = 269
    @s_down_cursor.visible = false
    
  end

  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------
  def pre_update
    #super
    
    if @window_update_flag == true
      
      case @window_state
      when 0,2 
        window_contents_clear
        output_recipe

        @recipe_window.update
      end
      if @result_window != nil
        result_window_contents_clear
        output_result
      end

      @window_update_flag = false
    end
    output_cursor
    output_updowncursor
    
  end
  #--------------------------------------------------------------------------
  # ● 上下カーソル
  #--------------------------------------------------------------------------
  def output_updowncursor
    
    if @put_start > 0
      @s_up_cursor.visible = true
    else
      @s_up_cursor.visible = false
    end
    if @put_end < (@put_arrmax)
      @s_down_cursor.visible = true
    else
      @s_down_cursor.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 合成のためのカードが足りているかチェック
  #-------------------------------------------------------------------------- 
  def chk_card_compo_cha recipeno
    card_num = 0
    result = true
    
    if $get_card_compo_recipe[recipeno] != true
      result = false
    end
    if result == true #無駄な処理をしないためにレシピを取得している時のみ実行
      #合成元カードの所持数が足りているか確認
      #p $card_compo_cha[recipeno][0] , $card_compo_cha[recipeno][1]
      if $card_compo_cha[recipeno][0] == $card_compo_cha[recipeno][1]
        card_num = 2
        if $game_party.item_number($data_items[$card_compo_cha[recipeno][0]]) < card_num
          result = false
          #p "同じカード足りない"
        end
      else
        card_num = 1
        if $game_party.item_number($data_items[$card_compo_cha[recipeno][0]]) < card_num
          result = false
          #p "違うカード1枚目足りない",$game_party.item_number($data_items[$card_compo_cha[recipeno][0]]),card_num
        end
        if $game_party.item_number($data_items[$card_compo_cha[recipeno][1]]) < card_num
          result = false
          
          #p "違うカード2枚目足りない",$game_party.item_number($data_items[$card_compo_cha[recipeno][1]]),card_num
        end
      end
    end
    
    return result
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
        case $temp_card_compo_recipe_mode
        when 0 #一覧から
          @select_componu = @cursorstate + @put_start

          if chk_card_compo_cha(@select_componu) == true
            #レシピ取得済みかつ、カード足りていた
            Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
            create_result_window
            @yes_no_result = 0
            @window_state = 1
          else
            #カード足りないまたはレシピが解放されていない
            Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          end
          
        when 1 #作りたいカードから
          if @put_arrmax > -1
            Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
            @window_update_flag = true
            @create_cardchano = @card_compo_get_cha_list[@cursorstate + @put_start]
            @window_state = 2
            @backup_cursorstate = @cursorstate #作成したいカードから、レシピに移動した時の一時格納用
            @backup_put_start = @put_start #作成したいカードから、レシピに移動した時の一時格納用
            @cursorstate = 0
            @put_start = 0
            @old_put_start = -1
          else
            #1つも出力対象がない
            Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          end

        end

      elsif @window_state == 1 #合成実施選択(共通)
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        
        case @yes_no_result
        
        when 0 #はい
          #p $card_compo_cha[@select_componu][0],$card_compo_cha[@select_componu][1]
          $card_compo_no = []
          $card_compo_no[0] = nil
          $card_compo_no[1] = $card_compo_cha[@select_componu][0]
          $card_compo_no[2] = $card_compo_cha[@select_componu][1]
          
          $game_party.lose_item ($data_items[$card_compo_cha[@select_componu][0]], 1) #カード減らす
          $game_party.lose_item ($data_items[$card_compo_cha[@select_componu][1]], 1) #カード減らす
          
          $game_switches[1319] = true #レシピから合成を選んだ
          
          #作りたいカードからの場合はこの処理をしないと選択位置がレシピのものになってしまう
          if $temp_card_compo_recipe_mode == 1 && $game_variables[463] == 1
            @cursorstate = @backup_cursorstate #作成したいカードから、レシピに移動した時の一時格納用
            @put_start = @backup_put_start #作成したいカードから、レシピに移動した時の一時格納用
          end
          
          $temp_card_compo_cursorstate = @cursorstate
          $temp_card_compo_put_start = @put_start
          $temp_create_cardchano = @create_cardchano
          Graphics.fadeout(20)
          dispose_result_window
          @window_state = 0

          #レシピの使用回数
          #nil対策初期化
          $card_compo_recipe_run_num[@select_componu] = 0 if $card_compo_recipe_run_num[@select_componu] == nil
          $card_compo_recipe_run_num[@select_componu] += 1
          $scene = Scene_Map.new
        when 1 #いいえ
          @window_state = 0
          dispose_result_window
        end
      elsif @window_state == 2 #作りたいカードからでレシピ一覧画面
        @select_componu = @card_compo_recipe_chalist[@cursorstate + @put_start]
        #p @card_compo_recipe_chalist
        if chk_card_compo_cha(@select_componu) == true
          #レシピ取得済みかつ、カード足りていた
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          create_result_window
          @yes_no_result = 0
          @window_state = 1
        else
          #カード足りないまたはレシピが解放されていない
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
        end
      end
    end
    if Input.trigger?(Input::B)
      @window_update_flag = true

      if @window_state == 0
        #Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
        Graphics.fadeout(20)
        #$game_switches[36] = true #合成をキャンセルしたフラグをON
        $scene = Scene_Map.new
        #$game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
      elsif @window_state == 1
        case $temp_card_compo_recipe_mode
        when 0 #一覧から
          @window_state = 0
          dispose_result_window
        when 1 #作りたいカードから
          @window_state = 2
          dispose_result_window
        end
      elsif @window_state == 2
        #作りたいカードのレシピ一覧から戻った時
        #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        @window_update_flag = true
        @create_cardchano = 0
        @window_state = 0
        @cursorstate = @backup_cursorstate #作成したいカードから、レシピに移動した時の一時格納用
        @put_start = @backup_put_start #作成したいカードから、レシピに移動した時の一時格納用
        @old_put_start = -1
      elsif @window_state == 3
        #@window_state = 1
      end

    end

    if Input.trigger?(Input::X)
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      if @window_state == 0
        #画面を更新するために更新系フラグを初期化
        @window_update_flag = true
        @put_start = 0
        @old_put_start = -1
        @cursorstate = 0
        if $temp_card_compo_recipe_mode == 0
          $temp_card_compo_recipe_mode = 1
        else
          $temp_card_compo_recipe_mode = 0
        end
      end
      #@display_skill_level = -@display_skill_level
    end
    
    if Input.trigger?(Input::L)
      if (@window_state == 0 || @window_state == 2) && @put_arrmax > -1
        @window_update_flag = true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 4 #カーソル移動
      end
    end
    
    if Input.trigger?(Input::R)
      if (@window_state == 0 || @window_state == 2) && @put_arrmax > -1
        @window_update_flag = true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 6 #カーソル移動
      end
    end
    
    if Input.trigger?(Input::DOWN)
      #chk_up = true
      if (@window_state == 0 || @window_state == 2) && @put_arrmax > -1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 2 #カーソル移動
      end
    elsif Input.trigger?(Input::UP)
      if (@window_state == 0 || @window_state == 2) && @put_arrmax > -1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 8 #カーソル移動
      end
    elsif Input.trigger?(Input::RIGHT)
      if (@window_state == 0 || @window_state == 2) && @put_arrmax > -1
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
      if (@window_state == 0 || @window_state == 2) && @put_arrmax > -1
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
  # ● カーソル表示
  #--------------------------------------------------------------------------  
  def output_cursor
    $cursor_blink_count += 1
    picture = Cache.picture("アイコン")
    
    if @result_window == nil 
      rect = set_yoko_cursor_blink
    else
      rect = set_yoko_cursor_blink 0
    end
    
    @recipe_window.contents.blt(Partynox + @cursorstate_side * 288,Partynoy+@cursorstate*Partyy+8,picture,rect)

    if @result_window != nil #カード使用はいいいえ表示
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @result_window.contents.blt(@yes_no_result*80+2,42+146,picture,rect)
    end
    
  end

  #--------------------------------------------------------------------------
  # ● レシピ一覧詳細表示
  #-------------------------------------------------------------------------- 
  def output_recipe_detail recipe_no,putrow

    for y in 0..2
    if $get_card_compo_recipe[recipe_no] == true
    
        #カード名
        case y 
        when 0,1
          mozi = $data_items[$card_compo_cha[recipe_no][y]].name
          output_mozi mozi
          #所持数が0、または同じカードの場合は2枚より少ない
          if $game_party.item_number($data_items[$card_compo_cha[recipe_no][y]]) == 0 ||
            ($card_compo_cha[recipe_no][0] == $card_compo_cha[recipe_no][1]) && $game_party.item_number($data_items[$card_compo_cha[recipe_no][0]]) < 2
            $tec_mozi.change_tone(128,128,128) #灰色
          end
        when 2
          mozi = $data_items[$card_compo_get_cha[recipe_no]].name
          output_mozi mozi
        end
      else
        mozi = "？？？？？？？？？"
        output_mozi mozi
      end
      
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @recipe_window.contents.blt(@cardx[y],Partynoy+(putrow)*Partyy,picture,rect)
      
      #カードのコロン
      mozi = "："
      output_mozi mozi
      
      if $get_card_compo_recipe[recipe_no] == true
        case y 
        when 0,1
          if $game_party.item_number($data_items[$card_compo_cha[recipe_no][y]]) == 0 ||
            ($card_compo_cha[recipe_no][0] == $card_compo_cha[recipe_no][1]) && $game_party.item_number($data_items[$card_compo_cha[recipe_no][0]]) < 2
           
            $tec_mozi.change_tone(128,128,128) #灰色
          end
        end
      end
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @recipe_window.contents.blt(@cardx[y]+144,Partynoy+(putrow)*Partyy,picture,rect)
      
      #カードの所持枚数
      if $get_card_compo_recipe[recipe_no] == true
        case y 
        when 0,1
          mozi = $game_party.item_number($data_items[$card_compo_cha[recipe_no][y]]).to_s
          output_mozi mozi
          if $game_party.item_number($data_items[$card_compo_cha[recipe_no][y]]) == 0 ||
            ($card_compo_cha[recipe_no][0] == $card_compo_cha[recipe_no][1]) && $game_party.item_number($data_items[$card_compo_cha[recipe_no][0]]) < 2
           
            $tec_mozi.change_tone(128,128,128) #灰色
          elsif $game_party.item_number($data_items[$card_compo_cha[recipe_no][y]]) == (get_havemax_card $card_compo_cha[recipe_no][y])
            $tec_mozi.change_tone(255,120,48) #オレンジ
          end
        when 2
          mozi = $game_party.item_number($data_items[$card_compo_get_cha[recipe_no]]).to_s
          output_mozi mozi
          if $game_party.item_number($data_items[$card_compo_get_cha[recipe_no]]) == 0
            
          elsif $game_party.item_number($data_items[$card_compo_get_cha[recipe_no]]) == (get_havemax_card $card_compo_get_cha[recipe_no])
            $tec_mozi.change_tone(255,120,48) #オレンジ
          end
        end
      else
        mozi = "？"
        output_mozi mozi
      end
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @recipe_window.contents.blt(@cardx[y]+160,Partynoy+(putrow)*Partyy,picture,rect)

      #1枚目カードと2枚目の間に×
      case y 
      when 0
        mozi = "＋"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @recipe_window.contents.blt(@cardx[y]+180,Partynoy+(putrow)*Partyy,picture,rect)
      when 1 
        mozi = "＝"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @recipe_window.contents.blt(@cardx[y]+180,Partynoy+(putrow)*Partyy,picture,rect)
      end

      
    end
  end
  
  #--------------------------------------------------------------------------
  # ● レシピ一覧で実際に出来るカードの表示
  #-------------------------------------------------------------------------- 
  def output_card_compo_get_cha_list cardcha_no,putrow
    
    #作成できるカード名
    mozi = $data_items[cardcha_no].name
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @recipe_window.contents.blt(@cardx[0],Partynoy+(putrow)*Partyy,picture,rect)

    #カードのコロン
    mozi = "："
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @recipe_window.contents.blt(@cardx[0]+144,Partynoy+(putrow)*Partyy,picture,rect)
    
    #カードの所持枚数
    mozi = $game_party.item_number($data_items[cardcha_no]).to_s
    output_mozi mozi
    if $game_party.item_number($data_items[cardcha_no]) == 0
      
    elsif $game_party.item_number($data_items[cardcha_no]) == (get_havemax_card cardcha_no)
      #所持数MAXであれば色を変更
      $tec_mozi.change_tone(255,120,48) #オレンジ
    end

    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @recipe_window.contents.blt(@cardx[0]+160,Partynoy+(putrow)*Partyy,picture,rect)


  end
  #--------------------------------------------------------------------------
  # ● 表示できるレシピがゼロだった場合に表示する
  #-------------------------------------------------------------------------- 
  def output_putok_recipezero
    #作成できるカード名
    mozi = "まだ1つもレシピがかいほうされていないぞ！"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @recipe_window.contents.blt(@cardx[0],Partynoy+(0)*Partyy,picture,rect)
  end
  #--------------------------------------------------------------------------
  # ● レシピ一覧表示
  #-------------------------------------------------------------------------- 
  def output_recipe

    case $temp_card_compo_recipe_mode
    
    when 0 #単純な一覧
      mozi = "　ーカードごうせいレシピ(いちらんからせんたく)ー"
    when 1 #作りたいカードから
      mozi = "　ーカードごうせいレシピ(つくりたいカードからせんたく)ー"
    end
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    #@title_window.contents.blt(0 ,Partynoy-32,picture,rect)
    @title_window.contents.blt(0 ,0,picture,rect)
    
    #カーソルを消すために背景色を塗る
    @recipe_window.contents.fill_rect(0+200*0,0,16,6400,@recipe_window.get_back_window_color)
    
    case $temp_card_compo_recipe_mode
    
    when 0 #単純な一覧
      @put_end = @put_start + (@cardput_max - 1)
      
      @put_arrmax = $card_compo_get_cha.size - 1
      putrow = 0
      #無駄な出力をしないようにする
      if @put_start != @old_put_start
        for x in @put_start..@put_end
          output_recipe_detail x,putrow
          
          putrow += 1
        end
        
        @old_put_start = @put_start 
      end 
 
    when 1 #作りたいカードから
      if @window_state == 0
        if @card_compo_get_cha_list.size >= @cardput_max
          #カードの種類が一覧の最高数より多い
          @put_end = @put_start + (@cardput_max - 1)
        else
          #カードの種類が一覧の最高数より少ない
          @put_end =  @card_compo_get_cha_list.size - 1
        end

        @put_arrmax = @card_compo_get_cha_list.size - 1
        
        putrow = 0
        #無駄な出力をしないようにする
        if @put_start != @old_put_start
          for x in @put_start..@put_end
            output_card_compo_get_cha_list @card_compo_get_cha_list[x],putrow
            
            putrow += 1
          end
          
          @old_put_start = @put_start 
        end 
        #出力できる内容が無い場合は特殊文字を表示
        if @put_arrmax == -1
          output_putok_recipezero
        end
    
      elsif @window_state == 2
        putrow = 0
        #無駄な出力をしないようにする
        if @put_start != @old_put_start
          @get_card_compo_recipe_chalist = []

          for x in @put_start..@get_card_compo_recipe_nolist.size - 1
            #作成したいカードが出来るレシピのみを一覧に加える
            if @create_cardchano == $card_compo_get_cha[@get_card_compo_recipe_nolist[x]]
              
              @card_compo_recipe_chalist[putrow] = @get_card_compo_recipe_nolist[x]
              output_recipe_detail @get_card_compo_recipe_nolist[x],putrow
              putrow += 1
            end
          end
          
          if putrow - 1 >= @cardput_max
            #カードの種類が一覧の最高数より多い
            @put_end = @put_start + (@cardput_max - 1)
          else
            #カードの種類が一覧の最高数より少ない
            @put_end =  putrow - 1
          end
          
          @put_arrmax = putrow - 1
          
        end

      end
      
    end

    #一覧No
    smozi = "　" * ((@put_arrmax+1).to_s.size - (@cursorstate + @put_start + 1).to_s.size)
    if @put_arrmax > -1
      smozi += (@cursorstate + @put_start + 1).to_s
    else
      smozi += (0).to_s
    end
    mozi = "NO：" + smozi + "／" + (@put_arrmax+1).to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @title_window.contents.blt(640 - (16 * mozi.split(//u).size + 14 + 32) ,0,picture,rect)

  end

  #--------------------------------------------------------------------------
  # ● 作成可能な合成リストの取得
  #--------------------------------------------------------------------------
  def create_get_card_compo_recipe_list
    
    listcount = 0
    @get_card_compo_recipe_nolist = []
    @card_compo_get_cha_list = [] 
    temp_card_compo_get_cha_list = [] 
    for x in 0..$get_card_compo_recipe.size - 1
      if $get_card_compo_recipe[x] == true
        @get_card_compo_recipe_nolist[listcount] = x
        temp_card_compo_get_cha_list[listcount] = $card_compo_get_cha[x]
        @card_compo_get_cha_list_order_id[listcount] = $data_items[$card_compo_get_cha[x]].speed
        listcount += 1
      end
    end
    
    #p @get_card_compo_recipe_nolist,@card_compo_get_cha_list
    
    #p @get_card_compo_recipe_nolist,@card_compo_get_cha_list
    
    #並び順をカードの表示順に変更
    tempcount = 0
    for x in 1..$data_items.size-1
      for z in 0..temp_card_compo_get_cha_list.size - 1
        
        if x == @card_compo_get_cha_list_order_id[z]
          @card_compo_get_cha_list[tempcount] = temp_card_compo_get_cha_list[z]
          tempcount += 1
        end
      end
    end
    
    #重複削除
    @card_compo_get_cha_list = @card_compo_get_cha_list.uniq
  end
  #--------------------------------------------------------------------------
  # ● カーソル移動
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def move_cursor n
    
    case n
    
    when 2 #下
      
    
      if @window_state == 0 || @window_state == 2

        @cursorstate +=1
        #画面の一番下で下を押した？
        if @put_end < (@put_start + @cursorstate)
          
          if (@put_start + @cursorstate) <= @put_arrmax
            #一番下で下を押したかつ、まだ次の合成がある
            @put_start += 1
            @cursorstate -=1
          else
            #もうないので最初に戻る
            @put_start = 0
            @cursorstate = 0
          end
        end
      end

    when 8 #上

      if @window_state == 0 || @window_state == 2
        @cursorstate -=1

        #画面の一番下で下を押した？
        if 0 <= (@put_start + @cursorstate)
          if (@put_start + @cursorstate) < @put_start
            #一番下で下を押したかつ、まだ次の合成がある
            @put_start -= 1
            @cursorstate +=1
          end
        else
          #もうないので最後に戻る
          @put_start = (@put_arrmax) - (@cardput_max - 1)
          @put_start = 0 if @put_start < 0
          if @put_arrmax >= @cardput_max
            #カードの種類が一覧の最高数より多い
            @cursorstate = (@cardput_max - 1)
          else
            #カードの種類が一覧の最高数より少ない
            @cursorstate = @put_arrmax
            #@put_start = 0
          end
        end
      end

    when 6 #右
      if @window_state == 0 || @window_state == 2
        
        temp_cardput_max = @cardput_max
        if @put_arrmax < @cardput_max
          temp_cardput_max = @put_arrmax
        end
        @put_start += temp_cardput_max
        if @put_start == @put_arrmax + 1 #($card_compo_get_cha.size)
          @put_start = @put_start -= temp_cardput_max
          @cursorstate = (temp_cardput_max - 1)
          
        elsif ((@put_arrmax) - temp_cardput_max) < @put_start
          
          if @put_arrmax < @cardput_max
            @put_start = 0
            @cursorstate = @put_arrmax
          else
            @put_start = (@put_arrmax) - (temp_cardput_max - 1)
          end
        end
      end
    when 4 #左
      if @window_state == 0 || @window_state == 2

        @put_start -= @cardput_max
        if (@put_start + @cursorstate) < 0
          @put_start = 0
          @cursorstate = 0
        elsif (@put_start + @cursorstate) < @cardput_max - 1
          @cursorstate = @cursorstate + @put_start
          @put_start = 0
        else

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