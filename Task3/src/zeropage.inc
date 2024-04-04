
.segment "ZEROPAGE"
player_x: .res 1
player_y: .res 1
player_dir: .res 1
player_state: .res 1
frame_rate_controller: .res 1
controller_info: .res 1
.exportzp player_x, player_y, player_dir, player_state
.exportzp frame_rate_controller, controller_info