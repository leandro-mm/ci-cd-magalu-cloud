## Práticas de CI/CD Utilizando Magalu Cloud

### Parte 1: Processo Manual
- Objetivo 1: Armazenar um container em registry privado na Magalu Cloud  
- Objetivo 2: Executar o container no Kubernets, em pods de forma replicada, com exposição externa via LoadBalancer

---

### Pré-requisitos
- Conta ativa na Magalu Cloud
- 1 Máquina Virtual criada no ambiente da Magalu Cloud com acesso ssh e Docker instalado
---
#### 1. Instalar o **CLI MGC** na Máquina Virtual
[Siga estas instruções, e em seguida execute:](https://docs.magalu.cloud/docs/devops-tools/cli-mgc/how-to/download-and-install)
```bash
mgc auth login
```
---
#### 2. Criar Container Registry na Magalu Cloud
[console.magalu.cloud/container-registry/new](https://console.magalu.cloud/container-registry/new)

*Exemplo de estrutura*  

<img width="639" height="109" alt="image" src="https://github.com/user-attachments/assets/21d1d948-3e2b-4d88-a06b-95a1886a5854" />
---

#### 3 Login no Container Registry
```bash
docker login https://container-registry.br-se1.magalu.cloud -u SEU_USER_ID
```
*O sistema solicitará sua senha/token. Para obtê-los, vá para seu namespace no Container Registry*

<img width="600" height="300" alt="container-registry-magalu" src="https://github.com/user-attachments/assets/0eeb57eb-acc4-4bbc-b510-97c49956fdc8" />

- *baixe o arquivo de credenciais para ser utilizado na criação do secret para integração do Docker Registry com o  Kubernets*
---
#### 4. Tagear imagem Docker
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
---
#### 5. Fazer Push da Imagem Docker para o Container Registry
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
---

#### 6: Criar Cluster Kubernets na Magalu Cloud 
- versão de Kubernetes: padrão (recomendado)
- Nome do node pool: pod-name1
- Zona de disponibilidade: br-se1-a
- Tipo de instância: low memory Balanced Value
- Número de Nodes: 5
- nome do cluster: cluster-kubenets1

| | |
| :---: | :---: |
| ![](https://github.com/user-attachments/assets/4a8dc4b9-1a96-4719-8e42-4e547f1449a5) | ![](https://github.com/user-attachments/assets/ea8e63de-e861-41f2-ae68-fff321d518e4) |
---
##### 6.1: Instalar Kubectl no Ubuntu
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
---
##### 6.2: Download do kubeconfig
| caminho do arquivo| conteúdo do arquivo|
| :---: | :---: |
| ![](https://github.com/user-attachments/assets/484e6457-f14d-4b86-a677-19ce1fd1bbae) | ![](https://github.com/user-attachments/assets/a6b87d07-e7b0-487b-96a9-8c3ae329d7d6) |
|  | o arquivo contém o nome do usuário, servidor e o certificado para fazer a conexão com o kuernets |
| ou baixar o arquivo pela CLI: ```mgc kubernets cluster kubeconfig --cluster-id <CLUSTER_ID> --raw > kubeconfig.yaml```|
---
##### 6.3: enviar o arquivo para a máquina virtual
```bash
scp nome_arquivo user@ip:/destino
```
---
##### 6.4: criar variável de ambiente
```bash
echo 'export KUBECONFIG=$HOME/<NOME-DO-ARQUIVO-BAIXADO>.yaml' >> ~/.bashrc
```
```bash
source ~/.bashrc
```
```bash
echo $KUBECONFIG
```
---
##### 6.5: testar a conexão
```bash
kubectl cluster-info
```
<img width="897" height="168" alt="image" src="https://github.com/user-attachments/assets/c9886bba-6615-4ede-aa16-18dba3a67e50" />

```bash
kubectl get nodes
```
```bash
kubectl config current-context
```
---
##### 6.6: Integração Docker Registry x Kubernets
O cluster precisa de um secret do tipo *docker-registry* para conseguir autenticar e puxar a imagem.
```bash
kubectl create secret docker-registry <NOME-DO-SECRET> \
--docker-server=container-registry.br-se1.magalu.cloud\
--docker-username=<SEU_USUARIO> \  #passo 3 login no container registry
--docker-password=<SUA_SENHA> \ #passo 3 login no container registry
--docker-email=<SEU_EMAIL> #passo 3 login no container registry
```
```bash
 kubectl describe secret <NOME-DO-SECRET> -n default
```

<img width="322" height="21" alt="image" src="https://github.com/user-attachments/assets/4adc0ac6-633b-4159-bf76-2970da0f9a96" />
---  

##### 6.7: Criar o arquivo deployment/service
- Os recursos já estão provisionados no cluster porém não estão em execução
- Deve ser criado o manifesto e aplicá-lo no kubernets para executar os recursos
- Edite o conteúdo do arquivo */parte1-processo-manual/app-k8s.yaml* contido neste repositório
---  

##### 6.7.1: enviar o arquivo `app-k8s.yaml` para a máquina virtual
```bash
scp app-k8s.yaml user@ip:/destino
```
---  

##### 6.7.2: aplicar o deployment/service
```bash
kubectl apply -f app-k8s.yaml
```
<img width="390" height="39" alt="image" src="https://github.com/user-attachments/assets/6a77a913-3cad-4a3f-b6f4-0df456476ac0" />

*Processo*
<img width="4670" height="3014" alt="image" src="https://github.com/user-attachments/assets/651ddf13-2383-4dc4-b8ac-8e625ecf3db8" />

---  

##### 7.0: Acessar recursos via ip externo do load balancer
```bash
kubectl describe svc <nome-do-service-arquivo-k8s>
```

| | |
| :---: | :---: |
| ![](https://github.com/user-attachments/assets/a06c8faf-2394-4056-b6b3-ca584e56a1cf) | ![](https://github.com/user-attachments/assets/3d08d5e7-c6e4-4262-afe2-0df543438a96) | 
|||
---
#### 8: Troubleshooting

##### Teste diretamente nos pods (ignorando o LoadBalancer)
```bash
kubectl exec -it <IDENTIFICADOR> -- curl -v localhost:80
```
---
##### POD Status 
```bash
kubectl get pods -l app=<NOME-DEFINIDO-PARA-APP>
```

```bash
kubectl get pods -o wide
```

<img width="1199" height="60" alt="image" src="https://github.com/user-attachments/assets/e86308f5-e06d-4dc4-86a4-21b2383234ed" />

Possíveis status de erros
- ImagePullBackOff: Kubernetes não conseguiu puxar (pull) a imagem definida no Deployment
- ErrImagePull: Falha imediata ao tentar puxar a imagem
- CrashLoopBackOff: O container está iniciando e falhando repetidamente
- Error: O container falhou ao iniciar
- Completed: Container foi morto por falta de memória (Out Of Memory)
- Evicted: Pod foi removido por falta de recursos no nó
  
Descrever um dos pods para ver a mensagem de erro exata
```bash
kubectl describe pod <POD-NAME>
```
---
Outros tipos de erro
| | |
| :---: | :---: |
|![](https://github.com/user-attachments/assets/25fad822-190a-4253-a103-4ff8333394c0)| ![](https://github.com/user-attachments/assets/8260ba31-91ee-4a69-8a0c-d0b09c72c778)| 
| ![](https://github.com/user-attachments/assets/e0720a0e-c767-460e-a82d-bcbef2d285fc)| ![](https://github.com/user-attachments/assets/c9b2710a-31ce-44b2-8830-335fae7a12a9)| 
---
Outros comandos
| | |
| :---: | :---: |
| ![](https://github.com/user-attachments/assets/cd33e2e8-d1b8-4bcd-a7bf-b38173eb3404) | ![](https://github.com/user-attachments/assets/a5e86231-6ba9-4669-b56a-fcfa93580b39) | 
|![](https://github.com/user-attachments/assets/d71612d0-b94f-4883-9a63-b7fc2fa839d7)  | ![](https://github.com/user-attachments/assets/dcde318f-5987-4d62-adb9-4b4eb4f2433e) | 
| ![](https://github.com/user-attachments/assets/07589bb2-dcfb-4bb9-9075-13c33277a356) |  ![](https://github.com/user-attachments/assets/7d28057e-effa-4a91-98da-4e82f288956f)| 
---
##### Service e app devem estar rodando na mesma porta
```bash
kubectl patch svc <nome-do-service-no-k8s-file> -p '{"spec":{"ports":[{"port":xx,"targetPort":xx}]}}'
```
```bash
kubectl run test-curl --rm -it --image=curlimages/curl --restart=Never -- curl -v http://<nome-servico-k8s-file>:80
```
---
##### watch
```bash
kubectl get service <app-k8s-service-name> --watch
```
<img width="757" height="40" alt="image" src="https://github.com/user-attachments/assets/925751c4-0525-45d2-8209-11a93a2189af" />

---
#### Excluir Recursos

##### Excluir/Desalocar IP do Load Balancer
```bash
./mgc.exe load-balancer network-loadbalancers list [-o table[json]]
```
```bash
/mgc.exe load-balancer network-loadbalancers delete <load-balancer-id> --delete-public-ip
```
---

##### Deletar IP público
o IP público muda seu status de in_use para created, ficando disponível para ser reutilizado ou deletado 
```bash
cd /mgccli_folder
```
```bash
./mgc.exe auth login
```
```bash
./mgc.exe network public-ips list
```
```bash
./mgc.exe  network public-ips delete <public-ip-id>
```
---
### Parte 2 - Processo Automatizado
- Objetivo: Publicar imagens Docker automaticamente no Container Registry da Magalu Cloud

#### Contexto
Sem automação, publicar uma nova versão de uma aplicação em contêiner costuma exigir uma sequência manual
de comandos: build da imagem, login no registry, tag correta, push e, por fim, conferência de que tudo
funcionou. Esse processo manual é repetitivo, sujeito a esquecimentos (como taggear com a versão errada) e
difícil de auditar.
<img width="1085" height="273" alt="image" src="https://github.com/user-attachments/assets/8fea3ae5-92d6-42c7-a568-c4c0767aec08" />

_fonte: Move Tech Magalu Cloud | Prosper Digital Skills_

Automatização do processo: escreve-se o código, executa-se git push, e o GitHub Actions cuida do restante — build, tag, autenticação e publicação no Magalu Cloud Container Registry.

<img width="1093" height="414" alt="image" src="https://github.com/user-attachments/assets/b83ad00f-44d2-47eb-ad90-c02b8eb4e553" />

_fonte: Move Tech Magalu Cloud | Prosper Digital Skills_


---


#### Continuous Delivery + Continuous Deployment
- *Continuous Delivery*: = O software está pronto para ir para produção, mas alguém aperta o botão para liberar.
  <img width="745" height="84" alt="image" src="https://github.com/user-attachments/assets/60c256c8-5750-4b2a-8750-d55ec62d617f" />
  
- *Continuous Deployment* = O software vai para produção automaticamente, sem que nenhum humano aperte o botão.
  <img width="725" height="84" alt="image" src="https://github.com/user-attachments/assets/aebfeac1-c33f-4c04-9a3b-e476eb28bb20" />

- Ambas são extensões do Continuous Integration (CI). O CI é o processo onde os desenvolvedores integram o código no repositório principal várias vezes ao dia. Isso dispara testes automatizados para garantir que o novo código não quebrou nada.- 

---
#### GitHub Runners em Pipelines CI/CD com GitHub Actions
- **GitHub Runners** são servidores (máquinas) que executam os jobs definidos nos seus workflows do GitHub Actions. Eles são o "motor" que roda os comandos, scripts e ferramentas necessários para testar, buildar e implantar seu código.
- Cada *runner* pode executar um job por vez e é destruído (ou reiniciado) após a conclusão, garantindo um ambiente limpo para cada execução.

##### Tipos de Runners

| Tipo | Descrição | Quando usar |
|------|-----------|-------------|
| **GitHub-hosted runners** | Máquinas gerenciadas pelo GitHub, com sistemas operacionais pré-configurados (Ubuntu, Windows, macOS). | Projetos open-source, equipes pequenas, ou quando você quer simplicidade e manutenção zero. |
| **Self-hosted runners** | Máquinas próprias (on-premise ou na nuvem) que você registra no GitHub. | Projetos com requisitos específicos de hardware, segurança, ou que precisam de cache persistente e custos reduzidos em grande escala. |

---

##### Como funcionam no pipeline?

1. **Trigger** – Um evento (push, pull_request, schedule, etc.) inicia o workflow.
2. **Seleção do runner** – O GitHub escolhe um runner disponível com a label especificada (`runs-on: ubuntu-latest`, por exemplo).
3. **Execução** – O runner clona o repositório, executa os steps definidos no YAML e gera logs em tempo real.
4. **Resultado** – Ao final, o runner reporta sucesso ou falha, e o ambiente é limpo (no caso dos hosted).

---

##### Exemplo de workflow com runner

```yaml
name: CI Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest   # <- Define o runner
    steps:
      - name: Checkout código
        uses: actions/checkout@v4

      - name: Configurar Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18

      - name: Instalar dependências
        run: npm ci

      - name: Rodar testes
        run: npm test

      - name: Build do projeto
        run: npm run build
```
<img width="979" height="592" alt="image" src="https://github.com/user-attachments/assets/609a6941-ce0a-4393-9363-ea50fb7a0b94" />  

_fonte: Move Tech Magalu Cloud | Prosper Digital Skills_

##### Benefícios dessa abordagem
- Redução de erro humano: a mesma sequência de passos é executada sempre da mesma forma.
- Rastreabilidade: cada imagem publicada fica associada ao commit e ao digest (identificador criptográfico único (sha256) de uma imagem específica — imutável, ao contrário da tag (apelido que pode ser reatribuído) que a gerou.
- Velocidade: uma nova versão fica disponível minutos após o push, sem intervenção manual.
- Padronização: todo o time publica imagens seguindo o mesmo processo e as mesmas boas práticas.

---
#### Mão na massa: Pré-requisitos
- Conta no GitHub
- Conta na Magalu Cloud
- Git instalado na máquina local
- Docker instalado na máquina local
- Editor de código (ex.: VS Code, Sublime, Vim)
- Terminal (Bash, Zsh, PowerShell ou WSL)
- Conexão com a internet 
---

#### Passo 1: Crie o Registry
- Obtenha as credenciais do registry criado no passo 2.
- Anote os cinco valores abaixo:
  
| Campo | Exemplo de valor | 
|------|-----------|
| Região | br-se1 | 
| Endpoint do Container Registry | é um endereço fixo por região. O endereço já existe para cada região disponível. Segue o formato `container-registry.<região>.magalu.cloud` (`container-registry.br-se1.magalu.cloud` ou `container-registry.br-ne1.magalu.cloud`)|
| Nome do registry | cr-meu-projeto |
| Username | pode ser obtido via mgc container-registry credentials get |
| Password | pode ser obtido via mgc container-registry credentials get |

Obs.: O endereço da imagem dentro do container registry será `container-registry.<região>.magalu.cloud/<nome-do-registry>/<nome-da-imagem>:<tag>` O nome do registry faz parte do caminho

---  

#### Passo 2: Criar uma pequena aplicação Flask com dois endpoints
1. Crie um Repositório, público ou privado, no gitHub
2. Clone o repositório
3. Valide a configuração do remoto
```bash
git remote -v
```
4. Utilize os arquivos da pasta ./parte-2-processo-automatico

---

#### Passo 3: Construir, validar e executar a imagem Docker localmente  
##### 3.1: Start Docker Desktop  
```bash
docker version
```

| Comando | Para que serve | 
|------|-----------|
| docker build | Constrói uma imagem a partir de um Dockerfile. `docker build -t meu-pipeline:1.0.0 .` O parâmetro -t define o nome e a tag da imagem (formato nome:versão). O ponto final indica que o Dockerfile está no diretório atual.| 
| docker run  | Executa um contêiner a partir de uma imagem. `docker run -p 5000:5000 --name app-teste1 meu-pipeline:1.0.0` O parâmetro -p 5000:5000 mapeia a porta 5000 do contêiner para a porta 5000 da máquina local.| 
---  

##### Conferindo imagens e contêineres
```bash
docker images
```
```bash
docker ps
```
---  

##### Acesse os dois endpoints da aplicação
> http://localhost:5000
> > http://localhost:5000/health
---  

#### Passo 4: Configurando GitHub Secrets
**Objetivo**: Armazenar as credenciais do Container Registry de forma segura no GitHub, para que o workflow possa usá-las sem expor a senha no código.

- Um Secret do GitHub é um valor criptografado, associado ao repositório, que fica acessível aos workflows do GitHub Actions em tempo de execução, mas nunca é exibido em logs nem pode ser lido de volta pela interface.
- No repositório do GitHub, acesse `Settings → Secrets and variables → Actions → New repository secret` e crie os dois secrets abaixo:

| Nome do Secret | Valor | 
|------|-----------|
|  MAGALU_REGISTRY_USERNAME | Username retornado por mgc container-registry credentials get| 
|   MAGALU_REGISTRY_PASSWORD | Password retornado por mgc container-registry credentials get|  

---
#### Passo 5: Criando o Workflow
> Criar o arquivo de workflow do GitHub Actions que constrói e publica a imagem Docker no Magalu Cloud Container Registry a cada push na branch main

##### Criar localmente (com VS Code)
```bash
# No seu projeto local
mkdir -p .github/workflows

#Crie o arquivo publish.yml dentro de .github/workflows

# Abra no VS Code e edite
code .github/workflows/publish.yml

# Copie o conteúdo do arquivo contido na branch
feature/publish/.github/workflows/publish.yml
```
##### Ajuste os valores no bloco env
<img width="412" height="99" alt="image" src="https://github.com/user-attachments/assets/ee0bfe30-6d2c-4e1c-928d-432e86b8f6da" />

---

##### Teste
1. Realizar o primeiro Push
2. Acompanhar a execução do workflow na aba Actions do GitHub
3. Confirmar, diretamente no Container Registry da Magalu Cloud, que a imagem foi publicada pelo workflow
   
<img width="842" height="370" alt="image" src="https://github.com/user-attachments/assets/61e05b47-a647-4049-adeb-74daace8aea6" />

---

##### Ajuste de versão da imagem
<img width="378" height="158" alt="image" src="https://github.com/user-attachments/assets/b7f976ac-d8d9-457d-bea3-2c685527ec70" />


---

##### Troubleshooting
1. O arquivo dockerfile está dentro de outra pasta, deveria estar na raíz do projeto, dessa forma se atentar à linha 64 do publish.yml, linhas 5 e 9 do dockerfile
2. Rode as duas imagens localmente (versões 1.0.0 e 2.0.0, se você as manteve) e compare a resposta do endpoint /. Essa comparação, lado a lado, é a demonstração final de que cada push realmente produz uma versão nova, rastreável e independente da anterior.
3. Testar se conexão com container registry está funcionando
```powershell
$env:MAGALU_USERNAME=" "
$env:MAGALU_PASSWORD=" "
echo $env:MAGALU_PASSWORD | docker login container-registry.br-se1.magalu.cloud -u $env:MAGALU_USERNAME --password-stdin

Login Succeeded
```
   



---
### Links Úteis
- [Documentação oficial Magalu Cloud](https://docs.magalu.cloud/)
- [Container Registry - Magalu Cloud](https://www.magalu.cloud/container-registry)
- [Documentação Docker](https://docs.docker.com/)
