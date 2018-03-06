//
//  PhotosViewController.swift
//  FlickrBrowser
//
//  Created by Marto Kenarov on 4.03.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit
import PKHUD

class PhotosViewController: UIViewController {
    
    private var viewModel: PhotosViewModel = PhotosViewModel()
    private var imageLoader = ImageCacheLoader()
    
    let collectionMargin = CGFloat(10)
    let itemSpacing = CGFloat(10)
    let itemHeight = CGFloat(322)
    
    var itemWidth = CGFloat(0)
    var currentItem = 0 {
        didSet {
            page = currentItem + 1
        }
    }
    var page = 1

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pagesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        viewModel.getPhotos()
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private struct Storyboard {
        static let CellIdentifier = "PhotoCellIdentifier"
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoCells.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as? PhotoCollectionViewCell
        
        if let cell = cell {
            
            let cellViewModel = self.viewModel.photoCells.value[indexPath.row]
            
            cell.viewModel = cellViewModel
            
            imageLoader.obtainImageWithPath(imagePath: cellViewModel.imageURL) { (image) in
                // Before assigning the image, check whether the current cell is visible
                cell.image.image = image
            }

        }

        return cell!
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView.contentSize.width  )
        var newPage = Float(currentItem)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? currentItem + 1 : currentItem - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        currentItem = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
        
        
        if currentItem < viewModel.photoCells.value.count {
            // update pages label
            pagesLabel.text = "tip \(page) of \(viewModel.photoCells.value.count) pages"
        }
    }

}

extension PhotosViewController {
    func bindViewModel() {
        viewModel.photoCells.bindAndFire { [weak self] cells in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                
                if let page = self?.page, let count = self?.viewModel.photoCells.value.count {
                    // update pages label
                    self?.pagesLabel.text = "tip \(page) of \(count) pages"
                }
            }
        }
        
        viewModel.showLoadingHud.bind() { visible in
            
            DispatchQueue.main.async {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide(true)
            }
        }
        
        viewModel.onShowError = { [weak self] message in
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            DispatchQueue.main.async {
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setup() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2.0
        debugPrint("\(itemWidth)")
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
}
