#==============================================================================
# ■ Scene_Db_New_game_plus
#------------------------------------------------------------------------------
# 　強くてニューゲーム強くてニューゲーム
#==============================================================================
class Scene_Db_New_game_plus < Scene_Base
  include Icon
  include Share
  Option_win_sizex = 640         #カード一覧ウインドウサイズX
  #Option_win_sizey = 360         #カード一覧ウインドウサイズY
  Option_win_sizey = 374         #カード一覧ウインドウサイズY
  Explanation_win_sizex = 640       #カード説明ウインドウサイズX
  #Explanation_win_sizey = 120       #カード説明ウインドウサイズY
  Explanation_win_sizey = 106       #カード説明ウインドウサイズY
  Explanation_lbx = 16              #カード説明表示基準X
  Explanation_lby = 0               #カード説明表示基準Y
  Confirm_win_sizex = 360
  Confirm_win_sizey = 86
  Confirm_lbx = (640-Confirm_win_sizex) / 2 #確認ウインドウ位置X
  Confirm_lby = (480-Confirm_win_sizey) / 2 #確認ウインドウ位置Y
  
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :op_flag                 # 引継ぎ有無
  attr_reader   :option_no               # 引継ぎ種類の並び
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     call_state : どのプログラムから呼ばれたか 1:戦闘 2:マップ 3:ステータス
  #--------------------------------------------------------------------------
  def initialize
    @battle_card_cursor_state = 0     #戦闘カードのカーソル位置
    @window_state = 0         #ウインドウ状態 0:カード選択 1:バトルカード選択
    @cursorstatex = 0
    @cursorstatey = 0
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    @confirm_cursor_state = 0                #確認カーソル
    @cursor_state = 0                #カーソル
    @option_line_height = 28          #改行の高さ
    @op_status = "op_status"  #能力
    @op_skill = "op_skill"    #スキル
    @op_zp = "op_zp"          #ZP
    @op_dress = "op_dress"    #ドレス(衣装替え)
    @op_card = "op_card"      #カード
    @op_tec = "op_tec"        #必殺技
    @op_skill_lv = "op_skill_lv" #熟練度
    @op_scombo = "op_scombo"  #Sコンボ
    @op_btlhis = "op_btlhis"  #闘いの記録
    @op_enehis = "op_enehis"  #敵の情報
    @op_bgm = "op_bgm"        #BGM
    @op_end = "op_end"        #完了
    
    @option_no=[@op_status,@op_skill,@op_dress,@op_card,@op_tec,@op_skill_lv,@op_scombo,@op_btlhis,@op_enehis,@op_bgm,@op_end] #オプションの種類
    #@option_no=[@op_status,@op_skill,@op_zp,@op_dress,@op_card,@op_tec,@op_skill_lv,@op_scombo,@op_btlhis,@op_enehis,@op_bgm,@op_end] #オプションの種類
    @option_Item_Num = @option_no.size
    
    @op_flag = []
    for x in 0..@option_no.size-1
      @op_flag[x] = 1
    end
    @win_state = 0 #0：引継ぎ内容選択 1:引継ぎ設定完了選択 9:タイトルに戻る
    @put_page = 0 #出力ページ
    @put_option_num = [11,0] #1ページの出力数
    super
    #シナリオ進行度によってファイル名の頭文字を変える
    #chk_scenario_progress
    @window_update_flag = true
    create_window
    #@s_up_cursor = Sprite.new
    #@s_down_cursor = Sprite.new
    #set_up_down_cursor
    pre_update
    set_bgm
    
    Graphics.fadein(5)
  end
  
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    #dispose_sprite
    dispose_window
    dispose_confirm_window
  end
  
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------    
  def pre_update
    
    if @window_update_flag == true
      window_contents_clear
      output_option
      output_option_message
      output_confirm if @confirm_window != nil
      @window_update_flag = false
    end
    output_cursor
  end
  
  #--------------------------------------------------------------------------
  # ● フレーム更新
  # 戻り値 "1" ：(メニュー画面を抜ける)
  #--------------------------------------------------------------------------   
  def update
    super
    #pre_update
    #カード所持数が0のときはキャンセル以外処理しない
    if Input.trigger?(Input::B)
      case @win_state
      
      when 0
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)
        @win_state = 9
        create_confirm_window
        @window_update_flag = true
        
      when 1,9
        #Audio.se_play("Audio/SE/" + $BGM_CursorOn)
        dispose_confirm_window
        @win_state = 0
      end
    end  
    
    if Input.trigger?(Input::C)
      case @win_state
      
      when 0
        
        case @option_no[@cursor_state]
        
        when @op_end
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)
          @win_state = 1
          create_confirm_window
          @window_update_flag = true
        end
      when 1 #引継ぎ設定確認
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)
        case @confirm_cursor_state
        when 0 #はい
          #confirm_player_location
          #Sound.play_decision
          set_start_val
          set_start_val 3 #MAXLVセット
          $game_party.setup_starting_members            # 初期パーティ
          $game_map.setup($data_system.start_map_id)    # 初期位置のマップ
          $game_player.moveto($data_system.start_x, $data_system.start_y)
          $game_player.refresh
          
          #変数DBの初期化
          new_game_plus_db_var_refresh
          #普通に遊ぶ場合こちらを有効に
          $scene = Scene_Map.new

          RPG::BGM.fade(1500)
          Graphics.fadeout(60)
          Graphics.wait(40)
          RPG::BGM.stop
          
          $game_variables[266] = 150
          #for x in 1..$zp.size
          #  $zp[x] = 0 if $zp[x] == nil
          #  $runzp[x] = 0 if $runzp[x] == nil
          #  
          #  $zp[x] += $runzp[x] * $game_variables[266]
          #end
            
          $game_map.autoplay
        when 1 #いいえ
          dispose_confirm_window
          @win_state = 0
        end
      when 9 #タイトルに戻る
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)
        case @confirm_cursor_state
        when 0 #はい
          $scene = Scene_Title.new
        when 1 #いいえ
          dispose_confirm_window
          @win_state = 0
        end
      end
    end

    if Input.trigger?(Input::DOWN)
      #if @window_state == 0
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 2
      #end
    end
    if Input.trigger?(Input::UP)
      #if @window_state == 0
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        move_cursor 8
      #end
    end
    if Input.trigger?(Input::RIGHT)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      
      case @win_state 
      
      when 0 #引継ぎ内容選択
        @op_flag[@cursor_state] = -@op_flag[@cursor_state]
      when 1,9 #引継ぎ内容確定、タイトルに戻る
        if @confirm_cursor_state == 0
          @confirm_cursor_state = 1
        else
          @confirm_cursor_state = 0
        end
      end

    end
    if Input.trigger?(Input::LEFT)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      case @win_state 
      
      when 0 #引継ぎ内容選択
        @op_flag[@cursor_state] = -@op_flag[@cursor_state]
      when 1,9 #引継ぎ内容確定、タイトルに戻る
        if @confirm_cursor_state == 0
          @confirm_cursor_state = 1
        else
          @confirm_cursor_state = 0
        end
      end
    end

     @window_update_flag = true if Input.dir8 != 0 #何かカーソルを押したら画面を更新フラグをON
     pre_update
  end

  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_window
    @option_window.dispose
    @option_window = nil
    @explanation_window.dispose
    @explanation_window = nil
  end 
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def window_contents_clear
    @option_window.contents.clear
    @explanation_window.contents.clear
    @confirm_window.contents.clear if @confirm_window != nil
  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    @option_window = Window_Base.new(0,Explanation_win_sizey,Option_win_sizex,Option_win_sizey)
    @option_window.opacity=255
    @option_window.back_opacity=255
    @option_window.contents.font.color.set( 0, 0, 0)
    #@option_window.contents.font.shadow = false
    #@option_window.contents.font.bold = true
    #@option_window.contents.font.name = ["ＭＳ ゴシック"]
    #@option_window.contents.font.size = 17
    @explanation_window = Window_Base.new(0,0,Explanation_win_sizex,Explanation_win_sizey)
    @explanation_window.opacity=255
    @explanation_window.back_opacity=255
    @explanation_window.contents.font.color.set( 0, 0, 0)
    #@option_window.contents.font.shadow = false
    #@option_window.contents.font.bold = true
    #@option_window.contents.font.name = ["ＭＳ ゴシック"]
    #@option_window.contents.font.size = 17
  end
  #--------------------------------------------------------------------------
  # ● 確認ウインドウの解放
  #--------------------------------------------------------------------------   
  def dispose_confirm_window
    @confirm_window.dispose
    @confirm_window = nil
  end
  #--------------------------------------------------------------------------
  # ● 確認ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_confirm_window

    @confirm_window = Window_Base.new(Confirm_lbx,Confirm_lby,Confirm_win_sizex,Confirm_win_sizey)
    @confirm_window.opacity=255
    @confirm_window.back_opacity=255
    @confirm_window.contents.font.color.set( 0, 0, 0)
    #@option_window.contents.font.shadow = false
    #@option_window.contents.font.bold = true
    #@option_window.contents.font.name = ["ＭＳ ゴシック"]
    #@option_window.contents.font.size = 17
    
    
  end
  #--------------------------------------------------------------------------
  # ● 確認内容表示
  #--------------------------------------------------------------------------
  def output_confirm
    option_msg = ""
    msg_height = 25
    msg_height_s = 0
    
    if @win_state == 9
      option_msg = "タイトル画面に戻りますか？"
    elsif @win_state == 1
      option_msg = "この内容でゲームを始めますか？"
    else
      
    end
    @confirm_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)

    option_msg = "　はい　　　　いいえ"
    @confirm_window.contents.draw_text(0,msg_height_s + msg_height*1, 630, msg_height, option_msg)
  end
  #--------------------------------------------------------------------------
  # ● オプション表示
  #--------------------------------------------------------------------------
  def output_option
    # オプション表示
    i = 0
    option_txt = ""
    option_flag_txt = "　　　　　　"
    puts = 0
    pute = 0
    if @put_page == 0
      pute = @put_option_num[@put_page]
    else
      puts = @put_option_num[@put_page - 1] + 1
      pute = @option_no.size
    end
    
    for i in puts..pute
      
      #フォントの色をもとに戻す
      @option_window.contents.font.color.set( 0, 0, 0)
      
      case @option_no[i]
      
      when @op_status
        option_txt = "ステータス："
      when @op_skill
        option_txt = "スキル　　："
      when @op_zp
        option_txt = "ＺＰ　　　："
      when @op_dress
        option_txt = "衣装替え　："
      when @op_card
        option_txt = "カード　　："
      when @op_tec
        option_txt = "必殺技　　："
      when @op_skill_lv
        option_txt = "熟練度　　："
      when @op_scombo
        option_txt = "Ｓコンボ　："
      when @op_btlhis
        option_txt = "戦いの記録："
      when @op_enehis
        option_txt = "敵の情報　："
      when @op_bgm
        option_txt = "ＢＧＭ　　："
      when @op_end
        option_txt = "設定完了"
      end
      
      if option_txt != "" && @option_no[i] != @op_btl_bgm && @option_no[i] != @op_meu_bgm && @option_no[i] != @op_btl_ready_bgm
        #@option_window.contents.draw_text(16,@option_line_height.to_i*i, 640, @option_line_height, option_txt.to_s)
        puttxt = 0 #テキスト出力位置調整
        if @put_page != 0
          puttxt = @put_option_num[@put_page-1] + 1
        end
        @option_window.contents.draw_text(16,@option_line_height.to_i*(i - puttxt), 640, @option_line_height, option_txt.to_s)
      end
      
      if @option_no[i] != @op_end
        if @op_flag[i] == 1
          option_flag_txt += "引き継ぐ"
          @option_window.contents.font.color.set( 0, 0, 0)
        else
          option_flag_txt += "引き継がない"
          @option_window.contents.font.color.set( 128, 128, 128)
        end
      end
      
      if i != pute
        @option_window.contents.draw_text(16,@option_line_height.to_i*(i - puttxt), 640, @option_line_height, option_flag_txt.to_s)
      end
      option_txt = ""
      option_flag_txt = "　　　　　　"
      i += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------
  def output_cursor
    
    # メニューカーソル表示
    $cursor_blink_count += 1
    picture = Cache.picture("アイコン")
    rect = set_yoko_cursor_blink
    
    case @win_state
    
    when 0

      if @put_page == 0
        @option_window.contents.blt(0,@cursor_state*@option_line_height+4,picture,rect)
      else
        @option_window.contents.blt(0,(@cursor_state-(@put_option_num[@put_page-1] + 1))*@option_line_height+4,picture,rect)
      end
    when 1,9 #タイトルに戻る
      #if @confirm_window != nil
      @confirm_window.contents.blt(@confirm_cursor_state * 110,28,picture,rect)
      #end
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソル移動
  #引数:n (下:2 上:8 右:6 左:4 0:変更なし)
  #--------------------------------------------------------------------------
  def move_cursor n
    # メニューカーソル表示
    
    case @win_state
    
    when 0 #引継ぎ内容選択
      case n
      
      when 2
        if @cursor_state != @option_Item_Num - 1 
          @cursor_state += 1
        else
          @cursor_state = 0
        end
      when 8
        if @cursor_state != 0
          @cursor_state -= 1
        else
          @cursor_state = @option_Item_Num - 1
        end
      when 6
        #@op_flag[@cursor_state] = -@op_flag[@cursor_state]
      when 4
        #@op_flag[@cursor_state] = -@op_flag[@cursor_state] 
      end
    when 1,9 #引継ぎ内容確定、タイトル画面に戻る

    end
      
    #if @cursor_state <= @put_option_num[0]
    #  @put_page = 0
    #  @s_up_cursor.visible = false
    #  @s_down_cursor.visible = true
    #else
    #  @put_page = 1
    #  @s_up_cursor.visible = true
    #  @s_down_cursor.visible = false
    #end
  end
  #--------------------------------------------------------------------------
  # ● オプションメッセージ
  #-------------------------------------------------------------------------- 
  def output_option_message
    
    option_msg = ""
    msg_height = 25
    msg_height_s = 25
    
    option_msg = "引き継ぐ内容を選択してください"
    @explanation_window.contents.draw_text(0,0, 630, msg_height, option_msg)
    
    
    case @option_no[@cursor_state]
    
    
    when @op_status #能力
      option_msg = "各キャラクターのレベルと経験値を引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
      option_msg = "※引き継がない場合、使用したZPは未使用状態に戻ります"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*1, 630, msg_height, option_msg)
      #option_msg = "※決定ボタンでＢＧＭを再生します"
      #@explanation_window.contents.draw_text(0,msg_height_s + msg_height*1, 630, msg_height, option_msg) 
    when @op_skill #スキル
      option_msg = "取得したスキルとCAPを引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    when @op_zp #ZP
      option_msg = "未使用分のZPを引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    when @op_dress #ドレス(衣装替え)
      option_msg = "取得した衣装を引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    when @op_card #カード
      option_msg = "未使用のカードと各ランクの所持数を引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    when @op_tec #必殺技
      option_msg = "取得した閃き技を引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    when @op_skill_lv #熟練度
      option_msg = "必殺技の熟練度を引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    when @op_scombo #Sコンボ
      option_msg = "取得したSコンボを引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    when @op_btlhis #闘いの記録
      option_msg = "戦いの記録とバトルアリーナの状態を引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    when @op_enehis #敵の情報
      option_msg = "敵の情報の状態を引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    when @op_bgm #BGM
      option_msg = "BGMの取得状態を引き継ぎます"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    when @op_end #完了
      option_msg = "設定を完了します"
      @explanation_window.contents.draw_text(0,msg_height_s + msg_height*0, 630, msg_height, option_msg)
    end
      
  end
  #--------------------------------------------------------------------------
  # ● メニュー再生
  #--------------------------------------------------------------------------    
  def set_bgm
      #set_menu_bgm_name true
      Audio.bgm_play("Audio/BGM/" + "DB1 イベント1")

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
    @s_up_cursor.x = Explanation_win_sizex/2 - 8
    @s_up_cursor.y = Explanation_win_sizey+16#Status_win_sizey+16+32
    @s_up_cursor.z = 255
    @s_up_cursor.angle = 91
    @s_up_cursor.visible = false
    
    #Sコンボ下カーソル
    # スプライトのビットマップに画像を設定
    @s_down_cursor.bitmap = Cache.picture("アイコン")
    @s_down_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @s_down_cursor.x = Explanation_win_sizex/2 + 8
    @s_down_cursor.y = 480-16
    @s_down_cursor.z = 255
    @s_down_cursor.angle = 269
    @s_down_cursor.visible = true

  end
  
end