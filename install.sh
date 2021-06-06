----Установка и настройка kubectl---

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

kubectl version --client

----Установка Minikube---

Чтобы проверить, поддерживается ли виртуализация в Linux, выполните следующую команду и проверьте, что вывод не пустой:

grep -E --color 'vmx|svm' /proc/cpuinfo

Убедитесь, что у вас установлен kubectl. Вы можете установить kubectl согласно инструкциям в разделе Установка и настройка kubectl.
Если у вас ещё не установлен гипервизор, установите один из них:
• KVM, который также использует QEMU
• VirtualBox
Minikube также поддерживает опцию --vm-driver=none, которая запускает компоненты Kubernetes на хосте, а не на виртуальной машине. Для использования этого драйвера требуется только Docker и Linux, но не гипервизор.
Если вы используете драйвер none в Debian и его производных, используйте пакеты .deb для Docker, а не snap-пакет, который не работает с Minikube. Вы можете скачать .deb-пакеты с сайта Docker.
Внимание: Драйвера виртуальной машины none может привести к проблемам безопасности и потери данных. Перед использованием --vm-driver=none обратитесь к этой документации для получения дополнительной информации.
Minikube также поддерживает vm-driver=podman, похожий на драйвер Docker. Podman, работающий с правами суперпользователя (пользователь root) — это лучший способ гарантировать вашим контейнерам полный доступ ко всем возможностям в системе.
Внимание: Драйвер podman должен запускать контейнеры от имени суперпользователя, поскольку у обычных аккаунтов нет полного доступа ко всем возможностям операционной системы, которые могут понадобиться контейнерам для работы.


-----Установка Minikube с помощью прямой ссылки------
Вы также можете загрузить двоичный файл и использовать его вместо установки пакета:

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
&& chmod +x minikube

Чтобы исполняемый файл Minikube был доступен из любой директории выполните следующие команды:

sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

---------------
Включение виртуализация на Вин10 для виртальной машине через CMD в винде
Ubuntu18.04.5ARM - имя виртуальной машины
VBoxManage modifyvm Ubuntu18.04.5ARM --nested-hw-virt on
У меня не сработало
--------------
Проверка установки
Чтобы убедиться в том, что гипервизор и Minikube были установлены корректно, выполните следующую команду, которая запускает локальный кластер Kubernetes:
minikube start
Запускать команду нужно под пользователем, под root исключено.
Заметка: Для использования опции --vm-driver с командой
 minikube start 
 укажите имя установленного вами гипервизора в нижнем регистре в заполнителе <driver_name> команды ниже.
  Полный список значений для опции --vm-driver перечислен в разделе по указанию драйвера виртуальной машины.

minikube start --vm-driver=<driver_name>
minikube start --vm-driver=virtualbox
--------------------------------
удаление кластера
minikube delete
-------------------
докер должен быть установлен
sudo systemctl status docker
sudo usermod -aG docker $(whoami)
sudo usermod -aG docker $USER && newgrp docker

Драйвер Docker позволяет установить Kubernetes в существующую установку Docker.
В Linux для этого не требуется включать виртуализацию.
Требования
Установите Docker 18.09 или выше
Система amd64 или arm64.
Применение
Запустите кластер с помощью драйвера докера:

minikube start --driver=docker

Чтобы сделать докер драйвером по умолчанию:

minikube config set driver docker

Особые возможности
Кроссплатформенность (linux, macOS, Windows)
При работе в Linux гипервизор не требуется
Экспериментальная поддержка WSL2 в Windows 10
------------------------------
kubectl version
minikube version
-------------

minikube get-k8s-versions - получить версию Утилита Minikube поддерживает разные версии Kubernetes
------------
alias k='kubectl' \
alias mk='/usr/local/bin/minikube'
---------------
Запустить определенную версию Kubernetes
 mk start --kubernetes-version="v1.10.0"  
 mk status
-----------------------------
Проверка кластера
Теперь, создав и запустив кластер, заглянем внутрь него.
Для начала подключимся к ВМ по ssh:
> mk ssh
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || ' <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_'__/'`\____)
$ uname -a
Linux minikube 4.9.64 #1 SMP Fri Mar 30 21:27:22 UTC 2018 x86_64 GNU/Linux$

Отлично! Все работает. Странные символы, которые вы видите, — это ASCII-
графика для Minikube. Теперь воспользуемся утилитой kubectl — это настоящий 
швейцарский нож, который пригодится в процессе работы с любыми кластерами 
Kubernetes, в том числе и в режиме federation.
---------------------------------------
Сначала проверим состояние кластера:
> k cluster-info

Главный узел Kubernetes работает по адресу https://192.168.99.101:8443.
KubeDNS находится по адресу https://192.168.99.1010:8443/api/v1/namespaces/kube-system/services/kub e-dns:dns/proxy.
Для дальнейшей отладки и диагностики неисправностей кластера используйте 
команду:
> k  cluster-info dump
Ее вывод может показаться немного пугающим, 
поэтому давайте исследовать наш кластер с помощью более конкретных команд
Введите get nodes, чтобы проверить узлы кластера:
> k get nodes
admuser@ubuntuArm:~$ k get nodes
NAME       STATUS   ROLES                  AGE     VERSION
minikube   Ready    control-plane,master   4m52s   v1.20.2

Итак, у нас имеется один узел с именем minikube. Чтобы получить подробную 
информацию о нем, введите
> k describe node minikube
Вывод получится довольно  объемным, ознакомьтесь с ним самостоятельно.
--------------------------
Выполнение работы
Мы подготовили и запустили прекрасный пустой кластер (ладно, не совсем пустой, 
так как внутри подов в пространстве имен kube-system выполняются сервис DNS и панель управления). 
Пришло время запустить какие-нибудь экземпляры пода. 
Возьмем в качестве примера сервер echo:
> k run echo --image=gcr.io/google_containers/echoserver:1.8 --port=8080 
выывод-  deployment "echo" created

Платформа Kubernetes развернула и запустила под. Обратите внимание на 
префикс echo:
> k get pods
NAME                   READY     STATUS    RESTARTS    AGE
echo-69f7cfb5bb-wqgkh   1/1      Running       0       18s

Для того чтобы превратить под в сервис, доступный извне, введите следующую 
команду:
> k expose deployment echo --type=NodePort
выывод-  service "echo" exposed

Мы выбрали тип сервиса NodePort, чтобы он был доступен локально на заданном 
порте (имейте в виду, что порт 8080 уже занят подом). Порты назначаются в кластере. 
Чтобы обратиться к сервису, нужны его IP-адрес и порт:
> mk ip
192.168.99.101

> k get service echo --output='jsonpath="{.spec.ports[0].nodePort}"'
30388

При обращении сервис echo возвращает множество информации:
> curl http://192.168.99.101:30388/hi

Поздравляю! Вы только что создали локальный кластер Kubernetes и развернули в нем сервис.
-----------------------------------------------------
Исследование кластера с помощью панели управления
Kubernetes имеет очень приятный веб-интерфейс, который, естественно, разво-
рачивается в виде сервиса внутри пода. Панель управления хорошо продумана 
и предоставляет общие сведения о вашем кластере, а также подробности об от-
дельных ресурсах. С ее помощью можно просматривать журнал, редактировать 
файлы ресурсов и многое другое. Это идеальный инструмент для ручной про-
верки кластера. Чтобы запустить панель управления, введите команду: 
> mk dashboard

Minikube откроет окно браузера с интерфейсом панели управления
Вот как выглядит обзор workload-объектов: 
- Deployments (Развертывание), 
- Replica  Sets (Наборы реплик),
- Replication Controllers (Контроллеры репликации)
- Pods (Поды)
---------------------------------------------------------
Удалить под
> kubectl delete -n default pod echo
-----------------------------------
Создание Deployment
Под Kubernetes - это группа из одного или более контейнеров, связанных друг с другом с целью адмистрирования и организации сети.
В данном руководстве под включает в себя один контейнер. Deployment в Kubernetes проверяет здоровье пода и перезагружает контейнер пода 
в случае его отказа. Deployment-ы являются рекоммендуемым способом организации создания и масштабирования подов.

Используйте команду kubectl create для создание деплоймента для управления подом. 
Под запускает контейнер на основе предоставленного Docker образа.

kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
Посмотреть информацию о Deployment:

> kubectl get deployments
Вывод:
NAME         DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello-node   1         1         1            1           1m

Посмотреть информацию о поде:
> kubectl get pods

Вывод:
NAME                          READY     STATUS    RESTARTS   AGE
hello-node-5f76cf6ccf-br9b5   1/1       Running   0          1m

Посмотреть события кластера:
> kubectl get events

Посмотреть kubectl конфигурацию:
> kubectl config view
-----------------------------------
Создание сервиса
По-умолчанию под доступен только при обращении по его внутреннему IP адресу внутри кластера Kubernetes.
Чтобы сделать контейнер hello-node доступным вне виртульной сети Kubernetes, необходимо представить под как сервис Kubernetes.

Сделать под доступным для публичной сети Интернет можно с помощью команды kubectl expose:

> kubectl expose deployment hello-node --type=LoadBalancer --port=8080
Флаг --type=LoadBalancer показывает, что сервис должен быть виден вне кластера.

Посмотреть только что созданный сервис:
> kubectl get services

Вывод:
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
hello-node   LoadBalancer   10.108.144.78   <pending>     8080:30369/TCP   21s
kubernetes   ClusterIP      10.96.0.1       <none>        443/TCP          23m

Для облачных провайдеров, поддерживающих балансировщики нагрузки, для доступа к сервису будет предоставлен внешний IP адрес.
 В Minikube тип LoadBalancer делает сервис доступным при обращении с помощью команды minikube service.

Выполните следующую команду:
> minikube service hello-node
--------------------------------------
Добавление дополнений
В Minikube есть набор встроенных дополнений, которые могут быть включены, выключены и открыты в локальном окружении Kubernetes.

Отобразить текущие поддерживаемые дополнения:
> minikube addons list
Вывод:
addon-manager: enabled
dashboard: enabled
default-storageclass: enabled
efk: disabled
freshpod: disabled
gvisor: disabled
heapster: disabled
helm-tiller: disabled
ingress: disabled
ingress-dns: disabled
logviewer: disabled
metrics-server: disabled
nvidia-driver-installer: disabled
nvidia-gpu-device-plugin: disabled
registry: disabled
registry-creds: disabled
storage-provisioner: enabled
storage-provisioner-gluster: disabled
--------------
Включить дополнение, например, metrics-server:
> minikube addons enable metrics-server
Вывод:
metrics-server was successfully enabled

Посмотреть Pod и Service, которые вы только что создали:
> kubectl get pod,svc -n kube-system
Вывод:
NAME                                        READY     STATUS    RESTARTS   AGE
pod/coredns-5644d7b6d9-mh9ll                1/1       Running   0          34m
pod/coredns-5644d7b6d9-pqd2t                1/1       Running   0          34m
pod/metrics-server-67fb648c5                1/1       Running   0          26s
pod/etcd-minikube                           1/1       Running   0          34m
pod/influxdb-grafana-b29w8                  2/2       Running   0          26s
pod/kube-addon-manager-minikube             1/1       Running   0          34m
pod/kube-apiserver-minikube                 1/1       Running   0          34m
pod/kube-controller-manager-minikube        1/1       Running   0          34m
pod/kube-proxy-rnlps                        1/1       Running   0          34m
pod/kube-scheduler-minikube                 1/1       Running   0          34m
pod/storage-provisioner                     1/1       Running   0          34m

NAME                           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
service/metrics-server         ClusterIP   10.96.241.45    <none>        80/TCP              26s
service/kube-dns               ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP       34m
service/monitoring-grafana     NodePort    10.99.24.54     <none>        80:30002/TCP        26s
service/monitoring-influxdb    ClusterIP   10.111.169.94   <none>        8083/TCP,8086/TCP   26s

Отключить metrics-server:
> minikube addons disable metrics-server
Вывод:
metrics-server was successfully disabled
---------------------------------
Освобождение ресурсов
Теперь вы можете освободить ресурсы созданного вами кластера:
> kubectl delete service hello-node
> kubectl delete deployment hello-node
Остановите выполнение виртуальной машины Minikube (опционально):
> minikube stop
Удалите виртуальную машину Minikube (опционально):
> minikube delete
--------------------------------
Создание многоузлового кластера  с помощью kubeadm
--############---
В этом разделе вы познакомитесь с kubeadm — инструментом для создания класте-
ров Kubernetes, который рекомендуется к использованию во всех средах, несмотря 
на то что находится на стадии активной разработки. Являясь частью Kubernetes, 
он неизбежно вбирает в себя лучшие методики. Чтобы сделать его доступным для 
всего кластера, воспользуемся виртуальными машинами.
Подготовка кластера виртуальных машин 
на основе vagrant
Следующий vagrant-файл создаст кластер из четырех ВМ с именами n1, n2, n3 и n4. 
---------------
# -*- mode: ruby -*-
# vi: set ft=ruby :
hosts = {
  "n1" => "192.168.77.10",
  "n2" => "192.168.77.11",
  "n3" => "192.168.77.12",
  "n4" => "192.168.77.13"
}
Vagrant.configure("2") do |config|
  # всегда используем небезопасный ключ Vagrant
  config.ssh.insert_key = false
  # перенаправляем ssh-агент, чтобы получить легкий доступ к разным узлам
  config.ssh.forward_agent = true
  check_guest_additions = false
  functional_vboxsf = false
#   config.vm.box = "bento/ubuntu-16.04"
  config.vm.box = "ubuntu/trusty64"
  
hosts.each do |name, ip|
    config.vm.hostname = name
    config.vm.define name do |machine|
      machine.vm.network :private_network, ip: ip
      machine.vm.provider "virtualbox" do |v|
        v.name = name
      end
    end
  end
end
-----------------------------
Установка необходимого  
программного обеспечения
Я очень люблю задействовать утилиту Ansible для управления конфигурациями, 
поэтому установил ее на ВМ n4 (под управлением Ubuntu 16.04). С этого момента 
n4 становится управляющим устройством — это означает, что мы будем работать 
в среде Linux.
> vagrant ssh n4
Welcome to Ubuntu

vagrant@vagrant:~$ sudo apt-get -y --fix-missing install python-pip sshpass
vagrant@vagrant:~$ sudo pip install ansible
Я использую версию 2.5.0, но самая последняя тоже должна подойти:
vagrant@vagrant:~$ ansible --version
ansible 2.5.0

---------------
Я создал каталог ansible и поместил в него три файла: hosts, vars.yml 
и playbook.yml.
Файл host
host — это служебный файл, благодаря которому каталог ansible знает, на какие 
узлы он должен быть скопирован. Узлы должны быть доступны из управля ющей 
системы по SSH. Далее перечислены три ВМ, на которые будет установлен кластер:
[all]
192.168.77.10 ansible_user=vagrant ansible_ssh_pass=vagrant
192.168.77.11 ansible_user=vagrant ansible_ssh_pass=vagrant
192.168.77.12 ansible_user=vagrant ansible_ssh_pass=vagrant
Файл vars.yml
Файл vars.yml всего лишь хранит список всех пакетов, которые я хочу установить 
на всех узлах. На каждом компьютере, который находится под моим управле-
нием, я предпочитаю иметь vim, htop и tmux. Остальные пакеты требуются для 
Kubernetes:
---
PACKAGES:
  - vim - htop - tmux - docker.io
  - kubelet
  - kubeadm
  - kubectl
  - kubernetes-cni
60  Глава 2  •  Создание кластеров Kubernetes
Файл playbook.yml
Запуск файла playbook.yml приводит к установке пакетов на все узлы:
---
- hosts: all
  become: true
  vars_files:
    - vars.yml
  strategy: free
  tasks:
    - name: hack to resolve Problem with MergeList Issue
      shell: 'find /var/lib/apt/lists -maxdepth 1 -type f -exec rm -v {} \;'
    - name: update apt cache directly (apt module not reliable)
      shell: 'apt-get clean && apt-get update'
    - name: Preliminary installation
      apt: name=apt-transport-https force=yes
    - name: Add the Google signing key
      apt_key: url=https://packages.cloud.google.com/apt/doc/apt-key.gpg state=present
    - name: Add the k8s APT repo
      apt_repository: repo='deb http://apt.kubernetes.io/ kubernetes-xenial main' state=present
    - name: update apt cache directly (apt module not reliable)
	   shell: 'apt-get update'
    - name: Install packages
      apt: name={{ item }} state=installed force=yes
      with_items: "{{ PACKAGES }}"
Поскольку некоторые пакеты берутся из APT-репозитория Kubernetes, его тоже 
следует указать (вместе с цифровым ключом Google).
Подключимся к n4:
> vagrant ssh n4
Вам нужно будет зайти на каждый из узлов, задав ssh:
vagrant@vagrant:~$ ssh 192.168.77.10
vagrant@vagrant:~$ ssh 192.168.77.11
vagrant@vagrant:~$ ssh 192.168.77.12
Для того чтобы не выполнять эту процедуру каждый раз, можно добавить файл 
~/.ansible.cfg со следующим содержимым:
[defaults]
host_key_checking = False
Запустите playbook.yml на узле n4 с помощью такой команды:
vagrant@n4:~$ ansible-playbook -i hosts playbook.yml
------------------

Cоздание кластера
----------------------------------
Пришло время создать сам кластер. Инициализируем ведущий узел на первой ВМ, 
затем настроим сеть и добавим остальные ВМ в качестве узлов.
Инициализация ведущего узла. Сделаем n1 (192.168.77.10) ведущим узлом. 
Работая с облаком, основанным на ВМ vagrant, нужно обязательно указать флаг 
--apiserveradvertise-address:
> vagrant ssh n1
vagrant@n1:~$ sudo kubeadm init --apiserver-advertise-address 192.168.77.10

В Kubernetes 1.10.1 это вызовет появление такого сообщения об ошибке:
----------------------------------------------------------------------------
[init] Using Kubernetes version: v1.10.1
[init] Using Authorization modes: [Node RBAC]
[preflight] Running pre-flight checks.
[WARNING FileExisting-crictl]: crictl not found in system path
[preflight] Some fatal errors occurred:
[ERROR Swap]: running with swap on is not supported. Please disable swap
[preflight] If you know what you are doing, you can make a check non-fatal with '--ignore-preflight-errors=...'
----------------------------------------------------------------------------
Дело в том, что по умолчанию не установлены инструменты из пакета cri-tools. 
Здесь мы имеем дело с одним из передовых аспектов Kubernetes. Я создал до-
полнительный раздел в файле playbook2.yml, чтобы установить Go и cri-tools, 
отключить раздел подкачки и исправить сетевые имена виртуальных машин vagrant:
##############################################################################
–--------------------------------------------------------------
Не забудьте повторно запустить этот файл на узле n4, чтобы обновить все ВМ 
в кластере.
Далее приводится часть вывода при успешном запуске Kubernetes:

vagrant@n1:~$ sudo kubeadm init --apiserver-advertise-address 192.168.77.10

[init] Using Kubernetes version: v1.10.1
[init] Using Authorization modes: [Node RBAC]
[certificates] Generated ca certificate and key.
[certificates] Generated apiserver certificate and key.
[certificates] Valid certificates and keys now exist in
"/etc/kubernetes/pki"
.
.
.
[addons] Applied essential addon: kube-dns
[addons] Applied essential addon: kube-proxy
Your Kubernetes master has initialized successfully!

Позже, при подключении к кластеру других узлов, вам нужно будет записать 
куда больше информации. Чтобы начать применять кластер, запустите от имени 
обычного пользователя следующие команды:

vagrant@n1:~$ mkdir -p $HOME/.kube
vagrant@n1:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
vagrant@n1:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

Теперь, чтобы подключить к кластеру любое количество ВМ, на каждом из его 
узлов достаточно выполнить от имени администратора лишь одну команду. Чтобы 
ее получить, введите kubeadm init cmmand:sudo kubeadm join -token << token>> 
--discovery-token-ca-cert-hash <<discvery token>> -skip-prflight-cheks.
------------------------------------------------------
Настройка pod-сети
---------------------
Сеть — это важная составляющая кластера. Подам нужно как-то общаться друг 
с другом. Для этого следует установить дополнение с поддержкой pod-сети. В ва-
шем распоряжении есть несколько вариантов, однако они должны быть основаны 
на CNI, так как этого требуют кластеры, сгенерированные с помощью команды 
kubeadm. Я предпочитаю дополнение Weave Net, которое поддерживает ресурс 
Network Policy, но вы можете выбрать нечто другое.
Выполните в ведущей ВМ команду:
vagrant@n1:~$ sudo sysctl net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-iptables = 1vagrant@n1:~$ kubectl apply -f
"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 |
tr -d '\n')"
Создание многоузлового кластера с помощью kubeadm  63
Вы должны увидеть следующее:
serviceaccount "weave-net" created
clusterrole.rbac.authorization.k8s.io "weave-net" created
clusterrolebinding.rbac.authorization.k8s.io "weave-net" created
role.rbac.authorization.k8s.io "weave-net" created
rolebinding.rbac.authorization.k8s.io "weave-net" created
daemonset.extensions "weave-net" created
Успешность выполнения можно проверить так:
vagrant@n1:~$ kubectl get po --all-namespaces
NAMESPACE NAME READY STATUS RESTARTS AGE
kube-system etcd-n1 1/1 Running 0 2m
kube-system kube-apiserver-n1 1/1 Running 0 2m
kube-system kube-controller-manager-n1 1/1 Running 0 2m
kube-system kube-dns-86f4d74b45-jqctg 3/3 Running 0 3m
kube-system kube-proxy-l54s9 1/1 Running 0 3m
kube-system kube-scheduler-n1 1/1 Running 0 2m
kube-system weave-net-fl7wn 2/2 Running 0 31s
Последним стоит под weave-net-fl7wn, который нам и нужен. Он был запущен 
вместе с kube-dns, это означает, что все в порядке.
Добавление рабочих узлов
Теперь с помощью ранее полученного токена можно добавить в кластер рабочие 
узлы. Выполните на каждом из узлов (не забудьте sudo) следующую команду, под-
ставив токены, которые получили при инициализации Kubernetes на ведущем узле:
sudo kubeadm join --token "token" --discovery-token-ca-cert-hash
"discovery token" --ignore-preflight-errors=all
На момент написания этой книги (с использованием Kubernetes 1.10) некото-
рые предварительные проверки завершались неудачно, но это всего лишь ложные 
срабатывания. На самом деле все в порядке. Можете их пропустить, установив флаг 
--ignore-preflight-errors=all. Надеюсь, когда вы будете читать эти строки, все 
подобные неувязки уже будут устранены. Вы должны увидеть следующий вывод:
[discovery] Trying to connect to API Server "192.168.77.10:6443"
[discovery] Created cluster-info discovery client, requesting info from 
"https://192.168.77.10:6443"
[discovery] Requesting info from "https://192.168.77.10:6443" again to 
validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate 
validates against pinned roots, will use API Server "192.168.77.10:6443"
[discovery] Successfully established connection with API Server 
"192.168.77.10:6443"
Данный узел присоединился к кластеру:
* Certificate signing request was sent to master and a response was received.
* The Kubelet was informed of the new secure connection details.
64  Глава 2  •  Создание кластеров Kubernetes
Чтобы убедиться в этом, выполните на ведущем узле команду kubectl get nodes.
В некоторых ситуациях это может не сработать из-за проблем с инициализацией 
CNI-дополнения.

























