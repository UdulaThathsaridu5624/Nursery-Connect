//
//  StatusBadge.swift
//  NurseryConnect
//
//  Created by Udula on 2026-04-09.
//

import SwiftUI

struct StatusBadge: View {
    let status: IncidentStatus

    var body: some View {
        Text(status.rawValue)
            .font(.system(.caption, design: .rounded, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xs)
            .background(Capsule().fill(status.color))
    }
}

#Preview {
    VStack(spacing: AppSpacing.sm) {
        ForEach(IncidentStatus.allCases, id: \.self) { status in
            StatusBadge(status: status)
        }
    }
    .padding()
}
