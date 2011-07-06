#! /usr/bin/env python
# -*- coding: utf8 -*-

#
# Copyright 2009 WireLoad LLC
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

"""
A script to build OFC using Flex.

The mxmlc command needs to be on your path. In Flex SDK 3 it's in the bin folder.
"""

import sys
import os

"""Features that can be enabled."""
AVAILABLE_FEATURES = [
  'area_hollow',
  'area_line',
  'bar',
  'bar_3d',
  'bar_fade',
  'bar_filled',
  'bar_glass',
  'bar_sketch',
  'bar_stack',
  'candle',
  'hbar',
  'line',
  'line_dot',
  'line_hollow',
  'pie',
  'radar',
  'scatter',
  'scatter_line',
  'shape',
  'embed_arial',
  'context_menu',
  'save_image',
  'external_interface',
]

def build_ofc(source_path, target, features):
  import pexpect
  args = [ os.path.join(source_path, "open-flash-chart", 'PreloaderFactory.as')]
  args.extend(['-frames.frame', '2', 'Main'])
  args.extend(['-output', target])
  #args.append('-incremental=true')
  if "debug" in features:
    args.extend(['-compiler.debug', '-define=CONFIG::debug,true'])
  else:
    args.extend(['-define=CONFIG::debug,false'])
  
  args.append('-define=CONFIG::mouse_out_alpha,0.7')
  args.append('--default-background-color=0xFFFFFF')
  args.extend(['--default-size', '512', '512'])
  
  for feat in AVAILABLE_FEATURES:
    args.append('-define=CONFIG::enable_%s,%s' % (feat, "true" if feat in features else "false"))
    
  #args.append('-link-report')
  #args.append('links.txt')

  child = pexpect.spawn('mxmlc', args)
  child.interact()
  code = child.status
  if code != 0:
    sys.exit(1)
    
if __name__ == '__main__':
  from optparse import OptionParser
  parser = OptionParser(usage="""usage: %prog [target]""", description=__doc__)

  parser.add_option("-d", "--debug",
                    action="store_true", dest="debug", default=False,
                    help="compile with the DEBUG flag defined")
  parser.add_option("-o", "--optimize",
                    action="store_true", dest="optimize", default=False,
                    help="disable all optional features except those specifically enabled")

  for feat in AVAILABLE_FEATURES:
    parser.add_option("", "--enable_%s" % feat, action="store_true", dest="enable_%s" % feat, default=False,
                      help="enable the '%s' feature" % feat) ;
                  
  (options, args) = parser.parse_args()

  target = "open-flash-chart.swf"
  if len(args) > 1:
    parser.error("incorrect number of arguments")
  elif len(args) == 1:
    target = args[0]
  
  features = []
  if not options.optimize:
    features = AVAILABLE_FEATURES
  else:
    features = [feature for feature in AVAILABLE_FEATURES if getattr(options, "enable_%s" % feature)]
  
  if options.debug:
    features.append("debug");
  
  INSTALLATION = os.path.dirname(os.path.abspath(__file__))
  build_ofc(INSTALLATION, target, features)
