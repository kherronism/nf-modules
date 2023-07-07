# ![kherronism/nf-modules](docs/images/kherronism-nf-modules_logo_darkbg.png)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A521.10.3-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

![GitHub Actions Coda Linting](https://github.com/nf-core/modules/workflows/Code%20Linting/badge.svg)

> THIS REPOSITORY IS UNDER ACTIVE DEVELOPMENT. SYNTAX, ORGANISATION AND LAYOUT MAY CHANGE WITHOUT NOTICE!

A repository for hosting locally-developed [Nextflow DSL2](https://www.nextflow.io/docs/latest/dsl2.html) module files and subworkflows containing tool-specific process definitions and their associated documentation.

## Table of contents

- [Summary of modules in this repository](#summary-of-modules-in-this-repository)
- [Using modules in this repository](#using-modules-in-this-repository)
- [Citations](#citations)

## Summary of modules in this repository

The module files hosted in this repository define a set of processes for bioinformatic tools and locally developed scripts. This serves as a hub for sharing and adding common functionality across multiple pipelines in a modular fashion.

- agat/spkeeplongestisoform
- agat/spmanagefunctionalannotations
- braker3
- eggnogmapper/emapper
- macse
- orthofinder
- picard/collectalignmentsummarymetrics
- repeatmodeler
- repeatmasker

## Using modules in this repository

The helper command in the `nf-core/tools` package uses the GitHub API to obtain the relevant information for the module files present in the [`modules/`](modules/) directory of the [nf-core/modules](https://github.com/nf-core/tools) repository. This includes using `git` commit hashes to track changes for reproducibility purposes, and to download and install all of the relevant module files.

To install modules from this repository (and any other custom repository), the modules supercommand in `nf-core/tools`can be used with the following two flags:

- `--git-remote <git remote url>`: Specify the repository from which the modules should be fetched as a git URL. Defaults to the github repository of `nf-core/modules`.
- `--branch <branch name>`: Specify the branch from which the modules should be fetched. Defaults to the default branch of the repository.

For instance, if you want to install the `repeatmasker` module from this repository, you can use the following command:

```terminal
nf-core modules --git-remote git@github.com:kherronism/nf-modules.git install repeatmasker
```

> **Note**
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how
> to set-up Nextflow. Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline)
> with `-profile test` before running workflows on actual data.
> For more information on using nf-core modules, please refer to [nf-core/modules](https://github.com/nf-core/modules).
> For more information on installing modules from custom repositories, please refer to [nf-core/tools](https://github.com/nf-core/tools#custom-remote-modules).

## Citations
This repository uses code and infrastructure developed and maintained by the [nf-core](https://nf-co.re) community, reused here under the [MIT license](https://github.com/nf-core/tools/blob/master/LICENSE).

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).

> **Note**
> Many modules in this repository define processes for pre-exisiting bioinformatic tools - please remember to cite the originial sources. The [`CITATIONS.md`](CIATIONS.md) file contains an exhaustive list of references to help with this.

<!---

### Offline usage

If you want to use an existing module file available in `nf-core/modules`, and you're running on a system that has no internet connection, you'll need to download the repository (e.g. `git clone https://github.com/nf-core/modules.git`) and place it in a location that is visible to the file system on which you are running the pipeline. Then run the pipeline by creating a custom config file called e.g. `custom_module.conf` containing the following information:

```bash
include /path/to/downloaded/modules/directory/
```

Then you can run the pipeline by directly passing the additional config file with the `-c` parameter:

```bash
nextflow run /path/to/pipeline/ -c /path/to/custom_module.conf
```

> Note that the nf-core/tools helper package has a `download` command to download all required pipeline
> files + singularity containers + institutional configs + modules in one go for you, to make this process easier.

# New test data created for the module- sequenzautils/bam2seqz
The new test data is an output from another module- sequenzautils/bcwiggle- (which uses sarscov2 genome fasta file as an input).
-->
