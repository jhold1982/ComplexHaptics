//
//  ContentView.swift
//  ComplexHaptics
//
//  Created by Justin Hold on 4/22/24.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
	
	// MARK: - PROPERTIES
	@State private var engine: CHHapticEngine?
	@State private var counter: Int = 0
	
	// MARK: - VIEW BODY
	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundStyle(.tint)
				.padding()
			
			Button("Tap Count: \(counter)") {
				counter += 1
				complexHaptic()
			}
			.onAppear(perform: prepareHaptics)
//			.sensoryFeedback(.increase, trigger: counter) // standard haptic effect
//			.sensoryFeedback(
//				.impact(flexibility: .soft, intensity: 0.5),
//				trigger: counter
//			) // a middling collision between two soft objects
//			.sensoryFeedback(
//				.impact(weight: .heavy, intensity: 1),
//				trigger: counter
//			) // an inense collision between two heavy objects
		}
		.padding()
	}
	
	// MARK: - FUNCTIONS
	func prepareHaptics() {
		
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		
		do {
			engine = try CHHapticEngine()
			try engine?.start()
		} catch {
			print("There was a problem creating the engine: \(error.localizedDescription)")
		}
	}
	
	func complexHaptic() {
		
		// make sure the device supports haptics
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		
		// define a variable called events which is equal to
		// an array of CHHapticEvent initialized
		var events = [CHHapticEvent]()
		
		// create one inense, sharp tap
//		let intensity = CHHapticEventParameter(
//			parameterID: .hapticIntensity,
//			value: 1
//		)
//		let sharpness = CHHapticEventParameter(
//			parameterID: .hapticSharpness,
//			value: 1
//		)
//		let event = CHHapticEvent(
//			eventType: .hapticTransient,
//			parameters: [intensity, sharpness],
//			relativeTime: 0
//		)
		
		for i in stride(from: 0, to: 1, by: 0.1) {
			let intensity = CHHapticEventParameter(
				parameterID: .hapticIntensity,
				value: Float(i)
			)
			let sharpness = CHHapticEventParameter(
				parameterID: .hapticSharpness,
				value: Float(i)
			)
			let event = CHHapticEvent(
				eventType: .hapticTransient,
				parameters: [intensity, sharpness],
				relativeTime: i
			)
			events.append(event)
		}
		
		for i in stride(from: 0, to: 1, by: 0.1) {
			let intensity = CHHapticEventParameter(
				parameterID: .hapticIntensity,
				value: Float(1 - i)
			)
			let sharpness = CHHapticEventParameter(
				parameterID: .hapticSharpness,
				value: Float(1 - i)
			)
			let event = CHHapticEvent(
				eventType: .hapticTransient,
				parameters: [intensity, sharpness],
				relativeTime: 1 + i
			)
			events.append(event)
		}
		
		
		// convert those events into a pattern and play it immediately
		do {
			let pattern = try CHHapticPattern(events: events, parameters: [])
			let player = try engine?.makePlayer(with: pattern)
			try player?.start(atTime: 0)
		} catch {
			print("Failed to play pattern: \(error.localizedDescription)")
		}
	}
}

#Preview {
    ContentView()
}
