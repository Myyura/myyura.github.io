#!/usr/bin/env python
#-*- coding: utf-8 -*-
# ******************************************************************************
# 程序名称:     @@des_table@@.py
# 功能描述:     @@desc@@
# 输入参数:     日期, 固定格式为YYYYMMDD
# 目标表名:     @@des_db@@::@@des_table@@
# 数据源表:     ${src_db}::${src_table}
# 创建人名:     joshualeung
# 版本说明:     v1.0
# 公司名称:     tencent
# 修改人名:
# 修改日期:
# 修改原因:
# ******************************************************************************

db       =  __import__("Database")
string   =  __import__("string")
time        = __import__('time')
datetime    = __import__('datetime')
calendar = __import__('calendar')

CREATE_TABLE_SQL = '''
${create_table_sql}
'''

class Config:
    des_db = "@@des_db@@"
    des_table = "@@des_table@@"
    
    
    clear_statement = '''
    DELETE
    FROM
        ${result_table}
    WHERE
        ftime = ${stat_date}
    '''

    sql_template = '''
@@update_sql@@
'''

def clear(tdw, cur_date):
    sql = Config.clear_statement
    sql = string.Template(sql).substitute(result_table = Config.des_table
                                    , stat_date = cur_date)
    tdw.WriteLog('clear with sql: \n' + sql)
    db.execute(tdw, sql)
    
def extract_data(tdw, cur_date):
    sql = Config.sql_template
    sql = string.Template(sql).substitute(stat_date = cur_date, result_table = Config.des_table)
    tdw.WriteLog('extract data with sql: \n' + sql) 
    db.execute(tdw, sql)

# main entry
def TDW_PL(tdw, argv=[]):
    tdw.WriteLog('script started...')
    
    if len(argv) < 1:
        tdw.WriteLog('no date argument found. exited.')
        return
    
    current_date = argv[0]
    if current_date == '' :
        tdw.WriteLog('invalid date. exited.')
        return 
    db._debug  = 0
    db.setDatabase(tdw, Config.des_db)
    clear(tdw, current_date)
    extract_data(tdw, current_date)
    