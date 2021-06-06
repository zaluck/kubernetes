Kubernetes — это система с открытым исходным кодом, которая автоматизирует 
развертывание и масштабирование упакованных в контейнер приложений, а также 
управление ими. Если вы запускаете много контейнеров или хотите управлять ими 
автоматически, эта система вам понадобится

Kubernetes — это одновременно крупный открытый проект и экосистема с большим 
количеством кода и богатой функциональностью. Автор Kubernetes — компания 
Google, но со временем этот проект присоединился к организации Cloud Native 
Computing Foundation (CNCF) и стал явным лидером в области контейнерных при-
ложений. Если говорить коротко, это платформа для оркестрации развертывания 
и масштабирования контейнерных приложений и управления ими

--------------------------------------
Install and Set Up kubectl on Linux

Установите двоичный файл kubectl с помощью curl в Linux
Загрузите последнюю версию с помощью команды:

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
Примечание:
Чтобы загрузить определенную версию, замените $(curl -L -s https://dl.k8s.io/release/stable.txt)часть команды определенной версией.

Например, чтобы загрузить версию v1.21.0 в Linux, введите:

curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
Проверить двоичный файл (необязательно)

Загрузите файл контрольной суммы kubectl:

curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
Проверьте двоичный файл kubectl по файлу контрольной суммы:

echo "$(<kubectl.sha256) kubectl" | sha256sum --check
Если это действительно так, вывод будет следующим:

kubectl: OK
Если проверка завершилась неудачно, sha256завершается работа с ненулевым статусом и выводится следующий результат:

kubectl: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
Примечание. Загрузите ту же версию двоичного файла и контрольной суммы.
Установить kubectl

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
Примечание:
Если у вас нет root-доступа в целевой системе, вы все равно можете установить kubectl в ~/.local/binкаталог:

mkdir -p ~/.local/bin/kubectl
mv ./kubectl ~/.local/bin/kubectl
# and then add ~/.local/bin/kubectl to $PATH
Протестируйте, чтобы убедиться, что установленная вами версия актуальна:

kubectl version --client
Установить с использованием собственного управления пакетами
Дистрибутивы на основе Debian
Распределения на основе Red Hat
Обновите aptиндекс пакетов и установите пакеты, необходимые для использования aptрепозитория Kubernetes :

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
Загрузите открытый ключ подписи Google Cloud:

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
Добавьте aptрепозиторий Kubernetes :

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
Обновите aptиндекс пакета с новым репозиторием и установите kubectl:

sudo apt-get update
sudo apt-get install -y kubectl
-------------------------------------------
minikube start

Installation
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

alias k='kubectl'
alias mk='/usr/local/bin/minikube'

> mk version
> k version

mk get-k8s-versions
 mk start --kubernetes-version="v1.10.0"
  mk start



