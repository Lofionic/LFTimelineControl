//
// Lofionic © 2019-2020
//

import UIKit

import pop

public final class TimelineControl: UIControl {
    
    /// The space between bar markers, in points.
    public dynamic var divisionWidth: CGFloat = 50.0 {
        didSet {
            let animation = CABasicAnimation(keyPath: #keyPath(TimelineLayer.divisionWidth))
            animation.duration = 0.2
            animation.fromValue = oldValue
            animation.toValue = divisionWidth
            
            timelineLayer.add(animation, forKey: "divisionWidth")
            timelineLayer.divisionWidth = divisionWidth
        }
    }
    
    /// Number of divisions between bar markers.
    public dynamic var divisionCount: Int = 3 {
        didSet {
            timelineLayer.divisionCount = divisionCount
        }
    }
        
    private let backgroundLayer = BackgroundLayer()
    private let timelineLayer = TimelineLayer()
    private let needleLayer = NeedleLayer()
    
    private var locationProperty: POPAnimatableProperty!
    
    private var decayAnimation: LFDecayAnimation!

    private(set) dynamic var location: CGFloat = 0.0 {
        didSet {
            timelineLayer.location = location
        }
    }
        
    private var isScrubbing: Bool = false {
        didSet {
            timelineLayer.isScrubbing = isScrubbing
        }
    }
    
    private var startTouchLocation: CGFloat?
    private var touchVelocity: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.contentsScale = UIScreen.main.scale
        
        layer.shadowColor = Colors.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 3)
        
        layer.addSublayer(backgroundLayer)
        backgroundLayer.addSublayer(timelineLayer)
        backgroundLayer.addSublayer(needleLayer)
        
        timelineLayer.location = location
        timelineLayer.divisionWidth = divisionWidth
        timelineLayer.divisionCount = divisionCount
        timelineLayer.actions = timelineLayer.newActions
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        
        addGestureRecognizer(panGesture)
        
        if let property = POPAnimatableProperty.property(withName: "location", initializer: { property in
            property?.readBlock = { base, values in
                guard let base = base as? Self, let values = values else { return }
                values[0] = base.location
            }
            
            property?.writeBlock = { base, values in
                guard let base = base as? Self, let values = values else { return }
                base.location = max(values[0], 0)
            }
                    
            property?.threshold = 0.2
        }) as? POPAnimatableProperty {
            locationProperty = property
        }
    }
    
    @objc func didPan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            isScrubbing = true
            pop_removeAnimation(forKey: "decay")
        case .changed:
            let delta = panGesture.translation(in: self).x / divisionWidth
            location = max(location - delta, 0)
            panGesture.setTranslation(.zero, in: self)
        case .ended:
            decayAnimation = LFDecayAnimation()
            decayAnimation.property = locationProperty
            decayAnimation.fromValue = location
            
            let velocity = -panGesture.velocity(in: self).x / divisionWidth
            decayAnimation.velocity = velocity
            
            if let toValue = decayAnimation.toValue as? CGFloat,
                floor(max(0, toValue)) != floor(location) {
                
                decayAnimation.toValue = max(0, velocity > 0.0 ? floor(toValue) : ceil(toValue))
                decayAnimation.completionBlock = { [weak self] _, completed in
                    if completed {
                        self?.sendActions(for: .valueChanged)
                    }
                }
                pop_add(decayAnimation, forKey: "decay")
            } else {
                setLocation(round(location), animated: true)
                sendActions(for: .valueChanged)
            }
            
            isScrubbing = false
        default:
            break
        }
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if layer == self.layer {
            backgroundLayer.frame = self.bounds
            timelineLayer.frame = self.bounds
            needleLayer.frame = self.bounds
        }
    }
    
    private class TimelineSublayer: CALayer {
        override init() {
            super.init()
            setup()
        }
        
        override init(layer: Any) {
            super.init(layer: layer)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        func setup() {
            contentsScale = UIScreen.main.scale
            needsDisplayOnBoundsChange = true
        }
    }
    
    private class BackgroundLayer: TimelineSublayer {
        
        override func setup() {
            super.setup()
        }
        
        override func draw(in ctx: CGContext) {
            super.draw(in: ctx)
            let backgroundPath = CGMutablePath()
            backgroundPath.addRect(bounds)
            
            ctx.setFillColor(Colors.offWhite.cgColor)
            ctx.addPath(backgroundPath)
            ctx.fillPath()
        }
    }
    
    private class NeedleLayer: TimelineSublayer {
        override func draw(in ctx: CGContext) {
            super.draw(in: ctx)
            
            let needleWidth: CGFloat = 3.0
            let needleRect = CGRect(
                x: bounds.midX - (needleWidth / 2.0),
                y: 0,
                width: needleWidth,
                height: bounds.height)
            
            ctx.setFillColor(Colors.red.cgColor)
            ctx.fill(needleRect)
        }
    }
}

extension TimelineControl {
    @objc
    private class TimelineLayer: TimelineSublayer {
        @NSManaged fileprivate var location: CGFloat
        @NSManaged fileprivate var divisionWidth: CGFloat
        @NSManaged fileprivate var divisionCount: Int
        
        @NSManaged fileprivate var isScrubbing: Bool
        @NSManaged fileprivate var isPlaying: Bool
        
        override class func needsDisplay(forKey event: String) -> Bool {
            if event == "location" ||
                event == "divisionWidth" ||
                event == "divisionCount" ||
                event == "isScrubbing" {
                return true
            } else {
                return super.needsDisplay(forKey: event)
            }
        }
        
        let newActions = [
            "contents": NSNull()
        ]
        
        override func draw(in ctx: CGContext) {
            super.draw(in: ctx)
            
            // Draw Major increments
            let barOffset = fmod(location, 1.0) * divisionWidth
            let centerOffset: CGFloat =
                divisionWidth - (bounds.midX - floor(bounds.midX / divisionWidth) * divisionWidth)
            
            var drawLocationX: CGFloat = 0 - centerOffset - barOffset
            let tickWidth: CGFloat = 0.25
            
            var barNumber = floor(location) - ceil(bounds.midX / divisionWidth)
            
            while drawLocationX < bounds.width {
                
                let textRect = CGRect(x: drawLocationX + 4, y: 4, width: divisionWidth, height: (bounds.height * 0.5))
                let divisionRect = CGRect(x: drawLocationX, y: 0, width: divisionWidth, height: bounds.height)
                
                if !isPlaying {
                    if 0.0...floor(location) ~= barNumber {
                        ctx.setFillColor(Colors.lightGray.cgColor)
                        ctx.fill(divisionRect)
                    }
                    
                    if barNumber == floor(location) {
                        let alpha = 1 - (location - floor(location))
                        ctx.setFillColor(Colors.offWhite.withAlphaComponent(alpha).cgColor)
                        ctx.fill(divisionRect)
                    }
                }
                
                let tickColor = barNumber >= 0 ? Colors.darkGray : Colors.lightGray
                let tickRect = CGRect(x: drawLocationX - tickWidth / 2.0, y: 0, width: tickWidth, height: bounds.height)
                ctx.setFillColor(tickColor.cgColor)
                ctx.fill(tickRect)
                
                (1..<divisionCount).forEach { _ in
                    drawLocationX += divisionWidth / CGFloat(divisionCount)
                    let subTickRect = CGRect(x: drawLocationX - tickWidth / 2.0,
                                             y: bounds.height * 0.8,
                                             width: tickWidth,
                                             height: bounds.height * 0.2)
                    ctx.setFillColor(tickColor.cgColor)
                    ctx.fill(subTickRect)
                }
                drawLocationX += divisionWidth / CGFloat(divisionCount)
                
                if barNumber >= 0 {
                    UIGraphicsPushContext(ctx)
                    let attributedString = NSAttributedString(
                        string: String(format: "%.0f", barNumber),
                        attributes: Fonts.annotation)
                    attributedString.draw(in: textRect)
                    UIGraphicsPopContext()
                }
                
                barNumber += 1
            }
        }
    }
}

// MARK: - Public
extension TimelineControl {
    
    func setLocation(_ newLocation: CGFloat, animated: Bool) {
        if animated {
            let animation = CABasicAnimation(keyPath: #keyPath(TimelineLayer.location))
            animation.duration = 0.1
            animation.fromValue = location
            animation.toValue = newLocation
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            timelineLayer.add(animation, forKey: "location")
        }
        
        location = newLocation
    }
}
