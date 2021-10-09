Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 513BAC433FE
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EB4D261058
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EB4D261058
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A27414B199;
	Fri,  8 Oct 2021 22:13:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EecwdOaZITiI; Fri,  8 Oct 2021 22:13:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44D3E4B168;
	Fri,  8 Oct 2021 22:13:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 584A24B099
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l-5F44XVjJRu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:53 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9D954B10C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:53 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 v70-20020a256149000000b005ba4d61ea0fso11140666ybb.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=5hpfBC6gWJkcOHt8YZBUrb02DaMNx5G2Fc+yXQaHUUY=;
 b=cEs+bgUeHMfI9uYlefh+iM2eRk3qPNVNbClvTmSKATAjUcroJxnsqJTWE5Qtyo9x4v
 MpdS/l8srF5XPxDJ3EvhMlxilUTs61ARdj9loqjhbHYZBmsenWUN8LtEDMCkMEaJvaMZ
 uOPcsFbAYqpQzCzAhduWriMhEMy9t0Z/V/MpMa4yPaPAqDM0ghdjCg9Xr7vQGjn4mQJV
 SFq46C1ENeOYMY/1H214g+SRJaGFL0taFNxQ6pcBHLxLCE9j0WGzk72+VlbrdQzjPG98
 S+0DuRiz94AOrzl+SivEGlCiXnW4CXIZo8xSX28/t54M/8XqZGhXfR3Nvwp8qqXg0lj0
 U+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=5hpfBC6gWJkcOHt8YZBUrb02DaMNx5G2Fc+yXQaHUUY=;
 b=PbBCiuU82VzSD6+fPHoR51z1/PnIxjMIIkB9AxilwfzO0bZuNDAd0z7In13zkTm0Tc
 jntdW/Jz3qjuIKta2Kwk2rvg0w0epA+plnMMLuJ1TBhRGytA/RSFstMShhBk96CwzIFh
 JoPQPpAjYWUbug8r5cGkqXdujOacUioQOC6BCGCCg7EgQelmVeRbgWf8yOGb5LQ/S4jQ
 BGVcHRaSSIshfnAXgQXD60UEqMHy0fBdSCdZIOCNt9AGgiWhjxwIs3OKD7bVkjp0eWRQ
 V3tqPmUafNWsEw8IjKMcRt6oiU6L+JvN2dq4jEtRhqsN8U9xahfOZJeuBLrDO1GO9EkH
 uLhA==
X-Gm-Message-State: AOAM531i/Q4r9Mt1xj9y21Wc/1mcnwQrv/+8ZtfNLmFE975ACQuu3Y0n
 9b4d7auPEUFzHySqhgngAffg7PJ1kZk=
X-Google-Smtp-Source: ABdhPJwkik0bV42yZ1/3W+y9UTCGHOxB4SFxrkoP6Q1joha5k6CqIsTRCA51206vu2uI7yIvAoLBFznrZmQ=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:1c08:: with SMTP id
 c8mr7646986ybc.316.1633745633346; 
 Fri, 08 Oct 2021 19:13:53 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:22 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-30-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 29/43] KVM: VMX: Handle PI wakeup shenanigans during
 vcpu_put/load
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Move the posted interrupt pre/post_block logic into vcpu_put/load
respectively, using the kvm_vcpu_is_blocking() to determining whether or
not the wakeup handler needs to be set (and unset).  This avoids updating
the PI descriptor if halt-polling is successful, reduces the number of
touchpoints for updating the descriptor, and eliminates the confusing
behavior of intentionally leaving a "stale" PI.NDST when a blocking vCPU
is scheduled back in after preemption.

The downside is that KVM will do the PID update twice if the vCPU is
preempted after prepare_to_rcuwait() but before schedule(), but that's a
rare case (and non-existent on !PREEMPT kernels).

The notable wart is the need to send a self-IPI on the wakeup vector if
an outstanding notification is pending after configuring the wakeup
vector.  Ideally, KVM would just do a kvm_vcpu_wake_up() in this case,
but the scheduler doesn't support waking a task from its preemption
notifier callback, i.e. while the task is smack dab in the middle of
being scheduled out.

Note, setting the wakeup vector before halt-polling is not necessary as
the pending IRQ will be recorded in the PIR and detected as a blocking-
breaking condition by kvm_vcpu_has_events() -> vmx_sync_pir_to_irr().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 162 ++++++++++++++-------------------
 arch/x86/kvm/vmx/posted_intr.h |   8 +-
 arch/x86/kvm/vmx/vmx.c         |   5 -
 3 files changed, 75 insertions(+), 100 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 901b7a5f7777..d2b3d75c57d1 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -37,33 +37,45 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 	struct pi_desc old, new;
+	unsigned long flags;
 	unsigned int dest;
 
 	/*
-	 * To simplify hot-plug and dynamic toggling of APICv, keep PI.NDST and
-	 * PI.SN up-to-date even if there is no assigned device or if APICv is
+	 * To simplify hot-plug and dynamic toggling of APICv, keep PI.NDST
+	 * up-to-date even if there is no assigned device or if APICv is
 	 * deactivated due to a dynamic inhibit bit, e.g. for Hyper-V's SyncIC.
 	 */
 	if (!enable_apicv || !lapic_in_kernel(vcpu))
 		return;
 
-	/* Nothing to do if PI.SN==0 and the vCPU isn't being migrated. */
-	if (!pi_test_sn(pi_desc) && vcpu->cpu == cpu)
+	/*
+	 * If the vCPU wasn't on the wakeup list and wasn't migrated, then the
+	 * full update can be skipped as neither the vector nor the destination
+	 * needs to be changed.
+	 */
+	if (pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR && vcpu->cpu == cpu) {
+		/*
+		 * Clear SN if it was set due to being preempted.  Again, do
+		 * this even if there is no assigned device for simplicity.
+		 */
+		if (pi_test_and_clear_sn(pi_desc))
+			goto after_clear_sn;
 		return;
+	}
+
+	local_irq_save(flags);
 
 	/*
-	 * If the 'nv' field is POSTED_INTR_WAKEUP_VECTOR, do not change
-	 * PI.NDST: pi_post_block is the one expected to change PID.NDST and the
-	 * wakeup handler expects the vCPU to be on the blocked_vcpu_list that
-	 * matches PI.NDST. Otherwise, a vcpu may not be able to be woken up
-	 * correctly.
+	 * If the vCPU was waiting for wakeup, remove the vCPU from the wakeup
+	 * list of the _previous_ pCPU, which will not be the same as the
+	 * current pCPU if the task was migrated.
 	 */
-	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR || vcpu->cpu == cpu) {
-		pi_clear_sn(pi_desc);
-		goto after_clear_sn;
+	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
+		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
+		list_del(&vcpu->blocked_vcpu_list);
+		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
 	}
 
-	/* The full case.  Set the new destination and clear SN. */
 	dest = cpu_physical_id(cpu);
 	if (!x2apic_mode)
 		dest = (dest << 8) & 0xFF00;
@@ -71,11 +83,23 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	do {
 		old.control = new.control = READ_ONCE(pi_desc->control);
 
+		/*
+		 * Clear SN (as above) and refresh the destination APIC ID to
+		 * handle task migration (@cpu != vcpu->cpu).
+		 */
 		new.ndst = dest;
 		new.sn = 0;
+
+		/*
+		 * Restore the notification vector; in the blocking case, the
+		 * descriptor was modified on "put" to use the wakeup vector.
+		 */
+		new.nv = POSTED_INTR_VECTOR;
 	} while (cmpxchg64(&pi_desc->control, old.control,
 			   new.control) != old.control);
 
+	local_irq_restore(flags);
+
 after_clear_sn:
 
 	/*
@@ -90,88 +114,24 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		pi_set_on(pi_desc);
 }
 
-void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
-{
-	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-
-	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
-		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
-		!kvm_vcpu_apicv_active(vcpu))
-		return;
-
-	/* Set SN when the vCPU is preempted */
-	if (vcpu->preempted)
-		pi_set_sn(pi_desc);
-}
-
-static void __pi_post_block(struct kvm_vcpu *vcpu)
-{
-	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-	struct pi_desc old, new;
-	unsigned int dest;
-
-	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
-	     "Wakeup handler not enabled while the vCPU was blocking");
-
-	/*
-	 * Remove the vCPU from the wakeup list of the _previous_ pCPU, which
-	 * will not be the same as the current pCPU if the task was migrated.
-	 */
-	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
-	list_del(&vcpu->blocked_vcpu_list);
-	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
-
-	dest = cpu_physical_id(vcpu->cpu);
-	if (!x2apic_mode)
-		dest = (dest << 8) & 0xFF00;
-
-	do {
-		old.control = new.control = READ_ONCE(pi_desc->control);
-
-		new.ndst = dest;
-
-		/* set 'NV' to 'notification vector' */
-		new.nv = POSTED_INTR_VECTOR;
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
-
-	vcpu->pre_pcpu = -1;
-}
-
 /*
- * This routine does the following things for vCPU which is going
- * to be blocked if VT-d PI is enabled.
- * - Store the vCPU to the wakeup list, so when interrupts happen
- *   we can find the right vCPU to wake up.
- * - Change the Posted-interrupt descriptor as below:
- *      'NV' <-- POSTED_INTR_WAKEUP_VECTOR
- * - If 'ON' is set during this process, which means at least one
- *   interrupt is posted for this vCPU, we cannot block it, in
- *   this case, return 1, otherwise, return 0.
- *
+ * Put the vCPU on this pCPU's list of vCPUs that needs to be awakened and set
+ * WAKEUP as the notification vector in the PI descriptor.
  */
-int pi_pre_block(struct kvm_vcpu *vcpu)
+static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 {
-	struct pi_desc old, new;
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+	struct pi_desc old, new;
 	unsigned long flags;
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
-	    !irq_remapping_cap(IRQ_POSTING_CAP) ||
-	    !kvm_vcpu_apicv_active(vcpu) ||
-	    vmx_interrupt_blocked(vcpu))
-		return 0;
-
 	local_irq_save(flags);
 
-	vcpu->pre_pcpu = vcpu->cpu;
 	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
 	list_add_tail(&vcpu->blocked_vcpu_list,
 		      &per_cpu(blocked_vcpu_on_cpu, vcpu->cpu));
 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
 
-	WARN(pi_desc->sn == 1,
-	     "Posted Interrupt Suppress Notification set before blocking");
+	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
 
 	do {
 		old.control = new.control = READ_ONCE(pi_desc->control);
@@ -181,24 +141,40 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	} while (cmpxchg64(&pi_desc->control, old.control,
 			   new.control) != old.control);
 
-	/* We should not block the vCPU if an interrupt is posted for it.  */
-	if (pi_test_on(pi_desc))
-		__pi_post_block(vcpu);
+	/*
+	 * Send a wakeup IPI to this CPU if an interrupt may have been posted
+	 * before the notification vector was updated, in which case the IRQ
+	 * will arrive on the non-wakeup vector.  An IPI is needed as calling
+	 * try_to_wake_up() from ->sched_out() isn't allowed (IRQs are not
+	 * enabled until it is safe to call try_to_wake_up() on the task being
+	 * scheduled out).
+	 */
+	if (pi_test_on(&new))
+		apic->send_IPI_self(POSTED_INTR_WAKEUP_VECTOR);
 
 	local_irq_restore(flags);
-	return (vcpu->pre_pcpu == -1);
 }
 
-void pi_post_block(struct kvm_vcpu *vcpu)
+void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 {
-	unsigned long flags;
+	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (vcpu->pre_pcpu == -1)
+	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
+	    !irq_remapping_cap(IRQ_POSTING_CAP)  ||
+	    !kvm_vcpu_apicv_active(vcpu))
 		return;
 
-	local_irq_save(flags);
-	__pi_post_block(vcpu);
-	local_irq_restore(flags);
+	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
+		pi_enable_wakeup_handler(vcpu);
+
+	/*
+	 * Set SN when the vCPU is preempted.  Note, the vCPU can both be seen
+	 * as blocking and preempted, e.g. if it's preempted between setting
+	 * its wait state and manually scheduling out.  In that case, KVM will
+	 * update
+	 */
+	if (vcpu->preempted)
+		pi_set_sn(pi_desc);
 }
 
 /*
@@ -239,7 +215,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
  * Bail out of the block loop if the VM has an assigned
  * device, but the blocking vCPU didn't reconfigure the
  * PI.NV to the wakeup vector, i.e. the assigned device
- * came along after the initial check in pi_pre_block().
+ * came along after the initial check in vmx_vcpu_pi_put().
  */
 void vmx_pi_start_assignment(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 36ae035f14aa..eb14e76b84ef 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -40,6 +40,12 @@ static inline bool pi_test_and_clear_on(struct pi_desc *pi_desc)
 			(unsigned long *)&pi_desc->control);
 }
 
+static inline bool pi_test_and_clear_sn(struct pi_desc *pi_desc)
+{
+	return test_and_clear_bit(POSTED_INTR_SN,
+			(unsigned long *)&pi_desc->control);
+}
+
 static inline bool pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
 {
 	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
@@ -88,8 +94,6 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
 
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
-int pi_pre_block(struct kvm_vcpu *vcpu);
-void pi_post_block(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
 void __init pi_init_cpu(int cpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5517893f12fc..26ed8cd1a1f2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7462,9 +7462,6 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 
 static int vmx_pre_block(struct kvm_vcpu *vcpu)
 {
-	if (pi_pre_block(vcpu))
-		return 1;
-
 	if (kvm_lapic_hv_timer_in_use(vcpu))
 		kvm_lapic_switch_to_sw_timer(vcpu);
 
@@ -7475,8 +7472,6 @@ static void vmx_post_block(struct kvm_vcpu *vcpu)
 {
 	if (kvm_x86_ops.set_hv_timer)
 		kvm_lapic_switch_to_hv_timer(vcpu);
-
-	pi_post_block(vcpu);
 }
 
 static void vmx_setup_mce(struct kvm_vcpu *vcpu)
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
