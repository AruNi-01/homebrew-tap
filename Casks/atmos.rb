cask "atmos" do
  arch arm: "aarch64", intel: "x64"

  version "2026.8.10,2026.8.10"
  sha256 arm:   "60908f2653022651dda31211acf5c118e1a3064b184c436c1bd99fb9f22ca08a",
         intel: "70b7c28cf40ae55fc9f54402178c871750a0a6c055899a7623be6109a076a61d"

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
