From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v7 00/11] QEMU MTTCG Test cases
Date: Thu, 24 Nov 2016 16:10:22 +0000
Message-ID: <20161124161033.11456-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: qemu-devel@nongnu.org, mttcg@listserver.greensocs.com, fred.konrad@greensocs.com, a.rigo@virtualopensystems.com, cota@braap.org, bobby.prani@gmail.com, nikunj@linux.vnet.ibm.com, mark.burton@greensocs.com, pbonzini@redhat.com, jan.kiszka@siemens.com, serge.fdrv@gmail.com, rth@twiddle.net, peter.maydell@linaro.org, claudio.fontana@huawei.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

Looking at my records it seems as though it has been a while since I
last posted these tests. As I'm hoping to get the final bits of MTTCG
merged upstream on the next QEMU development cycle I've been re-basing
these and getting them cleaned up for merging.

Some of the patches might be worth taking now if the maintainers are
happy to do so (run_test tweaks, libcflat updates?). The others could
do with more serious review. I've CC'd some of the ARM guys to look
over the tlbflush/barrier tests so they can cast their expert eyes
over them ;-)

There are two additions to the series.

The tcg-test is a general torture test aimed at QEMU's TCG execution
model. It stresses the cpu execution loop through the use of
cross-page and computed jumps. It can also add IRQ's and self-modifying
code to the mix.

The tlbflush-data test is a new one, the old tlbflush test is renamed
tlbflush-code to better indicate the code path it exercise. The the
code test tests the translation invalidation pathways in QEMU the data
test exercises the SoftMMU's TLBs and explicitly that tlbflush
completion semantics are correct.

The tlbflush-data passes most of the times on real hardware but
definitely showed the problem with deferred TLB flushes running under
MTTCG QEMU. I've looked at some of the failure cases on real hardware
and it did look like a timestamp appeared on a page that shouldn't
have been accessible at the time - I don't know if this is a real
silicon bug or my misreading of the semantics so I'd appreciate
a comment from the experts.

The code needs to be applied on top of Drew's latest ARM GIC patches
or you can grab my tree from:

  https://github.com/stsquad/kvm-unit-tests/tree/mttcg/current-tests-v7

Cheers,

Alex.

Alex Bennée (11):
  run_tests: allow forcing of acceleration mode
  run_tests: allow disabling of timeouts
  run_tests: allow passing of options to QEMU
  libcflat: add PRI(dux)32 format types
  lib: add isaac prng library from CCAN
  arm/Makefile.common: force -fno-pic
  arm/tlbflush-code: Add TLB flush during code execution test
  arm/tlbflush-data: Add TLB flush during data writes test
  arm/locking-tests: add comprehensive locking test
  arm/barrier-litmus-tests: add simple mp and sal litmus tests
  arm/tcg-test: some basic TCG exercising tests

 Makefile                  |   2 +
 arm/Makefile.arm          |   2 +
 arm/Makefile.arm64        |   2 +
 arm/Makefile.common       |  11 ++
 arm/barrier-litmus-test.c | 437 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/locking-test.c        | 302 ++++++++++++++++++++++++++++++++
 arm/tcg-test-asm.S        | 170 ++++++++++++++++++
 arm/tcg-test-asm64.S      | 169 ++++++++++++++++++
 arm/tcg-test.c            | 337 +++++++++++++++++++++++++++++++++++
 arm/tlbflush-code.c       | 212 ++++++++++++++++++++++
 arm/tlbflush-data.c       | 401 ++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg         | 190 ++++++++++++++++++++
 lib/arm/asm/barrier.h     |  63 ++++++-
 lib/arm64/asm/barrier.h   |  50 ++++++
 lib/libcflat.h            |   5 +
 lib/prng.c                | 162 +++++++++++++++++
 lib/prng.h                |  82 +++++++++
 run_tests.sh              |  18 +-
 scripts/functions.bash    |  13 +-
 scripts/runtime.bash      |   8 +
 20 files changed, 2626 insertions(+), 10 deletions(-)
 create mode 100644 arm/barrier-litmus-test.c
 create mode 100644 arm/locking-test.c
 create mode 100644 arm/tcg-test-asm.S
 create mode 100644 arm/tcg-test-asm64.S
 create mode 100644 arm/tcg-test.c
 create mode 100644 arm/tlbflush-code.c
 create mode 100644 arm/tlbflush-data.c
 create mode 100644 lib/prng.c
 create mode 100644 lib/prng.h

-- 
2.10.1

