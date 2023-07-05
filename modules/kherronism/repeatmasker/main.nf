process REPEATMASKER {
    tag "$meta.id"
    label 'process_high'

    conda "bioconda::repeatmasker=4.1.5"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/repeatmasker:4.1.5--pl5321hdfd78af_0':
        'biocontainers/repeatmasker:4.1.5--pl5321hdfd78af_0' }"

    input:
    tuple val(meta), path(fasta)
    tuple val(meta), path(lib)

    output:
    tuple val(meta), path("*.fna.masked") , emit: fna_masked
    tuple val(meta), path("*.fna.out")    , emit: fna_out
    tuple val(meta), path("*.fna.tbl")    , emit: fna_tbl
    tuple val(meta), path("*.fna.cat.gz") , emit: fna_cat_gz
    tuple val(meta), path("*.fna.out.gff"), emit: fna_out_gff, optional: true
    tuple val(meta), path("*.fna.align")  , emit: fna_align  , optional: true
    path "versions.yml"                   , emit: versions                          , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def VERSION = '4.1.5'  // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.
    """
    RepeatMasker \\
        -lib ${lib} \\
        -pa ${task.cpus} \\
        -dir ${prefix} \\
        ${args} \\
        ${fasta}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        repeatmasker: ${VERSION}
    END_VERSIONS
    """
}
