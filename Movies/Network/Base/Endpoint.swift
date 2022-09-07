//
//  Endpoint.swift
//  Movies
//
//  Created by BRR on 19.08.2022.
//
import Alamofire

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var param: [String: String]? { get }
    var header: HTTPHeaders { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.themoviedb.org"
    }
}
