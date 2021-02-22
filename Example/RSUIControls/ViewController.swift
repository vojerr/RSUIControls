//
//  ViewController.swift
//  RSUIControls
//
//  Created by Ruslan Samsonov on 02/22/2021.
//  Copyright (c) 2021 Ruslan Samsonov. All rights reserved.
//

import UIKit
import RSUIControls

class ViewController: UIViewController {
    @IBOutlet weak var animatedPageControl: AnimatedPageControl!
    @IBOutlet weak var pagingCollectionView: UICollectionView!
    
    private let pages = 7
    private let colors: [UIColor] = [.purple, .black, .yellow, .blue, .cyan, .green]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedPageControl.numberOfItems = pages
        pagingCollectionView.isPagingEnabled = true
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackgroundTap)))
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pagingCollectionView.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    private func onBackgroundTap() {
        view.endEditing(true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row % colors.count]
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        animatedPageControl.updateOffset(scrollView.contentOffset.x, total: scrollView.contentSize.width - scrollView.bounds.size.width)
    }
}
