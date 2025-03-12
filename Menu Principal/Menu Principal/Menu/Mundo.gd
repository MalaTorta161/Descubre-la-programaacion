extends Node2D


func _on_button_pressed():
	
	get_tree().change_scene_to_file("res://Juego/Principal/principal.tscn")
	




func _on_button_2_pressed():
	
	get_tree().change_scene_to_file("res://Menu Principal/controles/controles.tscn")
	


func _on_button_3_pressed(): 
	get_tree().change_scene_to_file("res://Menu Principal/creditos/creditos.tscn")
