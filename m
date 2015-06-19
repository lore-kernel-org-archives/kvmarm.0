From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL] KVM/ARM changes for 4.2
Date: Fri, 19 Jun 2015 13:53:04 +0100
Message-ID: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Firo Yang <firogm@gmail.com>, Tiejun Chen <tiejun.chen@intel.com>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Marcelo, Gleb,

This is the KVM/ARM pull request for 4.2. Not much this time, as what
we had planned for this merge window is taking longer that
expected. 4.3 should be a lot more significant.

Thanks,

	M.

The following changes since commit 3520469d65f26a1cd2f610f5d5de976f78db=
74fe:

  KVM: export __gfn_to_pfn_memslot, drop gfn_to_pfn_async (2015-05-19 2=
0:52:45 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/=
kvm-arm-for-4.2

for you to fetch changes up to c62e631d4a8e41493c6341d8259e996ed5fc11e3=
:

  KVM: arm/arm64: vgic: Remove useless arm-gic.h #include (2015-06-18 1=
5:50:31 +0100)

----------------------------------------------------------------
KVM/ARM changes for v4.2:

- Proper guest time accounting
- FP access fix for 32bit
- The usual pile of GIC fixes
- PSCI fixes
- Random cleanups

----------------------------------------------------------------
Alex Benn=C3=A9e (1):
      KVM: arm64: fix misleading comments in save/restore

Andre Przywara (1):
      KVM: arm64: add active register handling to GICv3 emulation as we=
ll

Christoffer Dall (1):
      arm/arm64: KVM: Properly account for guest CPU time

=46iro Yang (1):
      ARM: KVM: Remove pointless void pointer cast

Kim Phillips (1):
      KVM: arm/arm64: Enable the KVM-VFIO device

Lorenzo Pieralisi (1):
      ARM: kvm: psci: fix handling of unimplemented functions

Marc Zyngier (5):
      arm: KVM: force execution of HCPTR access on VM exit
      KVM: arm: vgic: Drop useless Group0 warning
      arm/arm64: KVM: vgic: Do not save GICH_HCR / ICH_HCR_EL2
      KVM: arm/arm64: vgic: Avoid injecting reserved IRQ numbers
      KVM: arm/arm64: vgic: Remove useless arm-gic.h #include

Tiejun Chen (1):
      kvm: remove one useless check extension

 arch/arm/kvm/Kconfig            |  1 +
 arch/arm/kvm/Makefile           |  2 +-
 arch/arm/kvm/arm.c              | 22 ++++++++++++----
 arch/arm/kvm/interrupts.S       | 10 +++-----
 arch/arm/kvm/interrupts_head.S  | 23 +++++++++++++----
 arch/arm/kvm/mmu.c              |  4 +--
 arch/arm/kvm/psci.c             | 16 +++---------
 arch/arm64/kvm/Kconfig          |  1 +
 arch/arm64/kvm/Makefile         |  2 +-
 arch/arm64/kvm/hyp.S            |  8 +++---
 arch/arm64/kvm/vgic-v2-switch.S |  3 ---
 arch/arm64/kvm/vgic-v3-switch.S |  2 --
 include/uapi/linux/kvm.h        |  2 +-
 virt/kvm/arm/vgic-v3-emul.c     | 56 +++++++++++++++++++++++++++++++++=
+++-----
 virt/kvm/arm/vgic.c             |  7 +-----
 15 files changed, 104 insertions(+), 55 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe kvm" in
