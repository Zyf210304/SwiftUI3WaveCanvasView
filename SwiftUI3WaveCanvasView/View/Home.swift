//
//  Home.swift
//  SwiftUI3WaveCanvasView
//
//  Created by 张亚飞 on 2021/6/13.
//

import SwiftUI

struct Home: View {
    
    @State var toggle: Bool = false
    
    var body: some View {
        
        ZStack {
            
            // wave from view...
            WaveFrom(color: .cyan.opacity(0.8), amplify: 150, isReversed: false)
                
            WaveFrom(color: (toggle ? Color.purple : Color.cyan).opacity(0.6), amplify: 140, isReversed: true)
            
            VStack {
                
                HStack {
                    
                    Text("Wave's")
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Toggle(isOn: $toggle) {
                        
                        Image(systemName: "eyedropper.halffull")
                            .font(.title2)
                    }
                    .toggleStyle(.button)
                    .tint(.purple)
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct WaveFrom: View {
    
    // custom color
    var color: Color
    
    var amplify: CGFloat
    
    //reverse motion...
    var isReversed: Bool
    
    var body: some View {
        
        //using time line view  for peroidc updates...
        
        TimelineView(.animation) { timeLine in
            
            
            //Canvas view for drawing wave...
            Canvas { context, size  in
                
                // getting current time ...
                let timeNow = timeLine.date.timeIntervalSinceReferenceDate
                
                //animating the wave using current time...
                let angle = timeNow.remainder(dividingBy: 2)
                
                //calculating offset...
                let offset = angle * size.width
                
//                context.draw(Text("\(offset)"), at: CGPoint(x: size.width / 2, y: 100))
                //you can see it now shifts to screen width...
                
                
                
                //you can see it moves between -1.5 - 1.5...
                //ie 3/2 = 1.5
                //if  2 means -1 to 1 ....
            
                //moving the whole view...
                //simple and easy wave animation....
                context.translateBy(x: isReversed ? offset : -offset, y: 0)
                
                
                
                // using swiftui path for drawing wave....
                context.fill(getPath(size: size), with: .color(color))
                
                // drawing curve front and back
                // so that tranlation will be lool like wave annimation
                context.translateBy(x: -size.width, y: 0)
                context.fill(getPath(size: size), with: .color(color))
                
                context.translateBy(x: size.width * 2, y: 0)
                context.fill(getPath(size: size), with: .color(color))
            }
        }
        
    }
    
    
    func  getPath(size: CGSize) ->Path{
        
        return Path{path in
            
            let  midHeight = size.height / 2
            
            let width = size.width
            
            //moving the wave to center leading...
            path.move(to: CGPoint(x: 0, y: midHeight))
            
            // drawing curve....
            
            // for bottom
            path.addCurve(to: CGPoint(x: width, y: midHeight), control1: CGPoint(x: width * 0.4, y: midHeight +  amplify), control2: CGPoint(x: width * 0.65, y: midHeight - amplify))
            
            // filling the bottom remaining area...
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            
            
            
        }
    }
    
}
