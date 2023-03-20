//
//  MatrixRainView.swift
//  SwiftUI-GPT-Lab
//
//  Created by zzzwco on 2023/3/20.
//
//  Copyright (c) 2023 zzzwco <zzzwco@outlook.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

struct MatrixRainView: View {
  @State private var drops: [Drop] = []
  private let dropCount = 600 // number of drops
  
  var body: some View {
    GeometryReader { gp in
      ZStack {
        Color.black
          .edgesIgnoringSafeArea(.all)
        ForEach(drops) { drop in
          Text(String(drop.text))
            .foregroundColor(.green)
            .font(Font.system(size: drop.size))
            .offset(x: drop.x, y: drop.y)
        }
      }
      .onAppear {
        for i in 0..<dropCount {
          drops.append(
            Drop(
              id: i,
              x: .random(in: -gp.size.width...gp.size.width),
              y: .random(in: -gp.size.height...gp.size.height)
            )
          )
        }
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
          for i in 0..<drops.count {
            drops[i].y += drops[i].speed
            if drops[i].y > gp.size.height {
              drops[i].y = -gp.size.height
              drops[i].x = CGFloat.random(in: -gp.size.width...gp.size.width)
            }
          }
        }
      }
    }
  }
}

struct Drop: Identifiable {
  var id: Int
  var x: CGFloat
  var y: CGFloat
  var speed: CGFloat
  var size: CGFloat
  var text: Character
  
  init(id: Int, x: CGFloat, y: CGFloat) {
    self.id = id
    self.x = x
    self.y = y
    self.speed = .random(in: 2..<6)
    self.size = .random(in: 10...20)
    self.text = Character(UnicodeScalar(Int.random(in: 33..<127))!)
  }
}


struct MatrixRainView_Previews: PreviewProvider {
  static var previews: some View {
    MatrixRainView()
  }
}
