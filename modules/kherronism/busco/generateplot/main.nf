process BUSCO_GENERATEPLOT {
    tag "$meta.id"
    label 'process_single'

    conda "bioconda::busco=5.4.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/busco:5.4.3--pyhdfd78af_0':
        'biocontainers/busco:5.4.3--pyhdfd78af_0' }"

    input:
    tuple val(meta), path('BUSCO_summaries/*')

    output:
    tuple val(meta), path("*.png"), emit: png
    tuple val(meta), path("*.R")  , emit: r
    path  "versions.yml"          , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    generate_plot.py \\
        --working_directory BUSCO_summaries \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        busco: \$( busco --version 2>&1 | sed 's/^BUSCO //' )
    END_VERSIONS
    """
}
