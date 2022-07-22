//
//  UserView.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/15/22.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        TabView{
            LocationView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Locations")
                }
            ProfileView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

