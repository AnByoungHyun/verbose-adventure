# Ubuntu 20.04 에 Docker 설치

## 기본 패키지 설치
``` bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
```

## Docker에서 제공하는 패키지 저장소 등록

### 패키지 저장소를 사용하기 위한 GPG 인증키 다운로드
``` bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

### 패키지 저장소 경로 GPG 키와 함께 등록
``` bash
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### 등록한 패키지 저장소 적용
``` bash
sudo apt-get update
```

## Docker 설치
``` bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 설치 후 확인
``` bash
docker -v
# Docker version 24.0.2, build cb74dfc
```