#==============================================================================
# ■ Window_Item
#------------------------------------------------------------------------------
# 　アイテム画面などで、所持アイテムの一覧を表示するウィンドウです。
#==============================================================================

class Window_Item < Window_Selectable
  include Icon
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x      : ウィンドウの X 座標
  #     y      : ウィンドウの Y 座標
  #     width  : ウィンドウの幅
  #     height : ウィンドウの高さ
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @column_max = 3
    @putloop_count = 0
    self.index = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● アイテムをリストに含めるかどうか
  #     item : アイテム
  #--------------------------------------------------------------------------
  def include?(item)
    return false if item == nil
    if $game_temp.in_battle
      return false unless item.is_a?(RPG::Item)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● アイテムを許可状態で表示するかどうか
  #     item : アイテム
  #--------------------------------------------------------------------------
  def enable?(item)
    return $game_party.item_can_use?(item)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for item in $game_party.items
      next unless include?(item)
      @data.push(item)
      if item.is_a?(RPG::Item) and item.id == $game_party.last_item_id
        self.index = @data.size - 1
      end
    end
    @data.push(nil) if include?(nil)
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
    
    #ループカウント初期化
    $put_item_loop_count = 0
    
=begin
    @@possession_card_num = 0
    @@possession_card_id = [nil]
    @@possession_card_motoid = [nil]
    @temp_possession_card_num = 0
    @temp_possession_card_id = [nil]
    @temp_possession_card_order_id = [nil]
    #とりあえず格納
    for i in 0...@item_max
      @temp_possession_card_num += 1
      @temp_possession_card_id[@temp_possession_card_num] = @data[i].id
      @temp_possession_card_order_id[@temp_possession_card_num] = @data[i].speed

    end
    #並び替え
    for x in 1..$data_items.size-1
      for z in 1..@temp_possession_card_num
        
        if x == @temp_possession_card_order_id[z]
          @@possession_card_num += 1
          @@possession_card_id[@@possession_card_num] = @temp_possession_card_id[z]
          @@possession_card_motoid[@@possession_card_num] = z
        end
      end
    end
    
    for i in 1..@@possession_card_num
      draw_item(@@possession_card_id[i])
    end
    
    #ループカウント初期化
    $put_item_loop_count = 0
=end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)

    self.contents.clear_rect(rect)
    item = @data[index]
    if item != nil
      $put_item_loop_count += 1
      number = $game_party.item_number(item)
      enabled = enable?(item)
      rect.width -= 4
      #rect.width -= 16
    
      #アイテム名
      #case @putloop_count % 3
      case index % 3
      
      when 0 #1列目
        draw_item_name(item, rect.x-12+8+2, rect.y, enabled)
      when 1 #2列目
        draw_item_name(item, rect.x-12+8+2-16+8, rect.y, enabled)
      when 2 #3列目
        draw_item_name(item, rect.x-12+8+2-16, rect.y, enabled)
      end
      #draw_item_name(item, rect.x-12-8, rect.y, enabled)
      #self.contents.draw_text(rect, sprintf(":%2d", number), 2)
      
      #所持数
      if $game_switches[72] == true
          mozi = "：" 
          mozi += "　" if number.to_s.size == 1 
      else
          mozi = "　：" 
      end
        
      if $data_items[item.id].consumable == false
        mozi += "無限"
      else
        mozi +=  number.to_s
      end
      output_mozi mozi
      
      rect1 = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      #p rect.x
      #if rect.x < 0
        #case @putloop_count % 3
        case index % 3
      
        when 0 #1列目
          self.contents.blt(rect.x+16*8+12+8+2, rect.y,  $tec_mozi,rect1)
        when 1 #2列目
          self.contents.blt(rect.x+16*8+12+8+2-16+8, rect.y,  $tec_mozi,rect1)
        when 2 #3列目
          self.contents.blt(rect.x+16*8+12+8+2-16, rect.y,  $tec_mozi,rect1)
        end
      #else
      #  self.contents.blt(rect.x+16*16, rect.y,  $tec_mozi,rect1)
      #end
      
      #
    end
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.contents.font.color = text_color(15)
    @help_window.contents.clear
    
    if item != nil
      picture = Cache.picture("顔カード")
      rect = put_icon item.id
      @help_window.contents.blt(8,0,picture,rect)
      #@help_window.set_text(item == nil ? "" : item.note)
      text = item.note
      y = 0
      text.each_line {|line| #改行を読み取り複数行表示する
        line.sub!("￥n", "") # ￥は半角に直す
        line = line.gsub("\r", "")#改行コード？が文字化けするので削除
        line = line.gsub("\n", "")#
        #@help_window.contents.draw_text(112, y, 370, 40, line)
        mozi = line
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @help_window.contents.blt(112, y*24, $tec_mozi,rect)
        y += 1#24
      }
      
        
      #カードランク表示
      picture = Cache.picture("数字英語")
      
      #for z in 0..3
      #rect = Rect.new(192+z*16, 16, 16, 16)
      #@help_window.contents.blt(74,0+z*16-2,picture,rect)
      #end
      tmp_set_posi = 0
      if $data_items[item.id.to_i].element_set.index(5)
        #Sランク
        tmp_set_posi = 0
      elsif $data_items[item.id.to_i].element_set.index(6)
        #Aランク
        tmp_set_posi = 1
      elsif $data_items[item.id.to_i].element_set.index(7)
        #Bランク
        tmp_set_posi = 2
      elsif $data_items[item.id.to_i].element_set.index(8)
        #Cランク
        tmp_set_posi = 3
      else
        tmp_set_posi = 9
      end
      if tmp_set_posi == 9
        #for z in 0..3
        #rect = Rect.new(256+z*16, 16, 16, 16)
        #@help_window.contents.blt(74,0+z*16-2,picture,rect)
        #end
      else
        rect = set_card_frame 11,tmp_set_posi
        #rect = Rect.new(256+tmp_set_posi*16, 16, 16, 16)
        @help_window.contents.blt(74,0+tmp_set_posi*16-2,picture,rect)
      end
      
      #使用箇所表示
      picture = Cache.picture("カード関係")
      rect = set_card_frame 10
      @help_window.contents.blt(0,64,picture,rect)
      #color = Color.new(@explanation_window.get_back_window_color)
      case item.occasion
      
      when 1
        @help_window.contents.fill_rect(48,64,48,16,@help_window.get_back_window_color)
      when 2
        @help_window.contents.fill_rect(0,64,48,16,@help_window.get_back_window_color)
      when 3
        @help_window.contents.fill_rect(0,64,96,16,@help_window.get_back_window_color)
      end



    end
  end

end
