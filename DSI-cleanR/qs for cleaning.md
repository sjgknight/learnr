Key concepts to learn:

1. Missing values (and the range of these)
2. Whitespace around values
3. Inconsistent data type
4. Disambiguation of named entities (x and y are different entities with common identifying feaure)
5. Data entity naming conventions (and data dictionaries) (x and y are the same entity with inconsistent names)
5. Sensechecking on an external source
6. 
  

The file includes (1) an encoding issue, (2) stupid values in every column, (3) missing values, repetition, whitespace, etc. (4) ...



1.	How many rows should the North American country that isn’t Canada have?
* I make 46047 after all merges and a scan

2. Where has the most students? (Are the first answers you find plausible?) * Unversity of Cincinnati comes up with 3,198,523,096 a quick google indicates it should be 26,608. The next ones down are also ridiculous (although CalState system is v large). Sorting on num students is probably the best bet here (excluding the very large values).

3. Which college is the most recently (uhum) established one?  Skidmore & * Concordia clearly wrong, there are a bunch in 2011

4. Where has the largest endowment for the smallest number of faculty?
* 