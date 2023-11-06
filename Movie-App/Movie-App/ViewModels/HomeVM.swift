//
//  HomeVM.swift
//  Movie-App
//
//  Created by Yaşar Duman on 31.10.2023.
//


// MARK: - Sections Enum
enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

protocol HomeVMInterface {
    var view: HomeViewInterface? { get set }
    func getMovies()
}

final class HomeVM {
    weak var view: HomeViewInterface?
  
    func showLoadingView() {
        view?.showLoadingIndicator()
       }
    
    func hideLoadingView() {
           view?.dismissLoadingIndicator()
       }
}


extension HomeVM: HomeVMInterface {
    func getMovies(){
        showLoadingView()
        Task{
            do {
                let getTrendingMovies  = try await APICaller.shared.getTrendingMovies().results
                let getTrendingTVs     = try await APICaller.shared.getTrendingTVs().results
                let getUpcomingMovies  = try await APICaller.shared.getUpcomingMovies().results
                let getPopularMovies   = try await APICaller.shared.getPopular().results
                let getTopRated        = try await APICaller.shared.getTopRated().results
                
                view?.SaveDatas(with: getTrendingMovies, tvs: getTrendingTVs, upcoming: getUpcomingMovies, popular: getPopularMovies, topRated: getTopRated)
                view?.configureHeaderView(with: getTrendingMovies)
                hideLoadingView()
            }catch {
                if let movieError = error as? MovieError {
                    print(movieError.rawValue)
                } else {
                   
                }
                hideLoadingView()
            }
        }
    }
}
