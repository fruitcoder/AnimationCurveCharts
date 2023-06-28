//
//  UnitCurveAnimatableChart.swift
//  AnimationCurveCharts
//
//  Created by fruitcoder on 27.06.23.
//

import Charts
import SwiftUI

struct UnitPointPlottable: Identifiable, Equatable {
  var x: Double
  var y: Double

  var id: some Hashable { x }
}

struct UnitCurveAnimatableChart: View, Animatable {
  var animatableData: Double = 0
  let unitCurve: UnitCurve
  let samplePoints: StrideThrough<Double>
  let samples: [UnitPointPlottable]

  init(
    progress: Double,
    unitCurve: UnitCurve = .easeInOut
  ) {
    self.unitCurve = unitCurve
    self.animatableData = progress
    self.samplePoints = stride(from: 0.0, through: 1.0, by: 0.01)
    self.samples = self.samplePoints.map {
      .init(x: $0, y: unitCurve.value(at: $0))
    }
  }

  var body: some View {
    Chart {
      let lastPoint = samples.first(where: { $0.x >= animatableData })

      ForEach(samples) {
        if $0.x <= lastPoint?.x ?? 0.0 {
          LineMark(
            x: .value("progress", $0.x),
            y: .value("value", $0.y)
          )
        }
      }

      PointMark(
        x: .value("progess", lastPoint?.x ?? 0.0),
        y: .value("value", lastPoint?.y ?? 0.0)
      )
    }
    .chartXScale(domain: 0.0...1.0)
    .chartYScale(domain: 0.0...1.0)
  }
}

enum UnitCurveOptions: String, CaseIterable, Identifiable {
  case linear, easeOut, easeInOut
  var curve: UnitCurve {
    switch self {
    case .linear:
      return .linear
    case .easeOut:
      return .easeOut
    case .easeInOut:
      return .easeInOut
    }
  }
  var id: Self { self }
}

struct AnimationWrapper: View {
  @State var progress: Double = 0.0
  @State var selectedCurve = UnitCurveOptions.linear

  var body: some View {
    VStack {
      UnitCurveAnimatableChart(
        progress: progress,
        unitCurve: selectedCurve.curve
      )
      .frame(height: 400)
      Button("Toggle") {
        withAnimation(.timingCurve(selectedCurve.curve, duration: 1.0)) {
          progress = progress == 0.0 ? 1.0 : 0.0
        }
      }.buttonStyle(.borderedProminent)
      Picker("Curve", selection: $selectedCurve.animation()) {
        ForEach(UnitCurveOptions.allCases) {
          Text($0.rawValue.capitalized)
        }
      }
      .pickerStyle(.segmented)
    }
  }
}

#Preview {
  AnimationWrapper()
}
