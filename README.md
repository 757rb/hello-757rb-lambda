
# Using Ruby with AWS Lambda & SAM

![Ruby AWS SAM & Lambda](https://user-images.githubusercontent.com/2381/51087409-f0ed8100-1720-11e9-87be-c493920bdca0.jpg)

A demo project build by [757rb](https://757rb.org) to explore the latest AWS SAM tool with Ruby & Lambda. High level goals.

* Strap script conventions for bootstrap, setup, deploy, test, and more.
* Solid directory setup to kickstart your next project.
* Leverage Minitest & Capybara for unit & system tests.
* Demonstrate AWS resource usage like DynamoDB.


## Setup

Make sure to install the following prerequisites before proceeding.

* Homebrew - https://brew.sh
* Rbenv - https://github.com/rbenv/rbenv
* Ruby Build - https://github.com/rbenv/ruby-build
* Docker - https://docs.docker.com/docker-for-mac/install/
* AWS CLI - https://aws.amazon.com/cli/
  - Requires Python
  - Ensure you setup your root AWS credentials too.

Setup scripts follow the [Strap](https://github.com/MikeMcQuaid/strap) convention. The bootstrap will install [AWS SAM CLI](https://aws.amazon.com/serverless/sam/) via Homebrew and also sets the local Ruby version to 2.5.3 via `rbenv` & `ruby-build`.

Finally, running bootstrap will make a S3 bucket in your AWS account to host your SAM/CloudFormation template. The default name will be `$(whoami)-cloudformation.757rb.org` or you can override this by exporting the `BUCKET_NAME` environment variable.

```shell
./bin/bootstrap
./bin/setup
```

From here you can run `bin/server` or `bin/test` as needed. Other Strap bin files include the following. Please examine these to see how the use AWS SAM for each task.

* `./bin/server` - Starts SAM local development. Uses `sam local start-api`.
* `./bin/test` - Runs all the tests.
* `./bin/build` - Prepares your Lambda for deploying in the `.aws-sam` directory. Uses `sam build`.
* `./bin/update` - Resets all vendored gems and re bundles.
* `./bin/info` - Shows the Function's CloudFormation Outputs. Uses `aws cloudformation describe-stacks`.


## Notes

Brief presentation notes & how this project progressed.

#### A Brief Intro to SAM

* Avoid using the older [Serverless](https://serverless.com) toolkit. Abstraction of [CloudFormation](https://aws.amazon.com/cloudformation/) and not needed when focusing on AWS Lambda.
* The [AWS SAM](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md) spec is a superset of CloudFormation. Use this reference when learning.
* The [AWS SAM CLI](https://github.com/awslabs/aws-sam-cli) is a command line tool for manager AWS Lambda for both local development and deployment to production.

Some helpful links about AWS SAM CLI.

* [SAM How To](https://github.com/awslabs/serverless-application-model/blob/master/HOWTO.md)
* [Usage](https://github.com/awslabs/aws-sam-cli/blob/develop/docs/usage.md)
* [Advanced Usage](https://github.com/awslabs/aws-sam-cli/blob/develop/docs/advanced_usage.md)

#### Created New Ruby App

Commands I used to create the project.

```shell
sam init --runtime ruby2.5 --name hello-757rb-lambda
cd hello-757rb-lambda
git init
git commit -a -m "Initial Project"
```

Then to use it.

```shell
rbenv local 2.5.3
bundle install
sam local start-api
open "http://127.0.0.1:3000/hello"
```

And got this error.

```
"errorMessage": "cannot load such file -- httparty"
```

Oh... the project runs in Docker from that hello world directory. SUCCESS!

```shell
bundle install --path app/vendor/bundle
sam local start-api
open "http://127.0.0.1:3000/hello"
```

#### First Cleanup

Removed `.gitignore` and replaced with this to avoid checking in vendored gems into source control. Also ignorning the `.aws-sam` directory which holds the build.

```
app/vendor/*
.bundle/*
.aws-sam
```

Also cleaned up both the `template.yaml` and `app.rb` file to show some debug info.

#### Bootstrapping & Deploy

* Creating Strap conventions in `./bin` directory.
* bin/bootstrap and friends (AWS CLI, Rbenv, Bundler, S3 Bucket)

⚠️ Learned that if `.aws-sam/build` is present, then `sam local` will use that directory. This will make you go crazy trying to figure out why changes to your code do not show up when hitting refresh in the browser. Added a `rm -rf` to that directory in `bin/server` to help avoid this.

⚠️ The `sam build` also leaves a root `vendor` directory for some reason, likely due to a copy. Used `bin/build` to remove this too.

#### Better App/Test Directories & Files

There is a bit of a tug of war going on here when needing to use Bundler for both build packaging and local development. This simple command illustrates the core issue and how `.bundle/config` will change when running `sam build`.

```shell
$ sam build
$ cat .bundle/config
BUNDLE_PATH: "vendor/bundle"
BUNDLE_FROZEN: "true"
BUNDLE_WITHOUT: "development:test"
```

Miscellaneous changes to support that issue and other work:

* Added some top level goals of the project.
* New `test` directory structure.
* Add cleanup to `bin/build` script and re-setup local dev bundle.
* Added `--no-deployment` to `bin/setup` so updates to Gemfile work well.
* Leveraged Bundler in `test_helper
* Move POROs to app/src and keep `app.rb` slim.
* Created an example unit spec/test.

#### Native Extensions

The goal of these changes is to introduce basic gems with native C extensions into the development, test, and deploy process. The high level summary of changes to meet this objective include:

* Added Nokogiri gem which builds against libxml.
* Get some XML from a service ([PLOS](https://www.plos.org)) via HTTP.
* Leverage Nokogiri via ActiveSupport to parse PLOS results.
* Made sure to use Bundler 1.17.3 in project. Details below.
* Used `sam build --use-container` in build script.
* Ensure Docker development local tests share platform native gems.
* Copy Gemfile files to `app` directory when building. Git ignore these.

Other smaller changes include:

* Add some debug HTML to the page to show PLO requests.
* Added Guard for rapid test feedback.
* Increase memory size to 256 megabytes.
* Increase lambda timeout to 10 seconds.

About Bundler 2 and how we juggled the `.aws-build` directory to get both local tests and the development server to work together. First, errors when building can often return a very un-helpful message.

```
{"jsonrpc": "2.0", "id": 1, "error": {"code": 400, "message": "PythonPipBuilder:ResolveDependencies - Could not satisfy the requirement: requests==2.20.0"}}
```

To over come this, we can use the following command to debug the errors in the build process. This is how I found that using Bundler v2 locally will cause errors for the build Docker container.

```shell
docker run -v $(pwd):/var/task \
  lambci/lambda:build-ruby2.5 \
  bash -c "bundle install --without development test --verbose"
```

#### DynamoDB

Allow Lambda to own a DynamoDB instance and use it for storing results of API queries to PLOS. Details to support this change include:

* Change API Gateway to use `/{resource+}` to slurp all path params.
* Pass the `query` query parameter down to the `PlosSearch` object.

