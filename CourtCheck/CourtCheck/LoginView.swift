//
//  ContentView.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/10/22.
//

import SwiftUI
import Firebase
class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
}
struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    var body: some View{
        NavigationView{
            ScrollView{
                
                VStack(spacing: 16){
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Sign Up")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode{
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }

                    Group{
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                    }.padding(12)
                    .background(Color.white)

                    
                    Button {
                        handleAction()
                    } label: {
                        HStack{
                            Spacer()
                            Text(isLoginMode ? "Log In": "Sign Up")
                                .foregroundColor(.white)
                                .padding()
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                    }
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
               

            }
            .navigationTitle(isLoginMode ? "Log In" : "Sign Up")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else{
            createNewAccount()
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err{
                self.loginStatusMessage = "Failed to create new user: \(err)"
                return
            }
            print("Sucessfully created user: \(result?.user.uid ?? "")")
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err{
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            print("Sucessfully logged in as user: \(result?.user.uid ?? "")")
        }
    }
}
struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        LoginView()
    }
}

