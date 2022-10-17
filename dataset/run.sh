#!/usr/bin/env bash
<<\c
#clean up empty lines
for i in wiki1m_shard/*; do
	sed '/^$/d' -i $i
done
c
<<\c
python process_data.py --n_processes 32  -f enwiki-20221001/enwiki-20221001-pages-articles-multistream.xml -o enwiki_all --type wiki
c
<<\c
head -n 1000000 enwiki_all/wiki_one_article_per_line.txt  > enwiki_1mm/wiki_one_article_per_line.1mm.txt
c

# try out 1mm articles
<<\c
python shard_data.py \
    --dir enwiki_1mm \
    -o enwiki_1mm_shards \
    --num_train_shards 256 \
    --num_test_shards 128 \
    --frac_test 0.1
c
<<\c
for i in enwiki_1mm_shard*/*; do
    gawk 'NF >= 5' $i > enwiki_1mm_shards_longer_than_5_words/$(basename $i)
done
c

<<\c
python generate_samples.py \
    --dir enwiki_1mm_dev \
    -o enwiki_1mm_masked \
    --dup_factor 3 \
    --seed 42 \
    --vocab_file ../vocabs/bert-base-uncased-vocab.txt \
    --do_lower_case 1 \
    --masked_lm_prob 0.15 \
    --max_seq_length 128 \
    --model_name bert-base-uncased \
    --max_predictions_per_seq 20 \
    --n_processes 32
c
# try out 1mm articles


# full wiki
#share_data.py put everything into memroy. Have to split my data first, otherwise, we will use swap and slow to death.
<<\c
split -l 3000000 -d --additional-suffix ".txt" all/wiki_one_article_per_line.txt
c

<<\c
for i in {00..11}; do 
    mkdir enwiki_all/$i
    mv enwiki_all/x$i.txt enwiki_all/$i/
done
c
<<\c
for i in {00..11}; do 
    echo "running $i shard"
    python shard_data.py \
        --dir enwiki_all/$i \
        -o enwiki_all_shards/$i \
        --num_train_shards 256 \
        --num_test_shards 128 \
        --frac_test 0.1
done
c

<<\c

for i in {0..127}; do
    mkdir -p merge_shards/test/$i
    cd merge_shards/test/$i
    for j in {00..11}; do
        ln -s ../../../enwiki_all_shards/$j/test${i}.txt ${j}.txt
    done
    cd -

    python merge_shards.py \
        --data merge_shards/test/$i \
        --output_dir merge_shards/test/$i \
        --ratio 12 \

done
c

<<\c
for i in {0..255}; do
    mkdir -p merge_shards/train/$i
    cd merge_shards/train/$i
    for j in {00..11}; do
        ln -s ../../../enwiki_all_shards/$j/training${i}.txt ${j}.txt
    done
    cd -

    python merge_shards.py \
        --data merge_shards/train/$i \
        --output_dir merge_shards/train/$i \
        --ratio 12 \

done
c
<<\c
[ -d merge_shard_all ] || mkdir -p merge_shard_all/
for i in {0..127}; do
    cd  merge_shard_all/
    ln -s ../merge_shards/test/$i/shard_0.txt test$i.txt
    cd -
done

for i in {0..255}; do
    cd  merge_shard_all/
    ln -s ../merge_shards/train/$i/shard_0.txt training$i.txt
    cd -
done
c


<<\c
python generate_samples.py \
    --dir merge_shard_all \
    -o enwiki_all_masked \
    --dup_factor 3 \
    --seed 42 \
    --vocab_file ../vocabs/bert-base-uncased-vocab.txt \
    --do_lower_case 1 \
    --masked_lm_prob 0.15 \
    --max_seq_length 128 \
    --model_name bert-base-uncased \
    --max_predictions_per_seq 20 \
    --n_processes 16
c
