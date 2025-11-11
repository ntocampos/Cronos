import SwiftUI

/// A subtle animated background featuring multiple soft "blob" gradients that drift slowly and organically.
/// Uses white and light gray tones for a minimal, elegant effect.
struct AnimatedBlobGradientView: View {
  @State private var phase: Double = 0.0

  private let blobs: [BlobConfig] = [
    BlobConfig(baseX: 0.15, baseY: 0.2, size: 0.8, speed: 1.0, color: .white),
    BlobConfig(baseX: 0.75, baseY: 0.15, size: 0.7, speed: 0.8, color: Color(white: 0.95)),
    BlobConfig(baseX: 0.5, baseY: 0.5, size: 0.9, speed: 1.2, color: .white),
    BlobConfig(baseX: 0.2, baseY: 0.85, size: 0.7, speed: 0.9, color: Color(white: 0.97)),
    BlobConfig(baseX: 0.85, baseY: 0.7, size: 0.8, speed: 1.1, color: Color(white: 0.96)),
  ]

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Base background
        Color(white: 0.65)

        // Animated blobs
        ForEach(blobs.indices, id: \.self) { index in
          BlobView(
            config: blobs[index],
            phase: phase,
            geometry: geometry
          )
        }
      }
      .ignoresSafeArea()
    }
    .onAppear {
      // Start continuous animation with slow, subtle motion
      withAnimation(
        .linear(duration: 20)
          .repeatForever(autoreverses: true)
      ) {
        phase = .pi * 2
      }
    }
  }
}

/// Individual blob gradient view
private struct BlobView: View {
  let config: BlobConfig
  let phase: Double
  let geometry: GeometryProxy

  var body: some View {
    let xOffset = sin(phase * config.speed + config.baseX * 10) * 80
    let yOffset = cos(phase * config.speed * 0.7 + config.baseY * 10) * 80

    let x = config.baseX * geometry.size.width + xOffset
    let y = config.baseY * geometry.size.height + yOffset

    // Use max dimension to ensure circular blobs
    let blobSize = max(geometry.size.width, geometry.size.height) * config.size

    RadialGradient(
      colors: [
        config.color.opacity(0.9),
        config.color.opacity(0.6),
        config.color.opacity(0.0),
      ],
      center: .center,
      startRadius: 0,
      endRadius: blobSize / 2
    )
    .frame(
      width: blobSize,
      height: blobSize
    )
    .blur(radius: 50)
    .position(x: x, y: y)
    .animation(.linear(duration: 20).repeatForever(autoreverses: true), value: phase)
  }
}

/// Configuration for a single blob gradient
private struct BlobConfig {
  /// Base X position (0.0 to 1.0, relative to screen width)
  let baseX: Double
  /// Base Y position (0.0 to 1.0, relative to screen height)
  let baseY: Double
  /// Blob size (0.0 to 1.0, relative to screen dimensions)
  let size: Double
  /// Animation speed multiplier
  let speed: Double
  /// Blob color
  let color: Color
}

#Preview {
  AnimatedBlobGradientView()
}
