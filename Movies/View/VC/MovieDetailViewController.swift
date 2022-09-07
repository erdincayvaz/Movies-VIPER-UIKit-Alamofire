//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Erdinç Ayvaz on 17.08.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieID:Int?
    var movieTitle:String?
    var viewModel = MovieDetailViewModel()
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movieID = movieID , let movieTitle = movieTitle{
            self.title = movieTitle
            setupViewModelObserver()
            viewModel.getMovieDetail(id: movieID)
        }
    }
    
    //MARK: - Statusbar Text Color = Black
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .darkContent
    }

    // MARK: - ViewModel Data Binding İşlemleri
    fileprivate func setupViewModelObserver() {
        viewModel.movie.bind { [weak self] (movie) in
            DispatchQueue.main.async {
                self?.imgPoster.kf.setImage(with: URL(string: Constant.imageBaseURL + (movie?.backdropPath ?? "")))
                self?.lblTitle.text = movie?.title ?? ""
                self?.lblDescription.text = (movie?.overview ?? "") + "\n\n" + (movie?.overview ?? "")
                self?.lblDate.text = movie?.releaseDate?.dateFormatMovie() ?? ""
                self?.lblPoint.pointFormat(value: movie?.voteAverage ?? 0.0)
            }
        }
        
        viewModel.isLoading.bind{ [weak self] (isLoading) in
            guard let isLoading = isLoading else { return }
            DispatchQueue.main.async {
                self?.infoView.isHidden = isLoading
            }
        }
        
        viewModel.alertItem.bind{ [weak self] (_) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: self?.viewModel.alertItem.value?.title ?? "Uyarı",
                                              message: self?.viewModel.alertItem.value?.message ?? "Bir Hata Oluştu",
                                              preferredStyle: .alert)
                let okButton = UIAlertAction(title: self?.viewModel.alertItem.value?.dismissButton ?? "Tamam", style: .default)
                alert.addAction(okButton)
                self?.present(alert, animated: true)
            }
        }
    }
}
