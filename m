Return-Path: <SRS0=y8js=UK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9A6C06508
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jun 2019 17:04:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D7A4421734
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jun 2019 17:04:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7A4421734
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FE294A517;
	Tue, 11 Jun 2019 13:04:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kCBlLgVxJ4at; Tue, 11 Jun 2019 13:04:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC484A53B;
	Tue, 11 Jun 2019 13:04:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A071D4A536
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jun 2019 13:04:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EmMuuNx2ZORY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jun 2019 13:04:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CB904A4EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jun 2019 13:04:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21131106F;
 Tue, 11 Jun 2019 10:04:01 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A61783F73C;
 Tue, 11 Jun 2019 10:03:59 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 8/9] KVM: arm/arm64: vgic-its: Check the LPI translation
 cache on MSI injection
Date: Tue, 11 Jun 2019 18:03:35 +0100
Message-Id: <20190611170336.121706-9-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611170336.121706-1-marc.zyngier@arm.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: "Raslan, KarimAllah" <karahmed@amazon.de>, "Saidi,
 Ali" <alisaidi@amazon.com>
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

When performing an MSI injection, let's first check if the translation
is already in the cache. If so, let's inject it quickly without
going through the whole translation process.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 36 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |  1 +
 2 files changed, 37 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 62932458476a..83d80ec33473 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -577,6 +577,20 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 	return irq;
 }
 
+static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
+					     u32 devid, u32 eventid)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	irq = __vgic_its_check_cache(dist, db, devid, eventid);
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+
+	return irq;
+}
+
 static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       u32 devid, u32 eventid,
 				       struct vgic_irq *irq)
@@ -736,6 +750,25 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
+int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
+{
+	struct vgic_irq *irq;
+	unsigned long flags;
+	phys_addr_t db;
+
+	db = (u64)msi->address_hi << 32 | msi->address_lo;
+	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);
+
+	if (!irq)
+		return -1;
+
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	irq->pending_latch = true;
+	vgic_queue_irq_unlock(kvm, irq, flags);
+
+	return 0;
+}
+
 /*
  * Queries the KVM IO bus framework to get the ITS pointer from the given
  * doorbell address.
@@ -747,6 +780,9 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 	struct vgic_its *its;
 	int ret;
 
+	if (!vgic_its_inject_cached_translation(kvm, msi))
+		return 1;
+
 	its = vgic_msi_to_its(kvm, msi);
 	if (IS_ERR(its))
 		return PTR_ERR(its);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 072f810dc441..ad6eba1e2beb 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -317,6 +317,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
+int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi);
 void vgic_lpi_translation_cache_init(struct kvm *kvm);
 void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
 void vgic_its_invalidate_cache(struct kvm *kvm);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
