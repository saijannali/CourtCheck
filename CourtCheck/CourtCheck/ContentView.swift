//
//  ContentView.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/15/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mainViewModel: MainViewModel

    var body: some View {
        if mainViewModel.isUserSignedIn{
            UserView()
        } else{
            LoginView (didCompleteLogin: {
                self.mainViewModel.isUserSignedIn = true
                self.mainViewModel.fetchCurrentUser()
            })
        }
            
    }
}



