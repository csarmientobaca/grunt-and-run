extends Node

var profile_state: Dictionary = {}
var dashboard_data: Dictionary = {}


func set_profile_state(value: Dictionary) -> void:
	profile_state = value
	if _has_dashboard_payload(value):
		dashboard_data = {
			"character": value.get("character", {}),
			"stats": value.get("stats", {}),
			"dashboard": value.get("dashboard", {}),
		}


func set_dashboard_data(value: Dictionary) -> void:
	dashboard_data = value


func has_dashboard_data() -> bool:
	return not dashboard_data.is_empty()


func clear() -> void:
	profile_state = {}
	dashboard_data = {}


func _has_dashboard_payload(value: Dictionary) -> bool:
	return value.has("character") and value.has("stats") and value.has("dashboard")
