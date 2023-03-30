//
//  BubblesView.swift
//  SwiftUI-GPT-Lab
//
//  Created by zzzwco on 2023/3/30.
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

struct BubblesView: View {
  @State private var bubbles: [Bubble] = (0..<20).map { _ in
    Bubble(color1: .random, color2: .random, size: CGFloat.random(in: 50...100))
  }
  @State private var animators: [BubbleAnimator] = (0..<20).map { _ in
    BubbleAnimator(progress: Double.random(in: 0...1))
  }
  @State private var positions: [CGPoint] = Array(repeating: .zero, count: 20)
  @State private var draggingBubble: Bubble?
  
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ForEach(0..<bubbles.count, id: \.self) { index in
          BubbleView(bubble: $bubbles[index], position: $positions[index], draggingBubble: $draggingBubble)
            .onAppear {
              positions[index] = randomPosition(for: bubbles[index], in: geometry)
            }
        }
      }
      .onReceive(timer) { _ in
        var animators = [BubbleAnimator]()
        var positions = [CGPoint]()
        for i in self.positions.indices {
          let isDragging = bubbles[i] == draggingBubble
          animators.append(BubbleAnimator(progress: self.animators[i].progress + (isDragging ? 0.0 : .random(in: 0.003...0.005))))
          positions.append(isDragging ? self.positions[i] : newPosition(for: bubbles[i], currentPos: self.positions[i], in: geometry, with: animators[i]))
        }
        withAnimation(Animation.linear(duration: 0.1)) {
          self.animators = animators
          self.positions = positions
        }
      }
    }
  }
  
  func randomPosition(for bubble: Bubble, in geometry: GeometryProxy) -> CGPoint {
    let maxPosX = Int(geometry.size.width - bubble.size / 2)
    let maxPosY = Int(geometry.size.height - bubble.size / 2)
    let minPos = Int(bubble.size / 2)
    
    let x = (bubble.id.hashValue % maxPosX) + minPos
    let y = (bubble.id.hashValue % maxPosY) + minPos
    
    return CGPoint(x: x, y: y)
  }
  
  func newPosition(for bubble: Bubble, currentPos: CGPoint, in geometry: GeometryProxy, with animator: BubbleAnimator) -> CGPoint {
    let angle = 2 * Double.pi * animator.progress
    
    let newX = currentPos.x + CGFloat(2 * cos(angle))
    let newY = currentPos.y + CGFloat(2 * sin(angle))
    
    return CGPoint(x: newX, y: newY)
  }
}

struct Bubble: Identifiable, Equatable {
  let id = UUID()
  let color1: Color
  let color2: Color
  var size: CGFloat
}

struct BubbleView: View {
  @Binding var bubble: Bubble
  @Binding var position: CGPoint
  @Binding var draggingBubble: Bubble?
  
  @GestureState private var dragOffset: CGSize = .zero
  @State private var isEnlarged: Bool = false
  
  var body: some View {
    Circle()
      .fill(LinearGradient(gradient: Gradient(colors: [bubble.color1, bubble.color2]), startPoint: .top, endPoint: .bottom))
      .frame(width: isEnlarged ? bubble.size * 1.5 : bubble.size, height: isEnlarged ? bubble.size * 1.5 : bubble.size)
      .position(position + dragOffset)
      .shadow(color: .gray, radius: 5, x: 0, y: 5)
      .gesture(
        DragGesture()
          .updating($dragOffset) { value, state, _ in
            state = value.translation
          }
          .onChanged { _ in
            draggingBubble = bubble
          }
          .onEnded { value in
            draggingBubble = nil
            position = position + value.translation
          }
      )
      .onTapGesture {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.2)) {
          isEnlarged.toggle()
        }
      }
  }
}

extension Color {
  static var random: Self {
    [Color.red, Color.orange, Color.yellow, Color.green, Color.teal, Color.blue, Color.purple, Color.brown, Color.cyan, Color.mint, Color.pink, Color.indigo]
      .randomElement()!
  }
}


func randomCGFloat() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}

func +(point: CGPoint, size: CGSize) -> CGPoint {
    return CGPoint(x: point.x + size.width, y: point.y + size.height)
}

struct BubbleAnimator: Animatable {
    var progress: Double

    init(progress: Double = 0) {
        self.progress = progress
    }

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
}

struct ContentView: View {
  var body: some View {
    BubblesView()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .preferredColorScheme(.dark)
  }
}


