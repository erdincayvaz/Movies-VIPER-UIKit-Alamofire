//
//  NetworkError.swift
//  Movies
//
//  Created by Erdinç Ayvaz on 17.08.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}
