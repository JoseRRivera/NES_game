def read_nam_file(file_path):
    try:
        with open(file_path, 'rb') as nam_file:
            # Read the contents of the .nam file
            nam_content = nam_file.readlines()
            # Print the contents to the console
            print(nam_content)
            nam_content = nam_content[0]
            index = 0
            bits = ''
            mapping = {
                '5555': '00',
                '6666': '01',
                '7777': '10',
                '8888': '11',
            }
            for _ in range(15):
                for _ in range(16):
                    key_index1 = index
                    key_index2 = index + 1
                    key_index3 = index + 32
                    key_index4 = index + 33

                    print(index)
                    
                    key = str(nam_content[key_index1]) + str(nam_content[key_index2]) + str(nam_content[key_index3]) + str(nam_content[key_index4])
                    bits += mapping.get(key)
                    index += 2
                bits += '\n'
                index += 32
            binary_to_hex(bits)



    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    # except Exception as e:
    #     print(f"An error occurred: {e}")


def binary_to_hex(binary_string):
    strings_by_32 = binary_string.strip().split('\n')
    list_of_lists = []
    for bit32 in strings_by_32:
        byte_line = []
        for i in range(4):
            byte = bit32[i * 8:i * 8+8]
            byte_line.append(byte)
        list_of_lists.append(byte_line)
    for byte_line in list_of_lists:
        print(f".byte %{byte_line[0]}, %{byte_line[1]}, %{byte_line[2]}, %{byte_line[3]}")

# Example usage:
if __name__ == "__main__":
    nam_file_path = input("Enter .nam file name: ")  # Replace "example.nam" with the actual path to your .nam file
    read_nam_file(nam_file_path)
