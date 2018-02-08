From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 00/16] kvm: arm64: Support for dynamic IPA size
Date: Thu, 8 Feb 2018 12:18:44 +0100
Message-ID: <20180208111844.GN29286@cbox>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109190414.4017-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On Tue, Jan 09, 2018 at 07:03:55PM +0000, Suzuki K Poulose wrote:
> On arm64 we have a static limit of 40bits of physical address space
> for the VM with KVM. This series lifts the limitation and allows the
> VM to configure the physical address space upto 52bit on systems
> where it is supported. We retain the default and minimum size to 40bits
> to avoid breaking backward compatibility.
> 
> The interface provided is an IOCTL on the VM fd. The guest can change
> only increase the limit from what is already configured, to prevent
> breaking the devices which may have already been configured with a
> particular guest PA. The guest can issue the request until something
> is actually mapped into the stage2 table (e.g, memory region or device).
> This also implies that we now have per VM configuration of stage2
> control registers (VTCR_EL2 bits).
> 
> The arm64 page table level helpers are defined based on the page
> table levels used by the host VA. So, the accessors may not work
> if the guest uses more number of levels in stage2 than the stage1
> of the host. In order to provide an independent stage2 page table,
> we refactor the arm64 page table helpers to give us raw accessors
> for each level, which should only used when that level is present.
> And then, based on the VM, we make the decision of the stage2
> page table using the raw accessors.
> 

This may come a bit out of left field, but have we considered decoupling
the KVM stage 2 page table manipulation functions even further from the
host page table helpers?  I found some of the patches a bit hard to read
with all the wrappers and folding logic considered, so I'm wondering if
it's possible to write something more generic for stage 2 page table
manipulations which doesn't have to fit within a Linux page table
manipulation nomenclature?

Wasn't this also the decision taken for IOMMU page table allocation, and
why was that the right approach for the IOMMU but not for KVM stage 2
page tables?  Is there room for reuse of the IOMMU page table allocation
logic in KVM as well?

This may have been discussed already, but I'd like to know the arguments
for doing things the way proposed in this series.

Thanks,
-Christoffer

> 
> The series also adds :
>  - Support for handling 52bit IPA for vgic ITS.
>  - Cleanup in virtio to handle errors when the PFN used in
>    the virtio transport doesn't fit in 32bit.
> 
> Tested with
>   - Modified kvmtool, which can only be used for (patches included in
>     the series for reference / testing):
>     * with virtio-pci upto 44bit PA (Due to 4K page size for virtio-pci
>       legacy implemented by kvmtool)
>     * Upto 48bit PA with virtio-mmio, due to 32bit PFN limitation.
>   - Hacked Qemu (boot loader support for highmem, phys-shift support)
>     * with virtio-pci GIC-v3 ITS & MSI upto 52bit on Foundation model.
> 
> The series applies on arm64 for-next/core tree with 52bit PA support patches.
> One would need the fix for virtio_mmio cleanup [1] on top of the arm64
> tree to remove the warnings from virtio.
> 
> [1] https://marc.info/?l=linux-virtualization&m=151308636322117&w=2
> 
> Kristina Martsenko (1):
>   vgic: its: Add support for 52bit guest physical address
> 
> Suzuki K Poulose (15):
>   virtio: Validate queue pfn for 32bit transports
>   irqchip: gicv3-its: Add helpers for handling 52bit address
>   arm64: Make page table helpers reusable
>   arm64: Refactor pud_huge for reusability
>   arm64: Helper for parange to PASize
>   kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table
>   kvm: arm/arm64: Remove spurious WARN_ON
>   kvm: arm/arm64: Clean up stage2 pgd life time
>   kvm: arm/arm64: Delay stage2 page table allocation
>   kvm: arm/arm64: Prepare for VM specific stage2 translations
>   kvm: arm64: Make stage2 page table layout dynamic
>   kvm: arm64: Dynamic configuration of VTCR and VTTBR mask
>   kvm: arm64: Configure VTCR per VM
>   kvm: arm64: Switch to per VM IPA
>   kvm: arm64: Allow configuring physical address space size
> 
>  Documentation/virtual/kvm/api.txt             |  27 +++
>  arch/arm/include/asm/kvm_arm.h                |   2 -
>  arch/arm/include/asm/kvm_host.h               |   7 +
>  arch/arm/include/asm/kvm_mmu.h                |  13 +-
>  arch/arm/include/asm/stage2_pgtable.h         |  46 +++---
>  arch/arm64/include/asm/cpufeature.h           |  16 ++
>  arch/arm64/include/asm/kvm_arm.h              | 112 +++++++++++--
>  arch/arm64/include/asm/kvm_asm.h              |   2 +-
>  arch/arm64/include/asm/kvm_host.h             |  21 ++-
>  arch/arm64/include/asm/kvm_mmu.h              |  83 ++++++++--
>  arch/arm64/include/asm/pgalloc.h              |  32 +++-
>  arch/arm64/include/asm/pgtable.h              |  61 ++++---
>  arch/arm64/include/asm/stage2_pgtable-nopmd.h |  42 -----
>  arch/arm64/include/asm/stage2_pgtable-nopud.h |  39 -----
>  arch/arm64/include/asm/stage2_pgtable.h       | 211 ++++++++++++++++--------
>  arch/arm64/kvm/hyp/s2-setup.c                 |  34 +---
>  arch/arm64/kvm/hyp/switch.c                   |   8 +
>  arch/arm64/kvm/reset.c                        |  28 ++++
>  arch/arm64/mm/hugetlbpage.c                   |   2 +-
>  drivers/irqchip/irq-gic-v3-its.c              |   2 +-
>  drivers/virtio/virtio_mmio.c                  |  19 ++-
>  drivers/virtio/virtio_pci_legacy.c            |  11 +-
>  include/linux/irqchip/arm-gic-v3.h            |  32 +++-
>  include/uapi/linux/kvm.h                      |   4 +
>  virt/kvm/arm/arm.c                            |  25 ++-
>  virt/kvm/arm/mmu.c                            | 228 +++++++++++++++-----------
>  virt/kvm/arm/vgic/vgic-its.c                  |  36 ++--
>  virt/kvm/arm/vgic/vgic-kvm-device.c           |   2 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c              |   1 -
>  29 files changed, 738 insertions(+), 408 deletions(-)
>  delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
>  delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h
> 
> -- 
> 2.13.6
> 
