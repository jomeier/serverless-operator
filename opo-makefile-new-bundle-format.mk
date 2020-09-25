
.PHONY: opo-bundle-image
opo-bundle-image:
ifndef VERSION
	@echo VERSION not set
	@exit 1
endif
ifndef DOCKER_REPO_OVERRIDE
	@echo DOCKER_REPO_OVERRIDE not set#
	@exit #1
endif
	docker build -f olm-catalog/serverless-operator/Dockerfile -t ${DOCKER_REPO_OVERRIDE}/openshift-pipelines-operator-midstr-bundle:v${VERSION} olm-catalog/serverless-operator
	docker push ${DOCKER_REPO_OVERRIDE}/openshift-pipelines-operator-midstr-bundle:v${VERSION}

.PHONY: opo-update-index-image
opo-index-image:
ifndef VERSION
	@echo VERSION not set
	@exit 1
endif
ifndef DOCKER_REPO_OVERRIDE
	@echo DOCKER_REPO_OVERRIDE not set
	@exit 1
endif
	# NOTE: tag index image as latest as CatalogSource Resources on clusters will always get the latest updates
	# if we tag the index image with a version, we will have to update the index image reference in CatalogSources on
	# on all cluster using this operator
	opm index add --bundles ${DOCKER_REPO_OVERRIDE}/openshift-pipelines-operator-midstr-bundle:v${VERSION} \
 		--tag ${DOCKER_REPO_OVERRIDE}/openshift-pipelines-operator-midstr-index:latest --container-tool docker
	docker push ${DOCKER_REPO_OVERRIDE}/openshift-pipelines-operator-midstr-index:latest
