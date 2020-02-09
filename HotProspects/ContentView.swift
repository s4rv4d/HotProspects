//
//  ContentView.swift
//  HotProspects
//
//  Created by Sarvad shetty on 2/7/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab1")
                .onTapGesture {
                    self.selectedTab = 1
            }
                .tabItem {
                    Image(systemName: "star")
                    Text("One")
            }
            .tag(0)
            Text("Tab2")
            .tabItem {
                    Image(systemName: "star.fill")
                    Text("Two")
            }
        .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
