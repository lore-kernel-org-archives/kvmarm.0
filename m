From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 00/10] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Tue, 26 Jan 2016 13:12:38 +0000
Message-ID: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B24E3409A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0qPfT6c5hPpF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 08:08:26 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54DB3407A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:25 -0500 (EST)
Received: by mail-wm0-f51.google.com with SMTP id l65so103466232wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 05:13:21 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, will.deacon@arm.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

This series addresses KVM PCIe passthrough with MSI enabled on ARM/ARM64.
It pursues the efforts done on [1], [2], [3]. It also aims at covering the
same need on some PowerPC platforms.

On x86 all accesses to the 1MB PA region [FEE0_0000h - FEF0_000h] are directed
as interrupt messages: accesses to this special PA window directly target the
APIC configuration space and not DRAM, meaning the downstream IOMMU is bypassed.

This is not the case on above mentionned platforms where MSI messages emitted
by devices are conveyed through the IOMMU. This means an IOVA/host PA mapping
must exist for the MSI to reach the MSI controller. Normal way to create
IOVA bindings consists in using VFIO DMA MAP API. However in this case
the MSI IOVA is not mapped onto guest RAM but on host physical page (the MSI
controller frame).

Following first comments, the spirit of [2] is kept: the guest registers
an IOVA range reserved for MSI mapping. When the VFIO-PCIe driver allocates
its MSI vectors, it overwrites the MSI controller physical address with an IOVA,
allocated within the window provided by the userspace. This IOVA is mapped
onto the MSI controller frame physical page.

The series does not address yet the problematic of telling the userspace how
much IOVA he should provision.

Best Regards

Eric

Testing:
This is currently tested on ARM64 AMD Overdrive HW (single GICv2m frame)
with an e1000e PCIe card. This is not tested on PPC.

References:
[1] [RFC 0/2] VFIO: Add virtual MSI doorbell support
    (https://lkml.org/lkml/2015/7/24/135)
[2] [RFC PATCH 0/6] vfio: Add interface to map MSI pages
    (https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016607.html)
[3] [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
    (http://permalink.gmane.org/gmane.comp.emulators.kvm.arm.devel/3858)

Git:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.5-rc1-pcie-passthrough-v1

History:

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
  iommu: Add DOMAIN_ATTR_MSI_MAPPING attribute
  vfio: expose MSI mapping requirement through VFIO_IOMMU_GET_INFO
  vfio_iommu_type1: add reserved binding RB tree management
  vfio: introduce VFIO_IOVA_RESERVED vfio_dma type
  vfio/type1: attach a reserved iova domain to vfio_domain
  vfio: introduce vfio_group_alloc_map_/unmap_free_reserved_iova
  vfio: pci: cache the vfio_group in vfio_pci_device
  vfio: introduce vfio_group_require_msi_mapping
  vfio-pci: create an iommu mapping for msi address
  vfio: allow the user to register reserved iova range for MSI mapping

 drivers/iommu/arm-smmu.c            |   2 +
 drivers/iommu/fsl_pamu_domain.c     |   3 +
 drivers/vfio/pci/vfio_pci.c         |   8 +
 drivers/vfio/pci/vfio_pci_intrs.c   |  73 ++++++-
 drivers/vfio/pci/vfio_pci_private.h |   1 +
 drivers/vfio/vfio.c                 |  64 ++++++
 drivers/vfio/vfio_iommu_type1.c     | 412 +++++++++++++++++++++++++++++++++++-
 include/linux/iommu.h               |   1 +
 include/linux/vfio.h                |  39 +++-
 include/uapi/linux/vfio.h           |  10 +
 10 files changed, 598 insertions(+), 15 deletions(-)

-- 
1.9.1
