Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FD1C432BE
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:15:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 600F46103A
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:15:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 600F46103A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14B2E4A198;
	Sat, 14 Aug 2021 20:15:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ft6r7Jiz8iqp; Sat, 14 Aug 2021 20:15:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37E604A4A3;
	Sat, 14 Aug 2021 20:15:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC06E4B0C6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:15:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cnIdpaIx-vSK for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 20:15:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9AAF4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:15:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628986551;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hVwwKdXnrlF17rr7ICUpWrckXNK7bZs/jTIpWezDxag=;
 b=WUl8crgk+HNQgT4MOjY8JsdO0EU1iS/VgNJS7ED3/op3NVqKP5DYOZxXDVMb/8kxxznUp5
 2tPTv/nAQ1pasp3Aode41uGiXRsZVJOf7+IQmlp+w5hIf6PTXJj2VA1ecD8gNRLARm7Xv0
 XswcpYASHV4kQjVDpGgHfPrqV3NpR7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-TEb3jDiwMryKxv77RlimrA-1; Sat, 14 Aug 2021 20:15:48 -0400
X-MC-Unique: TEb3jDiwMryKxv77RlimrA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35EB21008061;
 Sun, 15 Aug 2021 00:15:47 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 224F010074E1;
 Sun, 15 Aug 2021 00:15:42 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 19/21] KVM: arm64: Support SDEI event cancellation
Date: Sun, 15 Aug 2021 08:13:50 +0800
Message-Id: <20210815001352.81927-20-gshan@redhat.com>
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
