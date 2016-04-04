From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v6 0/7] KVM PCIe/MSI passthrough on ARM/ARM64: kernel part
 1/3: iommu changes
Date: Mon,  4 Apr 2016 08:06:55 +0000
Message-ID: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2780D40BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:06:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1pr6xITQF0Sb for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:05:57 -0400 (EDT)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92008407A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:05:57 -0400 (EDT)
Received: by mail-lf0-f54.google.com with SMTP id p188so130066957lfd.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:07:12 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

This series introduces the dma-reserved-iommu api used to:
- create/destroy an iova domain dedicated to reserved iova bindings
- map/unmap physical addresses onto reserved IOVAs.
- unmap and destroy all IOVA reserved bindings

Currently reserved IOVAs are meant to map MSI physical doorbells. A single
reserved domain does exit per domain.

Also a new domain attribute is introduced to signal whether the MSI
addresses must be mapped in the IOMMU

VFIO subsystem is supposed to create/destroy the iommu reserved domain.

When the MSI sub-system is about to handle an MSI physical address
that needs to be bound, it uses the dma-reserved_iommu API to map/unmap
the address. Since several drivers are likely to use the same doorbell,
a reference counting must exist on the bindings. An RB-tree indexed by PA
is used.

More details & context can be found at:
http://www.linaro.org/blog/core-dump/kvm-pciemsi-passthrough-armarm64/

Best Regards

Eric

Git: complete series available at
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.6-rc1-pcie-passthrough-v6

History:

RFC v5 -> patch v6:
- split to ease the review process
- in dma-reserved-api use a spin lock instead of a mutex (reported by
  Jean-Philippe)
- revisit iommu_get_reserved_iova API to pass a size parameter upon
  Marc's request
- Consistently use the page order passed when creating the iova domain.
- init reserved_binding_list (reported by Julien)

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


Eric Auger (7):
  iommu: Add DOMAIN_ATTR_MSI_MAPPING attribute
  iommu/arm-smmu: advertise DOMAIN_ATTR_MSI_MAPPING attribute
  iommu: introduce a reserved iova cookie
  dma-reserved-iommu: alloc/free_reserved_iova_domain
  dma-reserved-iommu: reserved binding rb-tree and helpers
  dma-reserved-iommu: iommu_get/put_single_reserved
  dma-reserved-iommu: iommu_unmap_reserved

 drivers/iommu/Kconfig              |   8 +
 drivers/iommu/Makefile             |   1 +
 drivers/iommu/arm-smmu-v3.c        |   2 +
 drivers/iommu/arm-smmu.c           |   2 +
 drivers/iommu/dma-reserved-iommu.c | 321 +++++++++++++++++++++++++++++++++++++
 drivers/iommu/iommu.c              |   2 +
 include/linux/dma-reserved-iommu.h |  80 +++++++++
 include/linux/iommu.h              |   7 +
 8 files changed, 423 insertions(+)
 create mode 100644 drivers/iommu/dma-reserved-iommu.c
 create mode 100644 include/linux/dma-reserved-iommu.h

-- 
1.9.1
