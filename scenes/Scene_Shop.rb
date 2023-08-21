#==============================================================================
# ■ Scene_Shop
#------------------------------------------------------------------------------
# 　ショップ画面の処理を行うクラスです。
#==============================================================================

class Scene_Shop < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    $game_switches[1321] = true #矢印有スキンに切替
    #カード数調整 最大値にあわせる
    set_max_item_card
    create_menu_background
    create_command_window
    @help_window = Window_Base.new(0,0,500,112)
    @help_window.contents.font.color.set( 0, 0, 0)
    @help_window.contents.font.shadow = false
    @help_window.contents.font.bold = true
    @help_window.contents.font.name = ["ＭＳ ゴシック"]
    @help_window.contents.font.size = 17
    @gold_window = Window_Gold.new(500,0)
    @dummy_window = Window_Base.new(0, 168, 640, 312)
    @buy_window = Window_ShopBuy.new(0, 112)
    @buy_window.active = false
    @buy_window.visible = false
    @buy_window.help_window = @help_window
    #@sell_window = Window_ShopSell.new(0, 168, 640, 312)
    @sell_window = Window_ShopSell.new(0, 112, 640, 312+56)
    @sell_window.active = false
    @sell_window.visible = false
    @sell_window.help_window = @help_window
    @number_window = Window_ShopNumber.new(0, 112)
    @number_window.active = false
    @number_window.visible = false
    @status_window = Window_ShopStatus.new(400, 112)
    @status_window.visible = false
    $game_variables[421] = 1 #ショップの買う売るやめる選択状態
    set_ringana_card_kouka #リングアナ効果を更新する
    
    #周回プレイ中であれば
    if $game_switches[860] == true
      #お気に入りチェンジを消費しないに変更(無限マークを表示するために)
      $data_items[141].consumable  = false
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    dispose_command_window
    @help_window.dispose
    @gold_window.dispose
    @dummy_window.dispose
    @buy_window.dispose
    @sell_window.dispose
    @number_window.dispose
    @status_window.dispose
    $game_switches[73] = false
    $game_variables[421] = 0 #ショップの状態を初期化
    $game_switches[1321] = false #矢印無スキンに切替
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    output_credit
    @help_window.update
    @command_window.update
    @gold_window.update
    @dummy_window.update
    @buy_window.update
    @sell_window.update
    @number_window.update
    @status_window.update
    if @command_window.active
      update_command_selection
    elsif @buy_window.active
      update_buy_selection
    elsif @sell_window.active
      update_sell_selection
    elsif @number_window.active
      update_number_input
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
    @gold_window.contents.blt(0-2, 0,  $tec_mozi,rect)
    mozi = $game_party.gold.to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @gold_window.contents.blt(16*(7-mozi.split(//u).size)-2, 32,  $tec_mozi,rect)

  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_command_window
    s1 = Vocab::ShopBuy
    s2 = Vocab::ShopSell
    s3 = Vocab::ShopCancel
    @command_window = Window_Command.new(640, [s1, s2, s3], 3)
    @command_window.y = 112
    if $game_temp.shop_purchase_only
      @command_window.draw_item(1, false)
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの解放
  #--------------------------------------------------------------------------
  def dispose_command_window
    @command_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_command_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      @help_window.contents.clear
      #説明表示
      picture = Cache.picture("顔カード")
      rect = Rect.new($game_variables[40]*64, 64*18, 64, 64)
      @help_window.contents.blt(8,0,picture,rect)
      text = "それでは　きをつけて　いくのじゃぞ"
      put_help_text text
      
      Graphics.wait(40)
      Graphics.fadeout(30)
      $scene = Scene_Map.new
    elsif Input.trigger?(Input::C)
      case @command_window.index
      when 0  # 購入する
        Sound.play_decision
        @command_window.active = false
        @dummy_window.visible = false
        @buy_window.active = true
        @buy_window.visible = true
        @buy_window.refresh
        @status_window.visible = true
        $game_switches[73] = false
        $game_variables[421] = 2 #買う状態
      when 1  # 売却する
        if $game_temp.shop_purchase_only
          Sound.play_buzzer
        else
          Sound.play_decision
          @command_window.active = false
          @dummy_window.visible = false
          @sell_window.active = true
          @sell_window.visible = true
          @sell_window.refresh
          #$game_switches[73] = false
          $game_variables[421] = 3 #売る状態
        end
      when 2  # やめる
        Sound.play_decision
        @help_window.contents.clear
        #説明表示
        picture = Cache.picture("顔カード")
        rect = Rect.new($game_variables[40]*64, 64*18, 64, 64)
        @help_window.contents.blt(8,0,picture,rect)
        text = "それでは　きをつけて　いくのじゃぞ"
        put_help_text text
        Graphics.wait(40)
        Graphics.fadeout(30)
        $scene = Scene_Map.new
      end
    end
    @help_window.contents.clear
    #説明表示
    picture = Cache.picture("顔カード")
    rect = Rect.new($game_variables[40]*64, 64*18, 64, 64)
    @help_window.contents.blt(8,0,picture,rect)
    text =
      "ここは　おたすけカードの　みせじゃ
      おたすけカードと　クレジットを
      とりひきしてやるぞい"
    put_help_text text
  end
  #--------------------------------------------------------------------------
  # ● 購入アイテム選択の更新
  #--------------------------------------------------------------------------
  def update_buy_selection
    @status_window.item = @buy_window.item
    if Input.trigger?(Input::B)
      Sound.play_cancel
      @command_window.active = true
      @dummy_window.visible = true
      @buy_window.active = false
      @buy_window.visible = false
      @status_window.visible = false
      @status_window.item = nil
      @help_window.set_text("")
      $game_switches[73] = true
      $game_variables[421] = 1 #買う売る辞める選択状態
      return
    end
    if Input.trigger?(Input::C)
      @item = @buy_window.item
      number = $game_party.item_number(@item)
      
      if $data_items[@item.id].element_set.index(5)
        #Sランク
        tmp_max_item_card_num = $game_variables[224]
      elsif $data_items[@item.id].element_set.index(6)
        #Aランク
        tmp_max_item_card_num = $game_variables[225]
      elsif $data_items[@item.id].element_set.index(7)
        #Bランク
        tmp_max_item_card_num = $game_variables[226]
      elsif $data_items[@item.id].element_set.index(8)
        #Cランク
        tmp_max_item_card_num = $game_variables[227]
      else
        tmp_max_item_card_num = 1
      end
      
      if @item == nil or @item.price > $game_party.gold or number == tmp_max_item_card_num
        Sound.play_buzzer
      else
        Sound.play_decision
        max = @item.price == 0 ? $max_item_card_num : $game_party.gold / @item.price
        max = [max, tmp_max_item_card_num - number].min
        @buy_window.active = false
        @buy_window.visible = false
        @number_window.set(@item, max, @item.price)
        @number_window.active = true
        @number_window.visible = true
        
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 売却アイテム選択の更新
  #--------------------------------------------------------------------------
  def update_sell_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      @command_window.active = true
      @dummy_window.visible = true
      @sell_window.active = false
      @sell_window.visible = false
      @status_window.item = nil
      $game_switches[73] = true
      $game_variables[421] = 1 #買う売る辞める選択状態
      @help_window.set_text("")
    elsif Input.trigger?(Input::C)
      @item = @sell_window.item
      @status_window.item = @item
      if @item == nil or @item.price == 0
        Sound.play_buzzer
      else
        Sound.play_decision
        max = $game_party.item_number(@item)
        @sell_window.active = false
        @sell_window.visible = false
        @number_window.set(@item, max, @item.price / 2)
        @number_window.active = true
        @number_window.visible = true
        @status_window.visible = true
        
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 個数入力の更新
  #--------------------------------------------------------------------------
  def update_number_input
    if Input.trigger?(Input::B)
      cancel_number_input
    elsif Input.trigger?(Input::C)
      decide_number_input
    end
  end
  #--------------------------------------------------------------------------
  # ● 個数入力のキャンセル
  #--------------------------------------------------------------------------
  def cancel_number_input
    Sound.play_cancel
    @number_window.active = false
    @number_window.visible = false
    case @command_window.index
    when 0  # 購入する
      @buy_window.active = true
      @buy_window.visible = true
    when 1  # 売却する
      @sell_window.active = true
      @sell_window.visible = true
      @status_window.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 個数入力の決定
  #--------------------------------------------------------------------------
  def decide_number_input
    Sound.play_shop
    @number_window.active = false
    @number_window.visible = false
    case @command_window.index
    when 0  # 購入する
      $game_party.lose_gold(@number_window.number * @item.price)
      $game_variables[212] += (@number_window.number * @item.price)
      $game_party.gain_item(@item, @number_window.number)
      $game_variables[220] += 1 #カード購入回数
      @gold_window.refresh
      @buy_window.refresh
      @status_window.refresh
      @buy_window.active = true
      @buy_window.visible = true
    when 1  # 売却する
      $game_party.gain_gold(@number_window.number * (@item.price / 2))
      $game_variables[211] += (@number_window.number * (@item.price / 2))
      $game_party.lose_item(@item, @number_window.number)
      $game_variables[221] += 1 #カード売却回数
      @gold_window.refresh
      @sell_window.refresh
      @status_window.refresh
      @sell_window.active = true
      @sell_window.visible = true
      @status_window.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● ヘルプの出力
  # 引数:[text:出力する文字列]
  #--------------------------------------------------------------------------
  def put_help_text text
    y = 0
    text.each_line {|line| #改行を読み取り複数行表示する
      line.sub!("￥n", "") # ￥は半角に直す
      line = line.gsub("\r", "")#改行コード？が文字化けするので削除
      line = line.gsub("\n", "")#
      line = line.gsub(" ", "")#
      mozi = line
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @help_window.contents.blt(112, y*24, $tec_mozi,rect)
      #@help_window.contents.draw_text(112, y, 370, 40, line)
      y += 1#24
      }
  end
end
