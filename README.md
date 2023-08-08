# Git 에서 특정 레포지토리 파일만 받아오기

## 사용방법
1. 해당 레포지토리를 clone 합니다.  
```git clone git@github.com:jin-jae/Git-Clone-Selected-Directory.git```

2. sh 파일의 권한을 변경합니다.  
```chmod 775 main.sh```

3. 파일을 실행합니다.  
```./main.sh```

4. 입력해야 할 내용을 입력합니다. 순서대로 다음과 같습니다.
    - Github의 해당 레포지토리 폴더 주소 (https://github.com/ 형태로 시작하는 URL)
    - 레포지토리를 클론할 local 경로 주소
    - 클론할 branch 확인 (기본 branch가 아닌 경우 branch 이름 입력)

## 연구중인 내용
- 현재 지식상 한계로 기본 브랜치의 파일이 아닌 다른 브랜치의 파일을 받아야 하는 경우, 해당 브랜치의 이름을 입력해야 합니다. 추후 입력이 없더라도 가능한 방안을 찾아보고 구현할 예정입니다.
- git sparse-checkout 기능의 한계 (혹은 지식의 한계)로, 기본 브랜치가 아닌 경로의 파일들을 받아오고자 하는 경우 모든 파일을 다 clone 하는 작업을 거쳐 트래픽의 절약 효과가 없습니다. 찾아보고 개선 방법이 있다면 업데이트할 예정입니다.

## 프로젝트 소개
특정 레포지토리 내 방대한 폴더 중 일부 폴더만 받아오고 싶다는 요청사항을 해결해보기 위해 bash script를 이용하여 해당 작업을 수행할 수 있는 bash Shell Script를 제작하였습니다.

## 업데이트 내역
- v1.0: 최초 배포
- v1.1: 기본 브랜치인 경우 받아오지 못하던 문제 해결
