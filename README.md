# seq-sublight
Highlight subsets of protein sequences from a larger superset on a Sequence Similarity Network (SSN).

## Requirements
The only requirements are [Nextflow](https://www.nextflow.io/) and [Docker](https://www.docker.com/).

## Parameters

```
--seqs :       File containing protein sequences in FASTA format.

--subset :     File containing the subset of sequences to highlight - one Sequence ID per line.
               *MUST* match the IDs in `--seqs`

--threshold :  Threshold to use for building the SSN.
               Should be paired with `--seqs` to run 'from scratch'.

--outdir :     Directory to store the results in.

--ini_ssn :    Sequence Similarity Network from a previous run 'from scratch'.
               
```

## How to run

This workflow can be run with two different sets of inputs:

### From Scratch

If you run this workflow from scratch, you need three inputs:
* A FASTA file containing the protein sequences you want to create an SSN for using `--seqs`.
* A threshold for the SSN using `--threshold`.
* A subset file containing the list of sequences to highlight on the SSN using `--subset`, with one sequence name per line. These names should match the headers provided in the `--seqs` input.
```
nextflow run intbio-ncl/seq-sublight --seqs test_seqs.fasta --threshold 0.4 --subset test_subset.txt  --outdir Test
```

With these inputs, the workflow will produce an initial ssn called 'ini_ssn.gml' that can be reused in 'reruns'.

### Rerun

The initial SSN can be reused in a new run. As the SSN can take a long time to produce, we recommend you use the 'rerun' set of inputs if you want to highlight a subset of nodes on the same sequences, but with different other inputs.
In this case, the parameters `--seqs` and `--threshold` should be replaced with one input: `--ini_ssn` for the initial SSN.

```
nextflow run intbio-ncl/seq-sublight --ini_ssn ini_ssn.gml --subset test_subset.txt --outdir Test
```
You can find the ini_ssn.gml file necessary for reruns in the output directory after your initial run.

## Outputs
This workflow produces two main outputs: 

* ssn.gml : A .gml file of the SSN with the subset highlighted, to be used in interactive network software like Cytoscape.
* ssn.png : A picture file of the SSN with the subset highlighted.
