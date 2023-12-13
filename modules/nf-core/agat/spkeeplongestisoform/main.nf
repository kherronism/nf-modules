process AGAT_SPKEEPLONGESTISOFORM {
    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/agat:1.2.0--pl5321hdfd78af_0' :
        'biocontainers/agat:1.2.0--pl5321hdfd78af_0' }"

    input:
    tuple val(meta), path(gff)

    output:
    tuple val(meta), path("*.gff"), emit: output_gff
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    agat_sp_keep_longest_isoform.pl \\
        --gff ${gff} \\
        --output ${prefix}.gff \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        agat: \$(agat_sp_keep_longest_isoform.pl --help |head -n4 | tail -n1 | grep -Eo '[0-9.]+')
    END_VERSIONS
    """
}
