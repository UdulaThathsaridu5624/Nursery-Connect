//
//  BodyMapView.swift
//  NurseryConnect
//
//  Created by Udula on 2026-04-10.
//

import SwiftUI

struct BodyMapView: View {
    @Binding var marks: [BodyMapMark]
    let isEditable: Bool

    @State private var showingFront = true

    private var visibleMarks: [BodyMapMark] {
        marks.filter { $0.isFrontView == showingFront }
    }

    var body: some View {
        VStack(spacing: AppSpacing.md) {

            // MARK: Front / Back toggle
            Picker("View", selection: $showingFront) {
                Text("Front").tag(true)
                Text("Back").tag(false)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, AppSpacing.md)

            // MARK: Body image + tap overlay
            GeometryReader { geo in
                ZStack {
                    // Body outline image
                    // Replace BodyFront / BodyBack in Assets.xcassets
                    // with proper child body outline diagrams for production
                    Image(showingFront ? "BodyFront" : "BodyBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .cornerRadius(12)

                    // Existing marks
                    ForEach(visibleMarks) { mark in
                        Circle()
                            .fill(Color.red.opacity(0.75))
                            .frame(width: 22, height: 22)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 2)
                            .position(
                                x: mark.xNormalized * geo.size.width,
                                y: mark.yNormalized * geo.size.height
                            )
                    }

                    // Tap to add marks (editable mode only)
                    if isEditable {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture { location in
                                let newMark = BodyMapMark(
                                    xNormalized: location.x / geo.size.width,
                                    yNormalized: location.y / geo.size.height,
                                    isFrontView: showingFront,
                                    label: showingFront ? "Front" : "Back"
                                )
                                marks.append(newMark)
                            }
                    }
                }
            }
            .frame(height: 280)
            .padding(.horizontal, AppSpacing.md)

            // MARK: Marks list (editable only)
            if isEditable && !marks.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Marked locations")
                        .font(.sectionHead)
                        .padding(.horizontal, AppSpacing.md)

                    ForEach(Array(marks.enumerated()), id: \.element.id) { index, mark in
                        HStack {
                            Circle()
                                .fill(Color.red.opacity(0.75))
                                .frame(width: 12, height: 12)
                            Text("\(mark.isFrontView ? "Front" : "Back") body — mark \(index + 1)")
                                .font(.bodySmall)
                            Spacer()
                            Button {
                                marks.remove(at: index)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                    }
                }
            }

            if isEditable {
                Text("Tap on the diagram to mark the location of injury")
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.md)
            }
        }
    }
}

#Preview {
    BodyMapView(marks: .constant([
        BodyMapMark(xNormalized: 0.5, yNormalized: 0.2, isFrontView: true, label: "Front")
    ]), isEditable: true)
    .padding()
}
