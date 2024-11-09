SELECT
    T0.id AS 'ID Chamado',
    T0.name AS 'Assunto do Ticket',
    DATE(T0.date) AS 'Data Abertura',
    TIME(T0.date) AS 'Hora Abertura',
    DATE(T0.solvedate) AS 'Data Solução',
    TIME(T0.solvedate) AS 'Hora Solução',
    DATE(T0.closedate) AS 'Data Fechamento',
    TIME(T0.closedate) AS 'Hora Fechamento',
    DATE(T0.begin_waiting_date) AS 'Dia da Atribuição',
    TIME(T0.begin_waiting_date) AS 'Hora da Atribuição',
    DATEDIFF(T0.begin_waiting_date, T0.date) AS 'Dias até Atribuir',
CONCAT(
        FLOOR(TIMESTAMPDIFF(MINUTE, T0.date, T0.begin_waiting_date) / 60), 'H, ',
        MOD(TIMESTAMPDIFF(MINUTE, T0.date, T0.begin_waiting_date), 60), 'M'
    ) AS 'Tempo até Atribuição',
    T3.completename AS 'Categoria',
    CASE 
        WHEN T0.status = 1 THEN 'Novo'
        WHEN T0.status = 2 THEN 'Em andamento (Atribuído)'
        WHEN T0.status = 3 THEN 'Planejado'
        WHEN T0.status = 4 THEN 'Pendente (Aguardando)'
        WHEN T0.status = 5 THEN 'Solucionado'
        WHEN T0.status = 6 THEN 'Fechado'
        ELSE 'Status Desconhecido'
    END AS 'Status',
    CONCAT(T1.firstname, ' ', T1.realname) AS 'Aberto Por',
    CONCAT(T2.firstname, ' ', T2.realname) AS 'Ultima Atualizaçao Por',
    CONCAT(T5.firstname, ' ', T5.realname) AS 'Técnico que atendeu',
    DATEDIFF(T0.solvedate, T0.date) AS 'Dias até solução',
    DATEDIFF(T0.closedate, T0.date) AS 'Dias até fechar',
    CONCAT(
        FLOOR(TIMESTAMPDIFF(MINUTE, T0.date, T0.closedate) / 60), 'H, ',
        MOD(TIMESTAMPDIFF(MINUTE, T0.date, T0.closedate), 60), 'M'
        ) AS 'Hrs em aberto'
FROM
    glpi_tickets AS T0
	INNER JOIN glpi_users AS T1 ON T0.users_id_recipient = T1.id
	INNER JOIN glpi_users AS T2 ON T0.users_id_lastupdater = T2.id
	INNER JOIN glpi_itilcategories AS T3 ON T0.itilcategories_id = T3.id
    LEFT JOIN (SELECT tickets_id, users_id FROM glpi_tickets_users WHERE type = 2 GROUP BY tickets_id) AS T4 ON T0.id = T4.tickets_id
    LEFT JOIN glpi_users AS T5 ON T4.users_id = T5.id
    
    