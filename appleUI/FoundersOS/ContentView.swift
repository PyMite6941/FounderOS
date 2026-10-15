//
//  ContentView.swift
//  FoundersOS
//
//  Main content view with TabView navigation.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            // Ideas Tab
            IdeasView()
                .tabItem {
                    Label("Ideas", systemImage: "lightbulb.fill")
                }
                .tag(1)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(.founderAccent)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: StartupIdea.self, inMemory: true)
}
