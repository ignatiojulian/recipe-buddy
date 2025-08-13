//
//  FilterView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct FilterView: View {
    @EnvironmentObject var recipeStore: RecipeStoreViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Sort By") {
                    Picker("Sort", selection: $recipeStore.sortOption) {
                        ForEach(RecipeStoreViewModel.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section("Filter by Tag") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Button(action: {
                                recipeStore.selectedTag = nil
                            }) {
                                Text("All")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(recipeStore.selectedTag == nil ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(recipeStore.selectedTag == nil ? .white : .primary)
                                    .cornerRadius(8)
                            }
                            
                            ForEach(recipeStore.allTags, id: \.self) { tag in
                                Button(action: {
                                    recipeStore.selectedTag = tag
                                }) {
                                    Text(tag)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(recipeStore.selectedTag == tag ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(recipeStore.selectedTag == tag ? .white : .primary)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
