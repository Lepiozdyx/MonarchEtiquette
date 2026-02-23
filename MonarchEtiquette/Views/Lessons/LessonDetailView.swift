import SwiftUI

struct LessonDetailView: View {
    let category: LessonCategory
    @Environment(ProgressManager.self) private var progressManager
    @State private var selectedLesson: Lesson?
    @State private var showingLesson = false

    var body: some View {
        ZStack {
            RoyalBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    coverHeader

                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Lessons")
                            .padding(.top, 32)

                        ForEach(category.lessons) { lesson in
                            lessonRow(lesson: lesson)
                        }

                        GoldDivider()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(category.title)
                    .font(.playfair(16))
                    .tracking(1.6)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.mGoldLight)
            }
        }
        .sheet(item: $selectedLesson) { lesson in
            LessonReaderView(lesson: lesson, onComplete: {
                progressManager.markLessonCompleted(lesson.id)
                selectedLesson = nil
            })
        }
    }

    private var coverHeader: some View {
        ZStack(alignment: .bottomLeading) {
            Image(category.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .clipped()

            LinearGradient(
                colors: [.clear, Color(red: 0.165, green: 0.039, blue: 0.063)],
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(spacing: 12) {
                Image(systemName: category.sfSymbol)
                    .font(.system(size: 20, weight: .light))
                    .foregroundStyle(Color.mGold)
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.subtitle)
                        .font(.inter(14, weight: .medium))
                        .foregroundStyle(Color.mCream.opacity(0.8))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .frame(height: 220)
        .clipped()
    }

    private func lessonRow(lesson: Lesson) -> some View {
        let isCompleted = progressManager.isLessonCompleted(lesson.id)

        return Button {
            selectedLesson = lesson
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? Color.mGold.opacity(0.2) : Color.mCardBg)
                        .overlay(
                            Circle().strokeBorder(
                                isCompleted ? Color.mGold : Color.mGold.opacity(0.3),
                                lineWidth: 0.6
                            )
                        )
                    Image(systemName: isCompleted ? "checkmark" : "book.open")
                        .font(.system(size: 14, weight: isCompleted ? .semibold : .light))
                        .foregroundStyle(isCompleted ? Color.mGold : Color.mGold.opacity(0.7))
                }
                .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(.playfair(17))
                        .foregroundStyle(isCompleted ? Color.mGold : Color.mGoldLight)

                    Text("\(lesson.keyPoints.count) key points")
                        .font(.inter(13))
                        .foregroundStyle(Color.mCream.opacity(0.6))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(Color.mGold.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .royalCard(borderOpacity: isCompleted ? 0.4 : 0.25)
        }
        .buttonStyle(.plain)
    }
}

struct LessonReaderView: View {
    let lesson: Lesson
    let onComplete: () -> Void
    @Environment(ProgressManager.self) private var progressManager

    var body: some View {
        ZStack {
            RoyalBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(lesson.title)
                        .font(.playfair(28))
                        .tracking(2)
                        .foregroundStyle(Color.mGoldLight)
                        .padding(.top, 32)
                        .padding(.horizontal, 24)

                    Rectangle()
                        .fill(LinearGradient.goldHorizontal)
                        .frame(height: 1)
                        .padding(.horizontal, 60)
                        .padding(.top, 16)

                    Text(lesson.content)
                        .font(.inter(16))
                        .foregroundStyle(Color.mCream.opacity(0.9))
                        .lineSpacing(8)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Key Points")

                        ForEach(lesson.keyPoints, id: \.self) { point in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "crown")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Color.mGold)
                                    .frame(width: 16, height: 16)
                                    .padding(.top, 2)

                                Text(point)
                                    .font(.inter(15))
                                    .foregroundStyle(Color.mCream.opacity(0.85))
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

                    let isCompleted = progressManager.isLessonCompleted(lesson.id)

                    if !isCompleted {
                        GoldButton(title: "Mark as Complete", icon: "checkmark") {
                            onComplete()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                    } else {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.mGold)
                            Text("Lesson Completed")
                                .font(.inter(15, weight: .medium))
                                .foregroundStyle(Color.mGold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        .padding(.horizontal, 24)
                    }

                    Spacer(minLength: 48)
                }
            }
        }
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(20)
    }
}

