//
//  DetailsViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/20/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var data = ["a", "b", "c", "d"]
    var currentCell: Int = 0 {
        didSet {
//            if currentCell >= data.count { currentCell = data.count - 1 }
//            if (currentCell < 0) { currentCell = 0 }
//            if (currentCell == 0) { prevButton.isHidden = true; } else { prevButton.isHidden = false }
//            if (currentCell == data.count - 1) { nextButton.isHidden = true; } else { nextButton.isHidden = false }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initUIValues();
    }
    
    func initUIValues() {
        collectionView.flashScrollIndicators()
        
    }
    
    @IBAction func prevCollectionView(_ sender: Any) {
        self.currentCell = self.currentCell - 1
        animateToCurrentCell()
    }
    
    @IBAction func nextCollectionView(_ sender: Any) {
        self.currentCell = self.currentCell + 1
        animateToCurrentCell()
    }
    func animateToCurrentCell() {
        let indexPath = IndexPath(item: currentCell, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        self.view.makeToast("\(pageNumber)")
        self.currentCell = pageNumber
    }
    
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let currentIndex = scrollView.contentOffset.x / CGFloat((itemWidth + interitemSpacing / 2))
//        self.view.makeToast("\(currentIndex)")
//    }
    
}


