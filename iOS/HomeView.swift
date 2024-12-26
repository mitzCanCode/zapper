//
//  HomeView.swift
//  zapperSwift
//
//  Created by Alex Amygdalios on 25/12/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                // HomeView in testing state.
                Text("App in testing state")
                    .font(.subheadline)
                    .padding(.bottom)
                NavigationLink(
                    destination: SendMessageView(),
                    label: {
                        Text("Go to Message View") // Label for the link
                    }
                )
            }
            .navigationTitle("Zapper")
        }
    }
}

#Preview {
    HomeView()
}
