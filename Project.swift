import ProjectDescription

let project = Project(
  name: "brainy",
  packages: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.22.1"),
  ],
  targets: [
    .target(
      name: "brainy",
      destinations: .iOS,
      product: .app,
      bundleId: "com.sro.brainy",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
        ]
      ),
      buildableFolders: [
        "brainy/Sources",
        "brainy/Resources",
      ],
      dependencies: [
        .package(product: "ComposableArchitecture")
      ]
    ),
    .target(
      name: "brainyTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "com.sro.brainyTests",
      infoPlist: .default,
      buildableFolders: [
        "brainy/Tests"
      ],
      dependencies: [.target(name: "brainy")]
    ),
  ]
)
