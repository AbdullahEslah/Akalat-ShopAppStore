//
//  RestaurantsSlideShowCell.swift
//  Akalat-Shop
//
//  Created by Macbook on 16/11/2021.
//

import UIKit
import Kingfisher
import AutoScrollCollectionView
import SkeletonView

//To Pass Data From SliderCell -to-> SliderCollectionView
protocol CollectionViewCellDelegate: class {
    func collectionView(collectionViewCell: SliderCollectionView?, index: Int, didTappedInCollectionViewCell: SliderCell)
    // other delegate methods that you can define to perform action in viewcontroller
}

class SliderCell: UICollectionViewCell {
    
    
    @IBOutlet var collectionView: AutoScrollCollectionView!

    @IBOutlet weak var pageControl: UIPageControl!
    var filteredRestaurants = [RestaurntsResult]()
    
    weak var cellDelegate: CollectionViewCellDelegate?
    
    // Slide-Show Cell
    var timer: Timer?
    var currentCellIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.startAutoScrolling(withTimeInterval: TimeInterval(exactly: 8.0)!)
        //Add Animation For CollectionView
        self.collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: .none, transition: .crossDissolve(0.25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [self] in
            fetchRestaurants()
        })
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SliderCollectionView", bundle: nil), forCellWithReuseIdentifier: "SliderCollectionView")

    }
    
    func addTimer() {
        let timer1 = Timer.scheduledTimer(timeInterval: 12.0, target: self, selector: #selector(self.nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer1, forMode: RunLoop.Mode.tracking)
        self.timer = timer1
    }

    func resetIndexPath() -> IndexPath {
        let currentIndexPath = self.collectionView.indexPathsForVisibleItems.last
        let currentIndexPathReset = IndexPath(item: (currentIndexPath?.item)!, section: 0)
        self.collectionView.scrollToItem(at: currentIndexPathReset, at: UICollectionView.ScrollPosition.left, animated: true)
        return currentIndexPath!
    }
    
    func removeTimer() {
        if self.timer != nil {
            self.timer?.invalidate()
        }
        self.timer = nil
    }
    
    @objc func nextPage() {
        let currentIndexPathReset:IndexPath = self.resetIndexPath()
        var nextItem = currentIndexPathReset.item + 1
        let nextSection = currentIndexPathReset.section
        if nextItem == filteredRestaurants.count{
            nextItem = 0
        }
        var nextIndexPath = IndexPath(item: nextItem, section: nextSection)
        if nextItem == 0 {
            self.collectionView.scrollToItem(at: nextIndexPath, at: UICollectionView.ScrollPosition.left, animated: false)
        }
        self.collectionView.scrollToItem(at: nextIndexPath, at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()

    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath? = collectionView.indexPathForItem(at: visiblePoint)
//        pageControlView.currentPage = (visibleIndexPath?.row)!
        
    }


    @objc func timerAction() {
            if currentCellIndex < (filteredRestaurants.count){
            
            currentCellIndex += 1
                collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
        else {
            currentCellIndex = 0
            collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
        
//        pageControl.currentPage = currentCellIndex
    }
    
    // Requests
    func fetchRestaurants() {
        
        NetworkManager.getRestaurantsList(restaurantAddress: UserDefaults.standard.value( forKey: "region") as? String ?? "") { restaurants, error in
            
            if error == nil {
                DispatchQueue.main.async {
                    self.collectionView.stopSkeletonAnimation()
                    self.collectionView.stopSkeletonAnimation()
                    self.contentView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    
                    ArraysModels.restaurants.removeAll()
                    ArraysModels.restaurants.append(contentsOf: restaurants)
                    
                    self.filteredRestaurants = ArraysModels.restaurants
                    
                    self.collectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.collectionView.stopSkeletonAnimation()
                    self.contentView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
            }
            
        }
        
    }
    
    func createcompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self](index, enviroment) -> NSCollectionLayoutSection? in
            
            return self?.createSectionFor(index: index, enviroment: enviroment)
        }
        return layout
    }
    
    func createSectionFor(index:Int , enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        if index == 0 {
            return createCustom()
        }
            return createCustom()
            
    }
    
    func createCustom() -> NSCollectionLayoutSection    {
        
        let fraction: CGFloat = 1.0 / 3.0
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(fraction))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 2.5, bottom: 0, trailing: 2.5)
            section.orthogonalScrollingBehavior = .continuous
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
    }
        return section
}
   
}

extension SliderCell: SkeletonCollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SliderCollectionView"
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionView", for: indexPath) as? SliderCollectionView else {
                return UICollectionViewCell()
            }
            //Configure the cell...
            firstCell.configureCell(restaurant: filteredRestaurants[indexPath.row])
            return firstCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? SliderCollectionView
        self.cellDelegate?.collectionView(collectionViewCell: cell, index: indexPath.item, didTappedInCollectionViewCell: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
//    // Add spaces at the beginning and the end of the collection view
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        }
    
//     func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        currentCellIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
//    }
    
}
