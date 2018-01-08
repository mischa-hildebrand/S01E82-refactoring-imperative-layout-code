//
//  ViewController.swift
//  ButtonFlowLayout
//
//  Created by Chris Eidhof on 11.12.17.
//  Copyright © 2017 objc.io. All rights reserved.
//

import UIKit

/// The struct itself is independent of the particular views.
/// As such, its logic can be tested independently of the actual view hierarchy.
struct FlowLayout {
    
    let containerSize: CGSize
    let spacing: UIOffset
    
    init(containerSize: CGSize, spacing: UIOffset = UIOffset(horizontal: 10, vertical: 10)) {
        self.containerSize = containerSize
        self.spacing = spacing
    }
    
    func frames(for sizes: [CGSize]) -> [CGRect] {
        var current = CGPoint.zero
        var lineHeight = 0 as CGFloat
        
        var result: [CGRect] = []
        for size in sizes {
            if current.x + size.width > containerSize.width {
                current.x = 0
                current.y += lineHeight + spacing.vertical
                lineHeight = 0
            }
            defer {
                lineHeight = max(lineHeight, size.height)
                current.x += size.width + spacing.horizontal
            }
            result.append(CGRect(origin: current, size: size))
        }
        return result
    }

}

/// This extension is dependent on the particular views
/// and only provides a convenience method.
extension FlowLayout {
    
    func layout(views: [UIView]) {
        let sizes = views.map { $0.intrinsicContentSize }
        let newFrames = frames(for: sizes)
        for (index, view) in views.enumerated() {
            view.frame = newFrames[index]
        }
    }
}

final class ButtonsView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flowLayout = FlowLayout(containerSize: bounds.size)
        flowLayout.layout(views: subviews)
    }
}

extension UIButton {
    convenience init(pill title: String) {
        self.init(type: .custom)
        setTitle(title, for: .normal)
        backgroundColor = UIColor.lightGray
        contentEdgeInsets = .init(top: 10, left: 15, bottom: 10, right: 15)
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = intrinsicContentSize.height / 2
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var buttonView: ButtonsView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = (0..<20).map { UIButton(pill: "Button   \($0)") }
        for b in buttons { buttonView.addSubview(b) }
        
    }

    @IBAction func decreaseWidth(_ sender: Any) {
        self.constraint.constant += 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func increaseWidth(_ sender: Any) {
        self.constraint.constant -= 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

