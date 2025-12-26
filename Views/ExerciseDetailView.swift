import SwiftUI

struct ExerciseDetailView: View {
    @Binding var workout: Workout
    @Binding var exercise: Exercise

    @StateObject private var restTimer = RestTimerManager()
    @State private var showingRestTimer = false

    @State private var showingAddSet = false
    @State private var weight: String = ""
    @State private var reps: String = ""

    @State private var showingRenameSheet = false
    @State private var editedName: String = ""

    // MARK: - Edit Set State
    @State private var showingEditSet = false
    @State private var selectedSet: ExerciseSet?
    @State private var editWeight: String = ""
    @State private var editReps: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: - Header
                VStack(spacing: 8) {
                    Text(exercise.name)
                        .font(.largeTitle.bold())
                }
                .padding(.top, 20)

                // MARK: - Sets (Modern Card Style, Sorted Newest → Oldest)
                VStack(spacing: 12) {
                    let sortedSets = exercise.sets.sorted { $0.date > $1.date }

                    ForEach(sortedSets) { set in
                        Button {
                            selectedSet = set
                            editWeight = String(format: "%.0f", set.weight)
                            editReps = "\(set.reps)"
                            showingEditSet = true
                        } label: {
                            HStack {
                                Text("\(set.weight, specifier: "%.0f") lbs")
                                    .font(.headline)

                                Spacer()

                                Text("\(set.reps) reps")
                                    .font(.headline)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
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
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                // MARK: - Rest Timer Button
                Button {
                    restTimer.remainingSeconds = 90
                    restTimer.totalSeconds = 90
                    restTimer.start()
                    showingRestTimer = true
                } label: {
                    Label("Rest Timer", systemImage: "timer")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
        }

        // MARK: - Toolbar (Rename Button)
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
            VStack(spacing: 20) {
                Text("Add Set")
                    .font(.title2.bold())

                TextField("Weight (lbs)", text: $weight)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)

                TextField("Reps", text: $reps)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                Button("Save") {
                    if let w = Double(weight), let r = Int(reps) {
                        exercise.sets.append(ExerciseSet(weight: w, reps: r))
                    }
                    weight = ""
                    reps = ""
                    showingAddSet = false
                }
                .buttonStyle(.borderedProminent)

                Button("Cancel") {
                    showingAddSet = false
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }

        // MARK: - Edit Set Sheet
        .sheet(isPresented: $showingEditSet) {
            NavigationStack {
                VStack(spacing: 24) {

                    Text("Edit Set")
                        .font(.largeTitle.bold())
                        .padding(.top, 20)

                    VStack(spacing: 16) {

                        // Weight Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Weight")
                                .font(.headline)
                            TextField("lbs", text: $editWeight)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }

                        // Reps Field
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

                    // Save Button
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

                    // Cancel Button
                    Button("Cancel") {
                        showingEditSet = false
                    }
                    .foregroundColor(.red)
                    .padding(.bottom, 20)

                }
                .navigationBarHidden(true)
            }
        }

        // MARK: - Rename Exercise Sheet
        .sheet(isPresented: $showingRenameSheet) {
            NavigationStack {
                Form {
                    TextField("Exercise Name", text: $editedName)
                }
                .navigationTitle("Rename Exercise")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            exercise.name = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
                            showingRenameSheet = false
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingRenameSheet = false
                        }
                    }
                }
            }
        }

        // MARK: - Rest Timer Sheet
        .sheet(isPresented: $showingRestTimer) {
            RestTimerView(timer: restTimer)
        }
    }
}

