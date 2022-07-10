//
//  LocationDetailsView.swift
//  CourtCheck
//
//  Created by Sai Jannali on 7/10/22.
//

import SwiftUI

struct LocationDetailsView: View {
    @ObservedObject var contentModel: ContentModel
    
    @State private var showingCheckIn: Bool = false
    var body: some View {
        VStack{
            Button("Check In"){
                self.showingCheckIn.toggle()
            }.sheet(isPresented: self.$showingCheckIn){
                CheckInView(contentModel: contentModel)
            }
            Form{
                
            }
        }
    }
}

struct CheckInView: View{
    @ObservedObject var contentModel: ContentModel
    @State var playerAmount: Int = 0
    
    var body: some View{
        TextField("number of players", value: $playerAmount, formatter: Formatter())
            .keyboardType(.decimalPad)
        Button("Check In"){
            self.contentModel.checkIn(playerAmt: self.playerAmount)
        }
    }
}
//
//struct LocationDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationDetailsView()
//    }
//}
