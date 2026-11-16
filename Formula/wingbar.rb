class Wingbar < Formula
  desc "Light native macOS status bar: workspaces and script widgets in two wings"
  homepage "https://github.com/iammosab/wingbar"
  # url and sha256 are updated by wingbar's release workflow
  url "https://github.com/iammosab/wingbar/releases/download/v0.3.2/wingbar-macos.zip"
  sha256 "1efff7a3175dc6bbd71ee6e9f2b6b74f0d3d0a79032424385885420012598238"
  license "MIT"

  depends_on :macos

  def install
    # Homebrew steps into a lone top-level folder, so we may be inside Wingbar.app
    app = File.directory?("Contents") ? Pathname.pwd : Pathname("Wingbar.app")
    # only Contents: Homebrew leaves a .brew_home here, which would break the signature
    (prefix/"Wingbar.app").install app/"Contents"
    bin.install_symlink prefix/"Wingbar.app/Contents/MacOS/wingbar"
  end

  service do
    run opt_prefix/"Wingbar.app/Contents/MacOS/wingbar"
    keep_alive successful_exit: false
    process_type :interactive
    error_log_path "/tmp/wingbar.log"
  end

  def caveats
    <<~EOS
      Start wingbar now and at login:
        brew services start wingbar

      macOS asks once for Accessibility permission (to read the focused
      window's title). After an upgrade you may need to allow it again.

      Coming from Übersicht + simple-bar? Quit Übersicht and remove it from
      your login items; wingbar imports ~/.simplebarrc on first start.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wingbar --version")
  end
end
