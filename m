Return-Path: <SRS0=gg7X=XS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91521C4CECF
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:26:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5309920B7C
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5309920B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 005C24A658;
	Mon, 23 Sep 2019 14:26:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wTa9qxx6UCIs; Mon, 23 Sep 2019 14:26:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 893C54A610;
	Mon, 23 Sep 2019 14:26:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2B5B4A555
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:26:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cSXKGBaAlTLZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Sep 2019 14:26:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4438D4A60F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:26:33 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F03C21576;
 Mon, 23 Sep 2019 11:26:32 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD4443F694;
 Mon, 23 Sep 2019 11:26:28 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/35] KVM: arm64: vgic-v4: Move the GICv4 residency flow to
 be driven by vcpu_load/put
Date: Mon, 23 Sep 2019 19:25:32 +0100
Message-Id: <20190923182606.32100-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190923182606.32100-1-maz@kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
MIME-Version: 1.0
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

When the VHE code was reworked, a lot of the vgic stuff was moved around,
but the GICv4 residency code did stay untouched, meaning that we come
in and out of residency on each flush/sync, which is obviously suboptimal.

To address this, let's move things around a bit:

- Residency entry (flush) moves to vcpu_load
- Residency exit (sync) moves to vcpu_put
- On blocking (entry to WFI), we "put"
- On unblocking (exit from WFI, we "load"

Because these can nest (load/block/put/load/unblock/put, for example),
we now have per-VPE tracking of the residency state.

Additionally, vgic_v4_put gains a "need doorbell" parameter, which only
gets set to true when blocking because of a WFI. This allows a finer
control of the doorbell, which now also gets disabled as soon as
it gets signaled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v4.c       |  7 +++-
 include/kvm/arm_vgic.h             |  4 +--
 include/linux/irqchip/arm-gic-v4.h |  2 ++
 virt/kvm/arm/arm.c                 | 12 ++++---
 virt/kvm/arm/vgic/vgic-v3.c        |  4 +++
 virt/kvm/arm/vgic/vgic-v4.c        | 55 ++++++++++++++----------------
 virt/kvm/arm/vgic/vgic.c           |  4 ---
 virt/kvm/arm/vgic/vgic.h           |  2 --
 8 files changed, 48 insertions(+), 42 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 563e87ed0766..45969927cc81 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -141,12 +141,17 @@ static int its_send_vpe_cmd(struct its_vpe *vpe, struct its_cmd_info *info)
 int its_schedule_vpe(struct its_vpe *vpe, bool on)
 {
 	struct its_cmd_info info;
+	int ret;
 
 	WARN_ON(preemptible());
 
 	info.cmd_type = on ? SCHEDULE_VPE : DESCHEDULE_VPE;
 
-	return its_send_vpe_cmd(vpe, &info);
+	ret = its_send_vpe_cmd(vpe, &info);
+	if (!ret)
+		vpe->resident = on;
+
+	return ret;
 }
 
 int its_invall_vpe(struct its_vpe *vpe)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index af4f09c02bf1..4dc58d7a0010 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -396,7 +396,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
 int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
 				 struct kvm_kernel_irq_routing_entry *irq_entry);
 
-void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu);
-void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu);
+int vgic_v4_load(struct kvm_vcpu *vcpu);
+int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
 
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index e6b155713b47..ab1396afe08a 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -35,6 +35,8 @@ struct its_vpe {
 	/* Doorbell interrupt */
 	int			irq;
 	irq_hw_number_t		vpe_db_lpi;
+	/* VPE resident */
+	bool			resident;
 	/* VPE proxy mapping */
 	int			vpe_proxy_event;
 	/*
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86c6aa1cb58e..bd2afcf9a13f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -322,20 +322,24 @@ void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 	/*
 	 * If we're about to block (most likely because we've just hit a
 	 * WFI), we need to sync back the state of the GIC CPU interface
-	 * so that we have the lastest PMR and group enables. This ensures
+	 * so that we have the latest PMR and group enables. This ensures
 	 * that kvm_arch_vcpu_runnable has up-to-date data to decide
 	 * whether we have pending interrupts.
+	 *
+	 * For the same reason, we want to tell GICv4 that we need
+	 * doorbells to be signalled, should an interrupt become pending.
 	 */
 	preempt_disable();
 	kvm_vgic_vmcr_sync(vcpu);
+	vgic_v4_put(vcpu, true);
 	preempt_enable();
-
-	kvm_vgic_v4_enable_doorbell(vcpu);
 }
 
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
-	kvm_vgic_v4_disable_doorbell(vcpu);
+	preempt_disable();
+	vgic_v4_load(vcpu);
+	preempt_enable();
 }
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 8d69f007dd0c..48307a9eb1d8 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -664,6 +664,8 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 
 	if (has_vhe())
 		__vgic_v3_activate_traps(vcpu);
+
+	WARN_ON(vgic_v4_load(vcpu));
 }
 
 void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
@@ -676,6 +678,8 @@ void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
 
 void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
+	WARN_ON(vgic_v4_put(vcpu, false));
+
 	vgic_v3_vmcr_sync(vcpu);
 
 	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 477af6aebb97..7e1f3202968a 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -85,6 +85,10 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
 {
 	struct kvm_vcpu *vcpu = info;
 
+	/* We got the message, no need to fire again */
+	if (!irqd_irq_disabled(&irq_to_desc(irq)->irq_data))
+		disable_irq_nosync(irq);
+
 	vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
 	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 	kvm_vcpu_kick(vcpu);
@@ -192,20 +196,30 @@ void vgic_v4_teardown(struct kvm *kvm)
 	its_vm->vpes = NULL;
 }
 
-int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu)
+int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db)
 {
-	if (!vgic_supports_direct_msis(vcpu->kvm))
+	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
+	struct irq_desc *desc = irq_to_desc(vpe->irq);
+
+	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
 		return 0;
 
-	return its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, false);
+	/*
+	 * If blocking, a doorbell is required. Undo the nested
+	 * disable_irq() calls...
+	 */
+	while (need_db && irqd_irq_disabled(&desc->irq_data))
+		enable_irq(vpe->irq);
+
+	return its_schedule_vpe(vpe, false);
 }
 
-int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
+int vgic_v4_load(struct kvm_vcpu *vcpu)
 {
-	int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
+	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
 	int err;
 
-	if (!vgic_supports_direct_msis(vcpu->kvm))
+	if (!vgic_supports_direct_msis(vcpu->kvm) || vpe->resident)
 		return 0;
 
 	/*
@@ -214,11 +228,14 @@ int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * doc in drivers/irqchip/irq-gic-v4.c to understand how this
 	 * turns into a VMOVP command at the ITS level.
 	 */
-	err = irq_set_affinity(irq, cpumask_of(smp_processor_id()));
+	err = irq_set_affinity(vpe->irq, cpumask_of(smp_processor_id()));
 	if (err)
 		return err;
 
-	err = its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, true);
+	/* Disabled the doorbell, as we're about to enter the guest */
+	disable_irq_nosync(vpe->irq);
+
+	err = its_schedule_vpe(vpe, true);
 	if (err)
 		return err;
 
@@ -226,9 +243,7 @@ int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * Now that the VPE is resident, let's get rid of a potential
 	 * doorbell interrupt that would still be pending.
 	 */
-	err = irq_set_irqchip_state(irq, IRQCHIP_STATE_PENDING, false);
-
-	return err;
+	return irq_set_irqchip_state(vpe->irq, IRQCHIP_STATE_PENDING, false);
 }
 
 static struct vgic_its *vgic_get_its(struct kvm *kvm,
@@ -335,21 +350,3 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
 	mutex_unlock(&its->its_lock);
 	return ret;
 }
-
-void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu)
-{
-	if (vgic_supports_direct_msis(vcpu->kvm)) {
-		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
-		if (irq)
-			enable_irq(irq);
-	}
-}
-
-void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu)
-{
-	if (vgic_supports_direct_msis(vcpu->kvm)) {
-		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
-		if (irq)
-			disable_irq(irq);
-	}
-}
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 45a870cb63f5..99b02ca730a8 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -857,8 +857,6 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
-	WARN_ON(vgic_v4_sync_hwstate(vcpu));
-
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
@@ -882,8 +880,6 @@ static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 /* Flush our emulation state into the GIC hardware before entering the guest. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
-	WARN_ON(vgic_v4_flush_hwstate(vcpu));
-
 	/*
 	 * If there are no virtual interrupts active or pending for this
 	 * VCPU, then there is no work to do and we can bail out without
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 83066a81b16a..c7fefd6b1c80 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -316,7 +316,5 @@ void vgic_its_invalidate_cache(struct kvm *kvm);
 bool vgic_supports_direct_msis(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
-int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu);
-int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
