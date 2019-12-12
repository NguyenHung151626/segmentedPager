//
//  ListMovieViewModel.swift
//  MovieReviewApp
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    let bag = DisposeBag()
    //Detail
    var movieDetailSubject = BehaviorSubject<MovieDetail>(value: MovieDetail())
    var movieIdSubject = PublishSubject<String>()
    
    init() {
        gettingMovieDetailById()
    }
    
    func gettingMovieDetailById() {
        let observable = movieIdSubject
            .asObserver()
            .flatMap { movieId -> Observable<MovieDetail> in
                let url = MovieDetailAPI.movieDetailURLHead + movieId + MovieDetailAPI.movieDetailURLTail + "&append_to_response=reviews,similar,credits"
                return self.callMovieDetailAPI(url: url)
                //noInternet die here
            }
        observable
            .subscribe(onNext: { movieDetail in
                self.movieDetailSubject.onNext(movieDetail)
            }, onError: { error in
                let movieDetailNil = MovieDetail()
                switch error {
                default:
                    self.movieDetailSubject.onNext(movieDetailNil)
                }
            })
            .disposed(by: bag)
    }
}

enum NetworkError: Error {
    case dummyData
    case emptyData
}
