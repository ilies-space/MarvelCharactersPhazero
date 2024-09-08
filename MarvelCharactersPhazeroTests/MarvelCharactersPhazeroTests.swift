//
//  MarvelCharactersPhazeroTests.swift
//  MarvelCharactersPhazeroTests
//
//  Created by ilies Ould menouer on 8/9/2024.
//

import XCTest
@testable import MarvelCharactersPhazero

class MarvelCharactersPhazeroTests: XCTestCase {

    var apiService: MarvelAPIService!

    override func setUpWithError() throws {
        apiService = MarvelAPIService.shared
    }

    override func tearDownWithError() throws {
        apiService = nil
    }

    // Test if API returns characters successfully
    func testFetchCharactersSuccess() throws {
        let expectation = self.expectation(description: "Characters fetched successfully")

        apiService.fetchCharacters(offset: 0, limit: 10) { result in
            switch result {
            case .success(let characters):
                XCTAssertFalse(characters.isEmpty, "Expected to fetch some characters")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got failure: \(error)")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    // Test if missing API keys return error
    func testMissingAPIKeys() throws {
        // Temporarily set API keys to nil
        let tempService = MarvelAPIService()
        
        let expectation = self.expectation(description: "Missing API keys handled correctly")

        tempService.fetchCharacters(offset: 0, limit: 10) { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to missing API keys")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, NetworkError.missingAPIKeys)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
