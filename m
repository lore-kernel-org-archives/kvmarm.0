Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E284FC433E3
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9217E2078D
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="be7NwkAM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9217E2078D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46E5B4BF11;
	Mon, 17 Aug 2020 06:06:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KkXS0hunc6xY; Mon, 17 Aug 2020 06:06:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09E554C003;
	Mon, 17 Aug 2020 06:06:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7A8E4C012
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h47h0NtVdcrl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:06:44 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B51C84BE67
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658804;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=K2ZGJ13gbLQ+MiMtvqOnS2mBev5SCPh9Uc/WReVg6vM=;
 b=be7NwkAMj8eCUfeEIQA0Y3e+krOhWFNqayj32Qv+dM+2/q1vSKs1mdzuCrLLcPxQeC3oN/
 yfaRwU6lXYiIlWMUY66k4j9Yw2Y5igT7mtooPcCGYUL3EVakFVU9phD7OrMe6Jm2CoXJ6c
 t7D6sVQI+eJ2KD/em0uRiJ7T38EXPu8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-k0WVKZ5GOCKs_1AuLQHaHw-1; Mon, 17 Aug 2020 06:06:42 -0400
X-MC-Unique: k0WVKZ5GOCKs_1AuLQHaHw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8A821014DF6;
 Mon, 17 Aug 2020 10:06:41 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 7A5A27843D;
 Mon, 17 Aug 2020 10:06:36 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 15/18] arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_{COMPLETE,
 COMPLETE_AND_RESUME} hypercall
Date: Mon, 17 Aug 2020 20:05:28 +1000
Message-Id: <20200817100531.83045-16-gshan@redhat.com>
In-Reply-To: <20200817100531.83045-1-gshan@redhat.com>
References: <20200817100531.83045-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
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

This supports SDEI_1_0_FN_SDEI_EVENT_{COMPLETE, COMPLETE_AND_RESUME}
hypercall by implementing kvm_sdei_hypercall_complete(). If there is
valid context, the registers are restored as below. Otherwise, errno
is returned.

   * x0 -> x17
   * PC and pState

If it's KVM private event, which is originated from KVM itself, the
notfier is executed. Besides, the IRQ exception is injected if the
request is to resume the guest by SDEI_1_0_FN_SDEI_EVENT_RESUME.
The behaviour is defined in SDEI specification (v1.0).

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  2 +
 arch/arm64/kvm/aarch32.c             |  8 +++
 arch/arm64/kvm/inject_fault.c        | 30 ++++++++++
 arch/arm64/kvm/sdei.c                | 88 +++++++++++++++++++++++++++-
 4 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 4d0f8ea600ba..bb7aee5927a5 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -29,10 +29,12 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr);
 
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
+void kvm_inject_irq(struct kvm_vcpu *vcpu);
 void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_undef32(struct kvm_vcpu *vcpu);
+void kvm_inject_irq32(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt32(struct kvm_vcpu *vcpu, unsigned long addr);
 
diff --git a/arch/arm64/kvm/aarch32.c b/arch/arm64/kvm/aarch32.c
index 40a62a99fbf8..73e9059cf2e8 100644
--- a/arch/arm64/kvm/aarch32.c
+++ b/arch/arm64/kvm/aarch32.c
@@ -181,6 +181,14 @@ void kvm_inject_undef32(struct kvm_vcpu *vcpu)
 	post_fault_synchronize(vcpu, loaded);
 }
 
+void kvm_inject_irq32(struct kvm_vcpu *vcpu)
+{
+	bool loaded = pre_fault_synchronize(vcpu);
+
+	prepare_fault32(vcpu, PSR_AA32_MODE_IRQ, 4);
+	post_fault_synchronize(vcpu, loaded);
+}
+
 /*
  * Modelled after TakeDataAbortException() and TakePrefetchAbortException
  * pseudocode.
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index e21fdd93027a..84e50b002cd0 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -168,6 +168,22 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
 }
 
+static void inject_irq64(struct kvm_vcpu *vcpu)
+{
+	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
+
+	enter_exception64(vcpu, PSR_MODE_EL1h, except_type_irq);
+
+	/*
+	 * Build an unknown exception, depending on the instruction
+	 * set.
+	 */
+	if (kvm_vcpu_trap_il_is32bit(vcpu))
+		esr |= ESR_ELx_IL;
+
+	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+}
+
 /**
  * kvm_inject_dabt - inject a data abort into the guest
  * @vcpu: The VCPU to receive the data abort
@@ -214,6 +230,20 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 		inject_undef64(vcpu);
 }
 
+/**
+ * kvm_inject_irq - inject an IRQ into the guest
+ *
+ * It is assumed that this code is called from the VCPU thread and that the
+ * VCPU therefore is not currently executing guest code.
+ */
+void kvm_inject_irq(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_el1_is_32bit(vcpu))
+		kvm_inject_irq32(vcpu);
+	else
+		inject_irq64(vcpu);
+}
+
 void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 esr)
 {
 	vcpu_set_vsesr(vcpu, esr & ESR_ELx_ISS_MASK);
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 52d0f0809a37..cf6908e87edd 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -590,6 +590,77 @@ static unsigned long kvm_sdei_hypercall_enable(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static unsigned long kvm_sdei_hypercall_complete(struct kvm_vcpu *vcpu,
+						 bool resume)
+{
+	struct kvm_sdei_event *event = NULL;
+	struct kvm_sdei_kvm_event *kevent = NULL;
+	struct kvm_sdei_vcpu_event *vevent = NULL;
+	struct user_pt_regs *regs;
+	int i;
+
+	spin_lock(&vcpu->arch.sdei_lock);
+
+	if (!vcpu->arch.sdei_critical_event &&
+	    !vcpu->arch.sdei_normal_event) {
+		spin_unlock(&vcpu->arch.sdei_lock);
+		return SDEI_DENIED;
+	}
+
+	if (vcpu->arch.sdei_critical_event) {
+		vevent = vcpu->arch.sdei_critical_event;
+		regs = &vcpu->arch.sdei_critical_regs;
+		vcpu->arch.sdei_critical_event = NULL;
+	} else if (vcpu->arch.sdei_normal_event) {
+		vevent = vcpu->arch.sdei_normal_event;
+		regs = &vcpu->arch.sdei_normal_regs;
+		vcpu->arch.sdei_normal_event = NULL;
+	}
+
+	/* Restore registers: x0 -> x17, PC, PState */
+	for (i = 0; i < 18; i++)
+		vcpu_set_reg(vcpu, i, regs->regs[i]);
+
+	*vcpu_cpsr(vcpu) = regs->pstate;
+	*vcpu_pc(vcpu) = regs->pc;
+
+	/* Notifier for KVM private event */
+	kevent = vevent->event;
+	event = kevent->event;
+	if (event->priv && event->priv->notifier) {
+		event->priv->notifier(vcpu, event->priv->num,
+				      KVM_SDEI_STATE_COMPLETED);
+	}
+
+	/* Inject interrupt if needed */
+	if (resume)
+		kvm_inject_irq(vcpu);
+
+	/* Release vCPU event if needed */
+	vevent->users--;
+	if (!vevent->users) {
+		list_del(&vevent->link);
+		kfree(vevent);
+	}
+
+	/* Queue request if pending events exist */
+	if (!list_empty(&vcpu->arch.sdei_events))
+		kvm_make_request(KVM_REQ_SDEI, vcpu);
+
+	spin_unlock(&vcpu->arch.sdei_lock);
+
+	/*
+	 * Update status to KVM event. We can't do this with the
+	 * vCPU lock hold. Otherwise, we might run into nested
+	 * locking issue.
+	 */
+	spin_lock(&event->lock);
+	kevent->users--;
+	spin_unlock(&event->lock);
+
+	return SDEI_SUCCESS;
+}
+
 static unsigned long kvm_sdei_hypercall_unregister(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -988,6 +1059,7 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 {
 	u32 function = smccc_get_function(vcpu);
 	unsigned long ret;
+	bool has_result = true;
 
 	switch (function) {
 	case SDEI_1_0_FN_SDEI_VERSION:
@@ -1003,8 +1075,16 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_sdei_hypercall_enable(vcpu, false);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
+		ret = SDEI_NOT_SUPPORTED;
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
+		has_result = false;
+		ret = kvm_sdei_hypercall_complete(vcpu, false);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
+		has_result = false;
+		ret = kvm_sdei_hypercall_complete(vcpu, true);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
 		ret = kvm_sdei_hypercall_unregister(vcpu);
 		break;
@@ -1037,7 +1117,13 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = SDEI_NOT_SUPPORTED;
 	}
 
-	smccc_set_retval(vcpu, ret, 0, 0, 0);
+	/*
+	 * For the COMPLETE or COMPLETE_AND_RESUME hypercalls,
+	 * we don't have return value. Otherwise, the restored
+	 * context is corrupted.
+	 */
+	if (has_result)
+		smccc_set_retval(vcpu, ret, 0, 0, 0);
 
 	return 1;
 }
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
