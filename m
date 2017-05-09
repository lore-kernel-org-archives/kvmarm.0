From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 00/37] KVM/ARM Changes for v4.12 - Round 2
Date: Tue,  9 May 2017 12:44:29 +0200
Message-ID: <20170509104506.30929-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here is a second round of KVM/ARM Changes for v4.12.  I only just put
these changes in kvmarm/next, but we've tested them pretty thoroughly.

I know it's late in the merge window, but if we can still get them into
v4.12 that would be good as the ITS save/restore impedes migration on
GICv3 ARMv8 server systems.

The changes include:
 - A fix related to the 32-bit idmap stub
 - A fix to the bitmask used to deode the operands of an AArch32 CP
   instruction
 - We have moved the files shared between arch/arm/kvm and
   arch/arm64/kvm to virt/kvm/arm
 - We add support for saving/restoring the virtual ITS state to
   userspace

The following changes since commit 1edb632133efb6226b6bef3e7d9fa8c7134ac4e2:

  ARM: KVM: Fix idmap stub entry when running Thumb-2 code (2017-04-20 20:17:57 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.12-round2

for you to fetch changes up to a2b19e6e2d4bb662a64799541c144fd94f8fb024:

  KVM: arm/arm64: vgic-its: Cleanup after failed ITT restore (2017-05-09 12:19:46 +0200)


Thanks,
-Christoffer


Christoffer Dall (11):
  KVM: arm/arm64: Move shared files to virt/kvm/arm
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

Eric Auger (24):
  KVM: arm/arm64: Add ITS save/restore API documentation
  KVM: arm/arm64: Add GICV3 pending table save API documentation
  KVM: arm/arm64: vgic-its: rename itte into ite
  arm/arm64: vgic: turn vgic_find_mmio_region into public
  KVM: arm64: vgic-its: KVM_DEV_ARM_VGIC_GRP_ITS_REGS group
  KVM: arm/arm64: vgic: expose (un)lock_all_vcpus
  KVM: arm64: vgic-its: Implement vgic_its_has_attr_regs and
    attr_regs_access
  KVM: arm64: vgic-its: Implement vgic_mmio_uaccess_write_its_creadr
  KVM: arm64: vgic-its: Introduce migration ABI infrastructure
  KVM: arm64: vgic-its: Implement vgic_mmio_uaccess_write_its_iidr
  KVM: arm64: vgic-its: Interpret MAPD Size field and check related
    errors
  KVM: arm64: vgic-its: Interpret MAPD ITT_addr field
  KVM: arm64: vgic-its: Check the device id matches TYPER DEVBITS range
  KVM: arm64: vgic-v3: vgic_v3_lpi_sync_pending_status
  KVM: arm64: vgic-its: Read config and pending bit in add_lpi()
  KVM: arm64: vgic-its: KVM_DEV_ARM_ITS_SAVE/RESTORE_TABLES
  KVM: arm64: vgic-its: vgic_its_alloc_ite/device
  KVM: arm64: vgic-its: Add infrastructure for table lookup
  KVM: arm64: vgic-its: Collection table save/restore
  KVM: arm64: vgic-its: vgic_its_check_id returns the entry's GPA
  KVM: arm64: vgic-its: Device table save/restore
  KVM: arm64: vgic-its: ITT save and restore
  KVM: arm64: vgic-its: Fix pending table sync
  KVM: arm64: vgic-v3: KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES

Marc Zyngier (2):
  arm64: KVM: Fix decoding of Rt/Rt2 when trapping AArch32 CP accesses
  KVM: arm/arm64: Get rid of its->initialized field

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  121 ++
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt  |    6 +
 arch/arm/include/uapi/asm/kvm.h                    |    6 +-
 arch/arm/kvm/Makefile                              |    7 +-
 arch/arm/kvm/trace.h                               |  247 ----
 arch/arm64/include/asm/kvm_emulate.h               |    6 +
 arch/arm64/include/uapi/asm/kvm.h                  |    6 +-
 arch/arm64/kvm/Makefile                            |    5 +-
 arch/arm64/kvm/sys_regs.c                          |    8 +-
 include/kvm/arm_vgic.h                             |    5 +-
 include/linux/irqchip/arm-gic-v3.h                 |   14 +
 include/linux/kvm_host.h                           |   11 +
 {arch/arm/kvm => virt/kvm/arm}/arm.c               |    2 +-
 {arch/arm/kvm => virt/kvm/arm}/mmio.c              |    0
 {arch/arm/kvm => virt/kvm/arm}/mmu.c               |    0
 {arch/arm/kvm => virt/kvm/arm}/perf.c              |    0
 {arch/arm/kvm => virt/kvm/arm}/psci.c              |    0
 virt/kvm/arm/trace.h                               |  246 +++-
 virt/kvm/arm/vgic/trace.h                          |   37 +
 virt/kvm/arm/vgic/vgic-init.c                      |   25 +-
 virt/kvm/arm/vgic/vgic-its.c                       | 1234 +++++++++++++++++---
 virt/kvm/arm/vgic/vgic-kvm-device.c                |   53 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   |  147 ++-
 virt/kvm/arm/vgic/vgic-mmio.c                      |   11 +-
 virt/kvm/arm/vgic/vgic-mmio.h                      |   14 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |  128 +-
 virt/kvm/arm/vgic/vgic.c                           |    2 +-
 virt/kvm/arm/vgic/vgic.h                           |   33 +-
 28 files changed, 1837 insertions(+), 537 deletions(-)
 rename {arch/arm/kvm => virt/kvm/arm}/arm.c (99%)
 rename {arch/arm/kvm => virt/kvm/arm}/mmio.c (100%)
 rename {arch/arm/kvm => virt/kvm/arm}/mmu.c (100%)
 rename {arch/arm/kvm => virt/kvm/arm}/perf.c (100%)
 rename {arch/arm/kvm => virt/kvm/arm}/psci.c (100%)
 create mode 100644 virt/kvm/arm/vgic/trace.h

-- 
2.9.0
