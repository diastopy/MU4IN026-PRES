# PROJET RESEAU 14 - L'impact des ROI (regions of interest) dans le streaming vidéo

## Lancer le serveur

`py serverV<x>.py`  

## Projet  

### V1  

Serveur qui envoie une vidéo  

### V2  

Serveur qui envoie une vidéo et qui nous permet de choisir quelle vidéo nous voulons (s'il y en a plusieurs)

### V3  

Un premier découpage en segment

### V4  

Utilisation réelle de DASH : découpage en segment de plusieurs qualités de la même vidéo  

### Pour utiliser la V6

V6 => Utilisation des ROI manuelles

Lancer la commande :  

```bash
gpac -i http://<IP_Serveur:Port_server>/<path>/output.mpd:gpac:tile_mode=center:algo=grate vout
```

avec path = {V5;V6_1;V6_2}
