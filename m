Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F970C4332D
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 18:51:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4FB920784
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 18:51:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="13EpXDmm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4FB920784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F3CB4A5A0;
	Fri, 20 Mar 2020 14:51:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FFDU+afQkTb5; Fri, 20 Mar 2020 14:51:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28AFD4B0BF;
	Fri, 20 Mar 2020 14:51:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3C0F4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 14:51:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gE-lCVWJfhBL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 14:51:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 826354B0A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 14:51:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B37A820775;
 Fri, 20 Mar 2020 18:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584730271;
 bh=zdyx+soSZeTAP2ojZnJTUsLxFVcyFu3o9E/v/FnMtCI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=13EpXDmmVrqF7ecGFnxqZPUN5HsT6yQRTRCVdwW2AXnteDUl5azw7CJingV+m643H
 4MktcPEAf5HL+ohwzIlM8uZEM74Z+DGxJXM4G8TwACDKv6zVSsxaFA5j0syket0g3o
 2HL1+sZQZKybEbge6O5je2i1wH8q5yfOPOtOaXGg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jFMK7-00EKAx-QG; Fri, 20 Mar 2020 18:24:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 18/23] KVM: arm64: GICv4.1: Add direct injection capability
 to SGI registers
Date: Fri, 20 Mar 2020 18:24:01 +0000
Message-Id: <20200320182406.23465-19-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200320182406.23465-1-maz@kernel.org>
References: <20200320182406.23465-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
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

Most of the GICv3 emulation code that deals with SGIs now has to be
aware of the v4.1 capabilities in order to benefit from it.

Add such support, keyed on the interrupt having the hw flag set and
being a SGI.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20200304203330.4967-19-maz@kernel.org
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 27 ++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 88 ++++++++++++++++++++++++++++++--
 2 files changed, 107 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index ebc218840fc2..f4da9d1a6bff 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -6,6 +6,7 @@
 #include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/interrupt.h>
 #include <kvm/iodev.h>
 #include <kvm/arm_vgic.h>
 
@@ -257,8 +258,18 @@ static unsigned long vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
 	 */
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		bool state = irq->pending_latch;
 
-		if (irq->pending_latch)
+		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+			int err;
+
+			err = irq_get_irqchip_state(irq->host_irq,
+						    IRQCHIP_STATE_PENDING,
+						    &state);
+			WARN_ON(err);
+		}
+
+		if (state)
 			value |= (1U << i);
 
 		vgic_put_irq(vcpu->kvm, irq);
@@ -942,8 +953,18 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
 		 * generate interrupts of either group.
 		 */
 		if (!irq->group || allow_group1) {
-			irq->pending_latch = true;
-			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+			if (!irq->hw) {
+				irq->pending_latch = true;
+				vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+			} else {
+				/* HW SGI? Ask the GIC to inject it */
+				int err;
+				err = irq_set_irqchip_state(irq->host_irq,
+							    IRQCHIP_STATE_PENDING,
+							    true);
+				WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
+				raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			}
 		} else {
 			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		}
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 97fb2a40e6ba..2199302597fa 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -5,6 +5,8 @@
 
 #include <linux/bitops.h>
 #include <linux/bsearch.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <kvm/iodev.h>
@@ -59,6 +61,11 @@ unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+static void vgic_update_vsgi(struct vgic_irq *irq)
+{
+	WARN_ON(its_prop_update_vsgi(irq->host_irq, irq->priority, irq->group));
+}
+
 void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
 			   unsigned int len, unsigned long val)
 {
@@ -71,7 +78,12 @@ void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->group = !!(val & BIT(i));
-		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+			vgic_update_vsgi(irq);
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		} else {
+			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+		}
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -113,7 +125,21 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-		if (vgic_irq_is_mapped_level(irq)) {
+		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+			if (!irq->enabled) {
+				struct irq_data *data;
+
+				irq->enabled = true;
+				data = &irq_to_desc(irq->host_irq)->irq_data;
+				while (irqd_irq_disabled(data))
+					enable_irq(irq->host_irq);
+			}
+
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			vgic_put_irq(vcpu->kvm, irq);
+
+			continue;
+		} else if (vgic_irq_is_mapped_level(irq)) {
 			bool was_high = irq->line_level;
 
 			/*
@@ -148,6 +174,8 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		if (irq->hw && vgic_irq_is_sgi(irq->intid) && irq->enabled)
+			disable_irq_nosync(irq->host_irq);
 
 		irq->enabled = false;
 
@@ -167,10 +195,22 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 		unsigned long flags;
+		bool val;
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-		if (irq_is_pending(irq))
-			value |= (1U << i);
+		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+			int err;
+
+			val = false;
+			err = irq_get_irqchip_state(irq->host_irq,
+						    IRQCHIP_STATE_PENDING,
+						    &val);
+			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
+		} else {
+			val = irq_is_pending(irq);
+		}
+
+		value |= ((u32)val << i);
 		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);
@@ -215,6 +255,21 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 		}
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+			/* HW SGI? Ask the GIC to inject it */
+			int err;
+			err = irq_set_irqchip_state(irq->host_irq,
+						    IRQCHIP_STATE_PENDING,
+						    true);
+			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
+
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			vgic_put_irq(vcpu->kvm, irq);
+
+			continue;
+		}
+
 		if (irq->hw)
 			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
 		else
@@ -269,6 +324,20 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
+		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+			/* HW SGI? Ask the GIC to clear its pending bit */
+			int err;
+			err = irq_set_irqchip_state(irq->host_irq,
+						    IRQCHIP_STATE_PENDING,
+						    false);
+			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
+
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			vgic_put_irq(vcpu->kvm, irq);
+
+			continue;
+		}
+
 		if (irq->hw)
 			vgic_hw_irq_cpending(vcpu, irq, is_uaccess);
 		else
@@ -318,8 +387,15 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
-	if (irq->hw) {
+	if (irq->hw && !vgic_irq_is_sgi(irq->intid)) {
 		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
+	} else if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+		/*
+		 * GICv4.1 VSGI feature doesn't track an active state,
+		 * so let's not kid ourselves, there is nothing we can
+		 * do here.
+		 */
+		irq->active = false;
 	} else {
 		u32 model = vcpu->kvm->arch.vgic.vgic_model;
 		u8 active_source;
@@ -493,6 +569,8 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		/* Narrow the priority range to what we actually support */
 		irq->priority = (val >> (i * 8)) & GENMASK(7, 8 - VGIC_PRI_BITS);
+		if (irq->hw && vgic_irq_is_sgi(irq->intid))
+			vgic_update_vsgi(irq);
 		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
