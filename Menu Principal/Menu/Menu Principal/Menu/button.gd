extends Button
@onready var audio_stream_player_4: AudioStreamPlayer = $AudioStreamPlayer4



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	audio_stream_player_4.playing = true
	pass # Replace with function body.
