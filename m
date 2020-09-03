Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE623C433E9
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 15:56:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A802020786
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 15:56:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSB2VzPA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A802020786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 607DB4B2C4;
	Thu,  3 Sep 2020 11:56:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IAKwG3FoWwMC; Thu,  3 Sep 2020 11:55:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D8514B2C7;
	Thu,  3 Sep 2020 11:55:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1154B2C4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 11:55:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I77uEf4Vg1-s for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 11:55:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EC4E4B249
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 11:55:55 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8549E206EF;
 Thu,  3 Sep 2020 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599148554;
 bh=mIcx7QKvrQ/3Pi34zcPE1Rc2LMl3kMD/YYZYDG3ZIls=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=eSB2VzPA6iOu/YGp9mhI8cNyyqD/69JylHkOAzB+6F7f3j+oG3n6brBMUZozKIaSM
 yBQJbhWeDbic3pVIsFfIIdY0rbln7bXRVFL1lbzqPNUAvT01ji+iaAMHk2cA2z/gUq
 Y9fE9rSGWPMvhdaGcqD2blX6Ja9fAMMKAeSsz1p0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kDr8D-008vT9-2Q; Thu, 03 Sep 2020 16:26:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 20/23] KVM: arm64: Move irqfd routing to irqchip_flow
Date: Thu,  3 Sep 2020 16:26:07 +0100
Message-Id: <20200903152610.1078827-21-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com
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

irqfd handling is still hidden away in the vgic code. Let's
extract it and move the generic part in the non-GIC code,
with the now required abstraction in the irqchip_flow struct.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_irq.h | 11 +++++
 arch/arm64/kvm/arm.c             | 68 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c  |  3 ++
 arch/arm64/kvm/vgic/vgic-irqfd.c | 72 ++++++--------------------------
 arch/arm64/kvm/vgic/vgic.h       | 10 +++++
 5 files changed, 104 insertions(+), 60 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
index 649b7d4c7e9f..05fbe5241642 100644
--- a/arch/arm64/include/asm/kvm_irq.h
+++ b/arch/arm64/include/asm/kvm_irq.h
@@ -19,6 +19,8 @@ enum kvm_irqchip_type {
 
 #define irqchip_finalized(k)	((k)->arch.irqchip_finalized)
 
+struct kvm_kernel_irq_routing_entry;
+
 struct kvm_irqchip_flow {
 	void (*irqchip_destroy)(struct kvm *);
 	int  (*irqchip_vcpu_init)(struct kvm_vcpu *);
@@ -41,6 +43,15 @@ struct kvm_irqchip_flow {
 				     u32, bool (*)(int));
 	int  (*irqchip_unmap_phys_irq)(struct kvm_vcpu *, unsigned int);
 	int  (*irqchip_set_owner)(struct kvm_vcpu *, unsigned int, void *);
+	int  (*irqchip_irqfd_set_irq)(struct kvm_kernel_irq_routing_entry *e,
+				      struct kvm *kvm, int irq_source_id,
+				      int level, bool line_status);
+	int  (*irqchip_set_msi)(struct kvm_kernel_irq_routing_entry *e,
+				struct kvm *kvm, int irq_source_id,
+				int level, bool line_status);
+	int  (*irqchip_set_irq_inatomic)(struct kvm_kernel_irq_routing_entry *e,
+					 struct kvm *kvm, int irq_source_id,
+					 int level, bool line_status);
 };
 
 /*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 678533871cfa..d625904633c0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1592,6 +1592,74 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
 	kvm_arm_resume_guest(irqfd->kvm);
 }
 
+/**
+ * kvm_set_routing_entry: populate a kvm routing entry
+ * from a user routing entry
+ *
+ * @kvm: the VM this entry is applied to
+ * @e: kvm kernel routing entry handle
+ * @ue: user api routing entry handle
+ * return 0 on success, -EINVAL on errors.
+ */
+int kvm_set_routing_entry(struct kvm *kvm,
+			  struct kvm_kernel_irq_routing_entry *e,
+			  const struct kvm_irq_routing_entry *ue)
+{
+	int r = -EINVAL;
+
+	switch (ue->type) {
+	case KVM_IRQ_ROUTING_IRQCHIP:
+		e->set = kvm->arch.irqchip_flow.irqchip_irqfd_set_irq;
+		e->irqchip.irqchip = ue->u.irqchip.irqchip;
+		e->irqchip.pin = ue->u.irqchip.pin;
+		if ((e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS) ||
+		    (e->irqchip.irqchip >= KVM_NR_IRQCHIPS))
+			goto out;
+		break;
+	case KVM_IRQ_ROUTING_MSI:
+		e->set = kvm->arch.irqchip_flow.irqchip_set_msi;
+		e->msi.address_lo = ue->u.msi.address_lo;
+		e->msi.address_hi = ue->u.msi.address_hi;
+		e->msi.data = ue->u.msi.data;
+		e->msi.flags = ue->flags;
+		e->msi.devid = ue->u.msi.devid;
+		break;
+	default:
+		goto out;
+	}
+
+	if (!e->set)
+		goto out;
+
+	r = 0;
+out:
+	return r;
+}
+
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id,
+		int level, bool line_status)
+{
+	if (!kvm->arch.irqchip_flow.irqchip_set_msi)
+		return -ENODEV;
+	return kvm->arch.irqchip_flow.irqchip_set_msi(e, kvm, irq_source_id,
+						      level, line_status);
+}
+
+int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
+			      struct kvm *kvm, int irq_source_id, int level,
+			      bool line_status)
+{
+	if (!level || !irqchip_finalized(kvm) ||
+	    !kvm->arch.irqchip_flow.irqchip_set_irq_inatomic)
+		return -EWOULDBLOCK;
+
+	return kvm->arch.irqchip_flow.irqchip_set_irq_inatomic(e, kvm,
+							       irq_source_id,
+							       level,
+							       line_status);
+}
+
 /**
  * Initialize Hyp-mode and memory mappings on all CPUs.
  */
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index a3e0389617a3..440b8c09c030 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -34,6 +34,9 @@ static struct kvm_irqchip_flow vgic_irqchip_flow = {
 	.irqchip_map_phys_irq		= kvm_vgic_map_phys_irq,
 	.irqchip_unmap_phys_irq		= kvm_vgic_unmap_phys_irq,
 	.irqchip_set_owner		= kvm_vgic_set_owner,
+	.irqchip_irqfd_set_irq		= vgic_irqfd_set_irq,
+	.irqchip_set_msi		= vgic_set_msi,
+	.irqchip_set_irq_inatomic	= vgic_set_irq_inatomic,
 };
 
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index dbece60c8dc0..5bbdfe982a00 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -15,9 +15,9 @@
  *
  * This is the entry point for irqfd IRQ injection
  */
-static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
-			struct kvm *kvm, int irq_source_id,
-			int level, bool line_status)
+int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
+		       struct kvm *kvm, int irq_source_id,
+		       int level, bool line_status)
 {
 	unsigned int spi_id = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
 
@@ -26,46 +26,6 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
 	return kvm_vgic_inject_irq(kvm, 0, spi_id, level, NULL);
 }
 
-/**
- * kvm_set_routing_entry: populate a kvm routing entry
- * from a user routing entry
- *
- * @kvm: the VM this entry is applied to
- * @e: kvm kernel routing entry handle
- * @ue: user api routing entry handle
- * return 0 on success, -EINVAL on errors.
- */
-int kvm_set_routing_entry(struct kvm *kvm,
-			  struct kvm_kernel_irq_routing_entry *e,
-			  const struct kvm_irq_routing_entry *ue)
-{
-	int r = -EINVAL;
-
-	switch (ue->type) {
-	case KVM_IRQ_ROUTING_IRQCHIP:
-		e->set = vgic_irqfd_set_irq;
-		e->irqchip.irqchip = ue->u.irqchip.irqchip;
-		e->irqchip.pin = ue->u.irqchip.pin;
-		if ((e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS) ||
-		    (e->irqchip.irqchip >= KVM_NR_IRQCHIPS))
-			goto out;
-		break;
-	case KVM_IRQ_ROUTING_MSI:
-		e->set = kvm_set_msi;
-		e->msi.address_lo = ue->u.msi.address_lo;
-		e->msi.address_hi = ue->u.msi.address_hi;
-		e->msi.data = ue->u.msi.data;
-		e->msi.flags = ue->flags;
-		e->msi.devid = ue->u.msi.devid;
-		break;
-	default:
-		goto out;
-	}
-	r = 0;
-out:
-	return r;
-}
-
 static void kvm_populate_msi(struct kvm_kernel_irq_routing_entry *e,
 			     struct kvm_msi *msi)
 {
@@ -75,16 +35,17 @@ static void kvm_populate_msi(struct kvm_kernel_irq_routing_entry *e,
 	msi->flags = e->msi.flags;
 	msi->devid = e->msi.devid;
 }
+
 /**
- * kvm_set_msi: inject the MSI corresponding to the
+ * vgic_set_msi: inject the MSI corresponding to the
  * MSI routing entry
  *
  * This is the entry point for irqfd MSI injection
  * and userspace MSI injection.
  */
-int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
-		struct kvm *kvm, int irq_source_id,
-		int level, bool line_status)
+int vgic_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		 struct kvm *kvm, int irq_source_id,
+		 int level, bool line_status)
 {
 	struct kvm_msi msi;
 
@@ -99,15 +60,12 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 }
 
 /**
- * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
+ * vgic_set_irq_inatomic: fast-path for irqfd injection
  */
-int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
-			      struct kvm *kvm, int irq_source_id, int level,
-			      bool line_status)
+int vgic_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
+			  struct kvm *kvm, int irq_source_id, int level,
+			  bool line_status)
 {
-	if (!level)
-		return -EWOULDBLOCK;
-
 	switch (e->type) {
 	case KVM_IRQ_ROUTING_MSI: {
 		struct kvm_msi msi;
@@ -120,12 +78,6 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 	}
 
 	case KVM_IRQ_ROUTING_IRQCHIP:
-		/*
-		 * Injecting SPIs is always possible in atomic context
-		 * as long as the damn vgic is initialized.
-		 */
-		if (unlikely(!irqchip_finalized(kvm)))
-			break;
 		return vgic_irqfd_set_irq(e, kvm, irq_source_id, 1, line_status);
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c9e14a6cddf6..db3b111ed611 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -324,6 +324,16 @@ void vgic_lpi_translation_cache_init(struct kvm *kvm);
 void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
 void vgic_its_invalidate_cache(struct kvm *kvm);
 
+int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
+		       struct kvm *kvm, int irq_source_id,
+		       int level, bool line_status);
+int vgic_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		 struct kvm *kvm, int irq_source_id,
+		 int level, bool line_status);
+int vgic_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
+			  struct kvm *kvm, int irq_source_id, int level,
+			  bool line_status);
+
 bool vgic_supports_direct_msis(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
