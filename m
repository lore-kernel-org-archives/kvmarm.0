Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A113C10F0E
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 01:27:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B0B1F20880
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 01:27:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EWdceTXE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0B1F20880
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67A5A4A2E5;
	Sun,  7 Apr 2019 21:27:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GJr4DjntlfsU; Sun,  7 Apr 2019 21:27:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 557794A47B;
	Sun,  7 Apr 2019 21:27:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 722464A379
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:27:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DvgnKlJceFAE for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Apr 2019 21:27:49 -0400 (EDT)
Received: from mail-yb1-f195.google.com (mail-yb1-f195.google.com
 [209.85.219.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 874F44A3EF
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:27:49 -0400 (EDT)
Received: by mail-yb1-f195.google.com with SMTP id b88so4548113ybi.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 07 Apr 2019 18:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=7644NDN/UtoV55YslGcHSTFcY4hV/XX8F3phjUCG6BI=;
 b=EWdceTXErKmsHF4tzV20HUylAD2VPtJXLvPKhruBjRvGmGV1nLD5WurnZd83oyZRAv
 hAl6SpBVpnloLMuI0spgNAHxyM4wfxTNF7GnTVjKqnVzsWc7gkxWK+/eQj0VffOlcFAX
 1bdABNPVwsmGuqQtZFOH93EZ7R0iO/7Lk7uXBzzUL+Nb25mjVlm68/irk0sRi6WSTNMQ
 fi/gdlkO22zGlBfig26lZl1hl5RArJV7zNqnYYYunYevfzOqQAef1gXBb364UGkGgA3S
 x5WaR/MnE0hqRmPyNubcO4CynGd41msngqIAgJIJQVT77eZkv3ufcINXCMzRAkaxLuxP
 +EFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=7644NDN/UtoV55YslGcHSTFcY4hV/XX8F3phjUCG6BI=;
 b=GD+QIJE7a04HKLdXVf/Inxe5aVWkxNTsfO7B1574fjMfjQK7tWPlJ9n44AGMwnFr28
 nTfhY42QuqyKB8JqvRT/20qaT25WRswuHnCbgQAmYDhnYU5VzgEkr+JWgJwg0dLjZCtC
 F0vTqlxwoOqKsIbvONPLQovhyA09rBpVz4uhwJfhdH/O/DrV2iWHFI6RnJX2AW7WQJf2
 eQkar7uOvgpzph8JLBYwyAK0sWCF1Jr5v5f8344yiQUdlJpLH6ChaqYPPtUh+1sJzBpg
 tloufs67OLEn0GD3K7Yu/F6PRD5+CCfo5EPodByADL/H2xlOv4+XRYxNz+djfTR1inlz
 jMSA==
X-Gm-Message-State: APjAAAVpkgT+3NcPrE/PAcQsdEXU0EBXqs0bievRyDWfWIUSbJ4C+NNb
 EN8n6wY1C70u+pgU/NU74Gvnjw==
X-Google-Smtp-Source: APXvYqxrKtxmsIkyAQxk6dN2tGa7A4aleY6Uhy5YYj4XxevBbnn9eyIwLKNGsImnIfSqyFl6NfR7gQ==
X-Received: by 2002:a25:260c:: with SMTP id m12mr3949026ybm.300.1554686869046; 
 Sun, 07 Apr 2019 18:27:49 -0700 (PDT)
Received: from localhost.localdomain (li931-65.members.linode.com.
 [45.56.113.65])
 by smtp.gmail.com with ESMTPSA id 190sm10494919ywd.62.2019.04.07.18.27.45
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sun, 07 Apr 2019 18:27:48 -0700 (PDT)
From: Leo Yan <leo.yan@linaro.org>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Will Deacon <Will.Deacon@arm.com>,
 Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
 Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>,
 Robin Murphy <Robin.Murphy@arm.com>
Subject: [PATCH v4 1/3] vfio-pci: Release INTx's unmask eventfd properly
Date: Mon,  8 Apr 2019 09:27:17 +0800
Message-Id: <20190408012719.16158-2-leo.yan@linaro.org>
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
Message-ID: <20190408012717.Rtft_OFaBWufrWIsTa07qlvNjCs2opuZ04uIpJX_Mmo@z>

The PCI device INTx uses event fd 'unmask_fd' to signal the deassertion
of the line from guest to host; but this eventfd isn't released properly
when disable INTx.

This patch firstly adds field 'unmask_fd' in struct vfio_pci_device for
storing unmask eventfd and close it when disable INTx.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/vfio.h | 1 +
 vfio/pci.c         | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index 60e6c54..28223cf 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -74,6 +74,7 @@ struct vfio_pci_device {
 
 	unsigned long			irq_modes;
 	int				intx_fd;
+	int				unmask_fd;
 	unsigned int			intx_gsi;
 	struct vfio_pci_msi_common	msi;
 	struct vfio_pci_msi_common	msix;
diff --git a/vfio/pci.c b/vfio/pci.c
index 03de3c1..5224fee 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1008,6 +1008,7 @@ static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
 	irq__del_irqfd(kvm, gsi, pdev->intx_fd);
 
 	close(pdev->intx_fd);
+	close(pdev->unmask_fd);
 }
 
 static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
@@ -1095,6 +1096,7 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 	}
 
 	pdev->intx_fd = trigger_fd;
+	pdev->unmask_fd = unmask_fd;
 	/* Guest is going to ovewrite our irq_line... */
 	pdev->intx_gsi = gsi;
 
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
