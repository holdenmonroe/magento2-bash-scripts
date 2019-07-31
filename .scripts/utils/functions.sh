function handleGitFetchResult() {
	cat git-fetch-output.log
	rm -f git-fetch-output.log

	echo -e "\n${YELLOW}Git Fetch output the above message. Would you like to continue? (y/n):${NC}"
	read fetchcontinue
	if [ $fetchcontinue == "y" ];
	then
		echo -e "\n${GREEN}OK - Hold on tight, here we go!${NC}"
	else
		echo -e "\n${YELLOW}Note: You'll need to manually intervene to solve the issue and either manually do our build process or attempt to run the script again after fixing any issues.${NC}"
		exit 1
	fi
}

function handleGitCheckoutResult() {
	cat git-checkout-output.log
	rm -f git-checkout-output.log

	echo -e "\n${YELLOW}Git Checkout output the above message. Would you like to continue? (y/n):${NC}"
	read checkoutcontinue
	if [ $checkoutcontinue == "y" ];
	then
		echo -e "\n${GREEN}OK - Hold on tight, here we go!${NC}"
	else
		echo -e "\n${YELLOW}Note: You'll need to manually intervene to solve the issue and either manually do our build process or attempt to run the script again after fixing any issues.${NC}"
		exit 1
	fi
}

function handleGitPushResult() {
	cat git-push-output.log
	rm -f git-push-output.log

	echo -e "\n${YELLOW}Git Push output the above message. If something went wrong you will need to manually git push after fixing the problem.${NC}"
}

function handleGitCheckout() {
	#This function handles running git checkout based on a user input branch name
	echo -e "${YELLOW}Enter the branch name you would like to checkout:${NC}"
	read branch
	echo -e Checking out branch: $branch
	git checkout -f $branch >& git-checkout-output.log
}

function handleEnableMaintenance() {
	#This function handles enabling the magento maintenance mode
	echo -e "Placing the site into maintenance mode..."
	php bin/magento maintenance:enable
	echo -e "The site is now in maintenance mode."
}

function handleDisableMaintenance() {
	#This function handles disabling the magento maintenance mode
	php bin/magento maintenance:disable
	echo -e "The site is no longer in maintenance mode."
}

function handleGitFetch() {
	#This function runs git fetch and reports errors to git-fetch-output.log
	echo -e "${YELLOW}Enter your git credentials to fetch:${NC}"
	git fetch >& git-fetch-output.log
}

function runSetupUpgrade() {
	#This function handles running magento setup upgrade
	echo -e "Running magento setup upgrade script..."
	php bin/magento setup:upgrade
	echo -e "${GREEN}Setup upgrade finished${NC}"
}

function handleGitReset() {
	#This function handles running git reset after setup upgrade has run
	echo -e Resetting git branch: $branch
	git reset --hard origin/$branch
}

function handleGitAddAll() {
    echo -e "Staging all changes..."
    git add .
}

function handleGitCommitBuild() {
    echo -e "Committing build to branch: $branch"
    git commit -m "Built release code for $branch"
}

function handleGitPushBuild() {
    echo -e "Pushing committed build to branch: $branch"
    echo -e "\n${YELLOW}Enter your git credentials to push:${NC}"
    git push >& git-push-output.log
}

function handleCacheFlush() {
	#This function handles flushing the magento cache
	echo -e "Flushing the magento cache..."
	php bin/magento c:f
	echo -e "${GREEN}Magento cache has been flushed${NC}"
}

function runComposerInstall() {
    /usr/local/bin/composer install
}

function runSetupDiCompile() {
    php bin/magento setup:di:compile
}

function runStaticContentDeploy() {
    php bin/magento setup:static-content:deploy
}

function runWeltPixelCssGenerateAllStoreViews() {
    php bin/magento weltpixel:css:generate --store=default
    php bin/magento weltpixel:css:generate --store=tranquility_store_view
}

function runWeltPixelCssGenerate() {
	echo -e "${YELLOW}Enter the store view code you would like to run WeltPixel CSS Generate on:${NC}"
	read storecode
	echo -e Running WeltPixel Css Generate on: $storecode
    php bin/magento weltpixel:css:generate --store=$storecode

	echo -e "\n${YELLOW}Do you have another WeltPixel store view you would like to generate css for (MultiStore) (y/n):${NC}"
	read anotherweltpixeltheme
	if [ $anotherweltpixeltheme == "y" ];
	then
		runWeltPixelCssGenerate
	fi
}