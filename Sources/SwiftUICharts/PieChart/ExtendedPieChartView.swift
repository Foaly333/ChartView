//
//  ExtendedPieChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct ExtendedPieChartView<ChartDataType,LegendViewType : View> : View {
    private var interpreter : (ChartDataType)->ChartDataDescription
    public var data: [ChartDataType]
    public var title: String
    public var legend: ()->LegendViewType
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
    
    private static func legendTextGenerator(legend : String?,legendTextColor : Color) -> (()->Text){
        return {
            if(legend != nil) {
                return Text(legend!)
                    .font(.headline)
                    .foregroundColor(legendTextColor)
                //.padding()
            }else{
                return Text("")
            }
        }
    }
    
    public init(data: [ChartDataType], title: String, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f", interpreter : @escaping (ChartDataType)->ChartDataDescription,@ViewBuilder legend :@escaping ()->LegendViewType){
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
                    .foregroundColor(self.style.accentColor)
                /*.padding(self.legend != nil ? 0 : 12)
                 .offset(y:self.legend != nil ? 0 : -10)*/
                self.legend()
                
            }
            .frame(height: self.formSize.height*1.5)
    }
}

extension ExtendedPieChartView where LegendViewType == Text{
    public init(data: [ChartDataType], title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f", interpreter : @escaping (ChartDataType)->ChartDataDescription){
        self.init(
            data : data,
            title : title,
            style : style,
            form : form,
            dropShadow : dropShadow,
            valueSpecifier : valueSpecifier,
            interpreter : interpreter,
            legend : ExtendedPieChartView.legendTextGenerator(legend: legend, legendTextColor: style.legendTextColor)
        )
    }
}

extension ExtendedPieChartView where ChartDataType == Double, LegendViewType == Text{
    public init(data: [Double], title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f"){
        self.init(
            data: data,
            title: title,
            legend: legend,
            style: style,
            form: form,
            dropShadow: dropShadow,
            valueSpecifier: valueSpecifier,
            interpreter: {ChartDataDescription(data: $0, color: nil)}
        )
    }
}

extension ExtendedPieChartView where ChartDataType == Double{
    public init(data: [ChartDataType], title: String, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f", interpreter : @escaping (ChartDataType)->ChartDataDescription, legend : ()->LegendViewType){
        self.init(
            data : data,
            title : title,
            style : style,
            form : form,
            dropShadow : dropShadow,
            valueSpecifier : valueSpecifier,
            interpreter : interpreter,
            legend : legend
        )
    }
}

extension ExtendedPieChartView where ChartDataType == ChartDataDescription, LegendViewType == Text{
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

extension ExtendedPieChartView where ChartDataType == ChartDataDescription{
    public init(data: [ChartDataType], title: String, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f", interpreter : @escaping (ChartDataType)->ChartDataDescription, legend : ()->LegendViewType){
        self.init(
            data : data,
            title : title,
            style : style,
            form : form,
            dropShadow : dropShadow,
            valueSpecifier : valueSpecifier,
            interpreter : interpreter,
            legend : legend
        )
    }
}

extension ExtendedPieChartView where ChartDataType == (Double,Color?), LegendViewType == Text{
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

extension ExtendedPieChartView where ChartDataType == (Double,Color?){
    public init(data: [(Double,Color?)], title: String, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f",legend : @escaping ()->LegendViewType){
        self.init(
            data : data,
            title : title,
            style : style,
            form : form,
            dropShadow : dropShadow,
            valueSpecifier : valueSpecifier,
            interpreter : {ChartDataDescription(data: $0.0, color: $0.1)},
            legend : legend
        )
    }
}

#if DEBUG
struct ExtendedPieChartView_Previews : PreviewProvider {
    static let testData : [(Double,Color?)] = [
        (56,Color.red),
        (78,Color.blue),
        (53,nil),
        (65,nil),
        (54,nil)
    ]
    static var previews: some View {
        VStack{
            ExtendedPieChartView(data: testData, title: "Title",form: ChartForm.small){
                HStack{
                    Text("Hallo")
                    Spacer()
                    Text("Du")
                    Spacer()
                    HStack{
                        Text("Schöne")
                        Button("Welt"){
                            print("!")
                        }
                    }
                }
                .padding()
            }
            ExtendedPieChartView(data: testData,title: "Dies ist ein Titel",legend: "Legende"){tuple in
                return ChartDataDescription(data: tuple.0, color: tuple.0>60 ? .red : .blue)
            }
        }
    }
}
#endif
