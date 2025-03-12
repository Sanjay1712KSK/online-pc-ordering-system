import time
def twe(words,delay):
    for char in words:
        print(char,end="",flush=True)
        time.sleep(0.5)
    print()
