SELECT
    T0.id AS 'ID Chamado',
    T0.name AS 'Assunto do Ticket',
    COALESCE(T3.completename, 'Sem Localizacao') AS 'Localização',
    CASE
        WHEN `T0`.`priority` = 1 THEN 'Muito Baixa'
        WHEN `T0`.`priority` = 2 THEN 'Baixa'
        WHEN `T0`.`priority` = 3 THEN 'Media'
        WHEN `T0`.`priority` = 4 THEN 'Alta'
        WHEN `T0`.`priority` = 5 THEN 'Muito Alta'
        WHEN `T0`.`priority` = 6 THEN 'Urgente'
        ELSE 'Prioridade Desconhecida - Falar com T.I'
    END AS `Prioridade`,
    DATE(T0.date) AS 'Data Abertura',
    TIME(T0.date) AS 'Hora Abertura',
    DATE(T0.solvedate) AS 'Data Solução',
    TIME(T0.solvedate) AS 'Hora Solução',
    TIMESTAMPDIFF(MINUTE, T0.date, T0.solvedate) AS 'Minutos até Solução',
    DATE(T0.closedate) AS 'Data Fechamento',
    TIME(T0.closedate) AS 'Hora Fechamento',
    TIMESTAMPDIFF(MINUTE, T0.date, T0.closedate) AS 'Minutos até Fechamento',
    DATE(T0.begin_waiting_date) AS 'Dia da Atribuição',
    TIME(T0.begin_waiting_date) AS 'Hora da Atribuição',
    DATEDIFF(T0.begin_waiting_date, T0.date) AS 'Dias até Atribuir',
    TIMESTAMPDIFF(MINUTE, T0.date, T0.begin_waiting_date) AS 'Minutos até Atribuição',
CONCAT(
        FLOOR(TIMESTAMPDIFF(MINUTE, T0.date, T0.begin_waiting_date) / 60), 'H, ',
        MOD(TIMESTAMPDIFF(MINUTE, T0.date, T0.begin_waiting_date), 60), 'M'
    ) AS 'Tempo até Atribuição',
    COALESCE(T2.completename, 'Sem Categoria') AS 'Categoria',
    CASE
        WHEN `T0`.`status` = 1 THEN 'Novo'
        WHEN `T0`.`status` = 2 THEN 'Em andamento (Atribuído)'
        WHEN `T0`.`status` = 3 THEN 'Planejado'
        WHEN `T0`.`status` = 4 THEN 'Pendente (Aguardando)'
        WHEN `T0`.`status` = 5 THEN 'Solucionado'
        WHEN `T0`.`status` = 6 THEN 'Fechado'
        ELSE 'Status Desconhecido'
    END AS `Status`,
    CONCAT(T4.firstname, ' ', T4.realname) AS 'Aberto Por',
    concat(`T5`.`firstname`, ' ', `T5`.`realname`) AS `Ultima Atualizaçao Por`,
    concat(`T7`.`firstname`, ' ', `T7`.`realname`) AS `Técnico responsável`,
    CASE
        WHEN cast(`T0`.`closedate` as date) is not null
        AND `T7`.`total` is null then 1
        ELSE `T7`.`total`
    END AS `Numero de Interacoes`
FROM
    glpi_tickets AS T0
    LEFT JOIN glpi_itilcategories AS T2 ON T0.itilcategories_id = T2.id
    LEFT JOIN glpi_locations AS T3 ON T0.locations_id = T3.id
    LEFT JOIN glpi_users AS T4 ON T0.users_id_recipient = T4.id
    LEFT JOIN glpi_users AS T5 on T0.users_id_lastupdater = T5.id
    LEFT JOIN (
    select
        `GLPI_grupofarina`.`glpi_tickets_users`.`tickets_id` AS `tickets_id`,
        `GLPI_grupofarina`.`glpi_tickets_users`.`users_id` AS `users_id`
    from
        `GLPI_grupofarina`.`glpi_tickets_users`
    where
        `GLPI_grupofarina`.`glpi_tickets_users`.`type` = 2
    group by
        `GLPI_grupofarina`.`glpi_tickets_users`.`tickets_id`) `T6` on
    (`T0`.`id` = `T6`.`tickets_id`)
    LEFT JOIN glpi_users AS T7 ON T6.users_id = T7.id
    LEFT JOIN (
    select
        `GLPI_grupofarina`.`glpi_itilfollowups`.`items_id` AS `items_id`,
        count(0) AS `total`
    from
        `GLPI_grupofarina`.`glpi_itilfollowups`
    group by
        `GLPI_grupofarina`.`glpi_itilfollowups`.`items_id`) `T7` on
    (`T0`.`id` = `T7`.`items_id`)
ORDER BY T0.id DESC;
