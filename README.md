# CENTRE Precomputed Package

This package holds the CENTRE PrecomputedDataLight.db and Example data. 
For more information on CENTRE go to https://github.com/slrvv/CENTRE

# Run Locally 

Clone the project
```
git clone https://github.com/slrvv/CENTREprecomputed
```

Install dependencies

```
install.packages(c("data.table", "RSQLite"))
```

Build package

```  
Rscript ./precomp_package_builder.R
```
