Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293CDC282DD
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 01:27:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D327C20880
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 01:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iuvLpJWr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D327C20880
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B19D4A331;
	Sun,  7 Apr 2019 21:27:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rj+FHeQgLZ0H; Sun,  7 Apr 2019 21:27:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7710B4A379;
	Sun,  7 Apr 2019 21:27:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F89C4A321
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:27:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5NnNPYaVW9Po for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Apr 2019 21:27:53 -0400 (EDT)
Received: from mail-yb1-f194.google.com (mail-yb1-f194.google.com
 [209.85.219.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BB714A319
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:27:53 -0400 (EDT)
Received: by mail-yb1-f194.google.com with SMTP id i10so4569827ybk.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 07 Apr 2019 18:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=IYBpeb1hM5WGzOAz6a5KnUsnQB8vYOsIsT8q10nvFg8=;
 b=iuvLpJWrwn8S1CnVss1ptsO+9Sh4wQT6s+ei8WPTWj9A8sAAudMxVsJS+qx119P+wY
 IYPo0FFhibgelLiNlTiHUOBnfdAyFnNutfb2hVbxTVA0h+ubxX3eNiMPtxuvvQGCHlDe
 J7ZgZfaroJrrqZQ2bPUeuEkHDwXHEaDdZneMlvYU2LeasXI2A1fJZn3UAc5qbZP3zWlu
 1kxRRC1/h5ITcHKCuKY+oHmLNFrrCzW12D2ZpoiAeMfGTo+ihXqc9hjBwgD0mBmJr5ix
 iVxOVwM/O+1D6ANnhYAJooAxYGXCuVeXRPzjPtCnCfb9Z2/6b2bVYZCQKVyrpH3kVou5
 FSlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=IYBpeb1hM5WGzOAz6a5KnUsnQB8vYOsIsT8q10nvFg8=;
 b=oR8La4GKRtFEMTAc7Evtejd1W8QhMFLyl9dhSuP45xzzSV+bW42nEE0fo9TAyrTA/y
 yyTD+vpg4+29kvjYP865XKZnMsLcDm1bylZz9xYGkax7BkO8zoEgMe4ZiRPG684cMqHx
 hTKjCDa4aCtwFwUkBktiW9wFSrtFBllO3WfXFBZK9Is47RDTO3qhGBzvNMLcw7y0J2+G
 wNZAWZabEJBfTSAHNPZ7CQm5p6Jhf4npUT23r6OE5jMEzYIe8vXzxvAFoDHQy5z01pqb
 4MHO0Icgf5mtqtUpT1EUSSXB3Sa2FUwHza9WjjKUFmUSiVmbGbIrTFiWNeV9q54TDicS
 4DZA==
X-Gm-Message-State: APjAAAWOLtc37nMwJZLdHtVHjEchLVpUQawbftrEgl+tmuU0qAFYaJCW
 JkCo3BQKzI/r9YZ+X611w5GC8Q==
X-Google-Smtp-Source: APXvYqzEwyTO3bYhwpzPsceG2Jd4WA5VG9HW3aLeXM29ct2Vq7Fzlee2snV2YUgiCrAgqWIWU7gYig==
X-Received: by 2002:a25:1e57:: with SMTP id e84mr22261328ybe.184.1554686872852; 
 Sun, 07 Apr 2019 18:27:52 -0700 (PDT)
Received: from localhost.localdomain (li931-65.members.linode.com.
 [45.56.113.65])
 by smtp.gmail.com with ESMTPSA id 190sm10494919ywd.62.2019.04.07.18.27.49
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sun, 07 Apr 2019 18:27:52 -0700 (PDT)
From: Leo Yan <leo.yan@linaro.org>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Will Deacon <Will.Deacon@arm.com>,
 Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
 Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>,
 Robin Murphy <Robin.Murphy@arm.com>
Subject: [PATCH v4 2/3] vfio-pci: Add new function for INTx one-time
 initialisation
Date: Mon,  8 Apr 2019 09:27:18 +0800
Message-Id: <20190408012719.16158-3-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190408012719.16158-1-leo.yan@linaro.org>
References: <20190408012719.16158-1-leo.yan@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408012718.Aq3fNPkP2BoLZ2y_woo5nh9puTbRH0gMzYlMp2Xiv5A@z>

To support INTx enabling for multiple times, we need firstly to extract
one-time initialisation and move the related code into a new function
vfio_pci_init_intx(); if later disable and re-enable the INTx, we can
skip these one-time operations.

This patch move below three main operations for INTx one-time
initialisation from function vfio_pci_enable_intx() into function
vfio_pci_init_intx():

- Reserve 2 FDs for INTx;
- Sanity check with ioctl VFIO_DEVICE_GET_IRQ_INFO;
- Setup pdev->intx_gsi.

Suggested-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 vfio/pci.c | 67 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index 5224fee..3c39844 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1018,30 +1018,7 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 	struct vfio_irq_eventfd	trigger;
 	struct vfio_irq_eventfd	unmask;
 	struct vfio_pci_device *pdev = &vdev->pci;
-	int gsi = pdev->hdr.irq_line - KVM_IRQ_OFFSET;
-
-	struct vfio_irq_info irq_info = {
-		.argsz = sizeof(irq_info),
-		.index = VFIO_PCI_INTX_IRQ_INDEX,
-	};
-
-	vfio_pci_reserve_irq_fds(2);
-
-	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
-	if (ret || irq_info.count == 0) {
-		vfio_dev_err(vdev, "no INTx reported by VFIO");
-		return -ENODEV;
-	}
-
-	if (!(irq_info.flags & VFIO_IRQ_INFO_EVENTFD)) {
-		vfio_dev_err(vdev, "interrupt not eventfd capable");
-		return -EINVAL;
-	}
-
-	if (!(irq_info.flags & VFIO_IRQ_INFO_AUTOMASKED)) {
-		vfio_dev_err(vdev, "INTx interrupt not AUTOMASKED");
-		return -EINVAL;
-	}
+	int gsi = pdev->intx_gsi;
 
 	/*
 	 * PCI IRQ is level-triggered, so we use two eventfds. trigger_fd
@@ -1097,8 +1074,6 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 
 	pdev->intx_fd = trigger_fd;
 	pdev->unmask_fd = unmask_fd;
-	/* Guest is going to ovewrite our irq_line... */
-	pdev->intx_gsi = gsi;
 
 	return 0;
 
@@ -1117,6 +1092,39 @@ err_close:
 	return ret;
 }
 
+static int vfio_pci_init_intx(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int ret;
+	struct vfio_pci_device *pdev = &vdev->pci;
+	struct vfio_irq_info irq_info = {
+		.argsz = sizeof(irq_info),
+		.index = VFIO_PCI_INTX_IRQ_INDEX,
+	};
+
+	vfio_pci_reserve_irq_fds(2);
+
+	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
+	if (ret || irq_info.count == 0) {
+		vfio_dev_err(vdev, "no INTx reported by VFIO");
+		return -ENODEV;
+	}
+
+	if (!(irq_info.flags & VFIO_IRQ_INFO_EVENTFD)) {
+		vfio_dev_err(vdev, "interrupt not eventfd capable");
+		return -EINVAL;
+	}
+
+	if (!(irq_info.flags & VFIO_IRQ_INFO_AUTOMASKED)) {
+		vfio_dev_err(vdev, "INTx interrupt not AUTOMASKED");
+		return -EINVAL;
+	}
+
+	/* Guest is going to ovewrite our irq_line... */
+	pdev->intx_gsi = pdev->hdr.irq_line - KVM_IRQ_OFFSET;
+
+	return 0;
+}
+
 static int vfio_pci_configure_dev_irqs(struct kvm *kvm, struct vfio_device *vdev)
 {
 	int ret = 0;
@@ -1142,8 +1150,13 @@ static int vfio_pci_configure_dev_irqs(struct kvm *kvm, struct vfio_device *vdev
 			return ret;
 	}
 
-	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX) {
+		ret = vfio_pci_init_intx(kvm, vdev);
+		if (ret)
+			return ret;
+
 		ret = vfio_pci_enable_intx(kvm, vdev);
+	}
 
 	return ret;
 }
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
