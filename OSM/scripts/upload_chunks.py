'''
Sasha Trubetskoy
April 2020
sasha@kartographia.com

Description:
    Python script that runs bash commands to upload a directory of raw OSM files (pbf 
    format) to a given database, as separate tables
'''

import os
import sys
import time
import pexpect
import argparse


def upload(args):
    db_name = 'osm'
    username = 'postgres'
    port = '5432'
    host = 'localhost'

    child = pexpect.spawn('bash', timeout=40000)
    child.logfile_read = sys.stdout.buffer # show output for debugging

    filenames = os.listdir(args.chunks_dir)
    if '.DS_Store' in filenames:
        filenames.remove('.DS_Store')

    for i, filename in enumerate(filenames):
        print(filename)

        table_name = 'osm_' + filename.split('.')[0].replace('-', 'neg')

        upload_command_args = [
            "{}/{}".format(args.chunks_dir, filename),
            "-l", # Store data as Lat Lon
            "-d", db_name,
            "-U", username,
            "-P", port,
            "-H", host,
            "-S", "default.style",
            "-r", "pbf", # Input format is pbf
            "-v", # Verbose output
            "-p", table_name,
            "-C", "30000",
            "--hstore",
            ]
        
        child.sendline('osm2pgsql ' + ' '.join(upload_command_args))
        child.expect('Osm2pgsql took .+ overall')

    child.close()
    sys.exit(child.status)

    return


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--chunks_dir', '-d', help='Where to put the chunks', type=str, default="chunks")
    args = parser.parse_args()

    upload(args)