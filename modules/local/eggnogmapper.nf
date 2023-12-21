

params.path_to_fasta = ""
params.fasta_prefix = ""
params.project_id = ""


process EGGNOGMAPPER {
    tag "Eggnogging $project_id"
    label 'process_long'
    publishDir "Run_results/EGG-results", mode: 'copy'



    input:
    path to_fasta
    val prefix
    val project_id

    output:
    path "*.emapper.seed_orthologs"

    // may need to find a solution to download data via script or import data from s3
    // container size may be too large
    script:
    """
    emapper.py -i $to_fasta/$prefix*.fasta -m diamond -o $project_id --itype proteins --cpu ${task.cpus}
    """

    stub:
    """
    touch $fasta
    """
}

workflow{
    egg_ch = Channel.empty()
    egg_ch = EGGNOGMAPPER(params.path_to_fasta, params.fasta_prefix, params.project_id)
    egg_ch.view()
}
