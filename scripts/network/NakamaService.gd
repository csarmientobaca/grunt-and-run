extends Node

const NAKAMA_HOST := "127.0.0.1"
const NAKAMA_PORT := 7350
const NAKAMA_SCHEME := "http"
const SERVER_KEY := "defaultkey"
const DEVICE_ID := "grunt-and-run-godot-smoke-test"

var _client: NakamaClient
var _session: NakamaSession


func connect_and_authenticate() -> bool:
	if _client == null:
		_client = Nakama.create_client(SERVER_KEY, NAKAMA_HOST, NAKAMA_PORT, NAKAMA_SCHEME)

	if _session != null and _session.is_valid() and not _session.is_expired():
		return true

	print("SDK AUTH device_id=%s" % DEVICE_ID)
	var session: NakamaSession = await _client.authenticate_device_async(DEVICE_ID)
	if session.is_exception():
		print("NAKAMA AUTH FAILED")
		print(session.get_exception())
		return false

	_session = session
	print("AUTH OK")
	print("user_id: %s" % _session.user_id)
	print("username: %s" % _session.username)
	print("created: %s" % _session.created)
	return true


func get_character() -> Dictionary:
	return await call_rpc("get_character")


func create_character(character_name: String, race: String, character_class: String) -> Dictionary:
	return await call_rpc("create_character", {
		"name": character_name,
		"race": race,
		"class": character_class,
	})


func get_dashboard() -> Dictionary:
	return await call_rpc("get_dashboard")


func call_rpc(rpc_name: String, payload: Dictionary = {}) -> Dictionary:
	if _session == null:
		return {"error": "not_authenticated"}

	print("SDK RPC %s" % rpc_name)
	var payload_text: Variant = null
	if not payload.is_empty():
		payload_text = JSON.stringify(payload)

	var response: Variant = await _client.rpc_async(_session, rpc_name, payload_text)
	if response.is_exception():
		var exception: NakamaException = response.get_exception()
		return {
			"error": exception.message,
			"status_code": exception.status_code,
			"grpc_status_code": exception.grpc_status_code,
		}

	var rpc_response: NakamaAPI.ApiRpc = response
	return _parse_rpc_payload(rpc_response.payload)


func is_character_not_found(result: Dictionary) -> bool:
	var message := str(result.get("message", "")).to_lower()
	var error := str(result.get("error", "")).to_lower()
	var body := str(result.get("body", "")).to_lower()

	return (
		message.contains("character_not_found")
		or error.contains("character_not_found")
		or body.contains("character_not_found")
	)


func pretty(value: Variant) -> String:
	return JSON.stringify(value, "\t")


func _parse_rpc_payload(payload_text: String) -> Dictionary:
	var parsed: Variant = JSON.parse_string(payload_text)
	if parsed is Dictionary:
		var parsed_dict: Dictionary = parsed
		return parsed_dict
	return {"payload": payload_text, "parsed": parsed}
