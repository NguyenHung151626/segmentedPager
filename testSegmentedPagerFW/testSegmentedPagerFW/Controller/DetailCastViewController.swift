//
//  DetailCastViewController.swift
//  testSegmentedPagerFW
//
//  Created by MacMini2012 on 12/11/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailCastViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var detailCastViewModel: MovieViewModel!
    let bag = DisposeBag()
    var casts = [Cast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        print("view1")
        detailCastViewModel.movieDetailSubject
            .asObserver()
            .map { movieDetail in
                return movieDetail.credits.cast
            }
            .subscribe(onNext: { casts in
                print(casts.count)
                self.casts = casts
                
                self.collectionView.reloadData()
                
            })
            .disposed(by: bag)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCastCollectionViewCell", for: indexPath) as! DetailCastCollectionViewCell
        let cast = casts[indexPath.item]
        cell.label.text = cast.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
    }
}
