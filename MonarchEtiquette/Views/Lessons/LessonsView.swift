import SwiftUI

struct LessonsView: View {
    @Environment(DataManager.self) private var dataManager
    @Environment(ProgressManager.self) private var progressManager
    @State private var viewModel: LessonsViewModel?
    @State private var selectedCategory: LessonCategory?

    var body: some View {
        NavigationStack {
            ZStack {
                RoyalBackground()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        headerSection
                            .padding(.horizontal, 24)
                            .padding(.top, 32)

                        categoryList
                            .padding(.top, 16)

                        GoldDivider()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 32)

                        Spacer(minLength: 32)
                    }
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = LessonsViewModel(dataManager: dataManager, progressManager: progressManager)
                }
            }
            .navigationDestination(item: $selectedCategory) { category in
                LessonDetailView(category: category)
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Lessons")
                .font(.playfair(32))
                .tracking(3.84)
                .textCase(.uppercase)
                .foregroundStyle(Color.mGoldLight)

            Text("Master the art of refined conduct")
                .font(.inter(15))
                .foregroundStyle(Color.mCream.opacity(0.75))
        }
    }

    private var categoryList: some View {
        LazyVStack(spacing: 20) {
            ForEach(viewModel?.categories ?? []) { category in
                Button {
                    selectedCategory = category
                } label: {
                    LessonCard(category: category)
                        .padding(.horizontal, 24)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    LessonsView()
        .environment(DataManager())
        .environment(ProgressManager())
}
