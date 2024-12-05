import XCTest
@testable import SynonymsApp

final class AddSynonymTests: XCTestCase {
    
    private var viewModel: AddSynonymViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AddSynonymViewModel()
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
    
    private func testAddSynonyms_SuccessfulAddition() {
        viewModel.newWord = "orange"
        viewModel.wordSynonyms = "citrus, tangerine"
        let result = viewModel.addSynonyms()
        XCTAssertTrue(result, "Expected synonyms to be successfully added.")
    }
    
    private func testAddSynonyms_BlankInputError() {
        viewModel.newWord = ""
        viewModel.wordSynonyms = ""
        let result = viewModel.addSynonyms()
        XCTAssertFalse(result, "Expected addSynonyms to fail for blank input.")
        XCTAssertEqual(viewModel.toastMessage, "ADD_SYNONYM.BLANK_INPUT_ERROR_MESSAGE".localized)
    }
    
    private func testAddSynonyms_DuplicateInDifferentSets() {
        viewModel.newWord = "empty"
        viewModel.wordSynonyms = "weak"
        let result = viewModel.addSynonyms()
        XCTAssertFalse(result, "Expected addSynonyms to fail if synonyms exist in different sets.")
        XCTAssertEqual(viewModel.toastMessage, "ADD_SYNONYM.INVALID_INPUT_ERROR_MESSAGE".localized)
    }
}
