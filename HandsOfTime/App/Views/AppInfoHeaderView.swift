import SwiftUI

struct AppInfoHeaderView: View {
    private let iconSize: CGFloat = 80

    private var appNameWithVersion: String {
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? "Hands of Time"
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        return version.isEmpty ? name : "\(name) \(version)"
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            appIcon
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: iconSize / 6.4, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(appNameWithVersion)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)

                Text("Made with 💙 by SpacePyro Labs")
                    .font(.system(size: 14))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }

    @ViewBuilder
    private var appIcon: some View {
        if let icon = Bundle.main.appIcon {
            Image(uiImage: icon)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Image(systemName: "clock")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: iconSize / 6.4, style: .continuous))
        }
    }
}

private extension Bundle {
    var appIcon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let iconName = iconFiles.last {
            return UIImage(named: iconName)
        }

        if let iconFiles = infoDictionary?["CFBundleIconFiles"] as? [String],
           let iconName = iconFiles.last {
            return UIImage(named: iconName)
        }

        return nil
    }
}
