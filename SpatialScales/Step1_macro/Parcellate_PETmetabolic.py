###### From Neuromaps by Justine Hansen adapted by Giulia Baracchini ######
# script for fetching and parcellating metabolic data on neuromaps

from neuromaps.datasets import available_annotations, fetch_annotation
from neuromaps.parcellate import Parcellater
from neuromaps import transforms
from neuromaps.images import dlabel_to_gifti
from netneurotools.datasets import fetch_schaefer2018

# print all annotations available in neuromaps
for annot in available_annotations():
    print(annot)

# list of annotations you want to fetch and parcellate
annotations = [('raichle', 'cbf', 'fsLR', '164k'),          # cerebral blood flow
               ('raichle', 'cbv', 'fsLR', '164k'),          # cerebral blood volume
               ('raichle', 'cmr02', 'fsLR', '164k'),        # oxygen metabolism
               ('raichle', 'cmruglu', 'fsLR', '164k')       # glucose metabolism
              ]

# parcellation file
# Transform the 164k maps to 32k
schaefer = fetch_schaefer2018('fslr32k')

# set up parcellater
parc_file = dlabel_to_gifti(schaefer['200Parcels17Networks'])

# store parcellated data
parcellated_data = dict([])

for (src, desc, space, res) in annotations:
    print(desc)
    annot = fetch_annotation(source=src,
                             desc=desc,
                             space=space,
                             res=res,
                             return_single=True)
    if src == 'hill2010':  # hill2010 data (expansion maps) only have R hemisphere
        hemi = 'R'
        parc = Parcellater(parc_file[1], 'fsLR', hemi=hemi)  # only take half of parc file
    else:
        hemi = None  # aka both hemisphere available
        parc = Parcellater(parc_file, 'fsLR', hemi=hemi)
    if space == 'fsLR' and res == '164k':
        annot = transforms.fslr_to_fslr(annot, target_density='32k', hemi=hemi)
    parcellated_data[src+'_' +desc] = parc.fit_transform(annot,
                                                         'fslr',
                                                         hemi=hemi)
    # or you could save out
    # np.savetxt('/path/to/file/' + src + '_' + desc + '_Schaefer200_17Networks.csv',
    #            parcelalted_data[src+'_'+desc], delimiter=',')


