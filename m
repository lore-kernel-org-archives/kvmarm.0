From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 00/22] SMMUv3 Nested Stage Setup
Date: Tue, 5 Mar 2019 17:42:32 +0100
Message-ID: <b7990ab6-e286-0aee-b15c-4a05fe4eed78@redhat.com>
References: <20190218135504.25048-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190218135504.25048-1-eric.auger@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 2/18/19 2:54 PM, Eric Auger wrote:
> This series allows a virtualizer to program the nested stage mode.
> This is useful when both the host and the guest are exposed with
> an SMMUv3 and a PCI device is assigned to the guest using VFIO.
> 
> In this mode, the physical IOMMU must be programmed to translate
> the two stages: the one set up by the guest (IOVA -> GPA) and the
> one set up by the host VFIO driver as part of the assignment process
> (GPA -> HPA).
> 
> On Intel, this is traditionnaly achieved by combining the 2 stages
> into a single physical stage. However this relies on the capability
> to trap on each guest translation structure update. This is possible
> by using the VTD Caching Mode. Unfortunately the ARM SMMUv3 does
> not offer a similar mechanism.
> 
> However, the ARM SMMUv3 architecture supports 2 physical stages! Those
> were devised exactly with that use case in mind. Assuming the HW
> implements both stages (optional), the guest now can use stage 1
> while the host uses stage 2.
> 
> This assumes the virtualizer has means to propagate guest settings
> to the host SMMUv3 driver. This series brings this VFIO/IOMMU
> infrastructure.  Those services are:
> - bind the guest stage 1 configuration to the stream table entry
> - propagate guest TLB invalidations
> - bind MSI IOVAs
> - propagate faults collected at physical level up to the virtualizer
> 
> This series largely reuses the user API and infrastructure originally
> devised for SVA/SVM and patches submitted by Jacob, Yi Liu, Tianyu in
> [1-2] and Jean-Philippe [3-4].
> 
> Best Regards
> 
> Eric
> 
> This series can be found at:
> https://github.com/eauger/linux/tree/v5.0-rc7-2stage-v4
For those interested in testing this kernel branch, you can use the
following qemu branch:

https://github.com/eauger/qemu/tree/v3.1.0-2stage-prev3-for-patchv4-testing

I will send an official QEMU RFCv3 asap.

Thanks

Eric
> 
> References:
> [1] [PATCH v5 00/23] IOMMU and VT-d driver support for Shared Virtual
>     Address (SVA)
>     https://lwn.net/Articles/754331/
> [2] [RFC PATCH 0/8] Shared Virtual Memory virtualization for VT-d
>     (VFIO part)
>     https://lists.linuxfoundation.org/pipermail/iommu/2017-April/021475.html
> [3] [v2,00/40] Shared Virtual Addressing for the IOMMU
>     https://patchwork.ozlabs.org/cover/912129/
> [4] [PATCH v3 00/10] Shared Virtual Addressing for the IOMMU
>     https://patchwork.kernel.org/cover/10608299/
> 
> History:
> v3 -> v4:
> - took into account Alex, jean-Philippe and Robin's comments on v3
> - rework of the smmuv3 driver integration
> - add tear down ops for msi binding and PASID table binding
> - fix S1 fault propagation
> - put fault reporting patches at the beginning of the series following
>   Jean-Philippe's request
> - update of the cache invalidate and fault API uapis
> - VFIO fault reporting rework with 2 separate regions and one mmappable
>   segment for the fault queue
> - moved to PATCH
> 
> v2 -> v3:
> - When registering the S1 MSI binding we now store the device handle. This
>   addresses Robin's comment about discimination of devices beonging to
>   different S1 groups and using different physical MSI doorbells.
> - Change the fault reporting API: use VFIO_PCI_DMA_FAULT_IRQ_INDEX to
>   set the eventfd and expose the faults through an mmappable fault region
> 
> v1 -> v2:
> - Added the fault reporting capability
> - asid properly passed on invalidation (fix assignment of multiple
>   devices)
> - see individual change logs for more info
> 
> Eric Auger (13):
>   iommu: Introduce bind/unbind_guest_msi
>   vfio: VFIO_IOMMU_BIND/UNBIND_MSI
>   iommu/smmuv3: Get prepared for nested stage support
>   iommu/smmuv3: Implement attach/detach_pasid_table
>   iommu/smmuv3: Implement cache_invalidate
>   dma-iommu: Implement NESTED_MSI cookie
>   iommu/smmuv3: Implement bind/unbind_guest_msi
>   iommu/smmuv3: Report non recoverable faults
>   vfio-pci: Add a new VFIO_REGION_TYPE_NESTED region type
>   vfio-pci: Register an iommu fault handler
>   vfio_pci: Allow to mmap the fault queue
>   vfio-pci: Add VFIO_PCI_DMA_FAULT_IRQ_INDEX
>   vfio: Document nested stage control
> 
> Jacob Pan (4):
>   driver core: add per device iommu param
>   iommu: introduce device fault data
>   iommu: introduce device fault report API
>   iommu: Introduce attach/detach_pasid_table API
> 
> Jean-Philippe Brucker (2):
>   iommu/arm-smmu-v3: Link domains and devices
>   iommu/arm-smmu-v3: Maintain a SID->device structure
> 
> Liu, Yi L (3):
>   iommu: Introduce cache_invalidate API
>   vfio: VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE
>   vfio: VFIO_IOMMU_CACHE_INVALIDATE
> 
>  Documentation/vfio.txt              |  83 ++++
>  drivers/iommu/arm-smmu-v3.c         | 580 ++++++++++++++++++++++++++--
>  drivers/iommu/dma-iommu.c           | 145 ++++++-
>  drivers/iommu/iommu.c               | 221 ++++++++++-
>  drivers/vfio/pci/vfio_pci.c         | 214 ++++++++++
>  drivers/vfio/pci/vfio_pci_intrs.c   |  19 +
>  drivers/vfio/pci/vfio_pci_private.h |  20 +
>  drivers/vfio/pci/vfio_pci_rdwr.c    |  73 ++++
>  drivers/vfio/vfio_iommu_type1.c     | 158 ++++++++
>  include/linux/device.h              |   3 +
>  include/linux/dma-iommu.h           |  18 +
>  include/linux/iommu.h               | 142 +++++++
>  include/uapi/linux/iommu.h          | 233 +++++++++++
>  include/uapi/linux/vfio.h           | 102 +++++
>  14 files changed, 1977 insertions(+), 34 deletions(-)
>  create mode 100644 include/uapi/linux/iommu.h
> 
