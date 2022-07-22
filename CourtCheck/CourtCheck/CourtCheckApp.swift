//
//  CourtCheckApp.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/10/22.
//

import SwiftUI

@main
struct CourtCheckApp: App {
    var body: some Scene {
        WindowGroup {
            let mainViewModel = MainViewModel()
            ContentView()
                .environmentObject(mainViewModel)
        }
    }
}
