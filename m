Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E25C433E6
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 21:08:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9DF6F64E89
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 21:08:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DF6F64E89
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50F5D4B21B;
	Tue, 23 Feb 2021 16:08:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X-mTteU+TZDg; Tue, 23 Feb 2021 16:08:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AC0E4B236;
	Tue, 23 Feb 2021 16:08:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EA434B11E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 16:08:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gUfkN5hGvS44 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 16:08:13 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 654AD4B153
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 16:08:13 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1614114493;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2A+UxmjgYX3NKEigcEzDsWb1xLUpHLySe93FlLrjxpc=;
 b=RHyCFJD9opX37RnyR3pDgC6q78+Zat7M4dX2SLroitsigp2IAMxYQpi1dWfZVeHRriblPi
 ETNWY1CRoy/qtqAptb4Xf6eYS8x31BMygpqBZSOJGd/JOWgUqTanps+vRP0jXr7fATAhgr
 sfEI8mxSEw2qV7v0jM8sGR0hQmqQmzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-HAyij1w_N1ii647t3ps2sg-1; Tue, 23 Feb 2021 16:07:56 -0500
X-MC-Unique: HAyij1w_N1ii647t3ps2sg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFE5D107ACF5;
 Tue, 23 Feb 2021 21:07:51 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 437905D9D0;
 Tue, 23 Feb 2021 21:07:41 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
 alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Subject: [PATCH v12 10/13] vfio/pci: Register and allow DMA FAULT IRQ signaling
Date: Tue, 23 Feb 2021 22:06:22 +0100
Message-Id: <20210223210625.604517-11-eric.auger@redhat.com>
In-Reply-To: <20210223210625.604517-1-eric.auger@redhat.com>
References: <20210223210625.604517-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 wangxingang5@huawei.com, lushenming@huawei.com, nicoleotsuka@gmail.com,
 vivek.gautam@arm.com, yi.l.liu@intel.com, vsethi@nvidia.com,
 zhangfei.gao@linaro.org
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

Register the VFIO_IRQ_TYPE_NESTED/VFIO_IRQ_SUBTYPE_DMA_FAULT
IRQ that allows to signal a nested mode DMA fault.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v10 -> v11:
- the irq now is registered in vfio_pci_dma_fault_init()
  in case the domain is nested
---
 drivers/vfio/pci/vfio_pci.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e6b94bad77da..f3fa6d4318ae 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -396,6 +396,7 @@ vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
 		(struct vfio_region_dma_fault *)vdev->fault_pages;
 	struct iommu_fault *new;
 	u32 head, tail, size;
+	int ext_irq_index;
 	int ret = -EINVAL;
 
 	if (WARN_ON(!reg))
@@ -420,7 +421,19 @@ vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
 	ret = 0;
 unlock:
 	mutex_unlock(&vdev->fault_queue_lock);
-	return ret;
+	if (ret)
+		return ret;
+
+	ext_irq_index = vfio_pci_get_ext_irq_index(vdev, VFIO_IRQ_TYPE_NESTED,
+						   VFIO_IRQ_SUBTYPE_DMA_FAULT);
+	if (ext_irq_index < 0)
+		return -EINVAL;
+
+	mutex_lock(&vdev->igate);
+	if (vdev->ext_irqs[ext_irq_index].trigger)
+		eventfd_signal(vdev->ext_irqs[ext_irq_index].trigger, 1);
+	mutex_unlock(&vdev->igate);
+	return 0;
 }
 
 #define DMA_FAULT_RING_LENGTH 512
@@ -475,6 +488,12 @@ static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
 	if (ret) /* the dma fault region is freed in vfio_pci_disable() */
 		goto out;
 
+	ret = vfio_pci_register_irq(vdev, VFIO_IRQ_TYPE_NESTED,
+				    VFIO_IRQ_SUBTYPE_DMA_FAULT,
+				    VFIO_IRQ_INFO_EVENTFD);
+	if (ret) /* the fault handler is also freed in vfio_pci_disable() */
+		goto out;
+
 	return 0;
 out:
 	kfree(vdev->fault_pages);
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
