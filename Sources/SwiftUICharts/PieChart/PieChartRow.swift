//
//  PieChartRow.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct PieChartRow : View {
    var data: [(Double,Color?)]
    var backgroundColor: Color
    var accentColor: Color
    var slices: [PieSlice] {
        var tempSlices:[PieSlice] = []
        var lastEndDeg:Double = 0
        let maxValue = data.map{$0.0}.reduce(0, +)
        for (slice,sliceColor) in data {
            let normalized:Double = Double(slice)/Double(maxValue)
            let startDeg = lastEndDeg
            let endDeg = lastEndDeg + (normalized * 360)
            lastEndDeg = endDeg
            tempSlices.append(PieSlice(startDeg: startDeg, endDeg: endDeg, value: slice, normalizedValue: normalized, color : sliceColor))
        }
        return tempSlices
    }
    
    @Binding var showValue: Bool
    @Binding var currentValue: Double
    
    @State private var currentTouchedIndex = -1 {
        didSet {
            if oldValue != currentTouchedIndex {
                showValue = currentTouchedIndex != -1
                currentValue = showValue ? slices[currentTouchedIndex].value : 0
            }
        }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack{
                ForEach(0..<self.slices.count){ i in
                    PieChartCell(
                        rect: geometry.frame(in: .local),
                        startDeg: self.slices[i].startDeg,
                        endDeg: self.slices[i].endDeg,
                        index: i,
                        backgroundColor: self.backgroundColor,
                        accentColor: self.slices[i].color == nil ? self.accentColor : self.slices[i].color!
                    )
                        .scaleEffect(self.currentTouchedIndex == i ? 1.1 : 1)
                        .animation(Animation.spring())
                }
            }
            .gesture(DragGesture()
                        .onChanged({ value in
                            let rect = geometry.frame(in: .local)
                            let isTouchInPie = isPointInCircle(point: value.location, circleRect: rect)
                            if isTouchInPie {
                                let touchDegree = degree(for: value.location, inCircleRect: rect)
                                self.currentTouchedIndex = self.slices.firstIndex(where: { $0.startDeg < touchDegree && $0.endDeg > touchDegree }) ?? -1
                            } else {
                                self.currentTouchedIndex = -1
                            }
                        })
                        .onEnded({ value in
                            self.currentTouchedIndex = -1
                        }))
        }
    }
}

#if DEBUG
struct PieChartRow_Previews : PreviewProvider {
    static let testData1 :[(Double,Color?)] = [
        (8.0,Color.red),
        (23.0,Color.blue),
        (54.0,Color.green),
        (32.0,Color.yellow),
        (12.0,Color.pink),
        (37.0,nil),
        (7.0,nil),
        (23.0,nil),
        (43.0,nil)
    ]
    static let testData2 : [(Double,Color?)] = [
        (0.0,nil)
    ]
    static var previews: some View {
        VStack {
            PieChartRow(data:testData1, backgroundColor: Color(red: 252.0/255.0, green: 236.0/255.0, blue: 234.0/255.0), accentColor: Color(red: 225.0/255.0, green: 97.0/255.0, blue: 76.0/255.0), showValue: Binding.constant(false), currentValue: Binding.constant(0))
                .frame(width: 100, height: 100)
            PieChartRow(data:testData2, backgroundColor: Color(red: 252.0/255.0, green: 236.0/255.0, blue: 234.0/255.0), accentColor: Color(red: 225.0/255.0, green: 97.0/255.0, blue: 76.0/255.0), showValue: Binding.constant(false), currentValue: Binding.constant(0))
                .frame(width: 100, height: 100)
        }
    }
}
#endif
