//
//  UnitCurveAnimationDebugView.swift
//  AnimationCurveCharts
//
//  Created by fruitcoder on 27.06.23.
//

import Charts
import SwiftUI

struct UnitCurveAnimationDebugView: View {
	let curves: [UnitCurve] = [
		.linear, .linear,
		.easeIn, .easeIn,
		.easeOut, .easeOut,
		.easeInOut, .easeInOut
	]

	var body: some View {
		PhaseAnimator(curves) { curve in
			VStack {
				Chart {
					let values = stride(from: 0.0, through: 1.0, by: 0.01).map { curve.value(at: $0) }

					ForEach(Array(values.enumerated()), id: \.offset) { index, value in
						LineMark(
							x: .value("Progress", Double(index) / 100.0),
							y: .value("Value", value)
						)
					}
				}
				.frame(height: 400)

				Text(curve.name)
					.transaction {
						$0.animation = nil
					}
			}
		} animation: { curve in
			Animation.timingCurve(curve, duration: 1.0)
		}
	}
}

private extension UnitCurve {
	var name: String {
		switch self {
		case .linear:
			return "Linear"
		case .easeIn:
			return "Ease In"
		case .easeOut:
			return "Ease Out"
		case .easeInOut:
			return "Ease InOut"
		case .circularEaseIn:
			return "Circular EaseIn"
		case .circularEaseOut:
			return "Circular EaseOut"
		case .circularEaseInOut:
			return "Circular EaseInOut"
		default:
			return "Other"
		}
	}
}

#Preview {
	UnitCurveAnimationDebugView()
}
