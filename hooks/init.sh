#! /bin/bash

wd=$(dirname $(readlink -f $0))
ln -s $wd/pre-commit $wd/../.git/hooks/
ln -s $wd/post-checkout $wd/../.git/hooks/
ln -s $wd/post-commit $wd/../.git/hooks/

