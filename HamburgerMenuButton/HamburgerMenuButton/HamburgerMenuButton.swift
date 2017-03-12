//
//  HamburgerMenuButton.swift
//  HamburgerMenuButton
//
//  Created by Stephan Ziegenaus on 05.03.17.
//  Copyright © 2017 KachelSolutions. All rights reserved.
//

import UIKit

@IBDesignable
public class HamburgerMenuButton: UIButton {

    // MARK: @IBInspectable
    
    @IBInspectable public var horizontalLineSpacing: CGFloat = 5 {
        didSet {
            setupLayer()
        }
    }
    
    @IBInspectable public var menuStrokeWidth: CGFloat = 1{
        didSet{
            updateStrokeWidth()
        }
    }
    
    @IBInspectable public var menuStrokeColor: UIColor? {
        didSet {
            updateMenuColor()
        }
    }
       
    /// Toggle this property for animated switch between menu open or not
    @IBInspectable public var isMenuOpen: Bool = false {
        didSet {            
            updateMenuIndicator()
        }
    }
    
    // MARK : Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
//    override public func prepareForInterfaceBuilder(){
//        setupLayer()
//    }
    
    private let topLeft = CAShapeLayer()
    private let topRight = CAShapeLayer()
    private let middleLeft = CAShapeLayer()
    private let middleRight = CAShapeLayer()
    private let bottomLeft = CAShapeLayer()
    private let bottomRight = CAShapeLayer()
    
    private let section1 = CAShapeLayer()
    private let section2 = CAShapeLayer()
    private let section3 = CAShapeLayer()
    private let section4 = CAShapeLayer()
    
    private enum layerType: Int {
        case top
        case middle
        case bottom
    }
    
    internal func setupLayer(){
        self.addTarget(self, action: #selector(buttonTapped(sender:)), for: UIControlEvents.touchUpInside)
        //TOP
        setupInitialMenuLine(left: topLeft, right: topRight, startPoint: startingPoint(for: .top), endPoint: endPoint(for: .top))
        //MIDDLE
        setupInitialMenuLine(left: middleLeft, right: middleRight, startPoint: startingPoint(for: .middle), endPoint: endPoint(for: .middle))
        //BOTTOM
        setupInitialMenuLine(left: bottomLeft, right: bottomRight, startPoint: startingPoint(for: .bottom), endPoint: endPoint(for: .bottom))
        
        let centerPoint = middelPoint(first: startingPoint(for: .middle), second: endPoint(for: .middle))
        setupOpenMenuX(sectionLayer: section1, startPoint: centerPoint, endPoint: startingPoint(for: .top))
        setupOpenMenuX(sectionLayer: section2, startPoint: centerPoint, endPoint: endPoint(for: .top))
        setupOpenMenuX(sectionLayer: section3, startPoint: centerPoint, endPoint: endPoint(for: .bottom))
        setupOpenMenuX(sectionLayer: section4, startPoint: centerPoint, endPoint: startingPoint(for: .bottom))
    }
    
    internal func setupOpenMenuX(sectionLayer:CAShapeLayer, startPoint:CGPoint, endPoint:CGPoint){
        var strokeValue = CGFloat(0)
        if isMenuOpen{
            strokeValue = CGFloat(1)
        }
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        sectionLayer.strokeColor = menuStrokeColor?.cgColor
        sectionLayer.lineWidth = menuStrokeWidth
        sectionLayer.path = path.cgPath
        sectionLayer.strokeEnd = strokeValue
        self.layer.addSublayer(sectionLayer)

    }
    
    
    
    internal func setupInitialMenuLine(left: CAShapeLayer, right: CAShapeLayer, startPoint: CGPoint, endPoint:CGPoint){
       
        var strokeValue = CGFloat(1)
        if isMenuOpen{
            strokeValue = CGFloat(0)
        }
        let middle = middelPoint(first: startPoint, second: endPoint)
        let leftPath = UIBezierPath()
        leftPath.move(to: middle)
        leftPath.addLine(to: startPoint)
        
        let rightPath = UIBezierPath()
        rightPath.move(to: middle)
        rightPath.addLine(to: endPoint)
        
        //Left
        left.strokeEnd = strokeValue
        left.path = leftPath.cgPath
        left.strokeColor = menuStrokeColor?.cgColor
        left.lineWidth = menuStrokeWidth
        self.layer.addSublayer(left)
        //Right
        right.strokeEnd = strokeValue
        right.path = rightPath.cgPath
        right.strokeColor = menuStrokeColor?.cgColor
        right.lineWidth = menuStrokeWidth
        self.layer.addSublayer(right)
    }
    
    // MARK: - Actions
    
    internal func buttonTapped(sender: UIButton){
        isMenuOpen = !isMenuOpen
    }
    
    // MARK: - Animations
    
    internal func animateMenuLine(lineLayers:[CAShapeLayer], animation:CABasicAnimation, strokeEndValue: CGFloat){
        for layer in lineLayers{
            layer.add(animation, forKey: animation.keyPath)
            layer.strokeEnd = strokeEndValue
        }
    }
    
    internal func animateMenuClosingLines(lineLayers:[CAShapeLayer], animation:CABasicAnimation, strokeEndValue: CGFloat){
        for layer in lineLayers{
            layer.add(animation, forKey: animation.keyPath)
            layer.strokeEnd = strokeEndValue
        }
    }
    
    internal func removeAllAnimation(lineLayers:[CAShapeLayer], lineLayersOpenMenu:[CAShapeLayer]){
        for layer in lineLayers{
            layer.removeAllAnimations()
        }
        for layer in lineLayersOpenMenu{
            layer.removeAllAnimations()
        }
    }
    
    internal func updateMenuIndicator(){
        let menuLineArray = [topLeft, topRight, middleLeft, middleRight, bottomLeft, bottomRight]
        let sectionArray = [section1, section2, section3, section4]
        let animationIn = strokeAnimation(from: 0, to: 1)
        let animationOut = strokeAnimation(from: 1, to: 0)
        removeAllAnimation(lineLayers: menuLineArray, lineLayersOpenMenu: sectionArray)
        let animationDuration = 0.5
        let menuState = isMenuOpen
        if isMenuOpen{
            CATransaction.begin()
            CATransaction.setAnimationDuration(animationDuration)
            CATransaction.setCompletionBlock({
                if menuState == self.isMenuOpen{
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(animationDuration)
                    self.animateMenuClosingLines(lineLayers: sectionArray, animation: animationIn,strokeEndValue: 1)
                    CATransaction.commit()
                }
            })
            animateMenuLine(lineLayers: menuLineArray, animation: animationOut,strokeEndValue: 0)
            CATransaction.commit()
        }else{
            CATransaction.begin()
            CATransaction.setAnimationDuration(animationDuration)
            CATransaction.setCompletionBlock({
                if menuState == self.isMenuOpen{
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(animationDuration)
                    self.animateMenuLine(lineLayers: menuLineArray, animation: animationIn,strokeEndValue: 1)
                    CATransaction.commit()
                }
            })
            animateMenuClosingLines(lineLayers: sectionArray, animation: animationOut, strokeEndValue: 0)
            CATransaction.commit()
        }

    }
    
    internal func strokeAnimation(from: CGFloat, to:CGFloat)-> CABasicAnimation{
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = from
        strokeAnimation.toValue = to
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.fillMode = kCAFillModeForwards
        return strokeAnimation
    }
    
    internal func updateMenuColor(){
        topLeft.strokeColor = menuStrokeColor?.cgColor
        topRight.strokeColor = menuStrokeColor?.cgColor
        middleLeft.strokeColor = menuStrokeColor?.cgColor
        middleRight.strokeColor = menuStrokeColor?.cgColor
        bottomLeft.strokeColor = menuStrokeColor?.cgColor
        bottomRight.strokeColor = menuStrokeColor?.cgColor
    }
    
    internal func updateStrokeWidth(){
        topLeft.lineWidth = menuStrokeWidth
        topRight.lineWidth = menuStrokeWidth
        middleLeft.lineWidth = menuStrokeWidth
        middleRight.lineWidth = menuStrokeWidth
        bottomLeft.lineWidth = menuStrokeWidth
        bottomRight.lineWidth = menuStrokeWidth
    }
    
    
    // MARK: - Helper
    
    private func startingPoint(for layerType: layerType)->CGPoint{
        
        let middleY = self.frame.height/2
        
        switch layerType {
        case .top:
            return CGPoint(x: 0.0, y: middleY + horizontalLineSpacing)
        case .middle:
            return CGPoint(x: 0.0, y: middleY)
        case .bottom:
            return CGPoint(x: 0.0, y: middleY - horizontalLineSpacing)
        }
    }
    
    private func middelPoint(first:CGPoint, second:CGPoint)->CGPoint{
        return  CGPoint(x: (first.x+second.x)/2, y: first.y)
    }
    
    private func endPoint(for layerType: layerType)->CGPoint{
        let startingPoint = self.startingPoint(for: layerType)
        switch layerType {
        case .top:
            return CGPoint(x: self.frame.width, y: startingPoint.y)
        case .middle:
            return CGPoint(x: self.frame.width, y: startingPoint.y)
        case .bottom:
            return CGPoint(x: self.frame.width, y: startingPoint.y)
        }
    }
}
