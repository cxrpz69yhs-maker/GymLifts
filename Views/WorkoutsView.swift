import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @State private var showingAddWorkout = false
    @State private var showingRestoreAlert = false

    // Delete confirmation
    @State private var workoutPendingDeletion: Workout?
    @State private var showingDeleteWorkoutAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // MARK: - Empty State
                    if workoutStore.workouts.isEmpty {
                        Text("No workouts yet. Tap + to start your first one.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                            .padding(.horizontal)
                    } else {

                        // MARK: - Workout List
                        ForEach($workoutStore.workouts) { $workout in
                            HStack {

                                // Navigation to WorkoutDetailView
                                NavigationLink {
                                    WorkoutDetailView(workout: $workout)
                                        .environmentObject(workoutStore)
                                } label: {
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
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .buttonStyle(.plain)

                                // DELETE BUTTON
                                Button(role: .destructive) {
                                    workoutPendingDeletion = workout
                                    showingDeleteWorkoutAlert = true
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding(.leading, 8)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                        }
                    }
                }
                .padding()
            }

            .navigationTitle("Workouts")

            // MARK: - Toolbar
            .toolbar {

                // Add Workout
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddWorkout = true }) {
                        Image(systemName: "plus")
                    }
                }

                // Backup Menu
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

            // MARK: - Restore Backup Alert
            .alert("Restore Backup?", isPresented: $showingRestoreAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Restore", role: .destructive) {
                    workoutStore.loadBackup()
                }
            } message: {
                Text("Restoring a backup will overwrite your current workouts.")
            }

            // MARK: - Delete Workout Confirmation
            .alert("Delete Workout?", isPresented: $showingDeleteWorkoutAlert) {
                Button("Cancel", role: .cancel) {}

                Button("Delete", role: .destructive) {
                    if let workout = workoutPendingDeletion,
                       let index = workoutStore.workouts.firstIndex(where: { $0.id == workout.id }) {
                        workoutStore.workouts.remove(at: index)
                    }
                    workoutPendingDeletion = nil
                }
            } message: {
                Text("This will permanently delete the workout and all its exercises.")
            }

            // MARK: - Add Workout Sheet
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView()
                    .environmentObject(workoutStore)
                    .presentationDetents([.fraction(0.6), .medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
