//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Korz on 08.03.22.
//

import SwiftUI

struct ChartFrame<ChartView : View>: View {
    
    public var title: String
    public var image : String
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
    
    var chart : (Binding<Bool>, Binding<Double>) -> ChartView
    
    public init(title: String, image : String = "chart.pie.fill", legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f", @ViewBuilder chart : @escaping (Binding<Bool>, Binding<Double>) -> ChartView){
        self.title = title
        self.image = image
        self.legend = legend
        self.style = style
        self.formSize = form!
        if self.formSize == ChartForm.large {
            self.formSize = ChartForm.extraLarge
        }
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
        self.chart = chart
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
                    Image(systemName: image)
                        .imageScale(.large)
                        .foregroundColor(self.style.legendTextColor)
                }.padding()
                chart($showValue, $currentValue)
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

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChartFrame(title: "Test",image : "pencil"){_,_ in
            Text("Chart")
        }
    }
}
