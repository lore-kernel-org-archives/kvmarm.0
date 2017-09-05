From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 0/8] KVM/ARM Changes for v4.14
Date: Tue,  5 Sep 2017 16:51:59 +0200
Message-ID: <20170905145207.18447-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here are the changes for KVM/ARM for v4.14.

The changes are mostly bug fixes which are cc'ed stable.

We also have some minor cleanups and improvements, including added
support for migrating the active priority of interrupts when running a
GICv2 guest on a GICv3 host.

Sorry about arriving with these rather late.

The following changes since commit 5771a8c08880cdca3bfb4a3fc6d309d6bba20877:

  Linux v4.13-rc1 (2017-07-15 15:22:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.14

for you to fetch changes up to f3470ce68ee2917ea17d27521b379af117b48c02:

  KVM: arm/arm64: Support uaccess of GICC_APRn (2017-09-05 16:46:30 +0200)


Thanks,
-Christoffer

Andrew Jones (1):
  KVM: arm/arm64: PMU: Fix overflow interrupt injection

Arvind Yadav (1):
  KVM: arm/arm64: vgic: constify seq_operations and file_operations

Christoffer Dall (2):
  KVM: arm/arm64: Extract GICv3 max APRn index calculation
  KVM: arm/arm64: Support uaccess of GICC_APRn

James Morse (1):
  KVM: arm/arm64: Fix guest external abort matching

Marc Zyngier (1):
  KVM: arm/arm64: vITS: Drop its_ite->lpi field

Shanker Donthineni (1):
  KVM: arm/arm64: Fix bug in advertising KVM_CAP_MSI_DEVID capability

Suzuki K Poulose (1):
  KVM: arm/arm64: Handle hva aging while destroying the vm

 Documentation/virtual/kvm/devices/arm-vgic.txt |  5 +++
 arch/arm/include/asm/kvm_arm.h                 |  1 -
 arch/arm/include/asm/kvm_emulate.h             | 24 ++++++++++---
 arch/arm64/include/asm/kvm_emulate.h           | 24 ++++++++++---
 arch/arm64/kvm/sys_regs.c                      |  2 +-
 arch/arm64/kvm/vgic-sys-reg-v3.c               | 23 ++-----------
 include/kvm/arm_pmu.h                          |  2 --
 virt/kvm/arm/mmu.c                             | 44 ++++++++----------------
 virt/kvm/arm/pmu.c                             | 43 ++++++++---------------
 virt/kvm/arm/vgic/vgic-debug.c                 |  4 +--
 virt/kvm/arm/vgic/vgic-init.c                  |  3 --
 virt/kvm/arm/vgic/vgic-its.c                   | 11 +++---
 virt/kvm/arm/vgic/vgic-mmio-v2.c               | 47 +++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h                       | 16 +++++++++
 14 files changed, 146 insertions(+), 103 deletions(-)

-- 
2.9.0
