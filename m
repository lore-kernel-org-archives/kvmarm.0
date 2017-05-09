From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 00/11] Fixes to v7 of the vITS save/restore series
Date: Tue,  9 May 2017 10:56:07 +0200
Message-ID: <20170509085618.28311-1-cdall@linaro.org>
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
git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git its-save-restore-queue-fixes-v2

Thanks,
-Christoffer

Changes since v1:
 - We got rid of the requirement to initialize the ITS (it doesn't do
   anything).
 - We fixed a race condition with setting the ITS base address which was
   introduced in v1 of this series.
 - We reworded some commit messages based on Eric's comments
 - We fixed the address check to work with partically unset base addrs
 - We use the vcpu index instead of the vcpu id for allocating redist
   regions.
 - Some renames and code cleanups.

Christoffer Dall (10):
  KVM: arm/arm64: Clarification and relaxation to ITS save/restore ABI
  KVM: arm/arm64: vgic: Rename kvm_vgic_vcpu_init to
    kvm_vgic_vcpu_enable
  KVM: Add kvm_vcpu_get_idx to get vcpu index in kvm->vcpus
  KVM: arm/arm64: Refactor vgic_register_redist_iodevs
  KVM: arm/arm64: Make vgic_v3_check_base more broadly usable
  KVM: arm/arm64: Slightly rework kvm_vgic_addr
  KVM: arm/arm64: Register iodevs when setting redist base and creating
    VCPUs
  KVM: arm/arm64: Register ITS iodev when setting base address
  KVM: arm/arm64: Don't call map_resources when restoring ITS tables
  KVM: arm/arm64: vgic-its: Cleanup after failed ITT restore

Marc Zyngier (1):
  KVM: arm/arm64: Get rid of its->initialized field

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  23 ++--
 include/kvm/arm_vgic.h                             |   2 +-
 include/linux/kvm_host.h                           |  11 ++
 virt/kvm/arm/arm.c                                 |   2 +-
 virt/kvm/arm/vgic/vgic-init.c                      |  25 +++-
 virt/kvm/arm/vgic/vgic-its.c                       |  96 +++++---------
 virt/kvm/arm/vgic/vgic-kvm-device.c                |  29 ++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   | 147 +++++++++++++++------
 virt/kvm/arm/vgic/vgic-v3.c                        |  33 +++--
 virt/kvm/arm/vgic/vgic.h                           |   5 +-
 10 files changed, 222 insertions(+), 151 deletions(-)

-- 
2.9.0
