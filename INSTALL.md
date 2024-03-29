# Toolchain for site building

*Tested on WSL Ubuntu 18.04, adaptation likely needed for other platforms*

## Dependencies

### Ruby and Gems

Make sure that GEM_HOME is defined locally, and the path includes $GEM_HOME/bin

    sudo apt install ruby-dev zlib-dev
    gem install bundler
    
> To be compatible with the github version, use (not necessary since we host now the site):
> ```
> gem install jekyll -v 3.8.7
> ```
> https://pages.github.com/versions/

### On Mac M1

The version of ruby shipped with OS-X is too old and the associated ffi version crashes.

--> Install ruby > 3 with HomeBrew
+ bundle add webrick

Inspired from: https://www.shouvikbasak.net/website/jekyll-on-macos-apple-m1-solved/


### jekyll-responsive-image

    sudo apt install imagemagick libmagickcore-dev pkg-config
    
## Jekyll toochain

    cd svplume
    bundler install

### Serve locally

    bundler exec jekyll serve

### Build for deployment

    bundler exec jekyll build
    rsync --archive --delete _site/ hws:/var/www/plume --verbose
