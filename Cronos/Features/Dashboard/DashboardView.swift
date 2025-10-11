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
  @State private var showingAddDeadline = false
  @State private var deadlineToEdit: Deadline?

  var body: some View {
    NavigationView {
      List {
        ForEach(deadlines) { deadline in
          DeadlineBarView(deadline: deadline)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .listRowBackground(Color.clear)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
              Button(action: {
                deadlineToEdit = deadline
              }) {
                Label("Edit", systemImage: "pencil")
              }
              .tint(.blue)

              Button(
                role: .destructive,
                action: {
                  deleteDeadline(deadline)
                }
              ) {
                Label("Delete", systemImage: "trash")
              }
            }
        }
      }
      .listStyle(.plain)
      .navigationTitle("Dashboard")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { showingAddDeadline = true }) {
            Label("Add Deadline", systemImage: "plus")
          }
        }
      }
      .sheet(isPresented: $showingAddDeadline) {
        DeadlineFormView()
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
      }
      .sheet(item: $deadlineToEdit) { deadline in
        DeadlineFormView(deadline: deadline)
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
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

  private func deleteDeadline(_ deadline: Deadline) {
    withAnimation {
      modelContext.delete(deadline)
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

          if let notes = deadline.notes, !notes.isEmpty {
            Text(notes)
              .font(.caption)
              .foregroundColor(.secondary)
              .lineLimit(2)
          }

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

        VStack(alignment: .trailing, spacing: 2) {
          Text(deadline.date.formatted(date: .abbreviated, time: .omitted))
            .font(.caption)
            .foregroundColor(.secondary)

          Text(deadline.date.formatted(date: .omitted, time: .shortened))
            .font(.caption2)
            .foregroundColor(.secondary)
        }
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
    .contentShape(Rectangle())  // Makes entire view tappable
  }
}

#Preview {
  NavigationView {
    DashboardView()
  }
  .modelContainer(for: [Deadline.self, Category.self], inMemory: true)
}
