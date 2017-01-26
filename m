From: vijay.kilari@gmail.com
Subject: [PATCH v11 0/8] arm/arm64: vgic: Implement API for vGICv3 live
 migration
Date: Thu, 26 Jan 2017 19:50:45 +0530
Message-ID: <1485440453-10597-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, eric.auger@redhat.com, peter.maydell@linaro.org
Cc: p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

This patchset adds API for saving and restoring
of VGICv3 registers to support live migration with new vgic feature.
This API definition is as per version of VGICv3 specification
Documentation/virtual/kvm/devices/arm-vgic-v3.txt

The patch 3 & 4 are picked from the Pavel's previous implementation.
http://www.spinics.net/lists/kvm/msg122040.html

NOTE: Only compilation tested for AArch32. No hardware available to test.

v10 => v11:
 - Rebased on top of kvmarm queue branch
 - Renamed KVM_DEV_ARM_VGIC_CPU_SYSREGS to KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
 - Used vcpu0 for KVM_DEV_ARM_VGIC_GRP_DIST_REGS access
 - Exported vgic_v{2,3}_has_attr_regs()
 - Used vgic_get_mmio_region() in vgic_v{2,3}_has_attr_regs() for checking
   validity of regs address in patch 2.
 - Moved macros KVM_REG_ARM_VGIC_SYSREG_* from patch 2 to patch 6
 - Fixed comments from Eric Auger
 - Updated document.

v9 => v10:
 - Dropped support for AArch32 mode.
 - Fixed line level update
 - Updated documentation
 - Moved vgic-sys-reg-v3.c to arch/arm64/kvm/ and
   added vgic-v3-coproc.c to arch/arm/kvm for AArch32
 - Fixed nits

v8 => v9:
 - Rebased to kvmarm/next branch
 - Introduce support for save and restore of CPU interface
   registers for AArch32 mode (9,10 and 11 patches).
   Only compilation tested.
 - Fixed vmcr.ctlr format
 - Updated error code for invalid CPU REG value in Documentation
 - Updated commit messages and added comments required
 - Queued IRQ when irq_line is set.
 - Compatibility check on ICC_CTLR_EL1.SEIS and A3V

v7 => v8:
 - Rebased to 4.9-rc3
 - Fixed wrong parameter to VGIC_TO_MPIDR
v6 => v7:
 - Rename all patches heading from vgic-new to vgic
 - Moved caching of priority and ID bits from vgic global struct
   to vgic_cpu struct.

v5 => v6:
 - Collated all register definitions to single patch (4)
 - Introduce macro to convert userspace MPIDR format to MPIDR reg format
 - Check on ICC_CTLR_EL1.CBPR value is made while accessing ICC_BPR1_EL1
 - Cached ich_vtr_el2 and guests priority and ID bits
 - Check on number of priority and ID bits when ICC_CTRL_EL1 write is made
 - Check is made on SRE bit for ICC_SRE_EL1 write

v4 => v5:
 - ICC_CTLR_EL1 access is updated to reflect HW values
 - Updated ICC reg access mask and shift macros
 - Introduced patch 4 for VMCR changes
 - Other minor fixes.
v3 => v4:
 - Rebased to latest code base
 - Moved vgic_uaccess() from vgic-mmio-v2.c to vgic-mmio.c
 - Dropped macro REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED_UACCESS
 - Dropped LE conversion for userspace access
 - Introduced vgic_uaccess_write_pending() for ISPENDR write
 - Change macro KVM_DEV_ARM_VGIC_V3_CPUID_MASK to KVM_DEV_ARM_VGIC_V3_MIDR_MASK
 - Refactored some code as common code.
 - Changed handing of ICC_* registers
 - Allowed ICC_SRE_EL1 read by userspace
 - Fixed KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_* macros

v2 => v3:
 - Implemented separate API for ISPENDR and ICPENDR to
   read soft_pending instead of pending for level triggerred interrupts
 - Implemented ioctl KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO to access line level
 - Rebased on top of Christoffer's patch set
   http://www.spinics.net/lists/kvm/msg136840.html

 NOTE: GICD_STATUSR and GICR_STATUSR are implemented as RAZ/WI.

v1 => v2:
 - The init sequence change patch is no more required.
   Fixed in patch 2 by using static vgic_io_dev regions structure instead
   of using dynamic allocation pointer.
 - Updated commit message of patch 4.
 - Dropped usage of union to manage 32-bit and 64-bit access in patch 1.
   Used local variable for 32-bit access.
 - Updated macro __ARM64_SYS_REG and ARM64_SYS_REG in
   arch/arm64/include/uapi/asm/kvm.h as per qemu requirements.

Vijaya Kumar K (8):
  arm/arm64: vgic: Implement support for userspace access
  arm/arm64: vgic: Add distributor and redistributor access
  arm/arm64: vgic: Introduce find_reg_by_id()
  irqchip/gic-v3: Add missing system register definitions
  arm/arm64: vgic: Introduce VENG0 and VENG1 fields to vmcr struct
  arm/arm64: vgic: Implement VGICv3 CPU interface access
  arm/arm64: vgic: Implement KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
  arm/arm64: Documentation: Update arm-vgic-v3.txt

 Documentation/virtual/kvm/devices/arm-vgic-v3.txt |  11 +-
 arch/arm/include/uapi/asm/kvm.h                   |  13 +
 arch/arm/kvm/Makefile                             |   4 +-
 arch/arm/kvm/vgic-v3-coproc.c                     |  35 +++
 arch/arm64/include/uapi/asm/kvm.h                 |  13 +
 arch/arm64/kvm/Makefile                           |   3 +-
 arch/arm64/kvm/sys_regs.c                         |  27 +-
 arch/arm64/kvm/sys_regs.h                         |   4 +
 arch/arm64/kvm/vgic-sys-reg-v3.c                  | 346 ++++++++++++++++++++++
 include/kvm/arm_vgic.h                            |   8 +
 include/linux/irqchip/arm-gic-v3.h                |  45 ++-
 virt/kvm/arm/vgic/vgic-kvm-device.c               | 231 ++++++++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v2.c                  |  81 ++---
 virt/kvm/arm/vgic/vgic-mmio-v3.c                  | 201 +++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c                     | 148 ++++++++-
 virt/kvm/arm/vgic/vgic-mmio.h                     |  24 ++
 virt/kvm/arm/vgic/vgic-v3.c                       |  28 +-
 virt/kvm/arm/vgic/vgic.h                          |  72 ++++-
 18 files changed, 1171 insertions(+), 123 deletions(-)
 create mode 100644 arch/arm/kvm/vgic-v3-coproc.c
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v3.c

-- 
1.9.1
