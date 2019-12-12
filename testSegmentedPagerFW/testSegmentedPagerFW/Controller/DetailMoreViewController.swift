//
//  DetailMoreViewController.swift
//  testSegmentedPagerFW
//
//  Created by MacMini2012 on 12/11/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailMoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var detailMoreViewModel = MovieViewModel()
    let bag = DisposeBag()
    var similarMovies: [SimilarMovie] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        print("view3")
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        
        detailMoreViewModel.movieDetailSubject
            .asObserver()
            .map { movieDetail in
                return movieDetail.similar.results
            }
            .subscribe(onNext: { similarMovies in
                self.similarMovies = similarMovies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: bag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return similarMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMoreTableViewCell", for: indexPath) as! DetailMoreTableViewCell
        let similarMovie = similarMovies[indexPath.row]
        cell.titleLabel.text = similarMovie.title
        let imageURL = MovieImageURL.imageURLHead + (similarMovie.poster_path ?? "")
        let url = URL(string: imageURL)
        cell.posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "default-image"))
        return cell
    }

}
