Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CC3C43462
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 13:49:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1FA161584
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 13:49:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1FA161584
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C3C74B4EF;
	Mon, 10 May 2021 09:49:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RDWYzaZ5+nMz; Mon, 10 May 2021 09:49:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6AC4B82D;
	Mon, 10 May 2021 09:49:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 542D74B4BA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 09:49:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G6JXtYovAuRt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 09:49:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7763D4B6B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 09:49:25 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DF97161104;
 Mon, 10 May 2021 13:49:23 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lg6Hi-000Rol-7E; Mon, 10 May 2021 14:49:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 5/9] KVM: arm64: vgic: move irq->get_input_level into an
 ops structure
Date: Mon, 10 May 2021 14:48:20 +0100
Message-Id: <20210510134824.1910399-6-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510134824.1910399-1-maz@kernel.org>
References: <20210510134824.1910399-1-maz@kernel.org>
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

We already have the option to attach a callback to an interrupt
to retrieve its pending state. As we are planning to expand this
facility, move this callback into its own data structure.

This will limit the size of individual interrupts as the ops
structures can be shared across multiple interrupts.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c |  8 ++++++--
 arch/arm64/kvm/vgic/vgic.c  | 14 +++++++-------
 include/kvm/arm_vgic.h      | 28 +++++++++++++++++-----------
 3 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 74e0699661e9..e2288b6bf435 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1116,6 +1116,10 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	return kvm_timer_should_fire(timer);
 }
 
+static struct irq_ops arch_timer_irq_ops = {
+	.get_input_level = kvm_arch_timer_get_input_level,
+};
+
 int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
@@ -1143,7 +1147,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	ret = kvm_vgic_map_phys_irq(vcpu,
 				    map.direct_vtimer->host_timer_irq,
 				    map.direct_vtimer->irq.irq,
-				    kvm_arch_timer_get_input_level);
+				    &arch_timer_irq_ops);
 	if (ret)
 		return ret;
 
@@ -1151,7 +1155,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		ret = kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
 					    map.direct_ptimer->irq.irq,
-					    kvm_arch_timer_get_input_level);
+					    &arch_timer_irq_ops);
 	}
 
 	if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 15b666200f0b..111bff47e471 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -182,8 +182,8 @@ bool vgic_get_phys_line_level(struct vgic_irq *irq)
 
 	BUG_ON(!irq->hw);
 
-	if (irq->get_input_level)
-		return irq->get_input_level(irq->intid);
+	if (irq->ops && irq->ops->get_input_level)
+		return irq->ops->get_input_level(irq->intid);
 
 	WARN_ON(irq_get_irqchip_state(irq->host_irq,
 				      IRQCHIP_STATE_PENDING,
@@ -480,7 +480,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 /* @irq->irq_lock must be held */
 static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 			    unsigned int host_irq,
-			    bool (*get_input_level)(int vindid))
+			    struct irq_ops *ops)
 {
 	struct irq_desc *desc;
 	struct irq_data *data;
@@ -500,7 +500,7 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	irq->hw = true;
 	irq->host_irq = host_irq;
 	irq->hwintid = data->hwirq;
-	irq->get_input_level = get_input_level;
+	irq->ops = ops;
 	return 0;
 }
 
@@ -509,11 +509,11 @@ static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 {
 	irq->hw = false;
 	irq->hwintid = 0;
-	irq->get_input_level = NULL;
+	irq->ops = NULL;
 }
 
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid, bool (*get_input_level)(int vindid))
+			  u32 vintid, struct irq_ops *ops)
 {
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
 	unsigned long flags;
@@ -522,7 +522,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 	BUG_ON(!irq);
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
-	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, get_input_level);
+	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, ops);
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e45b26e8d479..e5f06df000f2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -92,6 +92,21 @@ enum vgic_irq_config {
 	VGIC_CONFIG_LEVEL
 };
 
+/*
+ * Per-irq ops overriding some common behavious.
+ *
+ * Always called in non-preemptible section and the functions can use
+ * kvm_arm_get_running_vcpu() to get the vcpu pointer for private IRQs.
+ */
+struct irq_ops {
+	/*
+	 * Callback function pointer to in-kernel devices that can tell us the
+	 * state of the input level of mapped level-triggered IRQ faster than
+	 * peaking into the physical GIC.
+	 */
+	bool (*get_input_level)(int vintid);
+};
+
 struct vgic_irq {
 	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
 	struct list_head lpi_list;	/* Used to link all LPIs together */
@@ -129,16 +144,7 @@ struct vgic_irq {
 	u8 group;			/* 0 == group 0, 1 == group 1 */
 	enum vgic_irq_config config;	/* Level or edge */
 
-	/*
-	 * Callback function pointer to in-kernel devices that can tell us the
-	 * state of the input level of mapped level-triggered IRQ faster than
-	 * peaking into the physical GIC.
-	 *
-	 * Always called in non-preemptible section and the functions can use
-	 * kvm_arm_get_running_vcpu() to get the vcpu pointer for private
-	 * IRQs.
-	 */
-	bool (*get_input_level)(int vintid);
+	struct irq_ops *ops;
 
 	void *owner;			/* Opaque pointer to reserve an interrupt
 					   for in-kernel devices. */
@@ -355,7 +361,7 @@ void kvm_vgic_init_cpu_hardware(void);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level, void *owner);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid, bool (*get_input_level)(int vindid));
+			  u32 vintid, struct irq_ops *ops);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
