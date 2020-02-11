//
//  AWBarChart.swift
//  AWBarChart
//
//  Created by Tudor Ana on 03/02/2020.
//  Copyright © 2020 Tudor Ana. All rights reserved.
//

import UIKit

public struct GraphData {
    
    public var title: String?
    
    public var text: String
    public var value: Double
    public var textValue: String
    public var date: Date
    
    public init(title: String,
                text: String,
                value: Double,
                textValue: String,
                date: Date) {
        
        self.title = title
        self.text = text
        self.value = value
        self.textValue = textValue
        self.date = date
    }
}

open class BarChart: UIView {
    
    public var data: [GraphData] = []
    public var padding: CGFloat = 22
    private var infoLabel: UILabel?
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        if let _ = self.viewWithTag(999) { } else {
            self.infoLabel = UILabel(frame: rect)
            self.infoLabel?.tag = 999
            self.infoLabel?.textAlignment = .center
            self.infoLabel?.text = "No data available."
            self.infoLabel?.textColor = UIColor.gray
            self.infoLabel?.font = UIFont.systemFont(ofSize: 12)
            self.addSubview(self.infoLabel!)
        }
        
        self.clipsToBounds = false
        if let context = UIGraphicsGetCurrentContext() {
            self.drawBars(on: context)
            self.drawTopLabels(on: context)
        }
    }
    
    
    private func drawBars(on context: CGContext) {
        self.infoLabel?.alpha = 0.0
        
        // Calculate spacing
        let totalWidth = self.frame.size.width
        let totalHeight = self.frame.size.height - 22
        let offset = totalWidth / 7.0
        
        guard data.count > 0 else {
            self.infoLabel?.alpha = 1.0
            return
        }
        
        context.setLineWidth(min(offset - padding, 30))
        context.setStrokeColor(UIColor(red: 0, green: 150/255, blue: 1, alpha: 1).cgColor)
        
        // Calculate max and min
        let max = data.map( { $0.value } ).max() ?? 1
        let min = data.map( { $0.value } ).min() ?? 1
        let delta = (max - min)
        
        for index in 0...data.count - 1 {
            
            
            let value = data[index].value
            var height = ((max - value) * Double(totalHeight)) / delta
            if height < 0 {
                height = 0
            } else if height > Double(totalHeight - 22) {
                height = Double(totalHeight - 22)
            }
            
            let x = CGFloat(index) * (offset)
            
            context.move(to: CGPoint(x: x + padding + padding / 4, y: totalHeight))
            context.addLine(to: CGPoint(x: x + padding + padding / 4, y: totalHeight - 4))
            
            context.move(to: CGPoint(x: x + padding + padding / 4, y: totalHeight - 4))
            context.addLine(to: CGPoint(x: x + padding + padding / 4, y: CGFloat(height + 22)))
        }
        
        context.strokePath()
        context.closePath()
    }
    
    
    
    private func drawTopLabels(on context: CGContext) {
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .left
        let topAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .medium),
            .foregroundColor: UIColor.black,
            .paragraphStyle: titleParagraphStyle
        ]
        
        
        let bottomAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: UIColor.black,
            .paragraphStyle: titleParagraphStyle
        ]
        
        
        
        // Calculate spacing
        let totalWidth = self.frame.size.width
        let totalHeight = self.frame.size.height - 22
        let offset = totalWidth / 7.0
        
        guard data.count > 0 else { return }
        
        // Calculate max and min
        let max = data.map({ $0.value }).max() ?? 1
        let min = data.map({ $0.value }).min() ?? 1
        let delta = max - min
        
        for index in 0...data.count - 1 {
            
            let text = data[index].text
            let value = data[index].value
            let textValue = data[index].textValue
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
            
            let topText = textValue
            let topAttributedString = NSAttributedString(string: topText, attributes: topAttributes)
            let topStringRect = CGRect(x: x + padding / 1.6, y: y, width: 66, height: 30)
            topAttributedString.draw(in: topStringRect)
            
            
            
            let bottomText = String(format: "%@", text)
            let bottomAttributedString = NSAttributedString(string: bottomText, attributes: bottomAttributes)
            let bottomStringRect = CGRect(x: x + padding / 1.8, y: totalHeight + 8, width: 66, height: 30)
            bottomAttributedString.draw(in: bottomStringRect)
        }
        
        context.strokePath()
        context.closePath()
        
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
