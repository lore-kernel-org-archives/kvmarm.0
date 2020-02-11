Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B94C3B187
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:52:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9B4720848
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayEM2m4Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9B4720848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B5C4ACE9;
	Tue, 11 Feb 2020 12:52:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nu2C1Pm1DaKK; Tue, 11 Feb 2020 12:52:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0632E4AE9E;
	Tue, 11 Feb 2020 12:52:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCFEF4AEE3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:52:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jg9tMRko-2pQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 12:52:02 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 278104AEB9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:52:01 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5B08A206D7;
 Tue, 11 Feb 2020 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581443520;
 bh=IPlG3pg4CO1MgYK1b39GRc1ZDWAa8g8OanDrvwP2yV4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ayEM2m4QxvREt/HdGPA4aUx9hHxBnfxlskN/4mrUPGbNaZ8ySX+BuGmc+GBonImUs
 Sz6C2mwdVMOOvCu60HWJPST4ChozpLrzGKI4hlghNTt+qZ8ppk4owfa0Sg+Qu357OF
 kHume/zfnpXlEyjb4f6jWOJx6t4L0HOgdaKLLZgA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j1Zg1-004O7k-Qr; Tue, 11 Feb 2020 17:50:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 55/94] KVM: arm64: nv: Implement maintenance interrupt
 forwarding
Date: Tue, 11 Feb 2020 17:48:59 +0000
Message-Id: <20200211174938.27809-56-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

When we take a maintenance interrupt, we need to decide whether
it is generated on an action from the guest, or if it is something
that needs to be forwarded to the guest hypervisor.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-init.c      | 30 ++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3-nested.c | 25 +++++++++++++++++++++----
 2 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index a963b9d766b7..191b284e7bee 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -6,10 +6,12 @@
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
+#include <linux/irq.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include "vgic.h"
 
 /*
@@ -221,6 +223,16 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return 0;
 
+	if (nested_virt_in_use(vcpu)) {
+		/* FIXME: remove this hack */
+		if (vcpu->kvm->arch.vgic.maint_irq == 0)
+			vcpu->kvm->arch.vgic.maint_irq = kvm_vgic_global_state.maint_irq;
+		ret = kvm_vgic_set_owner(vcpu, vcpu->kvm->arch.vgic.maint_irq,
+					 vcpu);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * If we are creating a VCPU with a GICv3 we must also register the
 	 * KVM io device for the redistributor that belongs to this VCPU.
@@ -449,12 +461,23 @@ static int vgic_init_cpu_dying(unsigned int cpu)
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 {
+	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)data;
+
 	/*
 	 * We cannot rely on the vgic maintenance interrupt to be
 	 * delivered synchronously. This means we can only use it to
 	 * exit the VM, and we perform the handling of EOIed
 	 * interrupts on the exit path (see vgic_fold_lr_state).
 	 */
+
+	/* If not nested, deactivate */
+	if (!vcpu || !vgic_state_is_nested(vcpu)) {
+		irq_set_irqchip_state(irq, IRQCHIP_STATE_ACTIVE, false);
+		return IRQ_HANDLED;
+	}
+
+	/* Assume nested from now */
+	vgic_v3_handle_nested_maint_irq(vcpu);
 	return IRQ_HANDLED;
 }
 
@@ -525,6 +548,13 @@ int kvm_vgic_hyp_init(void)
 		return ret;
 	}
 
+	ret = irq_set_vcpu_affinity(kvm_vgic_global_state.maint_irq,
+				    kvm_get_running_vcpus());
+	if (ret) {
+		kvm_err("Error setting vcpu affinity\n");
+		goto out_free_irq;
+	}
+
 	ret = cpuhp_setup_state(CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
 				"kvm/arm/vgic:starting",
 				vgic_init_cpu_starting, vgic_init_cpu_dying);
diff --git a/virt/kvm/arm/vgic/vgic-v3-nested.c b/virt/kvm/arm/vgic/vgic-v3-nested.c
index 3ee3438b5e22..4ba426e2324d 100644
--- a/virt/kvm/arm/vgic/vgic-v3-nested.c
+++ b/virt/kvm/arm/vgic/vgic-v3-nested.c
@@ -173,10 +173,20 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_irq *irq;
+	unsigned long flags;
 
 	vgic_cpu->shadow_vgic_v3 = vgic_cpu->nested_vgic_v3;
 	vgic_v3_create_shadow_lr(vcpu);
 	__vgic_v3_restore_state(vcpu_shadow_if(vcpu));
+
+	irq = vgic_get_irq(vcpu->kvm, vcpu, vcpu->kvm->arch.vgic.maint_irq);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	if (irq->line_level || irq->active)
+		irq_set_irqchip_state(kvm_vgic_global_state.maint_irq,
+				      IRQCHIP_STATE_ACTIVE, true);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	vgic_put_irq(vcpu->kvm, irq);
 }
 
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
@@ -191,11 +201,14 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	 */
 	vgic_v3_fixup_shadow_lr_state(vcpu);
 	vgic_cpu->nested_vgic_v3 = vgic_cpu->shadow_vgic_v3;
+	irq_set_irqchip_state(kvm_vgic_global_state.maint_irq,
+			      IRQCHIP_STATE_ACTIVE, false);
 }
 
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+	bool state;
 
 	/*
 	 * If we exit a nested VM with a pending maintenance interrupt from the
@@ -203,8 +216,12 @@ void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 	 * can re-sync the appropriate LRs and sample level triggered interrupts
 	 * again.
 	 */
-	if (vgic_state_is_nested(vcpu) &&
-	    (cpu_if->vgic_hcr & ICH_HCR_EN) &&
-	    vgic_v3_get_misr(vcpu))
-		kvm_inject_nested_irq(vcpu);
+	if (!vgic_state_is_nested(vcpu))
+		return;
+
+	state  = cpu_if->vgic_hcr & ICH_HCR_EN;
+	state &= vgic_v3_get_misr(vcpu);
+
+	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
+			    vcpu->kvm->arch.vgic.maint_irq, state, vcpu);
 }
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
