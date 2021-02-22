//
//  AnimatedPageControl.swift
//  RSUIControls
//
//  Created by rsamsonov on 22.02.2021.
//

import UIKit

@objc
public class AnimatedPageControl: UIView {

    @IBInspectable
    public var radius: CGFloat = 4 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var stripeWidth: CGFloat = 12 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var spacing: CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public dynamic var selectedColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public dynamic var deselectedColor = UIColor.red.withAlphaComponent(0.3) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var numberOfItems = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public func updateOffset(_ offset: CGFloat, total: CGFloat) {
        progress = max(0, min(offset / total, 1.0))
    }
    
    public override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        let y = rect.size.height / CGFloat(2.0)
        let totalWidth = radius * 2 + stripeWidth + (radius * 2 + spacing) * CGFloat((numberOfItems - 1))
        let progressPart = CGFloat(1) / CGFloat(numberOfItems - 1)
        let left = floor((progress == 1.0 ? progress - progressPart : progress) / progressPart) * progressPart
        let right = left + progressPart
        
        var currentX = rect.size.width / 2.0 - totalWidth / 2.0
        for i in 0..<numberOfItems {
            let iterProgress = progressPart * CGFloat(i)
            let rounding: CGFloat = 10E-5
            if left - iterProgress > rounding || iterProgress - right > rounding {
                let color = deselectedColor
                color.setFill()
                ctx.addArc(center: CGPoint(x: currentX + radius, y: y), radius: radius, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
                ctx.closePath()
                ctx.fillPath()
                
                currentX += radius * 2.0 + spacing
            } else {
                var diffProgress = 1.0 - abs(progress - iterProgress) / progressPart
                diffProgress = CGFloat(Int(diffProgress * 10E3)) / 10E3
                let color = getColor(first: deselectedColor, second: selectedColor, progress: diffProgress)
                let addedWidth = stripeWidth * diffProgress
                color.setFill()
                
                let width = addedWidth + radius * 2.0
                let bezierPath = UIBezierPath(roundedRect: CGRect(x: currentX, y: y - radius, width: width, height: radius * 2.0), cornerRadius: radius)
                bezierPath.fill()
                
                currentX += width + spacing
            }
        }
    }
    
    private func getColor(first: UIColor, second: UIColor, progress: CGFloat) -> UIColor{
        let fRGBA = first.rgba
        let sRGBA = second.rgba
        let deltaRGBA = UIColor.RGBA(red: sRGBA.red - fRGBA.red, green: sRGBA.green - fRGBA.green, blue: sRGBA.blue - fRGBA.blue, alpha: sRGBA.alpha - fRGBA.alpha)
        return UIColor(red: fRGBA.red + deltaRGBA.red * progress, green: fRGBA.green + deltaRGBA.green * progress, blue: fRGBA.blue + deltaRGBA.blue * progress, alpha: fRGBA.alpha + deltaRGBA.alpha * progress)
    }
}


public extension UIColor {
    struct RGBA: CustomStringConvertible {
        public var description: String {
            return "RGBA{\(red) \(green) \(blue) \(alpha)}"
        }
        
        public let red: CGFloat
        public let green: CGFloat
        public let blue: CGFloat
        public let alpha: CGFloat
        
        public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
        
        public func toColor() -> UIColor {
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
    var rgba: RGBA {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }
}
