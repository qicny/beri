from beritest_tools import BaseBERITestCase
from nose.plugins.attrib import attr
import os
import tools.sim
expected_uncached=[
    0x0,
    0xf7ffffffffffffff,
    0x4,
    0xc000007fffffed44,
    0x9000000040000d20,
    0xc000007fffffe000,
    0x40000000,
    0x1000012,
    0x1000052,
    0xfedcba9876543210,
    0xc000007fffffe0ff,
    0xfedcba9876543210,
    0x9000000040000d20,
    0xffffffffffbfffff,
    0xe0e0e0e0e0e0e0e,
    0xf0f0f0f0f0f0f0f,
    0xd20,
    0xc000007fffffed20,
    0xc000007fffffed28,
    0xc000007fffffed20,
    0x1414141414141414,
    0x1515151515151515,
    0xc000007fffffe0ff,
    0x2,
    0x1818181818181818,
    0x9000000040000b9c,
    0x0,
    0x1b1b1b1b1b1b1b1b,
    0x1c1c1c1c1c1c1c1c,
    0x9000000000007fe0,
    0x9000000000008000,
    0x900000004000038c,
  ]
expected_cached=[
    0x0,
    0xf7ffffffffffffff,
    0x4,
    0xc000007fffffed64,
    0x9800000040000d40,
    0xc000007fffffe000,
    0x40000000,
    0x1000012,
    0x1000052,
    0xfedcba9876543210,
    0xc000007fffffe0ff,
    0xfedcba9876543210,
    0x9000000040000d40,
    0xffffffffffbfffff,
    0xe0e0e0e0e0e0e0e,
    0xf0f0f0f0f0f0f0f,
    0xd40,
    0xc000007fffffed40,
    0xc000007fffffed48,
    0xc000007fffffed40,
    0x1414141414141414,
    0x1515151515151515,
    0xc000007fffffe0ff,
    0x2,
    0x1818181818181818,
    0x9800000040000bbc,
    0x0,
    0x1b1b1b1b1b1b1b1b,
    0x1c1c1c1c1c1c1c1c,
    0x9800000000007fe0,
    0x9800000000008000,
    0x98000000400003ac,
  ]
class test_regfuzz_tlb_00001716(BaseBERITestCase):
  @attr('tlb')
  def test_registers_expected(self):
    cached=bool(int(os.getenv('CACHED',False)))
    expected=expected_cached if cached else expected_uncached
    for reg in xrange(len(tools.sim.MIPS_REG_NUM2NAME)):
      self.assertRegisterExpected(reg, expected[reg])

