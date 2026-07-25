## Práticas de CI/CD Utilizando Magalu Cloud
#### **Pré-requisitos**
- Conta ativa na Magalu Cloud
- 1 Máquina Virtual criada no ambiente da Magalu Cloud
- Docker instalado e configurado na VM 

### 1. MGC
- [Instalar MGC CLI na VM](Acehttps://docs.magalu.cloud/docs/devops-tools/cli-mgc/how-to/download-and-install)
```bash
mgc auth login
```	
  
### 2. Publicar Docker Images da VM para o Container Registry da Magalu Cloud
- Autenticar, tagear e fazer push de uma imagem Docker para o Container Registry da Magalu Cloud.

#### **2.1 Login no registry**
```bash
docker login https://container-registry.br-se1.magalu.cloud -u SEU_USER_ID
```
- O sistema solicitará sua senha/token. Para obtê-los, vá para seu namespace no Container Registry.
<img width="600" height="300" alt="container-registry-magalu" src="https://github.com/user-attachments/assets/0eeb57eb-acc4-4bbc-b510-97c49956fdc8" />

#### **2.2 Tagear a Imagem Docker**
```bash
# 2. Verificar imagem local
docker images

# 3. Tagear a imagem
docker tag <NOME_IMAGEM_LOCAL:TAG LOCAL> container-registry.br-se1.magalu.cloud/<NOME_REPOSITORIO>/<NOME_IMAGEM:TAG>

#Exemplo
docker tag docker-teste1:local container-registry.br-se1.magalu.cloud/container1/docker-teste1:v1
```
#### **2.3 Push para o registry**
```bash
docker push container-registry.br-se1.magalu.cloud/<NOME_REPOSITORIO>/<NOME_IMAGEM:TAG>

#Exemplo
docker push container-registry.br-se1.magalu.cloud/container1/docker-teste1:v1
```
<img width="507" height="143" alt="image" src="https://github.com/user-attachments/assets/819ca25e-28d1-41a2-bafc-a2754d89cc8a" />

<img width="554" height="369" alt="image" src="https://github.com/user-attachments/assets/a2b39f77-7693-4810-a998-9f67a5eb4132" />

### Parte 2: Criação e Acesso ao Cluster Kubernets

### Links Úteis
[Documentação oficial Magalu Cloud](https://docs.magalu.cloud/)

[Container Registry - Magalu Cloud](https://www.magalu.cloud/container-registry)

[Documentação Docker](https://docs.docker.com/)
