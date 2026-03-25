import SwiftUI

struct LifeChecklistView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showingAddItemAlert = false
    @State private var newItemTitle = ""

    var body: some View {
        NavigationStack {
            Group {
                if appState.lifeChecklistItems.isEmpty {
                    ContentUnavailableView(
                        "lifeChecklist.empty.title",
                        systemImage: "checklist",
                        description: Text("lifeChecklist.empty.subtitle")
                    )
                } else {
                    List {
                        ForEach(appState.sortedLifeChecklistItems) { item in
                            Button {
                                appState.toggleLifeChecklistItemCompletion(id: item.id)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundStyle(item.isCompleted ? Color.green : .secondary)

                                    Text(item.title)
                                        .foregroundStyle(.primary)
                                        .strikethrough(item.isCompleted, color: .secondary)
                                        .opacity(item.isCompleted ? 0.6 : 1)

                                    Spacer(minLength: 0)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                        .onMove(perform: appState.moveLifeChecklistItems)
                        .onDelete(perform: appState.deleteLifeChecklistItems)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(Text("lifeChecklist.title"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(appState.lifeChecklistProgressText)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    EditButton()

                    Button {
                        newItemTitle = ""
                        showingAddItemAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel(Text("lifeChecklist.add.button"))
                }
            }
            .alert("lifeChecklist.add.title", isPresented: $showingAddItemAlert) {
                TextField(LocalizedStringKey("lifeChecklist.add.placeholder"), text: $newItemTitle)
                Button("button.cancel", role: .cancel) {
                    newItemTitle = ""
                }
                Button("button.add") {
                    appState.addLifeChecklistItem(title: newItemTitle)
                    newItemTitle = ""
                }
            }
        }
    }
}

#Preview {
    LifeChecklistView()
        .environmentObject(AppState())
}
