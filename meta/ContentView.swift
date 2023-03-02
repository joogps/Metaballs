//
//  ContentView.swift
//  meta
//
//  Created by João Gabriel Pozzobon dos Santos on 08/09/22.
//

import SwiftUI

struct ContentView: View {
    @State var yPos: Double = 0.25
    @State var threshold: Double = 0.75
    @State var radius: Double = 20
    
    @State var date: Date? = nil
    
    var body: some View {
            HStack {
                Spacer()
                
                    TimelineView(.animation) { context in
                        let progress = date != nil ? min((context.date.timeIntervalSince1970-date!.timeIntervalSince1970)*0.35, 1) : 0
                        let animation = easeOutElastic(progress)
                        
                        var rect = CGRect(x: 0,
                                          y: 0,
                                          width: 450+cos(animation*Double.pi/2)*20,
                                          height: 150)
                        var blob = CGRect(x: rect.width-rect.height*1.5+animation*(rect.height+100),
                                          y: 0,
                                          width: rect.height+cos(animation*Double.pi/2)*20,
                                          height: rect.height)
                        
                        ZStack(alignment: .leading) {
                            Canvas { ctx, size in
                                ctx.addFilter(.alphaThreshold(min: threshold))
                                ctx.addFilter(.blur(radius: radius))
                                
                                ctx.drawLayer { ctx in
                                    ctx.fill(RoundedRectangle(cornerRadius: rect.height/2)
                                            .path(in: rect), with: .color(.black))
                                    
                                    ctx.fill(RoundedRectangle(cornerRadius: blob.height/2)
                                        .path(in: blob), with: .color(.black))
                                }
                            }
                            
                            Image(systemName: "timer")
                                .foregroundStyle(.orange)
                                .font(.system(size: 80))
                                .offset(x: blob.midX-46)
                                .blur(radius: (1-animation)*20)
                                .opacity(animation)
                        }
                    }.frame(width: 670, height: 150)
                    Spacer()
            }.padding(60)
            .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.white))
            .padding(60)
            .onTapGesture {
                date = .now
            }
    }
}

public func easeOutBack(_ t: Double) -> Double {
    let tMinueOne = t - 1.0
    return 1 + tMinueOne * tMinueOne * (2.70158 * tMinueOne + 1.70158)
}

public func easeOutElastic(_ t: Double) -> Double {
    let t2 = (t - 1) * (t - 1)
    return 1 - t2 * t2 * cos(t * Double.pi * 2.5)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
