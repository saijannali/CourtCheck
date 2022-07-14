//
//  LocationDetailsView.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/10/22.
//

import SwiftUI

struct LocationView: View {
    @ObservedObject var contentModel = ContentModel()
    
    var body: some View {
        NavigationView{
            VStack{
                List (contentModel.Locations) { location in
                    HStack{
                        Image(systemName: "photo")
                        Text(location.id)
                        Text("Players: \(location.curr_players)")
                        NavigationLink("", destination: LocationDetailsView()
                    )}
                    .background(backgroundColor(activePlayers: location.curr_players))
                    Text("Check IN here")
                }
            }
        }
        .navigationTitle("Locations")
        .onAppear{
            self.contentModel.getLocations()
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
    var body: some View{
        Text("")
    }
}

//
//struct LocationDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationDetailsView()
//    }
//}

struct Previews_LocationView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
