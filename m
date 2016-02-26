From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v4 00/14] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Fri, 26 Feb 2016 17:35:40 +0000
Message-ID: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4063D411F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IIDRxoeBz0Sv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 12:29:11 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF1C8410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:10 -0500 (EST)
Received: by mail-wm0-f54.google.com with SMTP id g62so79652147wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 09:36:02 -0800 (PST)
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

This series addresses KVM PCIe passthrough with MSI enabled on ARM/ARM64.
It pursues the efforts done on [1], [2], [3]. It also aims at covering the
same need on PowerPC platforms although the same kind of integration
should be carried out.

On x86 all accesses to the 1MB PA region [FEE0_0000h - FEF0_000h] are directed
as interrupt messages: accesses to this special PA window directly target the
APIC configuration space and not DRAM, meaning the downstream IOMMU is bypassed.

This is not the case on above mentionned platforms where MSI messages emitted
by devices are conveyed through the IOMMU. This means an IOVA/host PA mapping
must exist for the MSI to reach the MSI controller. Normal way to create
IOVA bindings consists in using VFIO DMA MAP API. However in this case
the MSI IOVA is not mapped onto guest RAM but on host physical page (the MSI
controller frame).

In a nutshell, this series does:
- introduce a new DMA-RESERVED-IOMMU API to register a IOVA window usable for
  reserved mapping and allocate/bind IOVA to host physical addresses
- reuse VFIO DMA MAP ioctl with a new flag to plug onto that new API
- check if the MSI mapping is safe when attaching the vfio group to the
  container
- allow the MSI subsystem to map/unmap the doorbell on MSI message composition
- allow the user-space to know how many IOVA pages are requested

Best Regards

Eric

Testing:
- functional on ARM64 AMD Overdrive HW (single GICv2m frame) with
  x Intel e1000e PCIe card
  x Intel X540-T2 (SR-IOV capable)
- Not tested: ARM GICv3 ITS

References:
[1] [RFC 0/2] VFIO: Add virtual MSI doorbell support
    (https://lkml.org/lkml/2015/7/24/135)
[2] [RFC PATCH 0/6] vfio: Add interface to map MSI pages
    (https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016607.html)
[3] [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
    (http://permalink.gmane.org/gmane.comp.emulators.kvm.arm.devel/3858)

Git:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.5-rc5-pcie-passthrough-rfcv4

previous version at
v3: https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.5-rc3-pcie-passthrough-rfcv3

QEMU Integration:
[RFC v2 0/8] KVM PCI/MSI passthrough with mach-virt
(http://lists.gnu.org/archive/html/qemu-arm/2016-01/msg00444.html)
https://git.linaro.org/people/eric.auger/qemu.git/shortlog/refs/heads/v2.5.0-pci-passthrough-rfc-v2

User Hints:
To allow PCI/MSI passthrough with GICv2M, compile VFIO as a module and
load the vfio_iommu_type1 module with allow_unsafe_interrupts param:
sudo modprobe -v vfio-pci
sudo modprobe -r vfio_iommu_type1
sudo modprobe -v vfio_iommu_type1 allow_unsafe_interrupts=1

History:

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


Eric Auger (14):
  iommu: Add DOMAIN_ATTR_MSI_MAPPING attribute
  iommu: introduce a reserved iova cookie
  dma-reserved-iommu: alloc/free_reserved_iova_domain
  dma-reserved-iommu: reserved binding rb-tree and helpers
  dma-reserved-iommu: iommu_get/put_single_reserved
  dma-reserved-iommu: iommu_unmap_reserved
  msi: Add a new MSI_FLAG_IRQ_REMAPPING flag
  msi: export msi_get_domain_info
  msi: IOMMU map the doorbell address when needed
  vfio: introduce VFIO_IOVA_RESERVED vfio_dma type
  vfio: allow the user to register reserved iova range for MSI mapping
  vfio/type1: also check IRQ remapping capability at msi domain
  iommu/arm-smmu: do not advertise IOMMU_CAP_INTR_REMAP
  vfio/type1: return MSI mapping requirements with VFIO_IOMMU_GET_INFO

 drivers/iommu/Kconfig                    |   8 +
 drivers/iommu/Makefile                   |   1 +
 drivers/iommu/arm-smmu.c                 |   4 +-
 drivers/iommu/dma-reserved-iommu.c       | 270 ++++++++++++++++++++++++
 drivers/iommu/fsl_pamu_domain.c          |   2 +
 drivers/iommu/iommu.c                    |   1 +
 drivers/irqchip/irq-gic-v3-its-pci-msi.c |   3 +-
 drivers/vfio/vfio_iommu_type1.c          | 348 ++++++++++++++++++++++++++++++-
 include/linux/dma-reserved-iommu.h       |  78 +++++++
 include/linux/iommu.h                    |   6 +
 include/linux/msi.h                      |   2 +
 include/uapi/linux/vfio.h                |  14 +-
 kernel/irq/msi.c                         | 113 +++++++++-
 13 files changed, 839 insertions(+), 11 deletions(-)
 create mode 100644 drivers/iommu/dma-reserved-iommu.c
 create mode 100644 include/linux/dma-reserved-iommu.h

-- 
1.9.1
