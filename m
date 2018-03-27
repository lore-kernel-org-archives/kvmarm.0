From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 00/12] KVM: arm/arm64: Allow multiple GICv3 redistributor regions
Date: Tue, 27 Mar 2018 16:04:04 +0200
Message-ID: <1522159456-10419-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
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
https://github.com/eauger/linux/tree/4.16-rc7-rdist-regions-rfc-v2
Previous version:
https://github.com/eauger/linux/tree/v4.16-rc5-rdist-regions-rfc

History:
- Rework the uapi. Only bits [51:16] of the redist region are
  exposed. Also a new flags field was introduced
- Do not store the last bit in the vgic_cpu struct anymore
- remove dist->spis check in 1st patch
- add last patch to bump VGIC_V3_MAX_CPUS to 512
- advertise the new attribute

Eric Auger (12):
  KVM: arm/arm64: Set dist->spis to NULL after kfree
  KVM: arm/arm64: Document KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
  KVM: arm/arm64: Replace the single rdist region by a list
  KVM: arm/arm64: Helper to locate free rdist index
  KVM: arm/arm64: Revisit Redistributor TYPER last bit computation
  KVM: arm/arm64: Helper to register a new redistributor region
  KVM: arm/arm64: Adapt vgic_v3_check_base to multiple rdist regions
  KVM: arm/arm64: Check vcpu redist base before registering an iodev
  KVM: arm/arm64: Check all vcpu redistributors are set on map_resources
  KVM: arm/arm64: Add KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
  KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
  KVM: arm/arm64: Bump VGIC_V3_MAX_CPUS to 512

 Documentation/virtual/kvm/devices/arm-vgic-v3.txt |  18 ++++
 arch/arm/include/uapi/asm/kvm.h                   |   7 +-
 arch/arm64/include/uapi/asm/kvm.h                 |   7 +-
 include/kvm/arm_vgic.h                            |  16 ++-
 virt/kvm/arm/vgic/vgic-init.c                     |  20 +++-
 virt/kvm/arm/vgic/vgic-kvm-device.c               |  53 +++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                  | 116 +++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-v3.c                       |  87 ++++++++++++----
 virt/kvm/arm/vgic/vgic.h                          |  34 ++++++-
 9 files changed, 308 insertions(+), 50 deletions(-)

-- 
2.5.5
