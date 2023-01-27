TEMPLATE_FILE = src/cloudformation-template.yml
STACK_NAME = account-commons
BUCKET = cfn-build-objects
PREFIX = account-commons
PROFILE = tohi.work-admin

package:
	mkdir -p build
	aws cloudformation package \
		--template-file $(TEMPLATE_FILE) \
		--s3-bucket $(BUCKET) \
		--s3-prefix $(PREFIX) \
		--output-template-file build/cloudformation-template.yml \
		--region ap-northeast-1 --profile $(PROFILE)

deploy:
	aws cloudformation deploy \
		--template-file ./build/cloudformation-template.yml \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
		--region ap-northeast-1 \
		--profile $(PROFILE)

all: package deploy

confirm:
	@read -p "Delete $(STACK_NAME) ?[y/N]: " ans; \
        if [ "$$ans" != y ]; then \
                exit 1; \
        fi

delete: confirm
	aws cloudformation delete-stack --stack-name $(STACK_NAME) --region ap-northeast-1 --profile $(PROFILE)
