process SEQKIT_FX2TAB {
    tag "$meta.id"
    label 'process_low'

    conda "bioconda::seqkit=2.2.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqkit:2.2.0--h9ee0642_0':
        'biocontainers/seqkit:2.2.0--h9ee0642_0' }"

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("*.tsv"), emit: tab
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args   = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    seqkit fx2tab \\
        $args \\
        $fasta > '${prefix}.tsv'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$( seqkit version | sed 's/seqkit v//' )
    END_VERSIONS
    """
}
