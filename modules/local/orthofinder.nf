
params.fasta = ""
params.project_id = ""
params.aws_path = "s3://mdibl-rgrindle/orthofinder_refs/"

process ORTHOFINDER {
    tag "Orthofinder on $project_id"
    label 'process_high'
    publishDir "Run_results/ORTHOF-results", mode: 'symlink'

    input:
    path fasta
    val project_id

    output:
    path("$fasta/OrthoFinder/Results_*"), emit: ortho_f

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    orthofinder -f $fasta
    """

    stub:
    """
    touch $fasta

    """
}

process PULL_AWS {
    tag "Pulling AWS reference fastas"
    label "process_high"

    input:
    val refs
    path fasta

    output:
    path fasta

    script:
    """
    aws s3 sync $refs $fasta
    echo $fasta
    """


}


workflow{
    ch_fasta = Channel.fromPath(params.fasta)
    ch_fasta_1 = PULL_AWS(params.aws_path, ch_fasta)
    ORTHOFINDER(ch_fasta_1, params.project_id)
}
