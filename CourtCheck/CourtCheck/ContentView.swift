//
//  ContentView.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/10/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var contentModel = ContentModel()
    
    var body: some View {
        NavigationView{
            VStack{
                List (contentModel.Locations) { location in
                    HStack{
                        Image(systemName: "photo")
                        Text(location.id)
                        Text("Players: \(location.curr_players)")
                        NavigationLink("", destination: LocationDetailsView(contentModel: contentModel))
                    }.background(backgroundColor(activePlayers: location.curr_players))
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

