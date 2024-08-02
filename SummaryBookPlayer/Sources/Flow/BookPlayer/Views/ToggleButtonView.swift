//
//  ToggleButtonView.swift
//  SummaryBookPlayer
//
//  Created by Daria on 02.08.2024.
//

import SwiftUI

struct ToggleButtonView: View {
    
    @State private var isButtonSelected = true
    @State private var position: CGFloat = -16.0
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 48.0)
                    .stroke(.gray, lineWidth: 0.5)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 60)
                            .fill(Color.white)
                    )
                
                HStack {
                    Button(action: {
                        withAnimation(.smooth(duration: 0.1)) {
                            position = -15.0
                            isButtonSelected = true
                        }
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(Color.blue)
                                .frame(width: 56.0, height: 56.0)
                                .offset(x: position)
                            
                            Image(systemName: "headphones")
                                .foregroundColor(isButtonSelected ? .white : .black)
                                .font(.system(size: 20.0, weight: .medium))
                                .clipShape(Circle())
                                .padding(.leading, -28.0)
                        }
                        .frame(width: 56.0, height: 56.0)
                    }
                    
                    Button(action: {
                        withAnimation(.smooth(duration: 0.1)) {
                            position = 49.0
                            isButtonSelected = false
                        }
                    }) {
                        ZStack {
                            Image(systemName: "text.alignleft")
                                .foregroundColor(isButtonSelected ? .black : .white)
                                .font(.system(size: 20.0, weight: .medium))
                        }
                    }
                }.padding(.horizontal, 20.0)
            }
            .frame(width: 124.0, height: 64.0)
        }
    }
    
}

