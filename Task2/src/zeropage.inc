
.segment "ZEROPAGE"
UP_player_x: .res 1
UP_player_y: .res 1
UP_player_dir: .res 1
UP_player_state: .res 1
DOWN_player_x: .res 1
DOWN_player_y: .res 1
DOWN_player_dir: .res 1
DOWN_player_state: .res 1
LEFT_player_x: .res 1
LEFT_player_y: .res 1
LEFT_player_dir: .res 1
LEFT_player_state: .res 1
RIGHT_player_x: .res 1
RIGHT_player_y: .res 1
RIGHT_player_dir: .res 1
RIGHT_player_state: .res 1
frame_rate_controller: .res 1
.exportzp UP_player_x, UP_player_y, UP_player_dir, UP_player_state
.exportzp LEFT_player_x, LEFT_player_y, LEFT_player_dir, LEFT_player_state
.exportzp RIGHT_player_x, RIGHT_player_y, RIGHT_player_dir, RIGHT_player_state
.exportzp DOWN_player_x, DOWN_player_y, DOWN_player_dir, DOWN_player_state
.exportzp frame_rate_controller