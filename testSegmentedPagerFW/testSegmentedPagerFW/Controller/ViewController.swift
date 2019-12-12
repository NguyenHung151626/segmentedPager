//
//  ViewController.swift
//  testSegmentedPagerFW
//
//  Created by MacMini2012 on 12/11/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import MXSegmentedPager
import RxSwift
import RxCocoa

class ViewController: MXSegmentedPagerController {
    var detailMovieViewModel = MovieViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view Total")
        // Do any additional setup after loading the view.
        detailMovieViewModel.movieIdSubject.onNext("330457")
    
        segmentedPager.backgroundColor = .red
        
        let headerView = CustomHeaderView()
        detailMovieViewModel.movieDetailSubject
            .asObserver()
            .map { $0.title ?? "1" }
            .bind(to: headerView.label.rx.text)
            .disposed(by: bag)
        
        // Parallax Header // scrollView auto
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 400
        segmentedPager.parallaxHeader.minimumHeight = view.safeAreaInsets.top
        
        // Segmented Control customization
        segmentedPager.segmentedControl.indicator.linePosition = .bottom
        segmentedPager.segmentedControl.textColor = .black
        segmentedPager.segmentedControl.selectedTextColor = .orange
        segmentedPager.segmentedControl.indicator.lineView.backgroundColor = .orange
    }

    override func viewSafeAreaInsetsDidChange() {
        segmentedPager.parallaxHeader.minimumHeight = view.safeAreaInsets.top
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["Cast", "Reviews", "More"][index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAt index: Int) -> UIViewController {
        if let vc = super.segmentedPager(segmentedPager, viewControllerForPageAt: index) as? DetailCastViewController {
            vc.detailCastViewModel = detailMovieViewModel
            return vc
        } else if let vc = super.segmentedPager(segmentedPager, viewControllerForPageAt: index) as? DetailReviewViewController {
            vc.detailReviewViewModel = detailMovieViewModel
            return vc
        } else if let vc = super.segmentedPager(segmentedPager, viewControllerForPageAt: index) as? DetailMoreViewController {
            vc.detailMoreViewModel = detailMovieViewModel
            return vc
        } else {
            return UIViewController()
        }
    }
}

