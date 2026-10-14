//
//  ProfileView.swift
//  FoundersOS
//
//  Profile tab - User settings and preferences.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("appearanceMode") private var appearanceMode = "system"
    @State private var showAbout = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.founderBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: FounderSpacing.lg) {
                        // Profile Section
                        profileSection
                            .padding(.horizontal, FounderSpacing.lg)
                        
                        // Preferences Section
                        preferencesSection
                            .padding(.horizontal, FounderSpacing.lg)
                        
                        // About Section
                        aboutSection
                            .padding(.horizontal, FounderSpacing.lg)
                    }
                    .padding(.top, FounderSpacing.md)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Profile Section
    
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            Text("Profile")
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
            
            VStack(spacing: 0) {
                ProfileRow(title: "Name", value: "Founder")
                Divider()
                    .background(Color.founderDivider)
                ProfileRow(title: "Email", value: "founder@example.com")
            }
            .background(Color.founderCard)
            .cornerRadius(FounderCornerRadius.large)
        }
    }
    
    // MARK: - Preferences Section
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            Text("Preferences")
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
            
            VStack(spacing: 0) {
                HStack {
                    Text("Appearance")
                        .font(FounderTypography.body)
                        .foregroundColor(.founderPrimaryText)
                    
                    Spacer()
                    
                    Picker("", selection: $appearanceMode) {
                        Text("System").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    .pickerStyle(.menu)
                    .tint(.founderAccent)
                }
                .padding(FounderSpacing.md)
            }
            .background(Color.founderCard)
            .cornerRadius(FounderCornerRadius.large)
        }
    }
    
    // MARK: - About Section
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            Text("About")
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
            
            VStack(spacing: 0) {
                HStack {
                    Text("FounderOS")
                        .font(FounderTypography.body)
                        .foregroundColor(.founderPrimaryText)
                    
                    Spacer()
                    
                    Text("Version \(AppConstants.appVersion)")
                        .font(FounderTypography.subheadline)
                        .foregroundColor(.founderSecondaryText)
                }
                .padding(FounderSpacing.md)
                
                Divider()
                    .background(Color.founderDivider)
                
                Button {
                    // Open privacy policy
                } label: {
                    HStack {
                        Text("Privacy Policy")
                            .font(FounderTypography.body)
                            .foregroundColor(.founderPrimaryText)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(FounderTypography.caption)
                            .foregroundColor(.founderSecondaryText)
                    }
                    .padding(FounderSpacing.md)
                }
                
                Divider()
                    .background(Color.founderDivider)
                
                Button {
                    // Open terms of service
                } label: {
                    HStack {
                        Text("Terms of Service")
                            .font(FounderTypography.body)
                            .foregroundColor(.founderPrimaryText)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(FounderTypography.caption)
                            .foregroundColor(.founderSecondaryText)
                    }
                    .padding(FounderSpacing.md)
                }
            }
            .background(Color.founderCard)
            .cornerRadius(FounderCornerRadius.large)
        }
    }
}

// MARK: - Profile Row Component

struct ProfileRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(FounderTypography.body)
                .foregroundColor(.founderPrimaryText)
            
            Spacer()
            
            Text(value)
                .font(FounderTypography.body)
                .foregroundColor(.founderSecondaryText)
        }
        .padding(FounderSpacing.md)
    }
}

#Preview {
    ProfileView()
}
