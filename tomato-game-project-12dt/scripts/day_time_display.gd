extends Control


@onready var date_label: Label = %date_label
@onready var time_label: Label = %time_label

var hours: int = 0
var days: int = 1


func _ready() -> void:
	_refresh_display()
	
	
func _refresh_display() -> void:
	date_label.text = "Day " + str(days)
	time_label.text = _get_time_label()


func _get_time_label() -> String:
	var display_hour: int
	var meridian: String
	
	if hours == 0:
		display_hour = 12
		meridian = "am"
	elif hours < 12:
		display_hour = hours
		meridian = "am"
	elif hours == 12:
		display_hour = 12
		meridian = "pm"
	else:
		display_hour = hours - 12
		meridian = "pm"
	return str(display_hour) + " " + meridian
	
	
func _update_time() -> void:
	hours += 1
	if hours > 23:
		hours = 0
		days += 1
	
	_refresh_display()
