extends Control


# Specify CSV file
var file_path: String = "res://data/data.csv"

# Create an empty CSV data
var data_set: Array = []
var column_header: Array = []

# Define nodes
@onready var console = $MainContainer/ConsolePanel/Container/Console
@onready var result = $MainContainer/ResultPanel/Container/Result
@onready var popup_dialog = $DialogContainer/Popup


func _ready():
	# Get data from CSV file
	data_set = get_data(file_path)
	# Debug message
	print(data_set)
	
	# Print each CSV line
	for row in data_set.size():
		console_print(data_set[row])
	
	# Print column/row size
	console_print("\nTotal Column = {total_column}".format({"total_column":column_header.size()}))
	console_println("Total Row (include header) = {total_row}".format({"total_row":data_set.size()}))


func get_data(path):
	# Specify CSV file
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	console_println("Loading CSV data...")
	
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
	while csv_data[csv_data.size() - 1][0].is_empty():
		# Remove last array (empty line)
		csv_data.pop_back()
		# Debug message
		#print(csv_data)
	
	return csv_data


func _on_ResultButton_pressed():
	var data_column: String = $MainContainer/ResultPanel/Container/InputContainer/ColumnPanel/Column/Input.get_line_edit().text
	var data_row: String = $MainContainer/ResultPanel/Container/InputContainer/RowPanel/Row/Input.get_line_edit().text
	if int(data_column) < column_header.size() && int(data_row) < data_set.size():
		result_print("Column = {selected_column}, Row = {selected_row}".format({"selected_column":data_column, "selected_row":data_row}))
		result_println("Data = {selected_data}".format({"selected_data":data_set[int(data_row)][int(data_column)]}))
	else:
		if int(data_column) > data_set[0].size() - 1:
			popup_dialog.window_title = "Invalid Column Number!"
			popup_dialog.get_label().text = "Valid number = 0 .. {last_column}".format({"last_column":data_set[0].size() - 1})
			popup_dialog.get_label().text += "\nColumn Size = {column_size}".format({"column_size":data_set[0].size()})
			popup_dialog.popup()
		elif int(data_row) > data_set.size() - 1:
			popup_dialog.window_title = "Invalid Row Number!"
			popup_dialog.get_label().text = "Valid number = 0 .. {last_row}".format({"last_row":data_set.size() - 1})
			popup_dialog.get_label().text += "\nRow Size (include header) = {row_size}".format({"row_size":data_set.size()})
			popup_dialog.popup()


func console_print(value):
	console.text += str(value) + "\n"
	# Auto scroll
	console.scroll_vertical = INF


func console_println(value):
	console.text += str(value) + "\n"
	console.text += "----------\n"
	# Auto scroll
	console.scroll_vertical = INF


func result_print(value):
	result.text += str(value) + "\n"
	# Auto scroll
	result.scroll_vertical = INF


func result_println(value):
	result.text += str(value) + "\n"
	result.text += "----------\n"
	# Auto scroll
	result.scroll_vertical = INF
