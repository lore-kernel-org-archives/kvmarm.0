From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 01/22] driver core: add per device iommu param
Date: Mon, 18 Feb 2019 14:54:42 +0100
Message-ID: <20190218135504.25048-2-eric.auger@redhat.com>
References: <20190218135504.25048-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76DA34A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 08:55:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e+7ydfbHwZ5f for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 08:55:52 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F58E40A52
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 08:55:52 -0500 (EST)
In-Reply-To: <20190218135504.25048-1-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, kevin.tian@intel.com, ashok.raj@intel.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

DMA faults can be detected by IOMMU at device level. Adding a pointer
to struct device allows IOMMU subsystem to report relevant faults
back to the device driver for further handling.
For direct assigned device (or user space drivers), guest OS holds
responsibility to handle and respond per device IOMMU fault.
Therefore we need fault reporting mechanism to propagate faults beyond
IOMMU subsystem.

There are two other IOMMU data pointers under struct device today, here
we introduce iommu_param as a parent pointer such that all device IOMMU
data can be consolidated here. The idea was suggested here by Greg KH
and Joerg. The name iommu_param is chosen here since iommu_data has been used.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Link: https://lkml.org/lkml/2017/10/6/81
---
 include/linux/device.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index 6cb4640b6160..fd7f9fae404e 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -42,6 +42,7 @@ struct iommu_ops;
 struct iommu_group;
 struct iommu_fwspec;
 struct dev_pin_info;
+struct iommu_param;
 
 struct bus_attribute {
 	struct attribute	attr;
@@ -950,6 +951,7 @@ struct dev_links_info {
  * 		device (i.e. the bus driver that discovered the device).
  * @iommu_group: IOMMU group the device belongs to.
  * @iommu_fwspec: IOMMU-specific properties supplied by firmware.
+ * @iommu_param: Per device generic IOMMU runtime data
  *
  * @offline_disabled: If set, the device is permanently online.
  * @offline:	Set after successful invocation of bus type's .offline().
@@ -1042,6 +1044,7 @@ struct device {
 	void	(*release)(struct device *dev);
 	struct iommu_group	*iommu_group;
 	struct iommu_fwspec	*iommu_fwspec;
+	struct iommu_param	*iommu_param;
 
 	bool			offline_disabled:1;
 	bool			offline:1;
-- 
2.20.1
