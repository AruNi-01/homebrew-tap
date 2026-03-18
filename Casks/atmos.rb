cask "atmos" do
  arch arm: "aarch64", intel: "x64"

  version "0.2.0,0.1.5"
  sha256 arm:   "b12527225d5c87c5b50ee25c6a526015aac24ffe2297157b71901b570bde388f",
         intel: "58b69fa2752b77757857a0b602d7deedcbc38504d7209f69c0504851d048f16f"

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
