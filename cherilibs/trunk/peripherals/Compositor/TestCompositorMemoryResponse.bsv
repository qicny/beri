/*-
 * Copyright (c) 2013 Philip Withnall
 * All rights reserved.
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

package TestCompositorMemoryResponse;

import CompositorMemoryResponse::*;
import CompositorUtils::*;
import GetPut::*;
import StmtFSM::*;
import TestUtils::*;
import Vector::*;

(* synthesize *)
module mkTestCompositorMemoryResponse ();
	CompositorMemoryResponseIfc compositorMemoryResponse <- mkCompositorMemoryResponse ();

	Wire#(Maybe#(CompositorMemoryResponseOutputPacket)) currentOutput <- mkDWire (tagged Invalid);

	/* Temporary registers for loops. */
	Reg#(UInt#(32)) i <- mkReg (0);

	/* Assert that a valid packet was outputted this cycle. */
	function assertOutputPacket ();
		action
			if (!isValid (currentOutput)) begin
				let theTime <- $time;
				failTest ($format ("%05t: expected packet", theTime));
			end else begin
				$display ("%05t: clock", $time);
			end
		endaction
	endfunction: assertOutputPacket

	/* Pull output from the MEMR module as fast as it will provide it. */
	(* fire_when_enabled *)
	rule grabOutputPacket;
		let packet = compositorMemoryResponse.first;
		compositorMemoryResponse.deq ();
		currentOutput <= tagged Valid packet;
	endrule: grabOutputPacket

	/* Push responses into the MEMR module as fast as it will accept them. */
	(* fire_when_enabled *)
	rule feedMemoryResponses;
		compositorMemoryResponse.extMemoryResponses.put (replicate (RgbaPixel { red: 255, green: 0, blue: 0, alpha: 255 }));
	endrule: feedMemoryResponses

	/* Pump input into the MEMR module as fast as it will accept it. */
	(* fire_when_enabled *)
	rule feedInputPacket;
		compositorMemoryResponse.enq (CompositorMemoryResponseInputPacket {
			requestMade: True,
			xPadding: 0,
			lhPixelSource: SOURCE_MEMORY,
			rhPixelSource: SOURCE_TRANSPARENT,
			useBackground: True,
			isFinalOp: True
		});
	endrule: feedInputPacket

	Stmt testSeq = seq
		seq
			/* Check that the module outputs every cycle. */
			startTest ("Outputs every cycle");

			/* Check that a packet is outputted every cycle for a number of cycles. */
			loopEveryCycleNoSetup (i, 12, assertOutputPacket ());

			finishTest ();
		endseq
	endseq;
	mkAutoFSM (testSeq);
endmodule: mkTestCompositorMemoryResponse

endpackage: TestCompositorMemoryResponse
