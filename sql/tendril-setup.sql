

drop event if exists tendril_purge_global_status_log;
create event tendril_purge_global_status_log
    on schedule every 1 minute starts date(now()) + interval 10 second
    do delete from global_status_log where stamp < now() - interval 1 week limit 50000;

drop event if exists tendril_purge_client_statistics_log;
create event tendril_purge_client_statistics_log
    on schedule every 1 minute starts date(now()) + interval 20 second
    do delete from client_statistics_log where stamp < now() - interval 1 week limit 10000;

drop event if exists tendril_purge_index_statistics_log;
create event tendril_purge_index_statistics_log
    on schedule every 1 minute starts date(now()) + interval 30 second
    do delete from index_statistics_log where stamp < now() - interval 1 week limit 10000;

drop event if exists tendril_purge_table_statistics_log;
create event tendril_purge_table_statistics_log
    on schedule every 1 minute starts date(now()) + interval 40 second
    do delete from table_statistics_log where stamp < now() - interval 1 week limit 10000;

drop event if exists tendril_purge_user_statistics_log;
create event tendril_purge_user_statistics_log
    on schedule every 1 minute starts date(now()) + interval 50 second
    do delete from user_statistics_log where stamp < now() - interval 1 week limit 10000;

drop event if exists tendril_purge_slave_status_log;
create event tendril_purge_slave_status_log
    on schedule every 1 minute starts date(now()) + interval 25 second
    do delete from slave_status_log where stamp < now() - interval 1 week limit 50000;

delimiter ;;

drop event if exists tendril_purge_processlist_query_log;
create event tendril_purge_processlist_query_log
    on schedule every 1 minute starts date(now()) + interval 35 second
    do begin

        delete from processlist_query_log where stamp < now() - interval 1 week limit 50000;
        delete from processlist_query_log where stamp < now() - interval 1 day and time < 5 limit 50000;

    end ;;

drop event if exists tendril_slave_status_logger;
create event tendril_slave_status_logger
    on schedule every 1 minute starts date(now()) + interval 15 second
    do begin

    if (get_lock('tendril_slave_status_logger', 1) = 0) then
        signal sqlstate value '45000' set message_text = 'get_lock';
    end if;

    insert ignore into strings (string)
        select distinct lower(variable_name) from slave_status
            where variable_value regexp('(^[0-9]+$)');

    insert into slave_status_log
        select server_id, now(), strings.id, variable_value from slave_status
            join strings on lower(variable_name) = lower(string)
            where variable_value regexp('(^[0-9]+$)');

    update servers s
        left join global_variables gv on s.id = gv.server_id and gv.variable_name = 'server_id'
        left join slave_status ss  on s.id = ss.server_id  and ss.variable_name = 'master_server_id'
        left join slave_status ss2 on s.id = ss2.server_id and ss2.variable_name = 'master_port'
        set s.m_server_id = gv.variable_value, s.m_master_id = ss.variable_value, s.m_master_port = ss2.variable_value;

    do release_lock('tendril_slave_status_logger');
    end ;;

delimiter ;
