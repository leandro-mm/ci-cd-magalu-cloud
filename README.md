## Práticas de CI/CD Utilizando Magalu Cloud
#### **Pré-requisitos**
- Conta ativa na Magalu Cloud
- 1 Máquina Virtual criada no ambiente da Magalu Cloud
- Docker instalado e configurado na Máquina Virtual
- 1 Docker file e container funcional

### 1. MGC
[Instalar MGC CLI na VM](https://docs.magalu.cloud/docs/devops-tools/cli-mgc/how-to/download-and-install)
```bash
mgc auth login
```	
### 2. Criar Container Registry na Magalu Cloud
*sem exemplo*

### 3 Login no Container Registry
```bash
docker login https://container-registry.br-se1.magalu.cloud -u SEU_USER_ID
```
*O sistema solicitará sua senha/token. Para obtê-los, vá para seu namespace no Container Registry*

<img width="600" height="300" alt="container-registry-magalu" src="https://github.com/user-attachments/assets/0eeb57eb-acc4-4bbc-b510-97c49956fdc8" />

*baixe o arquivo de credenciais para ser utilizado no passo 7*

### 4. Tagear imagem Docker
Verificar imagem local
```bash
docker images
```
Tagear a imagem
```bash
docker tag <NOME_IMAGEM_LOCAL:TAG LOCAL> container-registry.br-se1.magalu.cloud/<NOME_REPOSITORIO>/<NOME_IMAGEM:TAG>
```
Exemplo
```bash
docker tag docker-teste1:local container-registry.br-se1.magalu.cloud/container1/docker-teste1:v1
```

### 5. Fazer Push da Imagem Docker para o Container Registry
```bash
docker push container-registry.br-se1.magalu.cloud/<NOME_REPOSITORIO>/<NOME_IMAGEM:TAG>
```
*Exemplo*
```bash
docker push container-registry.br-se1.magalu.cloud/container1/docker-teste1:v1
```

<img width="507" height="143" alt="image" src="https://github.com/user-attachments/assets/819ca25e-28d1-41a2-bafc-a2754d89cc8a" />

| | |
| :---: | :---: |
| ![](https://github.com/user-attachments/assets/f1243380-ff0a-4f93-9a62-b626398b4b94) | ![](https://github.com/user-attachments/assets/17b7b2c3-3bab-404e-952c-abfc79f06574) |


### 6: Criar Cluster Kubernets na Magalu Cloud 
- versão de Kubernetes: padrão (recomendado)
- Nome do node pool: pod-name1
- Zona de disponibilidade: br-se1-a
- Tipo de instância: low memory Balanced Value
- Número de Nodes: 5
- nome do cluster: cluster-kubenets1

| | |
| :---: | :---: |
| ![](https://github.com/user-attachments/assets/4a8dc4b9-1a96-4719-8e42-4e547f1449a5) | ![](https://github.com/user-attachments/assets/ea8e63de-e861-41f2-ae68-fff321d518e4) |

#### 6.1: Instalar Kubectl no Ubuntu
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```
```bash
chmod +x kubectl
```

```bash
sudo mv kubectl /usr/local/bin/kubectl
```
```bash
kubectl version --client
```

#### 6.2: Download do kubeconfig
| caminho do arquivo| conteúdo do arquivo|
| :---: | :---: |
| ![](https://github.com/user-attachments/assets/484e6457-f14d-4b86-a677-19ce1fd1bbae) | ![](https://github.com/user-attachments/assets/a6b87d07-e7b0-487b-96a9-8c3ae329d7d6) |
|  | o arquivo contém o nome do usuário, servidor e o certificado para fazer a conexão com o kuernets |
| ou baixar o arquivo pela CLI: ```mgc kubernets cluster kubeconfig --cluster-id <CLUSTER_ID> --raw > kubeconfig.yaml```|

*enviar o arquivo para a máquina virtual*
```bash
scp nome_arquivo user@ip:/destino
```
*criar variável de ambiente*
```bash
export KUBECONFIG=$PWD/kubeconfig.yaml
```
### 7: Integração Docker Registry x Kubernets
O cluster precisa de um secret do tipo *docker-registry* para conseguir autenticar e puxar a imagem

### Links Úteis
[Documentação oficial Magalu Cloud](https://docs.magalu.cloud/)

[Container Registry - Magalu Cloud](https://www.magalu.cloud/container-registry)

[Documentação Docker](https://docs.docker.com/)
