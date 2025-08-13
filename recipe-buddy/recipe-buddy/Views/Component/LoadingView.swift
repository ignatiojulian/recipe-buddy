//
//  LoadingView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Loading recipes...")
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
    }
}
