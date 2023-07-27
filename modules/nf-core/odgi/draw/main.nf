process ODGI_DRAW {
    tag "$meta.id"
    label 'process_single'

    conda "bioconda::odgi=0.8.2"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/odgi:0.8.2--py310hc8f18ef_0':
        'biocontainers/odgi:0.8.2--py310hc8f18ef_0' }"

    input:
    tuple val(meta), path(graph), path(lay)

    output:
    tuple val(meta), path("*.png"), emit: png
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    odgi \\
        draw \\
        --threads $task.cpus \\
        --idx ${graph} \\
        --coords-in ${lay} \\
        --png ${prefix}.png \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        odgi: \$(echo \$(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
    END_VERSIONS
    """
}