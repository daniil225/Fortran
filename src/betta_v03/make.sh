

echo "Menu:"
echo "1: Запустить matrix_betta_v03_1_dat.for"
echo "2: Запустить txt_to_dat.for"
echo "3: Запустить matrix_betta_v03.for"
echo "4: Запустить dat_to_txt.for"
echo "5: Запустить make_big_test.for"

read n

case $n in
1) 
gfortran -std=legacy -o mat_dat matrix_betta_v03_1_dat.for
./mat_dat
rm mat_dat
;;
2) 
gfortran -std=legacy -o txt txt_to_dat.for
./txt
rm txt
;;
3)
gfortran -std=legacy -o mat matrix_betta_v03.for
./mat
rm mat
;;
4)
gfortran -std=legacy -o dat dat_to_txt.for
./dat
rm dat
;;
5)
gfortran -std=legacy -o test make_big_test.for
./test
rm test
;;
*)
exit 0


esac
