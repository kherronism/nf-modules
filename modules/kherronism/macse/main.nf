process MACSE {
    tag "$meta.id"
    label 'process_long'

    conda "bioconda::macse=2.07"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/macse:2.07--hdfd78af_0' :
        'quay.io/biocontainers/macse:2.07--hdfd78af_0' }"

    input:
    tuple val(meta), path(tbd)
    val program

    output:
    tuple val(meta), path('*.aln'), optional: true, emit: aln
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def VERSION = '2.07'
    """
    java -jar macse.jar \\
        -prog {program}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        macse: ${VERSION}
    END_VERSIONS
    """
}
