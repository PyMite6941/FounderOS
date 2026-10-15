//
//  IdeasView.swift
//  FoundersOS
//
//  Ideas tab - View and manage saved startup ideas.
//

import SwiftUI
import SwiftData

struct IdeasView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \StartupIdea.createdAt, order: .reverse) private var ideas: [StartupIdea]
    
    @State private var selectedIdea: StartupIdea?
    @State private var showDeleteConfirmation = false
    @State private var ideaToDelete: StartupIdea?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.founderBackground
                    .ignoresSafeArea()
                
                // Content
                if ideas.isEmpty {
                    EmptyStateView(
                        title: "Your next company starts here.",
                        subtitle: "Turn a rough idea into a real MVP.",
                        buttonTitle: "Create your first idea"
                    ) {
                        // Navigate to home and create idea
                        // This would typically use a tab selection or navigation
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: FounderSpacing.md) {
                            ForEach(ideas) { idea in
                                StartupCard(startup: idea) {
                                    selectedIdea = idea
                                }
                                .contextMenu {
                                    Button {
                                        selectedIdea = idea
                                    } label: {
                                        Label("View Details", systemImage: "eye")
                                    }
                                    
                                    Button(role: .destructive) {
                                        ideaToDelete = idea
                                        showDeleteConfirmation = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, FounderSpacing.lg)
                        .padding(.top, FounderSpacing.md)
                    }
                }
            }
            .navigationTitle("Your Ideas")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(item: $selectedIdea) { idea in
                StartupDetailView(startup: idea)
            }
            .confirmationDialog(
                "Delete this idea?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    if let idea = ideaToDelete {
                        deleteIdea(idea)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func deleteIdea(_ idea: StartupIdea) {
        PersistenceService.shared.deleteStartup(idea, context: modelContext)
        ideaToDelete = nil
    }
}

#Preview {
    IdeasView()
        .modelContainer(for: StartupIdea.self, inMemory: true)
}
