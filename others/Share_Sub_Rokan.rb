=begin
      RGSS3
      
      ★マップ一時停止★

      マップ上で指定キーを押すことで一時停止状態にすることができます。
      イベントも停止させることができます。
      
      ● 注意 ●==========================================================
      「STOP_BACK」という名前の画像ファイルをSystemフォルダの中にインポート
      しておいてください。
      ====================================================================
      
      ver1.10

      Last Update : 2012/01/19
      01/19 : 一時停止中はBGMとBGSの音量が少し下がるようにしました
      01/11 : RGSS2からの移植
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

#===========================================
#   設定箇所
#===========================================
module Rokan
module Game_Stop
  # 一時停止を許可するスイッチ番号
  STOP_SWICTH = 35
  # 一時停止に利用するキー
  # 扱えるキーはヘルプを参照してください
  STOP_KEY = :Z # キーボードのD
end
end
#===========================================
#   ここまで
#===========================================

$rsi ||= {}
$rsi["マップ一時停止"] = true

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● インクルード Rokan::Game_Stop
  #--------------------------------------------------------------------------
  include Rokan::Game_Stop
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias _start_with_stop start
  def start
    _start_with_stop
    @stop = false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias _update_with_stop update
  def update
    if @stop
      update_game_stop
    else
      _update_with_stop
      start_stop if Input.trigger?(STOP_KEY) && $game_switches[STOP_SWICTH]
    end
  end
  #--------------------------------------------------------------------------
  # ● 一時停止時のフレーム更新
  #--------------------------------------------------------------------------
  def update_game_stop
    Graphics.update
    Input.update
    end_stop if Input.trigger?(STOP_KEY)
  end
  #--------------------------------------------------------------------------
  # ● 一時停止時の開始
  #--------------------------------------------------------------------------
  def start_stop
    SceneManager.snapshot_for_background
    @last_bgm = RPG::BGM.last
    @last_bgs = RPG::BGS.last
    reduce_the_volume
    create_background
    @stop = true
  end
  #--------------------------------------------------------------------------
  # ● 一時停止時の終了
  #--------------------------------------------------------------------------
  def end_stop
    @last_bgm.play
    @last_bgs.play
    dispose_background
    @stop = false
  end
  #--------------------------------------------------------------------------
  # ● 背景の作成
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
    @stopback_sprite = Sprite.new
    @stopback_sprite.bitmap = Cache.system("STOP_BACK")
    @stopback_sprite.z = 300
  end
  #--------------------------------------------------------------------------
  # ● 背景の解放
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
    @stopback_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● 音量を抑える
  #--------------------------------------------------------------------------
  def reduce_the_volume
    stop_bgm = @last_bgm.dup
    stop_bgs = @last_bgs.dup
    stop_bgm.volume -= 30
    stop_bgs.volume -= 30
    stop_bgm.play
    stop_bgs.play
  end
end