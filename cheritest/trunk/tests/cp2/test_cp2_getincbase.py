#-
# Copyright (c) 2011 Robert N. M. Watson
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-10-C-0237
# ("CTSRD"), as part of the DARPA CRASH research programme.
#
# @BERI_LICENSE_HEADER_START@
#
# Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  BERI licenses this
# file to you under the BERI Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.beri-open-systems.org/legal/license-1-0.txt
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @BERI_LICENSE_HEADER_END@
#

from beritest_tools import BaseBERITestCase
from nose.plugins.attrib import attr

#
# Check basic behaviour of cgetbase and cincbase.
#

class test_cp2_getincbase(BaseBERITestCase):
    @attr('capabilities')
    def test_cp2_getbase1(self):
        '''Test that cgetbase returns correct initial value'''
        self.assertRegisterEqual(self.MIPS.a0, 0, "cgetbase returns incorrect initial value")

    @attr('capabilities')
    def test_cp2_getbase2(self):
        '''Test that cgetbase returns correct value after cincbase'''
        self.assertRegisterEqual(self.MIPS.a1, 100, "cgetbase returns incorrect value after cincbase")
