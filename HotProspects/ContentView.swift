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
//    @ObservedObject var updater = DelayedUpdater()
    @State private var backColor = Color.red
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            .padding()
            .background(backColor)
            
            Text("Change color")
            .padding()
                .contextMenu {
                    Button(action: {
                        self.backColor = .red
                    }) {
                        Text("Red")
                    }
                    
                    Button(action: {
                        self.backColor = .green
                    }) {
                        Text("Green")
                    }
                    
                    Button(action: {
                        self.backColor = .blue
                    }) {
                        Text("Blue")
                    }
            }
            
        }
    }
    
    func fetchData(from urlString: String, completion: @escaping(Result<String, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            //the task has completed push work to main thread
            DispatchQueue.main.async {
                if let data = data {
                    //deocde to string
                    let stringData = String(decoding: data, as: UTF8.self)
                    completion(.success(stringData))
                } else if error != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }.resume()
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
