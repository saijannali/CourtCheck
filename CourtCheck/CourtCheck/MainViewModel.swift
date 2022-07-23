//
//  MainViewModel.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/15/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import FirebaseStorage
import simd

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}

struct MainUser: Identifiable{
    var id: String {uid}
    var uid: String
    var checkInLocation: String
    var email: String
    var checkedInPlayers: Int
    var isCheckedIn: Bool

    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.checkInLocation = data["checkInLocation"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.checkedInPlayers = data["checkedInPlayers"] as? Int ?? -1
        self.isCheckedIn = data["isCheckedIn"] as? Bool ?? false
    }
}

class MainViewModel: ObservableObject{
    
    @Published var errorMsg = "Error"
    @Published var mainUser: MainUser?
    @Published var isUserSignedIn = false
    
    init() {
        fetchCurrentUser()
        
        DispatchQueue.main.async {
            if (FirebaseManager.shared.auth.currentUser != nil)
            {
                print("set to true")
                self.isUserSignedIn = true
            }
        }
    }
    
 
    
    // Error handling
    enum ErrorHandle: Error{
        case checkInError
        case fetchUserError
        case LocationError
    }
    
    func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
        else{
            self.errorMsg = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("Users")
            .document(uid).getDocument{ snapshot, error in
                if let error = error{
                    self.errorMsg = "Dailed to fetch current user: \(error)"
                    print("Failed to fetch current user", error)
                    return
                }
                
                guard let data = snapshot?.data() else {return}
                
                self.mainUser = .init(data: data)
            }
    }
    
    // check in User
    func checkIn(location : String, playersCheckedIn : Int){
        //check in locally
        DispatchQueue.main.async {
            self.mainUser?.checkInLocation = location
            self.mainUser?.checkedInPlayers = playersCheckedIn
            self.mainUser?.isCheckedIn = true
        }
        
        //checkIn firebase
        let db = Firestore.firestore()
        
        db.collection("Users").document(self.mainUser?.uid ?? "")
            .updateData([
                "checkInLocation" : location,
                "checkedInPlayers" : playersCheckedIn,
                "isCheckedIn" : true]) {err in
                    if let err = err{
                        print("Error writing -> checkIn :\(err)")
                    } else{
                        print("Player checkIn Updated!")
                    }
                }
    }

    func checkOut() {
        //checkout locally
        self.mainUser?.checkInLocation = ""
        self.mainUser?.checkedInPlayers = 0
        self.mainUser?.isCheckedIn = false
        
        //checkout Firebase
        let db = Firestore.firestore()
        db.collection("Users").document(self.mainUser!.uid)
            .updateData([
                "checkInLocation" : "",
                "checkedInPlayers" : 0,
                "isCheckedIn" : false]) { err in
                    if let err = err{
                        print("ERORR: Couldn't checkout Firebase :\(err)")
                    } else{
                        print("Sucessfully checked-out all players")
                    }
                }
    }
    
    func userSingOut() {
        try? FirebaseManager.shared.auth.signOut()
        isUserSignedIn = false
    }
}

