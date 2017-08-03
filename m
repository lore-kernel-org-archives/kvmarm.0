From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/4] KVM/ARM fixes for 4.13-rc4
Date: Thu,  3 Aug 2017 16:28:53 +0100
Message-ID: <20170803152857.32055-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Alex Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

Here's a pull request for a few KVM/ARM updates. Nothing major except
for a VM destruction race (Suzuki has a knack for finding those...).

Please pull.

	M.

The following changes since commit 5771a8c08880cdca3bfb4a3fc6d309d6bba20877:

  Linux v4.13-rc1 (2017-07-15 15:22:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.13-rc4

for you to fetch changes up to 3af4e414af5ce014d1f88cd816d997048298b310:

  KVM: arm/arm64: vgic: Use READ_ONCE fo cmpxchg (2017-08-03 15:47:36 +0100)

----------------------------------------------------------------
KVM/ARM Fixes for v4.13-rc4

- Yet another race with VM destruction plugged
- A set of small vgic fixes

----------------------------------------------------------------
Andrew Jones (1):
      KVM: arm/arm64: PMU: Fix overflow interrupt injection

Christoffer Dall (1):
      KVM: arm/arm64: vgic: Use READ_ONCE fo cmpxchg

Shanker Donthineni (1):
      KVM: arm/arm64: Fix bug in advertising KVM_CAP_MSI_DEVID capability

Suzuki K Poulose (1):
      KVM: arm/arm64: Handle hva aging while destroying the vm

 arch/arm64/kvm/sys_regs.c        |  2 +-
 include/kvm/arm_pmu.h            |  2 --
 virt/kvm/arm/mmu.c               |  4 ++++
 virt/kvm/arm/pmu.c               | 43 ++++++++++++++--------------------------
 virt/kvm/arm/vgic/vgic-init.c    |  3 ---
 virt/kvm/arm/vgic/vgic-its.c     |  1 +
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  4 ++--
 7 files changed, 23 insertions(+), 36 deletions(-)
