Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A63C10F14
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 12:19:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EBECD2087F
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 12:19:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBECD2087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A23AD4A41C;
	Mon,  8 Apr 2019 08:19:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nfl1X8AQJxtP; Mon,  8 Apr 2019 08:19:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 544384A44D;
	Mon,  8 Apr 2019 08:19:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C73344A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 08:19:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R4hWJ2bQ0wEf for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 08:19:38 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D3EF4A321
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 08:19:38 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 4B61A30833C0;
 Mon,  8 Apr 2019 12:19:37 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-161.ams2.redhat.com [10.36.117.161])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3F3E4600C4;
 Mon,  8 Apr 2019 12:19:31 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com,
 robin.murphy@arm.com
Subject: [PATCH v7 02/23] iommu: introduce device fault data
Date: Mon,  8 Apr 2019 14:18:50 +0200
Message-Id: <20190408121911.24103-3-eric.auger@redhat.com>
In-Reply-To: <20190408121911.24103-1-eric.auger@redhat.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.44]); Mon, 08 Apr 2019 12:19:37 +0000 (UTC)
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com,
 marc.zyngier@arm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408121850.3EWI3_17yTx-3rYQpPVyyGWRXMgCC_Iwd96nft3C8i8@z>

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Device faults detected by IOMMU can be reported outside the IOMMU
subsystem for further processing. This patch introduces
a generic device fault data structure.

The fault can be either an unrecoverable fault or a page request,
also referred to as a recoverable fault.

We only care about non internal faults that are likely to be reported
to an external subsystem.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v4 -> v5:
- simplified struct iommu_fault_event comment
- Moved IOMMU_FAULT_PERM outside of the struct
- Removed IOMMU_FAULT_PERM_INST
- s/IOMMU_FAULT_PAGE_REQUEST_PASID_PRESENT/
  IOMMU_FAULT_PAGE_REQUEST_PASID_VALID

v3 -> v4:
- use a union containing aither an unrecoverable fault or a page
  request message. Move the device private data in the page request
  structure. Reshuffle the fields and use flags.
- move fault perm attributes to the uapi
- remove a bunch of iommu_fault_reason enum values that were related
  to internal errors
---
 include/linux/iommu.h      |  44 ++++++++++++++
 include/uapi/linux/iommu.h | 115 +++++++++++++++++++++++++++++++++++++
 2 files changed, 159 insertions(+)
 create mode 100644 include/uapi/linux/iommu.h

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ffbbc7e39cee..c6f398f7e6e0 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -25,6 +25,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <uapi/linux/iommu.h>
 
 #define IOMMU_READ	(1 << 0)
 #define IOMMU_WRITE	(1 << 1)
@@ -48,6 +49,7 @@ struct bus_type;
 struct device;
 struct iommu_domain;
 struct notifier_block;
+struct iommu_fault_event;
 
 /* iommu fault flags */
 #define IOMMU_FAULT_READ	0x0
@@ -55,6 +57,7 @@ struct notifier_block;
 
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
 			struct device *, unsigned long, int, void *);
+typedef int (*iommu_dev_fault_handler_t)(struct iommu_fault_event *, void *);
 
 struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
@@ -247,6 +250,46 @@ struct iommu_device {
 	struct device *dev;
 };
 
+/**
+ * struct iommu_fault_event - Generic fault event
+ *
+ * Can represent recoverable faults such as a page requests or
+ * unrecoverable faults such as DMA or IRQ remapping faults.
+ *
+ * @fault: fault descriptor
+ * @iommu_private: used by the IOMMU driver for storing fault-specific
+ *                 data. Users should not modify this field before
+ *                 sending the fault response.
+ */
+struct iommu_fault_event {
+	struct iommu_fault fault;
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
@@ -422,6 +465,7 @@ struct iommu_ops {};
 struct iommu_group {};
 struct iommu_fwspec {};
 struct iommu_device {};
+struct iommu_fault_param {};
 
 static inline bool iommu_present(struct bus_type *bus)
 {
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
new file mode 100644
index 000000000000..edcc0dda7993
--- /dev/null
+++ b/include/uapi/linux/iommu.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * IOMMU user API definitions
+ */
+
+#ifndef _UAPI_IOMMU_H
+#define _UAPI_IOMMU_H
+
+#include <linux/types.h>
+
+#define IOMMU_FAULT_PERM_WRITE	(1 << 0) /* write */
+#define IOMMU_FAULT_PERM_EXEC	(1 << 1) /* exec */
+#define IOMMU_FAULT_PERM_PRIV	(1 << 2) /* privileged */
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
+	/* Could not access the PASID table (fetch caused external abort) */
+	IOMMU_FAULT_REASON_PASID_FETCH,
+
+	/* pasid entry is invalid or has configuration errors */
+	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
+
+	/*
+	 * PASID is out of range (e.g. exceeds the maximum PASID
+	 * supported by the IOMMU) or disabled.
+	 */
+	IOMMU_FAULT_REASON_PASID_INVALID,
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
+	IOMMU_FAULT_REASON_OOR_ADDRESS,
+};
+
+/**
+ * Unrecoverable fault data
+ * @reason: reason of the fault
+ * @addr: offending page address
+ * @fetch_addr: address that caused a fetch abort, if any
+ * @pasid: contains process address space ID, used in shared virtual memory
+ * @perm: Requested permission access using by the incoming transaction
+ * (IOMMU_FAULT_PERM_* values)
+ */
+struct iommu_fault_unrecoverable {
+	__u32	reason; /* enum iommu_fault_reason */
+#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
+#define IOMMU_FAULT_UNRECOV_PERM_VALID		(1 << 1)
+#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 2)
+#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 3)
+	__u32	flags;
+	__u32	pasid;
+	__u32	perm;
+	__u64	addr;
+	__u64	fetch_addr;
+};
+
+/*
+ * Page Request data (aka. recoverable fault data)
+ * @flags : encodes whether the pasid is valid and whether this
+ * is the last page in group
+ * @pasid: pasid
+ * @grpid: page request group index
+ * @perm: requested page permissions (IOMMU_FAULT_PERM_* values)
+ * @addr: page address
+ */
+struct iommu_fault_page_request {
+#define IOMMU_FAULT_PAGE_REQUEST_PASID_VALID	(1 << 0)
+#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
+#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
+	__u32   flags;
+	__u32	pasid;
+	__u32	grpid;
+	__u32	perm;
+	__u64	addr;
+	__u64	private_data[2];
+};
+
+/**
+ * struct iommu_fault - Generic fault data
+ *
+ * @type contains fault type
+ */
+
+struct iommu_fault {
+	__u32	type;   /* enum iommu_fault_type */
+	__u32	reserved;
+	union {
+		struct iommu_fault_unrecoverable event;
+		struct iommu_fault_page_request prm;
+	};
+};
+#endif /* _UAPI_IOMMU_H */
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
