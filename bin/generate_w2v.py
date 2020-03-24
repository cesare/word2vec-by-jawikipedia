#!/usr/bin/env python

import sys
from gensim.models import word2vec

if __name__ == "__main__":
    wakati_file_name = sys.argv[1]
    model_file_name  = sys.argv[2]

    corpus = word2vec.Text8Corpus(wakati_file_name)
    model = word2vec.Word2Vec(corpus, size=100)
    model.save(model_file_name)
