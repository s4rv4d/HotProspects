//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Sarvad shetty on 2/14/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    
    //MARK: - Property wrappers
    @EnvironmentObject var prospects: Prospects
    @State private var showingScanner = false
    
    //MARK: - Properties
    let filter: FilterType
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)

                    }
                     //context menu
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark UnContacted" : "Mark Contacted") {
                            self.prospects.toggle(prospect)
                        }
                        
                        if !prospect.isContacted {
                            Button("Remind me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }

                }
            }
                
                
            .navigationBarTitle(Text(title))
                .navigationBarItems(trailing: Button(action: {
                    self.showingScanner = true
                }){
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                })
                .sheet(isPresented: $showingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Sarvad\nsarvadshetty@gmail.com", completion: self.handleScan)
            }
        }
    }
    
    //MARK: - Methods
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.showingScanner = false
        
        //getting results
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            self.prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed \(error)")
        }
    }
    
    func addNotification(for prospect:Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addReq = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addReq()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
                    if success {
                        addReq()
                    } else {
                        print("Ah shit!")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}

//MARK: - Enum Properties
enum FilterType {
    case none, contacted, uncontacted
}
