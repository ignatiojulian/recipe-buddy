//
//  EmptyStateView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack {
            Image(systemName: "tray")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text(message)
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
    }
}
