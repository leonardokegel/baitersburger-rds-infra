# Baiters Burger - RDS Infrastructure

Este repositório contém as definições de Infraestrutura como Código (IaC) utilizando **Terraform** para o provisionamento e gestão de uma base de dados relacional (RDS) na AWS, destinada ao microsserviço de gerenciamento de clientes.

## 🏗️ Visão Geral da Infraestrutura

A infraestrutura é modularizada e provisiona os seguintes recursos na região `us-east-1`:

### 1. Base de Dados (Amazon RDS)
* **Motor:** MySQL 8.0.
* **Tipo de Instância:** `db.t3.micro`.
* **Armazenamento:** 20 GB alocados.
* **Rede:** Acessibilidade pública ativada (`publicly_accessible = true`) para facilitar integrações externas, protegida por um Security Group específico.

### 2. Segurança (AWS Secrets Manager)
O repositório utiliza o **AWS Secrets Manager** para gerir credenciais de forma segura, eliminando a necessidade de passwords em texto simples nos ficheiros de configuração:
* **Nome do Segredo:** `aws-rds-credentials`.
* **Conteúdo:** Inclui `username` (admin), `db_name` (baitersburgercustomer) e uma password gerada aleatoriamente.
* **Geração Automática:** Uma password de 16 caracteres é gerada dinamicamente via Terraform utilizando o recurso `random_password`.

### 3. Networking
* **VPC:** Utiliza a VPC padrão da conta AWS.
* **Subnets:** Grupo de subnets do RDS criado a partir das subnets disponíveis na VPC padrão.
* **Security Group:** Permite acesso de entrada na porta `3306` (MySQL) de qualquer origem (`0.0.0.0/0`).

## 🛠️ Tecnologias Utilizadas

* **Terraform:** Versão do provider AWS `6.21.0`.
* **Backend:** Estado do Terraform (`.tfstate`) armazenado remotamente num bucket S3 chamado `baitersburger-rds-infra`.
* **GitHub Actions:** Para automação do pipeline de infraestrutura.

## 🚀 Pipeline de CI/CD

O repositório possui um workflow automatizado via GitHub Actions que é acionado em cada `push` na branch `main`:

1.  **Checkout & Auth:** Obtém o código e configura as credenciais AWS via segredos do GitHub (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`).
2.  **Setup:** Instala o Terraform no ambiente de execução.
3.  **Validation:** Executa `terraform init`, `terraform validate` e `terraform plan` para garantir a integridade das configurações.
4.  **Deployment:** Executa `terraform apply -auto-approve` para aplicar as mudanças automaticamente na AWS.

## 📊 Outputs do Projeto

Após a execução bem-sucedida, o Terraform disponibiliza os seguintes dados:
* **`rds_endpoint`**: O endereço (DNS) de ligação à instância MySQL.
* **`secret_arn`**: O ARN do segredo no Secrets Manager que contém as credenciais de acesso.

## 📂 Estrutura de Pastas

* **/aws-rds**: Módulo contendo as definições específicas do RDS, Secrets Manager e dados de rede.
* **main.tf**: Ponto de entrada que chama o módulo RDS.
* **provider.tf**: Configurações do provider AWS e backend remoto.