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
    
    private var viewModel: PhotosViewModel?
    private var imageLoader = ImageCacheLoader()

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel = PhotosViewModel()
        viewModel?.getPhotos()
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
        guard let count = viewModel?.photoCells.value.count else {
            return 0
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as? PhotoCollectionViewCell
        
        if let cell = cell {
            
            let cellViewModel = self.viewModel?.photoCells.value[indexPath.row]
            
            cell.viewModel = cellViewModel
            
            if let umageURL = cellViewModel?.imageURL {
                
                imageLoader.obtainImageWithPath(imagePath: umageURL) { (image) in
                    // Before assigning the image, check whether the current cell is visible
                    cell.image.image = image
                }
            }

        }

        return cell!
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            var currentCellOffset = self.collectionView.contentOffset
            currentCellOffset.x += self.collectionView.frame.width / 2
            if let indexPath = self.collectionView.indexPathForItem(at: currentCellOffset) {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
}

extension PhotosViewController {
    func bindViewModel() {
        viewModel?.photoCells.bindAndFire { [weak self] cells in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel?.showLoadingHud.bind() { visible in
            
            DispatchQueue.main.async {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide(true)
            }
        }
        
        viewModel?.onShowError = { [weak self] message in
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            DispatchQueue.main.async {
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
