From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 00/17] kvm: arm64: Dynamic & 52bit IPA support
Date: Tue, 27 Mar 2018 14:15:10 +0100
Message-ID: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, ard.biesheuvel@linaro.org, peter.maydell@linaro.org, kristina.martsenko@arm.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The physical address space size for a VM (IPA size) on arm/arm64 is
limited to a static limit of 40bits. This series adds support for
using a limit specific to a VM, allowing to use a limit supported
by the host (based on the host kernel configuration and CPU support).
The default and the minimum size is fixed to 40bits. We also add
support for handling 52bit IPA addresses added by Arm v8.2 extensions.

As mentioned above, the supported IPA size on a host could be different
from the system's PARange indicated by the CPUs (e.g, kernel limit
on the PA size). So we expose the limit via a new system ioctl request
 - KVM_ARM_GET_MAX_VM_PHYS_SHIFT - on arm/arm64. This can then be
passed on to the KVM_CREATE_VM ioctl, encoded in the "type" field.
Bits [7-0] of the type are reserved for the IPA size. This approach
allows simpler management of the stage2 page table and guest memory
slots.

The arm64 page table level helpers are defined based on the page
table levels used by the host VA. So, the accessors may not work
if the guest uses more number of levels in stage2 than the stage1
of the host. In order to provide an independent stage2 page table,
we refactor the arm64 page table helpers to give us raw accessors
for each level, which should only used when that level is present.
And then, based on the VM, we make the decision of the stage2
page table using the raw accessors.

52bit support is added for VGIC (including ITS emulation) and handling
of PAR, HPFAR registers.

The series applies on arm64 for-next/core. A tree is available here:

	 git://linux-arm.org/linux-skp.git ipa52/v2

Changes since V1:
 - Change the userspace API for configuring VM to encode the IPA
   size in the VM type.  (suggested by Christoffer)
 - Expose the IPA limit on the host via ioctl on /dev/kvm
 - Handle 52bit addresses in PAR & HPFAR
 - Drop patch changing the life time of stage2 PGD
 - Rename macros for 48-to-52 bit conversion for GIC ITS BASER.
   (suggested by Christoffer)
 - Split virtio PFN check patches and address comments.

The series also adds :
 - Support for handling 52bit IPA for vgic ITS.
 - Cleanup in virtio to handle errors when the PFN used in
   the virtio transport doesn't fit in 32bit.

Tested with
  - Modified kvmtool, which can only be used for (patches included in
    the series for reference / testing):
    * with virtio-pci upto 44bit PA (Due to 4K page size for virtio-pci
      legacy implemented by kvmtool)
    * Upto 48bit PA with virtio-mmio, due to 32bit PFN limitation.
  - Hacked Qemu (boot loader support for highmem, phys-shift support)
    * with virtio-pci GIC-v3 ITS & MSI upto 52bit on Foundation model.

Kristina Martsenko (1):
  vgic: Add support for 52bit guest physical address

Suzuki K Poulose (16):
  virtio: mmio-v1: Validate queue PFN
  virtio: pci-legacy: Validate queue pfn
  arm64: Make page table helpers reusable
  arm64: Refactor pud_huge for reusability
  arm64: Helper for parange to PASize
  kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table
  kvm: arm/arm64: Remove spurious WARN_ON
  kvm: arm/arm64: Prepare for VM specific stage2 translations
  kvm: arm64: Make stage2 page table layout dynamic
  kvm: arm64: Dynamic configuration of VTCR and VTTBR mask
  kvm: arm64: Configure VTCR per VM
  kvm: arm/arm64: Expose supported physical address limit for VM
  kvm: arm/arm64: Allow tuning the physical address size for VM
  kvm: arm64: Switch to per VM IPA limit
  kvm: arm64: Add support for handling 52bit IPA
  kvm: arm64: Allow IPA size supported by the system

 Documentation/virtual/kvm/api.txt             |  14 ++
 arch/arm/include/asm/kvm_arm.h                |   3 +-
 arch/arm/include/asm/kvm_mmu.h                |  22 ++-
 arch/arm/include/asm/stage2_pgtable.h         |  42 ++---
 arch/arm64/include/asm/cpufeature.h           |  16 ++
 arch/arm64/include/asm/kvm_arm.h              | 119 +++++++++++++--
 arch/arm64/include/asm/kvm_asm.h              |   2 +-
 arch/arm64/include/asm/kvm_host.h             |  19 ++-
 arch/arm64/include/asm/kvm_mmu.h              |  71 +++++++--
 arch/arm64/include/asm/pgalloc.h              |  34 ++++-
 arch/arm64/include/asm/pgtable.h              |  63 +++++---
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |  42 -----
 arch/arm64/include/asm/stage2_pgtable-nopud.h |  39 -----
 arch/arm64/include/asm/stage2_pgtable.h       | 211 +++++++++++++++++---------
 arch/arm64/kvm/hyp/s2-setup.c                 |  34 +----
 arch/arm64/kvm/hyp/switch.c                   |   7 +-
 arch/arm64/mm/hugetlbpage.c                   |   2 +-
 drivers/virtio/virtio_mmio.c                  |  18 ++-
 drivers/virtio/virtio_pci_legacy.c            |  12 +-
 include/linux/irqchip/arm-gic-v3.h            |   5 +
 include/uapi/linux/kvm.h                      |  16 ++
 virt/kvm/arm/arm.c                            |  32 +++-
 virt/kvm/arm/mmu.c                            | 124 ++++++++-------
 virt/kvm/arm/vgic/vgic-its.c                  |  37 ++---
 virt/kvm/arm/vgic/vgic-kvm-device.c           |   2 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c              |   2 -
 26 files changed, 626 insertions(+), 362 deletions(-)
 delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
 delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h

kvmtool hack for IPA support :

Suzuki K Poulose (4):
  kvmtool: Allow backends to run checks on the KVM device fd
  kvmtool: arm64: Add support for guest physical address size
  kvmtool: arm64: Switch memory layout
  kvmtool: arm: Add support for creating VM with PA size

 arm/aarch32/include/kvm/kvm-arch.h        |  1 +
 arm/aarch64/include/kvm/kvm-arch.h        | 15 ++++++++++++---
 arm/aarch64/include/kvm/kvm-config-arch.h |  5 ++++-
 arm/include/arm-common/kvm-arch.h         | 17 +++++++++++------
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 arm/kvm.c                                 | 23 ++++++++++++++++++++++-
 include/kvm/kvm.h                         |  4 ++++
 kvm.c                                     |  2 ++
 8 files changed, 57 insertions(+), 11 deletions(-)

-- 
2.7.4
