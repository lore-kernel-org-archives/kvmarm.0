Return-Path: <SRS0=To9v=JA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F71C433B4
	for <kvmarm@archiver.kernel.org>; Sat,  3 Apr 2021 11:30:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A763C61243
	for <kvmarm@archiver.kernel.org>; Sat,  3 Apr 2021 11:30:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A763C61243
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 484D74B57D;
	Sat,  3 Apr 2021 07:30:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yjhcX94G1Z11; Sat,  3 Apr 2021 07:30:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA5014B580;
	Sat,  3 Apr 2021 07:29:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D56A4B57D
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Apr 2021 07:29:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fejgYpCJEPFl for <kvmarm@lists.cs.columbia.edu>;
 Sat,  3 Apr 2021 07:29:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 512BB4B1DA
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Apr 2021 07:29:55 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8F03461247;
 Sat,  3 Apr 2021 11:29:54 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lSeTQ-005R95-Ua; Sat, 03 Apr 2021 12:29:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 6/9] KVM: arm64: vgic: Implement SW-driven deactivation
Date: Sat,  3 Apr 2021 12:29:28 +0100
Message-Id: <20210403112931.1043452-7-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210403112931.1043452-1-maz@kernel.org>
References: <20210403112931.1043452-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st,
 mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Hector Martin <marcan@marcan.st>
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

In order to deal with these systems that do not offer HW-based
deactivation of interrupts, let implement a SW-based approach:

- When the irq is queued into a LR, treat it as a pure virtual
  interrupt and set the EOI flag in the LR.

- When the interrupt state is read back from the LR, force a
  deactivation when the state is invalid (neither active nor
  pending)

Interrupts requiring such treatment get the VGIC_SW_RESAMPLE flag.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 19 +++++++++++++++----
 arch/arm64/kvm/vgic/vgic-v3.c | 19 +++++++++++++++----
 include/kvm/arm_vgic.h        | 10 ++++++++++
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 11934c2af2f4..2c580204f1dc 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -108,11 +108,22 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		 * If this causes us to lower the level, we have to also clear
 		 * the physical active state, since we will otherwise never be
 		 * told when the interrupt becomes asserted again.
+		 *
+		 * Another case is when the interrupt requires a helping hand
+		 * on deactivation (no HW deactivation, for example).
 		 */
-		if (vgic_irq_is_mapped_level(irq) && (val & GICH_LR_PENDING_BIT)) {
-			irq->line_level = vgic_get_phys_line_level(irq);
+		if (vgic_irq_is_mapped_level(irq)) {
+			bool resample = false;
+
+			if (val & GICH_LR_PENDING_BIT) {
+				irq->line_level = vgic_get_phys_line_level(irq);
+				resample = !irq->line_level;
+			} else if (vgic_irq_needs_resampling(irq) &&
+				   !(irq->active || irq->pending_latch)) {
+				resample = true;
+			}
 
-			if (!irq->line_level)
+			if (resample)
 				vgic_irq_set_phys_active(irq, false);
 		}
 
@@ -152,7 +163,7 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	if (irq->group)
 		val |= GICH_LR_GROUP1;
 
-	if (irq->hw) {
+	if (irq->hw && !vgic_irq_needs_resampling(irq)) {
 		val |= GICH_LR_HW;
 		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
 		/*
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 6f530925a231..d7ee88de3a5c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -99,11 +99,22 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		 * If this causes us to lower the level, we have to also clear
 		 * the physical active state, since we will otherwise never be
 		 * told when the interrupt becomes asserted again.
+		 *
+		 * Another case is when the interrupt requires a helping hand
+		 * on deactivation (no HW deactivation, for example).
 		 */
-		if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT)) {
-			irq->line_level = vgic_get_phys_line_level(irq);
+		if (vgic_irq_is_mapped_level(irq)) {
+			bool resample = false;
+
+			if (val & ICH_LR_PENDING_BIT) {
+				irq->line_level = vgic_get_phys_line_level(irq);
+				resample = !irq->line_level;
+			} else if (vgic_irq_needs_resampling(irq) &&
+				   !(irq->active || irq->pending_latch)) {
+				resample = true;
+			}
 
-			if (!irq->line_level)
+			if (resample)
 				vgic_irq_set_phys_active(irq, false);
 		}
 
@@ -134,7 +145,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		}
 	}
 
-	if (irq->hw) {
+	if (irq->hw && !vgic_irq_needs_resampling(irq)) {
 		val |= ICH_LR_HW;
 		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
 		/*
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a7130f1b5ab9..379ee0c97ede 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -99,6 +99,11 @@ enum vgic_irq_config {
  * kvm_arm_get_running_vcpu() to get the vcpu pointer for private IRQs.
  */
 struct irq_ops {
+	/* Per interrupt flags for special-cased interrupts */
+	unsigned long flags;
+
+#define VGIC_IRQ_SW_RESAMPLE	BIT(0)	/* Clear the active state for resampling */
+
 	/*
 	 * Callback function pointer to in-kernel devices that can tell us the
 	 * state of the input level of mapped level-triggered IRQ faster than
@@ -150,6 +155,11 @@ struct vgic_irq {
 					   for in-kernel devices. */
 };
 
+static inline bool vgic_irq_needs_resampling(struct vgic_irq *irq)
+{
+	return irq->ops && (irq->ops->flags & VGIC_IRQ_SW_RESAMPLE);
+}
+
 struct vgic_register_region;
 struct vgic_its;
 
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
