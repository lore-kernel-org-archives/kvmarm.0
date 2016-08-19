From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/5] arm64: KVM: vgic-v2: Allow unsafe GICV accesses
Date: Fri, 19 Aug 2016 13:38:10 +0100
Message-ID: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In a number of cases, KVM cannot give access direct access to the
GICv2 GICV region, either because GICV is not page aligned, or its
size is not a multiple of the page size. This is especially visible
with 16kB/64kB pages and the original GIC-400 layout where each region
is only 4k aligned.

Instead of disabling KVM altogether (which is the current behaviour),
there is some value in trapping each guest GICV access, performing the
access as quickly as possible at EL2, and resuming the guest. This
allows us to keep KVM enabled on this HW.

Implementation wise, this is done with a static key controlling the
workaround being enabled, hence coming at zero cost (well, an extra
nop on the exit hot path) for unaffected platforms. On the affected
HW, I've measured a 10 to 15% overhead for a self-IPI test, which is
pretty bad, but still much better than not having a GIC at all.

Tested on Juno.

Marc Zyngier (5):
  arm/arm64: KVM: Don't BUG_ON if IT bits are set in ARM mode
  arm64: KVM: Allow kvm_skip_instr32 to be shared between kernel and HYP
    code
  arm64: KVM: vgic-v2: Add the GICV emulation infrastructure
  arm64: KVM: vgic-v2: Add GICV access from HYP
  arm64: KVM: vgic-v2: Enable GICV access from HYP if access from guest
    is unsafe

 arch/arm/kvm/emulate.c               |  4 +-
 arch/arm64/include/asm/kvm_emulate.h | 49 +++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_hyp.h     |  1 +
 arch/arm64/kvm/emulate.c             | 47 +-----------------------
 arch/arm64/kvm/hyp/switch.c          | 32 ++++++++++++++++
 include/kvm/arm_vgic.h               |  6 +++
 virt/kvm/arm/hyp/vgic-v2-sr.c        | 46 +++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c          | 71 ++++++++++++++++++++++--------------
 8 files changed, 180 insertions(+), 76 deletions(-)

-- 
2.1.4

