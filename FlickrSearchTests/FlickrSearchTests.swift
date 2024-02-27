//
//  FlickrSearchTests.swift
//  FlickrSearchTests
//
//  Created by Jacob Banks on 2/26/24.
//

import Combine
import XCTest
@testable import FlickrSearch

final class FlickrSearchTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialFetchImages() throws {
        // Init view model
        let viewModel: ImageListViewModel = .init()
        XCTAssert(viewModel.imageList.count == 0)

        let expectation = XCTestExpectation(description: "")

        // Wait for isLoading to update
        viewModel.$isLoading
            .sink { loading in
                guard !loading else { return }
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation])

        // Confirm that imageList loaded data and is not empty
        XCTAssert(!viewModel.imageList.isEmpty)
        XCTAssert(viewModel.isLoading == false)
    }

    func testSearchImages() throws {
        // Init view model
        let viewModel: ImageListViewModel = .init()

        // Load images with the search text
        let searchText1 = "porcupine"
        try searchImages(viewModel, search: searchText1)

        // Try another search string with multiple words
        let searchText2 = "red car"
        try searchImages(viewModel, search: searchText2)
    }

    private func searchImages(_ viewModel: ImageListViewModel, search: String = "") throws {
        let expectation = XCTestExpectation(description: "")
        let searchArray = search.split(separator: " ")

        // Update searchTerms so new images will be loaded
        viewModel.searchTerms = search

        // Wait for the image list to update
        viewModel.$imageList
            .sink { images in
                // Confirm that ALL of the search tags appear in the images
                let matchingTags = searchArray.filter { images.first?.tags.contains($0) ?? false }
                guard matchingTags.count == searchArray.count else { return }
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)

        // Confirm that imageList loaded data and is not empty
        XCTAssert(!viewModel.imageList.isEmpty)
        XCTAssert(viewModel.isLoading == false)
    }

}
