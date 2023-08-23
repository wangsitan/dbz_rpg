#==============================================================================
# ■ Scene_Story_So_Far
#------------------------------------------------------------------------------
# 　あらすじ表示
#==============================================================================
class Scene_templete < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize()

  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    Graphics.fadein(0)
    #@message_window = Window_Message.new
    #@msg_output_end = false
    #メッセージ表示
    #text_list=[]
    #text = nil
    #x = 0
    #if @msg_output_end == false
    #  text.each_line {|line| #改行を読み取り複数行表示する
    #    line.sub!("￥n", "") # ￥は半角に直す
    #    line = line.gsub("\r", "")#改行コード？が文字化けするので削除
    #    line = line.gsub("\n", "")#
    #    line = line.gsub(" ", "")#半角スペースも削除
    #    text_list[x]=line
    #    x += 1
    #    }
    #    put_message text_list
    #    @msg_output_end = true
    #end
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super

  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    
    if Input.trigger?(Input::B)
        
    end  

    if Input.trigger?(Input::C)

    end
    
    if Input.trigger?(Input::DOWN)

    end
    if Input.trigger?(Input::UP)

    end
    if Input.trigger?(Input::RIGHT)

    end
    if Input.trigger?(Input::LEFT)

    end
    #@message_window.update            # メッセージウィンドウを更新
  end
  #--------------------------------------------------------------------------
  # ● 文章の表示
  #引数：[text:表示内容,position:ウインドウ表示位置]
  #--------------------------------------------------------------------------
  def put_message text,position = 1
    unless $game_message.busy
      #$game_message.face_name = ""
      #$game_message.face_index = 0
      #$game_message.background = 0         #背景 0:通常 1:背景暗く 2:透明
      $game_message.position = position
      for x in 0..text.size - 1 
        $game_message.texts.push(text[x])
      end
      set_message_waiting                   # メッセージ待機状態にする
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● メッセージ待機中フラグおよびコールバックの設定
  #--------------------------------------------------------------------------
  def set_message_waiting
    @message_waiting = true
    $game_message.main_proc = Proc.new { @message_waiting = false }
  end
end