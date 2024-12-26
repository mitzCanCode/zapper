//
//  ContentView.swift
//  zapperSwift
//
//  Created by Alex Amygdalios on 25/12/24.
//

import SwiftUI

struct ContentView: View {
    
    func isLoggedIn() -> Bool {
        // Add logic later, currently in testing state
        return true
    }
    
    
    var body: some View {
        if isLoggedIn() {
            HomeView()
        }else{
            RegisterView()
        }

    }
}

#Preview {
    ContentView()
}
