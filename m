From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 00/20] SMMUv3 Nested Stage Setup
Date: Tue, 18 Sep 2018 16:24:37 +0200
Message-ID: <20180918142457.3325-1-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: tianyu.lan@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
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
- propagate faults collected at physical level up to the virtualizer

This series largely reuses the user API and infrastructure originally
devised for SVA/SVM and patches submitted by Jacob, Yi Liu, Tianyu in
[1-3] and Jean-Philippe [4].

This proof of concept also aims at illustrating how this API/infrastructure
would need to evolve to support this nested stage SMMUv3 use case.

Best Regards

Eric

This series can be found at:
https://github.com/eauger/linux/tree/v4.19-rc4-2stage-rfc-v2

This was tested on Qualcomm HW featuring SMMUv3 and with adapted QEMU
vSMMUv3.

References:
[1] [PATCH v5 00/23] IOMMU and VT-d driver support for Shared Virtual
    Address (SVA)
    https://lwn.net/Articles/754331/
[2] [RFC PATCH 0/8] Shared Virtual Memory virtualization for VT-d
    (VFIO part)
    https://lists.linuxfoundation.org/pipermail/iommu/2017-April/021475.html
[3] [RFC PATCH 0/3] VFIO: Report IOMMU fault event to userspace
    https://www.spinics.net/lists/kvm/msg145280.html
[4] [v2,00/40] Shared Virtual Addressing for the IOMMU
    https://patchwork.ozlabs.org/cover/912129/

History:

v1 -> v2:
- Added the fault reporting capability
- asid properly passed on invalidation (fix assignment of multiple
  devices)
- see individual change logs for more info


Eric Auger (11):
  iommu: Introduce bind_guest_msi
  vfio: VFIO_IOMMU_BIND_MSI
  iommu/smmuv3: Get prepared for nested stage support
  iommu/smmuv3: Implement bind_pasid_table
  iommu/smmuv3: Implement cache_invalidate
  dma-iommu: Implement NESTED_MSI cookie
  iommu/smmuv3: Implement bind_guest_msi
  vfio: VFIO_IOMMU_SET_FAULT_EVENTFD
  vfio: VFIO_IOMMU_GET_FAULT_EVENTS
  vfio: Document nested stage control
  iommu/smmuv3: Report non recoverable faults

Jacob Pan (4):
  iommu: Introduce bind_pasid_table API
  iommu: introduce device fault data
  driver core: add per device iommu param
  iommu: introduce device fault report API

Jean-Philippe Brucker (2):
  iommu/arm-smmu-v3: Link domains and devices
  iommu/arm-smmu-v3: Maintain a SID->device structure

Liu, Yi L (3):
  iommu: Introduce cache_invalidate API
  vfio: VFIO_IOMMU_BIND_PASID_TABLE
  vfio: VFIO_IOMMU_CACHE_INVALIDATE

 Documentation/vfio.txt          |  60 ++++
 drivers/iommu/arm-smmu-v3.c     | 476 ++++++++++++++++++++++++++++++--
 drivers/iommu/dma-iommu.c       |  97 ++++++-
 drivers/iommu/iommu.c           | 196 ++++++++++++-
 drivers/vfio/vfio_iommu_type1.c | 269 ++++++++++++++++++
 include/linux/device.h          |   3 +
 include/linux/dma-iommu.h       |  11 +
 include/linux/iommu.h           | 134 ++++++++-
 include/uapi/linux/iommu.h      | 237 ++++++++++++++++
 include/uapi/linux/vfio.h       |  48 ++++
 10 files changed, 1501 insertions(+), 30 deletions(-)
 create mode 100644 include/uapi/linux/iommu.h

-- 
2.17.1
