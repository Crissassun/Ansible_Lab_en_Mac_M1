### Ansible lab en Mac M1 con Docker containers

El objetivo de esta guía es lograr tener un laboratorio de Ansible usando Docker containers. El primer contenedor llamado  "master" es donde haremos la ejecución de nuestros playbooks en dos nodos llamados "nodo1" y "nodo2". Toda esta guia esta pensada para funcionar en una MacOs Monterey M1, pero fácilmente pueden adaptarla para otro sistema operativo.


## Docker instalación

Para instalar Docker en nuestra Mac con Apple chip ve a link [Docker Desktop](https://www.docker.com/products/docker-desktop/). Una vez descargada la aplicación de escritorio damos doble click y arrastramos a nuestra carpeta de aplicaciones.

Para validar que la instalación fue realizada exitosamente vamos a abrir nuestra terminal en nuestra Mac y escribimos lo siguiente:
```
docker --version
```
El output que obtendremos será algo similar dependiendo la versión instalada de Docker.

```
Docker version 20.10.13, build a224086
```

Docker está instalado exitosamente, solo hay que abrir nuestra aplicación.

## VsCode

El editor de texto que utilizaremos será VSCode, [Descarga VsCode](https://code.visualstudio.com/download)
Instalamos y abrimos nuestro editor de texto.

## Brew & Git 

Ahora para clonar este repositorio git necesitamos tener git instalado y la manera más fácil de instalar paquetes es usando brew en MacOS, para eso solo hay que ir a su sitio web y seguir sus instrucciones para instalar [brew](https://brew.sh/index_es).

Una vez tenemos instalado  bre wn nuestra Mac vamos a la terminal para poder instalar git con el siguiente comando:

```
brew install git
```

## Git clone 

Con VsCode instalado abriremos una carpeta donde tendremos nuestros archivos, seguidamente abriremos una nueva terminal y clonaremos este repositorio con el siguiente comando:

```
git clone https://github.com/Crissassun/Ansible_Lab_en_Mac_M1.git
```

## Crear Ansible lab 

Ya con el repositorio clonado en nuestra máquina construiremos nuestras imágenes y repositorios con Docker haciendo uso de docker-compose.yml

En nuestra terminal de VsCode correremos el siguiente comando:
 
```
docker-compose up -d --build
```
Cuando termine la ejecución el output que veremos será:

```
Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
Creating master ... done
Creating node2  ... done
Creating node1  ... done
```
Ahora validaremos que nuestros contenedores estén corriendo con el siguiente comando:

```
Docker container list 
```
El output será similar a:

```
CONTAINER ID   IMAGE            COMMAND               CREATED              STATUS              PORTS     NAMES
84d1d74607b0   node             "/var/key.sh"         About a minute ago   Up About a minute             node1
fa83997fdffd   node             "/var/key.sh"         About a minute ago   Up About a minute             node2
59b1e112eb3b   ansible_master   "/usr/sbin/sshd -D"   About a minute ago   Up About a minute             master
```

Ahora ingresaremos al bash del master node para poder validar la conexión y desde ahí siempre correr nuestros playbooks.

```
docker exec -it master /bin/bash
```
Dentro de la terminal de nuestro master container validaremos que la conexión entre nuestro master y nodos funcione correctamente con el siguiente comando:

```
ping -c 2 node1
```

Output:

```
--- node1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1003ms
```
 Repiten lo anterior para el nodo2. 

Ahora iniciaremos nuestro agente ssh en nuestro master con el siguiente comando:

```
ssh-agent bash
``` 
Después cargaremos nuestra llave ssh en el agente con el siguiente comando:

```
ssh-add ansible_key
```
El output nos pedirá una frase la cual es "ansible" sin las comillas:
```
Enter passphrase for ansible_key:
```

### Ansible playbook

Ahora correremos nuestro primer playbook en nuestro master para validar la conexion en los demas nodos con ssh, para eso ejecutamos el siguiente comando:

```
ansible-playbook -i inventary ping.yml
```

Output nos pedirá confirmar la conexión, escribimos "yes" varias veces:
```
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Please type 'yes', 'no' or the fingerprint: yes
Please type 'yes', 'no' or the fingerprint: yes
ok: [node1]
yes
```
Hasta que obtengamos el siguiente output:
```
TASK [Ping all nodes] ********************************************************************************************************************************
ok: [node1]
ok: [node2]

TASK [Execution succexxfully] ************************************************************************************************************************
ok: [node1] => {
    "msg": " The status of execution {'ping': 'pong', 'failed': False, 'changed': False}  "
}
ok: [node2] => {
    "msg": " The status of execution {'ping': 'pong', 'failed': False, 'changed': False}  "
}

PLAY RECAP *******************************************************************************************************************************************
node1                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node2                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

##  <center> Felicitaciones has logrado exitosamente crear tu laboratorio de Ansible empleando Docker. </center>


### Bonus

Salir del contenedor master sin detenerlo, pulsamos las teclas:
```
ctrl + d
```
Copiar nuestros playbooks desde nuestra Mac al contenedor:

```
cp ./test.yml master:/var/ansible/
```

Output:

```
> docker cp ./test.yml master:/var/ansible/
> docker exec -it master /bin/bash
root@master:/var/ansible# ll
total 28
drwxr-xr-x 2 root root    4096 Aug 24 19:10 ./
drwxr-xr-x 1 root root    4096 Aug 24 18:50 ../
-rw------- 1 root root    2655 Aug 24 18:50 ansible_key
-rw-r--r-- 1 root root     572 Aug 24 18:50 ansible_key.pub
-rw-r--r-- 1 root root     155 Aug 24 17:36 inventory
-rw-r--r-- 1 root root     214 Aug 24 17:56 ping.yml
-rw-r--r-- 1  501 dialout    0 Aug 24 19:09 test.yml
```

