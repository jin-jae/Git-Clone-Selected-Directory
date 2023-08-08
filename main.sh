#!/bin/bash

# made by JINJAE


# welcome message
for var in {1..100}
do echo -n "-"; done; echo ""

echo "Clone git repository's special directory only"; echo ""
echo "version 1.1"

for var in {1..100}
do echo -n "-"; done
echo ""


# directory 입력 받기
read -p "Enter git repository URL >> " GIT_DIRECTORY
DIR_ARRAY=(`echo $GIT_DIRECTORY | tr '\/' ' '`)
DIR_ARRAY_LEN=${#DIR_ARRAY[@]}
# echo "(debug) DIR_ARRAY: ${DIR_ARRAY[@]}"
# echo "(debug) DIR_ARRAY_LEN: $DIR_ARRAY_LEN"
echo ""


# base url (Repository 주소) 얻기
GIT_BASE_URL="${DIR_ARRAY[0]}//${DIR_ARRAY[1]}/${DIR_ARRAY[2]}/${DIR_ARRAY[3]}"
# echo "(debug) GIT_BASE_URL: $GIT_BASE_URL"
echo "Now trying to clone \"$GIT_BASE_URL\"..."
echo ""


# clone 받을 목적지 설정
read -p "Choose destination to clone repository (default: $HOME/Code/) >> " CLONE_DIRECTORY
if [ -n "$CLONE_DIRECTORY" ]; then
    CLONE_DIRECTORY="$CLONE_DIRECTORY"
else
    CLONE_DIRECTORY="$HOME/Code/"
fi
# echo "(debug) CLONE_DIRECTORY: $CLONE_DIRECTORY"
echo "Repository will be cloned to: $CLONE_DIRECTORY"
echo ""


# clone 작업 수행할 subshell
(
    echo "Now moving to git directory..."
    cd $CLONE_DIRECTORY
    git clone -n --depth=1 --filter=tree:0 $GIT_BASE_URL
    echo ""

    cd ${DIR_ARRAY[3]}

    # 기본 브랜치 체크
    BASE_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
    # echo "(debug) BASE_BRANCH: $BASE_BRANCH"

    read -p "Clone from \"$BASE_BRANCH\" branch. If correct, press Enter. If not, enter branch name and press Enter. >> " BRANCH_FLAG

    TO_BE_ADDED_ROUTE=""
    if [ -z "$BRANCH_FLAG" ]; then
        BASE_BRANCH_CHECK=(`echo $BASE_BRANCH | tr '\/' ' '`)
        CHECK_BRANCH_LEN=${#BASE_BRANCH_CHECK[@]}

        let "I = 5 + CHECK_BRANCH_LEN"
        for ((var = I; var < DIR_ARRAY_LEN; var++))
        do
            TO_BE_ADDED_ROUTE+="${DIR_ARRAY[$var]}/"
        done

        echo "(debug) TO_BE_ADDED_ROUTE: $TO_BE_ADDED_ROUTE"
        echo "$TO_BE_ADDED_ROUTE" > .git/info/sparse-checkout

        git sparse-checkout set --no-cone $TO_BE_ADDED_ROUTE

        # pull
        git checkout
    else
        # 일치하지 않는 경우의 처리
        echo "Recreating repository (to check all branches)..."
        cd $CLONE_DIRECTORY
        rm -rf ${DIR_ARRAY[3]}

        git init ${DIR_ARRAY[3]}
        cd ${DIR_ARRAY[3]}

        git remote add origin $GIT_BASE_URL

        # sparse checkout 가능하도록 설정
        git config core.sparsecheckout true

        BRANCH_FLAG_CHECK=(`echo $BRANCH_FLAG | tr '\/' ' '`)
        CHECK_BRANCH_FLAG_LEN=${#BRANCH_FLAG_CHECK[@]}

        let "I = 5 + CHECK_BRANCH_FLAG_LEN"
        for ((var = I; var < DIR_ARRAY_LEN; var++))
        do
            TO_BE_ADDED_ROUTE+="${DIR_ARRAY[$var]}/"
        done

        echo "(debug) TO_BE_ADDED_ROUTE: $TO_BE_ADDED_ROUTE"

        cat /dev/null > .git/info/sparse-checkout
        echo "$TO_BE_ADDED_ROUTE" > .git/info/sparse-checkout

        # git pull
        git pull origin $BRANCH_FLAG
    fi
)

# closing message
echo ""
echo "Clone done! Enjoy"
for var in {1..100}
do echo -n "-"; done
echo ""
