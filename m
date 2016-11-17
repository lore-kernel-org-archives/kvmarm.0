From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH 0/4] kvm-unit-tests: add first GIC MMIO tests
Date: Thu, 17 Nov 2016 17:57:48 +0000
Message-ID: <20161117175752.16475-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org
List-Id: kvmarm@lists.cs.columbia.edu

The GIC spec mandates certain constraints on how to acccess the MMIO
mapped registers, both in terms of which registers are available and also
in terms of which bits within a register should be masked, for instance.
Since we went through some lengths in the KVM emulation to implement this,
it's about time to give this actually a test beyond what the kernel as a
GIC user actually implements - for instance we ignore priorities in Linux.

This series tries to attack some constraints, on a low-hanging-fruit base.
It focusses on some generic registers and the PRIORITY and TARGETS registers
of GICv2. GICv3 is only covered to the point where the GICv2 tests overlap
with GICv3.

This actually revealed genuine bugs in the KVM emulation, for which I sent
fixes in the last days. With those fixes the kernel passes all tests.

Please have a look whether this makes sense and should eventually be
extended on that base.

Applies on top of master + Drew's v6 series.

Cheers,
Andre.

Andre Przywara (4):
  arm/arm64: GIC: basic GICv2 MMIO tests
  arm/arm64: GICv2: add GICD_IPRIORITYR testing
  arm/arm64: GICv2: add GICD_ITARGETSR testing
  arm/arm64: GICv3: add TYPER test

 arm/gic.c         | 253 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  12 +++
 lib/arm/asm/gic.h |   3 +
 3 files changed, 268 insertions(+)

-- 
2.9.0

