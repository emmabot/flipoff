import AppKit
import Foundation

// Render SVG layers to @1x PNGs for tvOS asset catalog
let sizes: [(Int, Int, String)] = [
    (400, 240, "small"),
    (1280, 768, "large"),
]
let layers = ["back", "middle", "front"]
let baseDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "."

for layer in layers {
    let svgPath = "\(baseDir)/layers/\(layer).svg"
    guard let svgData = try? Data(contentsOf: URL(fileURLWithPath: svgPath)),
          let svgImage = NSImage(data: svgData) else {
        print("ERROR: Failed to load \(svgPath)")
        exit(1)
    }

    for (w, h, label) in sizes {
        // Create a bitmap at exact @1x pixel dimensions
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: w,
            pixelsHigh: h,
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ) else {
            print("ERROR: Failed to create bitmap for \(layer)-\(label)")
            exit(1)
        }

        // Force @1x - 1 pixel = 1 point
        rep.size = NSSize(width: w, height: h)

        NSGraphicsContext.saveGraphicsState()
        let ctx = NSGraphicsContext(bitmapImageRep: rep)
        NSGraphicsContext.current = ctx
        ctx?.imageInterpolation = .high

        // Draw SVG scaled to fill
        svgImage.draw(in: NSRect(x: 0, y: 0, width: w, height: h))

        NSGraphicsContext.restoreGraphicsState()

        guard let pngData = rep.representation(using: .png, properties: [:]) else {
            print("ERROR: Failed to create PNG for \(layer)-\(label)")
            exit(1)
        }

        let outPath = "\(baseDir)/layers/\(layer)-\(label).png"
        try! pngData.write(to: URL(fileURLWithPath: outPath))
        print("✓ \(outPath) (\(w)x\(h) @1x)")
    }
}

// Also render the composite icon
for (w, h, label) in sizes {
    let svgPath = "\(baseDir)/lil-sauce-icon.svg"
    guard let svgData = try? Data(contentsOf: URL(fileURLWithPath: svgPath)),
          let svgImage = NSImage(data: svgData) else {
        print("ERROR: Failed to load composite SVG")
        exit(1)
    }

    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: w, pixelsHigh: h,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true,
        isPlanar: false, colorSpaceName: .deviceRGB,
        bytesPerRow: 0, bitsPerPixel: 0
    ) else { exit(1) }

    rep.size = NSSize(width: w, height: h)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    NSGraphicsContext.current?.imageInterpolation = .high
    svgImage.draw(in: NSRect(x: 0, y: 0, width: w, height: h))
    NSGraphicsContext.restoreGraphicsState()

    guard let pngData = rep.representation(using: .png, properties: [:]) else { exit(1) }
    let outPath = "\(baseDir)/lil-sauce-icon-\(w)x\(h).png"
    try! pngData.write(to: URL(fileURLWithPath: outPath))
    print("✓ \(outPath) (\(w)x\(h) @1x)")
}

print("\nDone! All layers rendered at @1x.")
