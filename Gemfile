# Gemfile
source "https://rubygems.org"

# Jekyll: keep a current 4.x (Actions lets you use any version)
gem "jekyll", "~> 4.3"

# Theme: use the released minima unless you specifically need HEAD
gem "minima", "~> 2.5"
# If you really need the GitHub version, keep this instead of the line above:
# gem "minima", git: "https://github.com/jekyll/minima"

group :jekyll_plugins do
  gem "jekyll-feed"          # keep your feed
  gem "jekyll_picture_tag"   # responsive images (libvips-based)
  gem "jekyll-responsive-image"
end

# Local dev convenience on Ruby 3.x for `jekyll serve`
group :development do
  gem "webrick", "~> 1.8"
end

