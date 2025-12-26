import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @State private var showingAddWorkout = false
    @State private var showingRestoreAlert = false

    var body: some View {
        NavigationStack {
            List {
                ForEach($workoutStore.workouts) { $workout in
                    NavigationLink {
                        WorkoutDetailView(workout: $workout)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                                .font(.headline)

                            Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if workout.isFinished {
                                Text("Complete")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.2))
                                    .foregroundColor(.green)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    deleteWorkout(at: indexSet)
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddWorkout = true }) {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Save Backup") {
                            workoutStore.saveBackup()
                        }

                        Button("Load Backup") {
                            showingRestoreAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert("Restore Backup?", isPresented: $showingRestoreAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Restore", role: .destructive) {
                    workoutStore.loadBackup()
                }
            } message: {
                Text("Restoring a backup will overwrite your current workouts.")
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView()
                    .environmentObject(workoutStore)
            }
        }
    }

    private func deleteWorkout(at offsets: IndexSet) {
        workoutStore.workouts.remove(atOffsets: offsets)
    }
}

