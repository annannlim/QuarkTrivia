//
//  AnimatedBackground.swift
//  Trivia
//
//  Created by Annabel Lim on 12/17/25.
//

import SwiftUI

struct AnimatedBackground: View {

    @State var geo: GeometryProxy
    var body: some View {
        Image("backgroundBeach")
            .resizable()
            .frame(width:geo.size.width * 3, height: geo.size.height * 1.1)
            .padding(.top, 3)
            .phaseAnimator([false,true]) { content, phase in
                content
                    .offset(x: phase ? geo.size.width/1/1 : -geo.size.width/1.1)
            } animation: { _ in
                    .linear(duration: 60)
            }
    }
}

#Preview {
    GeometryReader { geo in
        AnimatedBackground(geo: geo)
            .frame(width: geo.size.width, height: geo.size.height)
    }
    .ignoresSafeArea()
    
}
