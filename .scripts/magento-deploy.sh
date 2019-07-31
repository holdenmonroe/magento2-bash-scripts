set -e

source .scripts/utils/functions.sh
source .scripts/utils/colors.sh

# Handle git fetch and result
handleGitFetch
handleGitFetchResult

# Enable maintenance mode
handleEnableMaintenance

# Handle git checkout and result
handleGitCheckout
handleGitCheckoutResult

# Run setup:upgrade, reset git back to remote master, flush cache, disable maintenance mode
runSetupUpgrade
handleGitReset
handleCacheFlush
handleDisableMaintenance

echo -e "{$GREEN}Deployment Complete. Don't forget to flush CloudFront Cache! :)${NC}"