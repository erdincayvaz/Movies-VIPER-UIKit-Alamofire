//
//  MoviesEndpoint.swift
//  Movies
//
//  Created by BRR on 19.08.2022.
//
import Alamofire

enum MoviesEndpoint {
    case nowPlaying
    case upComing
    case movieDetail(id: Int)
}

extension MoviesEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "/3/movie/now_playing"
        case .upComing:
            return "/3/movie/upcoming"
        case .movieDetail(let id):
            return "/3/movie/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .nowPlaying, .upComing, .movieDetail:
            return .get
        }
    }
    
    var param: [String : String]? {
        switch self {
        case .nowPlaying, .upComing, .movieDetail:
            return ["api_key": Constant.apiKey,
                    "language":"tr-TR"]
        }
    }

    var header: HTTPHeaders {
        //let accessToken = "0c9a57d0308b2b382366fd7abc78d1ca"
        switch self {
        case .nowPlaying, .upComing, .movieDetail:
            return [
                //"Authorization": "Bearer \(accessToken)",
                "Accept": "*/*",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .nowPlaying, .upComing, .movieDetail:
            return nil
        }
    }
}
