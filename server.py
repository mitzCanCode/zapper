import socket
import threading
import json


# def send_message(sender, reciever):
#     while True:
        
#         client.send(message.encode("UTF-8"))

def listen(client):
    # while True:
    #     message = .recv(1024)
    #     print(message.decode("UTF-8"))
    pass


# Making the sever a TCP server.
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Assigning the server port and ip.
server.bind(("localhost",9990))

# Starting the server
server.listen()

# Accepting the first user
client1, address1 = server.accept()
# Sending the user an update from the server stating the status of the active users.
client1.send(json.dumps({"user":"server", "message":"Client1 joined. Waiting for second connection..."}).encode("UTF-8"))

# Setting the user name for user one
nickname1 = client1.recv(1024).decode("UTF-8")
# Printing to the server console
print(nickname1)

client2, address2 = server.accept()
# Setting the user name for user two
nickname2 = client2.recv(1024).decode("UTF-8")
print(nickname2)
# Sending the user an update from the server stating the status of the active users.
client1.send(json.dumps({"user":"server", "message":"Both users connected communication can start!"}).encode("UTF-8"))
# Sending the user an update from the server stating the status of the active users.
client2.send(json.dumps({"user":"server", "message":"Both users connected communication can start!"}).encode("UTF-8"))



try:
    while True:
        # Printing to the server console the messages sent
        print(client1.recv(1024).decode("UTF-8"))
        print(client2.recv(1024).decode("UTF-8"))
except KeyboardInterrupt:
    # If the server is quit by the user the server socket is closed
    server.close()
    print("Exiting...")
    
