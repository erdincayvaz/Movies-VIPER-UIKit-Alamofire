//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Erdinç Ayvaz on 17.08.2022.
//

import Foundation
import Alamofire

class MoviesViewModel {
    
    var nowPlaying = Observable<NowPlaying>()
    var upComing = Observable<UpComing>()
    var isLoadingSlide = Observable<Bool>()
    var isLoading = Observable<Bool>()
    var alertItem = Observable<AlertItem>()
    
    func getNowPlaying(){
        isLoadingSlide.value = true
        
        NetworkManager.instance.fetch(endpoint: MoviesEndpoint.nowPlaying, responseModel: NowPlaying.self){ [self] result in
            
            DispatchQueue.main.async { [self] in
                isLoadingSlide.value = false
                
                switch result {
                case .success(let result):
                    self.nowPlaying.value = result
                    
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
    
    func getUpComing(){
        isLoading.value = true
        
        NetworkManager.instance.fetch(endpoint: MoviesEndpoint.upComing, responseModel: UpComing.self){ [self] result in
            
            DispatchQueue.main.async { [self] in
                isLoading.value = false
                
                switch result {
                case .success(let result):
                    self.upComing.value = result
                    
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
