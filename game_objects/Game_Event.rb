#==============================================================================
# ■ Game_Event
#------------------------------------------------------------------------------
# 　イベントを扱うクラスです。条件判定によるイベントページ切り替えや、並列処理
# イベント実行などの機能を持っており、Game_Map クラスの内部で使用されます。
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :trigger                  # トリガー
  attr_reader   :list                     # 実行内容
  attr_reader   :starting                 # 起動中フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     map_id : マップ ID
  #     event  : イベント (RPG::Event)
  #--------------------------------------------------------------------------
  def initialize(map_id, event)
    super()
    @map_id = map_id
    @event = event
    @id = @event.id
    @erased = false
    @starting = false
    @through = true
    moveto(@event.x, @event.y)            # 初期位置に移動
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 起動中フラグのクリア
  #--------------------------------------------------------------------------
  def clear_starting
    @starting = false
  end
  #--------------------------------------------------------------------------
  # ● イベント起動
  #--------------------------------------------------------------------------
  def start
    return if @list.size <= 1                   # 実行内容が空？
    @starting = true
    lock if @trigger < 3
    unless $game_map.interpreter.running?
      $game_map.interpreter.setup_starting_event
    end
  end
  #--------------------------------------------------------------------------
  # ● 一時消去
  #--------------------------------------------------------------------------
  def erase
    @erased = true
    refresh
  end
  #--------------------------------------------------------------------------
  # ● イベントページの条件合致判定
  #--------------------------------------------------------------------------
  def conditions_met?(page)
    c = page.condition
    if c.switch1_valid      # スイッチ 1
      return false if $game_switches[c.switch1_id] == false
    end
    if c.switch2_valid      # スイッチ 2
      return false if $game_switches[c.switch2_id] == false
    end
    if c.variable_valid     # 変数
      return false if $game_variables[c.variable_id] < c.variable_value
    end
    if c.self_switch_valid  # セルフスイッチ
      key = [@map_id, @event.id, c.self_switch_ch]
      return false if $game_self_switches[key] != true
    end
    if c.item_valid         # アイテム
      item = $data_items[c.item_id]
      return false if $game_party.item_number(item) == 0
    end
    if c.actor_valid        # アクター
      actor = $game_actors[c.actor_id]
      return false unless $game_party.members.include?(actor)
    end
    return true   # 条件合致
  end
  #--------------------------------------------------------------------------
  # ● イベントページのセットアップ
  #--------------------------------------------------------------------------
  def setup(new_page)
    @page = new_page
    if @page == nil
      @tile_id = 0
      @character_name = ""
      @character_index = 0
      @move_type = 0
      @through = true
      @trigger = nil
      @list = nil
      @interpreter = nil
    else
      @tile_id = @page.graphic.tile_id
      @character_name = @page.graphic.character_name
      @character_index = @page.graphic.character_index
      if @original_direction != @page.graphic.direction
        @direction = @page.graphic.direction
        @original_direction = @direction
        @prelock_direction = 0
      end
      if @original_pattern != @page.graphic.pattern
        @pattern = @page.graphic.pattern
        @original_pattern = @pattern
      end
      @move_type = @page.move_type
      @move_speed = @page.move_speed
      @move_frequency = @page.move_frequency
      @move_route = @page.move_route
      @move_route_index = 0
      @move_route_forcing = false
      @walk_anime = @page.walk_anime
      @step_anime = @page.step_anime
      @direction_fix = @page.direction_fix
      @through = @page.through
      @priority_type = @page.priority_type
      @trigger = @page.trigger
      @list = @page.list
      @interpreter = nil
      if @trigger == 4                       # トリガーが [並列処理] の場合
        @interpreter = Game_Interpreter.new  # 並列処理用インタプリタを作成
      end
    end
    update_bush_depth
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    new_page = nil
    unless @erased                          # 一時消去されていない場合
      for page in @event.pages.reverse      # 番号の大きいページから順に
        next unless conditions_met?(page)   # 条件合致判定
        new_page = page
        break
      end
    end
    if new_page != @page            # イベントページが変わった？
      clear_starting                # 起動中フラグをクリア
      setup(new_page)               # イベントページをセットアップ
      check_event_trigger_auto      # 自動イベントの起動判定
    end
  end
  #--------------------------------------------------------------------------
  # ● 接触イベントの起動判定
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    return if $game_map.interpreter.running?
    if @trigger == 2 and $game_player.pos?(x, y)
      start if not jumping? and @priority_type == 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 自動イベントの起動判定
  #--------------------------------------------------------------------------
  def check_event_trigger_auto
    start if @trigger == 3
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    check_event_trigger_auto                    # 自動イベントの起動判定
    if @interpreter != nil                      # 並列処理が有効
      unless @interpreter.running?              # 実行中でない場合
        @interpreter.setup(@list, @event.id)    # セットアップ
      end
      @interpreter.update                       # インタプリタを更新
    end
  end
end
