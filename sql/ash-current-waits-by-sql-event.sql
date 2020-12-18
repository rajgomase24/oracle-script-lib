
-- ash-current-waits-by-sql-event.sql
-- find the current top 20 SQL by execution time per event 
-- that occurred in a single session
-- Jared Still - still@pythian.com jkstill@gmail.com

set pause off echo off
set feed on term on

set pagesize 200
set linesize 200 trimspool on

col wait_class format a20 head 'WAIT CLASS'
col event format a50 head 'EVENT'

col sql_id format a13 head 'SQL ID'
col session_serial# format 99999999 head 'SESSION|SERIAL#'
col sql_time format 999,999,999 head 'SQL TIME(s)'

with sqldata as (
select distinct
	sql_id
	,session_id
	, session_serial#
	, sql_exec_id
	, event
	, count(*) over (partition by sql_id, session_id, session_serial#, sql_exec_id, event) sql_time
from v$active_session_history h
where time_waited != 0
and sql_id is not null
order by 6 desc
)
select sql_id
	, event
	, sql_time
from sqldata
where rownum <= 20
order by sql_time
/

