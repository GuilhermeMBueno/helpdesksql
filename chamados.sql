SELECT 
    T0.id AS ID_Chamado,
    T0.name AS Assunto_do_Ticket,
    T6.completename AS Localizacao,
    CAST(T0.date AS DATE) AS Data_Abertura,
    CAST(T0.date AS TIME) AS Hora_Abertura,
    CONCAT(FLOOR(TIMESTAMPDIFF(MINUTE, T0.date, T0.closedate) / 60), 'H, ', 
           TIMESTAMPDIFF(MINUTE, T0.date, T0.closedate) MOD 60, 'M') AS Hrs_em_aberto,
    CAST(T0.solvedate AS DATE) AS Data_Solucao,
    CAST(T0.solvedate AS TIME) AS Hora_Solucao,
    TO_DAYS(T0.solvedate) - TO_DAYS(T0.date) AS Dias_ate_solucao,
    TIMESTAMPDIFF(MINUTE, T0.date, T0.solvedate) AS Minutos_ate_Solucao,
    CAST(T0.closedate AS DATE) AS Data_Fechamento,
    CAST(T0.closedate AS TIME) AS Hora_Fechamento,
    TO_DAYS(T0.closedate) - TO_DAYS(T0.date) AS Dias_ate_fechar,
    TIMESTAMPDIFF(MINUTE, T0.date, T0.closedate) AS Minutos_ate_Fechamento,
    CAST(T0.takeintoaccountdate AS DATE) AS Dia_da_Atribuicao,
    CAST(T0.takeintoaccountdate AS TIME) AS Hora_da_Atribuicao,
    TIMESTAMPDIFF(MINUTE, T0.date, T0.takeintoaccountdate) AS Minutos_ate_Atribuicao,
    TO_DAYS(T0.takeintoaccountdate) - TO_DAYS(T0.date) AS Dias_ate_Atribuir,
    CONCAT(FLOOR(TIMESTAMPDIFF(MINUTE, T0.date, T0.takeintoaccountdate) / 60), 'H, ', 
           TIMESTAMPDIFF(MINUTE, T0.date, T0.takeintoaccountdate) MOD 60, 'M') AS Tempo_ate_Atribuicao,
    T3.completename AS Categoria,
    CASE 
        WHEN T0.status = 1 THEN 'Novo'
        WHEN T0.status = 2 THEN 'Em andamento (Atribuído)'
        WHEN T0.status = 3 THEN 'Planejado'
        WHEN T0.status = 4 THEN 'Pendente (Aguardando)'
        WHEN T0.status = 5 THEN 'Solucionado'
        WHEN T0.status = 6 THEN 'Fechado'
        ELSE 'Status Desconhecido'
    END AS Status,
    CASE 
        WHEN T0.priority = 1 THEN 'Muito Baixa'
        WHEN T0.priority = 2 THEN 'Baixa'
        WHEN T0.priority = 3 THEN 'Media'
        WHEN T0.priority = 4 THEN 'Alta'
        WHEN T0.priority = 5 THEN 'Muito Alta'
        WHEN T0.priority = 6 THEN 'Urgente'
        ELSE 'Prioridade Desconhecida - Falar com Responsaveis'
    END AS Prioridade,
    CONCAT(T8.firstname, ' ', T8.realname) AS Aberto_Por,
    CONCAT(T2.firstname, ' ', T2.realname) AS Ultima_Atualizacao_Por,
    CONCAT(T5.firstname, ' ', T5.realname) AS Tecnico_responsavel,
    COALESCE(T7.total, 1) AS Numero_de_Interacoes
FROM glpi_tickets T0
LEFT JOIN glpi_users T1 ON T0.users_id_recipient = T1.id
LEFT JOIN glpi_users T2 ON T0.users_id_lastupdater = T2.id
LEFT JOIN glpi_itilcategories T3 ON T0.itilcategories_id = T3.id
LEFT JOIN (
    SELECT tickets_id, users_id 
    FROM glpi_tickets_users 
    WHERE type = 2 
    GROUP BY tickets_id
) T4 ON T0.id = T4.tickets_id
LEFT JOIN glpi_users T5 ON T4.users_id = T5.id
LEFT JOIN (
    SELECT tickets_id, users_id 
    FROM glpi_tickets_users 
    WHERE type = 1 
    GROUP BY tickets_id
) T9 ON T0.id = T9.tickets_id
LEFT JOIN glpi_users T8 ON T9.users_id = T8.id
JOIN glpi_locations T6 ON T0.locations_id = T6.id
LEFT JOIN (
    SELECT items_id, COUNT(*) AS total 
    FROM glpi_itilfollowups 
    GROUP BY items_id
) T7 ON T0.id = T7.items_id;
