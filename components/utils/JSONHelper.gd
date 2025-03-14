class_name JSONHelper


func load_data_from_json(infile: String):
	var file = FileAccess.open(infile, FileAccess.READ)
	if file == null:
		return null
	
	var content = file.get_as_text()
	var json_data = JSON.parse_string(content)
	
	return json_data
