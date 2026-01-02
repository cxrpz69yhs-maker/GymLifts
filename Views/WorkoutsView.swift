import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @State private var showingAddWorkout = false
    @State private var showingRestoreAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if workoutStore.workouts.isEmpty {
                        Text("No workouts yet. Tap + to start your first one.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                            .padding(.horizontal)
                    } else {
                        ForEach($workoutStore.workouts) { $workout in
                            NavigationLink {
                                WorkoutDetailView(workout: $workout)
                                    .environmentObject(workoutStore)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(workout.name)
                                            .font(.headline)

                                        Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)

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

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
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
                    .presentationDetents([.fraction(0.6), .medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
