Return-Path: <SRS0=V360=D6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A60C55179
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 16:51:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 769FB2465D
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 16:51:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 769FB2465D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8439C4B6DC;
	Fri, 23 Oct 2020 12:51:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i09QpNJSYkNU; Fri, 23 Oct 2020 12:51:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F00CA4B5E3;
	Fri, 23 Oct 2020 12:51:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 845FE4B628
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2020 12:51:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hlMmd9G-ca-A for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2020 12:51:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE6184B275
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2020 12:51:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29DBE113E;
 Fri, 23 Oct 2020 09:51:26 -0700 (PDT)
Received: from eglon.eretz (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F3913F719;
 Fri, 23 Oct 2020 09:51:25 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH] KVM: arm64: vgic: Allow an injected IRQ to be taken
 synchronously by the vcpu
Date: Fri, 23 Oct 2020 17:51:08 +0100
Message-Id: <20201023165108.15061-1-james.morse@arm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: maz@kernel.org
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

Paravirtualised features like 'asynchronous page fault' want to be able to
tell a guest that a page of memory isn't available right now, could
it try again a bit later?

No hardware does this, so it doesn't map nicely onto any existing
notification method. The notification needs to be synchronous and therefore
per-cpu. We can't invent a new type exception type,

Using a PPI, would depend on the CPU implementation prioritising
virtual IRQs higher than synchronous stage2 faults. D1.13.4 "Prioritization
and recognition of interrupts" of DDI0487F.a has a note:
| If the first instruction after the context synchronizing event generates
| a synchronous exception, then the architecture does not define whether the
| PE takes the interrupt or the synchronous exception first.

Here the synchronous exception would be 'the stage2 fault for a second
time', meaning a pending IRQ is not guaranteed to be taken.

As we can't rely on the hardware to do this for us, do it in software:
Add a kvm_vgic_inject_taken_irq() helper that injects an IRQ only if
it can also emulate the exception for the provided vcpu.

The IRQ should be a PPI, and the intid should be provided by the VMM.

The caller should have some alternative behaviour if the call fails.
It should also be prepared for the PPI to be delivered (and emulated
as taken), but ignored by the guest if it services a higher priority
interrupt instead. (these may become pending after this call completes).

If kvm_vgic_inject_taken_irq() is called in response to a synchronous
exception, the caller should be able to detect the same synchronous
exception being taken a second time.

This should probably be shared between paravirt services (some kind of
maintenance interrupt), if so the vgic_validate_injection() check shouldn't
reject already-pending level-sensitive IRQ. It should be possible for
user-space to do this for its own paravirt services too (using set_one_reg)
for the same PPI.

irqfd isn't tied to a vcpu, so isn't suitable for a PPI.

This patch is a little simpler than having an in-kernel SDEI dispatcher,
and has no additional state that would need migrating.

RFC - I haven't tested this. My question is why can't we do it?

CC: Gavin Shan <gshan@redhat.com>
NAK-bait-for: Marc Zyngier <maz@kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/inject_fault.c        | 16 ++++++
 arch/arm64/kvm/vgic/vgic.c           | 85 ++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h               |  2 +
 4 files changed, 104 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 49a55be2b9a2..cab9f1436f68 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -28,6 +28,7 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v);
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr);
 
+void kvm_inject_irq(struct kvm_vcpu *vcpu);
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index ebfdfc27b2bd..6ff462c83eb6 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -214,6 +214,22 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 		inject_undef64(vcpu);
 }
 
+
+/**
+ * kvm_inject_irq - inject an irq exception into a 64bit guest
+ *
+ * It is assumed that this code is called from the VCPU thread and that the
+ * VCPU therefore is not currently executing guest code.
+ *
+ * This only injects the irq exception to the VCPU. The guest irqchip must be
+ * updated separately.
+ */
+void kvm_inject_irq(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_el1_is_32bit(vcpu))
+		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_irq);
+}
+
 void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 esr)
 {
 	vcpu_set_vsesr(vcpu, esr & ESR_ELx_ISS_MASK);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index c3643b7f101b..ba52c72e9a24 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -10,6 +10,7 @@
 #include <linux/list_sort.h>
 #include <linux/nospec.h>
 
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
 #include "vgic.h"
@@ -476,6 +477,90 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 	return 0;
 }
 
+/**
+ * kvm_vgic_inject_taken_ppi - Inject a PPI only if the exception can be forced
+ *			       to be taken immediately by a 64bit guest.
+ * @vcpu:    The vcpu that should take the PPI.
+ * @intid:   The INTID to inject a new state to.
+ * @level:   Edge-triggered:  true:  to trigger the interrupt
+ *			      false: to ignore the call
+ *	     Level-sensitive  true:  raise the input signal
+ *			      false: lower the input signal
+ * @owner:   The opaque pointer to the owner of the IRQ being raised to verify
+ *           that the caller is allowed to inject this IRQ.  Userspace
+ *           injections will have owner == NULL.
+ *
+ * Inject a PPI only if @vcpu could take it immediately, and emulate the irq
+ * exception to force that to happen. The @vcpu must have PSTATE.I clear, have
+ * enable the PPI, and not masked it via PMR. The PPI may not be in the LRs on
+ * the next entry to the guest if higher prioirity interrupts are pending.  A
+ * subsequent higher priority IRQ may become pending after this call, and be
+ * serviced instead by the guest.
+ *
+ * This allows a paravirualised notification via PPI to be taken synchronously
+ * by the guest.
+ *
+ * It is assumed that this code is called from the VCPU thread and that the
+ * VCPU therefore is not currently executing guest code.
+ *
+ * See kvm_vgic_inject_irq() for notes about @level.
+ *
+ * Returns 0 for success, or -EBUSY if the PPI would not be taken.
+ */
+int kvm_vgic_inject_taken_irq(struct kvm_vcpu *vcpu, unsigned int intid,
+			      bool level, void *owner)
+{
+	bool priority_masked, vcpu_irq_masked;
+	struct kvm *kvm = vcpu->kvm;
+	struct vgic_vmcr vmcr;
+	struct vgic_irq *irq;
+	unsigned long flags;
+	int ret;
+
+	trace_vgic_update_irq_pending(vcpu->cpu, intid, level);
+
+	ret = vgic_lazy_init(kvm);
+	if (ret)
+		return ret;
+
+	if (vcpu_el1_is_32bit(vcpu))
+		return -EOPNOTSUPP;
+
+	if (!irq_is_ppi(intid))
+		return -EINVAL;
+
+	irq = vgic_get_irq(kvm, vcpu, intid);
+	if (!irq)
+		return -EINVAL;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+	priority_masked = (irq->priority >= vmcr.pmr);
+	vcpu_irq_masked = (*vcpu_cpsr(vcpu) & PSR_I_BIT);
+
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+	if (!irq->enabled || priority_masked || vcpu_irq_masked ||
+	    !vgic_validate_injection(irq, level, owner)) {
+		/* not going to be taken as a new exception */
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		vgic_put_irq(kvm, irq);
+		return -EBUSY;
+	}
+
+	if (irq->config == VGIC_CONFIG_LEVEL)
+		irq->line_level = level;
+	else
+		irq->pending_latch = true;
+
+	vgic_queue_irq_unlock(kvm, irq, flags);
+	vgic_put_irq(kvm, irq);
+
+	kvm_inject_irq(vcpu);
+
+	return 0;
+}
+
+
 /* @irq->irq_lock must be held */
 static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 			    unsigned int host_irq,
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a8d8fdcd3723..76d147de5489 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -350,6 +350,8 @@ void kvm_vgic_init_cpu_hardware(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level, void *owner);
+int kvm_vgic_inject_taken_irq(struct kvm_vcpu *vcpu, unsigned int intid,
+			      bool level, void *owner);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 			  u32 vintid, bool (*get_input_level)(int vindid));
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
