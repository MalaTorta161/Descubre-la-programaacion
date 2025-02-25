extends Node

#preload obstacles
var Tocon_escena = preload("res://Juego/Enemigos/Tocon/tocon.tscn")
var Roca_escena = preload("res://Juego/Enemigos/Roca/roca.tscn")
var Barril_escena = preload("res://Juego/Enemigos/Barril/barril.tscn")
var Pajaro_escena = preload("res://Juego/Enemigos/Pajaro/pajaro.tscn")
var obstacle_types := [Tocon_escena, Roca_escena, Barril_escena]
var obstacles : Array
var pajaro_altura := [200,390]

#game variables
const DINO_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)
var score : int
const SCORE_MODIFIER : int = 10
var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
const SPEED_MODIFIER : int = 5000
var screen_size : Vector2i
var game_running : bool
var last_obs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	new_game()


func new_game():
	#reset variables
	score = 0
	show_score()
	game_running = false
	
	
	#reset the nodes
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Suelo.position = Vector2i(0, 0)
	
	#reset hud
	$HUD.get_node("Presionar para empezar").show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		#generar obstaculos
		generate_obs()
		
		#move dino and camera
		$Dino.position.x += speed
		$Camera2D.position.x += speed
		
		#update score
		score += speed
		show_score()
		
		#update ground position
		if $Camera2D.position.x - $Suelo.position.x > screen_size.x * 1.5:
			$Suelo.position.x += screen_size.x
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("Presionar para empezar").hide()

func generate_obs():
	#generar obstaculos suelo
	if obstacles.is_empty():
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
	
func show_score():
	$HUD.get_node("Marca").text = "SCORE: " + str(score / SCORE_MODIFIER)
