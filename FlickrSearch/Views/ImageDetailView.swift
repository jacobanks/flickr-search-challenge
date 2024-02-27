//
//  ImageDetailView.swift
//  FlickrSearch
//
//  Created by Jacob Banks on 2/26/24.
//

import SwiftUI

struct ImageDetailView: View {

    private let imageData: ImageData

    init(_ photo: ImageData) {
        self.imageData = photo
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text(imageData.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                imageView()

                detailsView()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let url = imageData.media.url {
                ShareLink(item: url)
            }
        }
    }

    private func imageView() -> some View {
        VStack {
            AsyncImage(
                url: imageData.media.url,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            )

            if let dimensions = imageData.dimensions {
                Text(dimensions)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    private func detailsView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(imageData.username)
                .font(.headline)

            Text(imageData.publishedDate)
                .font(.subheadline)

            if let description = imageData.formattedDescription {
                Text("Description:")
                    .font(.headline)
                    .padding(.top, 16)
                
                Text(description)
                    .font(.body)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }

}

#Preview {
    ImageDetailView(.mock())
}
