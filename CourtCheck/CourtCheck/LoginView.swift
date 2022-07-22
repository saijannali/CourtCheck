//
//  ContentView.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/10/22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var isLoginMode = true
    @State var email = ""
    @State var password = ""
    let didCompleteLogin: () -> ()
    
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
            
            self.loginStatusMessage = "Successfully registered: \(result?.user.uid ?? "")"
            print("Sucessfully created user: \(result?.user.uid ?? "")")
            
            self.addUserDoc(userAuth: (result)!)
            self.isLoginMode = true
        }
    }
    
    private func addUserDoc(userAuth : AuthDataResult) {
        let db = Firestore.firestore()

        db.collection("Users").document(userAuth.user.uid)
            .setData([
                "uid" : userAuth.user.uid ?? "",
                "email" : userAuth.user.email ?? "",
                "checkedInPlayers" : 0,
                "isCheckedIn" : false])
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err{
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            print("Sucessfully logged in as user: \(result?.user.uid ?? "")")
            self.didCompleteLogin()
        }
    }
    
}

