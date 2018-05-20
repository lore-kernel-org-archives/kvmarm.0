From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v7 00/13] KVM: arm/arm64: Allow multiple GICv3 redistributor regions
Date: Sun, 20 May 2018 23:22:39 +0200
Message-ID: <1526851372-13009-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

At the moment the KVM VGICv3 only supports a single redistributor
region (whose base address is set through the GICv3 kvm device
KVM_DEV_ARM_VGIC_GRP_ADDR/KVM_VGIC_V3_ADDR_TYPE_REDIST). There,
all the redistributors are laid out contiguously. The size of this
single redistributor region is not set explicitly but instead
induced at a late stage by the number of online vcpus.

The GIC specification does not mandate all redistributors to be
contiguous. Moreover DT and ACPI were specified so that multiple
redistributors regions can be defined.

The current interface brings a limitation on QEMU where ARM
virt machine available GPA holes only allowed to assign a
redistributor region fitting a max of 123 vcpus. Overcoming this
limitation would force either to create a new machine or relocate
the single rdist region or allow the allocation of multiple rdist
regions.

This series enables this last alternative. A new GICv3 KVM device
KVM_DEV_ARM_VGIC_GRP_ADDR/KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION allows
to register individual redistributor regions whose size is defined
explicitly. Those rdist regions then are filled by vcpu rdist frames
according to the need. The vgic init and related base address checks
are impacted.

Best Regards

Eric

Git: complete series available at
https://github.com/eauger/linux/tree/v4.17-rc5-rdist-regions-v7
Previous version:
https://github.com/eauger/linux/tree/v4.17-rc2-rdist-regions-v6

History:
v6 -> v7:
- fix bug reported by Marc with kvmtool caused by rd_iodev.base_addr
  and sgi_iodev.base_addr being initialized too late:
  in kvm_vgic_vcpu_early_init instead of kvm_vgic_vcpu_init
- removed kvm_vgic_vcpu_early_init()

v5 -> v6:
- truly use list_last_entry in vgic_v3_insert_redist_region
- s/pointed by/pointed to by in API doc
- collected last R-b/A-b

v4 -> v5:
- fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read path and update
  the documentation accordingly (removed Peter's and
  Christoffer's A-b)
- use u<n> instead of uint<n>_t
- collected additional R-b/A-b

v3 -> v4:
- Collected Christoffer's R-b
- reworked vgic_v3_rdist_overlap and introduced vgic_dist_overlap
- vgic_v3_insert_redist_region cleanup
- inverse order for patches 6 and 7

v2 -> v3:
- Add details to the user API documentation
- early exit if vgic_v3_rdist_region_from_index() fails
- return -EINVAL if legacy and new redist region API are mixed

v1 -> v2:
- Rework the uapi. Only bits [51:16] of the redist region are
  exposed. Also a new flags field was introduced
- Do not store the last bit in the vgic_cpu struct anymore
- remove dist->spis check in 1st patch
- add last patch to bump VGIC_V3_MAX_CPUS to 512
- advertise the new attribute


Eric Auger (13):
  KVM: arm/arm64: Set dist->spis to NULL after kfree
  KVM: arm/arm64: Document KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
  KVM: arm/arm64: Replace the single rdist region by a list
  KVM: arm/arm64: Helper to locate free rdist index
  KVM: arm/arm64: Revisit Redistributor TYPER last bit computation
  KVM: arm/arm64: Adapt vgic_v3_check_base to multiple rdist regions
  KVM: arm/arm64: Helper to register a new redistributor region
  KVM: arm/arm64: Remove kvm_vgic_vcpu_early_init
  KVM: arm/arm64: Check vcpu redist base before registering an iodev
  KVM: arm/arm64: Check all vcpu redistributors are set on map_resources
  KVM: arm/arm64: Add KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
  KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
  KVM: arm/arm64: Bump VGIC_V3_MAX_CPUS to 512

 Documentation/virtual/kvm/devices/arm-vgic-v3.txt |  30 +++++-
 arch/arm/include/uapi/asm/kvm.h                   |   1 +
 arch/arm64/include/uapi/asm/kvm.h                 |   1 +
 include/kvm/arm_vgic.h                            |  17 ++--
 virt/kvm/arm/arm.c                                |   1 -
 virt/kvm/arm/vgic/vgic-init.c                     |  99 ++++++++++---------
 virt/kvm/arm/vgic/vgic-kvm-device.c               |  53 +++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                  | 114 +++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-v3.c                       | 101 +++++++++++++++----
 virt/kvm/arm/vgic/vgic.h                          |  42 +++++++-
 10 files changed, 369 insertions(+), 90 deletions(-)

-- 
2.5.5
