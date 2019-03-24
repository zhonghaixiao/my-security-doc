## 变量类型
1. 局部变量
2. 环境变量
3. shell变量

## 字符串
1. 单引号中的字符串都原样输出，单引号中的变量名无效
2. 双引号可以有变量，双引号里面可以有转义字符

- expr index "$string" io   查找io的位置

## 数组
array_name=(1 2 3 4 5)
echo ${array_name[1]}
echo ${array_name[2]}
echo "${#array_name[*]}"

## 传递参数
$0 $1 $2
- $# 参数个数
- $* 字符串格式的所有参数
- $$ 进程id
- $$ 后台运行的最有一个进程id
- $@ 同 $*
- $? 显示最后命令的退出状态， 0 表示没有错误

## 关系运算符
- -eq 检测是否相等  
- ne 检测是否不相等
- gt 大于
- lt 小于
- ge 大于等于
- le 小于等于

if [$a -eq $b]
then
    echo "$a -eq $b : a 等于 b"
else
    echo "$a -eq $b : a 不等于 b"
fi

## 布尔运算
- !     [! false]
- -o    [$a -lt 20 -o $b -gt 100]
- -a    [$a -lt 20 -a $b -gt 100]
- 





























