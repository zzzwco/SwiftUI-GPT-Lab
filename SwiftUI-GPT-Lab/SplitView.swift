//
//  SplitView.swift
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

struct SplitView: View {
  private let data: [SampleType] = SampleType.allCases
  @State private var selection: SampleType?
  
  var body: some View {
    NavigationSplitView {
      List(data, id: \.rawValue, selection: $selection) { v in
        NavigationLink(v.rawValue, value: v)
      }
      .navigationTitle("SwiftUI-GPT-Lab")
    } detail: {
      selection?.view
    }
  }
}

enum SampleType: String, CaseIterable, CustomStringConvertible {
  var description: String {
    rawValue
  }
  
  case MatrixRain
  case Bubbles
  
  @ViewBuilder
  var view: some View {
    switch self {
    case .MatrixRain:
      MatrixRainView()
    case .Bubbles:
      BubblesView()
    }
  }
}

struct SplitView_Previews: PreviewProvider {
  static var previews: some View {
    SplitView()
  }
}
