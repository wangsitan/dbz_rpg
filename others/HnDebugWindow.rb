=begin
############################################
 HnDebugWindow
　　Ver 0.0.0.4
　　　　　　　　by 半生
http://www.tktkgame.com

 RPGツクールXP/VX共用
 別ウィンドウに文字列を表示します。


 ■ 注意
 　このスクリプトの他に"hn_dwin.dll"が必要になります。

############################################
=end

=begin
module HnDebugWindow
  DLL_NAME = 'hn_dwin'
  @@show     = Win32API.new(DLL_NAME, 'Show', 'v', 'i')
  @@hide     = Win32API.new(DLL_NAME, 'Hide', 'v', 'i')
  @@destory  = Win32API.new(DLL_NAME, 'Destroy', 'v', 'i')
  @@opened   = Win32API.new(DLL_NAME, 'Opened', 'v', 'i')
  @@dwprint  = Win32API.new(DLL_NAME, 'DwPrintA', 'i p', 'i')
  @@dwprint2 = Win32API.new(DLL_NAME, 'DwPrint2A', 'i p I I I', 'i')
  @@clear    = Win32API.new(DLL_NAME, 'Clear', 'v', 'i')
  @@getHWND  = Win32API.new(DLL_NAME, 'GetHWND', 'v', 'n')

  # ウィンドウ生成・隠れてるだけなら表示のみ
  def self.show
    @@show.call();
  end
  
  # ウィンドウを隠す
  def self.hide
    @@hide.call();
  end
  
  # ウィンドウを閉じてログ等も破棄
  def self.destroy
    @@destroy.call();
  end
  
  # 表示状態かどうか
  def self.opened?
    return (@@opened.call() != 0 );
  end
  
  # デバッグウィンドウに文字を出力
  def self.dwprint(str)
    text=str.to_s.gsub("\n","\r\n")
    @@dwprint.call(text.size, text)
  end
  
  # ツクールのウィンドウハンドル
  def self.getHWND
    @@getHWND.call();
  end
  
  # デバッグウィンドウに文字を出力（色、サイズその他付き）
  def self.dwprint2(str, *option)
    size = 20
    color = [255,255,255]
    effect = 0
    if option.size==1 and option[0].is_a?(Hash)
      hoption = option[0]
      if hoption.key?(:size)
        size = hoption[:size]
      end
      if hoption.key?(:color)
        if ( hoption[:color].is_a?(Array) )
          color = hoption[:color]
        elsif ( hoption[:color].is_a?(Color) )
          color = [hoption[:color].red_to_i, hoption[:color].green.to_i, hoption[:color].blue.to_i]
        end
      end
      effect += 1 if (hoption[:bold] == true)
      effect += 2 if (hoption[:italic] == true)
      effect += 4 if (hoption[:strike] == true)
      effect += 8 if (hoption[:underline] == true)
    elsif option.size > 0
      color[2] = option[3] if option[3].is_a?(Fixnum)
      color[1] = option[2] if option[2].is_a?(Fixnum)
      color[0] = option[1] if option[1].is_a?(Fixnum)
      size = option[0] if option[0].is_a?(Fixnum)
    end

    text=str.to_s.gsub("\n","\r\n")
    @@dwprint2.call(text.size, text, colorref(*color), size, effect )
  end
  
  # ログの消去
  def self.clear
    return @@clear.call();
  end

  def self.colorref(red, green, blue)
    (blue&0xFF) * 0x10000 + (green&0xFF)* 0x100 + (red&0xFF)
  end
  
end


def dp(str)
  HnDebugWindow.dwprint(str.to_s + "\n")
  return nil
end
def dp2(obj)
  HnDebugWindow.dwprint(obj.inspect + "\n")
  return nil
end
alias __p p unless Module.method_defined?(:__p)
# ※ 通常のp命令をデバッグウィンドウに表示するように置き換えます。
# 不要な場合は下の行をコメントアウト(先頭に#追加)してください
alias p dp2

def dprint(str)
  HnDebugWindow.dwprint(str)
  return nil
end

def dprint2(str,*args)
  HnDebugWindow.dwprint2(str,*args)
  return nil
end

=end