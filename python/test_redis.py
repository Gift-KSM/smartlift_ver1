import redis
r = redis.Redis(
    host='52.221.67.113',
    password='kuse@fse2023')
#r.delete('Lift-0001')
#r.delete('Lift-0002')

#id,org,name,max_level,lift_state,up_status,down_status,car_status
#r.rpush('Lift-0001','KU CSC','KUSE-01','15','010900000000','00000000','00000000','00000000')
#r.rpush('Lift-0002','SNKTC','SNKTC-01','4','040906000000','00000000','00000000','00000000')
#r.lset('Lift-0001',0,'KU CSC')
value = r.lrange('Lift-0004',0,8)
print(value)
value = r.lrange('Name-0004',0,1)
print(value)
