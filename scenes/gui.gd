extends Control

func change_time(new_time):
	var minute: String = str(new_time.minute)
	if len(minute) < 2:
		minute = "0" + minute
	$Label.text = str(new_time.hour) + ":" + minute + "am" if new_time.am else "pm"
