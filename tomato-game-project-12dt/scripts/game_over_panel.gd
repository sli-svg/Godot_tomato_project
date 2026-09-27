extends Panel

@export_file("*.tscn") var main_menu_scene: String


func _ready() -> void:
	# Allow this UI to keep working when the game is paused.
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	# Hide the Game Over panel when the game starts.
	visible = false


func show_game_over() -> void:
	visible = true
	get_tree().paused = true


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	
	# Check that a Main Menu scene has been assigned.
	if main_menu_scene.is_empty():
		print("ERROR: Main Menu Scene is not assigned!")
		return
	
	# Check that the scene actually exists.
	if not ResourceLoader.exists(main_menu_scene):
		print("ERROR: Main Menu Scene does not exist!")
		return
	
	get_tree().change_scene_to_file(main_menu_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
