Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB93BF665
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268816; cv=none; b=UsBNgF9Dp+8Sjn0BVrj7jXZ44ssyMuaZBQvSVZo4p9F7jSq5BU4GMcOGUYrjhfxkFRGC50ECJILVvpyWFwLWTSyovDvl3MqWgh5QclcJeioIwRmba4ji1FN927Fen4qNXWUDgvIyzyeSgFITr4xj9lQNhTqYKG+RAMkSOqmrtTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268816; c=relaxed/simple;
	bh=yplioqIZjnWLEmaw5gvgfwTLT5yAMuYlbdnykrCs0j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stC8vVl4g5zwZtzcEGGZ6Cs6a9Ft0vou3kCbpQoLuAWCmJ15HCguVQbPcjxK9t+z4WwV5ocGJZ5y+6ka7FspQjt+T2xkl3ldkfA1dgy0LuSDx1WftSSKT/7gdimKIw22AiaofiITzI6b50uIFk5vImH2A6NLrZRSH6SpzG9fhiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SuqEbL0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SuqEbL0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC91E1F00899;
	Wed, 20 May 2026 09:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268813;
	bh=Dd/xKhw83nig8KcvWFPpSK+l67MudmyBRi03HKuCHrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuqEbL0vxSPnDDvIc83dhC/hc3yuTiyXhZrdXYZCFT3iap9K+BneVDDK2Astg+/lQ
	 a+IlpPJaVAVO429MUGy7QOtvJA7YBNXlDpkYXUNUPj7dfPd8KMqAuh/h4uxDq3GMrm
	 4KbTfcxjOo9Q6MkVG0mHDtI7ybvgLD8nb1RZ/DfEUZ45Eb5ATOtudd8a3InG48FtPv
	 MbxTA1CJfB66G7G8R9NfTtxvFpUMGpZww543vNVwgus+Zh8H/fnVOzKE0UsKjSRCPD
	 o9jKu3Shj6+UsNokERXBLF4U/r6RoJi7aS+LXuLkg/xWqvhTpZixomcpsmnz0f7+Kt
	 ZEHU9xmcS2zQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd63-00000004IaV-0p3G;
	Wed, 20 May 2026 09:20:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 05/18] KVM: arm64: vgic: Constify struct irq_ops usage
Date: Wed, 20 May 2026 10:19:36 +0100
Message-ID: <20260520091949.542365-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

vgic-v5 has introduced much more prevalent usage of the struct
irq_ops mechanism.

In the process, it becomes evident that suffers from two related
problems:

- it contains flags, rather than only callbacks
- it is mutable, because we need to update the above flags

Swap the flags for a helper retrieving the flags, and make all
irq_ops const, something that is slightly satisfying.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c   | 14 +++++++++-----
 arch/arm64/kvm/vgic/vgic-v5.c |  2 +-
 arch/arm64/kvm/vgic/vgic.c    |  2 +-
 include/kvm/arm_vgic.h        |  9 +++++----
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index cbea4d9ee9552..f003df76fdda7 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -52,11 +52,17 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timer_regs treg);
 static bool kvm_arch_timer_get_input_level(int vintid);
 
-static struct irq_ops arch_timer_irq_ops = {
+static unsigned long kvm_arch_timer_get_irq_flags(void)
+{
+	return kvm_vgic_global_state.no_hw_deactivation ? VGIC_IRQ_SW_RESAMPLE : 0;
+}
+
+static const struct irq_ops arch_timer_irq_ops = {
+	.get_flags	 = kvm_arch_timer_get_irq_flags,
 	.get_input_level = kvm_arch_timer_get_input_level,
 };
 
-static struct irq_ops arch_timer_irq_ops_vgic_v5 = {
+static const struct irq_ops arch_timer_irq_ops_vgic_v5 = {
 	.get_input_level = kvm_arch_timer_get_input_level,
 	.queue_irq_unlock = vgic_v5_ppi_queue_irq_unlock,
 	.set_direct_injection = vgic_v5_set_ppi_dvi,
@@ -1392,8 +1398,6 @@ static int kvm_irq_init(struct arch_timer_kvm_info *info)
 			return -ENOMEM;
 		}
 
-		if (kvm_vgic_global_state.no_hw_deactivation)
-			arch_timer_irq_ops.flags |= VGIC_IRQ_SW_RESAMPLE;
 		WARN_ON(irq_domain_push_irq(domain, host_vtimer_irq,
 					    (void *)TIMER_VTIMER));
 	}
@@ -1591,8 +1595,8 @@ static bool kvm_arch_timer_get_input_level(int vintid)
 int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
+	const struct irq_ops *ops;
 	struct timer_map map;
-	struct irq_ops *ops;
 	int ret;
 
 	if (timer->enabled)
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 0101ec3f55283..757484d2493b2 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -285,7 +285,7 @@ void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool dvi)
 	__assign_bit(ppi, cpu_if->vgic_ppi_dvir, dvi);
 }
 
-static struct irq_ops vgic_v5_ppi_irq_ops = {
+static const struct irq_ops vgic_v5_ppi_irq_ops = {
 	.queue_irq_unlock = vgic_v5_ppi_queue_irq_unlock,
 	.set_direct_injection = vgic_v5_set_ppi_dvi,
 };
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1e9fe8764584d..3ac6d49bc4876 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -573,7 +573,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 }
 
 void kvm_vgic_set_irq_ops(struct kvm_vcpu *vcpu, u32 vintid,
-			  struct irq_ops *ops)
+			  const struct irq_ops *ops)
 {
 	struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, vintid);
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ea793479ab254..fe49fb56dc3c9 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -205,7 +205,7 @@ struct vgic_irq;
  */
 struct irq_ops {
 	/* Per interrupt flags for special-cased interrupts */
-	unsigned long flags;
+	unsigned long (*get_flags)(void);
 
 #define VGIC_IRQ_SW_RESAMPLE	BIT(0)	/* Clear the active state for resampling */
 
@@ -271,7 +271,7 @@ struct vgic_irq {
 	u8 priority;
 	u8 group;			/* 0 == group 0, 1 == group 1 */
 
-	struct irq_ops *ops;
+	const struct irq_ops *ops;
 
 	void *owner;			/* Opaque pointer to reserve an interrupt
 					   for in-kernel devices. */
@@ -279,7 +279,8 @@ struct vgic_irq {
 
 static inline bool vgic_irq_needs_resampling(struct vgic_irq *irq)
 {
-	return irq->ops && (irq->ops->flags & VGIC_IRQ_SW_RESAMPLE);
+	return irq->ops && irq->ops->get_flags &&
+	       (irq->ops->get_flags() & VGIC_IRQ_SW_RESAMPLE);
 }
 
 struct vgic_register_region;
@@ -557,7 +558,7 @@ void kvm_vgic_init_cpu_hardware(void);
 int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			unsigned int intid, bool level, void *owner);
 void kvm_vgic_set_irq_ops(struct kvm_vcpu *vcpu, u32 vintid,
-			  struct irq_ops *ops);
+			  const struct irq_ops *ops);
 void kvm_vgic_clear_irq_ops(struct kvm_vcpu *vcpu, u32 vintid);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 			  u32 vintid);
-- 
2.47.3

