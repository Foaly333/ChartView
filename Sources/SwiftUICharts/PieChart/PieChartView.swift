//
//  PieChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct PieChartView<ChartDataType> : View {
    private var interpreter : (ChartDataType)->ChartDataDescription
    public var data: [ChartDataType]
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    
    public init(data: [ChartDataType], title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f", interpreter : @escaping (ChartDataType)->ChartDataDescription){
        self.data = data
        self.interpreter = interpreter
        self.title = title
        self.legend = legend
        self.style = style
        self.formSize = form!
        if self.formSize == ChartForm.large {
            self.formSize = ChartForm.extraLarge
        }
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        ChartFrame(
            title: self.title,
            legend: self.legend,
            style: self.style,
            form: self.formSize,
            dropShadow: self.dropShadow,
            valueSpecifier: self.valueSpecifier
        ){showValue, currentValue, style in
            PieChartRow(data: data, backgroundColor: style.backgroundColor, accentColor: style.accentColor, showValue: showValue, currentValue: currentValue,interpreter : interpreter)
                .foregroundColor(self.style.accentColor).padding(self.legend != nil ? 0 : 12).offset(y:self.legend != nil ? 0 : -10)
        }
    }
}

extension PieChartView where ChartDataType == Double{
    public init(data: [Double], title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f"){
        self.init(
            data: data,
            title: title,
            legend: legend,
            style: style,
            form: form,
            dropShadow: dropShadow,
            valueSpecifier: valueSpecifier,
            interpreter: {ChartDataDescription(data: $0, color: nil)})
    }
}

extension PieChartView where ChartDataType == ChartDataDescription{
    public init(data: [ChartDataDescription], title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f"){
        self.init(
            data: data,
            title: title,
            legend: legend,
            style: style,
            form: form,
            dropShadow: dropShadow,
            valueSpecifier: valueSpecifier,
            interpreter: {$0})
    }
}

extension PieChartView where ChartDataType == (Double,Color?){
    public init(data: [(Double,Color?)], title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f"){
        self.init(
            data: data,
            title: title,
            legend: legend,
            style: style,
            form: form,
            dropShadow: dropShadow,
            valueSpecifier: valueSpecifier,
            interpreter: {ChartDataDescription(data: $0.0, color: $0.1)})
    }
}

#if DEBUG
struct PieChartView_Previews : PreviewProvider {
    static let testData : [(Double,Color?)] = [
        (56,Color.red),
        (78,Color.blue),
        (53,nil),
        (65,nil),
        (54,nil)
    ]
    static var previews: some View {
        PieChartView(data: testData, title: "Title", legend: "Legend")
    }
}
#endif
