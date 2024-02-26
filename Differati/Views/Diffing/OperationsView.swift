//
//  OperationsView.swift
//  Differati
//
//  Created by Johan Sørensen on 25/02/2024.
//

import SwiftUI

struct OperationsView: View {
    let diff: DiffImage
    @State private var confirmingOverwriteOldWithNew = false
    @State private var confirmingOverwriteNewWithOld = false
    @State private var selectedOperation: CopyOperation = .overwriteOldWithNew
    @Environment(\.dismiss) private var dismiss

    private let maxHeight: CGFloat = 180

    enum CopyOperation: Hashable {
        case overwriteOldWithNew
        case overwriteNewWithOld
    }

    struct OperationSelection: View {
        let title: LocalizedStringKey
        let diff: DiffImage
        let operation: CopyOperation
        let isSelected: Bool

        private var operationColor: Color {
            operation == .overwriteNewWithOld ? Color.red : Color.green
        }

        private var image: NSImage {
            switch operation {
            case .overwriteOldWithNew: diff.oldImage
            case .overwriteNewWithOld: diff.newImage
            }
        }

        private var fileUrl: URL {
            switch operation {
            case .overwriteOldWithNew: diff.oldImageFileUrl
            case .overwriteNewWithOld: diff.newImageFileUrl
            }
        }

        var body: some View {
            VStack(spacing: 12) {
                Text(title)
                    .foregroundStyle(operationColor)
                ImageView(nsImage: image)
                    .frame(width: 200)
                    //.frame(minHeight: 64, maxHeight: maxHeight)

                Group {
                    if isSelected {
                        Image(systemName: operation == .overwriteOldWithNew ? "arrow.left.circle.fill" : "arrow.right.circle.fill")
                            .tint(.accentColor)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .font(.largeTitle)

                Text(verbatim: (fileUrl.relativePath as NSString).abbreviatingWithTildeInPath)
                    .truncationMode(.middle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .multilineTextAlignment(.center)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .stroke(isSelected ? Color(NSColor.selectedContentBackgroundColor) : .clear, lineWidth: 2)
            }
        }
    }

    @ViewBuilder
    private var oldView: some View {
        OperationSelection(
            title: "Replace New with Old",
            diff: diff,
            operation: .overwriteNewWithOld,
            isSelected: selectedOperation == .overwriteNewWithOld
        )
        .help("Replace new image with old image")
    }

    @ViewBuilder
    private var newView: some View {
        OperationSelection(
            title: "Replace Old with New",
            diff: diff,
            operation: .overwriteOldWithNew,
            isSelected: selectedOperation == .overwriteOldWithNew
        )
        .help("Replace old image with new image")
    }

    var body: some View {
        VStack {
            Text("Choose Image To Replace")
                .font(.headline)

            HStack {
                Button {
                    selectedOperation = .overwriteNewWithOld
                } label: {
                    oldView
                        .contentShape(.rect)
                }
                .keyboardShortcut(.rightArrow)
                // TODO: focusable()

                Button {
                    selectedOperation = .overwriteOldWithNew
                } label: {
                    newView
                        .contentShape(.rect)
                }
                .keyboardShortcut(.leftArrow)
            }
            .padding()
            .buttonStyle(.plain)

            HStack {
                Spacer()
                Button(confirmButtonTitle, role: .destructive) { confirm() }
                    .buttonStyle(.borderedProminent)
                Button("Cancel") { dismiss() }
            }
        }
        .padding()
        .frame(width: 520)
        .confirmationDialog(confirmTitle(targetUrl: diff.oldImageFileUrl), isPresented: $confirmingOverwriteOldWithNew) {
            Button("Replace", role: .destructive) {
                copy(source: diff.newImageFileUrl, destination: diff.oldImageFileUrl)
            }
        } message: {
            Text(confirmMessage(targetUrl:diff.oldImageFileUrl))
        }
        .confirmationDialog(confirmTitle(targetUrl: diff.newImageFileUrl), isPresented: $confirmingOverwriteNewWithOld) {
            Button("Replace", role: .destructive) {
                copy(source: diff.oldImageFileUrl, destination: diff.newImageFileUrl)
            }
        } message: {
            Text(confirmMessage(targetUrl:diff.newImageFileUrl))
        }
    }

    private var confirmButtonTitle: LocalizedStringKey {
        switch selectedOperation {
        case .overwriteOldWithNew: "Replace Old Image With New Image"
        case .overwriteNewWithOld: "Replace New Image With Old Image"
        }
    }

    private func confirm() {
        switch selectedOperation {
        case .overwriteOldWithNew: confirmingOverwriteOldWithNew = true
        case .overwriteNewWithOld: confirmingOverwriteNewWithOld = true
        }
    }

    private func confirmTitle(targetUrl: URL) -> LocalizedStringKey {
        let basename = targetUrl.lastPathComponent
        return "“\(basename)” already exists. Do you want to replace it?"
    }

    private func confirmMessage(targetUrl: URL) -> LocalizedStringKey {
        let folder = targetUrl.deletingLastPathComponent().lastPathComponent
        return "A file or folder with the same name already exists in the folder “\(folder)”. Replacing it will overwrite its current contents."
    }

    private func copy(source: URL, destination: URL) {
        do {
            _ = try FileManager.default.replaceItemAt(destination, withItemAt: source)
            dismiss()
        } catch {
            NSLog("failed to copy \(source) to \(destination): \(error)")
        }
    }
}

#Preview {
    OperationsView(diff: .preview)
}
