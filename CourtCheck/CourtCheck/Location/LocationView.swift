//
//  LocationDetailsView.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/10/22.
//

import SwiftUI
import Combine

struct LocationView: View {
    @ObservedObject var locationModel = LocationModel()
    
    var body: some View {
        NavigationView{
            VStack{
                List (locationModel.Locations) { location in
                    HStack{
                        Image(systemName: "photo")
                        Text(location.id)
                        Text("Players: \(location.curr_players)")
                        NavigationLink("", destination: LocationDetailsView(locationModel: locationModel)).onAppear {
                            locationModel.currLocation = location
                            }
                    }
                        .background(backgroundColor(activePlayers: location.curr_players))
                    Text("Check In")
                }
            }
        }
        .navigationTitle("Locations")
        .onAppear{
            self.locationModel.getLocations()
        }
    }
    
    private func backgroundColor(activePlayers: Int) -> Color {
        switch activePlayers {
        case 0:
            return .gray
        case 1...4:
            return .green
        case 5...9:
            return .yellow
        case 10...15:
            return .red
        default:
            return .brown
        }
    }
}

struct LocationDetailsView: View{
    @EnvironmentObject var mainViewModel: MainViewModel
    @ObservedObject var locationModel : LocationModel
    
    @State var numberOfPlayers = ""

    var body: some View{

        VStack {
            // check if user is checkedIn
            if let isCheckedIn = mainViewModel.mainUser?.isCheckedIn{
                if isCheckedIn{
                    Text("You are already checked in at a location")
                }else{
                    Button("Check In"){
                        mainViewModel.checkIn(playersCheckedIn: Int(self.numberOfPlayers) ?? -1)
                        locationModel.checkInLocation(playerAmt: Int(self.numberOfPlayers) ?? -1)
                    }
                    TextField("Enter number of players...", text: $numberOfPlayers)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onReceive(Just(numberOfPlayers)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.numberOfPlayers = filtered
                            }
                        }
                }
            } else{
                Text("Error retrieving checked in status")
            }
        
            Divider()
            
            Form{
                Section{
                    Text("\(locationModel.currLocation?.curr_players ?? -1)")
                }header: { Text("Players")}
                Section{
                    Text(locationModel.currLocation?.address ?? "Error")
                }header: { Text("Address")}
                Section{
                    Text("\(locationModel.currLocation?.halfCourts ?? -1)")
                }header: { Text("Half Courts")}
                Section{
                    Text(locationModel.currLocation?.rimType ?? "Error")
                }header: { Text("Rim Type")}
                
            }
        }
        
    }
}
  


struct Previews_LocationView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
