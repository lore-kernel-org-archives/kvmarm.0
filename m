Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68272C43333
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 16:20:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20D272076F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 16:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S5Mka4AH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20D272076F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD8344B095;
	Fri, 20 Mar 2020 12:20:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 27OmZlzprndN; Fri, 20 Mar 2020 12:20:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4084B090;
	Fri, 20 Mar 2020 12:20:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9AC44B093
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 12:20:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OYR4brz-0HTE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 12:20:23 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED9904ACC9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 12:20:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584721222;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mhzJgSkCJsNgfAjdjebamfXi6WM/A0Mk2yWVsVfPFeA=;
 b=S5Mka4AHlwhFoToZCM4yAXeNwU65TjJYEdj67WVXdG/Fs3kedPqprcSIhMhNRvX+5QVy+I
 YGA1NLVOe9dAhdMWoyCxVADJzhUekTHA91hvhSJniEFZdGEeyAytMGLEdkr9pcc46obXhv
 zS3iS9uAQii8ONOejRdU9QeVjnk6PhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-LMNIg5YeMteTqmLbGVuhnw-1; Fri, 20 Mar 2020 12:20:19 -0400
X-MC-Unique: LMNIg5YeMteTqmLbGVuhnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B1CC100550D;
 Fri, 20 Mar 2020 16:20:17 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 61B9A60BF1;
 Fri, 20 Mar 2020 16:20:12 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com,
 robin.murphy@arm.com
Subject: [PATCH v10 06/11] vfio/pci: Allow to mmap the fault queue
Date: Fri, 20 Mar 2020 17:19:06 +0100
Message-Id: <20200320161911.27494-7-eric.auger@redhat.com>
In-Reply-To: <20200320161911.27494-1-eric.auger@redhat.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: marc.zyngier@arm.com
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

The DMA FAULT region contains the fault ring buffer.
There is benefit to let the userspace mmap this area.
Expose this mmappable area through a sparse mmap entry
and implement the mmap operation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v8 -> v9:
- remove unused index local variable in vfio_pci_fault_mmap
---
 drivers/vfio/pci/vfio_pci.c | 61 +++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 69595c240baf..3c99f6f3825b 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -266,21 +266,75 @@ static void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
 {
 }
 
+static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
+				   struct vfio_pci_region *region,
+				   struct vm_area_struct *vma)
+{
+	u64 phys_len, req_len, pgoff, req_start;
+	unsigned long long addr;
+	unsigned int ret;
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
 static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
 					     struct vfio_pci_region *region,
 					     struct vfio_info_cap *caps)
 {
+	struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
 	struct vfio_region_info_cap_fault cap = {
 		.header.id = VFIO_REGION_INFO_CAP_DMA_FAULT,
 		.header.version = 1,
 		.version = 1,
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
+	sparse->areas[0].size = region->size - PAGE_SIZE;
+
+	ret = vfio_info_add_capability(caps, &sparse->header, size);
+	if (ret)
+		kfree(sparse);
+
+	return ret;
 }
 
 static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
 	.rw		= vfio_pci_dma_fault_rw,
 	.release	= vfio_pci_dma_fault_release,
+	.mmap		= vfio_pci_dma_fault_mmap,
 	.add_capability = vfio_pci_dma_fault_add_capability,
 };
 
@@ -341,7 +395,8 @@ static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
 		VFIO_REGION_TYPE_NESTED,
 		VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT,
 		&vfio_pci_dma_fault_regops, size,
-		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE,
+		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE |
+		VFIO_REGION_INFO_FLAG_MMAP,
 		vdev->fault_pages);
 	if (ret)
 		goto out;
@@ -349,7 +404,7 @@ static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
 	header = (struct vfio_region_dma_fault *)vdev->fault_pages;
 	header->entry_size = sizeof(struct iommu_fault);
 	header->nb_entries = DMA_FAULT_RING_LENGTH;
-	header->offset = sizeof(struct vfio_region_dma_fault);
+	header->offset = PAGE_SIZE;
 
 	ret = iommu_register_device_fault_handler(&vdev->pdev->dev,
 					vfio_pci_iommu_dev_fault_handler,
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
