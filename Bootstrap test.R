##bootstrap test
for i in `seq 1 1000`
do
shuf -n166 -r clean.fam > test${i} #sampling with put back
awk '{print $1,$2}' test${i} > tmp${i}
awk '{print $6}' test${i} > phe${i}
done
## GWAS for 1000 times
for j in `seq 1 1000`
do
  for i in `seq 1 166`
  do
  sed -n ''"$i"'p' tmp${j} > p${i} 
  plink -bfile clean --keep p${i} --make-bed --out tmp${i}
  awk '{print '"$i"','"$i"',$3,$4,$5,$6}' tmp${i}.fam > test${i}.fam
  mv test${i}.fam tmp${i}.fam
  rm p${i}
  done
 plink --bfile tmp1 --merge-list merge_id --allow-no-sex --make-bed --out Newdata${j}
 rm tmp*
 $gemma -bfile Newdata${j} -gk 1 -o result${j}
 $gemma -bfile Newdata${j} -k /sevzone/home/xuwenwu/bootstrap_test/output/result${j}.cXX.txt -lmm 4 -n 1 -o result${j}
done

##result statistic
for i in `seq 1 1000`
do
cat result${i}.assoc.txt | awk '{if($13 <= 1.48e-7) print '"$i"',$3,$13}' | sort -gk2  >> target_all
done

awk '{if($2 >= 5731847 && $2 <= 5732809) print $0}' target_all > tmp
awk '{print $1}' tmp | sort | uniq | wc

