//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Sarvad shetty on 2/14/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI
import CodeScanner

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
            
            self.prospects.people.append(person)
        case .failure(let error):
            print("Scanning failed")
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
