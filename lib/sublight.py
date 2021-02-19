
import networkx as nx
import matplotlib.pyplot as plt

#########################################

import argparse

parser = argparse.ArgumentParser(description="Highlight subsets of protein sequences from a larger superset.")
parser.add_argument("-g", "--graph", help="Path to the initial SSN graph (.gml).", type=str, required=False)
parser.add_argument("-s", "--subset", help="Path to the subset file.", type=str, required=True)


args = parser.parse_args()
_GRAPHPATH = args.graph
_SUBSETPATH = args.subset

#########################################


def parse_subset():

    fr = open(_SUBSETPATH, "r")
    subset = []

    for line in fr:
        line = line.strip()
        subset.append(line)

    return subset


def colour_graph(subset):

    ini_graph = nx.read_gml(_GRAPHPATH)
    ini_graph.remove_edges_from(nx.selfloop_edges(ini_graph))

    new_graph = nx.Graph()
    colour_lst = []

    for node in ini_graph.nodes:
        if node in subset:
            new_graph.add_node(node, graphics={
                                        "fill": "#e30909",
                                        "type": "ellipse",
                                        "w": 20.0,
                                        "h": 20.0})
            colour_lst.append("#e30909")
        else:
            new_graph.add_node(node, graphics={
                                        "fill": "#1a04de",
                                        "type": "ellipse",
                                        "w": 20.0,
                                        "h": 20.0})
            colour_lst.append("#1a04de")

    new_graph.add_edges_from(ini_graph.edges(data=True))
    nx.draw(new_graph, node_color=colour_lst, node_size=20, width=0.3,
            pos=nx.nx_pydot.pydot_layout(new_graph))

    plt.draw()
    plt.savefig('ssn.png', dpi=500)
    nx.write_gml(new_graph, 'ssn.gml')


def main():
    subset = parse_subset()
    colour_graph(subset)


if __name__ == '__main__':
    main()
