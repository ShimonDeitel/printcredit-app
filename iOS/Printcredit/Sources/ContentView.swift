import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false

    @State private var draftJob: String = ""
    @State private var draftPages: Int = 0
    @State private var draftCourse: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.job)
                                .font(Theme.bodyFont)
                                .foregroundStyle(.primary)
                            if !("pages: \(item.pages)" + " · " + "course: \(item.course)".isEmpty) {
                                Text("pages: \(item.pages)" + " · " + "course: \(item.course)")
                                    .font(Theme.captionFont)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .listRowBackground(Theme.cardBackground)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Printcredit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                addSheet
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
                    .environmentObject(purchases)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(purchases)
            }
        }
    }

    private var addSheet: some View {
        NavigationStack {
            Form {
                TextField("Job", text: $draftJob)
                    .accessibilityIdentifier("field_job")
                TextField("Pages", value: $draftPages, format: .number)
                    .keyboardType(.numberPad)
                    .accessibilityIdentifier("field_pages")
                TextField("Course", text: $draftCourse)
                    .accessibilityIdentifier("field_course")
            }
            .navigationTitle("Add Print Job")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAdd = false
                    }
                    .accessibilityIdentifier("cancelAddButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = PrintJob(job: draftJob, pages: draftPages, course: draftCourse)
                        store.add(item)
                        resetDraft()
                        showingAdd = false
                    }
                    .accessibilityIdentifier("saveAddButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func resetDraft() {
        draftJob = ""
        draftPages = 0
        draftCourse = ""
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
