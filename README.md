# Projeto_Pedidos_OnLine
Projeto de MBA de criação de um Banco para Pedidos OnLIne
# 📊 Projeto de Banco de Dados - Projeto Pedidos OnLine

## 🎓 Turma MBA em Engenharia de Dados

---

## 🧠 Integrantes da Equipe
ALDENIR JOSÉ TELLES DA SILVA
MARIANA DE LIMA SOUZA
REBEKA CAROLINA DA SILVA BRAGA
THAMYRES COSTA DE SOUZA
BEN-HUR QUEIROZ BELTRÃO

## 📌 Nome do Projeto
**Gerenciamento de Plataforma de Pedidos Online**

---

## 📝 Descrição do Projeto

O projeto de banco de dados voltado para o gerenciamento e análise de dados de uma plataforma de pedidos online.

O banco de dados foi modelado para representar um cenário real onde a empresa monitora seus clientes, pedidos, produtos, fornecedores, pagamentos e entrega.
Onde: 
•	Cada cliente possui um nome, CPF, e-mail, telefone e pode fazer vários pedidos. Cada pedido é associado a um cliente e contém a data em que foi realizado.
•	Um pedido pode conter vários itens. Os itens do pedido representam a compra de vários produtos, sendo armazenadas a quantidade e o valor unitário de cada produto adquirido. Cada item pertence a um único pedido e refere-se a um único produto.
•	Cada produto possui nome, valor unitário, descrição e um código identificador. Um produto pode ser fornecido por um ou mais fornecedores, enquanto cada fornecedor fornece pelo menos um produto. O fornecedor possui nome, CNPJ e telefone.
•	Cada pedido pode ser associado a um ou mais pagamentos, mas um pagamento está sempre ligado a um único pedido. O pagamento registra o valor pago, a data do pagamento e se ele foi efetivado. A forma de pagamento (como cartão, boleto ou pix) é armazenada separadamente, e cada forma pode ser usada em diversos pagamentos.
•	Um pedido pode ter, ou não, uma entrega associada, que só ocorre se houver pagamento efetuado. Cada entrega registra a data de envio e a data prevista para a entrega. A entrega é executada para um único pedido.

---


## 🧰 SGBD Escolhido

**MySQL Workbench**
**BR Modelo**

---

## 📐 Modelagem de Dados

https://github.com/benhur1920/Projeto_Pedidos_OnLine/blob/main/Print%20Modelo%20ER%20e%20Logico.pdf

---

## 🛠️ Scripts SQL

### 🏗️ Criação das Tabelas (DDL)

https://github.com/benhur1920/Projeto_Pedidos_OnLine/blob/main/Criacao%20das%20tabelas.sql

### 📥 Inserção de Dados (DML)

https://github.com/benhur1920/Projeto_Pedidos_OnLine/blob/main/Insert%20das%20tabelas.sql

```
### 🔍 Consultas SQL 
https://github.com/benhur1920/Projeto_Pedidos_OnLine/blob/main/Relatorios.sql
```
