all:
	find | fgrep -v '/.' | entr -r bash -c "docker build -f Dockerfile -t clin . && docker ps -q | xargs docker kill; bash run.sh clin"
