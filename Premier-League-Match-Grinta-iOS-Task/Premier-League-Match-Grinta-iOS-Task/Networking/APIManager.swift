//
//  APIManager.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

protocol APIClientProtocol {
    func fetchGlobal<T: Codable>(
        parsingType: T.Type,
        baseURL: URL,
        attributes: [String]?,
        queryParameters: [String: String]?,
        jsonBody: [String: Any]?,
        headers: [String: String]?
    ) -> Observable<T>
    func fetchLocalFile<T: Codable>(
        parsingType: T.Type,
        localFilePath: URL
    ) -> Observable<T>
}

extension APIClientProtocol {
    func fetchGlobal<T: Codable>(
        parsingType: T.Type,
        baseURL: URL,
        attributes: [String]? = nil,
        queryParameters: [String: String]? = nil,
        jsonBody: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) -> Observable<T> {
        return fetchGlobal(parsingType: parsingType, baseURL: baseURL, attributes: attributes, queryParameters: queryParameters, jsonBody: nil, headers: headers)
    }
}

class APIManager: APIClientProtocol {

    let disposeBag = DisposeBag()
    enum EndPoint {

        case matches(competitionCode: String)

        var stringValue: String {
            switch self {
            case .matches(let competitionCode):
                return SecurityConstants.Links.baseUrl + "competitions/\(competitionCode)/matches"
            }
        }

        var stringToUrl: URL {
            return URL(string: stringValue)!
        }
    }
    private enum APIError: Swift.Error {
        case invalidResponse(URLResponse?)
        case invalidJSON(Swift.Error)
    }

    private func buildURL(baseURL: URL, attributes: [String]?, queryParameters: [String: String]?) -> URL? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        if let attributes = attributes, !attributes.isEmpty {
            components.path += "/" + attributes.joined(separator: "/")
        }
        if let queryParameters = queryParameters {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return components.url
    }

    private func buildRequest(url: URL, method: String, jsonBody: [String: Any]?, headers: [String: String]?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let jsonBody = jsonBody {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) {
                request.httpBody = jsonData
            }
        }
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }

    func fetchGlobal<T: Codable>(
        parsingType: T.Type,
        baseURL: URL,
        attributes: [String]? = nil,
        queryParameters: [String: String]? = nil,
        jsonBody: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) -> Observable<T> {
        return Observable<T>.create { observer in
            guard let url = self.buildURL(baseURL: baseURL, attributes: attributes, queryParameters: queryParameters) else {
                observer.onError(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
                return Disposables.create()
            }
            let method = jsonBody != nil ? "POST" : "GET"
            let request = self.buildRequest(url: url, method: method, jsonBody: jsonBody, headers: headers)
            AF.request(request).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func fetchLocalFile<T: Codable>(
        parsingType: T.Type,
        localFilePath: URL
    ) -> Observable<T> {
        guard let data = try? Data(contentsOf: localFilePath) else {
            return Observable.error(APIError.invalidJSON(NSError(domain: "Failed to load local JSON file", code: -1, userInfo: nil)))
        }

        do {
            let decodedData = try JSONDecoder().decode(parsingType.self, from: data)
            return Observable.just(decodedData)
        } catch let error {
            return Observable.error(APIError.invalidJSON(error))
        }
    }

}
