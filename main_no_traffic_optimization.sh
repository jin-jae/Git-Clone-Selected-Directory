#!/bin/bash

# made by JINJAE

# init program
for var in {1..100}
do
    echo -n "-"
done
echo ""

echo "Clone git repository's special directory"
echo ""
echo "version 1.0"

for var in {1..100}
do
    echo -n "-"
done
echo ""

# directory 입력 받기
read -p "Enter git repository URL >> " GIT_DIRECTORY
DIR_ARRAY=(`echo $GIT_DIRECTORY | tr '\/' ' '`)
echo "debug array: ${DIR_ARRAY[@]}"
DIR_ARRAY_LEN=${#DIR_ARRAY[@]}

echo -n "Now trying to clone \""
GIT_BASE_URL="${DIR_ARRAY[0]}//${DIR_ARRAY[1]}/${DIR_ARRAY[2]}/${DIR_ARRAY[3]}"
echo -n "$GIT_BASE_URL"
echo "\"..."
echo ""



# clone 받을 목적지 설정
read -p "Choose destination to clone repository (default: $HOME/Code/) >> " CLONE_DIRECTORY
if [ -n "$CLONE_DIRECTORY" ]; then
    CLONE_DIRECTORY="$CLONE_DIRECTORY"
    echo "Repository will be cloned to: $CLONE_DIRECTORY"
else
    CLONE_DIRECTORY="$HOME/Code/"
    echo "Repository will be cloned to: $CLONE_DIRECTORY"
fi
# echo "debug CLONE_DIRECTORY: $CLONE_DIRECTORY"

# clone 작업
(
    echo "Now moving to git directory"
    cd $CLONE_DIRECTORY
    git init ${DIR_ARRAY[3]}
    cd ${DIR_ARRAY[3]}

    # sparse checkout 가능하도록 설정
    git config core.sparsecheckout true

    # add remote
    git remote add origin $GIT_BASE_URL

    BASE_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
    echo "debug BASE_BRANCH: $BASE_BRANCH"

    BASE_BRANCH_CHECK=(`echo $BASE_BRANCH | tr '\/' ' '`)
    CHECK_BRANCH_LEN=${#BASE_BRANCH_CHECK[@]}

    TO_BE_ADDED_ROUTE=""
    let "I = 5 + CHECK_BRANCH_LEN"
    for ((var = I; var < DIR_ARRAY_LEN; var++))
    do
        TO_BE_ADDED_ROUTE+="${DIR_ARRAY[$var]}/"
    done
    echo "debug TO_BE_ADDED_ROUTE: $TO_BE_ADDED_ROUTE"

    git sparse-checkout set "$TO_BE_ADDED_ROUTE"

    # git pull
    git pull origin $BASE_BRANCH
)

