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
sem exemplo

### 3 Login no Container Registry
```bash
docker login https://container-registry.br-se1.magalu.cloud -u SEU_USER_ID
```
O sistema solicitará sua senha/token. Para obtê-los, vá para seu namespace no Container Registry.
<img width="600" height="300" alt="container-registry-magalu" src="https://github.com/user-attachments/assets/0eeb57eb-acc4-4bbc-b510-97c49956fdc8" />

### 4. Tagear imagem Docker
```bash
# Verificar imagem local
docker images

# Tagear a imagem
docker tag <NOME_IMAGEM_LOCAL:TAG LOCAL> container-registry.br-se1.magalu.cloud/<NOME_REPOSITORIO>/<NOME_IMAGEM:TAG>

#Exemplo
docker tag docker-teste1:local container-registry.br-se1.magalu.cloud/container1/docker-teste1:v1
```

### 5. Fazer Push da Imagem Docker para o Container Registry
```bash
docker push container-registry.br-se1.magalu.cloud/<NOME_REPOSITORIO>/<NOME_IMAGEM:TAG>

#Exemplo
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

### Links Úteis
[Documentação oficial Magalu Cloud](https://docs.magalu.cloud/)

[Container Registry - Magalu Cloud](https://www.magalu.cloud/container-registry)

[Documentação Docker](https://docs.docker.com/)
