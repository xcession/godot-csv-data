extends Control


# Create an empty CSV data
var csv_data = []
var csv_headers = []

# Total columns/rows
var total_column
var total_row

# Define nodes
onready var tree = $MainContainer/DataPanel/Container/Tree
onready var console = $MainContainer/ConsolePanel/Container/Console
onready var popup_dialog = $DialogContainer/PopupDialog


func _ready():
	# Get data from CSV file
	csv_data = get_data()
	
	# Print CSV headers
	console_println(csv_headers)
	# Print CSV data
	for row in total_row:
		console_print(csv_data[row])
	
	# Print column/row size
	console_print("\nTotal Column = {total_column}".format({"total_column":total_column}))
	console_println("Total Row (exclude header) = {total_row}".format({"total_row":total_row}))
	
	# Fetch data to tree node
	assign_data_tree()


func get_data():
	var file = File.new()
	# Specify CSV file
	file.open("res://data/data.csv", File.READ)
	console_println("Loading CSV data...")
	
	# Iterate each CSV line into a data set
	while !file.eof_reached():
		var data_set = file.get_csv_line()
		
		# Append data set
		csv_data.append(data_set)
	
	file.close()
	
	# Get column count
	total_column = csv_data[0].size()
	# Get row count
	total_row = csv_data.size()
	# Debug message
	#print(csv_data)
	
	# Remove trailing empty line(s)
	while csv_data[total_row - 1][0].empty():
		# Remove last array (empty line)
		csv_data.pop_back()
		# Update total row
		total_row -= 1
		# Debug message
		#print(csv_data)
	
	# Get headers
	csv_headers = csv_data[0]
	# Remove first array (headers)
	csv_data.pop_front()
	# Update total row
	total_row -= 1
	
	# Return CSV data
	return csv_data


func assign_data_tree():
	# Set column count
	tree.set_columns(total_column)
	# Make column title visible
	tree.set_column_titles_visible(true)
	# Hide root tree
	tree.set_hide_root(true)
	# Hide folding
	tree.set_hide_folding(true)
	
	# Create tree root
	var root = tree.create_item()
	
	# Set column title
	for column in total_column:
		tree.set_column_title(column, str(csv_headers[column]).capitalize())
		# Set root column (not necessary)
		#root.set_text(column, str(csv_headers[column]))
	
	# Iterate data rows
	for row in total_row:
		#print("Row = ", row)
		
		# Create child tree
		var data_table = tree.create_item(root)
		
		# Iterate data columns
		for column in total_column:
			#print("Data row = ", row)
			data_table.set_text(column, str(csv_data[row][column]))


func _on_ResultButton_pressed():
	var data_column = $MainContainer/ConsolePanel/Container/InputContainer/ColumnPanel/Column/Input.get_line_edit().text
	var data_row = $MainContainer/ConsolePanel/Container/InputContainer/RowPanel/Row/Input.get_line_edit().text
	if int(data_column) < total_column && int(data_row) < total_row:
		console_print("Column = {selected_column}, Row = {selected_row}".format({"selected_column":data_column, "selected_row":data_row}))
		console_println("Data = {selected_data}".format({"selected_data":csv_data[int(data_row)][int(data_column)]}))
	else:
		if int(data_column) > csv_data[0].size() - 1:
			popup_dialog.window_title = "Invalid Column Number!"
			popup_dialog.get_label().text = "Valid number = 0 .. {last_column}".format({"last_column":csv_data[0].size() - 1})
			popup_dialog.get_label().text += "\nTotal Column = {column_size}".format({"column_size":csv_data[0].size()})
			popup_dialog.popup()
		elif int(data_row) > csv_data.size() - 1:
			popup_dialog.window_title = "Invalid Row Number!"
			popup_dialog.get_label().text = "Valid number = 0 .. {last_row}".format({"last_row":csv_data.size() - 1})
			popup_dialog.get_label().text += "\nTotal Row (exclude header) = {row_size}".format({"row_size":csv_data.size()})
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
