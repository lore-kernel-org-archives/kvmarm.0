Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC193C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87D732067C
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EWqoykWi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87D732067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E2254BF11;
	Mon, 17 Aug 2020 06:06:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tyveOS0xG6q3; Mon, 17 Aug 2020 06:06:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7C2E4BD76;
	Mon, 17 Aug 2020 06:06:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E9104C014
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 96W2WS3W6a-A for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:06:39 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B2D14C017
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658799;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=khQhCUnq3+T413dGEfdD9qTEBWDFTeG6j/5SLd0v/9Y=;
 b=EWqoykWie27LLEO+yvZoClx4hJ2PaEVKWPG3N/XQprW3rlYQkvGLQWM36735JENR4tKceU
 dlSM/Us95icGaEDAJnl/UgzIHS7L6//J0ajYj9dGivb53v1fs/2seQpIToyXBlhQRJVMI7
 hrhZblE7OjdUmPojd/t3lQ+6xOQ6o6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-5BkXWr13OqCd1USLU5hFhA-1; Mon, 17 Aug 2020 06:06:37 -0400
X-MC-Unique: 5BkXWr13OqCd1USLU5hFhA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 175B581F014;
 Mon, 17 Aug 2020 10:06:36 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 13D9C7843D;
 Mon, 17 Aug 2020 10:06:32 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 14/18] arm64/kvm: Implement event handler
Date: Mon, 17 Aug 2020 20:05:27 +1000
Message-Id: <20200817100531.83045-15-gshan@redhat.com>
In-Reply-To: <20200817100531.83045-1-gshan@redhat.com>
References: <20200817100531.83045-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com
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

This implements the event handler with help of KVM SDEI vCPU event,
which is represented by "struct kvm_sdei_vcpu_event". The shared
event is delivered to all VMs where it was registered and enabled.
The private event is delivered to the vCPUs, which are running or
suspending on current CPU.

KVM_REQ_SDEI request is fired to the vCPU if it receives new event
no matter what type it is. With that, kvm_sdei_deliver() is called
when the vCPU is loaded, to inject the SDEI event to the guest. The
behaviour is defined in SDEI specification (v1.0):

   * x0 to x17 are saved.
   * the interrupted PC/PState are saved.
   * x0/x1/x2/x3 is set to the event number, event parameter, the
     interrupt PC and PState separately.
   * PSTATE is modified as follows: DAIF=0b1111, EL=ELc, nRW=0, SP=1
   * PC is set to the address of the handler

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/include/asm/kvm_sdei.h |   2 +
 arch/arm64/kvm/arm.c              |   4 +
 arch/arm64/kvm/sdei.c             | 240 +++++++++++++++++++++++++++++-
 4 files changed, 246 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a8cfb3895f7..ba8cdc304b81 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -45,6 +45,7 @@
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
+#define KVM_REQ_SDEI		KVM_ARCH_REQ(5)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index 6cbf4015a371..70e613941577 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -104,8 +104,10 @@ static inline bool kvm_sdei_num_is_valid(unsigned long num)
 }
 
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
+void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
 void kvm_sdei_init(void);
 void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
+void kvm_sdei_vcpu_load(struct kvm_vcpu *vcpu);
 void kvm_sdei_destroy_vm(struct kvm *kvm);
 
 #endif /* __ARM64_KVM_SDEI_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index bb539b51cd57..a79a4343bac6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -356,6 +356,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vcpu->cpu = cpu;
 
+	kvm_sdei_vcpu_load(vcpu);
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vcpu_load_sysregs(vcpu);
@@ -623,6 +624,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
 
+		if (kvm_check_request(KVM_REQ_SDEI, vcpu))
+			kvm_sdei_deliver(vcpu);
+
 		/*
 		 * Clear IRQ_PENDING requests that were made to guarantee
 		 * that a VCPU sees new virtual interrupts.
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 2d5e44bb5497..52d0f0809a37 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -151,11 +151,242 @@ static unsigned long kvm_sdei_hypercall_version(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static int kvm_sdei_handler(u32 num, struct pt_regs *regs, void *arg)
+void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_event *event;
+	struct kvm_sdei_kvm_event *kevent;
+	struct kvm_sdei_vcpu_event *tmp, *vevent = NULL;
+	struct user_pt_regs *regs;
+	unsigned long num, type, priority, pstate;
+	bool handle_critical;
+	int index, i;
+
+	spin_lock(&vcpu->arch.sdei_lock);
+
+	/* No way to preempt critical event */
+	if (vcpu->arch.sdei_critical_event)
+		goto unlock;
+
+	/* Find the suitable event to deliver */
+	handle_critical = vcpu->arch.sdei_normal_event ? true : false;
+	list_for_each_entry(tmp, &vcpu->arch.sdei_events, link) {
+		event = tmp->event->event;
+		priority = event->priv ? event->priv->priority :
+					 event->event->priority;
+		if (!handle_critical ||
+		    (priority == SDEI_EVENT_PRIORITY_CRITICAL)) {
+			vevent = tmp;
+			kevent = vevent->event;
+			break;
+		}
+	}
+
+	if (!vevent)
+		goto unlock;
+
+	/* Save registers: x0 -> x17, PC, PState */
+	if (priority == SDEI_EVENT_PRIORITY_CRITICAL) {
+		vcpu->arch.sdei_critical_event = vevent;
+		regs = &vcpu->arch.sdei_critical_regs;
+	} else {
+		vcpu->arch.sdei_normal_event = vevent;
+		regs = &vcpu->arch.sdei_normal_regs;
+	}
+
+	for (i = 0; i < 18; i++)
+		regs->regs[i] = vcpu_get_reg(vcpu, i);
+
+	regs->pc = *vcpu_pc(vcpu);
+	regs->pstate = *vcpu_cpsr(vcpu);
+
+	/* Inject SDEI event: x0 -> x3, PC, PState */
+	num = event->priv ? event->priv->num : event->event->event_num;
+	type = event->priv ? event->priv->type : event->event->type;
+	index = (type == SDEI_EVENT_TYPE_PRIVATE) ? vcpu->vcpu_idx : 0;
+	for (i = 0; i < 18; i++)
+		vcpu_set_reg(vcpu, i, 0);
+
+	vcpu_set_reg(vcpu, 0, num);
+	vcpu_set_reg(vcpu, 1, kevent->params[index]);
+	vcpu_set_reg(vcpu, 2, regs->pc);
+	vcpu_set_reg(vcpu, 3, regs->pstate);
+
+	pstate = regs->pstate;
+	pstate |= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT);
+	pstate &= ~PSR_MODE_MASK;
+	pstate |= PSR_MODE_EL1h;
+	pstate &= ~PSR_MODE32_BIT;
+
+	vcpu_write_spsr(vcpu, regs->pstate);
+	*vcpu_cpsr(vcpu) = pstate;
+	*vcpu_pc(vcpu) = kevent->entries[index];
+
+	/* Notifier */
+	if (event->priv && event->priv->notifier)
+		event->priv->notifier(vcpu, num, KVM_SDEI_STATE_DELIVERED);
+
+unlock:
+	spin_unlock(&vcpu->arch.sdei_lock);
+}
+
+static int kvm_sdei_queue_event(struct kvm_vcpu *vcpu,
+				struct kvm_sdei_kvm_event *kevent)
+{
+	struct kvm_sdei_vcpu_event *e, *vevent = NULL;
+
+	lockdep_assert_held(&kevent->event->lock);
+	lockdep_assert_held(&vcpu->arch.sdei_lock);
+
+	list_for_each_entry(e, &vcpu->arch.sdei_events, link) {
+		if (e->event == kevent) {
+			vevent = e;
+			break;
+		}
+	}
+
+	/*
+	 * We just need increase the count if the vCPU event has been
+	 * existing. Otherwise, we have to create a new one.
+	 */
+	if (vevent) {
+		vevent->users++;
+		kevent->users++;
+		kvm_make_request(KVM_REQ_SDEI, vcpu);
+		return 0;
+	}
+
+	vevent = kzalloc(sizeof(*vevent), GFP_ATOMIC);
+	if (!vevent) {
+		pr_warn("%s: Unable to alloc memory (%lu, %u-%d)\n",
+			__func__, kevent->event->num,
+			kevent->kvm->userspace_pid, vcpu->vcpu_idx);
+		return -ENOMEM;
+	}
+
+	vevent->event = kevent;
+	vevent->users = 1;
+	kevent->users++;
+	list_add_tail(&vevent->link, &vcpu->arch.sdei_events);
+	kvm_make_request(KVM_REQ_SDEI, vcpu);
+
+	return 0;
+}
+
+/*
+ * Queue the shared event to the target VMs where the event have been
+ * registered and enabled. For the particular VM, the event is delivered
+ * to the first unmasked vCPU if the strict routing isn't specified.
+ * Otherwise, the event is delivered to the specified vCPU.
+ *
+ * If the vCPU event exists, we just need increase its count. Otherwise,
+ * a new one is created and queued to the target vCPU.
+ */
+static int kvm_sdei_shared_handler(struct kvm_sdei_event *event)
+{
+	struct kvm_sdei_kvm_event *kevent, *n;
+	struct kvm_vcpu *target, *vcpu;
+	unsigned long affinity;
+	int i;
+
+	spin_lock(&event->lock);
+
+	rbtree_postorder_for_each_entry_safe(kevent, n,
+					     &event->root, node) {
+		if (!test_bit(0, kevent->registered) ||
+		    !test_bit(0, kevent->enabled))
+			continue;
+
+		/*
+		 * Select the target vCPU according to the routing
+		 * mode and affinity.
+		 */
+		target = NULL;
+		kvm_for_each_vcpu(i, vcpu, kevent->kvm) {
+			affinity = kvm_vcpu_get_mpidr_aff(vcpu);
+			spin_lock(&vcpu->arch.sdei_lock);
+
+			if (kevent->route_mode == SDEI_EVENT_REGISTER_RM_ANY) {
+				if (!vcpu->arch.sdei_masked) {
+					target = vcpu;
+					spin_unlock(&vcpu->arch.sdei_lock);
+					break;
+				}
+			} else if (kevent->route_affinity == affinity) {
+				target = !vcpu->arch.sdei_masked ? vcpu : NULL;
+				spin_unlock(&vcpu->arch.sdei_lock);
+				break;
+			}
+
+			spin_unlock(&vcpu->arch.sdei_lock);
+		}
+
+		if (!target)
+			continue;
+
+		spin_lock(&target->arch.sdei_lock);
+		kvm_sdei_queue_event(target, kevent);
+		spin_unlock(&target->arch.sdei_lock);
+	}
+
+	spin_unlock(&event->lock);
+
+	return 0;
+}
+
+/*
+ * The private SDEI event is delivered into the vCPUs, which are
+ * running or suspending on the current CPU.
+ */
+static int kvm_sdei_private_handler(struct kvm_sdei_event *event)
 {
+	struct kvm_sdei_kvm_event *kevent, *n;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	spin_lock(&event->lock);
+
+	rbtree_postorder_for_each_entry_safe(kevent, n,
+					     &event->root, node) {
+		if (bitmap_empty(kevent->registered, KVM_MAX_VCPUS) ||
+		    bitmap_empty(kevent->enabled, KVM_MAX_VCPUS))
+			continue;
+
+		kvm_for_each_vcpu(i, vcpu, kevent->kvm) {
+			if (!test_bit(vcpu->vcpu_idx, kevent->registered) ||
+			    !test_bit(vcpu->vcpu_idx, kevent->enabled))
+				continue;
+
+			spin_lock(&vcpu->arch.sdei_lock);
+
+			if (vcpu->arch.sdei_masked ||
+			    vcpu->arch.sdei_cpu != smp_processor_id()) {
+				spin_unlock(&vcpu->arch.sdei_lock);
+				continue;
+			}
+
+			kvm_sdei_queue_event(vcpu, kevent);
+
+			spin_unlock(&vcpu->arch.sdei_lock);
+		}
+	}
+
+	spin_unlock(&event->lock);
+
 	return 0;
 }
 
+static int kvm_sdei_handler(u32 num, struct pt_regs *regs, void *arg)
+{
+	struct kvm_sdei_event *event = (struct kvm_sdei_event *)arg;
+	unsigned long type = (event->priv) ? event->priv->type :
+					     event->event->type;
+
+	if (type == SDEI_EVENT_TYPE_SHARED)
+		kvm_sdei_shared_handler(event);
+
+	return kvm_sdei_private_handler(event);
+}
+
 static unsigned long kvm_sdei_hypercall_register(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -826,6 +1057,13 @@ void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu)
 	INIT_LIST_HEAD(&vcpu->arch.sdei_events);
 }
 
+void kvm_sdei_vcpu_load(struct kvm_vcpu *vcpu)
+{
+	spin_lock(&vcpu->arch.sdei_lock);
+	vcpu->arch.sdei_cpu = smp_processor_id();
+	spin_unlock(&vcpu->arch.sdei_lock);
+}
+
 void kvm_sdei_destroy_vm(struct kvm *kvm)
 {
 	unsigned int types = ((1 << SDEI_EVENT_TYPE_PRIVATE) |
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
