import socket
import threading
import json


def send_message():
    while True:
        # Waiting for a message
        message = input()
        # Sending the message
        client.send(message.encode("UTF-8"))

def listen():
    while True:
        # Recieving the message from the server and decoding it.
        message = json.loads(client.recv(1024).decode('UTF-8'))
        # The message is in a dictionary format so it prints the user and the message from dictionary
        print(f"{message['user']}: {message['message']}")


client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connecting to the server
client.connect(("localhost",9990))
# Asking the user for a user name to be used in the chat.
client.send(input("Please set a username: ").encode("UTF-8"))



try:
    # Assigning a thread to the messaging function.
    thread1 = threading.Thread(target=send_message)
    # Assigning a thread to the listening function.
    thread2 = threading.Thread(target=listen)

    # Starting the threads
    thread1.start()
    thread2.start()
except KeyboardInterrupt:
    print("Exiting...")
