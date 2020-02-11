//
//  DelayedUpdaterClass.swift
//  HotProspects
//
//  Created by Sarvad shetty on 2/11/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI
import Foundation

class DelayedUpdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
                print(self.value)
            }
        }
    }
}
