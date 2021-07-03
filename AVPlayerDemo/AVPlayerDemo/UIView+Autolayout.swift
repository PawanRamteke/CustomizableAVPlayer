//
//  UIView+Autolayout.swift
//  BTS
//
//  Created by Pawan Ramteke on 17/11/18.
//  Copyright © 2018 Pawan Ramteke. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func enableAutoLayout(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func topMargin(pixels:CGFloat){
        let constraints = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func bottomMargin(pixels:CGFloat){
        let constraints = NSLayoutConstraint(item: self, attribute:.bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1.0, constant: -pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func leadingMargin(pixels:CGFloat){
        let constraints = NSLayoutConstraint(item: self, attribute:.leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func trailingMargin(pixels:CGFloat){
        let constraints = NSLayoutConstraint(item: self, attribute:.trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1.0, constant: -pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func fixedWidth(pixels:CGFloat){
        let constraints = NSLayoutConstraint(item: self, attribute:.width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func fixedHeight(pixels:CGFloat){
        let constraints = NSLayoutConstraint(item: self, attribute:.height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func addToLeftToView(view:UIView,pixels:CGFloat){
        let constraints = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: -pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func addToRightToView(view:UIView,pixels:CGFloat){
        let constraints = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
   
    func belowToView(view:UIView,pixels:CGFloat){
        let constraints = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func aboveToView(view:UIView,pixels:CGFloat){
        let constraints = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func centerX()
    {
        let constraints = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: self.superview, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)
        self.superview?.addConstraint(constraints)
    }
    
    func centerX(toView:UIView,pixels:CGFloat)
    {
        let constraints = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func centerY()
    {
        let constraints = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: .equal, toItem: self.superview, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0.0)
        self.superview?.addConstraint(constraints)
    }
    
    func centerY(toView:UIView,pixels:CGFloat)
    {
        let constraints = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: .equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func equalWidth(toView:UIView,pixels:CGFloat)
    {
        let constraints = NSLayoutConstraint(item: self, attribute:.width, relatedBy: .equal, toItem: toView, attribute: .width, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func equalHeight(toView:UIView,pixels:CGFloat)
    {
        let constraints = NSLayoutConstraint(item: self, attribute:.height, relatedBy: .equal, toItem: toView, attribute: .height, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
    
    func equalTop(toView:UIView,pixels:CGFloat) {
        let constraints = NSLayoutConstraint(item: self, attribute:.top, relatedBy: .equal, toItem: toView, attribute: .top, multiplier: 1.0, constant: pixels)
        self.superview?.addConstraint(constraints)
    }
}
