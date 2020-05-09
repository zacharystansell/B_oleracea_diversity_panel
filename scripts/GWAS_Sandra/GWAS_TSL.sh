#generate K matrix for MLM
perl /media/biolinuxuser/DataDrive1/bin/tassel-5-standalone/run_pipeline.pl -Xms50g -Xmx100g -importGuess sub123_sorted.vcf -KinshipPlugin -method Centered_IBS -endPlugin -export sub123_kinship.txt -exportType SqrMatrix

#MLM analysis of all traits
#PK model
perl /media/biolinuxuser/DataDrive1/bin/tassel-5-standalone/run_pipeline.pl -Xms100g -Xmx200g -fork1 -importGuess sub123_sorted.vcf -filterAlign -filterAlignMinFreq 0.05 -fork2 -r sub123_wehnerTSL.txt -fork3 -r sub123_PCs.txt -fork4 -k sub123_kinship.txt -combine5 -input1 -input2 -input3 -intersect -combine6 -input5 -input4 -mlm -mlmVarCompEst P3D -mlmCompressionLevel Optimum -export mlm_out -runfork1 -runfork2 -runfork3 -runfork4
#K model
perl /media/biolinuxuser/DataDrive1/bin/tassel-5-standalone/run_pipeline.pl -Xms100g -Xmx200g -fork1 -importGuess sub123_sorted.vcf -filterAlign -filterAlignMinFreq 0.05 -fork2 -r sub123_aac.txt -fork3  -k sub123_kinship.txt -combine4 -input1 -input2 -intersect -combine5 -input4 -input3 -mlm -mlmVarCompEst P3D -mlmCompressionLevel Optimum -export mlm_out -runfork1 -runfork2 -runfork3

#GLM
perl /media/biolinuxuser/DataDrive1/bin/tassel-5-standalone/run_pipeline.pl -Xms100g -Xmx200g -fork1 -importGuess sub123_sorted.vcf -FilterSiteBuilderPlugin -siteMinAlleleFreq 0.05 -endPlugin -fork2 -importGuess sub123_aac.txt -combine5 -input1 -input2 -intersect -FixedEffectLMPlugin -endPlugin -export glm_aac_out
