#!/usr/bin/env python

import code
import sys
from gensim.models import Word2Vec

if __name__ == "__main__":
    model_file_name = sys.argv[1]
    model = Word2Vec.load(model_file_name)

    code.interact(local=locals())
     
