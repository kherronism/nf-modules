process EGGNOGMAPPER_EMAPPER {
    tag "$meta.id"
    label 'process_medium'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/eggnog-mapper:2.1.11--pyhdfd78af_0' :
        'quay.io/biocontainers/eggnog-mapper:2.1.11--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(fasta)
    val method

    output:
    tuple val(meta), path('*.emapper.annotations')   , emit: annotations
    tuple val(meta), path('*.emapper.seed_orthologs'), emit: seed_orthologs
    tuple val(meta), path('*.emapper.decorated.gff') , emit: decorated_gff
    path "versions.yml"                              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    def VERSION = '2.1.10' // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.
    """
    download_eggnog_data.py \\
        --data_dir \\
        -P \\
        -M \\
        -y

    emapper.py \\
        --cpu ${task.cpus} \\
        -i ${fasta} \\
        -m ${method} \\
        --output_dir ${meta.id} \\
        --decorate_gff yes \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        eggnog-mapper: ${VERSION}
    END_VERSIONS
    """
}
