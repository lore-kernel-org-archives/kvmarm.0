Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83796C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 31 Jan 2022 16:03:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD324B26F;
	Mon, 31 Jan 2022 11:03:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s4y5JltT54vf; Mon, 31 Jan 2022 11:03:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B21844B276;
	Mon, 31 Jan 2022 11:03:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D2B44B276
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 11:03:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gqq5cVxjloug for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jan 2022 11:03:03 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34E344B26F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 11:03:03 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3D494B82668;
 Mon, 31 Jan 2022 16:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FE5C340E8;
 Mon, 31 Jan 2022 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643644980;
 bh=WoxKeHTwQ49xXf3+LWiIiOVqL9WBTWW3q4jucXTeYB4=;
 h=From:To:Cc:Subject:Date:From;
 b=Ngp3YT2ev54nhGOOoe0eRt6dKNtZHZXARqXlgwRzvuKa6tBoKRonFW1Lzd0Ctol3J
 YPCZzYZjoUnCscpvPnwxythGzbBv81SaWOqW8n7DBekxwtyqJAex4QV4rR61fOIiwt
 x5Kl4sh1+dCI4RcpU/mlJ0heP979aJnN0v4/Brm4HqyEjMDOkzOlcl6VcRqYERl1PO
 tqQk86OvC836SThNR4nCphHahYATMpfGdiM7Q2PXprk4/1otxeiszZs+BYuRF2KZin
 XapZichuVEq/jrlRe0jlrRXZjoCIcBxDWYis4ayVMRu0hjgm6IqodaV0g0uP4kT1Lh
 W8uSGLCRMqvGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nEZ8s-004OWD-1n; Mon, 31 Jan 2022 16:02:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH][kvmtool] virtio/pci: Signal INTx interrupts as level instead
 of edge
Date: Mon, 31 Jan 2022 16:02:42 +0000
Message-Id: <20220131160242.2665191-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com,
 alexandru.elisei@arm.com, kernel-team@android.com, pierre.gondois@arm.com,
 ardb@kernel.org, sami.mujawar@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Pierre Gondois <pierre.gondois@arm.com>, Will Deacon <will@kernel.org>,
 Andre Przywara <andre.przywara@arm.com>, Sami Mujawar <sami.mujawar@arm.com>,
 kernel-team@android.com
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

It appears that the way INTx is emulated is "slightly" out of spec
in kvmtool. We happily inject an edge interrupt, even if the spec
mandates a level.

This doesn't change much for either the guest or userspace (only
KVM will have a bit more work tracking the EOI), but at least
this is correct.

Reported-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Sami Mujawar <sami.mujawar@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 pci.c        | 2 +-
 virtio/pci.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/pci.c b/pci.c
index e5930331..a769ae27 100644
--- a/pci.c
+++ b/pci.c
@@ -61,7 +61,7 @@ int pci__assign_irq(struct pci_device_header *pci_hdr)
 	pci_hdr->irq_line	= irq__alloc_line();
 
 	if (!pci_hdr->irq_type)
-		pci_hdr->irq_type = IRQ_TYPE_EDGE_RISING;
+		pci_hdr->irq_type = IRQ_TYPE_LEVEL_HIGH;
 
 	return pci_hdr->irq_line;
 }
diff --git a/virtio/pci.c b/virtio/pci.c
index 41085291..2777d1c8 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -413,7 +413,7 @@ int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
 			kvm__irq_trigger(kvm, vpci->gsis[vq]);
 	} else {
 		vpci->isr = VIRTIO_IRQ_HIGH;
-		kvm__irq_trigger(kvm, vpci->legacy_irq_line);
+		kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_HIGH);
 	}
 	return 0;
 }
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
