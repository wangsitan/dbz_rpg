=begin
############################################
 Bitmapクラスの拡張 (DLL版)
　　Ver 0.1.2.2
　　　　　　　　by 半生
http://www11.atpages.jp/namahanka/

 RPGツクールXP/VX共用
 Bitmapクラスに機能を追加します。


 ・Marshaldump可能に
 ・PNGファイルとして保存
 ・色調変更
 ・モザイク効果
 ・色の反転
 ・ぼかし効果
 ・マスクを用いた切り抜き
 ・ブレンディング

 ■ 注意
 　このスクリプトの他に"hn_rg_bitmap.dll"が必要になります。

############################################
 2010/03/24 ver 0.1.2.2
　ブレンディング機能関連の軽量化。
　画像連結系メソッドの分離。
 2010/03/24 ver 0.1.2.1
　ブレンディング機能関連のバグフィックス
 2010/03/22 ver 0.1.2.0
　加算合成等のブレンディング機能の追加
2010/02/07 ver 0.1.1.0
　マーシャル化の処理の一部をDLLに移動
2010/01/17 ver 0.1.0.0
　dllの名称を"hn_rx_bitmap.dll"から"hn_rg_bitmap.dll"に変更
　モザイク効果・色反転・ぼかし効果の追加
############################################
=end

module Hn_Rg_Bitmap
  DLL_NAME = 'hn_rg_bitmap'

  @@png_save = Win32API.new(DLL_NAME, 'PngSaveA', 'p n i i', 'i')
  @@blur = Win32API.new(DLL_NAME, 'Blur', 'n i', 'i')
  @@change_tone = Win32API.new(DLL_NAME, 'ChangeTone', 'n i i i i', 'i')
  @@clip_mask = Win32API.new(DLL_NAME, 'ClipMask', 'n n i i i', 'i')
  @@invert = Win32API.new(DLL_NAME, 'InvertColor', 'n', 'i')
  @@mosaic = Win32API.new(DLL_NAME, 'Mosaic', 'n i i i i i i', 'i')
  @@address = Win32API.new(DLL_NAME, 'GetAddress', 'n', 'n')
  @@get_pixel_data = Win32API.new(DLL_NAME, 'GetPixelData', 'n p i', 'i')
  @@set_pixel_data = Win32API.new(DLL_NAME, 'SetPixelData', 'n p i', 'i')
  @@blend_blt = Win32API.new(DLL_NAME, 'BlendBlt', 'n i i n i i i i i i', 'i')
  #@@get_hwnd = Win32API.new(DLL_NAME, 'GetGameHWND', 'v', 'l')
  module_function

  # PNG形式で保存
  def png_save(bitmap,file_name,compression_level,filter)
    return @@png_save.call(file_name, bitmap.object_id, compression_level, filter)
  end

  # ぼかし効果
  def blur(bitmap, r = 1)
    return @@blur.call(bitmap.object_id, r)
  end
  
  # カラーバランス変更？
  def change_tone(bitmap, red = 0, green = 0, blue = 0, simplify = 1)
    return @@change_tone.call(bitmap.object_id, red, green, blue, simplify)
  end

  # マスクによる画像の切り抜き（アルファとの乗算）
  def clip_mask(g_bitmap, m_bitmap, x=0, y=0, outer=0)
    return @@clip_mask.call(g_bitmap.object_id, m_bitmap.object_id, x, y, outer)
  end

  # 色の反転
  def invert(bitmap)
    return @@invert.call(bitmap.object_id)
  end

  # モザイク効果
  def mosaic(bitmap, msw=5, msh=5)
    return self.mosaic_rect(bitmap, bitmap.rect, msw, msh)
  end

  # モザイク効果（範囲指定）
  def mosaic_rect(bitmap, rect, msw=5, msh=5)
    return @@mosaic.call(bitmap.object_id,
    rect.x, rect.y, rect.width, rect.height, msw, msh)
  end

  # ビットマップデータのアドレスを取得
  def address(bitmap)
    return @@address.call(bitmap.object_id)
  end
  
  # ビットマップのバイナリデータを取得
  def get_pixel_data(bitmap)
    buffer = "bgra" * bitmap.width * bitmap.height
    @@get_pixel_data.call(bitmap.object_id, buffer, buffer.size)
    return buffer
  end
  
  # ビットマップのバイナリデータを置き換え
  def set_pixel_data(bitmap, data)
    return @@set_pixel_data.call(bitmap.object_id, data, data.size)
  end
  
  def blend_blt(dest_bmp, x, y, src_bmp, rect, blend_type=0, opacity=255)
    @@blend_blt.call(dest_bmp.object_id, x, y, src_bmp.object_id,
                rect.x, rect.y, rect.width, rect.height,
                blend_type, opacity)
  end
  
  
end

class Font
  def marshal_dump;end
  def marshal_load(obj);end
end
class Bitmap
  # PNG圧縮用フィルタ
  PNG_NO_FILTERS   = 0x00
  PNG_FILTER_NONE  = 0x08
  PNG_FILTER_SUB   = 0x10
  PNG_FILTER_UP    = 0x20
  PNG_FILTER_AVG   = 0x40
  PNG_FILTER_PAETH = 0x80
  PNG_ALL_FILTERS  = (PNG_FILTER_NONE | PNG_FILTER_SUB | PNG_FILTER_UP |
                      PNG_FILTER_AVG | PNG_FILTER_PAETH)

  # Marshal_dump
  def _dump(limit)
    return "" if self.disposed?
    data = Hn_Rg_Bitmap.get_pixel_data(self)
    [width, height, Zlib::Deflate.deflate(data)].pack("LLa*") # ついでに圧縮
  end
  
  # Marshal_load
  def self._load(str)
    if str == ""
      b = Bitmap.new(1,1)
      b.dispose
      return b
    end
    w, h, zdata = str.unpack("LLa*"); b = new(w, h)
    Hn_Rg_Bitmap.set_pixel_data(b, Zlib::Inflate.inflate(zdata))
    return b
  end  
  
  def address
    Hn_Rg_Bitmap.address(self)
  end

  # ぼかし効果
  def blur2(r=1)
    Hn_Rg_Bitmap.blur(self, r)
  end

  # 色調変更
  def change_tone(red, green, blue, simplify = 1)
    Hn_Rg_Bitmap.change_tone(self, red, green, blue, simplify)
  end
  
  # クリッピング
  def clip_mask(bitmap, x=0, y=0, outer=0)
    Hn_Rg_Bitmap.clip_mask(self, bitmap, x, y, outer)
  end

  # 色の反転
  def invert
    Hn_Rg_Bitmap.invert(self)
  end

  # モザイク効果
  def mosaic(msw=5, msh=5)
    Hn_Rg_Bitmap.mosaic(self, msw, msh)
  end

  # モザイク効果(領域指定)
  def mosaic_rect(rect=self.rect, msw=5, msh=5)
    Hn_Rg_Bitmap.mosaic_rect(self, rect, msw, msh)
  end

  # ブレンディング
  def blend_blt(x, y, src_bmp, rect, blend_type=0, opacity=255)
    return if opacity <= 0
    Hn_Rg_Bitmap.blend_blt(self, x, y, src_bmp, rect, blend_type, opacity)
  end

  #png形式で保存
  def png_save(outp, level = 9, filter = PNG_NO_FILTERS)
    if (Hn_Rg_Bitmap.png_save(self, outp, level, filter) != 0)
      raise("Bitmap\#png_save failed")
    end
  end
end
