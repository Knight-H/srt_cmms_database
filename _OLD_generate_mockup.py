document_type_group = """101	นำอะไหล่เข้าโดยมีใบสั่งซื้อ
102	คืนอะไหล่
103	นำอะไหล่เข้า
111	เบิกอะไหล่ไปใช้งาน
112	นำอะไหล่ออก
121	เบิก/โอนย้ายอะไหล่
131	คืนอะไหล่ส่งซ่อม
132	ส่งซ่อมอะไหล่
141	ตรวจนับสินค้า
142	ปรับปรุงจำนวนอะไหล่
151	คืนซากอะไหล่
152	จำหน่ายซากอะไหล่"""

document_type_group = [line.split("\t") for line in document_type_group.splitlines()]
print(document_type_group)

ALL_WAREHOUSE = ["คลังพัสดุกลางบางซื่อ", "คลังอื่นๆ", "คลังของตอน"]

print()
print("Table: document_type")
for _id, _name in document_type_group:
    if _id == '121': # IV Transfer
        i = 1
        for _wh_from in ALL_WAREHOUSE:
            for _wh_to in ALL_WAREHOUSE:
                # Ignore Central WH sending to itself (only 1)
                if _wh_from == "คลังพัสดุกลางบางซื่อ" and _wh_from == _wh_to: continue
                # Special case ตอน -> ตอน Inside แขวง or not!!
                if _wh_from == "คลังของตอน" and _wh_from == _wh_to:
                    print(f"{_id}{i}\t{_name} {_wh_from}->{_wh_to} แขวงเดียวกัน")
                    i += 1
                    print(f"{_id}{i}\t{_name} {_wh_from}->{_wh_to} ต่างแขวง")
                else:
                    print(f"{_id}{i}\t{_name} {_wh_from}->{_wh_to}")
                i += 1
    elif _id == '151': #คืนซาก
        i = 1
        print(f"{_id}{i}\t{_name} คลังอื่นๆ->คลังพัสดุกลางบางซื่อ")
        i += 1
        print(f"{_id}{i}\t{_name} คลังของตอน->คลังพัสดุกลางบางซื่อ")
    elif _id == '152': #จำหน่ายซากอะไหล่
        i = 1
        print(f"{_id}{i}\t{_name} คลังพัสดุกลางบางซื่อ")
##    elif _id == '132': # ส่งซ่อมอะไหล่  -- doesn't make sense to change doc types over time
##        i = 1
##        for _wh in ALL_WAREHOUSE:
##            if _wh == "คลังของตอน":
##                print(f"{_id}{i}\t{_name} {_wh} ตอนดำเนินการซ่อม")
##                i += 1
##                print(f"{_id}{i}\t{_name} {_wh} แขวงดำเนินการซ่อม")
##                i += 1
##                print(f"{_id}{i}\t{_name} {_wh} กองดำเนินการซ่อม")
##                i += 1
##                print(f"{_id}{i}\t{_name} {_wh} กอง(ซ่อม)ดำเนินการซ่อม")
##                i += 1
##                continue
##            print(f"{_id}{i}\t{_name} {_wh}")
            i += 1
    else:
        for _idd, _wh in enumerate(ALL_WAREHOUSE):
            print(f"{_id}{_idd+1}\t{_name} {_wh}")

print()
print("Table: document_type_approval_process_lookup")
for _id, _name in document_type_group:
    if _id == '121': # IV Transfer
        i = 1
        for _wh_from in ALL_WAREHOUSE:
            for _wh_to in ALL_WAREHOUSE:
                # Ignore Central WH sending to itself (only 1)
                if _wh_from == "คลังพัสดุกลางบางซื่อ" and _wh_from == _wh_to: continue
                # Special case ตอน -> ตอน Inside แขวง or not!!
                if _wh_from == "คลังของตอน" and _wh_from == _wh_to:
                    print(f"{_name} {_wh_from}->{_wh_to} แขวงเดียวกัน DEFAULT")
                    i += 1
                    print(f"{_name} {_wh_from}->{_wh_to} ต่างแขวง DEFAULT")
                else:
                    print(f"{_name} {_wh_from}->{_wh_to} DEFAULT")
                i += 1
    elif _id == '151': #คืนซาก
        i = 1
        print(f"{_name} คลังอื่นๆ->คลังพัสดุกลางบางซื่อ DEFAULT")
        i += 1
        print(f"{_name} คลังของตอน->คลังพัสดุกลางบางซื่อ DEFAULT")
    elif _id == '152': #จำหน่ายซากอะไหล่
        i = 1
        print(f"{_name} คลังพัสดุกลางบางซื่อ DEFAULT")
    else:
        for _idd, _wh in enumerate(ALL_WAREHOUSE):
            print(f"{_name} {_wh} DEFAULT")

