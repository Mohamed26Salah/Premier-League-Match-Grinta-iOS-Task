//
//  APIManagerMock.swift
//  Premier-League-Match-Grinta-iOS-TaskTests
//
//  Created by Mohamed Salah on 13/10/2023.
//

import Foundation
import RxTest
import RxSwift
import RxRelay
import RxCocoa
@testable import Premier_League_Match_Grinta_iOS_Task

class APIManagerMock: APIClientProtocol {
    
    
    var fetchGlobalCalled = false
    var fetchGlobalResult: Any?
    
    var fetchLocalFileCalled = false
    var fetchLocalFileResult: Any?
    
    var fetchGlobalError: Error?
    var fetchLocalFileError: Error?
    
    func fetchGlobal<T>(request: FetchGlobalRequest<T>) -> Observable<T> {
        fetchGlobalCalled = true
        if let error = fetchGlobalError {
            return Observable.error(error)
        }
        return fetchGlobalResult as! Observable<T>
    }
    
    func fetchLocalFile<T: Codable>(
        parsingType: T.Type,
        localFilePath: URL
    ) -> Observable<T> {
        fetchLocalFileCalled = true
        if let error = fetchLocalFileError {
            return Observable.error(error)
        }
        return fetchLocalFileResult as! Observable<T>
    }
    
}
