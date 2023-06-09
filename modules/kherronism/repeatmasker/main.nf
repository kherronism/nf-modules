process REPEATMASKER {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::repeatmasker=4.1.5"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/repeatmasker:4.1.5--pl5321hdfd78af_0':
        'biocontainers/repeatmasker:4.1.5--pl5321hdfd78af_0' }"

    input:
    tuple val(meta), path(fasta),
    tuple val(meta), path(families_fasta)

    output:
    tuple val(meta), path("${meta.id}/*.fna.masked") , emit: assembly_softmasked
    tuple val(meta), path("${meta.id}/*.fna.align")  , emit: repeatmasker_align
    tuple val(meta), path("${meta.id}/*.fna.out")    , emit: repeatmasker_out
    tuple val(meta), path("${meta.id}/*.fna.out.gff"), emit: repeatmasker_out_gff
    tuple val(meta), path("${meta.id}/*.fna.tbl")    , emit: repeatmasker_tbl
    tuple val(meta), path("${meta.id}/*.fna.cat.gz") , emit: repeatmasker_cat_gz
    path "versions.yml"                              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def VERSION = '4.1.5'  // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.
    """
    RepeatMasker \\
        -lib ${families_fasta} \\
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
