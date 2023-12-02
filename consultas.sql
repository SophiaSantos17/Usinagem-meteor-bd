-- 1. Selecione todas as peças produzidas na última semana.
    SELECT *
    FROM pecas
    JOIN ordens_producao ON pecas.pk_ID_peca = ordens_producao.fk_ID_peca
    WHERE ordens_producao.data_conclusao >= CURRENT_DATE - INTERVAL 1 WEEK;
 
-- 2. Encontre a quantidade total de peças produzidas por cada máquina.
    SELECT maquinas.nome_maquina, COUNT(*) AS quantidade_total
    FROM maquinas
    JOIN ordens_producao ON maquinas.pk_ID_maquina = ordens_producao.fk_ID_peca
    GROUP BY maquinas.nome_maquina;
 
-- 3. Liste todas as manutenções programadas para este mês.
    SELECT *
    FROM manutencoes_programadas
    WHERE MONTH(data_programada) = MONTH(CURRENT_DATE);
 
-- 4. Encontre os operadores que estiveram envolvidos na produção de uma peça específica.
-- Substitua 'ID_DA_PECA_ESPECIFICA' pelo ID da peça desejada
    SELECT operadores.*
    FROM operadores
    JOIN ordens_producao ON operadores.pk_ID_operador = ordens_producao.fk_ID_peca
    WHERE ordens_producao.fk_ID_peca = '8';
 
 
-- 5. Classifique as peças por peso em ordem decrescente.
    SELECT *
    FROM pecas
    ORDER BY peso DESC;
 
 
-- 6. Encontre a quantidade total de peças rejeitadas em um determinado período.
    SELECT COUNT(*) AS quantidade_total
    FROM rejeicoes
    WHERE data_rejeicao BETWEEN '2020-01-01' AND '2023-12-31';
 
-- 7. Liste os fornecedores de matérias-primas em ordem alfabética.
    SELECT *
    FROM fornecedores
    ORDER BY nome_fornecedor;
 
 
--8. Encontre o número total de peças produzidas por tipo de material.
    SELECT material, COUNT(*) AS quantidade_total
    FROM pecas
    GROUP BY material;
 
 
-- 9. Selecione as peças que estão abaixo do nível mínimo de estoque.
    SELECT pecas.pk_ID_peca, materias_primas.qntd_estoque
    FROM pecas
    JOIN materias_primas ON pecas.pk_ID_peca = materias_primas.pk_ID_materia_prima
    WHERE materias_primas.qntd_estoque < 40;
 
 
-- 10.Liste as máquinas que não passaram por manutenção nos últimos três meses.
    SELECT *
    FROM maquinas
WHERE ultima_manutencao <= CURRENT_DATE - INTERVAL 3 MONTH;

-- pesquisa as maquinas que não teve manutenção a 3 meses
    SELECT
        *
    FROM
        maquinas m
    WHERE
    ultima_manutencao < "2023-09-01";
 
-- 11. informa a media de tempo de produção das peças
    SELECT
        p.descricao_peca,
        CONCAT(FORMAT(AVG(TIMESTAMPDIFF(HOUR, data_inicio, data_conclusao)), 0), ' horas') AS media_tempo_producao
    FROM
        pecas p
    JOIN
        ordens_producao op ON p.pk_ID_peca = op.fk_ID_peca
    GROUP BY
        p.descricao_peca;
    
    
 
-- 12. traz as peças que tiverão inpeção nos ultimos 7 dias
    SELECT
        p.descricao_peca,
        i.data_inspecao
    FROM
        pecas p
    JOIN
        inspecoes i ON p.pk_ID_peca = i.ID_peca_inspecionada
    WHERE
        i.data_inspecao BETWEEN (SELECT MAX(data_inspecao) FROM inspecoes) - INTERVAL 7 DAY AND (SELECT MAX(data_inspecao) FROM inspecoes);
    
 
-- 13. tras o operador mais produtivo
    SELECT
        o.nome_operador,
        SUM(op.qntd_a_ser_produzida) AS total_pecas_produzidas
    FROM
        operadores o
    JOIN
        ordens_producao op ON o.pk_ID_operador = op.fk_ID_operador
    GROUP BY
        o.nome_operador
    ORDER BY
        total_pecas_produzidas DESC;
 
-- 14. peças criadas em um determinado tempo
    SELECT
        op.data_conclusao,
        p.descricao_peca,
        op.qntd_a_ser_produzida
    FROM
        ordens_producao op
    JOIN
        pecas p ON op.fk_ID_peca = p.pk_ID_peca
    WHERE
        YEAR(op.data_conclusao) = 2023;
 
-- 15. fornecedor de materia prima mais frequente
    SELECT
        f.nome_fornecedor,
        COUNT(mp.pk_ID_materia_prima) AS quantidade_entregas
    FROM
        fornecedores f
    LEFT JOIN
        materias_primas mp ON f.pk_ID_fornecedor = mp.fornecedor
    GROUP BY
        f.nome_fornecedor
    ORDER BY
        quantidade_entregas DESC;
 
--  16. total de peças Produzidas pelos operarios
    SELECT
        o.nome_operador,
        SUM(op.qntd_a_ser_produzida) AS total_pecas_produzidas
    FROM
        operadores o
    JOIN
        ordens_producao op ON o.pk_ID_operador = op.fk_ID_operador
    GROUP BY
        o.nome_operador;
    
-- 17. inspeção aceita
    SELECT
        p.descricao_peca,
        i.data_inspecao,
        i.resultado_inspecao,
        a.data_aceitacao,
        a.destino_peca
    FROM
        inspecoes i
    JOIN
        aceitacoes a ON i.pk_ID_inspecao = a.ID_peca_aceita
    JOIN
        pecas p ON i.ID_peca_inspecionada = p.pk_ID_peca
    WHERE
        i.resultado_inspecao = 'Aceita';
    
-- 18. manutenções programadas
    
    SELECT *
    FROM manutencoes_programadas
    WHERE MONTH(data_programada) = MONTH(CURRENT_DATE) + 1
    AND YEAR(data_programada) = YEAR(CURRENT_DATE);
 
-- 19. tempo total de manuteção
    
    SELECT SUM(custos_manutencao) AS custo_total
    FROM historico_manutencoes
    WHERE data_da_manutencao <= CURRENT_DATE
    AND YEAR(data_da_manutencao) = YEAR(CURRENT_DATE)
    AND QUARTER(data_da_manutencao) = QUARTER(CURRENT_DATE) - 1;
    
-- 20. peças com 10% de regeição
    SELECT op.pk_ID_Ordem, op.fk_ID_peca, COUNT(r.pk_ID_rejeicao) AS quantidade_rejeicoes
    FROM ordens_producao op
    JOIN rejeicoes r ON op.fk_ID_peca = r.ID_peca_rejeitada
    WHERE MONTH(op.data_conclusao) = MONTH(CURRENT_DATE) OR
            (MONTH(op.data_conclusao) = MONTH(CURRENT_DATE) - 1 AND YEAR(op.data_conclusao) = YEAR(CURRENT_DATE))
    GROUP BY op.pk_ID_Ordem, op.fk_ID_peca
    HAVING (COUNT(r.pk_ID_rejeicao) / COUNT(op.qntd_a_ser_produzida)) > 0.1;