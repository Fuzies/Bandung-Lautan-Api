extends Node

func goto_scene(path):
	var loader = ResourceLoader.load_interactive(path)
	
	var loading_bar = load("res://UI/LoadingBar.tscn").instance()
	
	get_tree().get_root().call_deferred('add_child', loading_bar)
	
	while true:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			get_tree().get_root().call_deferred('add_child', resource.instance())
			break
		if err == OK:
			var progress = float(loader.get_stage())/loader.get_stage_count()
			loading_bar.value = progress * 100
			print(progress)
		yield(get_tree(),"idle_frame")
