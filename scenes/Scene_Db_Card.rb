#==============================================================================
# ■ Scene_Db_Card
#------------------------------------------------------------------------------
# 　カード画面表示
#==============================================================================
class Scene_Db_Card < Scene_Base
  include Icon
  include Share
  Possession_Card_win_sizex = 640         #カード一覧ウインドウサイズX
  Possession_Card_win_sizey = 235         #カード一覧ウインドウサイズY
  Explanation_win_sizex = 500       #カード説明ウインドウサイズX
  Explanation_win_sizey = 112       #カード説明ウインドウサイズY
  Credit_win_sizex = 140            #クレジットウインドウサイズX
  Credit_win_sizey = 112            #クレジットウインドウサイズY
  Possession_Cardx = 200                   #カード一覧表示列空き数
  Possession_Cardy = 32                   #カード一覧表示行空き数
  Possession_Card_Column = 3                   #カード一覧表示列数
  Possession_Card_Row = 6                   #カード一覧表示行数
  Possession_Cardnox = 0                  #カード一覧表示基準X
  Possession_Cardnoy = 32                 #カード一覧表示基準Y
  Explanation_lbx = 16              #カード説明表示基準X
  Explanation_lby = 0               #カード説明表示基準Y
  Creditx = 0                       #クレジット表示基準X
  Credity = 0                       #クレジット表示基準Y
  Creditnamex = 184                 #クレジット画像取得サイズX
  Creditnamey = 24                  #クレジット画像取得サイズY
  @@possession_card_num =0           #所持カード数(種類)
  @@possession_card_id = [nil]      #所持カードID
  @@possession_card_order_id = [nil] #並び順
  @@card_kind = 0                   #カード種類 1:回復 2:カード変更 3:その他
  #カードウインドウ表示位置
  Cardxstr = 10
  Cardystr = 330
  Cardxend = 680
  Cardyend = 210
  Cardsize = 64 #カードサイズ
  Cardoutputkizyun = 102 #カード表示基準位置
  @@cursorstatex = 0                #カードカーソルx軸
  @@cursorstatey = 0                #カードカーソルy軸
  @@run_cursorstatex = 0            #カードを使用した箇所
  @@run_cursorstatey = 0
  @@run_call_state = 0
  @put_card_strat_x = 1 #所持カードの表示開始位置
  @old_put_card_strat_x = 1 #所持カードの表示開始位置1つ前
  @put_card_kyousei_run = false #所持カード表示を強制的に実行flag(カードを使用した時の枚数更新用)
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     call_state : どのプログラムから呼ばれたか 1:戦闘 2:マップ 3:ステータス 4:合成
  #--------------------------------------------------------------------------
  def initialize(call_state = 2)
    @battle_card_cursor_state = 0     #戦闘カードのカーソル位置
    @window_state = 0         #ウインドウ状態 0:カード選択 1:バトルカード選択
    @call_state = call_state                         #呼び出し元の画面
    #カード星増加量
    @add_cardnum_syou =1 #少し
    @add_cardnum_tyuu =3 #かなり
    if @call_state == 2
      set_bgm
      @@cursorstatex = 0
      @@cursorstatey = 0

    elsif @call_state == 3
      @call_state = @@run_call_state
      @@cursorstatex = @@run_cursorstatex
      @@cursorstatey = @@run_cursorstatey
      
      #カードを使用してカードの種類が減ったときにカーソルの位置を調整する
      if @@possession_card_num < @@cursorstatey * Possession_Card_Column + @@cursorstatex + 1
        @@cursorstatex = 0
        @@cursorstatey = 0
        @put_area_y = 0
        #update_put_card_strat_x
        @put_card_kyousei_run = true
        #$get_card_run = true
      end
      
    elsif @call_state == 4
      @@cursorstatex = 0
      @@cursorstatey = 0
    end
    
  end
  #--------------------------------------------------------------------------
  # ● カードマスの状態をセット
  #--------------------------------------------------------------------------
  def set_cardmas_name
    #カードマスのランダム表示
    $game_actors[2].name = ""
    
    if $game_switches[866] == true
      $game_actors[2].name = "ショップ"
    elsif $game_switches[867] == true
      $game_actors[2].name = "しんけいすいじゃく"
    elsif $game_switches[868] == true
      $game_actors[2].name = "くじ"
    else
      $game_actors[2].name = "ランダム"
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start

    #カードマスの状態を2にセット
    set_cardmas_name
    
    #カード数調整 最大値にあわせる
    set_max_item_card
    #カードあと何枚取得できるか
    set_card_remaining
    @card_run_result = 0              #カード使用するかどうか選択
    
    #リングアナカードの効果を更新する
    set_ringana_card_kouka
      
    #周回プレイ中であれば
    if $game_switches[860] == true
      #お気に入りチェンジを消費しないに変更(無限マークを表示するために)
      $data_items[141].consumable  = false
    end
    
    $get_card_run = true #カード取得処理をするか
    super
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    @window_update_flag = true
    @put_area_y = 0
    @up_cursor = Sprite.new
    @down_cursor = Sprite.new
    set_up_down_cursor
    
    create_window
    pre_update
    Graphics.fadein(5)
  end
  
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_sprite
    dispose_window
    #パーティーの各フラグ更新
    if @call_state == 1 #戦闘時のみ戦闘から呼ばれたにする
      update_party_detail_status @call_state
    else
      update_party_detail_status 3
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------    
  def pre_update
    
    if @window_update_flag == true || @put_card_kyousei_run == true

      #カーソルを消すために背景色を塗る
      @possession_card_window.contents.fill_rect(0+200*0,0,16,6400,@possession_card_window.get_back_window_color)
      @possession_card_window.contents.fill_rect(0+200*1,0,16,6400,@possession_card_window.get_back_window_color)
      @possession_card_window.contents.fill_rect(0+200*2,0,16,6400,@possession_card_window.get_back_window_color)
      #カードの説明表示、カードの表示カーソル移動ごとに毎回クリアが必要なので、重複になるかもしれないが、個別に処理
      @explanation_window.contents.clear
      @card_window.contents.clear
      #@back_window.contents.clear
      #はい、いいえ選択カーソルが消せないので毎回表示
      if @result_window != nil
        @result_window.contents.clear
      end 
      get_possession_card if $get_card_run == true #カード取得処理
      update_put_card_strat_x
      if @old_put_card_strat_x != @put_card_strat_x || @put_card_kyousei_run == true
        window_contents_clear
        #get_possession_card if $get_card_run == true #カード取得処理
        output_back
        output_credit
        output_possession_card
      end

      #カードを使用してカードの種類が減ったときにカーソルの位置を調整する
      if @@possession_card_num < @@cursorstatey * Possession_Card_Column + @@cursorstatex + 1
        @@cursorstatex = 0
        @@cursorstatey = 0
        @put_area_y = 0
        #update_put_card_strat_x
        @put_card_kyousei_run = true
        #$get_card_run = true
      end

      if @@possession_card_num > 0
        output_explanation
      end

      if @result_window != nil
        output_result
      end
      @back_window.update
      @card_window.update
      @explanation_window.update
      @credit_window.update
      @possession_card_window.update
      #Graphics.update
      @window_update_flag = false
    end
    
    output_cursor
    output_battle_card
  
  end
  
  #--------------------------------------------------------------------------
  # ● フレーム更新
  # 戻り値 "1" ：(メニュー画面を抜ける)
  #--------------------------------------------------------------------------   
  def update
    super
    
    #カード所持数が0のときはキャンセル以外処理しない
    if Input.trigger?(Input::B)
      @window_update_flag = true
      if @window_state == 0
        Graphics.fadeout(5)
        $run_item_card_id = 0
        if @call_state == 1 #戦闘
          $scene = Scene_Db_Battle.new ($battle_escape,$battle_bgm,$battle_ready_bgm)
          @@cursorstatex = 0                #カードカーソルx軸
          @@cursorstatey = 0                #カードカーソルy軸
          $WinState = 5
        elsif @call_state == 2 #マップ
          Audio.bgm_play("Audio/BGM/" + $map_bgm)    # 効果音を再生する
          $scene = Scene_Map.new
        elsif @call_state == 4
          $game_switches[36] = true #カード合成キャンセルしたフラグ
          $scene = Scene_Map.new
        end
        
      elsif @window_state == 1
        @window_state = 0
      elsif @window_state == 2
        @window_state = 0
        @card_run_result = 0
        dispose_result_window
      end
        
    end  
    
    if Input.trigger?(Input::X)
      if @window_state == 0
        @window_update_flag = true
        #表示カードを再取得
        $get_card_run = true

        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        sel_card_no = @@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column]
        if $priority_card_no.index(sel_card_no) == nil
          #優先表示にする
          $priority_card_no << sel_card_no
          
          
          #カーソルの位置を変更する
          case @@cursorstatex
          
          when 0,1
            @@cursorstatex += 1
          when 2
            @@cursorstatex = 0
            @@cursorstatey += 1 
          end
        else
          #優先表示から外す
          $priority_card_no.delete(sel_card_no)
          
          #カーソルの位置を変更する
          case @@cursorstatex
          
          when 0
            if @@cursorstatey != 0
              #一番上にいなければ実行
              @@cursorstatex = 2
              @@cursorstatey -= 1
            end
          when 1,2
            @@cursorstatex -= 1
          end
        end
      end
    end
    
    if @@possession_card_num > 0
      
      #ページ送り前
      if Input.trigger?(Input::L)
        if @window_state == 0
          @window_update_flag = true
          Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
          @@cursorstatey -= Possession_Card_Row
          
          #表示スタート位置も調整
          @put_area_y -= Possession_Card_Row
          #0より小さくなったら0にする
          if @@cursorstatey < 0
            @@cursorstatey = 0
          end
          
          if @put_area_y < 0
            @put_area_y = 0
          end
          
        end
      end

      #ページ送り後ろ
      if Input.trigger?(Input::R)
        if @window_state == 0
          @window_update_flag = true
          Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する

          #最大ページ数取得
          #p @@possession_card_num/Possession_Card_Column - 1
          @@cursorstatey += Possession_Card_Row
          
          #表示スタート位置も調整
          @put_area_y += Possession_Card_Row
          
          #最大ページ以上になったら最大ページで止める
          if @@cursorstatey > @@possession_card_num/Possession_Card_Column
            @@cursorstatey = @@possession_card_num/Possession_Card_Column
          end
          
          #一番下のページの場合表示をあげる
#          p (@@cursorstatey - (@@possession_card_num / Possession_Card_Column)),
          #p ((@@possession_card_num / Possession_Card_Column) - @@cursorstatey)
          if ((@@possession_card_num / Possession_Card_Column) - @@cursorstatey) < Possession_Card_Row - 1
            #p ((@@possession_card_num / Possession_Card_Column) - @@cursorstatey)
            @put_area_y -= (Possession_Card_Row - ((@@possession_card_num / Possession_Card_Column) - @@cursorstatey))
          end
            #if @@cursorstatey == @@possession_card_num/Possession_Card_Column
          #  @put_area_y -= Possession_Card_Row
          #end
          
          temp_cursoriti_num = (@@cursorstatey * Possession_Card_Column + @@cursorstatex + 1)
          #p temp_cursoriti_num,@@possession_card_num
          #最大ページの2,3列目も存在するかチェック、
          if @@possession_card_num < temp_cursoriti_num
            #p "オーバーしている",temp_cursoriti_num - @@possession_card_num
            #カーソル位置行あげる
            @@cursorstatey -= 1
            #表示位置を下げる
            #p ((@@possession_card_num / Possession_Card_Column) - @put_area_y)
            if ((@@possession_card_num / Possession_Card_Column) - @put_area_y) == Possession_Card_Row
              @put_area_y += 1
            end
            #存在しなければ一列目にする
            #@@cursorstatex -= (temp_cursoriti_num - @@possession_card_num)
          end
        end
      end
    
      if Input.trigger?(Input::C)
        
        @window_update_flag = true
        
        if @call_state == 4
          if @window_state == 0
            card_run
            
          elsif @window_state == 2
            dispose_result_window
            
            
            if @card_run_result == 0
              Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              $run_item_card_id = @@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column]
              if $card_compo_no.size == 0
                $card_compo_no[0] = nil
              end
              $card_compo_no[$card_compo_no.size] = $run_item_card_id
              #p $card_compo_no,$card_compo_no.size
              $game_party.lose_item ($data_items[$run_item_card_id], 1) #カード減らす
              @window_state = 0
              Graphics.fadeout(5)
              $scene = Scene_Map.new
            else
              @card_run_result = 0
              @window_state = 0
              $get_card_run = true
            end

          end
        else
          if @window_state == 0
            #カードID格納
            $run_item_card_id = @@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column]
            if @call_state == $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].occasion || $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].occasion == 0
              card_run
            else  
              Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
            end
          elsif @window_state == 1 #バトルカードチェンジ
            if true == chk_change_card_run
              Audio.se_play("Audio/SE/" + "Z2 カードアップ")    # 効果音を再生する
              change_card_run
              $game_party.lose_item ($data_items[$run_item_card_id], 1) #カード減らす
              card_run_num_add $run_item_card_id
              @window_state = 0
              $get_card_run = true
            else
              Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
            end
          elsif @window_state == 2
            dispose_result_window
            
            
            if @card_run_result == 0
              card_run
              card_run_num_add $run_item_card_id
              @window_state = 0
              $get_card_run = true
            else
              @card_run_result = 0
              @window_state = 0
              $get_card_run = true
            end
          end
        end
      end
      
      if Input.trigger?(Input::DOWN)
        @window_update_flag = true
        if @window_state == 0
          Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
          move_cursor 2
        end
      end
      if Input.trigger?(Input::UP)
        @window_update_flag = true
        if @window_state == 0
          Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
          move_cursor 8
        end
      end
      if Input.trigger?(Input::RIGHT)
        @window_update_flag = true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if @window_state == 0
          move_cursor 6
        elsif @window_state == 1
          if @battle_card_cursor_state == $Cardmaxnum
            @battle_card_cursor_state = 0
          else
            @battle_card_cursor_state += 1
          end
        elsif @window_state == 2
          if @card_run_result == 0
            @card_run_result = 1
          else
            @card_run_result = 0
          end
        end
      end
      if Input.trigger?(Input::LEFT)
        @window_update_flag = true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if @window_state == 0
          move_cursor 4
        elsif @window_state == 1
          if @battle_card_cursor_state == 0
            @battle_card_cursor_state = $Cardmaxnum
          else
            @battle_card_cursor_state -= 1
          end
        elsif @window_state == 2
          if @card_run_result == 0
            @card_run_result = 1
          else
            @card_run_result = 0
          end
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
    @possession_card_window.dispose
    @possession_card_window = nil
    @explanation_window.dispose
    @explanation_window = nil
    @credit_window.dispose
    @credit_window = nil
    @card_window.dispose
    @card_window = nil
    @back_window.dispose
    @back_window = nil
  end 
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def window_contents_clear
    @possession_card_window.contents.clear
    @explanation_window.contents.clear
    @credit_window.contents.clear
    @card_window.contents.clear
    @back_window.contents.clear
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
    @result_window = Window_Base.new(180,160,280,100)
    @result_window.opacity=255
    @result_window.back_opacity=255
    @result_window.contents.font.color.set( 0, 0, 0)
    output_result
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    #Graphics.fadeout(0)
    # バックウインドウ作成(色・背景・敵キャラ)
    @back_window = Window_Base.new(-16,Explanation_win_sizey+Possession_Card_win_sizey-16,672,480-(Explanation_win_sizey+Possession_Card_win_sizey)+32)
    @back_window.opacity=0
    @back_window.back_opacity=0
    #Graphics.fadein(10)
    @possession_card_window = Window_Base.new(0,Explanation_win_sizey,Possession_Card_win_sizex,Possession_Card_win_sizey)
    @possession_card_window.opacity=255
    @possession_card_window.back_opacity=255
    @possession_card_window.contents.font.color.set( 0, 0, 0)
    @possession_card_window.contents.font.shadow = false
    @possession_card_window.contents.font.bold = true
    @possession_card_window.contents.font.name = ["ＭＳ ゴシック"]
    @possession_card_window.contents.font.size = 17
    @explanation_window = Window_Base.new(0,0,Explanation_win_sizex,Explanation_win_sizey)
    @explanation_window.opacity=255
    @explanation_window.back_opacity=255
    @explanation_window.contents.font.color.set( 0, 0, 0)
    @credit_window = Window_Base.new(Explanation_win_sizex,0,Credit_win_sizex,Credit_win_sizey)
    #@credit_window = Window_Gold.new(Explanation_win_sizex,0)
    @credit_window.opacity=255
    @credit_window.back_opacity=255
    @credit_window.contents.font.color.set( 0, 0, 0)
    # カードウインドウ作成(カード用)
    @card_window = Window_Base.new(Cardxstr,Cardystr,Cardxend,Cardyend)
    @card_window.opacity=0
    @card_window.back_opacity=0

  end
  #--------------------------------------------------------------------------
  # ● カード使用
  #-------------------------------------------------------------------------- 
  def card_run
    #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
    
    result = chk_card_run
    if result == true
        card_judgment if @call_state != 4
    else
      Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
    end
  end

  #--------------------------------------------------------------------------
  # ● カード使用
  #-------------------------------------------------------------------------- 
  def card_judgment
    
    if @@card_kind == 1
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      @@run_call_state = @call_state 
      @@run_cursorstatex = @@cursorstatex
      @@run_cursorstatey = @@cursorstatey
      #$run_item_card_id = @@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column]
      Graphics.fadeout(5)
      $scene = Scene_Db_Status.new 3
    elsif @@card_kind == 2
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      @battle_card_cursor_state = 0
      @window_state = 1
    elsif @@card_kind == 3
      if other_card_run == true
        
        if $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(3) != nil#敵選択
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          $WinState = 7
          Graphics.fadeout(5)
          $scene = Scene_Db_Battle.new ($battle_escape,$battle_bgm,$battle_ready_bgm)
        #elsif $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(18) != nil #敵選択
        #  Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        #  $WinState = 98
        #  $game_party.lose_item ($data_items[$run_item_card_id], 1)
        #  Graphics.fadeout(5)
        #  $scene = Scene_Db_Battle.new ($battle_escape,$battle_bgm,$battle_ready_bgm)
        else
          
          if @window_state == 0
            Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
            
            #ドラゴンレーダー以外なら実行
            if $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].id != 1
              @card_run_result = 0
              @window_state = 2
              create_result_window
            end
          else
            @window_state == 2 #消耗する設定のアイテムのみ数を減らす
            #if $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].id != 1
            if $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].consumable  == true 
              $game_party.lose_item ($data_items[$run_item_card_id], 1)
            end
          end
        end
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # ● カードが使用できるかチェック(HP等が全員満タンではないか等)
  #-------------------------------------------------------------------------- 
  def chk_card_run
    #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
    @@card_kind = 0
    
    #if @@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i == 37 || @@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i == 66
    #  return true
      
    #end
    
    if @call_state == 4
      #p $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(9),$data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set
      #p $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set,$data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(9)
      if $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(9) == nil #0
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        @window_state = 2
        create_result_window
        return true
      else
        return false
      end
    end
      
    #おばけ
    if $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].id == 121
      if $chadead.index(true) != nil
        for x in 0..$partyc.size - 1
          if $chadead[x] == true && $game_actors[$partyc[x]].hp != 0
            @@card_kind = 1
            return true
          end
        end
        
        return false
      else
        return false
      end
    end
    
    #回復系ではない場合はチェックせずにtrue
    if $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].hp_recovery_rate == 0 && $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].mp_recovery_rate == 0
      
      if 2 == $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set[0] #キャラ選択
        @@card_kind = 1
      elsif 1 == $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set[0] #カード変更
        @@card_kind = 2
      else
        @@card_kind = 3
      end  
      return true
    end
    
    #HP回復かチェック
    if 0 != $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].hp_recovery_rate
      for x in 0..$partyc.size - 1
        if $game_actors[$partyc[x]].hp != $game_actors[$partyc[x]].maxhp
          @@card_kind = 1
          return true
        end
      end
    end
    
    #MP回復かチェック
    if 0 != $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].mp_recovery_rate
      for x in 0..$partyc.size - 1
        if $game_actors[$partyc[x]].mp != $game_actors[$partyc[x]].maxmp
          @@card_kind = 1
          return true
        end
      end
    end
    
    #お気に入りキャラ選択カードかチェック
    #p $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set,$data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(19)
    #if $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(19) != nil
    #  return true
    #end
    return false
    #$partyc = [3,4]
  end
  #--------------------------------------------------------------------------
  # ● 所持カード取得＆並び替え
  #-------------------------------------------------------------------------- 
  def get_possession_card
    @put_card_kyousei_run = true #カードを取得しなおしたら強制的に画面更新を行う
    @@possession_card_num = 0
    @@possession_card_id = [nil]
    @temp_possession_card_num = 0
    @temp_possession_card_id = [nil]
    @temp_possession_card_order_id = [nil]
    #とりあえず格納
    for x in 1..$data_items.size-1
      if $game_party.item_number($data_items[x]) != 0
        
        @temp_possession_card_num += 1
        @temp_possession_card_id[@temp_possession_card_num] = $data_items[x].id
        @temp_possession_card_order_id[@temp_possession_card_num] = $data_items[x].speed
        #p $data_items[x].name
      end
    end
    #並び替え
    #@temp_possession_card_num
    for x in 1..$data_items.size-1
      for z in 1..@temp_possession_card_num
        
        if x == @temp_possession_card_order_id[z]
          @@possession_card_num += 1
          @@possession_card_id[@@possession_card_num] = @temp_possession_card_id[z]
          
        end
      end
    end
    
    #優先カードを追加
    if $priority_card_no.size != 0
      #優先設定が1個以上
      for x in 0..($priority_card_no.size - 1)
        x = ($priority_card_no.size - 1) - x
        
        if $game_party.item_number($data_items[$priority_card_no[x]]) >= 1
          #1個以上持っていれば
            @@possession_card_num += 1
            @@possession_card_id.insert(1, $priority_card_no[x])
        end
      end
    end
    
    $get_card_run = false
  end
  
  #--------------------------------------------------------------------------
  # ● カードの表示スタートを更新
  #--------------------------------------------------------------------------  
  def update_put_card_strat_x
    @old_put_card_strat_x = @put_card_strat_x
    
    if @temp_possession_card_num > (Possession_Card_Column * Possession_Card_Row - 1)
      #if @@cursorstatey > (Possession_Card_Row - 1)
       if @@cursorstatey < @put_area_y# || (@@cursorstatey + 1) > (@put_area_y + Possession_Card_Row)
         @put_area_y = @@cursorstatey 
       elsif (@@cursorstatey + 1) > (@put_area_y + Possession_Card_Row)
         @put_area_y = @@cursorstatey - (Possession_Card_Row - 1) 
         
       end
        #elsif @put_area_y >= @@cursorstatey
        #  @put_area_y = @@cursorstatey - (Possession_Card_Row - 1) 
        #  @put_card_strat_x = (@put_area_y * Possession_Card_Column + 1)
        #p @put_card_strat_x,@put_area_y,@@cursorstatey
        #p @put_card_strat_x
      #end
    end
    
    @put_card_strat_x = (@put_area_y * Possession_Card_Column + 1)
  end
  #--------------------------------------------------------------------------
  # ● 所持カード表示
  #--------------------------------------------------------------------------  
  def output_possession_card
    @put_card_kyousei_run = false #強制出力フラグを元に戻す
    y = 0

    #表示
    possession_card = 0
    
    #@put_area_y = 0

    #p @@cursorstatey, @put_area_y,@put_card_strat_x
    #p @put_card_strat_x,@temp_possession_card_num,@@possession_card_id.size
    #p @put_card_strat_x,@temp_possession_card_num,@@possession_card_id
    for x in @put_card_strat_x..@@possession_card_id.size - 1
        #p x
        #カード名
        #@possession_card_window.contents.draw_text(possession_card*Possession_Cardx-y*600, Possession_Cardy*y, 110, 20, @@possession_card_id[x])
        #text = $data_items[@@possession_card_id[x]].name.to_s
        #@possession_card_window.contents.draw_text(16+possession_card*Possession_Cardx-y*600, Possession_Cardy*y, 110, 20, text)
        mozi = $data_items[@@possession_card_id[x]].name.to_s
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        
        #優先カードか確認して色を変える
        if $priority_card_no.index(@@possession_card_id[x]) == nil
          $tec_mozi.change_tone(0,0,0) #黒
        else
          $tec_mozi.change_tone(255,120,48) #オレンジ
        end
        @possession_card_window.contents.blt(18+possession_card*Possession_Cardx-y*600, Possession_Cardy*y-2,$tec_mozi,rect)
        
        #カード数
        #text = ":" + $game_party.item_number($data_items[@@possession_card_id[x]]).to_s
        #@possession_card_window.contents.draw_text(125+possession_card*Possession_Cardx-y*600, Possession_Cardy*y, 48, 20, text)
        #カード二桁持てるか
        if $game_switches[72] == true
          mozi = "　　　　　　　　：" 
          mozi += "　" if $game_party.item_number($data_items[@@possession_card_id[x]]).to_s.size == 1 
        else
          mozi = "　　　　　　　　　：" 
        end
        
        #使っても消費しないカードか
        if $data_items[@@possession_card_id[x]].consumable == false
          #消費しないカード
          mozi += "無限"
        else
          #消費するカード
          mozi += $game_party.item_number($data_items[@@possession_card_id[x]]).to_s
        end
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        #優先カードか確認して色を変える
        if $priority_card_no.index(@@possession_card_id[x]) == nil
          $tec_mozi.change_tone(0,0,0) #黒
        else
          $tec_mozi.change_tone(255,120,48) #オレンジ
        end
        @possession_card_window.contents.blt(18+possession_card*Possession_Cardx-y*600, Possession_Cardy*y-2,$tec_mozi,rect)
        possession_card += 1
         
        if possession_card != 0 && possession_card % Possession_Card_Column == 0
          y += 1
        end
        
        break if (@put_card_strat_x+Possession_Card_Row*Possession_Card_Column - 1) <= x
    end
#    for x in 1..$data_items.size-1
#      if $game_party.item_number($data_items[x]) != 0
#        #カード名
#        text = $data_items[x].name
#        @possession_card_window.contents.draw_text(16+@@possession_card_num*Possession_Cardx-y*600, Possession_Cardy*y, 110, 20, text)
#        
#        #カード数調整 最大値にあわせる
#        if $game_party.item_number($data_items[x]) > $max_item_card_num
#          $game_party.lose_item ($data_items[x], $game_party.item_number($data_items[x]) - $max_item_card_num) #カード減らす
#        end
#        
#        #カード数
#        text = ":" + $game_party.item_number($data_items[x]).to_s
#        @possession_card_window.contents.draw_text(125+@@possession_card_num*Possession_Cardx-y*600, Possession_Cardy*y, 48, 20, text)
#        
#        @@possession_card_num += 1
#        @@possession_card_id[@@possession_card_num] = $data_items[x].id
#          
#        if @@possession_card_num != 0 && @@possession_card_num % Possession_Card_Column == 0
#          y += 1
#        end
#        
#        
#      end
#    end
  
#縦表示
#    for y in 1..40
#      if $game_party.item_number($data_items[y]) != 0

#        if y <= 1 || y >= 9
#          text = $data_items[y].name
#          @possession_card_window.contents.draw_text(16+x*150, 20*@@possession_card_num-200*x, 110, 20, text)
#          text = $game_party.item_number($data_items[y]).to_s
#          @possession_card_window.contents.draw_text(125+x*150, 20*@@possession_card_num-200*x, 48, 20, text)
          
#          @@possession_card_num += 1
#        end
#        if @@possession_card_num != 0 && @@possession_card_num % 10 == 0
#          x += 1
#        end
#      end
#    end

  end
  #--------------------------------------------------------------------------
  # ● カード説明とアイコン表示
  #--------------------------------------------------------------------------   
  def output_explanation
      
    #カードアイコン表示
    picture = Cache.picture("顔カード")
    rect = put_icon $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].id
    @explanation_window.contents.blt(8,0,picture,rect)
    #説明表示
    text = $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].note
    y = 0
    text.each_line {|line| #改行を読み取り複数行表示する
      line.sub!("￥n", "") # ￥は半角に直す
      line = line.gsub("\r", "")#改行コード？が文字化けするので削除
      line = line.gsub("\n", "")#
      mozi = line
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @explanation_window.contents.blt(112, y*24, $tec_mozi,rect)
      #@explanation_window.contents.draw_text(112, y, 370, 40, line)
      y += 1#24
      }
      
    
    #テスト用カードNo表示
    #text = @@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i
    #@explanation_window.contents.draw_text(112, 50, 370, 48, text)

    #使用可能箇所表示
    #0: 常時 
    #1: バトルのみ 
    #2: メニューのみ 
    #3: 使用不可
    picture = Cache.picture("カード関係")
    rect = set_card_frame 10
    @explanation_window.contents.blt(0,64,picture,rect)
    #color = Color.new(@explanation_window.get_back_window_color)

    case $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].occasion
    
    when 1
      @explanation_window.contents.fill_rect(48,64,48,16,@explanation_window.get_back_window_color)
    when 2
      @explanation_window.contents.fill_rect(0,64,48,16,@explanation_window.get_back_window_color)
    when 3
      @explanation_window.contents.fill_rect(0,64,96,16,@explanation_window.get_back_window_color)
    end
    #カードランク表示
    picture = Cache.picture("数字英語")
    
    
    #for z in 0..3
    #rect = Rect.new(192+z*16, 16, 16, 16)
    #@explanation_window.contents.blt(74,0+z*16-2,picture,rect)
    #end
    tmp_set_posi = 0
    if $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(5)
      #Sランク
      tmp_set_posi = 0
      
    elsif $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(6)
      #Aランク
      tmp_set_posi = 1
    elsif $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(7)
      #Bランク
      tmp_set_posi = 2
    elsif $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(8)
      #Cランク
      tmp_set_posi = 3
    else
      tmp_set_posi = 9
    end
    if tmp_set_posi == 9
      #for z in 0..3
      #rect = Rect.new(256+z*16, 16, 16, 16)
      #@explanation_window.contents.blt(74,0+z*16-2,picture,rect)
      #end
    else
      rect = set_card_frame 11,tmp_set_posi
      #rect = Rect.new(256+tmp_set_posi*16, 16, 16, 16)
      @explanation_window.contents.blt(74,0+tmp_set_posi*16-2,picture,rect)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● クレジット表示
  #--------------------------------------------------------------------------  
  def output_credit
    #text = "クレジット"
    #@credit_window.contents.draw_text(0, 0, 100, 40, text)
    mozi = "　　クレジット"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @credit_window.contents.blt(0-2, 0,  $tec_mozi,rect)
    mozi = $game_party.gold.to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @credit_window.contents.blt(16*(7-mozi.split(//u).size)-2, 32,  $tec_mozi,rect)

  end
  
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------
  def output_cursor
    # メニューカーソル表示
    $cursor_blink_count += 1
    picture = Cache.picture("アイコン")
    if @window_state == 0
      rect = set_yoko_cursor_blink
    else
      rect = set_yoko_cursor_blink 0 # アイコン
    end
    @possession_card_window.contents.blt(Possession_Cardx*@@cursorstatex,Possession_Cardy*(@@cursorstatey-@put_area_y)+6,picture,rect)
    
    if @window_state == 1 #バトルカードカーソル表示
      rect = set_tate_cursor_blink
      @card_window.contents.blt(110 + Cardsize * @battle_card_cursor_state,8,picture,rect)
    end
    
    if @result_window != nil #カード使用はいいいえ表示
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @result_window.contents.blt(@card_run_result*80+2,42,picture,rect)
    end
    
    #上側カーソル
    if @put_area_y > 0
      @up_cursor.visible = true
    else
      @up_cursor.visible = false
    end
    
    #下側カーソル
    if (@put_area_y*Possession_Card_Column + Possession_Card_Row*Possession_Card_Column) < @@possession_card_num
      @down_cursor.visible = true
    else
      @down_cursor.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● カード使用はいいいえ表示
  #-------------------------------------------------------------------------- 
  def output_result
    #@result_window.contents.draw_text(0,0, 300, 40, "このカードを使用しますか？")
    mozi = "このカードを　つかいますか？"
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
  # ● バトルカード表示
  #--------------------------------------------------------------------------  
  def output_battle_card
      # バトルカード表示
      picture = Cache.picture("カード関係")
      recta = set_card_frame 0
      for a in 1..6 do
        rectb = set_card_frame 2,$carda[a-1] # 攻撃
        rectc = set_card_frame 3,$cardg[a-1] # 防御
        rectd = Rect.new(0 + 32 * ($cardi[a-1]), 64, 32, 32) # 流派  
        @card_window.contents.blt(Cardoutputkizyun + Cardsize * (a-1),24,picture,recta)
        @card_window.contents.blt(Cardoutputkizyun + 2 + Cardsize * (a-1)+$output_card_tyousei_x,26+$output_card_tyousei_y,picture,rectb)
        @card_window.contents.blt(Cardoutputkizyun + 30 + Cardsize * (a-1),86,picture,rectc)
        @card_window.contents.blt(Cardoutputkizyun + 16 + Cardsize * (a-1),56,picture,rectd)
      end

  end
  #--------------------------------------------------------------------------
  # ● カーソル移動
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def move_cursor n
    #@@cursorstate = 0
    # メニューカーソル表示
    #@explanation_window.contents.fill_rect(Possession_Cardx*@@cursorstatex,Possession_Cardy*(@@cursorstatey),16,16,@explanation_window.get_back_window_color)
    case n
    
    when 2
      if @@possession_card_num > (@@cursorstatey+1) * Possession_Card_Column + @@cursorstatex
        @@cursorstatey += 1
      else
        @@cursorstatey = 0
        @put_area_y = 0
      end
    when 8
      if @@cursorstatey > 0
        @@cursorstatey -= 1
      elsif @@possession_card_num > (@@possession_card_num/Possession_Card_Column)*Possession_Card_Column+@@cursorstatex
        @@cursorstatey = @@possession_card_num/Possession_Card_Column
      else
        @@cursorstatey = @@possession_card_num/Possession_Card_Column - 1
      end
    when 6
      if @@cursorstatex < @@possession_card_num - @@cursorstatey * Possession_Card_Column - 1 && @@cursorstatex < Possession_Card_Column - 1
        @@cursorstatex += 1
      else
        @@cursorstatex = 0
      end
    when 4
      if @@cursorstatex > 0
        @@cursorstatex -= 1
      elsif @@possession_card_num < (@@cursorstatey+1) * Possession_Card_Column
        @@cursorstatex = @@possession_card_num - @@cursorstatey * Possession_Card_Column - 1
      else
        @@cursorstatex = Possession_Card_Column - 1
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 背景表示
  #--------------------------------------------------------------------------   
  def output_back
    color = set_skn_color 0
    @back_window.contents.fill_rect(0,0,640,480-(Explanation_win_sizey+Possession_Card_win_sizey)+32,color)
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ背景色取得
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def get_window_back_color(n)
    x = 64 + (n % 8) * 8
    y = 96 + (n / 8) * 8
    return windowskin.get_pixel(x, y)
  end
  #--------------------------------------------------------------------------
  # ● バトルカード変更アイテム(カード)使用
  #-------------------------------------------------------------------------- 
  def change_card_run
    
    anime_frame = 0 #白切り替えよう
    repetition = 50 #繰り返し回数
    for x in 0..repetition

      @back_window.contents.clear
      output_back
      output_battle_card

      if anime_frame < 2 || x == repetition
        output_card_change_effect ($data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].id,x,repetition)
      end
      
      @back_window.update
      Graphics.update
      
      if anime_frame != 3
        anime_frame += 1
      else
        anime_frame = 0
      end 
    end
    

  end

  #--------------------------------------------------------------------------
  # ● バトルカード変更アイテム(カード)画面更新
  #引数:(card_id:カードID,frame:繰り返し回数,max_num:繰り返し最大数) 
  #-------------------------------------------------------------------------- 
  def output_card_change_effect card_id,frame,max_num
    picture = Cache.picture("カード関係")

    case card_id

    when 19 #エンマ様 攻撃Zに
      rect = set_card_frame 5
      if frame == 50
        $carda[@battle_card_cursor_state] = 7
      end
    when 20 #占いババ 防御Zに
      rect = set_card_frame 6
      if frame == max_num
        $cardg[@battle_card_cursor_state] = 7
      end
    when 21 #牛魔王 攻撃全部プラス１から2
      rect = set_card_frame 5
      add_num = rand(2)+@add_cardnum_syou
      if frame == max_num
        for x in 0..$Cardmaxnum
          if $carda[x] != 7
            $carda[x] += add_num
            $carda[x] = 7 if $carda[x] > 7
          end
        end
      end
    when 22 #ランチ 防御全部プラス１から2
      rect = set_card_frame 6
      add_num = rand(2)+@add_cardnum_syou
      if frame == max_num
        for x in 0..$Cardmaxnum
          if $cardg[x] != 7
            $cardg[x] += add_num
            $cardg[x] = 7 if $cardg[x] > 7
          end
        end
      end
    when 23 #チチ 必殺カードに
      rect = set_card_frame 8
      if frame == max_num
        $cardi[@battle_card_cursor_state] = 0
      end
    when 50 #ウミガメ 流派変更
      rect = set_card_frame 8
      if frame == max_num
        $cardi[@battle_card_cursor_state] = create_card_i 0,false,0,$cardi[@battle_card_cursor_state]
      end

    when 169 #異星人 １枚だけカードを取り換える
      rect = set_card_frame 1
      if frame == max_num
        createcardval @battle_card_cursor_state
      end
    when 24 #ウーロン カード変更
      rect = set_card_frame 1
      if frame == max_num
        allcardexchange

      end
    when 25 #グレゴリー 1枚攻撃と防御入れ替え
      rect = set_card_frame 7
      if frame == max_num
        $carda[@battle_card_cursor_state],$cardg[@battle_card_cursor_state] = $cardg[@battle_card_cursor_state],$carda[@battle_card_cursor_state]
      end
    when 26 #ランチ金髪 全部攻撃と防御入れ替え
      rect = set_card_frame 7
      if frame == max_num
        for x in 0..$Cardmaxnum
          $carda[x],$cardg[x] = $cardg[x],$carda[x]
        end
      end
    when 38 #ポルンガ 攻撃防御全部プラス7 流派を気に
      rect = set_card_frame 9
      if frame == max_num
        
        for y in 0..7
          for x in 0..$Cardmaxnum
            $cardi[x] = 16
            if $carda[x] != 7
              $carda[x] += 1
            end
            if $cardg[x] != 7
              $cardg[x] += 1
            end
          end
        end
      end
    when 62 #なんでもカード 気カードに
      rect = set_card_frame 8
      if frame == max_num
        $cardi[@battle_card_cursor_state] = 16
      end
    when 84 #如意棒 攻１枚プラス1から2
      rect = set_card_frame 5
      add_num = rand(2)+@add_cardnum_syou
      if frame == max_num
        if $carda[@battle_card_cursor_state] != 7
          $carda[@battle_card_cursor_state] += add_num
          $carda[@battle_card_cursor_state] = 7 if $carda[@battle_card_cursor_state] > 7
        end
      end
    when 87 #暖かいコート 防１枚プラス1から2
      rect = set_card_frame 6
      add_num = rand(2)+@add_cardnum_syou
      if frame == max_num
        if $cardg[@battle_card_cursor_state] != 7
          $cardg[@battle_card_cursor_state] += add_num
          $cardg[@battle_card_cursor_state] = 7 if $cardg[@battle_card_cursor_state] > 7
        end
      end
    when 93 #ジャッキー・チュン 攻防１枚プラス3から4
      rect = set_card_frame 7
      add_num = rand(2)+@add_cardnum_tyuu
      if frame == max_num
        if $carda[@battle_card_cursor_state] != 7
          $carda[@battle_card_cursor_state] += add_num
          $carda[@battle_card_cursor_state] = 7 if $carda[@battle_card_cursor_state] > 7
        end
        if $cardg[@battle_card_cursor_state] != 7
          $cardg[@battle_card_cursor_state] += add_num
          $cardg[@battle_card_cursor_state] = 7 if $cardg[@battle_card_cursor_state] > 7
        end
      end
    when 98 #メタリック 防御全部プラス3から4
      rect = set_card_frame 6
      add_num = rand(2)+@add_cardnum_tyuu
      if frame == max_num
        for x in 0..$Cardmaxnum
          if $cardg[x] != 7
            $cardg[x] += add_num
            $cardg[x] = 7 if $cardg[x] > 7
          end
        end
      end
    when 104 #アラレ 全カードを必殺カードに
      rect = set_card_frame 8
      if frame == max_num
        for x in 0..$Cardmaxnum
            $cardi[x] = 0
        end
      end
    when 105 #ボラ 攻撃全部プラス3から4
      rect = set_card_frame 5
      add_num = rand(2)+@add_cardnum_tyuu
      if frame == max_num
        for x in 0..$Cardmaxnum
          if $carda[x] != 7
            $carda[x] += add_num
            $carda[x] = 7 if $carda[x] > 7
          end
        end
      end
    when 106 #ウパ 攻防１枚プラス1から3
      rect = set_card_frame 7
      add_num = rand(2)+@add_cardnum_syou
      if frame == max_num
        if $carda[@battle_card_cursor_state] != 7
          $carda[@battle_card_cursor_state] += add_num
          $carda[@battle_card_cursor_state] = 7 if $carda[@battle_card_cursor_state] > 7
        end
        if $cardg[@battle_card_cursor_state] != 7
          $cardg[@battle_card_cursor_state] += add_num
          $cardg[@battle_card_cursor_state] = 7 if $cardg[@battle_card_cursor_state] > 7
        end
      end
    when 156 #ハイヤードラゴン 全気カード
      rect = set_card_frame 8
      if frame == max_num
        for x in 0..$Cardmaxnum
            $cardi[x] = 16
        end
      end
    
    end
    #p $data_items[card_id].scope
    # バトルカードエフェクト表示
    if $data_items[card_id].scope == 7 #味方単体になっているのは指定カードのみ点滅
      @card_window.contents.blt(Cardoutputkizyun + Cardsize * @battle_card_cursor_state,24,picture,rect)
    else
      for a in 0..$Cardmaxnum do
        @card_window.contents.blt(Cardoutputkizyun + Cardsize * a,24,picture,rect)
        
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # ● バトルカード変更アイテム(カード)使用可能かチェック
  #戻り値 :使用可能か true:使用可能 false:使用不可
  #-------------------------------------------------------------------------- 
  def chk_change_card_run
    case $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].id
  
    when 19 #エンマ様 攻撃Zに
      if $carda[@battle_card_cursor_state] != 7
        return true
      end
    when 20 #占いババ 防御Zに
      if $cardg[@battle_card_cursor_state] != 7
        return true
      end
    when 21 #牛魔王 攻撃全部プラス１
      for x in 0..$Cardmaxnum
        if $carda[x] != 7
          return true
        end
      end
    when 22 #ランチ 防御全部プラス１
      for x in 0..$Cardmaxnum
        if $cardg[x] != 7
          return true
        end
      end
    when 23 #チチ 必殺カードに
      if $cardi[@battle_card_cursor_state] != 0
        return true
      end
    when 24 #ウーロン カード変更
      return true
    when 25 #グレゴリー 1枚攻撃と防御入れ替え
      if $carda[@battle_card_cursor_state] != $cardg[@battle_card_cursor_state]
        return true
      end
    when 26 #ランチ金髪 全部攻撃と防御入れ替え
      for x in 0..$Cardmaxnum
        if $carda[x] != $cardg[x]
          return true
        end
      end
    when 50 #ウミガメ
      return true
    when 62 #なんでもカード 気カードに
      if $cardi[@battle_card_cursor_state] != 16
        return true
      end
    when 169 #取り換え カード１枚だけ変更
      return true
    when 84 #如意棒 攻1～3アップ
      if $carda[@battle_card_cursor_state] != 7
        return true
      end
    when 87 #暖かいコート 防1～3アップ
      if $cardg[@battle_card_cursor_state] != 7
        return true
      end
    when 93 #ジャッキー・チュン 攻防4～6アップ
      if $carda[@battle_card_cursor_state] != 7 || $cardg[@battle_card_cursor_state] != 7
        return true
      end
    when 98 #メタリック 防御全部プラス４～
      for x in 0..$Cardmaxnum
        if $cardg[x] != 7
          return true
        end
      end
    when 104 #アラレ 全カードを必殺カードに
      for x in 0..$Cardmaxnum
        if $cardi[x] != 7
          return true
        end
      end
    when 105 #ボラ 攻撃全部プラス４～
      for x in 0..$Cardmaxnum
        if $carda[x] != 7
          return true
        end
      end
    when 106 #ウパ 攻防4～6アップ
      if $carda[@battle_card_cursor_state] != 7 || $cardg[@battle_card_cursor_state] != 7
        return true
      end

    end
    
    return false
  end
  #--------------------------------------------------------------------------
  # ● その他アイテム(カード)使用(回復とカード変更以外)
  #-------------------------------------------------------------------------- 
  def other_card_run
    skillno = 0
    
    #スキルカードであれば
    if $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].element_set.index(32)
      skillno = $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].base_damage
      
      #p skillno
      
      ##スキル用
      if skillno != 0
          #スキルの取得数とセット数 使わない予定だけど取得したか判断のため数は増やしておく
          $skill_set_get_num = Array.new(2).map{Array.new(1,0)} if $skill_set_get_num == []
          $skill_set_get_num[0][skillno] = 0 if $skill_set_get_num[0][skillno] == nil
          $skill_set_get_num[1][skillno] = 0 if $skill_set_get_num[1][skillno] == nil
          
        if $skill_set_get_num[0][skillno] == 0
          if @window_state == 0
            return true
          end
          if $skill_set_get_num[1][skillno] < $skill_get_max  
            $skill_set_get_num[0][skillno] += 1 
            $skill_set_get_num[1][skillno] += 1 
          end
          Audio.se_play("Audio/SE/" + "DB2 アイテム取得")    # 効果音を再生する
          return true
        else
          return false
        end
      else
        #スキル未設定
        p "スキルが未設定"
        return false
      end
      
=begin
      #スキル関係
      when 63 #取替え 取替え ●販売
        skillno = 421
        
      when 68 #逆さま さかさま ●販売
        skillno = 422
        
      when 66 #テレポート 緊急回避 ●メタルクウラ
        skillno = 392
      
      when 73 #ピラフ いたずら(防御) ●販売
        skillno = 23
      
      when 91 #シュウ いたずら(攻撃) ●バイオ戦士
        skillno = 259
      
      when 92 #マイ いたずら(変更) ●キュイ
        skillno = 289
      
      when 94 #レッドリボン軍A アタッカー ●14号
      when 95 #レッドリボン軍B ディフェンダー ●15号
      when 96 #ブルー将軍 やせがまん ●ピラール
        skillno = 67
        
      when 99 #ムラサキ せんてひっしょう ●ベジータ(超)
        skillno = 64
      
      when 100 #ハッチャン てっぺき ●販売
        skillno = 73
        
      when 101 #レッド総帥 必中 ●カイズ
        skillno = 389
        
      when 107 #タオパイパイ たぎる闘志 ●16号
        skillno = 42
       
      when 108 #ブラック補佐 ヒットアンドアウェイ ●クラズ
        skillno = 221
        
      when 111 #つるせんにん きをためる ●カイオウ
        skillno = 203
        
      when 112 #タンバリン 手加減 ●クウラ(最終形態)
        skillno = 385
      
      when 114 #ピッコロ大魔王(老) 精神統一　●フリーザ２
        skillno = 318
        
      when 115 #ピッコロ大魔王(若) 心身一如　●Z3ガーリック
        skillno = 300
        
      when 116 #タオパイパイサイボーグ 不屈の精神 ●ウィロー
        skillno = 212
        
      when 117 #シェン　攻防一体 ●17、18号
        skillno = 381  
        
      when 118#リカント カードドロップ　●Z3ガーリック(フルパワー)
        skillno = 74
        
      when 119#ギラン 気まぐれ　●販売
        skillno = 390
        
      when 122 #ナム 必殺の一撃　●ターレス・スラッグ
        skillno = 280
        
      when 123 #ミイラくん 力の温存　●フリーザ３　
        skillno = 309
        
      when 142 #ゴクウ すてみ ●ラディッツ
        skillno = 54
      
      when 143 #フリーザ フルパワー ●フリーザ最終
        skillno = 250
        
      when 144 #ピッコロ かばう ●ナッパ
        skillno = 271
        
      when 145 #20号 きゅうしゅう(こうげき)　●販売
        skillno = 260
      
      when 146 #19号 きゅうしゅう(防御)　●20、19号
        skillno = 261
      
      when 147 #セル(第一形態) きゅうしゅう(こうぼう)　●セル１
        skillno = 290
      
      when 148 #クリリン 気を練る　●ドドリア
        skillno = 291
        
      when 149 #ヤムチャ スタートダッシュ　●ベジータ
        skillno = 378
        
      when 150 #ネイル 時間かせぎ 　●フリーザ１
        skillno = 369
        
      when 151 #ベジータ とっさの機転 ●ザーボン
        skillno = 56

      when 152 #ギニュー 起死回生　●ギニュー
        skillno = 367
        
      when 153 #サウザー 連撃　●クウラ機甲戦隊
        skillno = 239
        
      when 154 #ゴハン 激怒　●販売
        skillno = 22
        
      when 155 #サイボーグフリーザ　見下す　●サイボーグフリーザ
        skillno = 393
      when 158 #ガーリック　不死身の体　●Z1ガーリック
        skillno = 412
      when 159 #セル(第二形態)　アウトサイダー　●Z4セル(第二形態)
        skillno = 430
      when 160 #ウィロー　不屈の精神　●Z4ウィロー
        skillno = 45
      when 161 #メタルクウラ・コア　鋼の身体　●Z4メタルクウラ・コア
        skillno = 51
      when 162 #13号 吸収(撃破) ●13号
      when 163 #13号(がったい) タフネス ●13号
=end
    end
    case $data_items[@@possession_card_id[@@cursorstatex + 1 + @@cursorstatey * Possession_Card_Column].to_i].id
    
    when 71 #カメハウス
      if @window_state == 0
        return true
      end
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)
      $game_variables[41] = 26
      $game_switches[474] = true #マップでカードからの移動処理
      $scene = Scene_Map.new
      $game_player.reserve_transfer(7, 0, 0, 0)
      return true
      
    
    when 77 #コガメラ
      if @window_state == 0
        return true
      end
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)
      $game_variables[41] = 91001
      $game_switches[474] = true #マップでカードからの移動処理
      $scene = Scene_Map.new
      $game_player.reserve_transfer(7, 0, 0, 0)
      return true
      
    when 78 #筋斗雲
      if @window_state == 0
        return false if $game_switches[78] == true #時の間にいたら使えない
        return true
      end
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)
      Graphics.fadeout(5)
      
      #スカウターを使った後に筋斗雲カードを使うと再度発動してしまう事の対策
      $WinState = 5 if @call_state == 1
      
      #パーティーの各フラグ更新
      update_party_detail_status 3
      
      #パーティー変更
      if @call_state == 1
        $scene = Scene_Db_Member_change.new @call_state
      else
        $scene = Scene_Db_Member_change.new 3
      end
      return true
    when 37 #ぶくうじゅつ
      if @window_state == 0
        return true
      end
      #Graphics.fadeout(5)
      
      if $game_variables[13] == 60 #ラディッツエリア 
        mapx = 56
        mapy = 5
      elsif $game_variables[13] == 61 #ガーリックエリア 
        mapx = 54
        mapy = 6
      elsif $game_variables[13] == 62 #界王エリア 
        mapx = 7
        mapy = 3
      elsif $game_variables[13] == 63 #ベジータエリア 
        mapx = 56
        mapy = 9
      elsif $game_variables[13] == 64 #ウィローエリア 
        mapx = 6
        mapy = 9
      elsif $game_variables[13] == 67 #キュイエリア 
        mapx = 5
        mapy = 23
      elsif $game_variables[13] == 68 #ドドリアエリア 
        mapx = 12
        mapy = 31
      elsif $game_variables[13] == 69 #ザーボンエリア 
        mapx = 8
        mapy = 9
      elsif $game_variables[13] == 70 #ギニューエリア 
        mapx = 57
        mapy = 22
      elsif $game_variables[13] == 71 #フリーザエリア 
        mapx = 38
        mapy = 60
      elsif $game_variables[13] == 73 #クラズエリア 
        mapx = 78
        mapy = 81
      elsif $game_variables[13] == 83 #ガーリックエリア 
        mapx = 5
        mapy = 2
      elsif $game_variables[13] == 74 #ピラールエリア 
        mapx = 60
        mapy = 21
      elsif $game_variables[13] == 75 #カイズエリア 
        mapx = 9
        mapy = 17
      elsif $game_variables[13] == 76 #クウラエリア 
        mapx = 16
        mapy = 16
      elsif $game_variables[13] == 77 #人造人間エリア 
        mapx = 64
        mapy = 14
      elsif $game_variables[13] == 87 #Z4ウィローエリア 
        mapx = 19
        mapy = 10
      elsif $game_variables[13] == 88 #Z4セル第一形態エリア 
        mapx = 8
        mapy = 40
      elsif $game_variables[13] == 89 #Z4セル第二形態エリア 
        mapx = 40
        mapy = 33
      elsif $game_variables[13] == 91 #Z4メタルクウラエリア 
        mapx = 68
        mapy = 4
      elsif $game_variables[13] == 92 #Z4メタルクウラ・コアエリア 
        mapx = 49
        mapy = 11
      elsif $game_variables[13] == 94 #Z4人造人間13号エリア 
        mapx = 64
        mapy = 17
      elsif $game_variables[13] == 95 #Z4セル完全体エリア 
        mapx = 44
        mapy = 36
      else #エラー防止のためとりあえず移動
        mapx = 1
        mapy = 1
      end
      $game_variables[1] = mapx
      $game_variables[2] = mapy
      $game_switches[474] = true #マップでカードからの移動処理
      $scene = Scene_Map.new
      $game_player.reserve_transfer($game_variables[13], mapx, mapy, 0)

      #Audio.bgm_stop
      Audio.se_play("Audio/SE/" + "Z1 飛ぶ")    # 効果音を再生する

      return true
    when 124 #あんないにん
      if @window_state == 0
        return true
      end
      
      if $game_variables[13] == 60 #ラディッツエリア 
        $game_variables[41] = 9103
      elsif $game_variables[13] == 61 #ガーリックエリア 
        $game_variables[41] = 9112
      elsif $game_variables[13] == 62 #界王エリア 
        $game_variables[41] = 9122
      elsif $game_variables[13] == 63 #ベジータエリア 
        $game_variables[41] = 9132
      elsif $game_variables[13] == 64 #ウィローエリア 
        $game_variables[41] = 9142
      elsif $game_variables[13] == 67 #キュイエリア 
        $game_variables[41] = 9303
      elsif $game_variables[13] == 68 #ドドリアエリア 
        $game_variables[41] = 9312
      elsif $game_variables[13] == 69 #ザーボンエリア 
        $game_variables[41] = 9322
      elsif $game_variables[13] == 70 #ギニューエリア 
        $game_variables[41] = 9332
      elsif $game_variables[13] == 71 #フリーザエリア 
        $game_variables[41] = 9342
      elsif $game_variables[13] == 73 #クラズエリア 
        $game_variables[41] = 9503
      elsif $game_variables[13] == 83 #ガーリックエリア 
        $game_variables[41] = 9552
      elsif $game_variables[13] == 74 #ピラールエリア 
        $game_variables[41] = 9512
      elsif $game_variables[13] == 75 #カイズエリア 
        $game_variables[41] = 9522
      elsif $game_variables[13] == 76 #クウラエリア 
        $game_variables[41] = 9532
      elsif $game_variables[13] == 77 #人造人間エリア 
        $game_variables[41] = 9542
      elsif $game_variables[13] == 87 #Z4ウィローエリア
        $game_variables[41] = 9703
      elsif $game_variables[13] == 88 #Z4セル第一形態エリア
        $game_variables[41] = 9712
      elsif $game_variables[13] == 89 #Z4セル第二形態エリア
        $game_variables[41] = 9722
      elsif $game_variables[13] == 91 #Z4メタルクウラエリア
        $game_variables[41] = 9732
      elsif $game_variables[13] == 92 #Z4メタルクウラ・コアエリア
        $game_variables[41] = 9742
      elsif $game_variables[13] == 94 #Z4人造人間13号エリア
        $game_variables[41] = 9752
      elsif $game_variables[13] == 95 #Z4セル完全体エリア
        $game_variables[41] = 9772
      else
        
      end
      
      $game_switches[474] = true 
      $scene = Scene_Map.new
      $game_player.reserve_transfer(7, 0, 0, 0)
      Graphics.fadeout(5)
      #Audio.bgm_stop
      Audio.se_play("Audio/SE/" + "Z1 入る")    # 効果音を再生する

      return true

    when 1 #ドラゴンレーダー
      Graphics.fadeout(5)
      card_run_num_add $run_item_card_id
      $scene = Scene_Dragon_Radar.new
      return true
    when 21 #牛魔王 攻撃全部プラス１
      if @window_state == 0
        for x in 0..$Cardmaxnum
          if $carda[x] != 7
            return true
          end
        end
        return false
      end
      Audio.se_play("Audio/SE/" + "Z2 カードアップ")    # 効果音を再生する
      change_card_run
      return true
    when 22 #ランチ 防御全部プラス１
      if @window_state == 0
        for x in 0..$Cardmaxnum
          if $cardg[x] != 7
            return true
          end
        end
        return false
      end
      Audio.se_play("Audio/SE/" + "Z2 カードアップ")    # 効果音を再生する
      change_card_run
      return true
    when 24 #ウーロン
      if @window_state == 0
        return true
      end
      Audio.se_play("Audio/SE/" + "Z2 カードアップ")    # 効果音を再生する
      change_card_run
      return true
    when 26 #ランチ金髪 全部攻撃と防御入れ替え
      if @window_state == 0
        for x in 0..$Cardmaxnum
          if $carda[x] != $cardg[x]
            return true
          end
        end
        return false
      end
      Audio.se_play("Audio/SE/" + "Z2 カードアップ")    # 効果音を再生する
      change_card_run
      return true
    when 27 #バブルス
      if $game_variables[39] < 999
        if @window_state == 0
          return true
        end
        $game_variables[39] += 5
        #999回を超えたら999にセット
        $game_variables[39] = 999 if $game_variables[39] >= 1000 
        Audio.se_play("Audio/SE/" + "Z1 飛ぶ")    # 効果音を再生する
        return true
      else
        return false
      end
    when 28 #ブリーフ博士
      if $game_variables[311] < 999
        if @window_state == 0
          return true
        end
        $game_variables[311] += 5
        #999回を超えたら999にセット
        $game_variables[311] = 999 if $game_variables[311] >= 1000 
        Audio.se_play("Audio/SE/" + "Z3 回復")    # 効果音を再生する
        return true
      else
        return false
      end
    when 29 #ヤジロベー
      
      if $one_turn_cha_defense_up == false
        if @window_state == 0
          return true
        end
        $one_turn_cha_defense_up = true
        Audio.se_play("Audio/SE/" + "Z1 刀")    # 効果音を再生する
        return true
      else
        return false
      end
    when 30 #じいちゃん
      if $run_stop_card == false
        return true
      else
        return false
      end
    when 34 #スカウター
      if $run_scouter == false
        if @window_state == 0
          return true
        end
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        $run_scouter = true
        $run_godscouter_card = false
        $WinState = 98
        #$game_party.lose_item ($data_items[$run_item_card_id], 1)
        Graphics.fadeout(5)
        $scene = Scene_Db_Battle.new ($battle_escape,$battle_bgm,$battle_ready_bgm)
        return true
      else
        return false
      end
    when 38 #ポルンガ
      if @window_state == 0
        return true
      end
      
      Audio.se_play("Audio/SE/" + "Z3 レベルアップ")    # 効果音を再生する
      $game_variables[311] += 1 #経験値アップ
      $game_variables[312] += 1 #CAPアップ
      $game_variables[313] += 1 #SPアップ
      change_card_run #カードをZ
      for i in 0..$partyc.size-1 #攻撃防御アップ
        $cha_power_up[i] = true
        $cha_defense_up [i] = true
      end
      #シェンロンは一括で回復する
      for x in 0..$partyc.size - 1
        $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp  
        $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
        $chadead[x] = false
        if $chadeadchk.size > 0
          $chadeadchk[x] = false #もし戦闘中ならチェック用もfals
        end
        
      end
      return true
    when 42 #Sランクカード
      if $game_variables[224] < $max_item_card_num
        if @window_state == 0
          return true
        end
        $game_variables[224] += 1
        Audio.se_play("Audio/SE/" + "Z3 レベルアップ")    # 効果音を再生する
        set_card_remaining
        return true
      else
        return false
      end
    when 43 #Aランクカード
      if $game_variables[225] < $max_item_card_num
        if @window_state == 0
          return true
        end
        $game_variables[225] += 1
        Audio.se_play("Audio/SE/" + "Z3 レベルアップ")    # 効果音を再生する
        set_card_remaining
        return true
      else
        return false
      end
    when 44 #Bランクカード
      if $game_variables[226] < $max_item_card_num
        if @window_state == 0
          return true
        end
        $game_variables[226] += 1
        Audio.se_play("Audio/SE/" + "Z3 レベルアップ")    # 効果音を再生する
        set_card_remaining
        return true
      else
        return false
      end
    when 45 #Cランクカード
      if $game_variables[227] < $max_item_card_num
        if @window_state == 0
          return true
        end
        $game_variables[227] += 1
        Audio.se_play("Audio/SE/" + "Z3 レベルアップ")    # 効果音を再生する
        set_card_remaining
        return true
      else
        return false
      end
    
    when 51 #ゴズ
      if $run_alow_card == false
        return true
      else
        return false
      end
    when 52 #メズ
      if $run_glow_card == false
        return true
      else
        return false
      end
    when 70 #リングアナ
        if @window_state == 0
          return true
        end
        $game_variables[25] += $game_variables[384] #CAP増加(進行度によって増加量変更)
        Audio.se_play("Audio/SE/" + "Z3 回復")    # 効果音を再生する
        return true
    when 76 #飛行機
      if $game_variables[420] < 999
        if @window_state == 0
          return true
        end
        $game_variables[420] += 5
        #999回を超えたら999にセット
        $game_variables[420] = 999 if $game_variables[420] >= 1000
        Audio.se_stop
        Audio.se_play("Audio/SE/" + "DB3 エネルギー波2")    # 効果音を再生する
        return true
      else
        return false
      end
    when 80 #亀の甲羅
      if $game_variables[312] < 999
        if @window_state == 0
          return true
        end
        $game_variables[312] += 5
        #999回を超えたら999にセット
        $game_variables[312] = 999 if $game_variables[312] >= 1000 
        Audio.se_play("Audio/SE/" + "Z3 回復")    # 効果音を再生する
        return true
      else
        return false
      end
    when 82 #重い道着
      if $game_variables[313] < 999
        if @window_state == 0
          return true
        end
        $game_variables[313] += 5
        #999回を超えたら999にセット
        $game_variables[313] = 999 if $game_variables[313] >= 1000 
        Audio.se_play("Audio/SE/" + "Z3 回復")    # 効果音を再生する
        return true
      else
        return false
      end
    when 89 #仙豆の壺 せんずを1枚生成
      if @window_state == 0
        if $game_party.item_number($data_items[17]) == $game_variables[225]
          return false
        else
          return true
        end
      end
      $game_party.gain_item ($data_items[17], 1) #せんず
      set_max_item_card
      set_card_remaining #カードの残り所持数取得
      
      Audio.se_play("Audio/SE/" + "Z3 アイテム取得")    # 効果音を再生する
      return true
    when 98 #メタリック 防御全部プラス4から
      if @window_state == 0
        for x in 0..$Cardmaxnum
          if $cardg[x] != 7
            return true
          end
        end
        return false
      end
      Audio.se_play("Audio/SE/" + "Z2 カードアップ")    # 効果音を再生する
      change_card_run
      return true
    when 104 #アラレ 全カード必に
      if @window_state == 0
        for x in 0..$Cardmaxnum
          if $cardi[x] != 0
            return true
          end
        end
        return false
      end
      Audio.se_play("Audio/SE/" + "Z2 カードアップ")    # 効果音を再生する
      change_card_run
      return true
    when 105 #ボラ 攻撃全部プラス4から
      if @window_state == 0
        for x in 0..$Cardmaxnum
          if $carda[x] != 7
            return true
          end
        end
        return false
      end
      Audio.se_play("Audio/SE/" + "Z2 カードアップ")    # 効果音を再生する
      change_card_run
      return true
    #when 121 #おばけ
    when 156 #ハイヤードラゴン 全カード気に
      if @window_state == 0
        for x in 0..$Cardmaxnum
          if $cardi[x] != 16
            return true
          end
        end
        return false
      end
      Audio.se_play("Audio/SE/" + "Z2 カードアップ")    # 効果音を再生する
      change_card_run
      return true  
      
    when 141 #お気に入りチェンジ
      if @window_state == 0
        return true
      end
      $game_variables[41] = 47
      $game_switches[76] = true
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      Graphics.fadeout(5)
      $game_player.reserve_transfer(7, 0, 0, 0) # 場所移動
      $scene = Scene_Map.new
      return true
    when 171 #恐竜 たべものとごちそうを2枚ずつ生成
      if @window_state == 0
        if $game_party.item_number($data_items[74]) == $game_variables[227] && $game_party.item_number($data_items[75]) == $game_variables[227]
          return false
        else
          return true
        end
      end
      $game_party.gain_item ($data_items[74], 2) #たべもの
      $game_party.gain_item ($data_items[75], 2) #ごちそう
      set_max_item_card
      set_card_remaining #カードの残り所持数取得
      
      Audio.se_play("Audio/SE/" + "Z3 アイテム取得")    # 効果音を再生する
      return true
    when 173 #スカイカー
      if $game_variables[420] < 999
        if @window_state == 0
          return true
        end
        $game_variables[420] += 15
        #999回を超えたら999にセット
        $game_variables[420] = 999 if $game_variables[420] >= 1000
        Audio.se_stop
        Audio.se_play("Audio/SE/" + "DB3 エネルギー波2")    # 効果音を再生する
        return true
      else
        return false
      end
    when 179 #海賊
      if $game_variables[311] < 999
        if @window_state == 0
          return true
        end
        $game_variables[311] += 15
        #999回を超えたら999にセット
        $game_variables[311] = 999 if $game_variables[311] >= 1000 
        Audio.se_play("Audio/SE/" + "Z3 回復")    # 効果音を再生する
        return true
      else
        return false
      end
    when 180 #パイレ人
      if $game_variables[312] < 999
        if @window_state == 0
          return true
        end
        $game_variables[312] += 15
        #999回を超えたら999にセット
        $game_variables[312] = 999 if $game_variables[312] >= 1000 
        Audio.se_play("Audio/SE/" + "Z3 回復")    # 効果音を再生する
        return true
      else
        return false
      end
    when 181 #オウター人
      if $game_variables[313] < 999
        if @window_state == 0
          return true
        end
        $game_variables[313] += 15
        #999回を超えたら999にセット
        $game_variables[313] = 999 if $game_variables[313] >= 1000 
        Audio.se_play("Audio/SE/" + "Z3 回復")    # 効果音を再生する
        return true
      else
        return false
      end
    when 198 #カードショップ
      if @window_state == 0
        if $game_switches[866] == true #既にショップがtrue
         return false
        else
          return true
        end
      end
      $game_switches[866] = true #ショップ
      $game_switches[867] = false #しんけいすいじゃく
      $game_switches[868] = false #くじ
      
      Audio.se_play("Audio/SE/" + "ZD カードセット")    # 効果音を再生する
      #カードマスの状態を2にセット
      set_cardmas_name
      return true
    when 199 #カード神経衰弱
      if @window_state == 0
        if $game_switches[867] == true #既に神経衰弱がtrue
         return false
        else
          return true
        end
      end
      $game_switches[866] = false #ショップ
      $game_switches[867] = true #しんけいすいじゃく
      $game_switches[868] = false #くじ
      
      Audio.se_play("Audio/SE/" + "ZD カードセット")    # 効果音を再生する
      #カードマスの状態を2にセット
      set_cardmas_name
      return true
    when 200 #カードくじ
      if @window_state == 0
        if $game_switches[868] == true #既にくじがtrue
         return false
        else
          return true
        end
      end
      $game_switches[866] = false #ショップ
      $game_switches[867] = false #しんけいすいじゃく
      $game_switches[868] = true #くじ
      
      Audio.se_play("Audio/SE/" + "ZD カードセット")    # 効果音を再生する
      #カードマスの状態を2にセット
      set_cardmas_name
      return true
    when 205 #ゴッドスカウター
      
      ene_all_scouter = true
      for x in 0..$enedead.size - 1
        if $run_scouter_ene[x] == false
          ene_all_scouter = false
        end
      end
      
      if $run_scouter == false || ene_all_scouter == false
        if @window_state == 0
          return true
        end
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        $run_scouter = true
        $run_godscouter_card = true
        $WinState = 98
        #$game_party.lose_item ($data_items[$run_item_card_id], 1)
        Graphics.fadeout(5)
        $scene = Scene_Db_Battle.new ($battle_escape,$battle_bgm,$battle_ready_bgm)
        return true
      else
        return false
      end
    else
      return false
    end
    
  end
  

  #--------------------------------------------------------------------------
  # ● スプライト開放
  #--------------------------------------------------------------------------
  def dispose_sprite
    @up_cursor.bitmap = nil
    @down_cursor.bitmap = nil
    @up_cursor = nil
    @down_cursor = nil
  end
  #--------------------------------------------------------------------------
  # ● 上下カーソルの設定
  #-------------------------------------------------------------------------- 
  def set_up_down_cursor
   picture = Cache.picture("アイコン")
    
    #上カーソル
    # スプライトのビットマップに画像を設定
    @up_cursor.bitmap = Cache.picture("アイコン")
    @up_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @up_cursor.x = 640/2+8-16
    @up_cursor.y = Explanation_win_sizey+16
    @up_cursor.z = 255
    @up_cursor.angle = 91
    @up_cursor.visible = false
    
    #下カーソル
    # スプライトのビットマップに画像を設定
    @down_cursor.bitmap = Cache.picture("アイコン")
    @down_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @down_cursor.x = 640/2+8
    @down_cursor.y = Explanation_win_sizey+Possession_Card_win_sizey-16
    @down_cursor.z = 255
    @down_cursor.angle = 269
    @down_cursor.visible = false
  end
  
  #--------------------------------------------------------------------------
  # ● スプライト開放
  #--------------------------------------------------------------------------
  def dispose_sprite
    @up_cursor.bitmap = nil
    @down_cursor.bitmap = nil
    @up_cursor = nil
    @down_cursor = nil
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