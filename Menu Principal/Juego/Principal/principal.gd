extends Node


#cargar obstaculos
var Tocon_escena = preload("res://Juego/Enemigos/Tocon/tocon.tscn")
var Roca_escena = preload("res://Juego/Enemigos/Roca/roca.tscn")
var Barril_escena = preload("res://Juego/Enemigos/Barril/barril.tscn")
var Pajaro_escena = preload("res://Juego/Enemigos/Pajaro/pajaro.tscn")
var obstacle_types := [Tocon_escena, Roca_escena, Barril_escena]
var obstacles : Array
var pajaro_altura := [200,390]

#variables del juego
const DINO_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)
var difficulty
const MAX_DIFFICULTY : int = 2
var score : int
const SCORE_MODIFIER : int = 10
var high_score : int
var speed : float
const START_SPEED : float = 5.0
const MAX_SPEED : int = 25
const SPEED_MODIFIER : int = 5000
var screen_size : Vector2i
var ground_height : int
var game_running : bool
var last_obs

# funcion de la escena a primera vista
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Suelo.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()


func new_game():
	#resetear variables
	score = 0
	show_score()
	game_running = false
	get_tree().paused = false
	difficulty = 0
	
	#borrar obstaculos
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	#resetear nodos
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Suelo.position = Vector2i(0, 0)
	
	#pantalla del HUD y de game over
	$HUD.get_node("Presionar para empezar").show()
	$GameOver.hide()


func _process(_delta):
	if game_running:
		# velocidad y ajustar dificultad
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		
		#generar obstaculos
		generate_obs()
		
		#mover dino y camara
		$Dino.position.x += speed
		$Camera2D.position.x += speed
		
		#avance de la puntuacion 
		score += speed
		show_score()
		
		#posicion del suelo
		if $Camera2D.position.x - $Suelo.position.x > screen_size.x * 1.5:
			$Suelo.position.x += screen_size.x
			
		#quitar obstaculos que no estan en pantalla
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("Presionar para empezar").hide()

func generate_obs():
	#generar obstaculos suelo
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = difficulty + 1
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x : int = screen_size.x + score + 100 + (i * 100)
			var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
		# probabilidad de aparecer pajaro
		if difficulty == MAX_DIFFICULTY:
			if (randi() % 2) == 0:
				#generar pajaro obstaculo
				obs = Pajaro_escena.instantiate()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = pajaro_altura[randi() % pajaro_altura.size()]
				add_obs(obs, obs_x, obs_y)

func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free() 
	obstacles.erase(obs)
	
func hit_obs(body):
	if body.name == "Dino":
		game_over()


func show_score():
	$HUD.get_node("Marca").text = "MARCA: " + str(score / SCORE_MODIFIER)

func check_high_score():
	if score > high_score:
		high_score = score
		$HUD.get_node("Mejor marca").text = "HIGH SCORE: " + str(high_score / SCORE_MODIFIER)

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY: 
		difficulty = MAX_DIFFICULTY

func game_over():
	check_high_score()
	get_tree().paused = true
	game_running = false
	$GameOver.show()




func _on_button_pressed() -> void:
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://Menu Principal/Menu/mundo.tscn" )
