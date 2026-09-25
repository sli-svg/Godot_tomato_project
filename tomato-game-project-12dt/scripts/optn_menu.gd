extends Control


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
