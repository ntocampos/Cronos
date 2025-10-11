//
//  DashboardView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct DashboardView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]

  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(spacing: 12) {
          ForEach(deadlines) { deadline in
            DeadlineBarView(deadline: deadline)
          }
        }
        .padding()
      }
      .navigationTitle("Deadlines")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: addSampleDeadline) {
            Label("Add Deadline", systemImage: "plus")
          }
        }
      }
      .overlay {
        if deadlines.isEmpty {
          ContentUnavailableView(
            "No Deadlines",
            systemImage: "calendar",
            description: Text("Add your first deadline to get started")
          )
        }
      }
    }
  }

  private func addSampleDeadline() {
    withAnimation {
      let newDeadline = Deadline(
        title: "Sample Deadline",
        notes: "This is a sample deadline",
        date: Date().addingTimeInterval(TimeInterval.random(in: 86400...604800))  // 1-7 days from now
      )
      modelContext.insert(newDeadline)
    }
  }
}

struct DeadlineBarView: View {
  let deadline: Deadline

  private var progressValue: Double {
    guard let daysUntil = deadline.daysUntil else { return 1.0 }
    if daysUntil <= 0 { return 1.0 }  // Past deadline

    // Calculate progress based on a 30-day scale (you can adjust this)
    let maxDays: Double = 30
    let progress = max(0, (maxDays - Double(daysUntil)) / maxDays)
    return min(1.0, progress)
  }

  private var barColor: Color {
    if deadline.isPast {
      return .red
    } else if let daysUntil = deadline.daysUntil {
      if daysUntil <= 3 {
        return .orange
      } else if daysUntil <= 7 {
        return .yellow
      } else {
        return .purple
      }
    }
    return .gray
  }

  private var dateText: String {
    if deadline.isPast {
      return "Overdue"
    } else if let daysUntil = deadline.daysUntil {
      if daysUntil == 0 {
        return "Today"
      } else if daysUntil == 1 {
        return "Tomorrow"
      } else {
        return "\(daysUntil) days"
      }
    }
    return deadline.date.formatted(date: .abbreviated, time: .omitted)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text(deadline.title)
            .font(.headline)
            .foregroundColor(deadline.isPast ? .red : .primary)

          HStack {
            Text(dateText)
              .font(.caption)
              .foregroundColor(.secondary)

            Spacer()

            if let category = deadline.category {
              HStack(spacing: 4) {
                Circle()
                  .fill(category.color)
                  .frame(width: 8, height: 8)
                Text(category.name)
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
            }
          }
        }

        Spacer()

        Text(deadline.date.formatted(date: .abbreviated, time: .omitted))
          .font(.caption)
          .foregroundColor(.secondary)
      }

      // Progress bar
      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          // Background bar
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 8)

          // Progress bar
          RoundedRectangle(cornerRadius: 4)
            .fill(barColor)
            .frame(
              width: geometry.size.width * progressValue,
              height: 8
            )
            .animation(.easeInOut(duration: 0.3), value: progressValue)
        }
      }
      .frame(height: 8)
    }
    .padding()
    .background(Color(UIColor.secondarySystemBackground))
    .cornerRadius(12)
    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
  }
}

#Preview {
  NavigationView {
    DashboardView()
  }
  .modelContainer(for: [Deadline.self, Category.self], inMemory: true)
}
