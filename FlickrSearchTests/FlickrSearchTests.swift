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

        try loadImages(viewModel)
    }

    func testSearchImages() throws {
        // Init view model
        let viewModel: ImageListViewModel = .init()

        // Load images with the search text
        let searchText1 = "porcupine"
        try loadImages(viewModel, search: searchText1)
        XCTAssert(viewModel.imageList[0].tags.contains(searchText1)) // Confirm that the search tags appear in response

        // Try another search string
        let searchText2 = "red car"
        try loadImages(viewModel, search: searchText2)

        let tags = viewModel.imageList[0].tags
        let searchArray = searchText2.split(separator: " ")

        // Confirm that ALL of the search tags appear in response
        XCTAssert(searchArray.filter { tags.contains($0) }.count == searchArray.count)
    }

    private func loadImages(_ viewModel: ImageListViewModel, search: String = "") throws {
        let expectation = XCTestExpectation(description: "")

        viewModel.loadImages(search)

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

}
