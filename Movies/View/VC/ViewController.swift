//
//  ViewController.swift
//  Movies
//
//  Created by Erdinç Ayvaz on 17.08.2022.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    var selectedMovieID:Int?
    var selectedMovieTitle:String?
    var viewModel = MoviesViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var slideIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var upComingIndicatorView: UIActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModelObserver()
        setupTableView()
        viewModel.getNowPlaying()
        viewModel.getUpComing()
    }
    
    //MARK: - Statusbar Text Color = White
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    //MARK: - PageControl kurulumu
    func setupPageControl(item:UpComing?){
        pageControl.numberOfPages = item?.results.count ?? 0
        pageControl.currentPage = 0
    }
    
    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
        //move page to wanted page
        let page: Int? = pageControl.currentPage
        if let page = page {
            let item:NowPlayingResult = (viewModel.nowPlaying.value?.results[page])!
            selectedMovieID = item.id
            selectedMovieTitle = item.title
            performSegue(withIdentifier: "movieDetail", sender: nil)
        }
    }
    
    //MARK: - Scrollview Kurulumu
    func setupScrollView(nowPlaying:NowPlaying){
        
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 256)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(nowPlaying.results.count), height: 256)
        scrollView.isPagingEnabled = true
        
        let slides:[Slide] = createSlides(nowPlaying: nowPlaying)
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: 256)
            scrollView.addSubview(slides[i])
        }
    }
    
    //MARK: - Scrollview için design oluşturma
    func createSlides(nowPlaying:NowPlaying) -> [Slide] {

        var slides = [Slide]()
        for item in nowPlaying.results {
            let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide.imgBackground.image = UIImage(systemName: "trash")
            
            slide.imgBackground.kf.setImage(with: URL(string:Constant.imageBaseURL + item.backdropPath))
            slide.lblTitle.text = item.title
            slide.lblDescription.text = item.overview
            slide.view.addTarget(self, action: #selector(self.pageControlSelectionAction(_:)), for: .touchUpInside)
            slides.append(slide)
        }
        
        return slides
    }
    
    //MARK: - TableView Kurulumu
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.bounds = CGRect(x: 0,
                                       y: 250,
                                       width: refreshControl.bounds.size.width,
                                       height: refreshControl.bounds.size.height)
        tableView.refreshControl = refreshControl
        
        let moviesTableViewCell = UINib(nibName: "MoviesTableViewCell", bundle: nil)
        self.tableView.register(moviesTableViewCell, forCellReuseIdentifier: "MoviesTableViewCell")
    }

    //MARK: - ViewModel ve Data Binding işlemleri
    fileprivate func setupViewModelObserver() {
        viewModel.nowPlaying.bind { [weak self] (nowPlaying) in
            DispatchQueue.main.async {
                self?.setupScrollView(nowPlaying: nowPlaying!)
            }
        }
        
        viewModel.upComing.bind { [weak self] (upComing) in
            DispatchQueue.main.async {
                self?.setupPageControl(item: upComing ?? nil)
                self?.tableView.reloadData()
            }
        }
        
        viewModel.isLoadingSlide.bind { [weak self] (isLoading) in
            guard let isLoading = isLoading else { return }
            DispatchQueue.main.async { [self] in
                isLoading ? self?.slideIndicatorView.startAnimating() : self?.slideIndicatorView.stopAnimating()
                self?.slideIndicatorView.isHidden = !isLoading
            }
        }
        
        viewModel.isLoading.bind { [weak self] (isLoading) in
            guard let isLoading = isLoading else { return }
            DispatchQueue.main.async { [self] in
                isLoading ? self?.upComingIndicatorView.startAnimating() : self?.upComingIndicatorView.stopAnimating()
                self?.upComingIndicatorView.isHidden = !isLoading
            }
        }
        
        viewModel.alertItem.bind{ [weak self] (alert) in
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

// MARK: - TableView Delegate, Datasource, Refresh İşlemleri
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upComing.value?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell") as? MoviesTableViewCell {
            let item:UpComingResult = (viewModel.upComing.value?.results[indexPath.row])!
            cell.imgMovie.kf.setImage(with: URL(string: Constant.imageBaseURL + (item.posterPath ?? "")))
            cell.lblMovieTitle.text = item.title
            cell.lblMovieDescription.text = item.overview
            cell.lblDate.text = item.releaseDate?.dateFormatMovie()
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item:UpComingResult = (viewModel.upComing.value?.results[indexPath.row])!
        selectedMovieID = item.id
        selectedMovieTitle = item.title
        performSegue(withIdentifier: "movieDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "movieDetail" {
            let vc = segue.destination as! MovieDetailViewController
            if let selectedMovieID = selectedMovieID, let selectedMoviewTitle = selectedMovieTitle {
                vc.movieID = selectedMovieID
                vc.movieTitle = selectedMoviewTitle
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.getUpComing()
        viewModel.getNowPlaying()
        refreshControl.endRefreshing()
    }
}

// MARK: - ScrollView Delegate İşlemleri
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
