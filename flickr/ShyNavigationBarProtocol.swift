//
//  ShyNavigationBarProtocol.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import Foundation
import UIKit

protocol ShyNavigationBarViewController:class {
    var initialScrollPositionY:CGFloat?{get set}
}
extension ShyNavigationBarViewController where Self:UIViewController{
    private var flexibleGap:CGFloat {return 144}
    
    private var navigationBarHeight:CGFloat{
        return navigationBar?.frame.height ?? 44
    }
    
    private var statusBarHeight:CGFloat{
        return UIApplication.sharedApplication().statusBarFrame.height
    }
    
    private var navigationBar:UINavigationBar?{
        return navigationController?.navigationBar
    }
    
    private var navigationBarOriginY:CGFloat{
        return navigationBar?.frame.origin.y ?? statusBarHeight
    }
    
    private var visibilityFraction:CGFloat{
        set{
            navigationItem.titleView?.alpha = newValue
            navigationController?.navigationBar.frame.origin.y = statusBarHeight - navigationBarHeight * (1-newValue)
        }get{
            return 1+(navigationBarOriginY - statusBarHeight) / navigationBarHeight
        }
    }
    


    func showNavigationBar(){
        visibilityFraction = 1
    }
    
    private func shouldAnchor(offsetY:CGFloat)->Bool{
        let summOffsetY = statusBarHeight+offsetY
        return summOffsetY < 0
    }
    
    func updateScrollOffsetWithY(offsetY:CGFloat){
        let globalDirectionUp = initialScrollPositionY < offsetY
        
        let summOffsetY = statusBarHeight+offsetY
        
        /**
         *  ignore the gap if tableView scrolled to the top
         */
        if shouldAnchor(offsetY) {
            if globalDirectionUp {
                visibilityFraction = min(1,0-summOffsetY/navigationBarHeight)
            }else{
                visibilityFraction = max(visibilityFraction,min(1,0-summOffsetY/navigationBarHeight))
            }
            return
        }
        guard let initialScrollPositionY = initialScrollPositionY else {
            return
        }
        let gap = offsetY - initialScrollPositionY
        
        if abs(gap) > flexibleGap {
            
            var stickyGap = abs(gap) - flexibleGap
            if stickyGap > navigationBarHeight {
                stickyGap = navigationBarHeight
            }
            if globalDirectionUp{
                visibilityFraction = min(visibilityFraction, max(0, 1-stickyGap/navigationBarHeight))
            }else{
                visibilityFraction = max(visibilityFraction, max(0, 0+stickyGap/navigationBarHeight))
            }
        }
    }
    
    func snapNavigationBar(scrollView:UIScrollView){
        UIView.animateWithDuration(0.2) { () -> Void in
            if self.shouldAnchor(scrollView.contentOffset.y) {
                scrollView.contentOffset.y = -scrollView.contentInset.top
                self.visibilityFraction = 1
            }
            else {
                self.visibilityFraction = CGFloat(Int(self.visibilityFraction+0.5))
            }
        }
        
        initialScrollPositionY = nil
    }
    
    private func draggingBeginWithY(offsetY:CGFloat){
        initialScrollPositionY = offsetY
    }
    
    private func scrollDidFinish(scrollView:UIScrollView){
        snapNavigationBar(scrollView)
    }
}
extension RootViewController {
    
    override func scrollViewDidScroll(scrollView: UIScrollView){
        self.updateScrollOffsetWithY(scrollView.contentOffset.y)
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollDidFinish(scrollView)
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollDidFinish(scrollView)
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        draggingBeginWithY(scrollView.contentOffset.y)
    }
}