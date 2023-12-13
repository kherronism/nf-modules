process REPEATMASKER {
    tag "$meta.id"
    label 'process_high'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/repeatmasker:4.1.5--pl5321hdfd78af_1':
        'biocontainers/repeatmasker:4.1.5--pl5321hdfd78af_1' }"

    input:
    tuple val(meta), path(fasta)
    path lib

    output:
    tuple val(meta), path("${meta.id}/*.f*a.masked") , emit: masked
    tuple val(meta), path("${meta.id}/*.f*a.tbl")    , emit: tbl
    tuple val(meta), path("${meta.id}/*.f*a.out")    , emit: out
    tuple val(meta), path("${meta.id}/*.f*a.out.gff"), emit: out_gff  , optional: true
    tuple val(meta), path("${meta.id}/*.f*a.out.xm") , emit: out_xm   , optional: true
    tuple val(meta), path("${meta.id}/*.f*a.cat.gz") , emit: cat_gz   , optional: true
    tuple val(meta), path("${meta.id}/*.f*a.align")  , emit: alignment, optional: true
    path "versions.yml"                              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    RepeatMasker \\
        -lib ${lib} \\
        -pa ${task.cpus} \\
        -dir ${prefix} \\
        ${args} \\
        ${fasta}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        repeatmasker: \${RepeatMasker | head -n 1 | sed 's/^.*RepeatMasker version.//; s/ .*\$//'}
    END_VERSIONS
    """
}
