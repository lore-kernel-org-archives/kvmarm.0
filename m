From: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v3 14/21] iommu: introduce device fault data
Date: Tue,  8 Jan 2019 11:26:26 +0100
Message-ID: <20190108102633.17482-15-eric.auger@redhat.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190108102633.17482-1-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org
Cc: marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christoffer.dall-5wv7dgnIgG8@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Device faults detected by IOMMU can be reported outside IOMMU
subsystem for further processing. This patch intends to provide
a generic device fault data such that device drivers can be
communicated with IOMMU faults without model specific knowledge.

The proposed format is the result of discussion at:
https://lkml.org/lkml/2017/11/10/291
Part of the code is based on Jean-Philippe Brucker's patchset
(https://patchwork.kernel.org/patch/9989315/).

The assumption is that model specific IOMMU driver can filter and
handle most of the internal faults if the cause is within IOMMU driver
control. Therefore, the fault reasons can be reported are grouped
and generalized based common specifications such as PCI ATS.

Signed-off-by: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Liu, Yi L <yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
[moved part of the iommu_fault_event struct in the uapi, enriched
 the fault reasons to be able to map unrecoverable SMMUv3 errors]
---
 include/linux/iommu.h      | 55 ++++++++++++++++++++++++-
 include/uapi/linux/iommu.h | 83 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 244c1a3d5989..1dedc2d247c2 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -49,13 +49,17 @@ struct bus_type;
 struct device;
 struct iommu_domain;
 struct notifier_block;
+struct iommu_fault_event;
 
 /* iommu fault flags */
-#define IOMMU_FAULT_READ	0x0
-#define IOMMU_FAULT_WRITE	0x1
+#define IOMMU_FAULT_READ		(1 << 0)
+#define IOMMU_FAULT_WRITE		(1 << 1)
+#define IOMMU_FAULT_EXEC		(1 << 2)
+#define IOMMU_FAULT_PRIV		(1 << 3)
 
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
 			struct device *, unsigned long, int, void *);
+typedef int (*iommu_dev_fault_handler_t)(struct iommu_fault_event *, void *);
 
 struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
@@ -255,6 +259,52 @@ struct iommu_device {
 	struct device *dev;
 };
 
+/**
+ * struct iommu_fault_event - Generic per device fault data
+ *
+ * - PCI and non-PCI devices
+ * - Recoverable faults (e.g. page request), information based on PCI ATS
+ * and PASID spec.
+ * - Un-recoverable faults of device interest
+ * - DMA remapping and IRQ remapping faults
+ *
+ * @fault: fault descriptor
+ * @device_private: if present, uniquely identify device-specific
+ *                  private data for an individual page request.
+ * @iommu_private: used by the IOMMU driver for storing fault-specific
+ *                 data. Users should not modify this field before
+ *                 sending the fault response.
+ */
+struct iommu_fault_event {
+	struct iommu_fault fault;
+	u64 device_private;
+	u64 iommu_private;
+};
+
+/**
+ * struct iommu_fault_param - per-device IOMMU fault data
+ * @dev_fault_handler: Callback function to handle IOMMU faults at device level
+ * @data: handler private data
+ *
+ */
+struct iommu_fault_param {
+	iommu_dev_fault_handler_t handler;
+	void *data;
+};
+
+/**
+ * struct iommu_param - collection of per-device IOMMU data
+ *
+ * @fault_param: IOMMU detected device fault reporting data
+ *
+ * TODO: migrate other per device data pointers under iommu_dev_data, e.g.
+ *	struct iommu_group	*iommu_group;
+ *	struct iommu_fwspec	*iommu_fwspec;
+ */
+struct iommu_param {
+	struct iommu_fault_param *fault_param;
+};
+
 int  iommu_device_register(struct iommu_device *iommu);
 void iommu_device_unregister(struct iommu_device *iommu);
 int  iommu_device_sysfs_add(struct iommu_device *iommu,
@@ -438,6 +488,7 @@ struct iommu_ops {};
 struct iommu_group {};
 struct iommu_fwspec {};
 struct iommu_device {};
+struct iommu_fault_param {};
 
 static inline bool iommu_present(struct bus_type *bus)
 {
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index f28cd9a1aa96..e9b5330a13c8 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -148,4 +148,87 @@ struct iommu_guest_msi_binding {
 	__u64		gpa;
 	__u32		granule;
 };
+
+/*  Generic fault types, can be expanded IRQ remapping fault */
+enum iommu_fault_type {
+	IOMMU_FAULT_DMA_UNRECOV = 1,	/* unrecoverable fault */
+	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
+};
+
+enum iommu_fault_reason {
+	IOMMU_FAULT_REASON_UNKNOWN = 0,
+
+	/* IOMMU internal error, no specific reason to report out */
+	IOMMU_FAULT_REASON_INTERNAL,
+
+	/* Could not access the PASID table (fetch caused external abort) */
+	IOMMU_FAULT_REASON_PASID_FETCH,
+
+	/* could not access the device context (fetch caused external abort) */
+	IOMMU_FAULT_REASON_DEVICE_CONTEXT_FETCH,
+
+	/* pasid entry is invalid or has configuration errors */
+	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
+
+	/* device context entry is invalid or has configuration errors */
+	IOMMU_FAULT_REASON_BAD_DEVICE_CONTEXT_ENTRY,
+	/*
+	 * PASID is out of range (e.g. exceeds the maximum PASID
+	 * supported by the IOMMU) or disabled.
+	 */
+	IOMMU_FAULT_REASON_PASID_INVALID,
+
+	/* source id is out of range */
+	IOMMU_FAULT_REASON_SOURCEID_INVALID,
+
+	/*
+	 * An external abort occurred fetching (or updating) a translation
+	 * table descriptor
+	 */
+	IOMMU_FAULT_REASON_WALK_EABT,
+
+	/*
+	 * Could not access the page table entry (Bad address),
+	 * actual translation fault
+	 */
+	IOMMU_FAULT_REASON_PTE_FETCH,
+
+	/* Protection flag check failed */
+	IOMMU_FAULT_REASON_PERMISSION,
+
+	/* access flag check failed */
+	IOMMU_FAULT_REASON_ACCESS,
+
+	/* Output address of a translation stage caused Address Size fault */
+	IOMMU_FAULT_REASON_OOR_ADDRESS
+};
+
+/**
+ * struct iommu_fault - Generic fault data
+ *
+ * @type contains fault type
+ * @reason fault reasons if relevant outside IOMMU driver.
+ * IOMMU driver internal faults are not reported.
+ * @addr: tells the offending page address
+ * @fetch_addr: tells the address that caused an abort, if any
+ * @pasid: contains process address space ID, used in shared virtual memory
+ * @page_req_group_id: page request group index
+ * @last_req: last request in a page request group
+ * @pasid_valid: indicates if the PRQ has a valid PASID
+ * @prot: page access protection flag:
+ *	IOMMU_FAULT_READ, IOMMU_FAULT_WRITE
+ */
+
+struct iommu_fault {
+	__u32	type;   /* enum iommu_fault_type */
+	__u32	reason; /* enum iommu_fault_reason */
+	__u64	addr;
+	__u64	fetch_addr;
+	__u32	pasid;
+	__u32	page_req_group_id;
+	__u32	last_req;
+	__u32	pasid_valid;
+	__u32	prot;
+	__u32	access;
+};
 #endif /* _UAPI_IOMMU_H */
-- 
2.17.2
