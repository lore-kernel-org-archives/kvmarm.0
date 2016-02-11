From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 00/15] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Thu, 11 Feb 2016 14:34:07 +0000
Message-ID: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC2BF49BA0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:28:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1DtStEDDdzBy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 09:28:56 -0500 (EST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7231549B9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:28:56 -0500 (EST)
Received: by mail-wm0-f48.google.com with SMTP id p63so70980945wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 06:34:51 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Thomas.Lendacky@amd.com, brijesh.singh@amd.com, patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, leo.duran@amd.com, sherry.hurwitz@amd.com
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
- introduce an IOMMU API to register a IOVA window usable for reserved mapping
- reuse VFIO DMA MAP ioctl with a new flag to plug onto that new API
- check if the device MSI-parent controllers allow IRQ remapping
  (allow unsafe interrupt modality) for a given group
- introduce a new IOMMU API to allocate reserved IOVAs and bind them onto
  a physical address
- allow the GICv2M and GICv3-ITS PCI irqchip to map/unmap the MSI frame
  on irq_write_msi_msg

Best Regards

Eric

Testing:
- functional on ARM64 AMD Overdrive HW (single GICv2m frame) with an e1000e
  PCIe card.
- tested there is no regresion on
  x non assigned PCIe driver
  x platform device passthrough
- Not tested: ARM with SR-IOV, ARM GICv3 ITS

References:
[1] [RFC 0/2] VFIO: Add virtual MSI doorbell support
    (https://lkml.org/lkml/2015/7/24/135)
[2] [RFC PATCH 0/6] vfio: Add interface to map MSI pages
    (https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016607.html)
[3] [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
    (http://permalink.gmane.org/gmane.comp.emulators.kvm.arm.devel/3858)

Git:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.5-rc3-pcie-passthrough-rfcv2

previous version at
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.5-rc1-pcie-passthrough-v1

QEMU Integration:
[RFC v2 0/8] KVM PCI/MSI passthrough with mach-virt
(http://lists.gnu.org/archive/html/qemu-arm/2016-01/msg00444.html)
https://git.linaro.org/people/eric.auger/qemu.git/shortlog/refs/heads/v2.5.0-pci-passthrough-rfc-v2

User Hints:
To allow PCI/MSI passthrough with GICv2M, compile VFIO as a module and
load the vfio_iommu_type1 module with allow_unsafe_interrupts param:
sudo modprobe -v vfio_iommu_type1 allow_unsafe_interrupts=1
sudo modprobe -v vfio-pci

History:

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


Eric Auger (15):
  iommu: Add DOMAIN_ATTR_MSI_MAPPING attribute
  vfio: expose MSI mapping requirement through VFIO_IOMMU_GET_INFO
  vfio: introduce VFIO_IOVA_RESERVED vfio_dma type
  iommu: add alloc/free_reserved_iova_domain
  iommu/arm-smmu: implement alloc/free_reserved_iova_domain
  iommu/arm-smmu: add a reserved binding RB tree
  iommu: iommu_get/put_single_reserved
  iommu/arm-smmu: implement iommu_get/put_single_reserved
  iommu/arm-smmu: relinquish reserved resources on domain deletion
  vfio: allow the user to register reserved iova range for MSI mapping
  msi: Add a new MSI_FLAG_IRQ_REMAPPING flag
  msi: export msi_get_domain_info
  vfio/type1: also check IRQ remapping capability at msi domain
  iommu/arm-smmu: do not advertise IOMMU_CAP_INTR_REMAP
  irqchip/gicv2m/v3-its-pci-msi: IOMMU map the MSI frame when needed

 drivers/iommu/arm-smmu.c                 | 292 +++++++++++++++++++++++++++++--
 drivers/iommu/fsl_pamu_domain.c          |   2 +
 drivers/iommu/iommu.c                    |  43 +++++
 drivers/irqchip/irq-gic-common.c         |  60 +++++++
 drivers/irqchip/irq-gic-common.h         |   5 +
 drivers/irqchip/irq-gic-v2m.c            |   3 +-
 drivers/irqchip/irq-gic-v3-its-pci-msi.c |   3 +-
 drivers/irqchip/irq-gic-v3-its.c         |   1 +
 drivers/vfio/vfio_iommu_type1.c          | 156 ++++++++++++++++-
 include/linux/iommu.h                    |  53 ++++++
 include/linux/msi.h                      |   6 +
 include/uapi/linux/vfio.h                |  10 ++
 kernel/irq/msi.c                         |   1 +
 13 files changed, 613 insertions(+), 22 deletions(-)

-- 
1.9.1
