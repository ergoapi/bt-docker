pull:
	git pull
build: pull
	docker build -t spanda/bt .