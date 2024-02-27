//
//  ImageListViewModel.swift
//  FlickrSearch
//
//  Created by Jacob Banks on 2/26/24.
//

import Combine
import Foundation

class ImageListViewModel: ObservableObject {

    @Published var imageList: [ImageData]
    @Published var searchTerms: String
    @Published var isLoading: Bool

    @Published var showErrorAlert: Bool = false
    var error: Error? = nil

    private var cancellables: Set<AnyCancellable> = []

    init(
        imageList: [ImageData] = [],
        searchTerms: String = "",
        isLoading: Bool = true
    ) {
        self.imageList = imageList
        self.searchTerms = searchTerms
        self.isLoading = isLoading

        // Observe changes to the search text and request new images on change
        $searchTerms
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak self] terms in
                self?.isLoading = true
                self?.loadImages(terms)
            }
            .store(in: &cancellables)
    }

    func loadImages(_ search: String = "") {
        let tags = search.replacingOccurrences(of: " ", with: ",")

        Networking.requestImages(tags)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completed in
                switch completed {
                case .finished: break
                case let .failure(error):
                    print(error)
                    self?.error = error
                    self?.showErrorAlert = true
                }
            } receiveValue: { [weak self] images in
                self?.imageList = images
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

}
