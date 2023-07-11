process ORTHOFINDER {
    tag "$meta.id"
    label 'process_medium'

    conda 'bioconda::orthofinder=2.5.5'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/orthofinder:2.5.5--hdfd78af_1':
        'biocontainers/orthofinder:2.5.5--hdfd78af_1' }"

    input:
    path("*/tmp_input")

    output:
    path "*OrthoFinder/Phylogenetic_Hierarchical_Orthogroups/N0.tsv", emit: n0
    path "*OrthoFinder/WorkingDirectory/Blast*"                     , emit: blasts
    path "*OrthoFinder/WorkingDirectory/SequenceIDs.txt"            , emit: seq_ids
    path "versions.yml"                                  , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def VERSION = '2.5.5'  // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.
    """
    orthofinder \\
        -t ${task.cpus} \\
        -a ${task.cpus} \\
        -f ${proteins}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        orthofinder: ${VERSION}
    END_VERSIONS
    """
}
