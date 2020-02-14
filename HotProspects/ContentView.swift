//
//  ContentView.swift
//  HotProspects
//
//  Created by Sarvad shetty on 2/7/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    var body: some View {
        VStack {
            Button("Request permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
                    if success {
                        print("All Set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Schdule notification") {
                print("SSSSSSS!!!!!!")
                let content = UNMutableNotificationContent()
                content.title = "Feed the Cat"
                content.subtitle = "It is hungry"
                content.sound = UNNotificationSound.default
                
                let timeInterval = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let unReq = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: timeInterval)
                UNUserNotificationCenter.current().add(unReq)
            }
        }
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
