process EGGNOGMAPPER_EMAPPER {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::eggnog-mapper=2.1.11"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/eggnog-mapper:2.1.11--pyhdfd78af_0' :
        'quay.io/biocontainers/eggnog-mapper:2.1.11--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path('*.emapper.hits')                , emit: hits
    tuple val(meta), path('*.emapper.seed_orthologs')      , emit: seed_orthologs
    tuple val(meta), path('*.emapper.annotations')         , emit: annotations
    tuple val(meta), path('*.emapper.annotations.xlsx')    , emit: annotations_excel  , optional: true
    tuple val(meta), path('*.emapper.orthologs')           , emit: orthologs          , optional: true
    tuple val(meta), path('*.emapper.genepred.fasta')      , emit: pred_cds           , optional: true
    tuple val(meta), path('*.emapper.gff')                 , emit: results_gff        , optional: true
    tuple val(meta), path('*.emapper.genepred.gff')        , emit: pred_cds_gff       , optional: true
    tuple val(meta), path('*.emapper.decorated.gff')       , emit: decorated_gff      , optional: true
    tuple val(meta), path('*.emapper.no_annotations.fasta'), emit: without_annotations, optional: true
    tuple val(meta), path('*.emapper.pfam')                , emit: pfam_hits          , optional: true
    path "versions.yml"                                    , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    emapper.py \\
        --cpu ${task.cpus} \\
        -i ${fasta} \\
        --output_dir ${meta.id} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        eggnog-mapper: \$(emapper.py --version 2>&1 | sed 's/^.*eggnog-mapper v//; s/ .*\$//')
    END_VERSIONS
    """
}
