# Sistema de Gestão de Base de Dados: Otimização, Transações e Segurança 🚀

Este repositório contém a resolução técnica para os desafios de banco de dados, focando-se em performance (índices), automação (procedures), integridade (transações) e disponibilidade (backup/recovery). O cenário foi adaptado para contextos de **E-commerce** e **Gestão Corporativa**, com especial atenção a fluxos de prevenção de fraude.

## 📂 Estrutura do Projeto

O projeto está dividido em scripts sequenciais para facilitar a implementação e auditoria:

1.  **`01_transacoes_e_controle_sessao.sql`**: Gestão manual de transações (ACID) para operações críticas de risco.
2.  **`02_procedure_transacional_savepoints.sql`**: Procedures avançadas com tratamento de erros e rollback parcial via `SAVEPOINT`.
3.  **`03_scripts_backup_recovery.sh`**: Automação de cópias de segurança lógicas utilizando `mysqldump`.

---

## 🛠️ Detalhes Técnicos

### 1. Índices e Performance
A estratégia de indexação focou-se no tipo **B-Tree**, ideal para as operações de `JOIN` e `GROUP BY` realizadas nos cenários de *Company*. 
* **Otimização**: Redução de *Full Table Scans* em colunas de chaves estrangeiras (`Dno`, `Dnumber`).

### 2. Transações e Integridade (ACID)
As transações foram desenhadas para garantir que modificações em múltiplas tabelas (ex: status de pedido e score de risco) sejam atómicas.
* **Controlo de Concorrência**: Utilização de `START TRANSACTION` e `COMMIT` após desabilitar o `autocommit`.

### 3. Procedures e Sub-transações
Foi implementada uma lógica de **Handler de Exceção** (`SQLEXCEPTION`). 
* **Savepoints**: Permitem que, em caso de falha numa operação financeira, o sistema reverta apenas o débito, mas mantenha o log de auditoria da tentativa de processamento.

### 4. Estratégia de Backup
Utilização de backups lógicos para portabilidade de esquemas complexos.
* **Flags Críticas**: `--routines` e `--events` para assegurar que as procedures e automações do sistema sejam incluídas no ficheiro de dump.

---

## 🚀 Como Executar

1.  **Preparação**: Certifique-se de que o motor de armazenamento é o **InnoDB** (para suporte a transações).
2.  **Scripts SQL**: Execute os ficheiros `.sql` diretamente no seu cliente MySQL ou via terminal:
    ```bash
    mysql -u seu_usuario -p < 01_transacoes_e_controle_sessao.sql
    ```
3.  **Backup**: Para gerar um novo backup completo, utilize o script shell:
    ```bash
    chmod +x 03_scripts_backup_recovery.sh
    ./03_scripts_backup_recovery.sh
    ```

---
*Projeto desenvolvido com foco em robustez transacional e arquitetura ANSI SQL.*
