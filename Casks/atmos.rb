cask "atmos" do
  arch arm: "aarch64", intel: "x64"

  version "2026.7.27,2026.7.27"
  sha256 arm:   "7d0fc4602fe58a9cbcd3a3c637847f763ee913409ae5405f1687c85301bcc102",
         intel: "ae556b963e3dc52bd93a00939317480b4f06b6c39996b2745a578fc7832d8fea"

  url "https://github.com/AruNi-01/atmos/releases/download/desktop-#{version.csv.first}/Atmos_#{version.csv.second}_#{arch}.dmg",
      verified: "github.com/AruNi-01/atmos/"
  name "Atmos"
  desc "Atmosphere for Agentic Builders"
  homepage "https://atmos.land"

  livecheck do
    url :url
    strategy :github_latest do |json, _regex|
      match = json["tag_name"]&.match(/^desktop-(\d{4}\.\d{1,2}\.\d{1,2}(?:[-.a-zA-Z0-9]+)?)$/)
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
