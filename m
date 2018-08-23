From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 07/13] vfio: Document nested stage control
Date: Thu, 23 Aug 2018 14:17:30 +0200
Message-ID: <1535026656-8450-8-git-send-email-eric.auger__28731.5827365548$1535038714$gmane$org@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 704F94A22B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c37vOGaKDmv8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:18:08 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A053F4A210
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:08 -0400 (EDT)
In-Reply-To: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
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

New iotcls were introduced to pass information about guest stage1
to the host through VFIO. Let's document the nested stage control.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

fault reporting is current missing to the picture
---
 Documentation/vfio.txt | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/vfio.txt b/Documentation/vfio.txt
index f1a4d3c..858a363 100644
--- a/Documentation/vfio.txt
+++ b/Documentation/vfio.txt
@@ -239,6 +239,51 @@ group and can access them as follows::
 	/* Gratuitous device reset and go... */
 	ioctl(device, VFIO_DEVICE_RESET);
 
+IOMMU Dual Stage Control
+------------------------
+
+Some IOMMUs support 2 stages of translation. This is useful when the
+guest is exposed with a virtual IOMMU and some devices are assigned
+to the guest through VFIO. Then the guest OS can use stage 1 (IOVA -> GPA),
+while the hypervisor uses stage 2 for VM isolation (GPA -> HPA).
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
+ioctl(container, VFIO_IOMMU_BIND_GUEST_STAGE, &guest_stage_info);
+
+This allows to combine guest stage1 configuration structure along with hypervisor
+stage 2 configuration structure. stage 1 configuration structures are dependent
+on the IOMMU type.
+
+When the guest invalidates stage 1 entries, IOTLB invalidations must be forwarded
+to the host through
+ioctl(container, VFIO_IOMMU_TLB_INVALIDATE, &inv_data);
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
2.5.5
