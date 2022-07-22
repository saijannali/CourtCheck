//
//  ContentModel.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/10/22.
//

import Foundation
import Firebase
import SwiftUI

struct Location: Identifiable{
    var id: String
    let address: String
    let halfCourts: Int
    var curr_players: Int
    let rimType: String
}

class LocationModel: ObservableObject{
    @EnvironmentObject var mainViewModel : MainViewModel
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
    /* check in # of players */
    func checkInLocation(playerAmt : Int) {
        //check for existing value in 'currLocation'
        guard (currLocation?.id) != nil else{
            print("Location Not Found")
            return
        }
        // Update in 'playerAmt' in at 'currLocation' in Firebase
        let totalPlayersNow = currLocation!.curr_players + playerAmt
        self.db.collection("Locations").document(currLocation!.id)
            .updateData([
                "players" : totalPlayersNow]) { err in
                    if let err = err{
                        print("ERROR: checkInLocation couldn't : \(err)")
                    } else{
                        print("CheckInLocation Completed : \(playerAmt) Players added")
                    }
                }
    }
    
}
