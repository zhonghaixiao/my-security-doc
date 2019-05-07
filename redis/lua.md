## lua and redis 数据类型转换
1. redis.call() redis.pcall()   redis --> lua
2. lua return v                 lua --> redis

## redis to lua
redis integer -> lua number
redis bulk reply -> lua string
redis multi bulk reply -> lua table
redis status reply -> lua table width a single ok field
redis error reply -> lua table width a single err field
redis Nil bulk reply, Nil numti bulk reply -> lua false boolean type

### lua to redis


### script flush


































