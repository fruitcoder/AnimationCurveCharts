//
//  AnimationCurveChartsApp.swift
//  AnimationCurveCharts
//
//  Created by fruitcoder on 27.06.23.
//

import SwiftUI

enum Destination: String, Identifiable, Hashable, CaseIterable {
	case unitCurvePhased
	case unitCurveInteractive
	case springsInteractive

	var id: String { rawValue }

	var title: String {
		switch self {
		case .unitCurvePhased:
			return "Unit Curves (phased animation)"
		case .unitCurveInteractive:
			return "Unit Curves Interactive"
		case .springsInteractive:
			return "Springs Interactive"
		}
	}
}

@main
struct AnimationCurveChartsApp: App {
	var body: some Scene {
		WindowGroup {
			NavigationStack {
				List(Destination.allCases) {
					NavigationLink($0.title, value: $0)
				}
				.navigationDestination(for: Destination.self) { destination in
					switch destination {
					case .unitCurvePhased:
						UnitCurveAnimationDebugView()
					case .unitCurveInteractive:
						AnimationWrapper()
					case .springsInteractive:
						SpringAnimationDebugView()
							.navigationBarBackButtonHidden()
					}
				}
			}
		}
	}
}
