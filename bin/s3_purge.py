#!/usr/bin/env python
import boto3
import math
import os
import queue
import time
import sys
import threading

BULK_DELETE_LIST_SIZE = 1000
MAX_CONSUMER = 15
MAX_LIST_LEN = 5000
QUEUE_TIMEOUT = 5
QUEUE_SLEEP = 10

def flatten(src_list):
  return [val for sublist in src_list for val in sublist]

def get_dir_entries(prefix):
  client = boto3.client('s3')
  paths = map(lambda x: x['Prefix'], client.list_objects(
    Bucket=BUCKET_NAME,
    Delimiter='/',
    Prefix=prefix
  ).get('CommonPrefixes', []))
  return list(paths)

def get_archive_paths(prefix):
  while True:
    print('prefix: {}'.format(prefix))
    dirs = get_dir_entries(prefix)
    print('dirs: {}'.format(dirs))
    if dirs:
    for dir in dirs:
      if len(get_archive_paths(dir)) == 0:
        return dir

def delete_items(items):
  print("{} Deleting items".format(threading.get_ident()))
  s3_client = boto3.client('s3')
  for i in range(0, len(items), BULK_DELETE_LIST_SIZE):
    response = s3_client.delete_objects(
      Bucket=BUCKET_NAME,
      Delete={
        'Objects': items[i:i+BULK_DELETE_LIST_SIZE],
        'Quiet': True
      }
    )
    if response['ResponseMetadata']['HTTPStatusCode'] != 200:
      print("ERROR: {}".format(response))
  print("{} List deleted".format(threading.get_ident()))

def producer(marker_queue, version_queue, path):
  s3_client = boto3.client('s3')
  object_response_paginator = s3_client.get_paginator('list_object_versions')

  delete_marker_list = []
  version_list = []

  print('{}: Starting producer => {}'.format(threading.get_ident(), path))

  for object_response_itr in object_response_paginator.paginate(Bucket=BUCKET_NAME, Prefix=path):
    if 'DeleteMarkers' in object_response_itr:
      for delete_marker in object_response_itr['DeleteMarkers']:
        delete_marker_list.append({'Key': delete_marker['Key'], 'VersionId': delete_marker['VersionId']})
        if len(delete_marker_list) > MAX_LIST_LEN:
          marker_queue.put(delete_marker_list)
          print('Added from path: {}'.format(path))
          print('Marker Queue size: {}'.format(marker_queue.qsize()))
          delete_marker_list = []

    if 'Versions' in object_response_itr:
      for version in object_response_itr['Versions']:
        version_list.append({'Key': version['Key'], 'VersionId': version['VersionId']})
        if len(version_list) > MAX_LIST_LEN:
          version_queue.put(version_list)
          print('Added from path: {}'.format(path))
          print('Version Queue size: {}'.format(version_queue.qsize()))
          version_list = []

  # Cleanup remaining list
  if len(delete_marker_list) > 0:
    marker_queue.put(delete_marker_list)
    delete_marker_list = []

  if len(version_list) > 0:
    version_queue.put(version_list)
    version_list = []

  marker_queue.join()
  version_queue.join()
  print('Producer {} exiting...'.format(threading.get_ident()))


def consumer(q):
  print('Starting consumer => {}'.format(threading.get_ident()))

  # Run indefinitely
  while True:
    try:
      delete_items(q.get(True, QUEUE_TIMEOUT))
      q.task_done()
    except queue.Empty:
      print('Consumer {}: Queue empty after {} seconds . . .'.format(threading.get_ident(), QUEUE_TIMEOUT))
      time.sleep(QUEUE_SLEEP)
      pass

if __name__ == '__main__':
  if len(sys.argv) < 3:
    print('Usage: {} <bucket_name> <prefix>'.format(sys.argv[0]))
    sys.exit(-1)

  BUCKET_NAME = sys.argv[1]

  # Create the Queue object
  queue_size = math.floor(MAX_CONSUMER * 1.2)
  print('Queue Size/Depth: {}'.format(queue_size))
  marker_queue = queue.Queue(maxsize=queue_size)
  version_queue = queue.Queue(maxsize=queue_size)

  paths = get_archive_paths(sys.argv[2])
  print('Paths: {}'.format(paths))
  sys.exit(0)

  consumers = []
  producers = []

  for i in range(MAX_CONSUMER):
    t = threading.Thread(target=consumer, args=(marker_queue,))
    t.start()
    consumers.append(t)
    t = threading.Thread(target=consumer, args=(version_queue,))
    t.start()
    consumers.append(t)

  for path in paths:
    t = threading.Thread(target=producer, args=(marker_queue, version_queue, path,))
    t.start()
    producers.append(t)

  for p in producers:
    p.join()

  for c in consumers:
    c.join()

  print("Main program exiting . . .")
