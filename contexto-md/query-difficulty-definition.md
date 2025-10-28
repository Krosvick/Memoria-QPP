# Predicting Query Difficulty in IR: Impact of Difficulty Definition

## Abstract
While it exists information on about any topic on the web, we know from information retrieval (IR) evaluation programs that search systems fail to answer to some queries in an effective manner. System failure is associated to query difficulty in the IR literature. However, there is no clear definition of query difficulty. This paper investigates several ways of defining query difficulty and analyses the impact of these definitions on query difficulty prediction results.

## I. INTRODUCTION
In IR literature, query difficulty is mainly associated with system failure and, as a consequence, a difficult query is a query for which the system gets poor performance in terms of system effectiveness measures [1]. One very active research topic in IR related to query difficulty is query difficulty prediction and query performance prediction.

There is no precise definition of what a difficult query is. Yet, a query can be difficult for a given system (just one system fails but other systems succeed) or for systems in general (all systems fail in retrieving relevant documents). Moreover, getting a third of the retrieved documents actually relevant to the user’s query (i.e. precision of 0.33) can be either a good or a poor result, depending on the context, the ambiguity of the query, etc.

Furthermore, from the definition of the notion of query difficulty can depend the evaluation of the accuracy of an automatic query difficulty prediction.

## II. RELATED WORK
Grivolla et al. introduced a binary classification of query difficulty [9]. They classify queries into difficult and non-difficult queries. They use the median value of the average precision over the set of queries to define the two classes.

Most of the related work does not need a precise definition of difficulty, since it rather aims at predicting the performance that is to say the effectiveness of the system on a query. Query performance prediction (QPP) indeed aims at estimating system effectiveness for a given query [2], [13], [21]; the prediction is evaluated by the means of ”Pearson correlation between the predicted system effectiveness and the real system effectiveness” [2], [16].

Indeed, if the difficulty of a query could be predicted, this knowledge could be used to enhance the system query-document matching one those only queries, by adding some processes such as query disambiguation [4], [6], [17], selective query expansion [8], [20], or matching parameter selection [7]. Alternatively, the system could also start a conversational interaction to better answer a difficult query; such a (time consuming) conversation would be acceptable for the user if it was applied to difficult queries only.

However, predicting query difficulty implies precisely defining the difficulty.

## III. QUERY DIFFICULTY DEFINITIONS
There is no consensual definition of query difficulty in the literature. Most of the existing studies consider the correlation between predicted and actual effectiveness, which does not require a clear definition of query difficulty.

When considering query difficulty prediction as a classification problem, a definition needs to be provided. Classification can be binary (a query is difficult or not), or graded (e.g. a query can be very easy, easy, difficult or very difficult for a system). If q is a query, M a given effectiveness measure such as AP (average precision) obtained by a system S, then a poor effectiveness corresponds to a low value of M.

We consider three kinds of strategies to define the difficulty of a query q, based on the value mS of an effectiveness measure M obtained for a given system S.

### A. Percentile-based strategies.
In the binary case, a query q is considered as difficult for a system S if the value of the effectiveness measure is lower than the xth percentile px, which means that x% of queries have a mS value lower than px.

In the graded difficulty case, the N difficulty classes can be defined thanks to N-1 percentiles.

### B. Threshold-based strategies.
In the binary case, a query q is considered difficult for a system S if the value of the effectiveness measure M is lower than a given threshold T.

Graded relevance is defined in a similar way as for the percentile-based strategy, replacing the percentiles values by the thresholds values.

### C. Combined strategies.
In the binary case, a query q is considered as difficult for a system S if it is judged as difficult regarding both the threshold-based and the percentile-based definitions.

In the graded difficulty case, let consider Dti (resp. Dpi) the ith difficulty class for the threshold (resp percentile)-based strategy. Then q belongs to the ith difficulty class for the combined strategy if q ∈ Dti and q ∈ Dpi.

In this paper, we consider a system-centered approach, which means that we define the difficulty regarding one given system instead of a set of systems. Nevertheless, the definitions we consider are generic enough to be used to define query difficulty regarding a set of systems S = {S1, . . . , Sn}.
## IV. QUERY DIFFICULTY PREDICTION AND EXPERIMENTAL SETTINGS

### B. Query difficulty predictors
We consider both pre-retrieval and post-retrieval features from the literature. Pre-retrieval features can be calculated prior the system runs the query while post-retrieval features implies to use initially-retrieved documents.

As pre-retrieval features, we used:
*   2 variants of the linguistic feature SynSet: max and mean number of synonyms of the query term synonyms in WordNet [14];
*   2 variants of IDF: the maximum and mean of the query terms Inverse Document Frequency in the entire document collection.

As post-retrieval features, we considered:
*   **Query Feedback (QF)** which measures the overlap of documents between initially retrieved documents and the retrieved documents after query expansion [22];
*   **Weighted Information Gain (WIG)** [22] which measures the divergence between the average score of the top retrieved documents and the score of the entire corpus;
*   **Normalized Query Commitment (NQC)** which is based on the standard deviation of the retrieved document scores normalized by the score of the whole collection [18];
*   **Clarity score** which measures the divergence between the mean of the top-retrieved document scores and the mean of the entire set of document scores [5].

### F. Query difficulty instanciations
In our experiments, we consider four instanciations of the proposed query difficulty definitions.

1)  **Experiment 1**: In experiment 1, we use the graded, percentile-based strategy to define four classes of difficulty (”very hard”, ”hard”, ”easy” and ”very easy”), according to the first quartile, the median and the third quartile. Our goal is to evaluate a graded definition of query difficulty with automatically fixed and quite homogeneous classes in terms of number of queries.

The three other experiments aim to analyse the impact of using definitions that focus on the hardest queries.

2)  **Experiment 2**: In experiment 2, we consider the binary threshold-based strategy to isolate the very hard queries. We use three different thresholds for P@10: T ∈ {0, 0.1, 0.2}. T = 0 implies that we consider a query to be very difficult for a system if it fails to retrieve any relevant document among the ten first documents. For T = 0.1 (resp. 0.2), a query is judged as very difficult if it retrieves only one (resp. two) relevant documents among the ten first documents. All other queries are considered as not difficult for the system.

3)  **Experiment 3**: In experiment 3, we established the very hard queries according to P@10 thresholds such as T ∈ {0.1, 0.2, 0.3}, but instead of considering all other queries as not hard, we keep only the easiest queries in the dataset. Once T is fixed, the threshold used to define the easiest class is set to 1 − T. Thus, we consider the following (T_veryhard, T_veryeasy) pairs of P@10 thresholds: (0.1, 0.9), (0.2, 0.8) and (0.3, 0.7).

4)  **Experiment 4**: Finally, in experiment 4, we investigate the combined definition of difficulty in the binary case. We consider the same P@10 thresholds than in the second experiment, T ∈ {0, 0.1, 0.2}, and the first quartile.

## VI. CONCLUSION
Since there is no clear definition for query difficulty, we proposed in this article three strategies to define query difficulty, based on percentiles, on thresholds and combined, respectively.

With data sets built on Robust and WT10G TREC collections and based on pre and post retrieval features as query difficulty predictors, we designed four experiments according to our query difficulty definitions, with the purpose of predicting ”very hard” queries.

The results show that “very hard” queries are hardly predicted, except for a few cases (WT10G collection and BM25 system).

We conclude that the best predictions are obtained with threshold-based strategies and a P@10 gap between difficulty classes and that the choice of the collection has the greatest impact on the predictions, while the threshold choices have the least impact.