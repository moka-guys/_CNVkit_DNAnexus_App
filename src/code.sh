#!/bin/bash
# Automate_duty_v2.0.0
# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail
### Set up parameters
# split project name to get the NGS run number(s)
#run=$(echo $project_name |  sed -n 's/^.*_\(NGS.*\)\.*/\1/p') 

# Location of the Automate_Duty docker file
docker_file=project-GFZQYVQ064pQvpBq4v34698Q:file-GFbpBZ8064pqPbzxB1VbXgx2

# Project type. Options are WES, SNP, MokaPipe and TSO500



#read the DNA Nexus api key as a variable
DNAnexus_auth_token=$(dx cat project-FQqXfYQ0Z0gqx7XG9Z2b4K43:DNAnexus_read_only_auth_token)
# make folder to hold downloaded files
echo $DNAnexus_auth_token
#mkdir to_test
# cd to test dir
# download the docker file from 001_Tools...(after testing)
dx download $docker_file --auth "${DNAnexus_auth_token}"
docker load -i '/home/dnanexus/cnvkit_docker.tgz'
#mark-section "Run the python script"
# docker run - mount the home directory as a share

if [[ $type_of_analysis=="create_coverage_for_PoN" ]]; then
    mkdir /home/dnanexus/out
    mkdir /home/dnanexus/out/coverage
    mkdir /home/dnanexus/out/coverage/Data
    mkdir /home/dnanexus/out/coverage/Data/coverage_normals
    chmod 777 /home/dnanexus/out/coverage/Data/coverage_normals
    mkdir /home/dnanexus/Data
    mkdir /home/dnanexus/Data/Controls_spleen
    mkdir /home/dnanexus/Data/target_bed
    cd /home/dnanexus/Data/Controls_spleen
    pwd
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gk8802g8xJP9694PZ2K6V
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gk8j02g8QYGGz1763K5k9
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gk9Q02g8fP0g7Bzkp5zp1
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkG802g8bBqgjF2JJq8xp
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkP002g8Z65JvFBQGb89z
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkQj02g8X1G0yBxY4Y46Y
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkX802g8Q12jXBz85Qv9P
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkY002g8bBqgjF2JJq8y4

    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gk8802g8Xv36gByXFVyq8
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gk8j02g8vFj7qF5X3B0Q3
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkB802g8bBqgjF2JJq8xj
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkGj02g8qVZbk8x9ykBPq
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkP002g8bJ28ZGfQP0g09
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkV002g8b5Q1qF7bqpbvB
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkXj02g8b2800G05Y0Z9P
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-G74gkY802g8zxf4yF621xG6x
    cd ..
    cd /home/dnanexus/Data/target_bed
    pwd
    dx download project-GFZQYVQ064pQvpBq4v34698Q:file-GFk85pj064pkvkv64YpzY5px
    ls
    cd ..
    ls
    cd ..
    echo "Running coverage for Panel of Normals"
    for entry in /home/dnanexus/Data/Controls_spleen/*.bam
    do
    new_entry="${entry/"home/dnanexus/Data"/"Data"}"
    new_entry2="${new_entry/"/Data/Controls_spleen"/"/output/coverage/Data/coverage_normals"}"

    docker run --rm \
        -v /home/dnanexus/Data:/Data \
        -v /home/dnanexus/out:/output \
        etal/cnvkit:latest \
        cnvkit.py coverage \
        $new_entry \
        /Data/target_bed/selected_genes_for_TSO500_CNV_project.bed \
        -o "${new_entry2/".bam"/"_normal.targetcoverage.cnn"}" 
    done
    dx-upload-all-outputs --parallel

elif [[ $type_of_analysis=="create_PoN" ]]; then
    echo "Generating Panel of Normals cnn file"
    docker run --rm -ti -v \
    /Data/:/Data \
    etal/cnvkit:latest \
    cnvkit.py reference \
    /Data/coverage_normals/ \
    --fasta /Data/Reference_Genome/hg19.fa \
    --output /Generating_PoN_test/normal/cnvkit_0.9.9_PoN.cnn

else
    echo "carry_out_Analysis"
    
fi


