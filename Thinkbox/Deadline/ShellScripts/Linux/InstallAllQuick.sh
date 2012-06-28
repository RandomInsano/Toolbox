#!/bin/sh

pushd /tmp

curl -L http://www.thinkboxsoftware.com/deadline-downloads/deadline-release-5247700-june-27-2012/Deadline_Linux_Installers_`uname -i`_5_2_47700.tar | tar x

DeadlineRepos*	&& rm DeadlineRepos*
DeadlineClient*	&& rm DeadlineClient*	

popd
