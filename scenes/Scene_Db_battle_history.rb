#==============================================================================
# ■ Scene_Db_battle_history
#------------------------------------------------------------------------------
# 　カード画面表示
#==============================================================================
class Scene_Db_battle_history < Scene_Base
  include Icon
  include Share
  Option_win_sizex = 640         #カード一覧ウインドウサイズX
  Option_win_sizey = 480-56         #カード一覧ウインドウサイズY
  Explanation_win_sizex = 640       #カード説明ウインドウサイズX
  Explanation_win_sizey = 56       #カード説明ウインドウサイズY
  Explanation_lbx = 16              #カード説明表示基準X
  Explanation_lby = 0               #カード説明表示基準Y
  TECPUT_NUM = 5 #必殺技出力数
  SCOMBOPUT_NUM = 5 #Sコンボ出力数 
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     call_state : どのプログラムから呼ばれたか 1:戦闘 2:マップ 3:ステータス
  #--------------------------------------------------------------------------
  def initialize
    @battle_card_cursor_state = 0     #戦闘カードのカーソル位置
    @window_state = 0         #ウインドウ状態 0:カード選択 1:バトルカード選択
    #set_bgm
    @cursorstatex = 0
    @cursorstatey = 0
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    @cursor_state = 0                #カーソル
    @option_line_height = 24          #改行の高さ
    @option_no=["play_time","btl_win_count","ene_dead_count","cha_max_damage","ene_max_damage","idou_count","yadomas_count","tremas_count","cardmas_count","get_gold","put_gold","buy_card","sell_card","ace_cha","ace_card","ace_tec","ace_scombo"] #オプションの種類
    @option_Item_Num = @option_no.size
    #@total_sec = Graphics.frame_count / Graphics.frame_rate
    if Graphics.frame_rate == 60
      @total_sec = Graphics.frame_count / Graphics.frame_rate
    else
      @total_sec = Graphics.frame_count / Graphics.frame_rate * 2
    end
    @put_page = 1
    @put_page_max = 2
    @s_up_cursor = Sprite.new
    @s_down_cursor = Sprite.new
    set_up_down_cursor
    super
    #カード数調整 最大値にあわせる
    set_max_item_card
    @window_update_flag = true
    chk_battle_bgm_on
    chk_menu_bgm_on
    create_window
    pre_update
    Graphics.fadein(5)
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
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_sprite
    dispose_window
    #$game_variables[41]=41
    #$game_player.reserve_transfer(7, 0, 0, 0) # 場所移動
  end
  
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------    
  def pre_update
    
    if @window_update_flag == true
      window_contents_clear
      output_option
      output_option_message
      output_option_up_down_cursor
      @window_update_flag = false
    end
    #output_cursor
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
    @s_down_cursor.visible = false

  end
  
  #--------------------------------------------------------------------------
  # ● 上下カーソルの表示非表示切り替え
  #-------------------------------------------------------------------------- 
  def output_option_up_down_cursor
    
    #下カーソルの表示
    if @put_page < @put_page_max
      @s_down_cursor.visible = true
    else
      @s_down_cursor.visible = false
    end
    
    #上カーソルの表示
    if @put_page > 1
      @s_up_cursor.visible = true
    else
      @s_up_cursor.visible = false
    end
    
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  # 戻り値 "1" ：(メニュー画面を抜ける)
  #--------------------------------------------------------------------------   
  def update
    super
    pre_update
    
    if Input.trigger?(Input::DOWN)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      @window_update_flag = true
      
      @put_page += 1
      
      if @put_page > @put_page_max
        @put_page = 1
      end

    end
    if Input.trigger?(Input::UP)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      @window_update_flag = true
      @put_page -= 1
      
      if @put_page < 1
        @put_page = @put_page_max
      end
    end
    if Input.trigger?(Input::RIGHT)

    end
    if Input.trigger?(Input::LEFT)

    end
    if Input.trigger?(Input::B)
      if @window_state == 0
        Audio.se_stop
        Graphics.fadeout(5)
        #Audio.bgm_play("Audio/BGM/" + $map_bgm)    # 効果音を再生する
        $scene = Scene_Map.new
      end
        
    end
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_window
    @option_window.dispose
    @option_window = nil
    @option_back_window.dispose
    @option_back_window = nil
    @explanation_window.dispose
    @explanation_window = nil
  end 
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def window_contents_clear
    @option_window.contents.clear
    @explanation_window.contents.clear
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    @option_back_window = Window_Base.new(0,Explanation_win_sizey,Option_win_sizex,Option_win_sizey)
    @option_window = Window_Base.new(0,Explanation_win_sizey,Option_win_sizex,Option_win_sizey)
    #@option_window.opacity=255
    @option_window.opacity=0
    #@option_window.back_opacity=255
    @option_window.back_opacity=0
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
  # ● オプション表示
  #--------------------------------------------------------------------------
  def output_option
    # オプション表示
    i = 0
    option_txt = ""
    put_line = 0
    
    
    for i in 0..@option_no.size
      put_run = false
      put_line_add = 1
      case @option_no[i]
      
        when "play_time"
          if @put_page == 1
            put_run = true
            option_txt = "プレイ時間　　　："
            hour = @total_sec / 60 / 60
            min = @total_sec / 60 % 60
            sec = @total_sec % 60
            option_txt += sprintf("%02d:%02d:%02d", hour, min, sec)
          end
        when "btl_win_count"
          if @put_page == 1
            put_run = true
            option_txt = "戦闘勝利回数　　："
            option_txt += $game_variables[202].to_s
          end
        when "ene_dead_count"
          if @put_page == 1
            put_run = true
            option_txt = "撃破数　　　　　："
            #p $cha_defeat_num
          
            total = 0
            for x in 0..$cha_defeat_num.size - 1
              $cha_defeat_num[x] = 0 if $cha_defeat_num[x] == nil
            end
            #p $cha_defeat_num
            $cha_defeat_num.each do |y|
              total = total.to_i + y.to_i
            end
            option_txt += total.to_s
          end
        when "idou_count"
          if @put_page == 1
            put_run = true
            option_txt = "移動量　　　　　："
            option_txt += $game_variables[218].to_s+ "マス"
          end
        when "yadomas_count"
          if @put_page == 1
            put_run = true
            option_txt = "宿マス回数　　　："
            option_txt += $game_variables[219].to_s + "回"
          end
        when "tremas_count"
          if @put_page == 1
            put_run = true
            option_txt = "修行マス回数　　："
            option_txt += $game_variables[222].to_s + "回"
          end
        when "cardmas_count"
          if @put_page == 1
            put_run = true
            option_txt = "カードマス回数　："
            option_txt += $game_variables[223].to_s + "回"
          end
        when "buy_card"
          if @put_page == 1
            put_run = true
            option_txt = "カード購入回数　："
            option_txt += $game_variables[220].to_s + "回"
          end
        when "sell_card"
          if @put_page == 1
            put_run = true
            option_txt = "カード売却回数　："
            option_txt += $game_variables[221].to_s + "回"
          end
        when "cha_max_damage"
          if @put_page == 1
            put_run = true
            option_txt = "味方最大ダメージ："
            #option_txt += $game_actors[$game_variables[204]].name + " が " + $data_enemies[$game_variables[214]].name + " に " + $game_variables[203].to_s + "ダメージ" if $game_variables[204] != 0  
            option_txt += $game_actors[$game_variables[204]].name + " が " + $data_enemies[$game_variables[214]].name + " に " + $game_variables[203].to_s if $game_variables[204] != 0
          end
        
        when "ene_max_damage"
          if @put_page == 1
            put_run = true
            option_txt = "敵最大ダメージ　："
            #option_txt += $data_enemies[$game_variables[208]].name + " が " + $game_actors[$game_variables[216]].name + " に " + $game_variables[207].to_s + "ダメージ" if $game_variables[208] != 0
            option_txt += $data_enemies[$game_variables[208]].name + " が " + $game_actors[$game_variables[216]].name + " に " + $game_variables[207].to_s if $game_variables[208] != 0
          end
        when "get_gold" 
          if @put_page == 1
            put_run = true
            option_txt = "全獲得クレジット："
            option_txt += $game_variables[211].to_s
          end
        when "put_gold" 
          if @put_page == 1
            put_run = true
            option_txt = "全使用クレジット："
            option_txt += $game_variables[212].to_s
          end
        when "ace_cha"
          if @put_page == 2
            put_run = true
            option_txt = "撃破数順位　　　："
            #option_txt += $game_variables[212].to_s
            put_line_add = 3
          end
        when "ace_card"
          if @put_page == 2
              put_run = true
            option_txt = "カード使用順位　："
            #option_txt += $game_variables[212].to_s
            put_line_add = 3
          end
        when "ace_tec"
          if @put_page == 2
            put_run = true
            option_txt = "必殺技使用順位　："
            #option_txt += $game_variables[212].to_s
            put_line_add = TECPUT_NUM
          end
        when "ace_scombo"
          if @put_page == 2
            put_run = true
            option_txt = "Ｓコンボ使用順位："
            #option_txt += $game_variables[212].to_s
            put_line_add = SCOMBOPUT_NUM
          end

      end
      
      if option_txt != "" 
        @option_window.contents.draw_text(16,@option_line_height.to_i*put_line, 640, @option_line_height, option_txt.to_s)
      end
      
      case @option_no[i]
      
      when "ace_cha"
        if @put_page == 2
          if $cha_defeat_num.size != 0
            tmp_cha_defeat_num = Marshal.load(Marshal.dump($cha_defeat_num))
            tmp_get_max_val = [0,0,0]
            tmp_get_max_arr = [0,0,0]
            #picture = Cache.picture($top_file_name+"顔味方")
            for z in 0..2
              
              tmp_get_max_val[z] = tmp_cha_defeat_num.max
              tmp_get_max_arr[z] = tmp_cha_defeat_num.index(tmp_get_max_val[z])
              tmp_cha_defeat_num[tmp_get_max_arr[z]] = 0
              
              #超サイヤ人のフラグの初期化
              for x in 1..7
                if $super_saiyazin_flag[x] == nil
                  $super_saiyazin_flag[x] = false
                end
              end 
              #超サイヤ人の変身状態をみて、違う方は表示を消す
              if tmp_get_max_arr[z] == 3 && $super_saiyazin_flag[1] == true ||
              tmp_get_max_arr[z] == 5 && $super_saiyazin_flag[2] == true ||
              tmp_get_max_arr[z] == 12 && $super_saiyazin_flag[3] == true ||
              tmp_get_max_arr[z] == 16 && $super_saiyazin_flag[7] == true ||
              tmp_get_max_arr[z] == 17 && $super_saiyazin_flag[4] == true ||
              tmp_get_max_arr[z] == 25 && $super_saiyazin_flag[6] == true ||
              tmp_get_max_arr[z] == 14 && $super_saiyazin_flag[1] == false ||
              tmp_get_max_arr[z] == 18 && $super_saiyazin_flag[2] == false ||
              tmp_get_max_arr[z] == 19 && $super_saiyazin_flag[3] == false ||
              tmp_get_max_arr[z] == 32 && $super_saiyazin_flag[7] == false ||
              tmp_get_max_arr[z] == 20 && $super_saiyazin_flag[4] == false ||
              tmp_get_max_arr[z] == 26 && $super_saiyazin_flag[6] == false
                tmp_get_max_val.delete_at(z)
                tmp_get_max_arr.delete_at(z)
                redo
              end
            
              if tmp_get_max_val[z] != 0
                #rect = Rect.new(0, 0+((tmp_get_max_arr[z]-3)*64), 64, 64) # 顔グラ
                rect,picture = set_character_face 0,tmp_get_max_arr[z]-3
                @option_window.contents.blt(16+224+z*128,@option_line_height.to_i*put_line+4,picture,rect)

                tmp_rank = 0
                if tmp_get_max_val[z] == tmp_get_max_val[0]
                  tmp_rank = 1
                elsif tmp_get_max_val[z] == tmp_get_max_val[1]
                  tmp_rank =2
                else
                  tmp_rank = z+1
                end
                
                @option_window.contents.draw_text(16+172+z*128,@option_line_height.to_i*put_line, 640, @option_line_height, tmp_rank.to_s + "位")
                @option_window.contents.draw_text(16+(224-tmp_get_max_val[z].to_s.length*10)+z*128,@option_line_height.to_i*(put_line+2), 640, @option_line_height, tmp_get_max_val[z].to_s)
              end
            end
          end
        end
      when "ace_card"
        if @put_page == 2
          if $card_run_num.size != 0
            for x in 0..$card_run_num.size - 1
              $card_run_num[x] = 0 if $card_run_num[x] == nil
            end
            tmp_card_run_num = Marshal.load(Marshal.dump($card_run_num))
            tmp_get_max_val = [0,0,0]
            tmp_get_max_arr = [0,0,0]
            picture = Cache.picture("顔カード")
            for z in 0..2
              tmp_get_max_val[z] = tmp_card_run_num.max
              tmp_get_max_arr[z] = tmp_card_run_num.index(tmp_get_max_val[z])
              tmp_card_run_num[tmp_get_max_arr[z]] = 0
              if tmp_get_max_val[z] != 0
                rect = put_icon tmp_get_max_arr[z]
                @option_window.contents.blt(16+224+z*128,@option_line_height.to_i*put_line+4,picture,rect)
                
                tmp_rank = 0
                if tmp_get_max_val[z] == tmp_get_max_val[0]
                  tmp_rank = 1
                elsif tmp_get_max_val[z] == tmp_get_max_val[1]
                  tmp_rank =2
                else
                  tmp_rank = z+1
                end
                
                @option_window.contents.draw_text(16+172+z*128,@option_line_height.to_i*put_line, 640, @option_line_height, tmp_rank.to_s + "位")
                @option_window.contents.draw_text(16+(224-tmp_get_max_val[z].to_s.length*10)+z*128,@option_line_height.to_i*(put_line+2), 640, @option_line_height, tmp_get_max_val[z].to_s)
              end
            end
            
          end
        end
      when "ace_tec"
        if @put_page == 2
          if $cha_skill_level.size != 0
            for x in 0..$cha_skill_level.size - 1
              $cha_skill_level[x] = 0 if $cha_skill_level[x] == nil
            end
            tmp_cha_skill_level = Marshal.load(Marshal.dump($cha_skill_level))
            tmp_get_max_val = [0,0,0,0,0]
            tmp_get_max_arr = [0,0,0,0,0]
            #picture = Cache.picture("顔カード")
            for z in 0..(TECPUT_NUM - 1)
              tmp_get_max_val[z] = tmp_cha_skill_level.max
              tmp_get_max_arr[z] = tmp_cha_skill_level.index(tmp_get_max_val[z])
              tmp_cha_skill_level[tmp_get_max_arr[z]] = 0
              if tmp_get_max_val[z] != 0
                
                tmp_rank = 0
                if tmp_get_max_val[z] == tmp_get_max_val[0]
                  tmp_rank = 1
                elsif tmp_get_max_val[z] == tmp_get_max_val[1]
                  tmp_rank =2
                else
                  tmp_rank = z+1
                end
                
                tmp_cha_name = ""
                
                case tmp_get_max_arr[z]
                
                when 0..30
                  tmp_cha_name = "ゴクウ"
                when 31..45
                  tmp_cha_name = "ピッコロ"
                when 46..60
                  tmp_cha_name = "ゴハン"
                when 61..70
                  tmp_cha_name = "クリリン"
                when 71..80
                  tmp_cha_name = "ヤムチャ"
                when 81..90
                  tmp_cha_name = "テンシンハン"
                when 91..100
                  tmp_cha_name = "チャオズ"
                when 101..120
                  tmp_cha_name = "チチ"
                when 121..140
                  tmp_cha_name = "べジータ"
                when 141..146
                  tmp_cha_name = "若者"
                when 147..170
                  tmp_cha_name = "バーダック"
                when 171..190
                  tmp_cha_name = "トランクス"
                when 191..200
                  tmp_cha_name = "18号"
                when 201..210
                  tmp_cha_name = "17号"
                when 211..224
                  tmp_cha_name = "16号"
                when 225..235
                  tmp_cha_name = "亀仙人"
                when 236..245
                  tmp_cha_name = "Ｆゴハン"
                when 246..254
                  tmp_cha_name = "トーマ"
                when 255..264
                  tmp_cha_name = "セリパ"
                when 265..272
                  tmp_cha_name = "トテッポ"
                when 273..280
                  tmp_cha_name = "パンブーキン"
                when 281..287
                  tmp_cha_name = "サタン"
                end
                @option_window.contents.draw_text(16+172,@option_line_height.to_i*(put_line+z), 640, @option_line_height, tmp_rank.to_s + "位 " + tmp_get_max_val[z].to_s + "回：" + tmp_cha_name)
                @option_window.contents.draw_text(16+392,@option_line_height.to_i*(put_line+z), 640, @option_line_height,$data_skills[tmp_get_max_arr[z]].name)
              end
            end
          end
        end
      
      when "ace_scombo"
        if @put_page == 2
         if $cha_skill_level.size != 0
            for x in 0..$cha_skill_level.size - 1
              $cha_skill_level[x] = 0 if $cha_skill_level[x] == nil
            end
            tmp_cha_skill_level = Marshal.load(Marshal.dump($cha_skill_level))
            tmp_get_max_val = [0,0,0,0,0]
            tmp_get_max_arr = [0,0,0,0,0]
            #picture = Cache.picture("顔カード")
            
            for x in 1..tmp_cha_skill_level.size
              #コンボ以外は回数を0にする
              if $data_skills[x].element_set.index(33) == nil
                tmp_cha_skill_level[x] = 0
              end
            end
            for z in 0..(SCOMBOPUT_NUM - 1)
              tmp_get_max_val[z] = tmp_cha_skill_level.max
              tmp_get_max_arr[z] = tmp_cha_skill_level.index(tmp_get_max_val[z])
              tmp_cha_skill_level[tmp_get_max_arr[z]] = 0
              if tmp_get_max_val[z] != 0
                
                tmp_rank = 0
                if tmp_get_max_val[z] == tmp_get_max_val[0]
                  tmp_rank = 1
                elsif tmp_get_max_val[z] == tmp_get_max_val[1]
                  tmp_rank =2
                else
                  tmp_rank = z+1
                end

                @option_window.contents.draw_text(16+172,@option_line_height.to_i*(put_line+z), 640, @option_line_height, tmp_rank.to_s + "位 " + tmp_get_max_val[z].to_s + "回：" + $data_skills[tmp_get_max_arr[z]].name)
                #@option_window.contents.draw_text(16+292,@option_line_height.to_i*(put_line+z), 640, @option_line_height,)
              end
            end
          end
        end
      end
      
      option_txt = ""
      i += 1
      if put_run == true
        put_line += put_line_add
      end
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
    @option_window.contents.blt(0,@cursor_state*@option_line_height+12,picture,rect)

  end

  #--------------------------------------------------------------------------
  # ● オプションメッセージ
  #-------------------------------------------------------------------------- 
  def output_option_message
    
    option_msg = ""
    msg_height = 25
    option_msg = "戦いの記録"
    @explanation_window.contents.draw_text(0,msg_height*0, 630, msg_height, option_msg)
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