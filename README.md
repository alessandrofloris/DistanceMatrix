# Distance Matrix

Questa piccola utility creata con julia serve per creare delle matrici dei costi quando il numero dei punti è molto grande.
Si serve delle api di OSMR per recuperare le distanze e e il tempo di percorrenza tra i punti.

In caso di un numero di punti < 80 circa è sconsigliato usare questa repo in quanto le api di OSMR gia forniscono un servizio per il calcolo della matrice dei costi 
dari N punti.

## Codifica del file in input

Distance Matrix prende in input un file txt che contiene dei punti (lat,lon).  
Il file deve essere codificato in questo modo:  
lat lon  
lat lon   
... 

## Note 

Nella cartella data è gia presente un file di prova "coordinate.txt" che contiene dei punti di prova.

