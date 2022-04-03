Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A67C433F5
	for <kvmarm@archiver.kernel.org>; Sun,  3 Apr 2022 15:41:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 779904B206;
	Sun,  3 Apr 2022 11:41:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kdGitzDK0sOL; Sun,  3 Apr 2022 11:40:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D21BA4B1B5;
	Sun,  3 Apr 2022 11:40:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 525864B103
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UaLGjsQGoZDE for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 11:40:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EACD34B0F1
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649000455;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AtmhTbXVKunwbsOVOQkic+/uO9rAxPGFl0a9puIA7og=;
 b=E94q7DvfRmcCJOFp9wK55YQQnKB2TgQmTAz0Q58/X0zd+b1H9WZdveERKjFZyTjc5YvjXO
 jHEduoeTHjRzZ7bom6wHZ9I+xhPXbOOZ1Iro24iepBFQ+ptqotfzcIflsmjzimfYrt8dEk
 TGYfXGTMHeIrDwUaw8v+syPFfC2dEhM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-4H8n1VM8O3OWleF-fGv-7w-1; Sun, 03 Apr 2022 11:40:54 -0400
X-MC-Unique: 4H8n1VM8O3OWleF-fGv-7w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E454185A7BA;
 Sun,  3 Apr 2022 15:40:54 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-82.pek2.redhat.com [10.72.12.82])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E8074538D7;
 Sun,  3 Apr 2022 15:40:47 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 12/18] KVM: arm64: Support SDEI event injection, delivery
Date: Sun,  3 Apr 2022 23:39:05 +0800
Message-Id: <20220403153911.12332-13-gshan@redhat.com>
In-Reply-To: <20220403153911.12332-1-gshan@redhat.com>
References: <20220403153911.12332-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

This supports event injection, delivery and cancellation. The event
is injected and cancelled by kvm_sdei_{inject, cancel}_event(). For
event delivery, vcpu request (KVM_REQ_SDEI) is introduced.

kvm_sdei_deliver_event() is called to accommodate the KVM_REQ_SDEI
request. The execution context is switched like below:

  * x0 - x17 are saved. All of them are cleared except the following
    registers:

    x0: event number
    x1: user argument associated with the SDEI event
    x2: PC of the interrupted or preempted context
    x3: PSTATE of the interrupted or preempted context

  * PC is set to the event handler, which is provided when the event
    is registered. PSTATE is modified according to the specification.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/include/asm/kvm_sdei.h |   4 +
 arch/arm64/kvm/arm.c              |   3 +
 arch/arm64/kvm/sdei.c             | 260 ++++++++++++++++++++++++++++++
 4 files changed, 268 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7644a400c4a8..951264d4b64d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -46,6 +46,7 @@
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
+#define KVM_REQ_SDEI		KVM_ARCH_REQ(6)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index 2dbfb3ae0a48..f946d4ebdc14 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -142,6 +142,10 @@ KVM_SDEI_REGISTERED_EVENT_FUNC(unregister_pending, UNREGISTER_PENDING)
 
 /* APIs */
 int kvm_sdei_call(struct kvm_vcpu *vcpu);
+int kvm_sdei_inject_event(struct kvm_vcpu *vcpu, unsigned int num,
+			  bool immediate);
+int kvm_sdei_cancel_event(struct kvm_vcpu *vcpu, unsigned int num);
+void kvm_sdei_deliver_event(struct kvm_vcpu *vcpu);
 void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
 void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 227c0e390571..7e77d62aeab1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -659,6 +659,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
 
+		if (kvm_check_request(KVM_REQ_SDEI, vcpu))
+			kvm_sdei_deliver_event(vcpu);
+
 		/*
 		 * Clear IRQ_PENDING requests that were made to guarantee
 		 * that a VCPU sees new virtual interrupts.
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 6716ed020aa2..9d18fee59751 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -87,6 +87,36 @@ static int reset_event(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int inject_event(struct kvm_vcpu *vcpu,
+			struct kvm_sdei_event *event)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_exposed_event *exposed_event;
+
+	/* The event should have been registered and enabled */
+	if (!kvm_sdei_is_registered(event) ||
+	    !kvm_sdei_is_enabled(event))
+		return -ENOENT;
+
+	/*
+	 * If the event is pending for unregistration, we shouldn't
+	 * inject the event.
+	 */
+	if (kvm_sdei_is_unregister_pending(event))
+		return -EAGAIN;
+
+	event->event_count++;
+	exposed_event = event->exposed_event;
+	if (kvm_sdei_is_critical(exposed_event->priority))
+		vsdei->critical_event_count++;
+	else
+		vsdei->normal_event_count++;
+
+	kvm_make_request(KVM_REQ_SDEI, vcpu);
+
+	return 0;
+}
+
 static unsigned long hypercall_register(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -447,6 +477,236 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+int kvm_sdei_inject_event(struct kvm_vcpu *vcpu,
+			  unsigned int num,
+			  bool immediate)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_exposed_event *exposed_event;
+	struct kvm_sdei_event *event;
+	unsigned long event_count = 0;
+	int ret = 0;
+
+	if (!vsdei) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	if (!kvm_sdei_is_supported(num)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	spin_lock(&vsdei->lock);
+
+	/* Check if the vcpu has been masked */
+	if (vsdei->masked) {
+		ret = -EPERM;
+		goto unlock;
+	}
+
+	/* Check if the event exists */
+	event = find_event(vcpu, num);
+	if (!event) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+
+	/*
+	 * In some cases, the injected event is expected to be delivered
+	 * immediately. However, there are two cases the injected event
+	 * can't be delivered immediately: (a) the injected event is a
+	 * critical one, but we already have pending critical events for
+	 * delivery. (b) the injected event is a normal one, but we have
+	 * pending events for delivery, regardless of their priorities.
+	 */
+	if (immediate) {
+		exposed_event = event->exposed_event;
+		event_count = vsdei->critical_event_count;
+		if (kvm_sdei_is_normal(exposed_event->priority))
+			event_count += vsdei->normal_event_count;
+
+		if (event_count > 0)
+			return -ENOSPC;
+	}
+
+	ret = inject_event(vcpu, event);
+
+unlock:
+	spin_unlock(&vsdei->lock);
+out:
+	return ret;
+}
+
+int kvm_sdei_cancel_event(struct kvm_vcpu *vcpu, unsigned int num)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_context *context;
+	struct kvm_sdei_exposed_event *exposed_event;
+	struct kvm_sdei_event *event;
+	int ret = 0;
+
+	if (!vsdei) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	if (!kvm_sdei_is_supported(num)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	spin_lock(&vsdei->lock);
+
+	/* Check if the event exists */
+	event = find_event(vcpu, num);
+	if (!event) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+
+	/* The event should have been registered and eanbled */
+	if (!kvm_sdei_is_registered(event) ||
+	    !kvm_sdei_is_enabled(event)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/*
+	 * If the event is pending for unregistration, we needn't
+	 * cancel it because all the pending events will be cancelled
+	 * after its handler is to finish.
+	 */
+	if (kvm_sdei_is_unregister_pending(event)) {
+		ret = -EAGAIN;
+		goto unlock;
+	}
+
+	/* Return success if there is no pending events */
+	if (event->event_count <= 0)
+		goto unlock;
+
+	/* The event can't be cancelled if it's being handled */
+	exposed_event = event->exposed_event;
+	context = kvm_sdei_is_critical(exposed_event->priority) ?
+		  &vsdei->context[SDEI_EVENT_PRIORITY_CRITICAL] :
+		  &vsdei->context[SDEI_EVENT_PRIORITY_NORMAL];
+	if (event->event_count == 1 &&
+	    context->event == event) {
+		ret = -EAGAIN;
+		goto unlock;
+	}
+
+	/* Cancel the event */
+	event->event_count--;
+	if (kvm_sdei_is_critical(exposed_event->priority))
+		vsdei->critical_event_count--;
+	else
+		vsdei->normal_event_count--;
+
+unlock:
+	spin_unlock(&vsdei->lock);
+out:
+	return ret;
+}
+
+void kvm_sdei_deliver_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_context *context;
+	struct kvm_sdei_exposed_event *exposed_event;
+	struct kvm_sdei_event *selected, *event;
+	unsigned long pstate;
+	unsigned int i;
+
+	if (!vsdei)
+		return;
+
+	spin_lock(&vsdei->lock);
+
+	/* Check if the vcpu has been masked */
+	if (vsdei->masked)
+		goto unlock;
+
+	/* The currently handled critical event can't be preempted */
+	context = &vsdei->context[SDEI_EVENT_PRIORITY_CRITICAL];
+	if (context->event)
+		goto unlock;
+
+	/*
+	 * Select the event to be handled. The critical event is
+	 * selected if we have one. Otherwise, the first normal
+	 * event will be selected. Beside, the normal event can
+	 * be preempted by the critical event. However, the normal
+	 * event can't be preempted by another normal event.
+	 */
+	selected = NULL;
+	context = &vsdei->context[SDEI_EVENT_PRIORITY_NORMAL];
+	kvm_sdei_for_each_event(vsdei, event, i) {
+		exposed_event = event->exposed_event;
+		if (event->event_count <= 0)
+			continue;
+
+		if (context->event &&
+		    kvm_sdei_is_normal(exposed_event->priority))
+			continue;
+
+		if (kvm_sdei_is_critical(exposed_event->priority)) {
+			selected = event;
+			break;
+		}
+
+		selected = selected ? : event;
+	}
+
+	if (!selected)
+		goto unlock;
+
+	/*
+	 * Save context: x0 -> x17, PC, PState. There might be pending
+	 * exception or PC increment request in the last run on this vCPU.
+	 * In this case, we need to save the site in advance. Otherwise,
+	 * the passed entry point could be floated by 4 bytes in the
+	 * subsequent call to __kvm_adjust_pc().
+	 */
+	event = selected;
+	exposed_event = event->exposed_event;
+	context = kvm_sdei_is_critical(exposed_event->priority) ?
+		  &vsdei->context[SDEI_EVENT_PRIORITY_CRITICAL] :
+		  &vsdei->context[SDEI_EVENT_PRIORITY_NORMAL];
+	context->event = event;
+
+	__kvm_adjust_pc(vcpu);
+	context->pc = *vcpu_pc(vcpu);
+	context->pstate = *vcpu_cpsr(vcpu);
+	for (i = 0; i < ARRAY_SIZE(context->regs); i++)
+		context->regs[i] = vcpu_get_reg(vcpu, i);
+
+	/*
+	 * Inject event: x0 -> x3, PC, PState. The other general
+	 * purpose registers are cleared.
+	 */
+	for (i = 0; i < ARRAY_SIZE(context->regs); i++)
+		vcpu_set_reg(vcpu, i, 0);
+
+	vcpu_set_reg(vcpu, 0, exposed_event->num);
+	vcpu_set_reg(vcpu, 1, event->ep_arg);
+	vcpu_set_reg(vcpu, 2, context->pc);
+	vcpu_set_reg(vcpu, 3, context->pstate);
+
+	pstate = context->pstate;
+	pstate |= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT);
+	pstate &= ~PSR_MODE_MASK;
+	pstate |= PSR_MODE_EL1h;
+	pstate &= ~PSR_MODE32_BIT;
+
+	*vcpu_cpsr(vcpu) = pstate;
+	*vcpu_pc(vcpu) = event->ep_address;
+
+unlock:
+	spin_unlock(&vsdei->lock);
+}
+
 void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei;
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
