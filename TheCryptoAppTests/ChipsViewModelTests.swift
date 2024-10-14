//
//  ChipsViewModelTests.swift
//  TheCryptoApp
//
//  Created by Vaishnav on 15/10/24.
//


import XCTest
@testable import TheCryptoApp

class ChipsViewModelTests: XCTestCase {
    
    func testRemoveFilters() {
        let initialOptions = ["Ethereum", "Bitcoin"]
        let chipsViewModel = MockChipsViewModel(filterOptions: initialOptions)
        chipsViewModel.deselectFilter("Ethereum")
        XCTAssertFalse(chipsViewModel.selectedFilterData.contains("Ethereum"))
    }
    
    func testAddFilters() {
        let initialOptions = ["Bitcoin"]
        let chipsViewModel = MockChipsViewModel(filterOptions: initialOptions)
        chipsViewModel.selectFilter("Ethereum")
        XCTAssertTrue(chipsViewModel.selectedFilterData.contains("Ethereum"))
    }
}

// MARK: - MOCK View Model
class MockChipsViewModel: ChipsViewModel {
    
    override init(filterOptions: [String]) {
        super.init(filterOptions: filterOptions)
    }
}
