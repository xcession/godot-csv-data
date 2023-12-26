extends Control


# Specify CSV file
var file_path: String = "res://data/data.csv"

# Create an empty CSV data
var data_set: Array = []
var column_headers: Array = []

# Define nodes
@onready var tree = $MainContainer/DataPanel/Container/Tree
@onready var console = $MainContainer/ConsolePanel/Container/Console
@onready var popup_dialog = $DialogContainer/Popup


func _ready():
	# Get data from CSV file
	data_set = get_data(file_path)
	# Debug message
	print(data_set)
	
	# Print CSV headers
	console_println(column_headers)
	# Print CSV data
	for row in data_set.size():
		console_print(data_set[row])
	
	# Print column/row size
	console_print("\nTotal Column = {total_column}".format({"total_column":column_headers.size()}))
	console_println("Total Row (exclude header) = {total_row}".format({"total_row":data_set.size()}))
	
	# Fetch data to tree node
	assign_data_tree()


func get_data(path):
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
			column_headers = line
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


func assign_data_tree():
	# Set column count
	tree.set_columns(column_headers.size())
	# Make column title visible
	tree.set_column_titles_visible(true)
	# Hide root tree
	tree.set_hide_root(true)
	# Hide folding
	tree.set_hide_folding(true)

	# Create tree root
	var root = tree.create_item()

	# Set column title
	for column in column_headers.size():
		tree.set_column_title(column, str(column_headers[column]).capitalize())
		# Set root column (not necessary)
		#root.set_text(column, str(column_headers[column]))

	# Iterate data rows
	for row in data_set.size():

		# Create child tree
		var data_table = tree.create_item(root)

		# Iterate data columns
		for column in column_headers.size():
			#print("Data row = ", row)
			data_table.set_text(column, str(data_set[row][column]))


func _on_ResultButton_pressed():
	var data_column: String = $MainContainer/ConsolePanel/Container/InputContainer/ColumnPanel/Column/Input.get_line_edit().text
	var data_row: String = $MainContainer/ConsolePanel/Container/InputContainer/RowPanel/Row/Input.get_line_edit().text
	if int(data_column) < column_headers.size() && int(data_row) < data_set.size():
		console_print("Column = {selected_column}, Row = {selected_row}".format({"selected_column":data_column, "selected_row":data_row}))
		console_println("Data = {selected_data}".format({"selected_data":data_set[int(data_row)][int(data_column)]}))
	else:
		if int(data_column) > data_set[0].size() - 1:
			popup_dialog.window_title = "Invalid Column Number!"
			popup_dialog.get_label().text = "Valid number = 0 .. {last_column}".format({"last_column":data_set[0].size() - 1})
			popup_dialog.get_label().text += "\nTotal Column = {column_size}".format({"column_size":data_set[0].size()})
			popup_dialog.popup()
		elif int(data_row) > data_set.size() - 1:
			popup_dialog.window_title = "Invalid Row Number!"
			popup_dialog.get_label().text = "Valid number = 0 .. {last_row}".format({"last_row":data_set.size() - 1})
			popup_dialog.get_label().text += "\nTotal Row (exclude header) = {row_size}".format({"row_size":data_set.size()})
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
