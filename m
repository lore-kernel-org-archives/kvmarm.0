Return-Path: <SRS0=aSj2=JI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFC3C433ED
	for <kvmarm@archiver.kernel.org>; Sun, 11 Apr 2021 11:50:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A0196100B
	for <kvmarm@archiver.kernel.org>; Sun, 11 Apr 2021 11:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A0196100B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E88F4B4F3;
	Sun, 11 Apr 2021 07:50:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5MK9uBmkFPZY; Sun, 11 Apr 2021 07:49:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BA7A4B568;
	Sun, 11 Apr 2021 07:49:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 943D04B4F3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Apr 2021 07:49:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0JSIs1sCXGFi for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Apr 2021 07:49:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBC064B568
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Apr 2021 07:49:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618141790;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0aSD6V877Q7HGWA4DO5hGFo60VEegdaef4o5r+M0zIE=;
 b=Q4mHNejOnAVb7kvdRK+LOnqDFB1giy4ierHKAp/GGRROc7URyxMv3cIQOsRGWtihgiJ7IA
 Q1CEqhqf0bMKqp5JNVCfGoiuSGzM6ccw3TxIvw7MhnPyKs10GzJ/oeaDaJIu/9l3vP791n
 2ipsICIlYeXCkQIluG/jBNVXDnUu4fg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-c866b95IPdOWfDRSXpyyTw-1; Sun, 11 Apr 2021 07:49:47 -0400
X-MC-Unique: c866b95IPdOWfDRSXpyyTw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E03E10054F6;
 Sun, 11 Apr 2021 11:49:44 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-22.ams2.redhat.com [10.36.112.22])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 6BBC25C266;
 Sun, 11 Apr 2021 11:49:36 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
 alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Subject: [PATCH v13 13/13] vfio/pci: Inject page response upon response region
 fill
Date: Sun, 11 Apr 2021 13:46:59 +0200
Message-Id: <20210411114659.15051-14-eric.auger@redhat.com>
In-Reply-To: <20210411114659.15051-1-eric.auger@redhat.com>
References: <20210411114659.15051-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 wangxingang5@huawei.com, lushenming@huawei.com, chenxiang66@hisilicon.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, vdumpa@nvidia.com,
 yi.l.liu@intel.com, vsethi@nvidia.com, zhangfei.gao@linaro.org
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

When the userspace increments the head of the page response
buffer ring, let's push the response into the iommu layer.
This is done through a workqueue that pops the responses from
the ring buffer and increment the tail.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         | 40 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  7 +++++
 drivers/vfio/pci/vfio_pci_rdwr.c    |  1 +
 3 files changed, 48 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 560b1a830726..bb4a0e1e39bf 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -552,6 +552,32 @@ static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
 	return ret;
 }
 
+static void dma_response_inject(struct work_struct *work)
+{
+	struct vfio_pci_dma_fault_response_work *rwork =
+		container_of(work, struct vfio_pci_dma_fault_response_work, inject);
+	struct vfio_region_dma_fault_response *header = rwork->header;
+	struct vfio_pci_device *vdev = rwork->vdev;
+	struct iommu_page_response *resp;
+	u32 tail, head, size;
+
+	mutex_lock(&vdev->fault_response_queue_lock);
+
+	tail = header->tail;
+	head = header->head;
+	size = header->nb_entries;
+
+	while (CIRC_CNT(head, tail, size) >= 1) {
+		resp = (struct iommu_page_response *)(vdev->fault_response_pages + header->offset +
+						tail * header->entry_size);
+
+		/* TODO: properly handle the return value */
+		iommu_page_response(&vdev->pdev->dev, resp);
+		header->tail = tail = (tail + 1) % size;
+	}
+	mutex_unlock(&vdev->fault_response_queue_lock);
+}
+
 #define DMA_FAULT_RESPONSE_RING_LENGTH 512
 
 static int vfio_pci_dma_fault_response_init(struct vfio_pci_device *vdev)
@@ -597,8 +623,22 @@ static int vfio_pci_dma_fault_response_init(struct vfio_pci_device *vdev)
 	header->nb_entries = DMA_FAULT_RESPONSE_RING_LENGTH;
 	header->offset = PAGE_SIZE;
 
+	vdev->response_work = kzalloc(sizeof(*vdev->response_work), GFP_KERNEL);
+	if (!vdev->response_work)
+		goto out;
+	vdev->response_work->header = header;
+	vdev->response_work->vdev = vdev;
+
+	/* launch the thread that will extract the response */
+	INIT_WORK(&vdev->response_work->inject, dma_response_inject);
+	vdev->dma_fault_response_wq =
+		create_singlethread_workqueue("vfio-dma-fault-response");
+	if (!vdev->dma_fault_response_wq)
+		return -ENOMEM;
+
 	return 0;
 out:
+	kfree(vdev->fault_response_pages);
 	vdev->fault_response_pages = NULL;
 	return ret;
 }
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index f7b1e7fb86e5..835fbb221dea 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -52,6 +52,12 @@ struct vfio_pci_irq_ctx {
 	struct irq_bypass_producer	producer;
 };
 
+struct vfio_pci_dma_fault_response_work {
+	struct work_struct inject;
+	struct vfio_region_dma_fault_response *header;
+	struct vfio_pci_device *vdev;
+};
+
 struct vfio_pci_device;
 struct vfio_pci_region;
 
@@ -146,6 +152,7 @@ struct vfio_pci_device {
 	u8			*fault_pages;
 	u8			*fault_response_pages;
 	struct workqueue_struct *dma_fault_response_wq;
+	struct vfio_pci_dma_fault_response_work *response_work;
 	struct mutex		fault_queue_lock;
 	struct mutex		fault_response_queue_lock;
 	struct list_head	dummy_resources_list;
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index efde0793360b..78c494fe35cc 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -430,6 +430,7 @@ size_t vfio_pci_dma_fault_response_rw(struct vfio_pci_device *vdev, char __user
 		mutex_lock(&vdev->fault_response_queue_lock);
 		header->head = new_head;
 		mutex_unlock(&vdev->fault_response_queue_lock);
+		queue_work(vdev->dma_fault_response_wq, &vdev->response_work->inject);
 	} else {
 		if (copy_to_user(buf, base + pos, count))
 			return -EFAULT;
-- 
2.26.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
