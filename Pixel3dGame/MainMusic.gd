extends AudioStreamPlayer


var rewind_time = 8.0  
var loop_end_time = 10.0  




func _process(delta):
	_on_music_finished()


func _on_music_finished():
	
	var current_position = get_playback_position()
	
	
	if current_position >= loop_end_time:
		print("privet")
		
		seek(rewind_time)
		
