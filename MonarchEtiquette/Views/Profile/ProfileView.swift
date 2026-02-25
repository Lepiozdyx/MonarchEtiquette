import SwiftUI

struct ProfileView: View {
    @Environment(ProgressManager.self) private var progressManager
    @State private var viewModel: ProfileViewModel?
    @FocusState private var focusedField: ProfileField?

    enum ProfileField { case name, age }

    var body: some View {
        ZStack {
            RoyalBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                        .padding(.horizontal, 24)
                        .padding(.top, 32)

                    if let vm = viewModel {
                        personalInfoSection(vm: vm)
                            .padding(.horizontal, 24)
                            .padding(.top, 24)

                        refinementGoalsSection(vm: vm)
                            .padding(.horizontal, 24)
                            .padding(.top, 32)
                        
                        GoldButton(title: "Save Changes", icon: "checkmark") {
                            focusedField = nil
                            vm.saveProfile()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                        societyStatusSection(vm: vm)
                            .padding(.horizontal, 24)
                            .padding(.top, 32)

                        GoldDivider()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 32)
                    }

                    Spacer(minLength: 32)
                }
            }
            .scrollDismissesKeyboard(.interactively)

            if viewModel?.showingSavedBanner == true {
                savedBanner
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = ProfileViewModel(progressManager: progressManager)
            }
        }
    }

    private var headerSection: some View {
        Text("Profile")
            .font(.playfair(32))
            .tracking(3.84)
            .textCase(.uppercase)
            .foregroundStyle(Color.mGoldLight)
    }

    private func personalInfoSection(vm: ProfileViewModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Personal Information")

            VStack(spacing: 20) {
                inputField(
                    label: "Full Name",
                    text: Binding(get: { vm.fullName }, set: { vm.fullName = $0 }),
                    placeholder: "Your name",
                    field: .name
                )

//                inputField(
//                    label: "Age",
//                    text: Binding(get: { vm.ageText }, set: { vm.ageText = $0 }),
//                    placeholder: "Your age",
//                    field: .age,
//                    keyboardType: .numberPad
//                )

                reasonsSection(vm: vm)
            }
            .padding(24)
            .royalCard(borderOpacity: 0.3)
            .padding(.top, 16)
        }
    }

    private func inputField(
        label: String,
        text: Binding<String>,
        placeholder: String,
        field: ProfileField,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.inter(14, weight: .medium))
                .tracking(0.28)
                .foregroundStyle(Color.mGoldLight)

            TextField(placeholder, text: text)
                .font(.inter(16))
                .foregroundStyle(Color.mCream)
                .tint(Color.mGold)
                .keyboardType(keyboardType)
                .focused($focusedField, equals: field)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.165, green: 0.039, blue: 0.063).opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.mGold.opacity(focusedField == field ? 0.6 : 0.3), lineWidth: 0.6)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: focusedField == field)
        }
    }

    private func reasonsSection(vm: ProfileViewModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Primary Reason for Using the App")
                .font(.inter(14, weight: .medium))
                .tracking(0.28)
                .foregroundStyle(Color.mGoldLight)

            ForEach(PrimaryReason.allCases) { reason in
                reasonRow(reason: reason, vm: vm)
            }
        }
    }

    private func reasonRow(reason: PrimaryReason, vm: ProfileViewModel) -> some View {
        let isSelected = vm.selectedReasons.contains(reason)

        return Button {
            vm.toggleReason(reason)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isSelected ? Color.mGold : Color.mGold.opacity(0.2))
                        .frame(width: 20, height: 20)
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(isSelected ? Color.mGold : Color.mGold.opacity(0.4), lineWidth: 0.6)
                        .frame(width: 20, height: 20)
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color(red: 0.165, green: 0.039, blue: 0.063))
                    }
                }

                Text(reason.rawValue)
                    .font(.inter(15, weight: .medium))
                    .foregroundStyle(Color.mCream)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? Color.mGold.opacity(0.2) : Color(red: 0.165, green: 0.039, blue: 0.063).opacity(0.4))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color.mGold : Color.mGold.opacity(0.2), lineWidth: 0.6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    private func refinementGoalsSection(vm: ProfileViewModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Refinement Goals")

            VStack(spacing: 12) {
                ForEach(RefinementGoal.allCases) { goal in
                    goalRow(goal: goal, vm: vm)
                }
            }
        }
    }

    private func goalRow(goal: RefinementGoal, vm: ProfileViewModel) -> some View {
        let isEnabled = vm.selectedGoals.contains(goal)

        return HStack {
            Text(goal.rawValue)
                .font(.inter(16, weight: .medium))
                .foregroundStyle(isEnabled ? Color.mCream : Color.mCream.opacity(0.7))

            Spacer()

            Toggle("", isOn: Binding(
                get: { isEnabled },
                set: { _ in vm.toggleGoal(goal) }
            ))
            .tint(Color.mGold)
            .labelsHidden()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .royalCard(borderOpacity: 0.25)
    }

    private func societyStatusSection(vm: ProfileViewModel) -> some View {
        let rank = vm.societyRank

        return VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Society Status")

            ZStack {
                LinearGradient(
                    colors: [Color.mGold.opacity(0.2), Color.mGoldLight.opacity(0.08)],
                    startPoint: UnitPoint(x: 0.15, y: 0.15),
                    endPoint: UnitPoint(x: 0.85, y: 0.85)
                )
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.mGold.opacity(0.4), lineWidth: 0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.mGold.opacity(0.3), Color.mGoldLight.opacity(0.15)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                            .overlay(Circle().strokeBorder(Color.mGold, lineWidth: 1.7))

                        Image(systemName: "crown.fill")
                            .font(.system(size: 36, weight: .light))
                            .foregroundStyle(Color.mGold)
                    }
                    .frame(width: 96, height: 96)

                    Text(rank.title)
                        .font(.playfair(24))
                        .tracking(2.4)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.mGoldLight)

                    Text(rank.description)
                        .font(.inter(15))
                        .foregroundStyle(Color.mCream.opacity(0.8))
                        .multilineTextAlignment(.center)

                    if rank.level < 5 {
                        VStack(spacing: 8) {
                            Divider()
                                .background(Color.mGold.opacity(0.2))

                            Text("Next Level")
                                .font(.playfair(13))
                                .tracking(0.65)
                                .textCase(.uppercase)
                                .foregroundStyle(Color.mGoldLight.opacity(0.8))

                            HStack(spacing: 8) {
                                Image(systemName: "star")
                                    .font(.system(size: 16, weight: .light))
                                    .foregroundStyle(Color.mGold)
                                Text(rank.nextTitle)
                                    .font(.playfairRegular(18))
                                    .foregroundStyle(Color.mGold)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(24)
            }

            Text("Level \(rank.level) of 5")
                .font(.inter(13))
                .foregroundStyle(Color.mCream.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .center)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color.mGold.opacity(0.15))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 100)
                        .fill(LinearGradient.goldBarGradient)
                        .frame(width: geo.size.width * min(vm.rankProgress, 1.0), height: 8)
                        .shadow(color: Color.mGold.opacity(0.4), radius: 4)
                }
            }
            .frame(height: 8)
        }
    }

    private var savedBanner: some View {
        VStack {
            Spacer()
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.mGold)
                Text("Profile saved")
                    .font(.inter(15, weight: .medium))
                    .foregroundStyle(Color.mCream)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color(red: 0.165, green: 0.039, blue: 0.063))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.mGold.opacity(0.4), lineWidth: 0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.3), radius: 10)
            .padding(.bottom, 100)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(duration: 0.4), value: viewModel?.showingSavedBanner)
    }
}

#Preview {
    ProfileView()
        .environment(ProgressManager())
}
