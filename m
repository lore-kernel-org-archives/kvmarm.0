Return-Path: <SRS0=9ge9=T2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49CAC282E3
	for <kvmarm@archiver.kernel.org>; Sun, 26 May 2019 16:12:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A757620657
	for <kvmarm@archiver.kernel.org>; Sun, 26 May 2019 16:12:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A757620657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E2B54A51F;
	Sun, 26 May 2019 12:12:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IIOJtqrrW2eP; Sun, 26 May 2019 12:12:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 196A14A522;
	Sun, 26 May 2019 12:12:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17E234A4E1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 May 2019 12:12:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qNwTtu8avR-h for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 May 2019 12:12:47 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEC7E4A518
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 May 2019 12:12:46 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 49CAA3084213;
 Sun, 26 May 2019 16:12:46 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-67.ams2.redhat.com [10.36.116.67])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 0C7C55DD81;
 Sun, 26 May 2019 16:12:41 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com,
 robin.murphy@arm.com
Subject: [PATCH v8 27/29] vfio_pci: Allow to mmap the fault queue
Date: Sun, 26 May 2019 18:10:02 +0200
Message-Id: <20190526161004.25232-28-eric.auger@redhat.com>
In-Reply-To: <20190526161004.25232-1-eric.auger@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.40]); Sun, 26 May 2019 16:12:46 +0000 (UTC)
Cc: marc.zyngier@arm.com, kevin.tian@intel.com, vincent.stehle@arm.com,
 ashok.raj@intel.com
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

The Producer Fault region contains the fault queue in the second page.
There is benefit to let the userspace mmap this area. So let's expose
this mmappable area through a sparse mmap entry and implement the mmap
operation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c | 61 +++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 520999994ba8..a9c8af2a774a 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -275,15 +275,70 @@ static const struct vfio_pci_fault_abi fault_abi_versions[] = {
 
 #define NR_FAULT_ABIS ARRAY_SIZE(fault_abi_versions)
 
+static int vfio_pci_fault_mmap(struct vfio_pci_device *vdev,
+			       struct vfio_pci_region *region,
+			       struct vm_area_struct *vma)
+{
+	u64 phys_len, req_len, pgoff, req_start;
+	unsigned long long addr;
+	unsigned int index, ret;
+
+	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+
+	phys_len = region->size;
+
+	req_len = vma->vm_end - vma->vm_start;
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	req_start = pgoff << PAGE_SHIFT;
+
+	/* only the second page of the producer fault region is mmappable */
+	if (req_start < PAGE_SIZE)
+		return -EINVAL;
+
+	if (req_start + req_len > phys_len)
+		return -EINVAL;
+
+	addr = virt_to_phys(vdev->fault_pages);
+	vma->vm_private_data = vdev;
+	vma->vm_pgoff = (addr >> PAGE_SHIFT) + pgoff;
+
+	ret = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			      req_len, vma->vm_page_prot);
+	return ret;
+}
+
 static int vfio_pci_fault_prod_add_capability(struct vfio_pci_device *vdev,
 		struct vfio_pci_region *region, struct vfio_info_cap *caps)
 {
+	struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
 	struct vfio_region_info_cap_fault cap = {
 		.header.id = VFIO_REGION_INFO_CAP_PRODUCER_FAULT,
 		.header.version = 1,
 		.version = NR_FAULT_ABIS,
 	};
-	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
+	size_t size = sizeof(*sparse) + sizeof(*sparse->areas);
+	int ret;
+
+	ret = vfio_info_add_capability(caps, &cap.header, sizeof(cap));
+	if (ret)
+		return ret;
+
+	sparse = kzalloc(size, GFP_KERNEL);
+	if (!sparse)
+		return -ENOMEM;
+
+	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+	sparse->header.version = 1;
+	sparse->nr_areas = 1;
+	sparse->areas[0].offset = PAGE_SIZE;
+	sparse->areas[0].size = PAGE_SIZE;
+
+	ret = vfio_info_add_capability(caps, &sparse->header, size);
+	if (ret)
+		kfree(sparse);
+
+	return ret;
 }
 
 static const struct vfio_pci_regops vfio_pci_fault_cons_regops = {
@@ -294,6 +349,7 @@ static const struct vfio_pci_regops vfio_pci_fault_cons_regops = {
 static const struct vfio_pci_regops vfio_pci_fault_prod_regops = {
 	.rw		= vfio_pci_fault_prod_rw,
 	.release	= vfio_pci_fault_release,
+	.mmap		= vfio_pci_fault_mmap,
 	.add_capability = vfio_pci_fault_prod_add_capability,
 };
 
@@ -352,7 +408,8 @@ static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
 		VFIO_REGION_TYPE_NESTED,
 		VFIO_REGION_SUBTYPE_NESTED_FAULT_PROD,
 		&vfio_pci_fault_prod_regops, 2 * PAGE_SIZE,
-		VFIO_REGION_INFO_FLAG_READ, vdev->fault_pages);
+		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_MMAP,
+		vdev->fault_pages);
 	if (ret)
 		goto out;
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
