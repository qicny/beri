/*-
 * Copyright (c) 2013 Jonathan Woodruff
 * All rights reserved.
 *
 * This software was developed by SRI International and the University of
 * Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-10-C-0237
 * ("CTSRD"), as part of the DARPA CRASH research programme.
 *
 * @BERI_LICENSE_HEADER_START@
 *
 * Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
 * license agreements.  See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.  BERI licenses this
 * file to you under the BERI Hardware-Software License, Version 1.0 (the
 * "License"); you may not use this file except in compliance with the
 * License.  You may obtain a copy of the License at:
 *
 *   http://www.beri-open-systems.org/legal/license-1-0.txt
 *
 * Unless required by applicable law or agreed to in writing, Work distributed
 * under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations under the License.
 *
 * @BERI_LICENSE_HEADER_END@
 */

__stack_size__ = 0x400; /* 1k stack */
__mem_top__ = 0x9800000040007F00;

__sp = __mem_top__;
__heap_top__ = __mem_top__ - __stack_size__;
__sp_bottom = __heap_top__;

SECTIONS
{
. = 0x9800000040000000;	/* BRAM address */
//. = 0x0000000000000000;


.text : { init.o(.text) test.o(.text) }
.bss : { test.o(.bss) }
.data : { test.o(.data) }
_gp = ALIGN(16) + 0x7ff0;
.got : { *(.got.plt) *(.got) }
.rodata : { test.o(.rodata*) }

. = ALIGN(0x2000);
.box.text : { box.o(.text) }
.box.bss : { box.o(.bss) }
.box.data : { box.o(.data) }

__bss_start = ADDR(.bss);
__bss_end = ALIGN(__bss_start + SIZEOF(.bss), 0x8);
__heap = ALIGN(0x8); /*64-bit alligned heap pointer */

__box_start = ADDR(.box.text);
__box_array = ADDR(.box.data) - __box_start;
__box_size = SIZEOF(.box.text) + SIZEOF(.box.bss) + 1024/*SIZEOF(.box.data)*/;
}
