//
//  AWBarChart.swift
//  AWBarChart
//
//  Created by Tudor Ana on 03/02/2020.
//  Copyright © 2020 Tudor Ana. All rights reserved.
//

import UIKit

public struct GraphData {
    var title: String?
    var value: Double?
    var date: Date?
}

public final class BarChart: UIView {
    
    public var data: [GraphData] = []
    private var padding: CGFloat = 22
    private var infoLabel: UILabel?
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.infoLabel = UILabel(frame: rect)
        self.infoLabel?.textAlignment = .center
        self.infoLabel?.text = "No data available."
        self.infoLabel?.textColor = UIColor.gray
        self.addSubview(self.infoLabel!)
        
        self.clipsToBounds = false
        self.drawBars()
        self.drawTopLabels()
    }
    
    func drawBars() {
        self.infoLabel?.alpha = 0.0
        
        // Calculate spacing
        let totalWidth = self.frame.size.width
        let totalHeight = self.frame.size.height - 22
        let offset = totalWidth / 7.0
        
        guard data.count > 0 else {
            self.infoLabel?.alpha = 1.0
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(min(offset - padding, 30))
        context!.setStrokeColor(UIColor(red: 0, green: 150/255, blue: 1, alpha: 1).cgColor)
        

        // Calculate max and min
        let max = data.map( { $0.value ?? 1 } ).max() ?? 1
        let min = data.map( { $0.value ?? 1 } ).min() ?? 1
        let delta = max - min

        for index in 0...data.count - 1 {
            
            
            let value = data[index].value ?? 0
            var height = ((max - value) * Double(totalHeight)) / delta
            if height < 0 {
                height = 0
            } else if height > Double(totalHeight - 22) {
                height = Double(totalHeight - 22)
            }

            let x = CGFloat(index) * (offset)
            
            context?.move(to: CGPoint(x: x + padding + padding / 4, y: totalHeight))
            context?.addLine(to: CGPoint(x: x + padding + padding / 4, y: totalHeight - 4))
            
            context?.move(to: CGPoint(x: x + padding + padding / 4, y: totalHeight - 4))
            context?.addLine(to: CGPoint(x: x + padding + padding / 4, y: CGFloat(height + 22)))
        }

        context!.strokePath()
    
    }
    
    
    
    func drawTopLabels() {
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .left
        let topAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.black,
            .paragraphStyle: titleParagraphStyle
        ]
        
        
        let bottomAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.black,
            .paragraphStyle: titleParagraphStyle
        ]
        

        
        // Calculate spacing
        let totalWidth = self.frame.size.width
        let totalHeight = self.frame.size.height - 22
        let offset = totalWidth / 7.0
        
        guard data.count > 0 else { return }
        
        let context = UIGraphicsGetCurrentContext()

        // Calculate max and min
        let max = data.map({ $0.value ?? 1 }).max() ?? 1
        let min = data.map({ $0.value ?? 1 }).min() ?? 1
        let delta = max - min
        
        for index in 0...data.count - 1 {
            
            
            let value = data[index].value ?? 0
            let title = data[index].title
            var height = ((max - value) * Double(totalHeight)) / delta
            
            if height < 0 {
                height = 0
            } else if height > Double(totalHeight - 22) {
                height = Double(totalHeight - 22)
            }
            
            if delta == 0 {
                height = Double(totalHeight - 22)
            }
 
            let x = CGFloat(index) * (offset)
            let y = CGFloat(height)

            let topText = value.minimize()
            let topAttributedString = NSAttributedString(string: topText, attributes: topAttributes)
            let topStringRect = CGRect(x: x + padding / 1.6, y: y, width: 66, height: 30)
            topAttributedString.draw(in: topStringRect)
            
            
            
            let bottomText = String(format: "%@", title ?? "Now")
            let bottomAttributedString = NSAttributedString(string: bottomText, attributes: bottomAttributes)
            let bottomStringRect = CGRect(x: x + padding / 1.8, y: totalHeight + 8, width: 66, height: 30)
            bottomAttributedString.draw(in: bottomStringRect)
        }

        context!.strokePath()
        
    }
}


extension Double {
    func minimize() -> String {
        if self >= 1000000 {
            return String(format: "%.2fM", Double(self) / 1000000)
        } else if self >= 1000 {
            return String(format: "%.2fK", Double(self) / 1000)
        } else {
            return String(format: "%.1f", self)
        }
    }
}
