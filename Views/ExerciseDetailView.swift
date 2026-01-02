import SwiftUI

struct ExerciseDetailView: View {
    @Binding var workout: Workout
    @Binding var exercise: Exercise

    // Rest Timer
    @EnvironmentObject var restTimer: RestTimerManager

    // Add Set
    @State private var showingAddSet = false
    @State private var weight: String = ""
    @State private var reps: String = ""

    // Edit Set
    @State private var showingEditSet = false
    @State private var selectedSet: ExerciseSet?
    @State private var editWeight: String = ""
    @State private var editReps: String = ""

    // Rename Exercise
    @State private var showingRenameSheet = false
    @State private var editedName: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Exercise Name
                HStack {
                    Text(exercise.name)
                        .font(.largeTitle.bold())
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.horizontal)

                // MARK: - Inline Rest Timer
                VStack(spacing: 12) {

                    // Timer Display
                    Text(formattedTime)
                        .font(.system(size: 42, weight: .bold, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Start / Pause / Reset
                    HStack(spacing: 12) {
                        Button {
                            if restTimer.isRunning {
                                restTimer.pause()
                            } else {
                                restTimer.start()
                            }
                        } label: {
                            Text(restTimer.isRunning ? "Pause" : "Start")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        Button {
                            restTimer.reset()
                        } label: {
                            Text("Reset")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray6))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                        }
                    }

                    // Presets
                    HStack(spacing: 12) {
                        ForEach([30, 60, 90], id: \.self) { sec in
                            Button("\(sec)s") {
                                restTimer.add(seconds: sec)
                            }
                            .font(.subheadline)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }

                    }
                }
                .padding(.horizontal)

                // MARK: - Sets List (Modern Cards)
                VStack(alignment: .leading, spacing: 12) {
                    let sortedSets = exercise.sets.sorted { $0.date > $1.date }

                    if sortedSets.isEmpty {
                        Text("No sets yet. Add your first one below.")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    } else {
                        ForEach(sortedSets) { set in
                            Button {
                                selectedSet = set
                                editWeight = String(format: "%.0f", set.weight)
                                editReps = "\(set.reps)"
                                showingEditSet = true
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(set.weight, specifier: "%.0f") lbs")
                                            .font(.headline)
                                        Text("\(set.reps) reps")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
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
                .padding(.horizontal)

                // MARK: - Add Set Button
                Button {
                    showingAddSet = true
                } label: {
                    Label("Add Set", systemImage: "plus")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                }

                Spacer(minLength: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    editedName = exercise.name
                    showingRenameSheet = true
                }
            }
        }

        // MARK: - Add Set Sheet
        .sheet(isPresented: $showingAddSet) {
            VStack(spacing: 28) {
                Text("Add Set")
                    .font(.largeTitle.bold())
                    .padding(.top, 20)

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Weight")
                            .font(.headline)
                        TextField("lbs", text: $weight)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Reps")
                            .font(.headline)
                        TextField("reps", text: $reps)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button {
                    if let w = Double(weight), let r = Int(reps) {
                        exercise.sets.append(ExerciseSet(weight: w, reps: r))
                    }
                    weight = ""
                    reps = ""
                    showingAddSet = false
                } label: {
                    Text("Save Set")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Button("Cancel") {
                    showingAddSet = false
                }
                .foregroundColor(.red)
                .padding(.bottom, 20)
            }
        }

        // MARK: - Edit Set Sheet
        .sheet(isPresented: $showingEditSet) {
            VStack(spacing: 28) {
                Text("Edit Set")
                    .font(.largeTitle.bold())
                    .padding(.top, 20)

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Weight")
                            .font(.headline)
                        TextField("lbs", text: $editWeight)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Reps")
                            .font(.headline)
                        TextField("reps", text: $editReps)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button {
                    if let selected = selectedSet,
                       let w = Double(editWeight),
                       let r = Int(editReps),
                       let index = exercise.sets.firstIndex(where: { $0.id == selected.id }) {
                        exercise.sets[index].weight = w
                        exercise.sets[index].reps = r
                    }
                    showingEditSet = false
                } label: {
                    Text("Save Changes")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Button("Cancel") {
                    showingEditSet = false
                }
                .foregroundColor(.red)
                .padding(.bottom, 20)
            }
        }

        // MARK: - Rename Exercise Sheet
        .sheet(isPresented: $showingRenameSheet) {
            VStack(spacing: 24) {
                Text("Rename Exercise")
                    .font(.title.bold())
                    .padding(.top, 20)

                TextField("Exercise name", text: $editedName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)

                Spacer()

                Button {
                    exercise.name = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
                    showingRenameSheet = false
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Button("Cancel") {
                    showingRenameSheet = false
                }
                .foregroundColor(.red)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Timer Formatting
    private var formattedTime: String {
        let seconds = max(restTimer.remainingSeconds, 0)
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}

