//
//  ContentView.swift
//  HotProspects
//
//  Created by Sarvad shetty on 2/7/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI
import UserNotifications
import SamplePackage

struct ContentView: View {
    
    let possibleNumber = Array(1...60)
    var results: String {
        let selected = possibleNumber.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.joined(separator: ",")
    }
    
    var body: some View {
        Text(results)
    }
}

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
