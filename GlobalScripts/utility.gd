extends Node

# Save Dictionary in a file
func saveDictionary(path : String, data : Dictionary) -> bool:
    var data_string = JSON.print(data)
    var file = File.new()
    var json_error = validate_json(data_string)
    # Oops invalid Dictionary
    if json_error:
        print("Error : unable to save %s" % [path])
        print("JSON IS NOT VALID FOR: " + data_string)
        print("error: " + json_error)
        return false
    # Open and save data
    var err = file.open(path,File.WRITE)
    if err != OK:
        print("Failed to open file %s" % [path])
        return false
    file.store_string(data_string)
    file.close()
    return true


# Load data from File, returns dictionary if success otherwise will return null 
func loadDictionary(path : String):
    var file : File = File.new()
    # Verify existance of file
    if not file.file_exists(path):
        print_debug('file [%s] does not exist' % path)
        return null
    # Check for any error
    var err = file.open(path,File.READ)
    if err != OK:
        print("Failed to open file %s" % [path])
        return null
        
    var json : String = file.get_as_text()
    var data = parse_json(json)
    file.close()
    return data


# Copy dictionary from source to destination dictionary
func dictionaryCpy(dest_D : Dictionary, src_D : Dictionary):
    var keys = src_D.keys()
    for i in keys:
        if dest_D.has(i):
            dest_D[i] = src_D[i]


# Get file name from File path
#e.g "user/folder/file.txt" will return "file.txt" 
func getFileName(file : String):
    if file == "":
        return "UNTITLED"
    return file.get_file()