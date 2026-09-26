extends Control


func _ready() -> void:
	hide()


func _on_pause_button_pressed() -> void:
	# Pause the game and display the pause menu.
	get_tree().paused = true
	show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	hide()


func _on_resume_button_pressed() -> void:
	# Resume the game and hide the pause menu.
	get_tree().paused = false
	hide()


func _on_restart_button_pressed() -> void:
	# Unpause the game before reloading the current scene.
	get_tree().paused = false
	get_tree().call_deferred("reload_current_scene")
	hide()


func _on_options_button_pressed() -> void:
	# Unpause the game before changing scenes.
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/optn_menu.tscn")
	hide()


func _on_main_menu_button_pressed() -> void:
	# Unpause the game before returning to the main menu.
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
	hide()
