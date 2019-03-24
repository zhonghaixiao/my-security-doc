echo "----演示---"
for i in "$*"; do
    echo $i
done

for i in "$@"; do
    echo $i
done

# echo $0 $1 $2  

# array_name=(1 2 3 4 5)
# echo ${array_name[1]}
# echo ${array_name[2]}
# echo "${#array_name[*]}"

# your_name="runoob"
# greeting="hello, "${your_name}" !"
# greeting_1="hello, ${your_name} !"
# echo $greeting, $greeting_1
# greeting_2='hello, '${your_name}'!'
# greeting_3='hello, ${your_name} !'
# echo $greeting_2 $greeting_3

# string="abscd"
# echo ${#string}

# echo ${string:1:3}

# string="runoob is a great site"
# echo `expr index "$string" io`



# echo 'test'
# NAME=zhonghaixiao
# echo ${NAME}
# for skill in Ada Coffe Action; do
#     echo 'I am good at ${skill}Script'
# done
# # readonly NAME
# unset NAME
# # NAME=haixiao
# echo $NAME
# NAME=zhonghaixiao
# str="Hello, I know you are \"$NAME\"! \n"
# echo -e $str


