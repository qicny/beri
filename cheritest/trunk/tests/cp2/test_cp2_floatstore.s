#-
# Copyright (c) 2013 Michael Roe
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

.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test that writing from the floating point unit to an address clears the tag
# bit
#

		.global test
test:		.ent test
		daddu 	$sp, $sp, -32
		sd	$ra, 24($sp)
		sd	$fp, 16($sp)
		daddu	$fp, $sp, 32

		# If the floating point unit is not present, skip the test
		dmfc0	$t0, $16, 1
		andi	$t0, $t0, 0x1
		beq	$t0, $zero, no_fpu
		nop	# Branch delay slot

		# Store a capability into cap1

		dla	$t0, cap1
                cscr    $c0, $t0($c0)


		# Overwrite the 'base' field of cap1 with a float

		dla	$t1, v1
		lw	$a0, 0($t1)
		mtc1	$a0, $f1
		swc1	$f1, 20($t0)

		# Clear $a0 so we can tell if it gets reloaded by mfc1

		dli	$a0, 0

		# Reload the stored value with a floating point instruction

		lwc1    $f2, 20($t0)
		mfc1    $a0, $f2

		# Reload the stored value as a 32-bit word

		clw	$a1, $t0, 20($c0)

		# Reload the stoted value as a capability

		clcr	$c1, $t0($c0)
		cgetbase $a2, $c1

		# The tag bit should have been cleared by the FP store

		cgettag  $a3, $c1

no_fpu:
		ld	$fp, 16($sp)
		ld	$ra, 24($sp)
		daddu	$sp, $sp, 32
		jr	$ra
		nop			# branch-delay slot
		.end	test

		.data
		.align 3
v1:		.word 0x01234567

		.align	5                  # Must 256-bit align capabilities
cap1:		.dword	0x0123456789abcdef # uperms/reserved
		.dword	0x0123456789abcdef # otype/eaddr
		.dword	0x0123456789abcdef # base
		.dword	0x0123456789abcdef # length
