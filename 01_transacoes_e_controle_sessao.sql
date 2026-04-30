-- PARTE 1: Transações e Controlo de Sessão
-- Foco: Garantia de Atomicidade em operações críticas de E-commerce.

-- Desativar autocommit para controlo manual do estado
SET autocommit = 0;

START TRANSACTION;

-- Cenário: Atualização de status de pedido e atualização de score de risco simultânea
UPDATE ecommerce_orders 
SET status = 'SOB_ANALISE_FRAUDE' 
WHERE id_pedido = 1024;

UPDATE perfis_risco_usuario 
SET score_fraude = score_fraude + 10 
WHERE id_usuario = (SELECT id_usuario FROM ecommerce_orders WHERE id_pedido = 1024);

-- Confirmação das alterações
COMMIT;

-- Restaurar configuração padrão
SET autocommit = 1;
