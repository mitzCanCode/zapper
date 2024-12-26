import SwiftUI

struct RegisterView: View {
    @State var Username: String = ""
    @State var Password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    func registerUser(username: String, password: String) {
        if username.count >= 3 && username.count <= 20 && password.count >= 8 && password.count <= 20 {
            print("User registered")
            // Add SQL logic later
        } else {
            if username.count < 3 || username.count > 20 {
                alertMessage = "Username must be between 3 and 20 characters."
            } else if password.count < 8 || password.count > 20 {
                alertMessage = "Password must be between 8 and 20 characters."
            }
            showAlert = true // Trigger the alert
        }
    }
    
    var body: some View {
        VStack {
            Text("Register")
                .font(.title)
                .padding()
            
            TextField("Username", text: $Username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $Password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                registerUser(username: Username, password: Password)
            }) {
                Text("Register")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}

