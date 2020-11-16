Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D3BC5519F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 10:43:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 818AA222C4
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 10:43:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A3rW9Ykd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 818AA222C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06CAE4B77C;
	Mon, 16 Nov 2020 05:43:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n0K-DhXeM7Sa; Mon, 16 Nov 2020 05:43:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B93574C14E;
	Mon, 16 Nov 2020 05:43:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E40BE4C155
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 05:43:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8varPSOFV1WZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 05:43:46 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 076BD4BF7A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 05:43:46 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605523425;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Xt9O3qgPaQcKJ6v+r6VkbOebz28mmgpKfhwxBsPCjFg=;
 b=A3rW9YkddHwKHvIr5xzOoEmW4FrK+61TZctVjlTFJAfCDP8HDeB3vRWRE4tl6XOGTAbiEY
 pmqmCGlKQOQjK16s+Ns1lEIj0bsxm4QjhUjKG8VOp5l4AWoDRjTA1o7aThBrKppjLpwnSS
 tGZPOQwngNho+6lep7CImHzOdCwS/9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-rW4bRd8LMpSBbQGJ6D96iw-1; Mon, 16 Nov 2020 05:43:42 -0500
X-MC-Unique: rW4bRd8LMpSBbQGJ6D96iw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E05DA10074CD;
 Mon, 16 Nov 2020 10:43:39 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9F1825C5FE;
 Mon, 16 Nov 2020 10:43:35 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Subject: [PATCH v12 02/15] iommu: Introduce bind/unbind_guest_msi
Date: Mon, 16 Nov 2020 11:43:03 +0100
Message-Id: <20201116104316.31816-3-eric.auger@redhat.com>
In-Reply-To: <20201116104316.31816-1-eric.auger@redhat.com>
References: <20201116104316.31816-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, alex.williamson@redhat.com,
 yi.l.liu@intel.com, zhangfei.gao@linaro.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On ARM, MSI are translated by the SMMU. An IOVA is allocated
for each MSI doorbell. If both the host and the guest are exposed
with SMMUs, we end up with 2 different IOVAs allocated by each.
guest allocates an IOVA (gIOVA) to map onto the guest MSI
doorbell (gDB). The Host allocates another IOVA (hIOVA) to map
onto the physical doorbell (hDB).

So we end up with 2 untied mappings:
         S1            S2
gIOVA    ->    gDB
              hIOVA    ->    hDB

Currently the PCI device is programmed by the host with hIOVA
as MSI doorbell. So this does not work.

This patch introduces an API to pass gIOVA/gDB to the host so
that gIOVA can be reused by the host instead of re-allocating
a new IOVA. So the goal is to create the following nested mapping:

         S1            S2
gIOVA    ->    gDB     ->    hDB

and program the PCI device with gIOVA MSI doorbell.

In case we have several devices attached to this nested domain
(devices belonging to the same group), they cannot be isolated
on guest side either. So they should also end up in the same domain
on guest side. We will enforce that all the devices attached to
the host iommu domain use the same physical doorbell and similarly
a single virtual doorbell mapping gets registered (1 single
virtual doorbell is used on guest as well).

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v7 -> v8:
- dummy iommu_unbind_guest_msi turned into a void function

v6 -> v7:
- remove the device handle parameter.
- Add comments saying there can only be a single MSI binding
  registered per iommu_domain
v5 -> v6:
-fix compile issue when IOMMU_API is not set

v3 -> v4:
- add unbind

v2 -> v3:
- add a struct device handle
---
 drivers/iommu/iommu.c | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/iommu.h | 20 ++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b061bf4c3bb2..3f311e25d6e2 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2251,6 +2251,43 @@ static void __iommu_detach_device(struct iommu_domain *domain,
 	trace_detach_device_from_domain(dev);
 }
 
+/**
+ * iommu_bind_guest_msi - Passes the stage1 GIOVA/GPA mapping of a
+ * virtual doorbell
+ *
+ * @domain: iommu domain the stage 1 mapping will be attached to
+ * @iova: iova allocated by the guest
+ * @gpa: guest physical address of the virtual doorbell
+ * @size: granule size used for the mapping
+ *
+ * The associated IOVA can be reused by the host to create a nested
+ * stage2 binding mapping translating into the physical doorbell used
+ * by the devices attached to the domain.
+ *
+ * All devices within the domain must share the same physical doorbell.
+ * A single MSI GIOVA/GPA mapping can be attached to an iommu_domain.
+ */
+
+int iommu_bind_guest_msi(struct iommu_domain *domain,
+			 dma_addr_t giova, phys_addr_t gpa, size_t size)
+{
+	if (unlikely(!domain->ops->bind_guest_msi))
+		return -ENODEV;
+
+	return domain->ops->bind_guest_msi(domain, giova, gpa, size);
+}
+EXPORT_SYMBOL_GPL(iommu_bind_guest_msi);
+
+void iommu_unbind_guest_msi(struct iommu_domain *domain,
+			    dma_addr_t iova)
+{
+	if (unlikely(!domain->ops->unbind_guest_msi))
+		return;
+
+	domain->ops->unbind_guest_msi(domain, iova);
+}
+EXPORT_SYMBOL_GPL(iommu_unbind_guest_msi);
+
 void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 {
 	struct iommu_group *group;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 464fcbecf841..35819bff03bc 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -225,6 +225,8 @@ struct iommu_iotlb_gather {
  * @sva_unbind_gpasid: unbind guest pasid and mm
  * @attach_pasid_table: attach a pasid table
  * @detach_pasid_table: detach the pasid table
+ * @bind_guest_msi: provides a stage1 giova/gpa MSI doorbell mapping
+ * @unbind_guest_msi: withdraw a stage1 giova/gpa MSI doorbell mapping
  * @def_domain_type: device default domain type, return value:
  *		- IOMMU_DOMAIN_IDENTITY: must use an identity domain
  *		- IOMMU_DOMAIN_DMA: must use a dma domain
@@ -305,6 +307,10 @@ struct iommu_ops {
 
 	int (*def_domain_type)(struct device *dev);
 
+	int (*bind_guest_msi)(struct iommu_domain *domain,
+			      dma_addr_t giova, phys_addr_t gpa, size_t size);
+	void (*unbind_guest_msi)(struct iommu_domain *domain, dma_addr_t giova);
+
 	unsigned long pgsize_bitmap;
 	struct module *owner;
 };
@@ -444,6 +450,10 @@ extern int iommu_attach_pasid_table(struct iommu_domain *domain,
 extern int iommu_uapi_attach_pasid_table(struct iommu_domain *domain,
 					 void __user *udata);
 extern void iommu_detach_pasid_table(struct iommu_domain *domain);
+extern int iommu_bind_guest_msi(struct iommu_domain *domain,
+				dma_addr_t giova, phys_addr_t gpa, size_t size);
+extern void iommu_unbind_guest_msi(struct iommu_domain *domain,
+				   dma_addr_t giova);
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
@@ -1087,6 +1097,16 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
 {
 	return NULL;
 }
+
+static inline
+int iommu_bind_guest_msi(struct iommu_domain *domain,
+			 dma_addr_t giova, phys_addr_t gpa, size_t size)
+{
+	return -ENODEV;
+}
+static inline
+void iommu_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova) {}
+
 #endif /* CONFIG_IOMMU_API */
 
 /**
-- 
2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
