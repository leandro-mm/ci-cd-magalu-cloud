### Parte 1: Publicando Imagens no Container Registry da Magalu Cloud
Nessa primeira parte, veremos como autenticar, tagear e fazer push de uma imagem Docker para o Container Registry da Magalu Cloud.

#### **Pré-requisitos**
- Conta ativa na Magalu Cloud
- 1 Máquina Virtual criada no ambiente da Magalu Cloud
- Docker instalado e configurado na VM- 
- Acesso ao Container Registry da Magalu Cloud

#### **1.1 Login no registry**
```bash
docker login https://container-registry.br-se1.magalu.cloud -u SEU_USER_ID
```
- O sistema solicitará sua senha/token. Para obtê-los, vá para seu namespace no Container Registry.
<img width="600" height="300" alt="container-registry-magalu" src="https://github.com/user-attachments/assets/0eeb57eb-acc4-4bbc-b510-97c49956fdc8" />

#### **1.2 Tagear a Imagem Docker**
```bash
# 2. Verificar imagem local
docker images

# 3. Tagear a imagem
docker tag <NOME_IMAGEM_LOCAL:TAG LOCAL> container-registry.br-se1.magalu.cloud/<NOME_REPOSITORIO>/<NOME_IMAGEM:TAG>

#Exemplo
docker tag docker-teste1:local container-registry.br-se1.magalu.cloud/container1/docker-teste1:v1
```
#### **1.3 Push para o registry**
```bash
docker push container-registry.br-se1.magalu.cloud/<NOME_REPOSITORIO>/<NOME_IMAGEM:TAG>

#Exemplo
docker push container-registry.br-se1.magalu.cloud/container1/docker-teste1:v1
```
<img width="507" height="143" alt="image" src="https://github.com/user-attachments/assets/819ca25e-28d1-41a2-bafc-a2754d89cc8a" />

### Links Úteis
[Documentação oficial Magalu Cloud](https://docs.magalu.cloud/)

[Container Registry - Magalu Cloud](https://www.magalu.cloud/container-registry)

[Documentação Docker](https://docs.docker.com/)
