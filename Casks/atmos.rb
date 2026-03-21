cask "atmos" do
  arch arm: "aarch64", intel: "x64"

  version "0.2.4,0.2.4"
  sha256 arm:   "75b51276dbd42fa2402d2fe55e6af3b665bb47c8916e71b70d4b86eb736a80d3",
         intel: "2ed2d53227e0d3c92dfa11bcd6305dbe6d3fa4310e38c18fd42ffd27e8e4ea05"

  url "https://github.com/AruNi-01/atmos/releases/download/desktop-v#{version.csv.first}/Atmos_#{version.csv.second}_#{arch}.dmg",
      verified: "github.com/AruNi-01/atmos/"
  name "Atmos"
  desc "Atmosphere for Agentic Builders"
  homepage "https://atmos.land"

  livecheck do
    url :url
    strategy :github_latest do |json, _regex|
      match = json["tag_name"]&.match(/^desktop-v(\d+(?:\.\d+)+(?:[-.a-zA-Z0-9]+)?)$/)
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
