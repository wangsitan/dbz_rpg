#==============================================================================
# ■ EasyConv module - Ver 0.90
#------------------------------------------------------------------------------
# 　文字コード簡易変換モジュール。
#   コードは「Dante98とかのページ」に掲載されたものを流用しています。
#------------------------------------------------------------------------------
# 注意！).当モジュールに関するバグ報告、質問等は「Dante98とかのページ」管理人の
#         郵便はみがき氏ではなく、下記の連絡先までお願いします。
#------------------------------------------------------------------------------
# ＨＰ  ：Moonlight INN
# ＵＲＬ：http://cgi.members.interq.or.jp/aquarius/rasetsu/
# 管理人：RaTTiE
# e-mail：rasetsu@aquarius.interq.or.jp
#--- 簡易リファレンス ---------------------------------------------------------
# EasyConv::s2u(text) : S-JIS -> UTF-8
# EasyConv::u2s(text) : UTF-8 -> S-JIS
#==============================================================================
module EasyConv
  # API用定数定義
    CP_ACP = 0
    CP_UTF8 = 65001

  #--------------------------------------------------------------------------
  # ● S-JIS -> UTF-8
  #--------------------------------------------------------------------------
  def s2u(text)
  # API定義
    m2w = Win32API.new('kernel32', 'MultiByteToWideChar', 'ilpipi', 'i')
    w2m = Win32API.new('kernel32', 'WideCharToMultiByte', 'ilpipipp', 'i')

  # S-JIS -> Unicode
    len = m2w.call(CP_ACP, 0, text, -1, nil, 0);
    buf = "\0" * (len*2)
    m2w.call(CP_ACP, 0, text, -1, buf, buf.size/2);

  # Unicode -> UTF-8
    len = w2m.call(CP_UTF8, 0, buf, -1, nil, 0, nil, nil);
    ret = "\0" * len
    w2m.call(CP_UTF8, 0, buf, -1, ret, ret.size, nil, nil);
    
    return ret
  end
  # module_functionとして公開
  module_function :s2u
  #--------------------------------------------------------------------------
  # ● UTF-8 -> S-JIS
  #--------------------------------------------------------------------------
  def u2s(text)
  # API定義
    m2w = Win32API.new('kernel32', 'MultiByteToWideChar', 'ilpipi', 'i')
    w2m = Win32API.new('kernel32', 'WideCharToMultiByte', 'ilpipipp', 'i')

  # UTF-8 -> Unicode
    len = m2w.call(CP_UTF8, 0, text, -1, nil, 0);
    buf = "\0" * (len*2)
    m2w.call(CP_UTF8, 0, text, -1, buf, buf.size/2);

  # Unicode -> S-JIS
    len = w2m.call(CP_ACP, 0, buf, -1, nil, 0, nil, nil);
    ret = "\0" * len
    w2m.call(CP_ACP, 0, buf, -1, ret, ret.size, nil, nil);
    
    return ret
  end
  # module_functionとして公開
  module_function :u2s
end
