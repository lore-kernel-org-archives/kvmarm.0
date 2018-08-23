From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 00/13] SMMUv3 Nested Stage Setup
Date: Thu, 23 Aug 2018 14:17:23 +0200
Message-ID: <1535026656-8450-1-git-send-email-eric.auger__48623.6575911336$1535038706$gmane$org@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF7B74A210
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:17:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AsX+11-wCcwd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:17:45 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEC154A1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:17:45 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jean-philippe.brucker@arm.com,
 jacob.jun.pan@linux.intel.com, yi.l.liu"@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

This series allows a virtualizer to program the nested stage mode.
This is useful when both the host and the guest are exposed with
an SMMUv3 and a PCI device is assigned to the guest using VFIO.

In this mode, the physical IOMMU must be programmed to translate
the two stages: the one set up by the guest (IOVA -> GPA) and the
one set up by the host VFIO driver as part of the assignment process
(GPA -> HPA).

On Intel, this is traditionnaly achieved by combining the 2 stages
into a single physical stage. However this relies on the capability
to trap on each guest translation structure update. This is possible
by using the VTD Caching Mode. Unfortunately the ARM SMMUv3 does
not offer a similar mechanism.

However, the ARM SMMUv3 architecture supports 2 physical stages! Those
were devised exactly with that use case in mind. Assuming the HW
implements both stages (optional), the guest now can use stage 1
while the host uses stage 2.

This assumes the virtualizer has means to propagate guest settings
to the host SMMUv3 driver. This series brings this VFIO/IOMMU
infrastructure.  Those services are:
- bind the guest stage 1 configuration to the stream table entry
- propagate guest TLB invalidations
- bind MSI IOVAs

This series largely reuses the infrastructure devised for SVA/SVM
and patches submitted by Jacob and Liu in [1] and [2] and
Jean-Philippe [3], with some generalizations to adapt to this use case.

At the moment, this series does not implement fault reporting to
the guest. This will be added later on.

Best Regards

Eric

This series can be found at:
https://github.com/eauger/linux/tree/v4.18-2stage-rfc

This was tested on Qualcomm HW featuring SMMUv3 and with adapted QEMU
vSMMUv3.

References:
[1] [PATCH v5 00/23] IOMMU and VT-d driver support for Shared Virtual
    Address (SVA)
    https://lwn.net/Articles/754331/
[2] [RFC PATCH 0/8] Shared Virtual Memory virtualization for VT-d
    (VFIO part)
    https://lists.linuxfoundation.org/pipermail/iommu/2017-April/021475.html
[3] [v2,17/40] iommu/arm-smmu-v3: Link domains and devices
    https://patchwork.kernel.org/patch/10395187/

Eric Auger (8):
  iommu: Introduce bind_guest_msi
  vfio: VFIO_IOMMU_BIND_MSI
  vfio: Document nested stage control
  iommu/smmuv3: Get prepared for nested stage support
  iommu/smmuv3: Implement bind_guest_stage
  iommu/smmuv3: Implement tlb_invalidate
  dma-iommu: Implement NESTED_MSI cookie
  iommu/smmuv3: Implement bind_guest_msi

Jacob Pan (1):
  iommu: Introduce bind_guest_stage API

Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3: Link domains and devices

Liu, Yi L (3):
  iommu: Introduce tlb_invalidate API
  vfio: VFIO_IOMMU_BIND_GUEST_STAGE
  vfio: VFIO_IOMMU_TLB_INVALIDATE

 Documentation/vfio.txt          |  45 ++++++++++
 drivers/iommu/arm-smmu-v3.c     | 179 ++++++++++++++++++++++++++++++++++++++--
 drivers/iommu/dma-iommu.c       |  88 +++++++++++++++++++-
 drivers/iommu/iommu.c           |  43 ++++++++++
 drivers/vfio/vfio_iommu_type1.c | 110 ++++++++++++++++++++++++
 include/linux/dma-iommu.h       |  11 +++
 include/linux/iommu.h           |  48 +++++++++++
 include/uapi/linux/iommu.h      | 157 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  22 +++++
 9 files changed, 692 insertions(+), 11 deletions(-)
 create mode 100644 include/uapi/linux/iommu.h

-- 
2.5.5
