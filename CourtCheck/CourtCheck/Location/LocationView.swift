//
//  LocationDetailsView.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/10/22.
//

import SwiftUI
import Combine

struct LocationView: View {
    @EnvironmentObject var mainViewModel : MainViewModel
    @ObservedObject var locationModel = LocationModel()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(locationModel.Locations) { location in
                    HStack{
                        Image(systemName: "photo")
                        Text(location.id)
                        Text("Players: \(location.curr_players)")

                        NavigationLink("Details", destination: LocationDetailsView(locationModel: locationModel, location: location))
                    }
                        .background(backgroundColor(activePlayers: location.curr_players))
                }
            }

        }
        .navigationTitle("Locations")
        .onAppear{
            self.locationModel.getLocations()
        }
        .environmentObject(mainViewModel)
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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mainViewModel: MainViewModel
    @ObservedObject var locationModel : LocationModel
    @State var location : Location?
    @State var numberOfPlayers: Int = 0
    @State var showingConfirmation = false

    var body: some View{
        VStack {
            // check if user is checkedIn
            if let isCheckedIn = mainViewModel.mainUser?.isCheckedIn{
                if isCheckedIn{
                    VStack{
                        Text("You are already checked in at a location")
                        // if currView is same as the one user is checkedIn, provide checkout button
                        if mainViewModel.mainUser!.checkInLocation == location!.id{
                            Button {
                                mainViewModel.checkOut()
                                locationModel.checkOutAtLocation(decrementPlayer: numberOfPlayers,location: location!)
                                print(numberOfPlayers)
                                showingConfirmation = true
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("Checkout all players at \(location!.id)?")
                            }
                            .alert("You have successfully Checked-Out", isPresented: $showingConfirmation){
                                Button("Ok", role: .cancel) {}
                            }
                            .padding()
                        }
                    }
                    
                }else{
                    Button("Check In"){
                        mainViewModel.checkIn(location: location!.id, playersCheckedIn: self.numberOfPlayers)
                        locationModel.checkInAtLocation(playerAmt: self.numberOfPlayers, location: location!)
                    }
                    TextField("Enter number of players...", value: $numberOfPlayers, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
//                        .onReceive(Just(numberOfPlayers)) { newValue in
//                            let filtered = newValue.filter { "0123456789".contains($0) }
//                            if filtered != newValue {
//                                self.numberOfPlayers = filtered
//                            }
//                        }
                }
            } else{
                Text("Error retrieving checked in status")
            }
        
            Divider()
            
            Form{
                Section{
                    Text("\(location?.curr_players ?? -1)")
                }header: { Text("Players")}
                Section{
                    Text(location?.address ?? "Error")
                }header: { Text("Address")}
                Section{
                    Text("\(location?.halfCourts ?? -1)")
                }header: { Text("Half Courts")}
                Section{
                    Text(location?.rimType ?? "Error")
                }header: { Text("Rim Type")}
                
            }
        }
        .onDisappear {
            locationModel.getLocations()
        }
    }
}
  
struct Previews_LocationView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
