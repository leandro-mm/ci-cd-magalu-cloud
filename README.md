### Parte 1: Publicando Imagens no Container Registry da Magalu Cloud
Nessa primeira parte, veremos como autenticar, tagear e fazer push de uma imagem Docker para o Container Registry da Magalu Cloud.

**Pré-requisitos**
- Conta ativa na Magalu Cloud
- 1 Máquina Virtual criada no ambiente da Magalu Cloud
- Docker instalado e configurado na VM- 
- Acesso ao Container Registry da Magalu Cloud

**1.1**
faça login no registry da Magalu Cloud usando seu User ID
```bash
docker login https://container-registry.br-se1.magalu.cloud -u SEU_USER_ID
```

<img width="600" height="300" alt="container-registry-magalu" src="https://github.com/user-attachments/assets/0eeb57eb-acc4-4bbc-b510-97c49956fdc8" />
