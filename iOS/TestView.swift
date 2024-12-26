import SwiftUI

struct SendMessageView: View {
    @State private var message: String = "" // The message to send
    @State private var responseText: String = "" // To display the server's response
    @State private var isSending: Bool = false // Loading state
    @State private var deviceID: String = "device1" // Device identifier
    
    // Timer object for polling new messages
    @State private var pollingTimer: Timer? = nil

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter your message", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: sendMessage) {
                if isSending {
                    ProgressView()
                } else {
                    Text("Send Message")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .disabled(isSending || message.isEmpty)
            .padding()

            Text("Response:")
                .font(.headline)
                .padding(.top)

            ScrollView {
                Text(responseText.isEmpty ? "No response yet" : responseText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            startPolling()  // Start polling for new messages when the view appears
        }
        .onDisappear {
            // Stop polling when the view disappears
            pollingTimer?.invalidate()
        }
    }

    // Start polling for new messages every 5 seconds
    private func startPolling() {
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.fetchMessages()
        }
    }

    // Send a message to the server
    private func sendMessage() {
        guard let url = URL(string: "http://192.168.0.31:8080/sendMessage") else {
            responseText = "Invalid URL"
            return
        }

        let payload: [String: Any] = [
            "to": "device2", // Specify the recipient device
            "message": message
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: payload) else {
            responseText = "Failed to encode message."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        isSending = true
        responseText = ""

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSending = false

                if let error = error {
                    responseText = "Error: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    responseText += "HTTP Status Code: \(httpResponse.statusCode)\n"
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    responseText += "Response: \(responseString)"
                }
            }
        }.resume()
    }

    // Fetch new messages for the current device
    private func fetchMessages() {
        guard let url = URL(string: "http://192.168.0.31:8080/getMessages?device=\(deviceID)") else {
            responseText = "Invalid URL"
            return
        }

        isSending = true
        responseText = ""

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isSending = false

                if let error = error {
                    responseText = "Error: \(error.localizedDescription)"
                    return
                }

                if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let messages = jsonResponse["messages"] as? [String] {
                    responseText = "Received messages:\n" + messages.joined(separator: "\n")
                } else {
                    responseText = "No new messages."
                }
            }
        }.resume()
    }
}

struct SendMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SendMessageView()
    }
}
