# Recommender System

This repo contains code and documentation for eda and prototyping done for the recommender system. There is prototyped Market Basket Model that has runs and a CF model that is a WIP and needs more work to run

## Files

    ├── CF - WIP                                             
        ├── 2.0_collaborative_filtering.ipynb                <- collaborative filtering model; real rough and very early stages, needs way more development
        ├── user-item-viewcount.sql                          <- sql for pulling users and the PDPs they viewed
        └── items.sql                                        <- maps items to other metadata
    └── market-basket                                        
        ├── json-outputs                                     <- json outputs for ingestion into klaviyo by retention teams
        ├── sql                                              <- all sql used in the MBA
        ├── bundle-functions.R                               <- helper functions
        ├── market_basket_analyis-top-rugs-email-test.ipynb  <- market basket model; prototype runs and outputs json 
        └── market_basket_analyis.ipynb                      <- market basket model for exploring recommendations by specifying rug designs explicitly

## How to use this
* Refer to step-by-step manual [here](https://docs.google.com/document/d/1sEYyfKuzxt1wiyeKr_-WDA5N7oh9_U-a7baAT0vmX_k/edit?usp=sharing)

## Reference Material
Articles on Market Basket Analysis
* [TDS Article](https://towardsdatascience.com/a-gentle-introduction-on-market-basket-analysis-association-rules-fa4b986a40ce)
* [Medium Article](https://medium.com/@niharika.goel/market-basket-analysis-association-rules-e7c27b377bd8)
* [Step-by-step examples using arules package in R](https://www.datacamp.com/community/tutorials/market-basket-analysis-r)

Collaborative Filtering
* [Pinecone Documentation](https://www.pinecone.io/docs/examples/)

## Potential Improvements
* CF algorithm may be more robust than MBA and should be tested
* Deploying as an API will allow ecomm to be incorporate model outputs more easily