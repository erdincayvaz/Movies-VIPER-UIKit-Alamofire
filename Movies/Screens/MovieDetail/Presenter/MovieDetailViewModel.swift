//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Erdinç Ayvaz on 18.08.2022.
//

import Foundation
import Alamofire

class MovieDetailViewModel {
    
    var isLoading = Observable<Bool>()
    var alertItem = Observable<AlertItem>()
    var movie = Observable<Movie>()
    
    func getMovieDetail(id:Int){
        
        NetworkManager.instance.fetch(endpoint: MoviesEndpoint.movieDetail(id: id), responseModel: Movie.self){ [self] result in
            
            DispatchQueue.main.async { [self] in
                isLoading.value = false
                
                switch result {
                case .success(let result):
                    self.movie.value = result
                    
                case .failure(let error):
                    switch error {
                    case .invalidData:
                        alertItem.value = AlertContext.invalidData
                        
                    case .invalidURL:
                        alertItem.value = AlertContext.invalidURL
                        
                    case .invalidResponse:
                        alertItem.value = AlertContext.invalidResponse
                        
                    case .unableToComplete:
                        alertItem.value = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
}
