import Charts
import SwiftUI

struct SpringAnimationDebugView: View {
	let samples = 200
	let fullDurationSample: Double

	var values: [Double] {
		let spring = Spring(duration: 1.0, bounce: bounce)
		return (0...samples).map {
			spring.value(target: 1.0, time: Double($0) / fullDurationSample)
		}
	}

	func velocity(at progress: Double) -> Double {
		Spring(duration: 1.0, bounce: bounce).velocity(target: 1.0, time: progress)
	}

	init() {
		self.fullDurationSample = (Double(self.samples) / 2.0)
	}

	@State var bounce: Double = 0.0
	@State var selectedProgress: Double?

	var body: some View {
		VStack(spacing: 16) {
			Chart {
				ForEach(Array(values.enumerated()), id: \.offset) { index, value in
					LineMark(
						x: .value("Progress", Double(index) / fullDurationSample),
						y: .value("Value", value)
					)
				}

				if let selectedProgress {
					PointMark(
						x: .value("Progress", selectedProgress),
						y: .value("Value", values[Int(selectedProgress * fullDurationSample)])
					)
					RuleMark(
						x: .value("Selected", selectedProgress)
					)
					.foregroundStyle(Color.gray.opacity(0.3))
					.offset(yStart: -10)
					.zIndex(-1)
					.annotation(
						position: .top,
						spacing: 0,
						overflowResolution: .init(
							x: .fit(to: .chart),
							y: .disabled
						)
					) {
						VStack {
							Text("y: \(values[Int(selectedProgress * fullDurationSample)])")
							Text("velocity: \(velocity(at: selectedProgress))")
						}
						.foregroundColor(.secondary)
						.padding()
						.overlay(
							RoundedRectangle(cornerRadius: 12)
								.stroke(.blue, lineWidth: 2)
						)
					}
				}
			}
			.chartXSelection(value: $selectedProgress)
			.chartXScale(domain: 0.0...2.0)
			.chartYScale(domain: 0.0...2.0)
			.frame(height: 400)

			Slider(
				value: $bounce.animation(.interpolatingSpring),
				in: -0.99...1.0,
				step: 0.1) {
					Text("Bounce")
				} minimumValueLabel: {
					VStack {
						Image(systemName: "chart.line.flattrend.xyaxis")
						Text("-1.0")
					}
				} maximumValueLabel: {
					VStack {
						Image(systemName: "chart.line.uptrend.xyaxis")
						Text("1.0")
					}
				}
				.padding(.vertical)

			Text("Bounce: \(String(format: "%.2f", bounce))")
			Text(bounce < 0.0
					 ? "Overdamped aka Flattened"
					 : (bounce == 0.0 ? "Critically damped aka Smooth" : "Overdamped aka Bouncy")
			)
		}
	}
}

#Preview {
	SpringAnimationDebugView()
}
