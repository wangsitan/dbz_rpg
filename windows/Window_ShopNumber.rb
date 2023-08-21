#==============================================================================
# ■ Window_ShopNumber
#------------------------------------------------------------------------------
# 　ショップ画面で、購入または売却するアイテムの個数を入力するウィンドウです。
#==============================================================================

class Window_ShopNumber < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, 400, 368)
    @item = nil
    @max = 1
    @price = 0
    @number = 1
  end
  #--------------------------------------------------------------------------
  # ● アイテム、最大個数、価格の設定
  #--------------------------------------------------------------------------
  def set(item, max, price)
    @item = item
    @max = max
    @price = price
    @number = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 入力された個数の設定
  #--------------------------------------------------------------------------
  def number
    return @number
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    y = 54 #64 #96
    self.contents.clear
    draw_item_name(@item, 0-16, y)
    self.contents.font.color =  text_color(15)
    #self.contents.draw_text(212, y, 20, WLH, "×")
    mozi = "X"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    self.contents.blt(212, y,  $tec_mozi,rect)
    mozi = @number.to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    self.contents.blt(264-16*mozi.split(//u).size, y,  $tec_mozi,rect)
    #self.contents.draw_text(248, y, 20, WLH, @number, 2)

    if $data_items[@item.id].element_set.index(32)
      skillno = $data_items[@item.id].base_damage
      
      $skill_set_get_num[0][skillno] = 0 if $skill_set_get_num[0][skillno] == nil

      if $skill_set_get_num[0][skillno] >= 1
        mozi = "※このスキルは　すでにしゅとくずみだぞ！！※"
      else
        mozi = "※このスキルは　まだしゅとくしてないぞ！！※"
      end
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      self.contents.blt(8, y + 32 ,  $tec_mozi,rect)
       
      y = 64
      tyouseiy = 0
      #スキルの説明表示
      if skillno != 0
          mozi = "＊＊＊＊＊＊＊　スキルこうか　＊＊＊＊＊＊＊"
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          self.contents.blt(8, y + 80 - 32+tyouseiy,  $tec_mozi,rect)
        
          text_list=[]
          mozi = get_cha_skill_manual skillno
          text_list=text_Adjust mozi
          #p text_list

          for y2 in 0..text_list.size - 1
            #p 1,y,text_list[y2]
            output_mozi text_list[y2]
            #p 2,y,text_list[y2]
            rect = Rect.new(16*0,16*0, 16*text_list[y2].split(//u).size,24)
            self.contents.blt(8+16, y + 80 + 24 * y2+tyouseiy,  $tec_mozi,rect)
            #self.contents.blt(64-(16*text_list[y2].split(//u).size), y + 64 + 24 * y2,  $tec_mozi,rect)
          end
          mozi = "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          self.contents.blt(8, y + 80 + 24 * y2 + 32+tyouseiy ,  $tec_mozi,rect)
      end
    end
    
    #self.cursor_rect.set(244, y+4, 28, WLH)

    
    draw_currency_value(@price * @number, 4, y + WLH * 2, 264)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if self.active
      last_number = @number
      if Input.repeat?(Input::RIGHT) and @number < @max
        @number += 1
      end
      if Input.repeat?(Input::LEFT) and @number > 1
        @number -= 1
      end
      if Input.repeat?(Input::UP) and @number < @max
        @number = [@number + 10, @max].min
      end
      if Input.repeat?(Input::DOWN) and @number > 1
        @number = [@number - 10, 1].max
      end
      if @number > $max_item_card_num
        @number = $max_item_card_num
      end
      if @number != last_number
        Sound.play_cursor
        refresh
      end
      
      $cursor_blink_count += 1
      picture = Cache.picture("アイコン")
      rect = set_tate_cursor_blink

      self.contents.blt(246,56-10,picture,rect)
    end
  end
end
