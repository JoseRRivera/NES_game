
.segment "ZEROPAGE"
player_x: .res 1
player_y: .res 1
player_dir: .res 1
player_state: .res 1
frame_rate_controller: .res 1
controller_info: .res 1
scroll: .res 1
ppuctrl_settings: .res 1
stage: .res 1
offset_high: .res 1
offset_low: .res 1
mega_x: .res 1
mega_y: .res 1
tile_offset: .res 1
left_or_right: .res 1
switch_stage: .res 1
.exportzp player_x, player_y, player_dir, player_state
.exportzp frame_rate_controller, controller_info
.exportzp stage, offset_high, offset_low, mega_x, mega_y, tile_offset, left_or_right
.exportzp switch_stage, ppuctrl_settings, scroll