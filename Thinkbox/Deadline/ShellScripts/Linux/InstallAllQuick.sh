#!/bin/sh

pushd /tmp

curl -L http://www.thinkboxsoftware.com/deadline-downloads/deadline-release-5147014-april-17-2012/Deadline_Linux_Installers_x86_64_5_1_47014.tar | tar x

DeadlineRepos*	&& rm DeadlineRepos*
DeadlineClient*	&& rm DeadlineClient*	

popd
