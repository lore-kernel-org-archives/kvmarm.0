From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 00/13] KVM/ARM Fixes for v4.12-rc2
Date: Thu, 18 May 2017 11:47:09 +0200
Message-ID: <20170518094722.9926-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Radim and Paolo,

Here is a fairly large set of fixes post -rc1 for KVM/ARM.

The fixes include:
 - A fix for a build failure introduced in -rc1 when tracepoints are
   enabled on 32-bit ARM.
 - Disabling use of stack pointer protection in the hyp code which can
   cause panics.
 - A handful of VGIC fixes.
 - A fix to the init of the redistributors on GICv3 systems that
   prevented boot with kvmtool on GICv3 systems introduced in -rc1.
 - A number of race conditions fixed in our MMU handling code.
 - A fix for the guest being able to program the debug extensions for
   the host on the 32-bit side.

The following changes since commit 2ea659a9ef488125eb46da6eb571de5eae5c43f6:

  Linux 4.12-rc1 (2017-05-13 13:19:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.12-rc2

for you to fetch changes up to fa472fa91a5a0b241f5ddae927d2e235d07545df:

  KVM: arm/arm64: Hold slots_lock when unregistering kvm io bus devices (2017-05-18 11:18:16 +0200)


Thanks,
-Christoffer

Christoffer Dall (2):
      KVM: arm/arm64: Fix bug when registering redist iodevs
      KVM: arm/arm64: Hold slots_lock when unregistering kvm io bus devices

Marc Zyngier (6):
      ARM: KVM: Fix tracepoint generation after move to virt/kvm/arm/
      arm64: KVM: Do not use stack-protector to compile EL2 code
      arm: KVM: Do not use stack-protector to compile HYP code
      KVM: arm/arm64: vgic-v2: Do not use Active+Pending state for a HW interrupt
      KVM: arm/arm64: vgic-v3: Do not use Active+Pending state for a HW interrupt
      KVM: arm/arm64: vgic-v3: Use PREbits to infer the number of ICH_APxRn_EL2 registers

Suzuki K Poulose (3):
      kvm: arm/arm64: Fix race in resetting stage2 PGD
      kvm: arm/arm64: Force reading uncached stage2 PGD
      kvm: arm/arm64: Fix use after free of stage2 page table

Zhichao Huang (2):
      KVM: arm: plug potential guest hardware debug leakage
      KVM: arm: rename pm_fake handler to trap_raz_wi

 arch/arm/include/asm/kvm_coproc.h |   3 +-
 arch/arm/kvm/coproc.c             | 106 ++++++++++++++++++++++++++------------
 arch/arm/kvm/handle_exit.c        |   4 +-
 arch/arm/kvm/hyp/Makefile         |   2 +
 arch/arm/kvm/hyp/switch.c         |   4 +-
 arch/arm/kvm/trace.h              |   8 +--
 arch/arm64/kvm/hyp/Makefile       |   2 +
 include/kvm/arm_vgic.h            |   5 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c     |  18 +++----
 virt/kvm/arm/mmu.c                |  33 +++++++-----
 virt/kvm/arm/vgic/vgic-init.c     |   5 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c  |  12 +++--
 virt/kvm/arm/vgic/vgic-v2.c       |   7 +++
 virt/kvm/arm/vgic/vgic-v3.c       |   7 +++
 14 files changed, 150 insertions(+), 66 deletions(-)
