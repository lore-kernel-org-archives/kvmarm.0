From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 00/20] kvm: arm64: Dynamic IPA and 52bit IPA
Date: Wed, 18 Jul 2018 10:18:43 +0100
Message-ID: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2AF04A0C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jul 2018 05:06:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BYRnLggtfEf2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Jul 2018 05:06:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 120FD408AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jul 2018 05:06:21 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


The physical address space size for a VM (IPA size) on arm/arm64 is
limited to a static limit of 40bits. This series adds support for
using an IPA size specific to a VM, allowing to use a size supported
by the host (based on the host kernel configuration and CPU support).
The default size is fixed to 40bits. On arm64, we can allow the limit
to be lowered (limiting the number of levels in stage2 to 2, to prevent
splitting the host PMD huge pages at stage2). We also add support for
handling 52bit IPA addresses (where supported) added by Arm v8.2
extensions.

As mentioned above, the supported IPA size on a host could be different
from the system's PARange indicated by the CPUs (e.g, kernel limit
on the PA size). So we expose the limit via a new KVM_CAP_ARM_VM_MAX_PHYS_SHIFT
on arm/arm64. See below for further discussion on the userspace API.

Supporting different IPA size requires modification to the stage2 page
table code. The arm64 page table level helpers are defined based on the
page table levels used by the host VA. So, the accessors may not work
if the guest uses more number of levels in stage2 than the stage1
of the host.  The previous versions (v1 & v2) of this series refactored
the stage1 page table accessors to reuse the low-level accessors for an
independent stage2 table. However, due to the level folding in the
generic code, the types are redefined as well. i.e, if the PUD is
folded, the pud_t could be defined as :

 typedef struct { pgd_t pgd; } pud_t;

similarly for pmd_t.  So, without stage1 independent page table entry
types for stage2, we could be dealing with a different type for level
 0-2 entries. This is practically fine on arm/arm64 as the entries
have similar format and size and we always use the appropriate
accessors to get the raw value (i.e, pud_val/pmd_val etc). But not
ideal for a solution upstream. So, this version caps the stage2 page
table levels to that of the stage1. This has the following impact on
the IPA support for various pagesize/host-va combinations :


x-----------------------------------------------------x
| host\ipa    | 40bit | 42bit | 44bit | 48bit | 52bit |
-------------------------------------------------------
| 39bit-4K    |  y    |   y   |  n    |   n   |  n/a  |
-------------------------------------------------------
| 48bit-4K    |  y    |   y   |  y    |   y   |  n/a  |
-------------------------------------------------------
| 36bit-16K   |  y    |   n   |  n    |   n   |  n/a  |
-------------------------------------------------------
| 47bit-16K   |  y    |   y   |  y    |   y   |  n/a  |
-------------------------------------------------------
| 48bit-4K    |  y    |   y   |  y    |   y   |  n/a  |
-------------------------------------------------------
| 42bit-64K   |  y    |   y   |  y    |   n   |  n    |
-------------------------------------------------------
| 48bit-64K   |  y    |   y   |  y    |   y   |  y    |
x-----------------------------------------------------x

Or the following list shows what cannot be supported :

 39bit-4K host  | [44 - 48]
 36bit-16K host | [41 - 48]
 42bit-64K host | [47 - 52]

which is not really bad. We can pursue the independent stage2
page table support and lift the restriction once we get there.
Given there is a proposal for new generic page table walker [0],
it would make sense to make our efforts in sync with it to avoid
diverting from a common API.

52bit support is added for VGIC (including ITS emulation) and handling
of PAR, HPFAR registers.

We need to set the IPA limit as early as the VM creation to keep the
code simpler to avoid sprinkling checks everywhere to ensure that the
IPA is configured. So, this version encodes the IPA size in the machine_type
argument to KVM_CREATE_VM ioctl. Bits [7-0] of the type are reserved for
the IPA size. However, there are other reasons (e.g, SVE vector length on
arm64) why we need a better way to tune the parameters of the VM early
enough to finalize the settings before any additional devices/memory/CPUs
are added to the VM. See [2] for the discussions on the previous version.

To summarise these are the following options :

 1) Add a new CREATE_VM ioctl (e.g CREAT_VM2) which imposes one of the
following semantics on the user.
  a) Pass a list of attributes/capabilities to be configured when the
     VM is created.

	vm_fd = ioctl(kvm_dev_fd, KVM_CREATE_VM2, &attributes);
     where "attributes" could be a new different structure or existing
     struct kvm_enable_cap {}.

	OR

  b) Create the VM in an unconfigured state where no resources can
     be allocated until a further IOCTL is issued after configuring
     different attributes/capabilities.
	i.e
		vm_fd = ioctl(kvm_dev_fd, KVM_CREATE_VM2, ..);
		/* Creates a VM unconfigured, not runnable */
		/* Configure the VM attributes on vm_fd */
		rc = ioctl(vm_fd, KVM_CREATE_VM_COMPLETE,...);

The series applies on 4.18-rc4. A tree is available here:

	 git://linux-arm.org/linux-skp.git ipa52/v4

Tested with
  - Modified kvmtool, which can only be used for (patches included in
    the series for reference / testing):
    * with virtio-pci upto 44bit PA (Due to 4K page size for virtio-pci
      legacy implemented by kvmtool)
    * Upto 48bit PA with virtio-mmio, due to 32bit PFN limitation.
  - Hacked Qemu (boot loader support for highmem, phys-shift support)
    * with virtio-pci GIC-v3 ITS & MSI upto 52bit on Foundation model.
    Also see [1] for Qemu support.

[0] https://lkml.org/lkml/2018/4/24/777
[1] https://lists.gnu.org/archive/html/qemu-devel/2018-06/msg05759.html
[2] https://lkml.org/lkml/2018/7/4/729

Changes since V3:
 - Use per-VM VTCR instead per-VM private VTCR bits
 - Allow IPA less than 40bits
 - Split the patch adding support for stage2 dynamic page tables
 - Rearrange the series to keep the userspace API at the end, which
   needs further discussion.
 - Collect Reviews/Acks from Eric & Marc

Changes since V2:
 - Drop "refactoring of host page table helpers" and restrict the IPA size
   to make sure stage2 doesn't use more page table levels than that of the host.
 - Load VTCR for TLB operations on behalf of the VM (Pointed-by: James Morse)
 - Split a couple of patches to make them easier to review.
 - Fall back to normal (non-concatenated) entry level page table support if
   possible.
 - Bump the IOCTL number

Changes since V1:
 - Change the userspace API for configuring VM to encode the IPA
   size in the VM type.  (suggested by Christoffer)
 - Expose the IPA limit on the host via ioctl on /dev/kvm
 - Handle 52bit addresses in PAR & HPFAR
 - Drop patch changing the life time of stage2 PGD
 - Rename macros for 48-to-52 bit conversion for GIC ITS BASER.
   (suggested by Christoffer)
 - Split virtio PFN check patches and address comments.


Kristina Martsenko (1):
  vgic: Add support for 52bit guest physical address

Suzuki K Poulose (19):
  virtio: mmio-v1: Validate queue PFN
  virtio: pci-legacy: Validate queue pfn
  kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table
  kvm: arm/arm64: Remove spurious WARN_ON
  kvm: arm64: Add helper for loading the stage2 setting for a VM
  arm64: Add a helper for PARange to physical shift conversion
  kvm: arm64: Clean up VTCR_EL2 initialisation
  kvm: arm64: Configure VTCR_EL2 per VM
  kvm: arm/arm64: Prepare for VM specific stage2 translations
  kvm: arm64: Prepare for dynamic stage2 page table layout
  kvm: arm64: Make stage2 page table layout dynamic
  kvm: arm64: Dynamic configuration of VTTBR mask
  kvm: arm64: Configure VTCR_EL2.SL0 per VM
  kvm: arm64: Switch to per VM IPA limit
  kvm: arm64: Add 52bit support for PAR to HPFAR conversoin
  kvm: arm64: Set a limit on the IPA size
  kvm: arm64: Limit the minimum number of page table levels
  kvm: arm/arm64: Expose supported physical address limit for VM
  kvm: arm64: Allow tuning the physical address size for VM

 Documentation/virtual/kvm/api.txt             |   4 +
 arch/arm/include/asm/kvm_arm.h                |   3 +-
 arch/arm/include/asm/kvm_host.h               |   7 +
 arch/arm/include/asm/kvm_mmu.h                |  18 +-
 arch/arm/include/asm/stage2_pgtable.h         |  50 +++---
 arch/arm64/include/asm/cpufeature.h           |  13 ++
 arch/arm64/include/asm/kvm_arm.h              | 130 +++++++++++---
 arch/arm64/include/asm/kvm_asm.h              |   2 -
 arch/arm64/include/asm/kvm_host.h             |  15 +-
 arch/arm64/include/asm/kvm_hyp.h              |   7 +
 arch/arm64/include/asm/kvm_mmu.h              |  82 ++++++++-
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |  42 -----
 arch/arm64/include/asm/stage2_pgtable-nopud.h |  39 -----
 arch/arm64/include/asm/stage2_pgtable.h       | 237 +++++++++++++++++++-------
 arch/arm64/kvm/guest.c                        |  49 +++++-
 arch/arm64/kvm/hyp/Makefile                   |   1 -
 arch/arm64/kvm/hyp/s2-setup.c                 |  90 ----------
 arch/arm64/kvm/hyp/switch.c                   |   4 +-
 arch/arm64/kvm/hyp/tlb.c                      |   4 +-
 drivers/virtio/virtio_mmio.c                  |  20 ++-
 drivers/virtio/virtio_pci_legacy.c            |  14 +-
 include/linux/irqchip/arm-gic-v3.h            |   5 +
 include/uapi/linux/kvm.h                      |  10 ++
 virt/kvm/arm/arm.c                            |  23 ++-
 virt/kvm/arm/mmu.c                            | 120 ++++++-------
 virt/kvm/arm/vgic/vgic-its.c                  |  36 ++--
 virt/kvm/arm/vgic/vgic-kvm-device.c           |   2 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c              |   2 -
 28 files changed, 631 insertions(+), 398 deletions(-)
 delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
 delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h
 delete mode 100644 arch/arm64/kvm/hyp/s2-setup.c


kvmtool changes :

Suzuki K Poulose (4):
  kvmtool: Allow backends to run checks on the KVM device fd
  kvmtool: arm64: Add support for guest physical address size
  kvmtool: arm64: Switch memory layout
  kvmtool: arm: Add support for creating VM with PA size

 arm/aarch32/include/kvm/kvm-arch.h        |  6 ++++--
 arm/aarch64/include/kvm/kvm-arch.h        | 15 ++++++++++++---
 arm/aarch64/include/kvm/kvm-config-arch.h |  5 ++++-
 arm/include/arm-common/kvm-arch.h         | 17 +++++++++++------
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 arm/kvm.c                                 | 24 +++++++++++++++++++++++-
 include/kvm/kvm.h                         |  4 ++++
 kvm.c                                     |  2 ++
 8 files changed, 61 insertions(+), 13 deletions(-)

-- 
2.7.4
