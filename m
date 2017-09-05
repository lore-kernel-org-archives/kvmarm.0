From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL v2 0/5] KVM/ARM Changes for v4.14
Date: Tue,  5 Sep 2017 17:41:01 +0200
Message-ID: <20170905154106.2945-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here is v2 of the changes for kvm/arm for v4.14.  Hopefully I got it
right this time.

Two minor cleanups and improvements, a fix for decoding external abort
types from guests, and added support for migrating the active priority
of interrupts when running a GICv2 guest on a GICv3 host.

The following changes since commit 712b12d72451411c40e39d25e2140fb8c7fd0e49:

  kvm: nVMX: Validate the virtual-APIC address on nested VM-entry (2017-08-25 12:34:16 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.14

for you to fetch changes up to 9b87e7a8bfb5098129836757608b3cbbdc11245a:

  KVM: arm/arm64: Support uaccess of GICC_APRn (2017-09-05 17:33:39 +0200)


Thanks,
-Christoffer

Arvind Yadav (1):
  KVM: arm/arm64: vgic: constify seq_operations and file_operations

Christoffer Dall (2):
  KVM: arm/arm64: Extract GICv3 max APRn index calculation
  KVM: arm/arm64: Support uaccess of GICC_APRn

James Morse (1):
  KVM: arm/arm64: Fix guest external abort matching

Marc Zyngier (1):
  KVM: arm/arm64: vITS: Drop its_ite->lpi field

 Documentation/virtual/kvm/devices/arm-vgic.txt |  5 +++
 arch/arm/include/asm/kvm_arm.h                 |  1 -
 arch/arm/include/asm/kvm_emulate.h             | 24 ++++++++++---
 arch/arm64/include/asm/kvm_emulate.h           | 24 ++++++++++---
 arch/arm64/kvm/vgic-sys-reg-v3.c               | 23 ++-----------
 virt/kvm/arm/mmu.c                             | 40 ++++++----------------
 virt/kvm/arm/vgic/vgic-debug.c                 |  4 +--
 virt/kvm/arm/vgic/vgic-its.c                   | 10 +++---
 virt/kvm/arm/vgic/vgic-mmio-v2.c               | 47 +++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h                       | 16 +++++++++
 10 files changed, 125 insertions(+), 69 deletions(-)

-- 
