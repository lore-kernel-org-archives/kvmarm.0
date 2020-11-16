Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06A2C4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 11:01:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2436E20684
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 11:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ijin9UCX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2436E20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B33DB4C164;
	Mon, 16 Nov 2020 06:01:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9I0Gqf7MGKoA; Mon, 16 Nov 2020 06:01:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3CB4BF63;
	Mon, 16 Nov 2020 06:01:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94A0A4BC8C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 06:01:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PMUAvD37W34r for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 06:01:41 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88C034BE06
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 06:01:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605524501;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=q4hQUNWeVvrMyJW5B2CVV/vzK8bShCZT5rYetr9JqRg=;
 b=Ijin9UCXOliaZT+MuOcrgRnr1E3/LHKxnMCNqs05+prk9v8jUxWOHtDRCpxs/S4VGu0NgQ
 PE6LU9r/Ee1o1Asu3faYdneeo5+v/ZqvprfRQLA2hMNfzKv3mBoSSmQj3RdieQto0Hz20f
 uMq6dkK+eBwxzugDw3tZOSctftw+eLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-zA1I6xGtOB6oodjH1nO7yg-1; Mon, 16 Nov 2020 06:01:38 -0500
X-MC-Unique: zA1I6xGtOB6oodjH1nO7yg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43DC21007474;
 Mon, 16 Nov 2020 11:01:36 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 956B35C716;
 Mon, 16 Nov 2020 11:01:31 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
 alex.williamson@redhat.com
Subject: [PATCH v11 07/13] vfio: Use capability chains to handle device
 specific irq
Date: Mon, 16 Nov 2020 12:00:24 +0100
Message-Id: <20201116110030.32335-8-eric.auger@redhat.com>
In-Reply-To: <20201116110030.32335-1-eric.auger@redhat.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, yi.l.liu@intel.com,
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

From: Tina Zhang <tina.zhang@intel.com>

Caps the number of irqs with fixed indexes and uses capability chains
to chain device specific irqs.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
[Eric: Put cap_offset at the end of the vfio_irq_info struct,
remove GFX IRQ at the moment and remove any reference to this latter
in the commit message]

---
---
 include/uapi/linux/vfio.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 629dfb38d9e7..0e2bfbeccd08 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -701,11 +701,27 @@ struct vfio_irq_info {
 #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
 #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
 #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
+#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info supports caps */
 	__u32	index;		/* IRQ index */
 	__u32	count;		/* Number of IRQs within this index */
+	__u32	cap_offset;	/* Offset within info struct of first cap */
 };
 #define VFIO_DEVICE_GET_IRQ_INFO	_IO(VFIO_TYPE, VFIO_BASE + 9)
 
+/*
+ * The irq type capability allows IRQs unique to a specific device or
+ * class of devices to be exposed.
+ *
+ * The structures below define version 1 of this capability.
+ */
+#define VFIO_IRQ_INFO_CAP_TYPE      3
+
+struct vfio_irq_info_cap_type {
+	struct vfio_info_cap_header header;
+	__u32 type;     /* global per bus driver */
+	__u32 subtype;  /* type specific */
+};
+
 /**
  * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
  *
@@ -807,7 +823,8 @@ enum {
 	VFIO_PCI_MSIX_IRQ_INDEX,
 	VFIO_PCI_ERR_IRQ_INDEX,
 	VFIO_PCI_REQ_IRQ_INDEX,
-	VFIO_PCI_NUM_IRQS
+	VFIO_PCI_NUM_IRQS = 5	/* Fixed user ABI, IRQ indexes >=5 use   */
+				/* device specific cap to define content */
 };
 
 /*
-- 
2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
