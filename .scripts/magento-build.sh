set -e

source .scripts/utils/functions.sh
source .scripts/utils/colors.sh

# Git Fetch Handle
handleGitFetch
handleGitFetchResult

# Git Checkout Handle
handleGitCheckout
handleGitCheckoutResult

# Run composer install in root
runComposerInstall

# Reset .htaccess and pub/.htaccess after composer install
git checkout .htaccess
git checkout pub/.htaccess

# Run composer install in update directory then return to magento root
cd update
runComposerInstall
cd ..

# Run setup:di:compile
runSetupDiCompile

# Run setup:static-content:deploy
runStaticContentDeploy

# Grab execute variable
wp=$1

# Only run weltpixel css generate if "weltpixel" is passed as a parameter
if [[ -n "$wp" ]]; then
    if [ $wp == "weltpixel" ]; then
        runWeltPixelCssGenerateAllStoreViews
    fi
fi

# Git Add Handle
handleGitAddAll

# Git Commit Handle
handleGitCommitBuild

# Git Push Handle
handleGitPushBuild
handleGitPushResult

echo -e "${GREEN}Build Complete. :)${NC}"