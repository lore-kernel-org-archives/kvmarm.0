From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 22/22] vfio: Document nested stage control
Date: Sun, 17 Mar 2019 18:22:32 +0100
Message-ID: <20190317172232.1068-23-eric.auger@redhat.com>
References: <20190317172232.1068-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190317172232.1068-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org, vincent.stehle@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

New iotcls were introduced to pass information about guest stage1
to the host through VFIO. Let's document the nested stage control.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- document the new fault API

v1 -> v2:
- use the new ioctl names
- add doc related to fault handling
---
 Documentation/vfio.txt | 83 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/Documentation/vfio.txt b/Documentation/vfio.txt
index f1a4d3c3ba0b..aab59ddf5ebd 100644
--- a/Documentation/vfio.txt
+++ b/Documentation/vfio.txt
@@ -239,6 +239,89 @@ group and can access them as follows::
 	/* Gratuitous device reset and go... */
 	ioctl(device, VFIO_DEVICE_RESET);
 
+IOMMU Dual Stage Control
+------------------------
+
+Some IOMMUs support 2 stages/levels of translation. "Stage" corresponds to
+the ARM terminology while "level" corresponds to Intel's VTD terminology. In
+the following text we use either without distinction.
+
+This is useful when the guest is exposed with a virtual IOMMU and some
+devices are assigned to the guest through VFIO. Then the guest OS can use
+stage 1 (IOVA -> GPA), while the hypervisor uses stage 2 for VM isolation
+(GPA -> HPA).
+
+The guest gets ownership of the stage 1 page tables and also owns stage 1
+configuration structures. The hypervisor owns the root configuration structure
+(for security reason), including stage 2 configuration. This works as long
+configuration structures and page table format are compatible between the
+virtual IOMMU and the physical IOMMU.
+
+Assuming the HW supports it, this nested mode is selected by choosing the
+VFIO_TYPE1_NESTING_IOMMU type through:
+
+ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
+
+This forces the hypervisor to use the stage 2, leaving stage 1 available for
+guest usage.
+
+Once groups are attached to the container, the guest stage 1 translation
+configuration data can be passed to VFIO by using
+
+ioctl(container, VFIO_IOMMU_BIND_PASID_TABLE, &pasid_table_info);
+
+This allows to combine guest stage 1 configuration structure along with
+hypervisor stage 2 configuration structure. stage 1 configuration structures
+are dependent on the IOMMU type.
+
+As the stage 1 translation is fully delegated to the HW, physical events that
+may occur (especially translation faults), need to be propagated up to
+the virtualizer and re-injected into the guest.
+
+The userspace must be prepared to receive faults. The VFIO-PCI device
+exposes 2 regions dedicated to HW faults: one read-only "producer" fault
+region (kernel is the producer and writes into this region) and one
+write-only "consumer" fault region, type/subtype respectively:
+- VFIO_REGION_TYPE_NESTED/VFIO_REGION_SUBTYPE_NESTED_FAULT_PROD
+- VFIO_REGION_TYPE_NESTED/VFIO_REGION_SUBTYPE_NESTED_FAULT_CONS
+
+The producer fault region exposes a VFIO_REGION_INFO_CAP_PRODUCER_FAULT
+region capability that allows the userspace to retrieve the max fault
+ABI version supported by the kernel.
+
+The ABI version can be negotiated: the userspace writes the version it
+wants in the consumer region (greater or equal than 1). Once set, the
+ABI version cannot be changed.
+
+Then by using VFIO_DEVICE_SET_IRQS along with the VFIO_PCI_DMA_FAULT_IRQ_INDEX
+index, the virtualizer can register an eventfd signalled whenever a fault is
+observed at physical level.
+
+The kernel writes the fault records formatted according to the negotiated
+ABI version in the producer region fault queue. This part of the producer
+fault region can be mmapped (see VFIO_REGION_INFO_CAP_SPARSE_MMAP result).
+
+When the userspace consumes a fault in the queue, it should increment
+the consumer index to allow new fault records to replace the used ones.
+The queue size and the entry size can be retrieved in the producer region.
+The consumer index should never overshoot the producer index as in any
+other circular buffer scheme. Also it must be less than the queue size
+otherwise the change is ignored by the kernel.
+
+When the guest invalidates stage 1 related caches, invalidations must be
+forwarded to the host through
+ioctl(container, VFIO_IOMMU_CACHE_INVALIDATE, &inv_data);
+Those invalidations can happen at various granularity levels, page, context, ...
+
+The ARM SMMU specification introduces another challenge: MSIs are translated by
+both the virtual SMMU and the physical SMMU. To build a nested mapping for the
+IOVA programmed into the assigned device, the guest needs to pass its IOVA/MSI
+doorbell GPA binding to the host. Then the hypervisor can build a nested stage 2
+binding eventually translating into the physical MSI doorbell.
+
+This is achieved by
+ioctl(container, VFIO_IOMMU_BIND_MSI, &guest_binding);
+
 VFIO User API
 -------------------------------------------------------------------------------
 
-- 
2.20.1
