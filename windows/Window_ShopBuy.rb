#==============================================================================
# ■ Window_ShopBuy
#------------------------------------------------------------------------------
# 　ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_ShopBuy < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  include Icon
  include Share
  def initialize(x, y)
    super(x, y, 400, 368)
    @shop_goods = $game_temp.shop_goods
    refresh
    self.index = 0
    
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for goods_item in @shop_goods
      case goods_item[0]
      when 0
        item = $data_items[goods_item[1]]
      when 1
        #item = $data_weapons[goods_item[1]]
      when 2
        #item = $data_armors[goods_item[1]]
      end
      if item != nil
        @data.push(item)
      end
    end
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    number = $game_party.item_number(item)
    enabled = (item.price <= $game_party.gold and number < 99)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    draw_item_name(item, rect.x - 2, rect.y, enabled)
    
    rect.width -= 4
    #self.contents.draw_text(rect, item.price, 2)
    mozi = item.price.to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    self.contents.blt(356-16*mozi.split(//u).size, index*24,  $tec_mozi,rect)


  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.contents.font.color = text_color(15)
    @help_window.contents.clear

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
      @help_window.contents.blt(74,0+tmp_set_posi*16-2,picture,rect)
    end
  end

end
