//
//  DetailReviewViewController.swift
//  testSegmentedPagerFW
//
//  Created by MacMini2012 on 12/11/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var detailReviewViewModel = MovieViewModel()
    var reviews: [Review] = []
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        print("view2")
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        
        detailReviewViewModel.movieDetailSubject
            .asObserver()
            .map { movieDetail in
                return movieDetail.reviews.results
            }
            .subscribe(onNext: { reviews in
                self.reviews = reviews
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: bag)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailReviewTableViewCell", for: indexPath) as! DetailReviewTableViewCell
        let review = reviews[indexPath.row]
        cell.reviewLabel.text = review.content
        return cell
    }
    
}
