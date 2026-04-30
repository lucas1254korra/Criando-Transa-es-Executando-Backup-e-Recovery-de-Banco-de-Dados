-- PARTE 2: Transações em Procedures com Savepoints
-- Foco: Tratamento de exceções e Rollback Parcial.

DELIMITER //

CREATE PROCEDURE sp_processar_pagamento_auditado(
    IN p_id_pedido INT, 
    IN p_valor DECIMAL(10,2)
)
BEGIN
    -- Variável para captura de estado de erro
    DECLARE erro_sql TINYINT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = 1;

    START TRANSACTION;

    -- Ponto de salvamento inicial: Log de tentativa de processamento
    INSERT INTO logs_auditoria (id_pedido, acao) VALUES (p_id_pedido, 'INICIO_PROCESSAMENTO');
    
    -- Definir Savepoint antes de operação financeira sensível
    SAVEPOINT ponto_pagamento;

    -- Tentativa de débito (pode falhar por constraint de saldo)
    UPDATE contas_financeiras SET saldo = saldo - p_valor WHERE id_pedido = p_id_pedido;

    IF erro_sql = 1 THEN
        -- Ocorreu erro: Reverter apenas o débito, mantendo o log de início
        ROLLBACK TO ponto_pagamento;
        INSERT INTO logs_auditoria (id_pedido, acao) VALUES (p_id_pedido, 'FALHA_SALDO_INSUFICIENTE');
        COMMIT;
    ELSE
        -- Sucesso total
        UPDATE ecommerce_orders SET status = 'PAGO' WHERE id_pedido = p_id_pedido;
        COMMIT;
    END IF;
END //

DELIMITER ;
