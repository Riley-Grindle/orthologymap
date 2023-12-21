params.fasta = ""
params.out_dir = ""
params.sup_info = ""
params.project_id = ""


process TREEGRAFTER {
    tag "Grafting $project_id"
    label 'process_single'
    publishDir "Run_results/TREE-results", mode: 'copy'


    input:
    val fasta
    val out_dir
    val sup_info
    val project_id
    // val bash_path - copy bash script into panther working dir - run bash script

    output:
    
    path "*.out"

    script:

    """
    docker run --rm --name treegrafter -v $fasta:/sample -v ./:/output -v $sup_info:/opt/supplemental ningzhithm/treegrafter:1.01 -f /sample/human_ch2_9genes.fasta -o /output/$project_id\.out -cpus ${task.cpus} -d /opt/supplemental -auto
    """

    stub:
    """
    touch $fasta

    """

}

workflow{
    TREEGRAFTER(params.fasta, params.out_dir, params.sup_info, params.project_id)
}

