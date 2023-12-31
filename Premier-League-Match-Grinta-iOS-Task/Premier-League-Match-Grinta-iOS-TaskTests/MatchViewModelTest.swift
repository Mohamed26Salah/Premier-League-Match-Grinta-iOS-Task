//
//  MatchViewModelTest.swift
//  Premier-League-Match-Grinta-iOS-TaskTests
//
//  Created by Mohamed Salah on 13/10/2023.
//

import XCTest
import Foundation
import RxTest
import RxSwift
import RxRelay
@testable import Premier_League_Match_Grinta_iOS_Task

final class MatchViewModelTest: XCTestCase {
    
    var disposeBag: DisposeBag!
    var sut: MatchViewModel!
    var apiServiceMock: APIManagerMock!
    var apiManager: APIManager!
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        apiServiceMock = APIManagerMock()
        sut = MatchViewModel(apiManager: apiServiceMock)
        apiManager = APIManager()
    }
    
    override func tearDownWithError() throws {
        disposeBag = nil
        apiServiceMock = nil
        sut = nil
        apiManager = nil
    }
    func test_Get_All_Matches(){
        let expectedMatcheArray: Matches = Matches(matches: [Match.mock, Match.mock])
        apiServiceMock.fetchGlobalResult = Observable.just(expectedMatcheArray)
        sut.getMatches()
        XCTAssertTrue(apiServiceMock.fetchGlobalCalled)
    }
    func test_Get_All_Matches_Fails() {
        let expectedError = NSError(domain: "Test", code: 1, userInfo: nil)
        apiServiceMock.fetchGlobalError = expectedError
        
        let expectation = self.expectation(description: "Error emitted")
        
        let disposable = sut.errorSubject.subscribe(onNext: { error in
            XCTAssertEqual(error as NSError, expectedError)
            expectation.fulfill()
        })
        sut.getMatches()
        waitForExpectations(timeout: 5.0, handler: nil)
        disposable.dispose()
    }
//    func testApiFetchSuccessful() {
//        let expectation = XCTestExpectation(description: "Data Parsed")
////        var responseError: Error?
//        var MatchesModel: Matches?
//        guard let url = Bundle(for: type(of: self)).url(forResource: "stub", withExtension: "json") else {
//            XCTFail("Failed to load JSON file")
//            return
//        }
//        let disposable = apiManager.fetchLocalFile(parsingType: Matches.self, localFilePath: url).subscribe(onNext: { MatchesM in
//            MatchesModel = MatchesM
//            expectation.fulfill()
//        })
//        waitForExpectations(timeout: 5.0, handler: nil)
//        XCTAssertNotNil(MatchesModel)
//        disposable.dispose()
//    }
    
    func testFormatDate() {
        let dateString = Match.mock.utcDate
        let formattedDate = sut.formatDate(dateString: dateString)
        XCTAssertEqual(formattedDate, "01/01")
        
        let formattedDateYearly = sut.formatDate(dateString: dateString, yearly: true)
        XCTAssertEqual(formattedDateYearly, "01/01/2023")
    }
    
    func testFormatTime() {
        let dateString = Match.mock.utcDate
        let formattedTime = sut.formatTime(dateString: dateString)
        XCTAssertEqual(formattedTime, "02:00")
    }
    func testCategorizeMatches2() {
        var match1 = Match.mock
        match1.utcDate = "2023-01-01T00:00:00Z"
        
        var match2 = Match.mock
        match2.utcDate = "2023-02-01T00:00:00Z"
        
        var match3 = Match.mock
        match3.utcDate = "2023-03-01T00:00:00Z"
        
        let matches = [match1, match2, match3]
        
        let categorizedMatches = sut.categorizeMatches(matches)
        
        XCTAssertEqual(categorizedMatches.count, 3)
        
        XCTAssertEqual(categorizedMatches[0].0, "01/01/2023")
        XCTAssertEqual(categorizedMatches[0].1, [match1])
        
        XCTAssertEqual(categorizedMatches[1].0, "02/01/2023")
        XCTAssertEqual(categorizedMatches[1].1, [match2])
        
        XCTAssertEqual(categorizedMatches[2].0, "03/01/2023")
        XCTAssertEqual(categorizedMatches[2].1, [match3])
    }

}
