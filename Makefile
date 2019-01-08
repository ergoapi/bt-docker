pull:
	git pull
build: pull
	docker build  --no-cache -t spanda/bt .