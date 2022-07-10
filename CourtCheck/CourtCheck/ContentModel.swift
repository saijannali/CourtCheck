//
//  ContentModel.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/10/22.
//

import Foundation
import Firebase

struct Location: Identifiable{
    var id: String
    let address: String
    let halfCourts: Int
    var curr_players: Int
    let rimType: String
}
class ContentModel: ObservableObject{
    @Published var Locations = [Location]()
    @Published var currLocation : Location?
    
    let db = Firestore.firestore()
    
    func getLocations(){
        db.collection("Locations").getDocuments{ snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.Locations = snapshot.documents.map{ d in
                            return Location(id: d.documentID, address: d["address"] as? String ?? "error", halfCourts: d["half_courts"] as? Int ?? 0, curr_players: d["players"] as? Int ?? -1, rimType: d["rim_type"] as? String ?? "error")
                        }
                    }
                }
            } else{
                print("Error getLocations()")
            }
            
        }
    }
    
    func checkIn(playerAmt : Int) {
        // check in # of players
    }
}
