import sys

input_file = "book.txt"
output_file = "compiled_book"

compiled_text = ""
quoteflag = False
new_line_count = 0
pacman = False
 

with open(input_file, 'r', encoding="utf-8") as f:
    
    while True:
    
        letter = f.read(1)

        if(letter == "."):
            
            pacman = False
            compiled_text += ".[[stop]]"

        elif(letter == '"'):
        
            pacman = False
            quoteflag = not quoteflag

            if quoteflag == False:

                nextchar = f.read(1)
                
                if(nextchar == "." or nextchar == "," or nextchar == "!"):
                    compiled_text += '"'
                    f.seek(f.tell() - 1)
                else:
                    compiled_text += '"[[stop]]'
    
            else:
                compiled_text += '"'
    
        elif(letter == "\n"):
            
            new_line_count += 1

            if new_line_count == 2:
                compiled_text += "\n[[page]]\n"
                pacman = True
                new_line_count = 0
            else:
                if(not pacman):
                    compiled_text += "\n"

        # no more text to compile break.
        elif(letter == ''):
            break
    
        # normal letter, include directly.
        else:
            pacman = False
            compiled_text += letter


with open(output_file, 'w', encoding="utf-8") as f:
    f.write(compiled_text)




