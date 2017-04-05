From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 0/5] KVM/ARM Fixes for v4.11-rc6
Date: Wed,  5 Apr 2017 12:13:26 +0200
Message-ID: <20170405101331.23812-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Please pull a handfull of fixes for the next -rc release of v4.11.

They include:
 - Addressing a problem with GICv3 userspace save/restore
 - Clarify GICv2 userspace save/restore ABI
 - Be more careful in clearing GIC LRs
 - Add missing synchronization primitive to our MMU handling code

The following changes since commit 955a3fc6d2a1c11d6d00bce4f3816100ce0530cf:

  KVM: arm64: Increase number of user memslots to 512 (2017-03-09 09:13:50 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-for-v4.11-rc6

for you to fetch changes up to 6d56111c92d247bb64301029fe88365aa4caf16e:

  KVM: arm/arm64: vgic: Fix GICC_PMR uaccess on GICv3 and clarify ABI (2017-04-04 14:33:59 +0200)

Thanks,
-Christoffer

Christoffer Dall (2):
      KVM: arm64: Ensure LRs are clear when they should be
      KVM: arm/arm64: vgic: Fix GICC_PMR uaccess on GICv3 and clarify ABI

Marc Zyngier (2):
      arm/arm64: KVM: Take mmap_sem in stage2_unmap_vm
      arm/arm64: KVM: Take mmap_sem in kvm_arch_prepare_memory_region

Suzuki K Poulose (1):
      kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd

 Documentation/virtual/kvm/devices/arm-vgic.txt |  6 ++++++
 arch/arm/kvm/arm.c                             |  3 +++
 arch/arm/kvm/mmu.c                             | 23 ++++++++++++++++++++---
 include/kvm/arm_vgic.h                         |  1 +
 include/linux/irqchip/arm-gic.h                |  3 +++
 virt/kvm/arm/vgic/vgic-init.c                  | 19 +++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v2.c               | 20 ++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-v2.c                    | 23 +++++++++++++++++++----
 virt/kvm/arm/vgic/vgic.h                       | 11 ++++++++++-
 9 files changed, 99 insertions(+), 10 deletions(-)
