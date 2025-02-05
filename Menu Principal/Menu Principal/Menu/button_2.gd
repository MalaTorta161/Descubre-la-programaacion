extends Button
@onready var audio_stream_player_3: AudioStreamPlayer = $AudioStreamPlayer3



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass








func _on_button_down() -> void:
	audio_stream_player_3.playing = true
	pass # Replace with function body.
