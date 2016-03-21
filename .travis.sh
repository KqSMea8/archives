#!/bin/sh

deploy_resea_net() {
    commit_msg="auto deploy: $(git log --format=%B -n1|tr -d '\n')"

    git clone https://github.com/resea/resea.github.io
    reseasdk alldocs --outdir resea.net/docs/master
    cd resea.github.io
    cp -r ../resea.net/* .

    git config user.name "Travis CI"
    git config user.email "travis@resea.net"
    
    git diff --exit-code > /dev/null
    if [ "$?" = "0" ] ; then
        echo "nothing to commit, aborting deployment"
        exit 0
    fi

    git add -A
    git commit -m "$commit_msg"
    git push --quiet "https://${GH_TOKEN}@github.com/resea/resea.github.io" master> /dev/null 2>&1
    if [ "$?" != "0" ] ; then
        echo "failed to git push"
        exit 1
    fi
    echo "deployed"
}

case $TARGET in
SDK)
    cd SDK
    make test 
    ;;
resea.net)
    deploy_resea_net
    ;;
*)
    cd $TARGET
    reseasdk test --all-in-one HAL=posix_host
    ;;
esac
