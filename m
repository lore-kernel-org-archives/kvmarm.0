From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 00/19] KVM/ARM Fixes for v4.15
Date: Mon,  4 Dec 2017 14:56:18 +0100
Message-ID: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Hi Paolo and Radim,

Here's the first round of fixes for KVM/ARM for v4.15.  This is a fairly large
set of fixes, partially because we spotted a handful of issues from running the
SMATCH static analysis on the code (thanks to AKASHI Takahiro).

In more details, this pull request fixes:
 - A number of issues in the vgic discovered using SMATCH
 - A bit one-off calculation in out stage base address mask (32-bit and
   64-bit)
 - Fixes to single-step debugging instructions that trap for other
   reasons such as MMMIO aborts
 - Printing unavailable hyp mode as error
 - Potential spinlock deadlock in the vgic
 - Avoid calling vgic vcpu free more than once
 - Broken bit calculation for big endian systems


The following changes since commit 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323:

  Linux 4.15-rc1 (2017-11-26 16:01:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-fixes-for-v4.15-1

for you to fetch changes up to fc396e066318c0a02208c1d3f0b62950a7714999:

  KVM: arm/arm64: Fix broken GICH_ELRSR big endian conversion (2017-12-04 14:25:33 +0100)


Thanks,
-Christoffer

Alex Bennée (5):
  KVM: arm/arm64: debug: Introduce helper for single-step
  kvm: arm64: handle single-stepping trapped instructions
  kvm: arm64: handle single-step of userspace mmio instructions
  kvm: arm64: handle single-step during SError exceptions
  kvm: arm64: handle single-step of hyp emulated mmio instructions

Andre Przywara (1):
  KVM: arm/arm64: VGIC: extend !vgic_is_initialized guard

Andrew Jones (1):
  KVM: arm/arm64: kvm_arch_destroy_vm cleanups

Ard Biesheuvel (1):
  kvm: arm: don't treat unavailable HYP mode as an error

Christoffer Dall (3):
  KVM: arm/arm64: Don't enable/disable physical timer access on VHE
  KVM: arm/arm64: Avoid attempting to load timer vgic state without a
    vgic
  KVM: arm/arm64: Fix broken GICH_ELRSR big endian conversion

Kristina Martsenko (1):
  arm64: KVM: fix VTTBR_BADDR_MASK BUG_ON off-by-one

Marc Zyngier (7):
  KVM: arm/arm64: vgic-irqfd: Fix MSI entry allocation
  KVM: arm/arm64: vgic: Preserve the revious read from the pending table
  KVM: arm/arm64: vgic-its: Preserve the revious read from the pending
    table
  KVM: arm/arm64: vgic-its: Check result of allocation before use
  KVM: arm/arm64: vgic-v4: Only perform an unmap for valid vLPIs
  arm: KVM: Fix VTTBR_BADDR_MASK BUG_ON off-by-one
  KVM: arm/arm64: Fix spinlock acquisition in vgic_set_owner

 arch/arm/include/asm/kvm_arm.h    |  3 +--
 arch/arm/include/asm/kvm_host.h   |  5 ++++
 arch/arm64/include/asm/kvm_arm.h  |  3 +--
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/debug.c            | 21 +++++++++++++++
 arch/arm64/kvm/handle_exit.c      | 57 ++++++++++++++++++++++++++++-----------
 arch/arm64/kvm/hyp/switch.c       | 37 ++++++++++++++++++++-----
 include/kvm/arm_arch_timer.h      |  3 ---
 virt/kvm/arm/arch_timer.c         | 11 +++-----
 virt/kvm/arm/arm.c                |  7 +++--
 virt/kvm/arm/hyp/timer-sr.c       | 48 ++++++++++++++-------------------
 virt/kvm/arm/hyp/vgic-v2-sr.c     |  4 ---
 virt/kvm/arm/vgic/vgic-irqfd.c    |  3 +--
 virt/kvm/arm/vgic/vgic-its.c      |  4 ++-
 virt/kvm/arm/vgic/vgic-v3.c       |  2 +-
 virt/kvm/arm/vgic/vgic-v4.c       |  6 +++--
 virt/kvm/arm/vgic/vgic.c          |  8 +++---
 17 files changed, 144 insertions(+), 79 deletions(-)

-- 
2.14.2
