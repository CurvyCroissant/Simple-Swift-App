// Components/BaseFormLayout.swift

import SwiftUI

struct BaseFormLayout<Content: View, BottomButton: View>: View {
    let title: String
    @ViewBuilder let content: Content
    @ViewBuilder let bottomButton: BottomButton
    
    var body: some View {
        ZStack {
            // MARK: BACKGROUND LAYER
            VStack(spacing: 0) {
                Color(red: 0.09, green: 0.36, blue: 0.62)
                    .frame(height: 350)
                    .ignoresSafeArea(edges: .top)
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea(edges: .bottom)
            }
            
            // MARK: FOREGROUND LAYER
            VStack(spacing: 0) {
                // Inject form here
                content
                
                // Inject button here
                bottomButton
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color(red: 0.09, green: 0.36, blue: 0.62), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
