#!/usr/bin/env ruby

require 'rubygems' 
require 'bundler/setup'

require 'debugger'

require 'rmagick'

ROOT          = Pathname(File.dirname(__FILE__)).parent

# from collections import namedtuple
# from math import sqrt
# import random
# try:
#     import Image
# except ImportError:
#     from PIL import Image

Point = Struct.new('Point', :coords, :n, :ct)
# Point = namedtuple('Point', ('coords', 'n', 'ct'))

Cluster = Struct.new('Cluster', :points, :center, :n)
# Cluster = namedtuple('Cluster', ('points', 'center', 'n'))

def get_points(img)
    points = []

    w = img.columns
    h = img.rows

    img.quantize.color_histogram.sort{|a, b| b[1] <=> a[1] }
    # w, h = img.size
    
    # for count, color in img.getcolors(w * h):
    #     points.append(Point(color, 3, count))
    # return points
end

# rtoh = lambda rgb: '#%s' % ''.join(('%02x' % p for p in rgb))

def colorz(filename, n=3)
    img = Magick::Image::read(filename)[0]
    # img = Image.open(filename)
    
    #img.resize!(200, 200)
    # img.thumbnail((200, 200))
    # w, h = img.size

    points = get_points(img)
    clusters = kmeans(points, n, 1)
    # rgbs = [map(int, c.center.coords) for c in clusters]
    # return map(rtoh, rgbs)
end

# def euclidean(p1, p2)
#     return sqrt(sum([
#         (p1.coords[i] - p2.coords[i]) ** 2 for i in range(p1.n)
#     ]))
# end

# def calculate_center(points, n)
#     vals = [0.0 for i in range(n)]
#     plen = 0
#     for p in points:
#         plen += p.ct
#         for i in range(n):
#             vals[i] += (p.coords[i] * p.ct)
#     return Point([(v / plen) for v in vals], n, 1)
# end

def kmeans(points, k, min_diff)

    clusters = points.sample(k).map{|p, idx| Struct::Cluster.new(p, idx)}
    # clusters = [Cluster([p], p, p.n) for p in random.sample(points, k)]

    # while 1:
    #     plists = [[] for i in range(k)]

    #     for p in points:
    #         smallest_distance = float('Inf')
    #         for i in range(k):
    #             distance = euclidean(p, clusters[i].center)
    #             if distance < smallest_distance:
    #                 smallest_distance = distance
    #                 idx = i
    #         plists[idx].append(p)

    #     diff = 0
    #     for i in range(k):
    #         old = clusters[i]
    #         center = calculate_center(plists[i], old.n)
    #         new = Cluster(plists[i], center, old.n)
    #         clusters[i] = new
    #         diff = max(diff, euclidean(old.center, new.center))

    #     if diff < min_diff:
    #         break

    return clusters
end

puts colorz("src/akira.jpg")
    