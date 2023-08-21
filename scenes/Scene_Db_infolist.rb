#==============================================================================
# ■ Scene_Db_infolist
#------------------------------------------------------------------------------
# 　説明の一覧
#==============================================================================
class Scene_Db_infolist < Scene_Base
  include Share
  include Icon
  Title_win_sizex = 640
  Title_win_sizey = 56
  Infolist_win_sizex = Title_win_sizex         #パーティーウインドウサイズX
  Infolist_win_sizey = 480 - Title_win_sizey         #パーティーウインドウサイズY
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
    
    @window_state = 0         #ウインドウ状態(並び替え時のみ使用) 0:未選択 1:キャラ選択
    @cursorstate = 0             #カーソル位置

    @cursorstate_side = 0         #カーソル位置横

    @select_componu = 0 #選択している合成パターン
    @cardput_max = 14 #1ページの最大出力数
    @put_start = 0 #出力開始位置
    @put_end = @cardput_max - 1 #出力終了位置
    @old_put_start = -1
    @yes_no_result = 0 #はい、いいえ結果
    create_window
    @window_update_flag = true
    @s_up_cursor = Sprite.new
    @s_down_cursor = Sprite.new
    @put_infolist = []
    create_put_infolist
    if $temp_card_compo_cursorstate != nil
      @cursorstate = $temp_card_compo_cursorstate
      @put_start = $temp_card_compo_put_start 
    end

    set_up_down_cursor
    pre_update
    
    color = set_skn_color 0
    @main_window.contents.fill_rect(0,0,656,496,color)
    @main_window.update
    
    option_msg = ""
    msg_height = 25
    option_msg = "どの機能の説明を　確認しますか？(キャンセルでも抜けれます)"
    @title_window.contents.draw_text(0,msg_height*0, 630, msg_height, option_msg)


    #Graphics.fadein(5)

    #run_common_event 262
  end

  #--------------------------------------------------------------------------
  # ● 出力する説明リストの作成
  #-------------------------------------------------------------------------- 
  def create_put_infolist
    $infolist = ["時の間","スキル","Ｓコンボ","必殺技熟練度","お助けカード","お気に入りキャラ設定","作戦","カード合成","バトルアリーナ","１ターンアタックチャレンジ"]
    
    $infolist << "衣装チェンジ" if $game_switches[502] == true #バイオ戦士撃破
    $infolist << "時の間のバトルアリーナと各エリアのススメ" if $game_switches[1309] == true || $game_switches[522] == true #Z2ナメック星人機能説明とあったまたはザーボンを撃破した
    $infolist << "スキル「地球育ちのサイヤ人」と「武泰斗の教え」" if $game_switches[1313] == true || $game_variables[40] >= 2 #Z2ナメック星人スキル説明とあったまたはZ2クリア後
    $infolist << "Ｓコンボの追加ヒント" if $game_switches[1307] == true || $game_switches[521] == true #Z3ウミガメとあったまたはクラズを撃破した
    $infolist << "スキル「フリー」" if $game_switches[1311] == true || $game_switches[545] == true #Z3ヤジロベーとあったまたはガーリックを撃破した
    $infolist << "Ｓコンボ発動優先度" if $game_switches[1308] == true || $game_switches[431] == true #Z3ウーロンとあったまたはZ3編クリアした
    $infolist << "カード「筋斗雲」" if $game_switches[565] == true #Z4 悟空と悟飯の修行が終わった(ナメック星編始まった)
    $infolist << "終了する"
    for x in 0..$infolist.size - 1
      @put_infolist << $infolist[x]
    end
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_window
    @Infolist_window.dispose
    @Infolist_window = nil
    @title_window.dispose
    @title_window = nil
    @main_window.dispose
    @main_window = nil
  end 
  
  #-----------------------------------------------------------------------
  # ● ウインドウ内容クリア---
  #--------------------------------------------------------------------------    
  def window_contents_clear
    @Infolist_window.contents.clear
    #@title_window.contents.clear
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
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    #Graphics.fadeout(0)
    @main_window = Window_Base.new(-16,-16,672,512)
    @main_window.opacity=0
    @main_window.back_opacity=0
    @Infolist_window = Window_Base.new((640 - Infolist_win_sizex) / 2,Title_win_sizey ,Infolist_win_sizex,Infolist_win_sizey)
    @Infolist_window.opacity=255
    @Infolist_window.back_opacity=255
    @Infolist_window.contents.font.color.set( 0, 0, 0)
    
    @title_window = Window_Base.new((640 - Title_win_sizex) / 2,0 ,Title_win_sizex,Title_win_sizey)
    @title_window.opacity=255
    @title_window.back_opacity=255
    @title_window.contents.font.color.set( 0, 0, 0)
    #Graphics.fadein(10)
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
    @s_up_cursor.x = Infolist_win_sizex - Infolist_win_sizex/2 - 8
    @s_up_cursor.y = Title_win_sizey+16
    @s_up_cursor.z = 255
    @s_up_cursor.angle = 91
    @s_up_cursor.visible = false
    
    #Sコンボ下カーソル
    # スプライトのビットマップに画像を設定
    @s_down_cursor.bitmap = Cache.picture("アイコン")
    @s_down_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @s_down_cursor.x = Infolist_win_sizex - Infolist_win_sizex/2 + 8
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
      
      if @window_state == 0
        
        if @put_start != @old_put_start
          window_contents_clear
        end
        output_infolist
        
        @Infolist_window.update
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
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        $runinfolistmsg = @put_infolist[@put_start+@cursorstate] #+ @put_start
        $scene = Scene_Map.new
        
      elsif @window_state == 1
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        
      end
    end
    if Input.trigger?(Input::B)
      @window_update_flag = true

      if @window_state == 0
        #Audio.se_play("Audio/se/" + "Z1 出る")# 効果音を再生する
        #Graphics.fadeout(20)
        #$game_switches[36] = true #合成をキャンセルしたフラグをON
        $runinfolistmsg = @put_infolist[@put_infolist.size-1]
        $scene = Scene_Map.new
        #$game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動
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
      
    end
    
    if Input.trigger?(Input::R)
      
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
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 6 #カーソル移動
      elsif @window_state == 1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する

      end
    elsif Input.trigger?(Input::LEFT)
      if @window_state == 0
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 4 #カーソル移動
      elsif @window_state == 1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
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
    
    @Infolist_window.contents.blt(Partynox + @cursorstate_side * 288,@cursorstate*Partyy+6,picture,rect)

    if @result_window != nil #カード使用はいいいえ表示
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @result_window.contents.blt(@yes_no_result*80+2,42+146,picture,rect)
    end
    
  end
 
  #--------------------------------------------------------------------------
  # ● 説明一覧表示
  #-------------------------------------------------------------------------- 
  def output_infolist

    #カーソルを消すために背景色を塗る
    @Infolist_window.contents.fill_rect(0+200*0,0,16,640,@Infolist_window.get_back_window_color)

    puty = 0
    putx = 18
    
    #@put_start = 0
    #@put_end = 0
    #@put_arrmax = 0
    
    if @cardput_max < @put_infolist.size
      @put_arrmax = @put_infolist.size - 1
      @put_end = @put_start + (@cardput_max - 1)
    else
      @put_arrmax = @put_infolist.size - 1
      @put_end = @put_infolist.size - 1
    end
    
    putrow = 0
    
    if @put_start != @old_put_start
      for x in @put_start..@put_end
        option_msg = ""
        
        #終了するのみNoをつけないため
        if x != @put_infolist.size-1
          option_msg = "No"
          option_msg += " " * (2 - (x + 1).to_s.size)
          #p ((x + 1).to_s).encode("utf-8", "sjis") #,((x + 1).to_s).tr('0-9', '０-９').encoding
          option_msg += ((x + 1).to_s)#.tr('0-9', '０-９')
          option_msg += ":"
        end
        option_msg += @put_infolist[x]
        @Infolist_window.contents.draw_text(putx,Partyy*putrow, 630, Partyy, option_msg)
        putrow += 1
      end
      @old_put_start = @put_start
    end
    #
  end

  #--------------------------------------------------------------------------
  # ● カーソル移動
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def move_cursor n
    
    case n
    
    when 2 #下
      
    
      if @window_state == 0

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

      if @window_state == 0
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
      if @window_state == 0
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
      if @window_state == 0
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