extends RefCounted
class_name DevIdentity

const DEVICE_ID_PATH := "user://dev_device_id.txt"
const DEVICE_ID_PREFIX := "grunt-and-run-dev"


static func get_device_id() -> String:
	var saved_id: String = _read_device_id()
	if not saved_id.is_empty():
		return saved_id

	return reset_device_id()


static func reset_device_id() -> String:
	var device_id: String = _generate_device_id()
	_write_device_id(device_id)
	return device_id


static func _read_device_id() -> String:
	if not FileAccess.file_exists(DEVICE_ID_PATH):
		return ""

	var file: FileAccess = FileAccess.open(DEVICE_ID_PATH, FileAccess.READ)
	if file == null:
		return ""

	var device_id: String = file.get_as_text().strip_edges()
	file.close()
	return device_id


static func _write_device_id(device_id: String) -> void:
	var file: FileAccess = FileAccess.open(DEVICE_ID_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Could not save dev device id.")
		return

	file.store_string(device_id)
	file.close()


static func _generate_device_id() -> String:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var timestamp: int = int(Time.get_unix_time_from_system())
	var random_suffix: int = rng.randi()

	return "%s-%s-%s" % [
		DEVICE_ID_PREFIX,
		timestamp,
		random_suffix,
	]
