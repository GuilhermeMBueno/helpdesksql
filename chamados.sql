SELECT
    T0.id AS 'ID Chamado',
    T0.name AS 'Assunto do Ticket',
    DATE(T0.date) AS 'Data Abertura',
    TIME(T0.date) AS 'Hora Abertura',
    DATE(T0.solvedate) AS 'Data Solução',
    TIME(T0.solvedate) AS 'Hora Solução',
    DATE(T0.closedate) AS 'Data Fechamento',
    TIME(T0.closedate) AS 'Hora Fechamento',
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
    CONCAT(T2.firstname, ' ', T2.realname) AS 'Ultima Atualizaçao Por'
FROM
   	glpi_tickets AS T0
	INNER JOIN glpi_users AS T1 ON T0.users_id_recipient = T1.id
	INNER JOIN glpi_users AS T2 ON T0.users_id_lastupdater = T2.id
	