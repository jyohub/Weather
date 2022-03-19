//
//  WeatherViewController+CollectionView.swift
//  Weather
//
//  Created by jyohub on 2022/03/10.
//

import UIKit

extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.widgetTypes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case WeatherWidgetType.small.rawValue:
            let cell = collectionView.dequeueCell(for: indexPath, cell: WeatherWidgetSmallCollectionViewCell.self)
            cell.setCurrentWeather(weather: self.currentWeather, errorMessage: self.errorMessage)
            return cell
        case WeatherWidgetType.medium.rawValue:
            let cell = collectionView.dequeueCell(for: indexPath, cell: WeatherWidgetMediumCollectionViewCell.self)
            cell.setCurrentWeather(weather: self.currentWeather, errorMessage: self.errorMessage)
            return cell
        case WeatherWidgetType.large.rawValue:
            let cell = collectionView.dequeueCell(for: indexPath, cell: WeatherWidgetLargeCollectionViewCell.self)
            cell.setCurrentWeather(weather: self.currentWeather, errorMessage: self.errorMessage)
            return cell
        default:
            let cell = collectionView.dequeueCell(for: indexPath, cell: WeatherWidgetSmallCollectionViewCell.self)
            cell.setCurrentWeather(weather: self.currentWeather, errorMessage: self.errorMessage)
            return cell
        }
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.size.width-50, height: 487)
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    
    private static var velocity = CGPoint.zero
    private static var startIndex: Int?
    
    var cellSpacing: CGFloat {
        return 16.0
    }
    
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: 16.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let indexPath = getCenterIndexPath() {
            Self.startIndex = indexPath.row
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: false)
        moveToNearestCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        Self.velocity = velocity
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        moveToNearestCell()
    }
    
    func getCenterIndexPath() -> IndexPath? {
        guard let cell = getCenterCollectionViewCell() else {
            return IndexPath(row: 0, section: 0)
        }
        return collectionView.indexPath(for: cell)
    }
    
    func getCenterCollectionViewCell() -> UICollectionViewCell? {
        guard collectionView.visibleCells.count > 0 else { return nil }
        
        let xPos = collectionView.contentOffset.x + collectionView.bounds.width / 2
        let centerCell = collectionView.visibleCells.filter { cell in
            let absPos = abs(xPos - cell.frame.midX) - cellSpacing
            return absPos < cell.bounds.width / 2
        }.first
        
        if centerCell == nil {
            let row = collectionView.contentOffset.x <= 0 ? 0: collectionView.numberOfItems(inSection: 0) - 1
            return collectionView?.cellForItem(at: IndexPath(row: row, section: 0))
        }
        return centerCell
    }
    
    func moveToNearestCell() {
        guard var indexPath = getCenterIndexPath() else { return }
        if(Self.startIndex == indexPath.row) {
            if Self.velocity.x  > 0.5 {
                indexPath.row = min(indexPath.row + 1, collectionView.numberOfItems(inSection: indexPath.section) - 1)
            }
            if Self.velocity.x < -0.5 {
                indexPath.row = max(indexPath.row - 1 , 0)
            }
        }
        Self.velocity = .zero
        Self.startIndex = nil
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
}
