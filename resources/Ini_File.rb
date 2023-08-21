#==============================================================================
# ■ Ini_File
#------------------------------------------------------------------------------
# 　iniファイルからのデータ読み出しを行うクラスです。
#   動作にはEasyConv(ＨＰにて別途配布)が必要です。
#==============================================================================

class Ini_File
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(filename)
    @filename = filename

  # ファイル存在チェック(見つからない場合は問答無用で終了する)
    unless FileTest.exist?(@filename)
      p sprintf("error/Ini_File -- iniファイルが見つかりません。")
      exit
    end
    
  # ファイルパスの設定(APIで使用)
    @filepath = File.expand_path("./") + "/" + @filename
    @filepath.gsub!(/(\/)/) { "\\" }
  # ファイルパスをS-JISに変換
    @filepath = EasyConv::u2s(@filepath)
  end
  #--------------------------------------------------------------------------
  # ● データの取得
  #--------------------------------------------------------------------------
  # section：セクション名
  # key    ：キー名
  # 返り値 ：キーの値を返す。データが存在しない場合は""。
  #--------------------------------------------------------------------------
  def get_profile(section,key)
  # API宣言
    get_prof = Win32API.new('kernel32', 'GetPrivateProfileStringA', %w(p p p p l p), 'l')

  # section,keyをSHIFT-JISに変換する
    section = EasyConv::u2s(section)
    key     = EasyConv::u2s(key)

  # APIを使用してキーを取得
    buffer = "\0" * 256
    get_prof.call(section, key, "", buffer, 255, @filepath)
  
  # バッファ内データをUTF-8に変換
    buffer = EasyConv::s2u(buffer)
    buffer.delete!("\0")
  
  # ""の場合はnilを返す
    buffer == "" ? buffer = nil : nil
    return buffer
  end
  #--------------------------------------------------------------------------
  # ● データの書出
  #--------------------------------------------------------------------------
  # section：セクション名
  # key    ：キー名
  # value  ：キーの値
  # 返り値 ：書き込み処理の成否
  #--------------------------------------------------------------------------
  def write_profile(section,key,value)
  # API宣言
    set_prof = Win32API.new('kernel32', 'WritePrivateProfileStringA', %w(p p p p), 'l')
  
  # section,key,valueをSHIFT-JISに変換する
    section = EasyConv::u2s(section)
    key     = EasyConv::u2s(key)
    value   = EasyConv::u2s(value)

  # APIを使用してキーを書き込み
    return set_prof.call(section, key, value, @filepath)
  end
end
