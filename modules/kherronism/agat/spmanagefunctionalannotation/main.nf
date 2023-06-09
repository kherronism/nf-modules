process AGAT_SPMANAGEFUNCTIONALANNOTATION {
    tag "$meta.id"
    label 'process_single'

    conda "bioconda::agat=1.0.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/agat:1.0.0--pl5321hdfd78af_1':
        'biocontainers/agat:1.0.0--pl5321hdfd78af_1' }"

    input:
    tuple val(meta), path(gff)
    path interproscan_tsv
    path blast_tbl
    path blast_db_fasta

    output:
    tuple val(meta), path("*.gff"), emit: func_annot_gff
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def infiles = [
        interproscan_tsv ? "--interpro ${interproscan_tsv}" : "",
        blast_tbl ? "--blast ${blast_tbl}" : "",
        blast_db_fasta ? "--db ${blast_db_fasta}" : ""
    ].join(' ')
    """
    agat_sp_manage_functional_annotation.pl \\
        --gff ${gff} \\
        --output ${prefix}.gff \\
        ${infiles} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        agat: \$(agat_sp_manage_functional_annotation.pl --help |head -n4 | tail -n1 | grep -Eo '[0-9.]+')
    END_VERSIONS
    """
}
