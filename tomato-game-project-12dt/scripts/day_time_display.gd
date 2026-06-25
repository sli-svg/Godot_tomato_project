extends Control


@onready var date_label: Label = %date_label
@onready var time_label: Label = %time_label

var hours: int = 0
var days: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_refresh_display()
	
	
func _refresh_display():
	#date_label.text = "Day " + _add_zero(current_date.day)
	date_label.text = "Day " + str(days)
	time_label.text = "hour " + str(hours)
	
func _add_zero(number):
	if number < 10:
		return "0" + str(number)

	else:
		return str(number)
	
	
func _get_time_label():
	var hour: int
	var meridian: String
	

	#if current_date.hour - 12 < 0:
		#hour = current_date.hour
		#meridian = "am"
		
	#else:
		#hour = current_date.hour - 12
		#meridian = "pm"
		
	#return _add_zero(hour) + ":" + _add_zero(current_date.minute) + " " + meridian	


func _update_time() -> void:
	hours += 1
	if hours > 23:
		hours = 0
		days += 1
	_refresh_display()
