    set.seed(1234)
    create_go_annotation = function(db, ontology = NULL){
      all_genes = keys(db)
      go_all_gene = AnnotationDbi::select(db, keys = all_genes, columns = c("GOALL", "ONTOLOGYALL"))
      
      if (!is.null(ontology)) {
        go_all_gene = go_all_gene[go_all_gene$ONTOLOGYALL == ontology, ]
        ontology_type = paste0("GO.", ontology)
      } else {
        ontology_type = "GO.all"
      }
      go_2_gene = split(go_all_gene$ENTREZID, go_all_gene$GOALL)
      go_2_gene = lapply(go_2_gene, unique)
      go_desc = AnnotationDbi::select(GO.db::GO.db, keys = names(go_2_gene), columns = "TERM", keytype = "GOID")$TERM
      names(go_desc) = names(go_2_gene)

      go_annotation = categoryCompare2::annotation(annotation_features = go_2_gene,
                                                   description = go_desc,
                                                   annotation_type = ontology_type,
                                                   feature_type = "ENTREZID")
      go_annotation
    }


    library(org.Hs.eg.db)

    ## Loading required package: AnnotationDbi

    ## Loading required package: stats4

    ## Loading required package: BiocGenerics

    ## 
    ## Attaching package: 'BiocGenerics'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     IQR, mad, sd, var, xtabs

    ## The following objects are masked from 'package:base':
    ## 
    ##     anyDuplicated, append, as.data.frame,
    ##     basename, cbind, colnames, dirname, do.call,
    ##     duplicated, eval, evalq, Filter, Find, get,
    ##     grep, grepl, intersect, is.unsorted, lapply,
    ##     Map, mapply, match, mget, order, paste,
    ##     pmax, pmax.int, pmin, pmin.int, Position,
    ##     rank, rbind, Reduce, rownames, sapply,
    ##     setdiff, sort, table, tapply, union, unique,
    ##     unsplit, which.max, which.min

    ## Loading required package: Biobase

    ## Welcome to Bioconductor
    ## 
    ##     Vignettes contain introductory material;
    ##     view with 'browseVignettes()'. To cite
    ##     Bioconductor, see 'citation("Biobase")', and
    ##     for packages 'citation("pkgname")'.

    ## Loading required package: IRanges

    ## Loading required package: S4Vectors

    ## 
    ## Attaching package: 'S4Vectors'

    ## The following objects are masked from 'package:base':
    ## 
    ##     expand.grid, I, unname

    ## 

    library(GO.db)

    ## 

    library(categoryCompare2)

    ## 
    ## Attaching package: 'categoryCompare2'

    ## The following object is masked from 'package:Biobase':
    ## 
    ##     annotation

    ## The following object is masked from 'package:BiocGenerics':
    ## 
    ##     annotation

    library(methods)

    go_mf = create_go_annotation(org.Hs.eg.db, "MF")

    ## 'select()' returned 1:many mapping between keys
    ## and columns

    ## 'select()' returned 1:1 mapping between keys and
    ## columns

    all_features = unique(unlist(go_mf@annotation_features))
    sig_features = sample(all_features, 500)

    enrich = hypergeometric_feature_enrichment(
      new("hypergeom_features", significant = sig_features,
          universe = all_features,
          annotation = go_mf),
      p_adjust = "BH"
    )

    comb_enrich = combine_enrichments(sig1 = enrich)
    sig_cutoff = 0.1
    filter_enrich = get_significant_annotations(comb_enrich, padjust <= sig_cutoff)
