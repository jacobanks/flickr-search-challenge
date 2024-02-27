//
//  ImageListView.swift
//  FlickrSearch
//
//  Created by Jacob Banks on 2/26/24.
//

import Combine
import SwiftUI

struct ImageListView: View {

    @StateObject private var viewModel: ImageListViewModel = .init()

    private let gridColumns: [GridItem] = [
        .init(.adaptive(minimum: 150, maximum: .infinity), spacing: 4)
    ]

    var body: some View {
        imageGrid()
            .navigationTitle("Home")
            .alert(
                "Error Loading Images",
                isPresented: $viewModel.showErrorAlert,
                actions: {
                    Button("Cancel", role: .cancel) {}
                    Button("Retry") { viewModel.loadImages() }
                },
                message: {
                    Text(viewModel.error?.localizedDescription ?? "Failed to retrieve images.")
                }
            )
    }

    private func imageGrid() -> some View {
        ScrollView {
            HStack(spacing: 4) {
                VStack(spacing: 4) {
                    ForEach(viewModel.imageList[..<(viewModel.imageList.count/2)], content: gridItem(_:))
                }

                VStack(spacing: 4) {
                    ForEach(viewModel.imageList[(viewModel.imageList.count/2)...], content: gridItem(_:))
                }
            }
            .padding(12)
            .progress($viewModel.isLoading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .refreshable { viewModel.loadImages(viewModel.searchTerms) }
        .searchable(text: $viewModel.searchTerms)
        .overlay {
            if viewModel.imageList.isEmpty && !viewModel.isLoading {
                VStack(spacing: 12) {
                    Text("No Images To Display.")

                    Button("Retry Loading") {
                        viewModel.loadImages(viewModel.searchTerms)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    private func gridItem(_ photo: ImageData) -> some View {
        NavigationLink(
            destination: ImageDetailView(photo),
            label: {
                AsyncImage(
                    url: photo.media.url,
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                    },
                    placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white.opacity(0.3))
                    }
                )
            }
        )
        .buttonStyle(ImageButtonStyle())
    }

}

struct ImageButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .cornerRadius(5)
            .scaleEffect(configuration.isPressed ? 0.90 : 1)
            .animation(.linear(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        ImageListView()
    }
    .preferredColorScheme(.dark)
}
