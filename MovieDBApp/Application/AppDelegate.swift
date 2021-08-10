//
//  AppDelegate.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import UIKit
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let rootVC = HomePageViewController()
        let navController = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = navController
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //
    }

    
//    func getNowPlaying() {
//        let networkService = NetworkService.share
//        let moviesProvider = MoviesProvider(networkService: networkService)
//
//        moviesProvider.getNowPlayingMovies(page: 1, completion: { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let succesResponse):
//                if let results = succesResponse.results {
//                    print(results)
//                } else {
//                    print("No Movies Found")
//                }
//
//            case .failure:
//                print("Failure")
//            }
//        })
//    }
//
//    func getUpcoming() {
//        let networkService = NetworkService.share
//        let moviesProvider = MoviesProvider(networkService: networkService)
//
//        moviesProvider.getUpcomingMovies(page: 1, completion: { [weak self] result in
//            switch result {
//            case .success(let succesResponse):
//                if let results = succesResponse.results {
//                    print(results)
//                } else {
//                    print("No Movies Found")
//                }
//
//            case .failure:
//                print("Failure")
//            }
//        })
//    }
//
//    func searchMovies(query: String) {
//        let networkService = NetworkService.share
//        let moviesProvider = MoviesProvider(networkService: networkService)
//
//        moviesProvider.searchMovies(query: query,page: 1, completion: { [weak self] result in
//            switch result {
//            case .success(let succesResponse):
//                if let results = succesResponse.results {
//                    print(results)
//                } else {
//                    print("No Movies Found")
//                }
//
//            case .failure:
//                print("Failure")
//            }
//        })
//    }
//
//    func movieById(id: Int) {
//        let networkService = NetworkService.share
//        let moviesProvider = MoviesProvider(networkService: networkService)
//
//        moviesProvider.getMovieById(id: id, page: 1, completion: { [weak self] result in
//            switch result {
//            case .success(let succesResponse):
//                print(succesResponse)
//            case .failure:
//                print("Failure")
//            }
//        })
//    }
//
//    func similarMovies(id: Int) {
//        let networkService = NetworkService.share
//        let moviesProvider = MoviesProvider(networkService: networkService)
//
//        moviesProvider.getSimilarMovies(page: 1, id: id, completion: { [weak self] result in
//            switch result {
//            case .success(let succesResponse):
//                if let results = succesResponse.results {
//                    print(results)
//                } else {
//                    print("No Movies Found")
//                }
//            case .failure:
//                print("Failure")
//            }
//        })
//    }

}

