import glob
import pandas as pd
import numpy as np
import datetime


EXCEL_FILES = glob.glob('*.xlsx')
SQL_COMMAND = ""


def _str_from_data(data):
    if type(data) == int:
        return str(data)
    elif 'DEFAULT' == data:
        return 'DEFAULT'
    elif type(data) == str:
        return f"'{data}'"
    elif pd.isnull(data):
        return "NULL"
    elif type(data) is datetime.date:
        return f'"{data.strftime("%Y%m%d")}"'
    elif type(data) is datetime.datetime:
        if data.time() == datetime.time(0): #check if time has 0 info
            return f'"{data.strftime("%Y%m%d")}"'
        return f'"{data.strftime("%Y%m%d %I:%M:%S %p")}"'
    else:
        return str(data)

for file in EXCEL_FILES:
    sheets = pd.read_excel(file, sheet_name=None, header=None) # return all sheets
    for sheet_name, df in sheets.items():
        print(f"Unpacking {sheet_name}...")

        NEXT_IS_VALUE_NAMES = False
        NEXT_IS_VALUE       = False
        CURRENT_VALUE_NAMES = []

        
        # For all rows in the sheet
        for index,row in df.iterrows():
            # Check New Table
            if ('table' in str(row[1]).lower() and row[2]):
                _table_name = row[2].strip()
                print(f"\t{_table_name}")
                SQL_COMMAND += f"INSERT INTO {_table_name} "
                NEXT_IS_VALUE_NAMES = True
                continue
            if NEXT_IS_VALUE_NAMES:
                _value_names = row[~row.isnull()]
                CURRENT_VALUE_NAMES = _value_names
                SQL_COMMAND += f"({','.join(_value_names)})\nVALUES"
                NEXT_IS_VALUE_NAMES = False
                NEXT_IS_VALUE = True
                continue
            if NEXT_IS_VALUE:
                if (pd.isnull(row[1])):
                    SQL_COMMAND = SQL_COMMAND[:-1] + ";\n\n" #Remove comma
                    NEXT_IS_VALUE = False
                    CURRENT_VALUE_NAMES = []
                    continue
                else:
                    _values = row[1:len(CURRENT_VALUE_NAMES)+1]
                    SQL_COMMAND += f"\n\t({','.join(map(_str_from_data, _values))}),"
                    continue
        SQL_COMMAND = SQL_COMMAND[:-1] + ";\n\n" #Remove comma

print(SQL_COMMAND)
