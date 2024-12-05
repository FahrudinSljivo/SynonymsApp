import XCTest
@testable import SynonymsApp

final class SynonymsAppTests: XCTestCase {

    private var viewModel: SearchSynonymsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SearchSynonymsViewModel()
        viewModel.synonymSets = [
            ["empty", "vacant", "unfilled", "unoccupied"],
            ["strong", "powerful", "sturdy", "tough"],
            ["weak", "frail", "fragile"]
        ]
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    private func testCheckForSynonyms_FindsMatchingSet() {
        viewModel.searchText = "strong"
        viewModel.checkForSynonyms()
        
        XCTAssertEqual(viewModel.synonymSetToBeShown, ["strong", "powerful", "sturdy", "tough"], "Expected second synonym set to be shown for 'strong'.")
        XCTAssertTrue(viewModel.showResults, "Expected showResults to be true after search.")
    }

    private func testCheckForSynonyms_NoMatchingSet() {
        viewModel.searchText = "hardened"
        viewModel.checkForSynonyms()

        XCTAssertNil(viewModel.synonymSetToBeShown, "Expected no synonym set to be shown for 'hardened'.")
        XCTAssertTrue(viewModel.showResults, "Expected showResults to be true after search.")
    }

    private func testCheckForSynonyms_CaseInsensitiveMatch() {
        viewModel.searchText = "FRAIL"
        viewModel.checkForSynonyms()
        
        XCTAssertEqual(viewModel.synonymSetToBeShown, ["weak", "frail", "fragile"], "Expected third synonym set to be shown for 'FRAIL' (case-insensitive).")
        XCTAssertTrue(viewModel.showResults, "Expected showResults to be true after search.")
    }
}
