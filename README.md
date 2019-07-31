# Magento 2 Scripts

The scripts in this repo exist to make handling our current Magento 2.2.X build server code build creation process and our staging/production deployment of those built assets. I'm fully aware that there are many other better industry standard ways to do this but we lack a position at my company who is good with DevOps so this is currently how we are making our lives just a little bit easier.

Note: Use these scripts at your own risk. I recommend you fully understand what the scripts are doing and that they will work for you and your environment. I also highly recommend testing them before using them in production. I'm not responsible for any damages you may have by you using this script. These scripts work well for our build & deployment process but they may not work for you. Please use caution.

# Build Script - magento-build.sh

This script has the following work flow:

- Git Fetch (Prompts for git credentials & handles messages with a (y/n) prompt displaying any resulting messages to the screen before allowing you to continue.)
- Git Checkout (Prompts for the branch name that you would like to perform a build on. Handles reported messages by displaying to the screen and prompting with (y/n) prompt to continue with build.)
- Composer Install
- Resets .htaccess to what is in git
- Resets pub/.htaccess to what is in git
- Runs Composer Install in update folder
- Runs Magento Static DI Compile command with screen visable output
- Runs Magento Static Content Deploy with screen visable output
- (WeltPixel Pearl Theme Only) We use WeltPixel theme so if you pass in "weltpixel" as a variable to the script it will run WeltPixel's CSS Generate
- Git Add All is run to add all built assets to staged changes
- Git Commit is run to commit built assets back to the branch. This will prompt for a commit message.
- Git Push (Pushes changes out to the remote for deployment. Handles any messages by displaying the git message.)

## Usage

First you must create a branch off of your master branch of your production ready code. We use the branch naming convention release/x.x.x and create release version numbers with tracked changes so we can easily rollback if there is a problem.

Once you have your build release branch created these branches will effectively be dead end build artifact branches so they should be treated as such. On your build server you can begin the build process and run this script by simply executing the script. You will want to run the script as the user that runs your web server.

# Deployment Script - magento-deploy.sh

This script has the following work flow:

- Git Fetch (Prompts for git credentials & handles messages with a (y/n) prompt displaying any resulting messages to the screen before allowing you to continue.)
- Enable Magento Maintenance Mode
- Git Checkout (Prompts for the branch name that you would like to perform a deployment on. Handles reported messages by displaying to the screen and prompting with (y/n) prompt to continue with build.)
- Magento Setup Upgrade
- Git Reset (Resets all code changes from the built release. Not sure why Magento's Setup Upgrade script makes a bunch of code changes but it breaks the build)
- Magento Cache Flush
- Magento Disable Maintenance Mode

## Usage

First you must already have a fully built code artifact branch for the deployment to run smoothly. See Build Script above for more details.

On your deployment server you can begin the deployment process and run this script by simply executing the script. You will want to run the script as the user that runs your web server.