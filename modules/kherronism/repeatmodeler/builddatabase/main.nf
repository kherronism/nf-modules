process REPEATMODELER_BUILDDATABASE {
    tag "$meta.id"
    label 'process_high'
    label 'process_long'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/repeatmodeler:2.0.4--pl5321hdfd78af_0':
        'quay.io/biocontainers/repeatmodeler:2.0.4--pl5321hdfd78af_0' }"

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("*${prefix}"), emit: repeatmodeler_db
    path "versions.yml"                  , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "RM_${meta.id}"
    def VERSION = '2.0.4'  // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.
    """
    BuildDatabase \\
        -name RM_${prefix} \\
        ${fasta}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        repeatmodeler: ${VERSION}
    END_VERSIONS
    """
}
