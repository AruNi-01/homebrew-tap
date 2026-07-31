cask "atmos" do
  arch arm: "aarch64", intel: "x64"

  version "2026.7.29,2026.7.29"
  sha256 arm:   "d4f5bab2987aa355f5f898f8f241ce1a3ab1ad0fc466c20b00ebb894df165d0d",
         intel: "073d216f9341ec9e73f8cd461a190c8bb872d75e7146af1cdcb065f057ce9d94"

  url "https://github.com/AruNi-01/atmos/releases/download/desktop-electron-#{version.csv.first}/Atmos_#{version.csv.second}_#{arch}.dmg",
      verified: "github.com/AruNi-01/atmos/"
  name "Atmos"
  desc "Atmosphere for Agentic Builders"
  homepage "https://atmos.land"

  livecheck do
    url :url
    strategy :github_latest do |json, _regex|
      match = json["tag_name"]&.match(/^desktop-electron-(\d{4}\.\d{1,2}\.\d{1,2}(?:[-.a-zA-Z0-9]+)?)$/)
      next if match.blank?

      version = match[1]
      release = GitHub.get_latest_release("AruNi-01", "atmos")
      arm_asset = release["assets"]&.find { |asset| asset["name"]&.match?(/^Atmos_(.+)_aarch64\.dmg$/) }
      asset_match = arm_asset && arm_asset["name"].match(/^Atmos_(.+)_aarch64\.dmg$/)
      asset_version = asset_match && asset_match[1]
      next if asset_version.blank?

      "#{version},#{asset_version}"
    end
  end

  depends_on macos: ">= :catalina"

  app "Atmos.app"

  zap trash: [
    "~/Library/Application Support/com.atmos.desktop",
    "~/Library/Caches/com.atmos.desktop",
    "~/Library/HTTPStorages/com.atmos.desktop",
    "~/Library/Logs/com.atmos.desktop",
    "~/Library/Preferences/com.atmos.desktop.plist",
    "~/Library/Saved Application State/com.atmos.desktop.savedState",
  ]
end
