extends HBoxContainer

onready var file_menu = get_node('FileMenu')
onready var help_menu = get_node('HelpMenu')

var callback_target = null

var file_menu_items = [
	{
		"text": "Open File",
		"callback": "open_file_pressed",
		"shortcut_key": KEY_O
	},
	{
		"text": "Save As File",
		"callback": "save_as_file_pressed",
		"shortcut_key": KEY_E
	},
	{
		"text": "Save File",
		"callback": "save_file",
		"shortcut_key": KEY_S
	},
	{
		"text": "New File",
		"callback": "new_file",
		"shortcut_key": KEY_N
	},
	{
		"text": "Quit",
		"callback": "quit_pressed",
		"shortcut_key": KEY_Q
	}
]

var help_menu_items = [
	{
		"text": "About",
		"callback": "about_pressed",
		"shortcut_key": null
	},
	{
		"text": "GitHub",
		"callback": "github_pressed",
		"shortcut_key": null
	},
	{
		"text": "Report a Bug",
		"callback": "report_bug_pressed",
		"shortcut_key": null
	}
]

func initialize():
	populate_menu()


# Function that makes a shortcut
func create_shortcut(key):
	# Creates ShortCut and InputKeyEvent
	var shortcut = ShortCut.new()
	var inputeventkey = InputEventKey.new()
	# Sets the scanned key and uses control as the preceding command
	inputeventkey.set_scancode(key)
	inputeventkey.control = true
	# Makes the final shortcut and returns it
	shortcut.set_shortcut(inputeventkey)
	return shortcut


func populate_menu():
	add_menu_items(file_menu, file_menu_items, self, "file_item_pressed")
	add_menu_items(help_menu, help_menu_items, self, "help_item_pressed")


func add_menu_items(menu, items, target, callback):
	# Local index to track as we iterate over the items
	var _index = 0
	
	for item in items:
		menu.get_popup().add_item(item.get("text"))
		# If the menu item has a shortcut key, assign it
		if (item.get("shortcut_key")):
			menu.get_popup().set_item_shortcut(
				# Index of the item we're setting the shortcut for
				_index,
				# The Shortcut object
				create_shortcut(item.get("shortcut_key")),
				# Specify that the shortcut is global
				true
			)
	
		# We haven't found the item yet, keep iterating
		_index += 1
	
	# Connect the signal for when an item is pressed
	menu.get_popup().connect("id_pressed", target, callback)


func call_menu_item_callback(index, items):
	# Attempt to find the item at the index pressed in the menu popup
	var item = find_menu_item_at_index(index, items)
	
	# If we've found an item, call the item's callback
	if (item != null and callback_target != null):
		callback_target.call(item.get("callback"))


func find_menu_item_at_index(index, items):
	# Local index to track as we iterate over the items
	var _index = 0
	
	for item in items:
		# If the pressed index matches our iteration index, we've
		# found the item
		if (_index == index):
			return item
		# We haven't found the item yet, keep iterating
		_index += 1
	
	# We didn't find the item for some reason, return null
	return null


# Set the callback target for menu item callbacks
func set_callback_target(target):
	callback_target = target


func file_item_pressed(id):
	call_menu_item_callback(id, file_menu_items)


func help_item_pressed(id):
	call_menu_item_callback(id, help_menu_items)
