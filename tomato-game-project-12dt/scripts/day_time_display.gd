extends Control


@onready var date_label: Label = %date_label
@onready var time_label: Label = %time_label

var hours: int = 0
var days: int = 1

const HOURS_PER_DAY: int = 24
const LAST_HOUR: int = HOURS_PER_DAY - 1


func _ready() -> void:
	_refresh_display()
	
	
func _refresh_display() -> void:
	date_label.text = "Day " + str(days)
	time_label.text = _get_time_label()


func _get_time_label() -> String:
	var display_hour: int
	var meridian: String
	
	# Convert the 24-hour time into a 12-hour display.
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
	# Advance the time by one hour. 
	hours += 1
	
	# Start a new day after the final hour.
	if hours > LAST_HOUR:
		hours = 0
		days += 1
	
	_refresh_display()
