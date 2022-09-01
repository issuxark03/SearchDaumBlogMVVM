//
//  SearchBlogNetwork.swift
//  SearchDaumBlog
//
//  Created by Yongwoo Yoo on 2022/07/19.
//

import Foundation
import RxSwift

enum SearchNetworkError: Error {
    case invaildURL
    case invaildJSON
    case networkError
}

class SearchBlogNetwork {
    private let session : URLSession
    let api = SearchBlogAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchBlog(query: String) -> Single<Result<DKBlog, SearchNetworkError>>{
        guard let url = api.searchBlog(query: query).url else { return .just(.failure(.invaildURL)) }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK cfc8c40eafc41f8dbce36a05692f514e", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                    return .success(blogData)
                } catch {
                    return .failure(.invaildJSON)
                }
            }
            .catch { _ in
            .just(.failure(.networkError))
            }
            .asSingle()
    }
}
