import socket
import threading
import json
import sys

def send_message(receiver, sender, message):
    message = json.dumps({"user": sender, "message": message})
    receiver.send(message.encode("UTF-8"))

def handle_client(client, users):
    while True:
        try:
            message = client.recv(1024).decode("UTF-8")
            if message:
                print(f"{users[client]}: {message}")
                # Broadcast the message to all other connected clients
                for other_client in users.keys():
                    if other_client != client:
                        send_message(other_client, users[client], message)
        except ConnectionResetError:
            # Handle disconnection
            print(f"{users[client]} has disconnected.")
            del users[client]
            for other_client in users.keys():
                    send_message(other_client, sender="server", message=f"{users[client]} has disconnected.")
            break

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("localhost", 9996))
server.listen()

users = {}  # Dictionary to store clients and their usernames

try:
    while True:
        client, address = server.accept()
        nickname = client.recv(1024).decode("UTF-8")
        print(f"{nickname} connected from {address}")
        users[client] = nickname
        client.send(json.dumps({"user": "server", "message": "You are now connected!"}).encode("UTF-8"))

        # Starting a new thread to handle this client.
        client_thread = threading.Thread(target=handle_client, args=(client, users))
        client_thread.start()

except KeyboardInterrupt or ConnectionResetError:
    # If the server is quit by the user, close the server socket
    server.close()
    print("Server is shutting down.")
    sys.exit()
    
    
    
