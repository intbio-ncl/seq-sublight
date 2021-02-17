#!/usr/bin/env nextflow

/*
Nextflow workflow that solves the Maximum Diversity Problem (MDP) for a set
of protein sequences using sequence identity as a distance metric.

Required parameters are either a FASTA file with sequences OR the matrix/heading
pair of files from a previous run, a solution subset size K, an output directory,
and the solver to be used (greedy, ts, or all).

Can optionally submit an annotation file, for which Coverage and Gini-Simpson
values will be computed.
*/



// Initialise Parameters
params.seqs = null
params.subset = null
params.threshold = null
params.outdir = null

seqs = file( params.seqs )
subset = file ( params.subset )
threshold = params.threshold


// Create output directory
outdir = file( params.outdir )
outdir.mkdirs()


process produce_identities{
    // Use needleall to produce all-vs-all global alignment sequence identities

    input:
    file seqs

    output:
    file "identities.gml" into ini_ssn

    """
    nextflow run ravenlocke/nf-needleall-ava --infile ${seqs}  --outdir needle_out --threshold ${threshold} --cpu 4
    cp ./needle_out/identities.gml ./
    """
}


process produce_nets{
    // Solve the MDP

    publishDir outdir, mode : "copy"
    container 'mdp-kit'

    input:
    file ini_ssn
    file subset

    output:
    file "./ssn.gml"
    file "./ssn.png"


    """
    python3 /code/sublight.py -g ${ini_ssn} -s ${subset}
    """
}
