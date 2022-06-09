//
//  ContentView.swift
//  WorkHotel
//
//  Created by yugo.sugiyama on 2022/06/08.
//

import SwiftUI
import WorkHotelMap

struct ContentView: View {
    var body: some View {
        WorkHotelMapView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
