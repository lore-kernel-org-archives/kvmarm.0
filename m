Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E94C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:15:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5FBF360FC1
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5FBF360FC1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F343C4A4A4;
	Sat, 14 Aug 2021 20:15:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A5I+qDvLe37X; Sat, 14 Aug 2021 20:15:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 459994B0D5;
	Sat, 14 Aug 2021 20:15:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4F584B0C9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:15:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e6v9wPiThG1S for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 20:15:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F14C4AC78
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:15:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628986518;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=HDIF804hsFXz7fo4/n1hskGvZoXurMvfIhDu1hTQGQE=;
 b=QyGZCLZ+92CJUg9VLBZrfqn7LPojMG3kIYtaEXSiEZRSob2cs1c37r5HO2viGz8aZAeOKj
 ZVjB0xV2tJHSOkYm3LV8TVWFIQgM+6QZJxh0YsD+vU5i8if0RRWSUNQ0+VyXHlcFRHDkFw
 7vvZAbCE7q5SM5aHV3ga9PIWgfxNSjQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-INtLakD-Nfm6lTq8eJL1Iw-1; Sat, 14 Aug 2021 20:15:16 -0400
X-MC-Unique: INtLakD-Nfm6lTq8eJL1Iw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6001824F83;
 Sun, 15 Aug 2021 00:15:15 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EB5510429FE;
 Sun, 15 Aug 2021 00:15:11 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 13/21] KVM: arm64: Impment SDEI event delivery
Date: Sun, 15 Aug 2021 08:13:44 +0800
Message-Id: <20210815001352.81927-14-gshan@redhat.com>
In-Reply-To: <20210815001352.81927-1-gshan@redhat.com>
References: <20210815001352.81927-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com,
 pbonzini@redhat.com, will@kernel.org
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

This implement kvm_sdei_deliver() to support SDEI event delivery.
The function is called when the request (KVM_REQ_SDEI) is raised.
The following rules are taken according to the SDEI specification:

   * x0 - x17 are saved. All of them are cleared except the following
     registered:
     x0: number SDEI event to be delivered
     x1: parameter associated with the SDEI event
     x2: PC of the interrupted context
     x3: PState of the interrupted context

   * PC is set to the handler of the SDEI event, which was provided
     during its registration. PState is modified accordingly.

   * SDEI event with critical priority can preempt those with normal
     priority.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/kvm_sdei.h |  1 +
 arch/arm64/kvm/arm.c              |  3 ++
 arch/arm64/kvm/sdei.c             | 84 +++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index aedf901e1ec7..46f363aa6524 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -47,6 +47,7 @@
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
+#define KVM_REQ_SDEI		KVM_ARCH_REQ(6)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index b0abc13a0256..7f5f5ad689e6 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -112,6 +112,7 @@ KVM_SDEI_FLAG_FUNC(enabled)
 void kvm_sdei_init_vm(struct kvm *kvm);
 void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
+void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
 void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu);
 void kvm_sdei_destroy_vm(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2f021aa41632..0c3db1ef1ba9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -689,6 +689,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
 
+		if (kvm_check_request(KVM_REQ_SDEI, vcpu))
+			kvm_sdei_deliver(vcpu);
+
 		/*
 		 * Clear IRQ_PENDING requests that were made to guarantee
 		 * that a VCPU sees new virtual interrupts.
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 62efee2b67b8..b5d6d1ed3858 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -671,6 +671,90 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *kse = NULL;
+	struct kvm_sdei_kvm_event *kske = NULL;
+	struct kvm_sdei_vcpu_event *ksve = NULL;
+	struct kvm_sdei_vcpu_regs *regs = NULL;
+	unsigned long pstate;
+	int index = 0;
+
+	/* Sanity check */
+	if (!(ksdei && vsdei))
+		return;
+
+	/* The critical event can't be preempted */
+	spin_lock(&vsdei->lock);
+	if (vsdei->critical_event)
+		goto unlock;
+
+	/*
+	 * The normal event can be preempted by the critical event.
+	 * However, the normal event can't be preempted by another
+	 * normal event.
+	 */
+	ksve = list_first_entry_or_null(&vsdei->critical_events,
+			struct kvm_sdei_vcpu_event, link);
+	if (!ksve && !vsdei->normal_event) {
+		ksve = list_first_entry_or_null(&vsdei->normal_events,
+				struct kvm_sdei_vcpu_event, link);
+	}
+
+	if (!ksve)
+		goto unlock;
+
+	kske = ksve->kske;
+	kse = kske->kse;
+	if (kse->state.priority == SDEI_EVENT_PRIORITY_CRITICAL) {
+		vsdei->critical_event = ksve;
+		vsdei->state.critical_num = ksve->state.num;
+		regs = &vsdei->state.critical_regs;
+	} else {
+		vsdei->normal_event = ksve;
+		vsdei->state.normal_num = ksve->state.num;
+		regs = &vsdei->state.normal_regs;
+	}
+
+	/* Save registers: x0 -> x17, PC, PState */
+	for (index = 0; index < ARRAY_SIZE(regs->regs); index++)
+		regs->regs[index] = vcpu_get_reg(vcpu, index);
+
+	regs->pc = *vcpu_pc(vcpu);
+	regs->pstate = *vcpu_cpsr(vcpu);
+
+	/*
+	 * Inject SDEI event: x0 -> x3, PC, PState. We needn't take lock
+	 * for the KVM event as it can't be destroyed because of its
+	 * reference count.
+	 */
+	for (index = 0; index < ARRAY_SIZE(regs->regs); index++)
+		vcpu_set_reg(vcpu, index, 0);
+
+	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
+		vcpu->vcpu_idx : 0;
+	vcpu_set_reg(vcpu, 0, kske->state.num);
+	vcpu_set_reg(vcpu, 1, kske->state.params[index]);
+	vcpu_set_reg(vcpu, 2, regs->pc);
+	vcpu_set_reg(vcpu, 3, regs->pstate);
+
+	pstate = regs->pstate;
+	pstate |= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT);
+	pstate &= ~PSR_MODE_MASK;
+	pstate |= PSR_MODE_EL1h;
+	pstate &= ~PSR_MODE32_BIT;
+
+	vcpu_write_sys_reg(vcpu, regs->pstate, SPSR_EL1);
+	*vcpu_cpsr(vcpu) = pstate;
+	*vcpu_pc(vcpu) = kske->state.entries[index];
+
+unlock:
+	spin_unlock(&vsdei->lock);
+}
+
 void kvm_sdei_init_vm(struct kvm *kvm)
 {
 	struct kvm_sdei_kvm *ksdei;
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
