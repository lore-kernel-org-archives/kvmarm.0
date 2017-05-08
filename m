From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 0/8] Fixes to v7 of the vITS save/restore series
Date: Mon,  8 May 2017 13:54:46 +0200
Message-ID: <20170508115454.5075-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We spotted a number of isses on the v7 ITS save/restore patch series,
but because most of that patch series is in really good shape, and
because the work discussed is somewhat orthogonal (the register iodevs
in particular), I decided to send out a set of fixes to apply after the
main ITS save/restore series, and we can apply the v7 series plus these
fixes.

The whole series with the fixes applied on top of queue can be found here:
git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git its-save-restore-queue-fixes

Thanks,
-Christoffer

Christoffer Dall (8):
  KVM: arm/arm64: Clarification and relaxation to ITS save/restore ABI
  KVM: arm/arm64: vgic: Rename kvm_vgic_vcpu_init to
    kvm_vgic_vcpu_enable
  KVM: arm/arm64: Refactor vgic_register_redist_iodevs
  KVM: arm/arm64: Make vgic_v3_check_base more broadly usable
  KVM: arm/arm64: Slightly rework kvm_vgic_addr
  KVM: arm/arm64: Register iodevs when setting redist base and creating
    VCPUs
  KVM: arm/arm64: Register ITS iodev when setting base address
  KVM: arm/arm64: vgic-its: Cleanup after failed ITT restore

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  19 +--
 include/kvm/arm_vgic.h                             |   1 +
 virt/kvm/arm/arm.c                                 |   6 +-
 virt/kvm/arm/vgic/vgic-init.c                      |  25 +++-
 virt/kvm/arm/vgic/vgic-its.c                       |  64 ++++-----
 virt/kvm/arm/vgic/vgic-kvm-device.c                |  29 ++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   | 147 +++++++++++++++------
 virt/kvm/arm/vgic/vgic-v3.c                        |  32 ++---
 virt/kvm/arm/vgic/vgic.h                           |   5 +-
 9 files changed, 201 insertions(+), 127 deletions(-)

-- 
2.9.0
