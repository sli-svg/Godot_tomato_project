extends Control


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_resume_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")


func _on_restart_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")
	get_tree().call_deferred("reload_current_scene")
	#test this later when the pause button is added to the UI in main.tscn


func _on_options_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/optn_menu.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
