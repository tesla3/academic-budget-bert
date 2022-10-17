#!/usr/bin/env bash
<<\c
#clean up empty lines
for i in wiki1m_shard/*; do
	sed '/^$/d' -i $i
done
c

<<\c
for i in wiki1m_shard//*; do
    gawk 'NF >= 5' $i > wiki1m_shard_longer_than_5_words/$(basename $i)
done
c

<<\c
#inspect the number words in each line
cat wiki1m_shard_longer_than_5_words/*.txt  |gawk '{print NF}' |sort |uniq -c |sort -k2n |less
c

	
