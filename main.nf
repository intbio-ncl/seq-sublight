#!/usr/bin/env nextflow

/*
Workflow that highlights a subset of sequences in a Sequence Similarity Network (SSN).
Can either make an SSN from scratch if given sequences, or use an already existing SSN (in .gml)
*/



// Initialise Parameters
params.seqs = null
params.subset = null
params.threshold = null
params.ini_ssn = 'null' // ini_ssn file is optional
params.outdir = null

subset = file ( params.subset )

flag = false

if (params.seqs == null && params.ini_ssn != null){
    ini_ssn_1 = Channel.fromPath( params.ini_ssn )
    seqs = Channel.empty()

}
else {
    seqs = file ( params.seqs )
    threshold = params.threshold
    ini_ssn_1 = Channel.empty()
    flag = true
}

// Create output directory
outdir = file( params.outdir )
outdir.mkdirs()


process produce_identities{
    // Use needleall to produce all-vs-all global alignment sequence identities

    publishDir outdir, mode : "copy"

    input:
    file seqs

    output:
    file "ini_ssn.gml" into ini_ssn_2

    when:
    flag

    """
    nextflow run ravenlocke/nf-needleall-ava --infile ${seqs}  --outdir needle_out --threshold ${threshold} --cpu 4
    cp ./needle_out/identities.gml ./ini_ssn.gml
    """
}

// Merge the two ini_ssn channels so reusing previous runs can work
ini_ssn = ini_ssn_2.mix(ini_ssn_1).first()

process produce_nets{
    // Produce the highlighted network and picture

    publishDir outdir, mode : "copy"
    container 'chrisata/mdp-kit'

    input:
    file ini_ssn
    file subset

    output:
    file "./ssn.gml"
    file "./ssn.png"


    """
    python3 /seq-sublight/lib/sublight.py -g ${ini_ssn} -s ${subset}
    """
}
