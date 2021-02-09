Return-Path: <SRS0=2BI6=HL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15747C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 03:29:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B2C564EBD
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 03:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B2C564EBD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3148D4B70A;
	Mon,  8 Feb 2021 22:29:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id znqYNPtwQ5l9; Mon,  8 Feb 2021 22:29:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 319F44B713;
	Mon,  8 Feb 2021 22:29:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF93B4B525
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 22:29:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qM+6DfrBGvd8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 22:29:15 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 065E04B665
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 22:29:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612841354;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hVwwKdXnrlF17rr7ICUpWrckXNK7bZs/jTIpWezDxag=;
 b=Ic0BEnWE3ufwY5TPoku4qwrBnznWkd6gaf3GWwF42cwzK1KNEY3Jm24jhPlcLauxyqy0Rg
 EZXXlDEquxg1LFLk1kzg3rpkeiBRGZsslNfnK8FzgEy2ZHAchDsGMqw2zLMTsBc5j1Viqh
 TMxGgXcx8I3oCSwp6CZDxfnsBZm8paw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-RiIJkcjmNh2lxHNK6K1daQ-1; Mon, 08 Feb 2021 22:29:13 -0500
X-MC-Unique: RiIJkcjmNh2lxHNK6K1daQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61D02801965;
 Tue,  9 Feb 2021 03:29:11 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-26.bne.redhat.com [10.64.54.26])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8A7C119C66;
 Tue,  9 Feb 2021 03:29:08 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 19/21] KVM: arm64: Support SDEI event cancellation
Date: Tue,  9 Feb 2021 11:27:31 +0800
Message-Id: <20210209032733.99996-20-gshan@redhat.com>
In-Reply-To: <20210209032733.99996-1-gshan@redhat.com>
References: <20210209032733.99996-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

The injected SDEI event is to send notification to guest. The SDEI
event might not be needed after it's injected. This introduces API
to support cancellation on the injected SDEI event if it's not fired
to the guest yet.

This mechanism will be needed when we're going to support asynchronous
page fault.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_sdei.h |  1 +
 arch/arm64/kvm/sdei.c             | 49 +++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index 51087fe971ba..353744c7bad9 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -126,6 +126,7 @@ int kvm_sdei_register_notifier(struct kvm *kvm, unsigned long num,
 			       kvm_sdei_notifier notifier);
 int kvm_sdei_inject(struct kvm_vcpu *vcpu,
 		    unsigned long num, bool immediate);
+int kvm_sdei_cancel(struct kvm_vcpu *vcpu, unsigned long num);
 void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
 long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg);
 long kvm_sdei_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long arg);
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 7c2789cd1421..4f5a582daa97 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -907,6 +907,55 @@ int kvm_sdei_inject(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+int kvm_sdei_cancel(struct kvm_vcpu *vcpu, unsigned long num)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_kvm_event *kske = NULL;
+	struct kvm_sdei_vcpu_event *ksve = NULL;
+	int ret = 0;
+
+	if (!(ksdei && vsdei)) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	/* Find the vCPU event */
+	spin_lock(&vsdei->lock);
+	ksve = kvm_sdei_find_vcpu_event(vcpu, num);
+	if (!ksve) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	/* Event can't be cancelled if it has been delivered */
+	if (ksve->state.refcount <= 1 &&
+	    (vsdei->critical_event == ksve ||
+	     vsdei->normal_event == ksve)) {
+		ret = -EINPROGRESS;
+		goto unlock;
+	}
+
+	/* Free the vCPU event if necessary */
+	kske = ksve->kske;
+	ksve->state.refcount--;
+	if (!ksve->state.refcount) {
+		list_del(&ksve->link);
+		kfree(ksve);
+	}
+
+unlock:
+	spin_unlock(&vsdei->lock);
+	if (kske) {
+		spin_lock(&ksdei->lock);
+		kske->state.refcount--;
+		spin_unlock(&ksdei->lock);
+	}
+out:
+	return ret;
+}
+
 void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
