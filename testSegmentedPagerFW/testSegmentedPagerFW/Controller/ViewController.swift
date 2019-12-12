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
import MXParallaxHeader
//MXSegmentedPagerController
class ViewController: UIViewController, MXSegmentedPagerDelegate, MXSegmentedPagerDataSource {
    @IBOutlet weak var scrollView: MXScrollView!
    @IBOutlet weak var segmentedPager: MXSegmentedPager!
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    var pages = [UIViewController]()
    
    var detailMovieViewModel = MovieViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view Total")
        
        setUpNavigationBar()
        // Do any additional setup after loading the view.
        detailMovieViewModel.movieIdSubject.onNext("330457")
        
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (navigationController?.navigationBar.frame.height ?? 0.0)
        constraint.constant = view.frame.height - topBarHeight
        
        let headerView = CustomHeaderView()
        detailMovieViewModel.movieDetailSubject
            .asObserver()
            .map { $0.title ?? "1" }
            .bind(to: headerView.label.rx.text)
            .disposed(by: bag)
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = 410
        scrollView.parallaxHeader.mode = .bottom
        
        segmentedPager.delegate = self
        segmentedPager.dataSource = self
        
        segmentedPager.backgroundColor = .white
        
        // Parallax Header // scrollView auto
//        segmentedPager.parallaxHeader.view = headerView
//        segmentedPager.parallaxHeader.mode = .fill
//        segmentedPager.parallaxHeader.height = 400
//        segmentedPager.parallaxHeader.minimumHeight = view.safeAreaInsets.top
        
        // Segmented Control customization
        segmentedPager.segmentedControl.indicator.linePosition = .bottom
        segmentedPager.segmentedControl.textColor = .black
        segmentedPager.segmentedControl.selectedTextColor = .orange
        segmentedPager.segmentedControl.indicator.lineView.backgroundColor = .orange
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let page1 = storyboard.instantiateViewController(withIdentifier: "DetailCastViewController") as! DetailCastViewController
        let page2 = storyboard.instantiateViewController(withIdentifier: "DetailReviewViewController") as! DetailReviewViewController
        let page3 = storyboard.instantiateViewController(withIdentifier: "DetailMoreViewController") as! DetailMoreViewController
        page1.detailCastViewModel = detailMovieViewModel
        page2.detailReviewViewModel = detailMovieViewModel
        page3.detailMoreViewModel = detailMovieViewModel
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        scrollView.parallaxHeader.minimumHeight = view.safeAreaInsets.top
        
    }
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return 3
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        let page = pages[index]
        return page.view
    }
    //
    override func viewSafeAreaInsetsDidChange() {
        segmentedPager.parallaxHeader.minimumHeight = view.safeAreaInsets.top
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["Cast", "Reviews", "More"][index]
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

