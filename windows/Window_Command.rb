#==============================================================================
# ■ Window_Command
#------------------------------------------------------------------------------
# 　一般的なコマンド選択を行うウィンドウです。
#==============================================================================

class Window_Command < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :commands                 # コマンド
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     width      : ウィンドウの幅
  #     commands   : コマンド文字列の配列
  #     column_max : 桁数 (2 以上なら横選択)
  #     row_max    : 列数 (0:コマンド数に合わせる)
  #     spacing    : 横に項目が並ぶときの空白の幅
  #--------------------------------------------------------------------------
  def initialize(width, commands, column_max = 1, row_max = 0, spacing = 32)
    if row_max == 0
      row_max = (commands.size + column_max - 1) / column_max
    end
    super(0, 0, width, row_max * WLH + 32, spacing)
    @commands = commands
    @item_max = commands.size
    @column_max = column_max
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index   : 項目番号
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_item(index, enabled = true)
    rect = item_rect(index)
    rect.x += 4
    rect.width -= 8
    self.contents.clear_rect(rect)
    self.contents.font.color = text_color(15)
    self.contents.font.color.alpha = enabled ? 255 : 128
    #self.contents.draw_text(rect, @commands[index])
    mozi = @commands[index]
    #p mozi,index,rect.x,rect.width
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    if $game_switches[73] == true #横に並べる
      self.contents.blt(8+212*index,0-0,  $tec_mozi,rect)
    else
      self.contents.blt(18,index*24-0,  $tec_mozi,rect)
    end
  end
end
