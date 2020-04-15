# Sasha Trubetskoy
# April 2020
# sasha@kartographia.com

import os
import argparse
import subprocess

def partition_planet(args):

    max_bytes = int(eval(args.maxsize))

    def make_partitions(bbox1, bbox2, large_file):
        '''
        Create new files out of bbox1 and bbox2, and then delete large_file
        '''
        print('Partitioning {}...'.format(large_file['filename']))
        new_files = []
        for new_bbox in [bbox1, bbox2]:
            new_bbox_str = '{},{},{},{}'.format(*new_bbox)
            new_filename = args.output_dir + '/chunk_{}_{}_{}_{}.pbf'.format(*[int(v) for v in list(new_bbox)])

            cmd = 'sudo osmium extract -s smart -S types=any -b "{}" "{}" -o "{}"'.format(
                new_bbox_str,
                large_file['filename'],
                new_filename
                )

            print(cmd)
            subprocess.run(cmd, cwd=os.getcwd(), shell=True)
            
            if os.path.getsize(new_filename) > max_bytes:
                new_files.append({'filename': new_filename, 'bbox': new_bbox})
        
        if large_file['filename'] != args.input_loc:
            subprocess.run('sudo rm {}'.format(large_file['filename']), cwd=os.getcwd(), shell=True)
        
        return new_files


    # Initialize list of larger files
    larger_files = [
        {'filename': args.input_loc,
         'bbox': (-180, -90, 180, 90)}
    ]

    # Split up list of larger files
    while larger_files:
        
        larger_files = sorted(larger_files, key=lambda x: os.path.getsize(x['filename']))
        
        largest_file = larger_files.pop()
        
        xmin, ymin, xmax, ymax = largest_file['bbox']
        x_range = xmax - xmin
        y_range = ymax - ymin
        
        if x_range > y_range: # If wide, partition by width (x)
            '''
              (xmax - (x_range/2))
                       |
                 ┌─────┬─────┐
                 │  1  │  2  │
                 │     │     │
                 └─────┴─────┘
                 |           |
              xmin           xmax
            '''
            bbox1 = (xmin, ymin, xmax - (x_range/2), ymax)
            bbox2 = (xmax - (x_range/2), ymin, xmax, ymax)

        else:
            '''
            ┌─────┐ ymax 
            │  2  │    
            │     │    
            ├─────┤ ymax - (y_range/2)
            │  1  │
            │     │
            └─────┘ ymin
             '''
            bbox1 = (xmin, ymin, xmax, ymax - (y_range/2))
            bbox2 = (xmin, ymax - (y_range/2), xmax, ymax)

        new_larger_files = make_partitions(bbox1, bbox2, largest_file)
        larger_files = larger_files + new_larger_files

    print('Done.')
    return


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--maxsize', '-m', help='Max size of osm files, in bytes', type=str, default="8e8")
    parser.add_argument('--input_loc', '-i', help='Input PBF filename', type=str, default="planet-latest.osm.pbf")
    parser.add_argument('--output_dir', '-o', help='Where to put the chunks', type=str, default="chunks")
    args = parser.parse_args()

    partition_planet(args)