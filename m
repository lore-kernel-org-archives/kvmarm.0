From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v11 00/10] KVM PCIe/MSI passthrough on ARM/ARM64: kernel part
 2/3: msi changes
Date: Tue, 19 Jul 2016 13:02:37 +0000
Message-ID: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AA6E411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 08:56:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zTEseyRsEmw4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2016 08:56:48 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 673EF411BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 08:56:48 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

KVM PCIe/MSI passthrough on ARM/ARM64: kernel part 2/3: msi changes

This series implements the MSI address mapping/unmapping in the MSI layer.
IOMMU binding happens on pci_enable_msi since this function can sleep and
return errors. On msi_domain_set_affinity, msi_domain_(de)activate, which
are not allowed to sleep, we simply look for the already existing binding.

Irqchips likely to be downstream to iommus (not bypassing MSIs) are supposed
to register their MSI doorbells. This make possible to retrieve their
characteristics, detect whether MSI assignment is safe and report to the
userspace the size/alignment of the guest PA window to provision for MSI
mapping.

A new MSI domain info flag value is introduced to report whether the msi
domain implements IRQ remapping. GIC v3 ITS is the first MSI controller
advertising it. This flag value will be used by VFIO subsystem to
determine whether MSI forwarding is safe.

More details & context can be found at:
http://www.linaro.org/blog/core-dump/kvm-pciemsi-passthrough-armarm64/

Best Regards

Eric

Git: complete series available at
https://github.com/eauger/linux/tree/v4.7-rc7-passthrough-v11

History:

v10 -> v11:
- restored irq_chip msi_doorbell_info since lookup function introduced
  in v10 (taking the chip_data as parameter) did not work for ITS and
  most probably for other irqchips/
- changed the registration API
- eventually tested with GICv3 ITS

v9 -> v10:
- was forced to introduce important changes on parts that were reviewed
  already :-( I took the initiative to replace the irqchip's
  get_doorbell_info callback by a new API, msi-doorbell).
  the new API makes possible to register, lookup doorbells and also compute
  the total requirements and IRQ safety flag used by VFIO.
- also added code in GICv3 ITS to register a global doorbell.

v8 -> v9:
- use a union in irq_chip_msi_doorbell_info + boolean telling whether the
  doorbell is percpu
- decouple irq_data parsing from the actual mapping/unmapping in
  msi_handle_doorbell_mappings
- fix misc style issues

v7 -> v8:
take into account Marc's comments:
- use iommu_msi_msg_pa_to_va with new proto
- change in irq_chip_msi_doorbell_info struct definition:
  prot and size became shared between all doorbells and phys_addr_t __percpu
- cleanups in v2m irqchip
- eventually did not touch MSI_FLAG_IRQ_REMAPPING naming
- On msi_handle_doorbell_mappings, stop on the first irqchip where doorbells
  can be found
- fix resource deallocation on mapping failure in msi_domain_alloc_irqs

v6 -> v7:
- do alloc/map handling on pci_enable_msi and search on msi_(de)domain_activate
- add msi_doorbell_info callback in irq-chip to retrieve the characteristics
  of doorbells

RFC v5 -> patch v6:
- split to ease the review process
- rebase on default iommu domain code (irq_data_to_msi_mapping_domain
  checks IOMMU_DOMAIN_DMA type)
- fix unmap sequence on msi_domain_set_affinity (reported by Marc):
  unmap the previous doorbell when the new one has been mapped & written to
  the device, ie. irq_chip_write_msi_msg.
- "msi: msi_compose wrapper removed" following change above
- add size parameter to iommu_get_reserved_iova API following Marc's request

RFC v4 -> RFC v5:
- take into account Thomas' comments on MSI related patches
  - split "msi: IOMMU map the doorbell address when needed"
  - increase readability and add comments
  - fix style issues
 - split "iommu: Add DOMAIN_ATTR_MSI_MAPPING attribute"
 - platform ITS now advertises IOMMU_CAP_INTR_REMAP
 - fix compilation issue with CONFIG_IOMMU API unset
 - arm-smmu-v3 now advertises DOMAIN_ATTR_MSI_MAPPING

RFC v3 -> v4:
- Move doorbell mapping/unmapping in msi.c
- fix ref count issue on set_affinity: in case of a change in the address
  the previous address is decremented
- doorbell map/unmap now is done on msi composition. Should allow the use
  case for platform MSI controllers
- create dma-reserved-iommu.h/c exposing/implementing a new API dedicated
  to reserved IOVA management (looking like dma-iommu glue)
- series reordering to ease the review:
  - first part is related to IOMMU
  - second related to MSI sub-system
  - third related to VFIO (except arm-smmu IOMMU_CAP_INTR_REMAP removal)
- expose the number of requested IOVA pages through VFIO_IOMMU_GET_INFO
  [this partially addresses Marc's comments on iommu_get/put_single_reserved
   size/alignment problematic - which I did not ignore - but I don't know
   how much I can do at the moment]

RFC v2 -> RFC v3:
- should fix wrong handling of some CONFIG combinations:
  CONFIG_IOVA, CONFIG_IOMMU_API, CONFIG_PCI_MSI_IRQ_DOMAIN
- fix MSI_FLAG_IRQ_REMAPPING setting in GICv3 ITS (although not tested)

PATCH v1 -> RFC v2:
- reverted to RFC since it looks more reasonable ;-) the code is split
  between VFIO, IOMMU, MSI controller and I am not sure I did the right
  choices. Also API need to be further discussed.
- iova API usage in arm-smmu.c.
- MSI controller natively programs the MSI addr with either the PA or IOVA.
  This is not done anymore in vfio-pci driver as suggested by Alex.
- check irq remapping capability of the group

RFC v1 [2] -> PATCH v1:
- use the existing dma map/unmap ioctl interface with a flag to register a
  reserved IOVA range. Use the legacy Rb to store this special vfio_dma.
- a single reserved IOVA contiguous region now is allowed
- use of an RB tree indexed by PA to store allocated reserved slots
- use of a vfio_domain iova_domain to manage iova allocation within the
  window provided by the userspace
- vfio alloc_map/unmap_free take a vfio_group handle
- vfio_group handle is cached in vfio_pci_device
- add ref counting to bindings
- user modality enabled at the end of the series


Eric Auger (10):
  genirq/msi: export msi_get_domain_info
  genirq/msi: msi_compose wrapper
  genirq/irq: introduce msi_doorbell_info
  genirq/msi-doorbell: allow MSI doorbell (un)registration
  genirq/msi-doorbell: msi_doorbell_pages
  genirq/msi-doorbell: msi_doorbell_safe
  irqchip/gicv2m: register the MSI global doorbell
  irqchip/gicv3-its: register the MSI global doorbell
  genirq/msi: map/unmap the MSI doorbells on msi_domain_alloc/free_irqs
  genirq/msi: use the MSI doorbell's IOVA when requested

 drivers/iommu/Kconfig            |   1 +
 drivers/irqchip/irq-gic-v2m.c    |  23 ++++++-
 drivers/irqchip/irq-gic-v3-its.c |  28 ++++++++
 include/linux/irq.h              |  16 ++++-
 include/linux/msi-doorbell.h     |  78 ++++++++++++++++++++++
 kernel/irq/Kconfig               |   4 ++
 kernel/irq/Makefile              |   1 +
 kernel/irq/msi-doorbell.c        | 129 ++++++++++++++++++++++++++++++++++++
 kernel/irq/msi.c                 | 137 +++++++++++++++++++++++++++++++++++----
 9 files changed, 404 insertions(+), 13 deletions(-)
 create mode 100644 include/linux/msi-doorbell.h
 create mode 100644 kernel/irq/msi-doorbell.c

-- 
1.9.1
