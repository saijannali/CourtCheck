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
    
    var checkoutLocation: Location?
    
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
    func checkInAtLocation(playerAmt : Int, location: Location) {
        //check for existing value in 'currLocation'
//        guard (location.id) != nil else{
//            print("Location Not Found")
//            return
//        }
        // Update in 'playerAmt' in at 'currLocation' in Firebase
        let totalPlayersNow = location.curr_players + playerAmt
        self.db.collection("Locations").document(location.id)
            .updateData([
                "players" : totalPlayersNow]) { err in
                    if let err = err{
                        print("ERROR: checkInLocation couldn't : \(err)")
                    } else{
                        print("CheckInLocation Completed : \(playerAmt) Players added")
                    }
                }
    }
    
    func checkOutAtLocation(decrementPlayer: Int, location: Location) {
        //find # of players at location
//        db.collection("Locations").document(mainViewModel.mainUser!.checkInLocation)
//            .getDocuments { snapshot, err in
//                if err == nil{
//                    if let snapshot = snapshot {
//                        DispatchQueue.main.async {
//                            self.checkoutLocation = snapshot.documents.map{d in
//                                return
//
//                            }
//                        }
//                    }
//                } else{
//                    print("ERROR: checkOutAtLocation couldn't complete: \(err)")
//                }
//
//
//
//            }
    
        // Decrement in Firebase
        db.collection("Locations").document(location.id).updateData(["players" : FieldValue.increment(-Double(decrementPlayer))]) { [self] err in
                if let err = err{
                    print("ERROR: Failed to checkOutAtLocation: \(err)")
                } else{
                    print("Successfully checked-out \(decrementPlayer) Players at \(location.id)")
                    //self.getLocations()
                }
        }
    }
    
    func goToMaps(){
        let latitude = 42.25723435854716
        let longitude = -71.0714040028362
        let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")
        
        if UIApplication.shared.canOpenURL(url!) {
              UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else{
            let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")
                      
             UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
      }
    }
    
}
