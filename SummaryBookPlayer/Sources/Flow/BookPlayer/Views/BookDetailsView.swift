//
//  BookDetailsView.swift
//  SummaryBookPlayer
//
//  Created by Daria on 02.08.2024.
//

import SwiftUI

struct BookDetailsView: View {
    
    @ObservedObject var viewModel: BookPlayerViewModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: SharedLinks.Cover.musicIndustryBook.url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 350.0)
            } placeholder: {
                ProgressView()
                    .frame(width: 100.0, height: 100.0)
                    .zIndex(-1.0)
            }
            .padding(.bottom, 24.0)
            
            Text("key point \(viewModel.numberOfChapter) of \(viewModel.numberOfChapters)")
                .foregroundStyle(.grayFont)
                .font(.system(size: 14.0, weight: .semibold))
                .textCase(.uppercase)
                .frame(alignment: .center)
                .padding(.horizontal, 24.0)
                .padding(.bottom, 12.0)
            
            Text(viewModel.currentBook.title)
                .foregroundStyle(.blackFont)
                .font(.system(size: 16.0, weight: .light))
                .lineLimit(4)
                .multilineTextAlignment(.center)
                .frame(alignment: .top)
                .padding(.horizontal, 32.0)
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: 45.0, alignment: .top)
        }
    }
    
}
