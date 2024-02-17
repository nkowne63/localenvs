export
IMAGE := wsl2-distro
USER_NAME := wsl2-user
PASSWD := password
TZ := Asia/Tokyo
INSTALL_LOCATION := C:\Users\nkowne63\wsl-custom

build_docker:
	docker build \
		-t $(IMAGE) . \
		--build-arg TZ=$(TZ) \
		--build-arg USER_NAME=$(USER_NAME) \
		--build-arg PASSWD=$(PASSWD)
	$(eval CID := $(shell docker run --rm -t -d $(IMAGE)))
	docker export $(CID) > output/$(IMAGE).tar
	docker stop $(CID)

import_wsl:
	wsl.exe --import $(IMAGE) $(INSTALL_LOCATION) ./output/$(IMAGE).tar