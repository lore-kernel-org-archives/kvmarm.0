From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v4 0/7] KVM: arm64: Implement API for vGICv3 live migration
Date: Mon, 28 Sep 2015 18:27:27 +0300
Message-ID: <cover.1443451687.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patchset adds necessary userspace API in order to support vGICv3 live
migration. GICv3 registers are accessed using device attribute ioctls,
similar to GICv2.

v3 => v4:
- Split pure refactoring from anything else
- Documentation brought up to date
- Cleaned up 'mmio' structure usage in vgic_attr_regs_access(),
  use call_range_handler() for 64-bit access handling
- Rebased on new linux-next

v2 => v3:
- KVM_DEV_ARM_VGIC_CPUID_MASK enlarged to 20 bits, allowing more than 256
  CPUs.
- Bug fix: Correctly set mmio->private, necessary for redistributor access.
- Added accessors for ICC_AP0R and ICC_AP1R registers
- Rebased on new linux-next

v1 => v2:
- Do not use generic register get/set API for CPU interface, use only
  device attributes.
- Introduce size specifier for distributor and redistributor register
  accesses, do not assume size any more.
- Lots of refactor and reusable code extraction.
- Added forgotten documentation

Pavel Fedin (7):
  KVM: arm/arm64: Move endianness conversion out of
    vgic_attr_regs_access()
  KVM: arm/arm64: Refactor vGIC attributes handling code
  KVM: arm/arm64: Fix the documentation
  KVM: arm64: Implement vGICv3 distributor and redistributor access from
    userspace
  KVM: arm64: Refactor system register handlers
  KVM: arm64: Introduce find_reg_by_id()
  Implement vGICv3 CPU interface access

 Documentation/virtual/kvm/devices/arm-vgic.txt |  90 ++++++-
 arch/arm64/include/uapi/asm/kvm.h              |  11 +-
 arch/arm64/kvm/sys_regs.c                      |  83 +++---
 arch/arm64/kvm/sys_regs.h                      |   8 +-
 arch/arm64/kvm/sys_regs_generic_v8.c           |   2 +-
 include/linux/irqchip/arm-gic-v3.h             |  18 +-
 virt/kvm/arm/vgic-v2-emul.c                    | 122 ++-------
 virt/kvm/arm/vgic-v3-emul.c                    | 338 ++++++++++++++++++++++++-
 virt/kvm/arm/vgic.c                            |  65 +++++
 virt/kvm/arm/vgic.h                            |   4 +
 10 files changed, 571 insertions(+), 170 deletions(-)

-- 
2.4.4

