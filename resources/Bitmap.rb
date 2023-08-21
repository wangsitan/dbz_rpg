=begin
 Bitmapクラスの拡張 ～ Ver 0.1.2.1までに同封されてた画像連結計メソッド
　　　　　　　　by 半生
http://www11.atpages.jp/namahanka/

　はっきり言って微妙

=end

class Bitmap
  # 画像連結系の入力チェック
  def chk_connect(bitmap)
    if self.disposed?
      text  = "Bitmap\#join_right: \n"
      text += "このビットマップは既に解放されています。"
      raise(text)
    end
    if !bitmap.is_a?(Bitmap)
      text  = "Bitmap\#join_right: \n"
      text += "ビットマップ以外のものが指定されました。\n"
      text += "#{bitmap.class}"
      raise(text)
    end
    if bitmap.disposed?
      text  = "Bitmap\#join_right: \n"
      text += "指定されたビットマップは既に解放されています。\n"
      text += "#{bitmap.class}"
      raise(text)
    end
    return true
  end
  private :chk_connect

  # 右に別の画像を連結したBitmapを返す
  def connect_right(d_bitmap, valign=0)
    chk_connect(d_bitmap)
    width = self.width + d_bitmap.width
    height = [self.height, d_bitmap.height].max
    bitmap = Bitmap.new(width, height)
    bitmap.clear
    case valign
    when 1
      s_y = (height - self.height) / 2
      d_y = (height - d_bitmap.height) / 2
    when 2
      s_y = height - self.height
      d_y = height - d_bitmap.height
    else
      s_y = 0
      d_y = 0
    end
    bitmap.blt(0, s_y, self, self.rect)
    bitmap.blt(self.width, d_y, d_bitmap, d_bitmap.rect)
    return bitmap
  end

  # 左に別の画像を連結したBitmapを返す
  def connect_left(d_bitmap, valign=0)
    chk_connect(d_bitmap)
    width = self.width + d_bitmap.width
    height = [self.height, d_bitmap.height].max
    bitmap = Bitmap.new(width, height)
    bitmap.clear
    case valign
    when 1
      s_y = (height - self.height) / 2
      d_y = (height - d_bitmap.height) / 2
    when 2
      s_y = height - self.height
      d_y = height - d_bitmap.height
    else
      s_y = 0
      d_y = 0
    end
    bitmap.blt(0, d_y, d_bitmap, d_bitmap.rect)
    bitmap.blt(d_bitmap.width, s_y, self, self.rect)
    return bitmap
  end

  # 下に別の画像を連結したBitmapを返す
  def connect_bottom(d_bitmap, align=0)
    chk_connect(d_bitmap)
    width = [self.width + d_bitmap.width].max
    height = self.height + d_bitmap.height.max
    bitmap = Bitmap.new(width, height)
    bitmap.clear
    case align
    when 1
      s_x = (width - self.width) / 2
      d_x = (width - d_bitmap.width) / 2
    when 2
      s_x = width - self.width
      d_x = width - d_bitmap.width
    else
      s_x = 0
      d_x = 0
    end
    bitmap.blt(s_x, 0, self, self.rect)
    bitmap.blt(d_x, self.height, d_bitmap, d_bitmap.rect)
    return bitmap
  end

  # 上に別の画像を連結したBitmapを返す
  def connect_top(d_bitmap, align=0)
    chk_connect(d_bitmap)
    width = [self.width, d_bitmap.width].max
    height = self.height + d_bitmap.height
    bitmap = Bitmap.new(width, height)
    bitmap.clear
    case align
    when 1
      s_x = (width - self.width) / 2
      d_x = (width - d_bitmap.width) / 2
    when 2
      s_x = width - self.width
      d_x = width - d_bitmap.width
    else
      s_x = 0
      d_x = 0
    end
    bitmap.blt(d_x, 0, d_bitmap, d_bitmap.rect)
    bitmap.blt(s_x, d_bitmap.height, self, self.rect)
    return bitmap
  end
end
