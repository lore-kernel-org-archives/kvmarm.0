Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CECC43461
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:32:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 561B1613ED
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:32:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 561B1613ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA73E4B4BE;
	Fri,  7 May 2021 02:32:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4np+MP2AGXNd; Fri,  7 May 2021 02:32:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A59804B2C2;
	Fri,  7 May 2021 02:32:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EA624B584
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:32:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qeHKfoRimdnx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:32:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F9CF4B29A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:32:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369157;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OWRQNAAvEJAGDBngbg1zVPusvys42/BilG2w2bU7UFw=;
 b=GX5ldfsxHw6R8Ax4ZpaJRaOPNZDlicfxZfQL0APuSYcL2f7HnaDhyCfki5Uhm/vML7FI25
 JCDBA0GUn+okUjrVHFsQ1E9Qdsg0PLxiyDDaef8fdF6JfVETlylJJT8HY0KHCnFIs73EkN
 qN8O1V7MV1BXxLv9Hh7ZQaUiJcDcKVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-klKbWkNqOaKfdu551ngxJA-1; Fri, 07 May 2021 02:32:34 -0400
X-MC-Unique: klKbWkNqOaKfdu551ngxJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0E1B195D560;
 Fri,  7 May 2021 06:32:32 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A24E55D9CA;
 Fri,  7 May 2021 06:32:29 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 15/21] KVM: arm64: Support SDEI event notifier
Date: Fri,  7 May 2021 16:31:18 +0800
Message-Id: <20210507083124.43347-16-gshan@redhat.com>
In-Reply-To: <20210507083124.43347-1-gshan@redhat.com>
References: <20210507083124.43347-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, will@kernel.org
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

The owner of the SDEI event, like asynchronous page fault, need
know the state of injected SDEI event. This supports SDEI event
state updating by introducing notifier mechanism. It's notable
the notifier (handler) should be capable of migration.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_sdei.h      | 12 +++++++
 arch/arm64/include/uapi/asm/kvm_sdei.h |  1 +
 arch/arm64/kvm/sdei.c                  | 45 +++++++++++++++++++++++++-
 3 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index 7f5f5ad689e6..19f2d9b91f85 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -16,6 +16,16 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
+struct kvm_vcpu;
+
+typedef void (*kvm_sdei_notifier)(struct kvm_vcpu *vcpu,
+				  unsigned long num,
+				  unsigned int state);
+enum {
+	KVM_SDEI_NOTIFY_DELIVERED,
+	KVM_SDEI_NOTIFY_COMPLETED,
+};
+
 struct kvm_sdei_event {
 	struct kvm_sdei_event_state		state;
 	struct kvm				*kvm;
@@ -112,6 +122,8 @@ KVM_SDEI_FLAG_FUNC(enabled)
 void kvm_sdei_init_vm(struct kvm *kvm);
 void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
+int kvm_sdei_register_notifier(struct kvm *kvm, unsigned long num,
+			       kvm_sdei_notifier notifier);
 void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
 void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu);
 void kvm_sdei_destroy_vm(struct kvm *kvm);
diff --git a/arch/arm64/include/uapi/asm/kvm_sdei.h b/arch/arm64/include/uapi/asm/kvm_sdei.h
index 2961a79b8a69..78ff26e49ee6 100644
--- a/arch/arm64/include/uapi/asm/kvm_sdei.h
+++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
@@ -23,6 +23,7 @@ struct kvm_sdei_event_state {
 	__u8	type;
 	__u8	signaled;
 	__u8	priority;
+	__u64	notifier;
 };
 
 struct kvm_sdei_kvm_event_state {
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 1e8e213c9d70..5f7a37dcaa77 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -314,9 +314,11 @@ static unsigned long kvm_sdei_hypercall_complete(struct kvm_vcpu *vcpu,
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *kse = NULL;
 	struct kvm_sdei_kvm_event *kske = NULL;
 	struct kvm_sdei_vcpu_event *ksve = NULL;
 	struct kvm_sdei_vcpu_regs *regs;
+	kvm_sdei_notifier notifier;
 	unsigned long ret = SDEI_SUCCESS;
 	int index;
 
@@ -349,6 +351,13 @@ static unsigned long kvm_sdei_hypercall_complete(struct kvm_vcpu *vcpu,
 	*vcpu_cpsr(vcpu) = regs->pstate;
 	*vcpu_pc(vcpu) = regs->pc;
 
+	/* Notifier */
+	kske = ksve->kske;
+	kse = kske->kse;
+	notifier = (kvm_sdei_notifier)(kse->state.notifier);
+	if (notifier)
+		notifier(vcpu, kse->state.num, KVM_SDEI_NOTIFY_COMPLETED);
+
 	/* Inject interrupt if needed */
 	if (resume)
 		kvm_inject_irq(vcpu);
@@ -358,7 +367,6 @@ static unsigned long kvm_sdei_hypercall_complete(struct kvm_vcpu *vcpu,
 	 * event state as it's not destroyed because of the reference
 	 * count.
 	 */
-	kske = ksve->kske;
 	ksve->state.refcount--;
 	kske->state.refcount--;
 	if (!ksve->state.refcount) {
@@ -746,6 +754,35 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+int kvm_sdei_register_notifier(struct kvm *kvm,
+			       unsigned long num,
+			       kvm_sdei_notifier notifier)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_event *kse = NULL;
+	int ret = 0;
+
+	if (!ksdei) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	spin_lock(&ksdei->lock);
+
+	kse = kvm_sdei_find_event(kvm, num);
+	if (!kse) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	kse->state.notifier = (unsigned long)notifier;
+
+unlock:
+	spin_unlock(&ksdei->lock);
+out:
+	return ret;
+}
+
 void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -755,6 +792,7 @@ void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
 	struct kvm_sdei_kvm_event *kske = NULL;
 	struct kvm_sdei_vcpu_event *ksve = NULL;
 	struct kvm_sdei_vcpu_regs *regs = NULL;
+	kvm_sdei_notifier notifier;
 	unsigned long pstate;
 	int index = 0;
 
@@ -826,6 +864,11 @@ void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
 	*vcpu_cpsr(vcpu) = pstate;
 	*vcpu_pc(vcpu) = kske->state.entries[index];
 
+	/* Notifier */
+	notifier = (kvm_sdei_notifier)(kse->state.notifier);
+	if (notifier)
+		notifier(vcpu, kse->state.num, KVM_SDEI_NOTIFY_DELIVERED);
+
 unlock:
 	spin_unlock(&vsdei->lock);
 }
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
