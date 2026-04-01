//
//  DiaryDashboardView.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct DiaryDashboardView: View {
    @Query(sort: \Child.fullName)
    private var children: [Child]

    @State private var selectedDate: Date = .now
    @State private var selectedChild: Child?

    let columns = [GridItem(.adaptive(minimum: 160), spacing: AppSpacing.md)]

    var activeChildren: [Child] {
        children.filter { $0.isActive }
    }

    var body: some View {
        Group {
            if activeChildren.isEmpty {
                ContentUnavailableView(
                    "No Children Assigned",
                    systemImage: "person.2.slash",
                    description: Text("No active children are assigned to you today.")
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                        ForEach(activeChildren) { child in
                            // Placeholder card — replaced on Day 4
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                HStack {
                                    Circle()
                                        .fill(LinearGradient.nurseryAvatar)
                                        .frame(width: 44, height: 44)
                                        .overlay {
                                            Text(child.initials)
                                                .font(.cardTitle)
                                                .foregroundStyle(.white)
                                        }
                                    Spacer()
                                }
                                Text(child.preferredName)
                                    .font(.cardTitle)
                                Text(child.age)
                                    .font(.bodySmall)
                                    .foregroundStyle(.secondary)
                                Text(child.roomName)
                                    .font(.bodySmall)
                                    .foregroundStyle(Color.nurseryTeal)
                            }
                            .padding(AppSpacing.md)
                            .nurseryCard()
                            .onTapGesture { selectedChild = child }
                        }
                    }
                    .padding(AppSpacing.md)
                }
            }
        }
        .navigationTitle("Daily Diary")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .labelsHidden()
            }
        }
        .navigationDestination(item: $selectedChild) { child in
            // ChildDiaryView added on Day 5
            Text("Diary for \(child.preferredName) — coming Day 5")
                .navigationTitle(child.preferredName)
        }
    }
}

#Preview {
    NavigationStack {
        DiaryDashboardView()
    }
    .modelContainer(SampleData.previewContainer)
}
