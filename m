Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7004DC282DD
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 01:28:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24C1D20880
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 01:28:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uVhjfmZH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24C1D20880
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D04FA4A3A3;
	Sun,  7 Apr 2019 21:28:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mb9ThxM4ieF5; Sun,  7 Apr 2019 21:27:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AD4E4A48C;
	Sun,  7 Apr 2019 21:27:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41D074A47F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:27:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pl03sdNzzV2R for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Apr 2019 21:27:57 -0400 (EDT)
Received: from mail-yw1-f68.google.com (mail-yw1-f68.google.com
 [209.85.161.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28A124A321
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:27:57 -0400 (EDT)
Received: by mail-yw1-f68.google.com with SMTP id u197so4371584ywf.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 07 Apr 2019 18:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=9jMj4zisIi2PTAUSf9rNiwxCUVuPxEzAObjIhEFNUsQ=;
 b=uVhjfmZH5BN7AtgpBxgCNuaXgvIxp2FyOJ5KAtnLsAQKmtND0SiVJIF2W29FSsgj+C
 +H3IzdtwndJik/uDfjKnUyVkTyENTbeYN2oIzULB9woIWZBMIQ9xJDUzHjPnkMXfht9m
 5+Nz3tTvx5owKr0OsXkL7XlJbECEzk9MpQ2vaEGPhptYPAyibbv/pjAYhN9XC5tNUz79
 cc3k0aWWE39sr+VhAKpM76d9sh3S1+VqBd70N0oBq5JXS6k/kbg+8LvlsiY7Q4jO7NEh
 hvtMEkIOFOWUDh8NrEHNpET0VXD3IDODIN1w5FL/F9casKED/D6Oianoo2kzvxghaNU3
 gdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=9jMj4zisIi2PTAUSf9rNiwxCUVuPxEzAObjIhEFNUsQ=;
 b=BsHSO25/T3Uhedoo0fRw1M6N1TiwS4oDbTStRt8vNABbSj30Fc48OHrx6wNLL223Dl
 wSSjnVIwueMOUZtYZExElmZb6Jvkxjq+BSpiwXBe/rZUBtOnFpoV6aScGowKYVtP7/QH
 uAymMXXhwaIyXOQKENT28Rcy/2Sxn+KvVTIEEE1fhrDeXCAanclbLftpgPyPH9qFkvmw
 7wwPEeHSdXseb9LxyBoWmaWgkQ5UNYytbQM78T+ct1q6Ou1b3f6MbYQCm+LCkwwyK0jR
 bvMS6sfkL5gZV0h9jqnRztvS8brNiI7C4RG93erlYGSRYjw93x9DrwL2suCJQ4zM02sJ
 WEHQ==
X-Gm-Message-State: APjAAAXhO5yfk7sliYVJZJNLOrqv+YI3Xhp1Ehy4Mm4bruaLMKLd4OMT
 1+RkORFexouUa28Qdk3C5nqICQ==
X-Google-Smtp-Source: APXvYqyt8WJ2bAhRgvq3AHr/y7EBERk4LqRyLa1Gh4nLELo8/NnIUle1muXyjkwAwMcCQrN5ns0MbA==
X-Received: by 2002:a81:2e83:: with SMTP id u125mr20760789ywu.18.1554686876734; 
 Sun, 07 Apr 2019 18:27:56 -0700 (PDT)
Received: from localhost.localdomain (li931-65.members.linode.com.
 [45.56.113.65])
 by smtp.gmail.com with ESMTPSA id 190sm10494919ywd.62.2019.04.07.18.27.53
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sun, 07 Apr 2019 18:27:55 -0700 (PDT)
From: Leo Yan <leo.yan@linaro.org>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Will Deacon <Will.Deacon@arm.com>,
 Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
 Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>,
 Robin Murphy <Robin.Murphy@arm.com>
Subject: [PATCH v4 3/3] vfio-pci: Re-enable INTx mode when disable MSI/MSIX
Date: Mon,  8 Apr 2019 09:27:19 +0800
Message-Id: <20190408012719.16158-4-leo.yan@linaro.org>
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
Message-ID: <20190408012719.iGVKe3ROtTdvbVq-b9DNwpRiK1Y5FeKFW15xRhfxgd0@z>

Since PCI forbids enabling INTx, MSI or MSIX at the same time, it's by
default to disable INTx mode when enable MSI/MSIX mode; but this logic is
easily broken if the guest PCI driver detects the MSI/MSIX cannot work as
expected and tries to rollback to use INTx mode.  In this case, the INTx
mode has been disabled and has no chance to re-enable it, thus both INTx
mode and MSI/MSIX mode cannot work in vfio.

Below shows the detailed flow for introducing this issue:

  vfio_pci_configure_dev_irqs()
    `-> vfio_pci_enable_intx()

  vfio_pci_enable_msis()
    `-> vfio_pci_disable_intx()

  vfio_pci_disable_msis()   => Guest PCI driver disables MSI

To fix this issue, when disable MSI/MSIX we need to check if INTx mode
is available for this device or not; if the device can support INTx then
re-enable it so that the device can fallback to use it.

Since vfio_pci_disable_intx() / vfio_pci_enable_intx() pair functions
may be called for multiple times, this patch uses 'intx_fd == -1' to
denote the INTx is disabled, the pair functions can directly bail out
when detect INTx has been disabled and enabled respectively.

Suggested-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 vfio/pci.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index 3c39844..f17498e 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -28,6 +28,7 @@ struct vfio_irq_eventfd {
 	msi_update_state(state, val, VFIO_PCI_MSI_STATE_EMPTY)
 
 static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev);
+static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev);
 
 static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 				bool msix)
@@ -50,17 +51,14 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 	if (!msi_is_enabled(msis->virt_state))
 		return 0;
 
-	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX) {
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
 		/*
 		 * PCI (and VFIO) forbids enabling INTx, MSI or MSIX at the same
 		 * time. Since INTx has to be enabled from the start (we don't
-		 * have a reliable way to know when the user starts using it),
+		 * have a reliable way to know when the guest starts using it),
 		 * disable it now.
 		 */
 		vfio_pci_disable_intx(kvm, vdev);
-		/* Permanently disable INTx */
-		pdev->irq_modes &= ~VFIO_PCI_IRQ_MODE_INTX;
-	}
 
 	eventfds = (void *)msis->irq_set + sizeof(struct vfio_irq_set);
 
@@ -162,7 +160,16 @@ static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev,
 	msi_set_enabled(msis->phys_state, false);
 	msi_set_empty(msis->phys_state, true);
 
-	return 0;
+	/*
+	 * When MSI or MSIX is disabled, this might be called when
+	 * PCI driver detects the MSI interrupt failure and wants to
+	 * rollback to INTx mode.  Thus enable INTx if the device
+	 * supports INTx mode in this case.
+	 */
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
+		ret = vfio_pci_enable_intx(kvm, vdev);
+
+	return ret >= 0 ? 0 : ret;
 }
 
 static int vfio_pci_update_msi_entry(struct kvm *kvm, struct vfio_device *vdev,
@@ -1002,6 +1009,9 @@ static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
 		.index	= VFIO_PCI_INTX_IRQ_INDEX,
 	};
 
+	if (pdev->intx_fd == -1)
+		return;
+
 	pr_debug("user requested MSI, disabling INTx %d", gsi);
 
 	ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
@@ -1009,6 +1019,7 @@ static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
 
 	close(pdev->intx_fd);
 	close(pdev->unmask_fd);
+	pdev->intx_fd = -1;
 }
 
 static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
@@ -1020,6 +1031,9 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 	struct vfio_pci_device *pdev = &vdev->pci;
 	int gsi = pdev->intx_gsi;
 
+	if (pdev->intx_fd != -1)
+		return 0;
+
 	/*
 	 * PCI IRQ is level-triggered, so we use two eventfds. trigger_fd
 	 * signals an interrupt from host to guest, and unmask_fd signals the
@@ -1122,6 +1136,8 @@ static int vfio_pci_init_intx(struct kvm *kvm, struct vfio_device *vdev)
 	/* Guest is going to ovewrite our irq_line... */
 	pdev->intx_gsi = pdev->hdr.irq_line - KVM_IRQ_OFFSET;
 
+	pdev->intx_fd = -1;
+
 	return 0;
 }
 
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
