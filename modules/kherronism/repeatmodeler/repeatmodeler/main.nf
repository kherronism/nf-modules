process REPEATMODELER {
    tag "$meta.id"
    label 'process_medium'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/repeatmodeler:2.0.4--pl5321hdfd78af_0':
        'quay.io/biocontainers/repeatmodeler:2.0.4--pl5321hdfd78af_0' }"

    input:
    tuple val(meta), path(repeat_db)

    output:
    tuple val(meta), path("*-families.fa") , emit: repeatmodeler_families_fa
    tuple val(meta), path("*-families.stk"), emit: repeatmodeler_families_stk
    tuple val(meta), path("*-rmod.log")    , emit: repeatmodeler_log
    path "versions.yml"                    , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def VERSION = '2.0.4'  // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.
    """
    RepeatModeler \\
        -database ${repeat_db} \\
        -threads ${task.cpus} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        repeatmodeler: ${VERSION}
    END_VERSIONS
    """
}
