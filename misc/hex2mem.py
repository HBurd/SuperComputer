#!/usr/bin/python3
import argparse

def main(args):
    rfname = args.rfname
    wfname = args.wfname

    total_char_pixels = args.width * args.height

    if total_char_pixels > args.wordlen:
        print(f"Error: character consisting of {args.width * args.height} pixels \
                will not fit into {args.wordlen} bits.")
        return -1

    wordnibs = int(args.wordlen / 4)

    write_strings = ['0' * wordnibs + '\n'] * 128
    chars_written = 0

    with open(rfname, 'r') as rfile:
        while chars_written < 128:
            line = rfile.readline()
            if line == '':
                break

            line = line.split(':')

            char = int(line[0], 16)
            if char < 128:
                bitmap = line[1][:-1] # discard newline
                if len(bitmap) <= wordnibs:
                    # flip it
                    bitmap = hex(int(bin(int(bitmap, 16))[2:].zfill(args.wordlen)[::-1], 2))[2:].zfill(wordnibs)
                    write_strings[char] = bitmap + '\n'
                    chars_written = chars_written + 1
            
    #write to file
    with open(wfname, 'w') as wfile:
        wfile.writelines(write_strings)
        
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="turn a raw image file into a xilinx .mem")
    parser.add_argument('rfname', help="read file name")
    parser.add_argument('wfname', help="write file name")
    parser.add_argument('--width', help="width of a character in pixels", default=8)
    parser.add_argument('--height', help="height of a character in pixels", default=16)
    parser.add_argument('--wordlen', help="character memory word length", default=128)
    args = parser.parse_args()
    main(args)
