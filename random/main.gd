extends Control

# Specify CSV file
var file_path: String = "res://data/data.csv"

# Create an empty CSV data
var data_set: Array = []
var column_header: Array = []

# Define nodes
onready var data_console = $MainContainer/DataPanel/Container/Console
onready var result_console = $MainContainer/ResultPanel/Container/Console


func _ready():
	# Get data from CSV file
	data_set = get_data(file_path)
	# Debug message
	print(data_set)
	
	# Print headers
	data_println(column_header)
	# Print each CSV line
	for row in data_set.size():
		data_print(data_set[row])
	
	# Print column/row size
	data_print("\nTotal Column = {total_column}".format({"total_column":column_header.size()}))
	data_println("Total Row (exclude header) = {total_row}".format({"total_row":data_set.size()}))
	
	# New random seed
	randomize()


func get_data(path):
	var file: File = File.new()
	# Specify CSV file
	file.open(path, File.READ)
	print("Loading CSV data...")
	
	var csv_data: Array = []
	
	var line_index: int = -1
	
	# Iterate each CSV line into a data set
	while !file.eof_reached():
		line_index += 1
		var line: Array = file.get_csv_line()
	
		# Get headers
		if line_index == 0:
			column_header = line
		else:
			# Append data set
			csv_data.append(line)
	
	file.close()
	
	# Debug message
	#print(csv_data)
	
	# Remove trailing empty line(s)
	while csv_data[csv_data.size() - 1][0].empty():
		# Remove last array (empty line)
		csv_data.pop_back()
		# Debug message
		#print(csv_data)
	
	return csv_data


func get_random(data):
	var random_data = int(data[randi() % data.size()][0])
	random_data -= 1
	
	return random_data


func data_print(value):
	data_console.text += str(value) + "\n"
	# Auto scroll
	data_console.scroll_vertical = INF


func data_println(value):
	data_console.text += str(value) + "\n"
	data_console.text += "----------\n"
	# Auto scroll
	data_console.scroll_vertical = INF


func result_print(value):
	result_console.text += str(value) + "\n"
	# Auto scroll
	result_console.scroll_vertical = INF


func result_println(value):
	result_console.text += str(value) + "\n"
	result_console.text += "----------\n"
	# Auto scroll
	result_console.scroll_vertical = INF


func _on_Button_pressed():
	var random_result = int(get_random(data_set))
	print(random_result)
	result_println("Random result:\n{result_data}".format({"result_data": data_set[random_result]}))
