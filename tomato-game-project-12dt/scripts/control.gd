extends Control


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")


func _on_options_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/optn_menu.tscn")
