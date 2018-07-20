From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH v2 0/4] arm: add GICv2 MMIO tests
Date: Fri, 20 Jul 2018 16:39:38 +0100
Message-ID: <20180720153942.26821-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3FC140196
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 11:26:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7SD6GctJp+YJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jul 2018 11:26:42 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3F7940192
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 11:26:42 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

I found this in one my branches: this is an updated version of what I sent
end of 2016 [1]. I tried to address all comments that Drew and Eric had at
the time.
Please have a look whether this makes sense.

Changelog v1..v2:
- made many functions void
- use symbolic name for first SPI being number 32
- add test runs with one and three vCPUs
- use gic_version() directly
- factor out test_byte_access()
- drop redundant "filling priorities" test
- dropped GICv3 test

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-November/022352.html

Original cover letter:
======================
The GIC spec mandates certain constraints on how to acccess the MMIO
mapped registers, both in terms of which registers are available and also
in terms of which bits within a register should be masked, for instance.
Since we went through some lengths in the KVM emulation to implement this,
it's about time to give this actually a test beyond what the kernel as a
GIC user actually implements - for instance we ignore priorities in Linux.

This series tries to attack some constraints, on a low-hanging-fruit base.
It focusses on some generic registers and the PRIORITY and TARGETS registers
of GICv2. GICv3 is not covered yet.

This actually revealed genuine bugs in the KVM emulation in the past. KVM
passes these tests now, but QEMU fails some UP and 3-way-SMP tests.

Cheers,
Andre.

Andre Przywara (4):
  mark exit() and abort() as non-returning functions
  arm/arm64: GIC: basic GICv2 MMIO tests
  arm/arm64: GICv2: add GICD_IPRIORITYR testing
  arm/arm64: GICv2: add GICD_ITARGETSR testing

 arm/gic.c         | 213 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  18 +++++
 lib/arm/asm/gic.h |   5 ++
 lib/arm/io.c      |   1 +
 lib/libcflat.h    |   7 +-
 lib/powerpc/io.c  |   1 +
 lib/x86/io.c      |   1 +
 7 files changed, 243 insertions(+), 3 deletions(-)

-- 
2.14.4
