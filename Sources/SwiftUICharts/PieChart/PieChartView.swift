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
    
    @State private var showValue = false
    @State private var currentValue: Double = 0 {
        didSet{
            if(oldValue != self.currentValue && self.showValue) {
                HapticFeedback.playSelection()
            }
        }
    }
    
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
        ZStack{
            Rectangle()
                .fill(self.style.backgroundColor)
                .cornerRadius(20)
                .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 12 : 0)
            VStack(alignment: .leading){
                HStack{
                    if(!showValue){
                        Text(self.title)
                            .font(.headline)
                            .foregroundColor(self.style.textColor)
                    }else{
                        Text("\(self.currentValue, specifier: self.valueSpecifier)")
                            .font(.headline)
                            .foregroundColor(self.style.textColor)
                    }
                    Spacer()
                    Image(systemName: "chart.pie.fill")
                        .imageScale(.large)
                        .foregroundColor(self.style.legendTextColor)
                }.padding()
                PieChartRow(data: data, backgroundColor: self.style.backgroundColor, accentColor: self.style.accentColor, showValue: $showValue, currentValue: $currentValue,interpreter : interpreter)
                    .foregroundColor(self.style.accentColor).padding(self.legend != nil ? 0 : 12).offset(y:self.legend != nil ? 0 : -10)
                if(self.legend != nil) {
                    Text(self.legend!)
                        .font(.headline)
                        .foregroundColor(self.style.legendTextColor)
                        .padding()
                }
                
            }
        }.frame(width: self.formSize.width, height: self.formSize.height)
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
