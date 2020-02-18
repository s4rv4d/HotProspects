//
//  Prospects.swift
//  HotProspects
//
//  Created by Sarvad shetty on 2/14/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable{
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
//    “this property can be read from anywhere, but only written from the current file”
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    //MARK: - Property wrappers
    @Published private(set) var people: [Prospect]
    
    //MARK: - Properties
    static let savedKey = "SavedData"
    
    //MARK: - Initializers
    init() {
        //using Self cause of static property
        if let data = UserDefaults.standard.data(forKey: Self.savedKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        self.people = []
    }
    
    //MARK: - Functions
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.savedKey)
        }
    }
    
    func add(_ prospect:Prospect) {
        people.append(prospect)
        save()
    }
}
