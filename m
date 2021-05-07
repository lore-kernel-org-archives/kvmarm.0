Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1D9C433ED
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:32:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0FBF1613EC
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FBF1613EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9784B576;
	Fri,  7 May 2021 02:32:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DCl-awXTb5j2; Fri,  7 May 2021 02:32:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 127234B4A5;
	Fri,  7 May 2021 02:32:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B604F4B29A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:32:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id puT8SzWXBlUl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:32:46 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B97C24B584
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:32:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369166;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=fi7wCLp+ftQbYw5nXsnZAApC20vNSZGkc12Mn6MDQtw=;
 b=e23zHpnN5+BurkN612h95ywTs8uggwIIpAFhwPD15Z+IBILH/7mxY11JxuX/W/+/ljST9W
 fcnidvC6NHTpDul3X9bs1p/YQkyicduuwNOfgUKTDN2lSOc9ZF1DG6pqKajdLcfabBLp9A
 qHrPWFHdh/fRwV3WZb5YmaPd4VnJooQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-zsIgVIr1M8a2lDQuldyROg-1; Fri, 07 May 2021 02:32:45 -0400
X-MC-Unique: zsIgVIr1M8a2lDQuldyROg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E347C801817;
 Fri,  7 May 2021 06:32:43 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B0BD55D9CA;
 Fri,  7 May 2021 06:32:40 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 18/21] KVM: arm64: Support SDEI event injection
Date: Fri,  7 May 2021 16:31:21 +0800
Message-Id: <20210507083124.43347-19-gshan@redhat.com>
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

This supports SDEI event injection by implementing kvm_sdei_inject().
It's called by kernel directly or VMM through ioctl command to inject
SDEI event to the specific vCPU.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_sdei.h      |   2 +
 arch/arm64/include/uapi/asm/kvm_sdei.h |   1 +
 arch/arm64/kvm/sdei.c                  | 108 +++++++++++++++++++++++++
 3 files changed, 111 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index a997989bab77..51087fe971ba 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -124,6 +124,8 @@ void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
 int kvm_sdei_register_notifier(struct kvm *kvm, unsigned long num,
 			       kvm_sdei_notifier notifier);
+int kvm_sdei_inject(struct kvm_vcpu *vcpu,
+		    unsigned long num, bool immediate);
 void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
 long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg);
 long kvm_sdei_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long arg);
diff --git a/arch/arm64/include/uapi/asm/kvm_sdei.h b/arch/arm64/include/uapi/asm/kvm_sdei.h
index 1e96dbe2aa6f..a3703ead9dac 100644
--- a/arch/arm64/include/uapi/asm/kvm_sdei.h
+++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
@@ -67,6 +67,7 @@ struct kvm_sdei_vcpu_state {
 #define KVM_SDEI_CMD_SET_VEVENT			7
 #define KVM_SDEI_CMD_GET_VCPU_STATE		8
 #define KVM_SDEI_CMD_SET_VCPU_STATE		9
+#define KVM_SDEI_CMD_INJECT_EVENT		10
 
 struct kvm_sdei_cmd {
 	__u32						cmd;
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 79315b77f24b..7c2789cd1421 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -802,6 +802,111 @@ int kvm_sdei_register_notifier(struct kvm *kvm,
 	return ret;
 }
 
+int kvm_sdei_inject(struct kvm_vcpu *vcpu,
+		    unsigned long num,
+		    bool immediate)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *kse = NULL;
+	struct kvm_sdei_kvm_event *kske = NULL;
+	struct kvm_sdei_vcpu_event *ksve = NULL;
+	int index, ret = 0;
+
+	/* Sanity check */
+	if (!(ksdei && vsdei)) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	if (!kvm_sdei_is_valid_event_num(num)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Check the kvm event */
+	spin_lock(&ksdei->lock);
+	kske = kvm_sdei_find_kvm_event(kvm, num);
+	if (!kske) {
+		ret = -ENOENT;
+		goto unlock_kvm;
+	}
+
+	kse = kske->kse;
+	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
+		vcpu->vcpu_idx : 0;
+	if (!(kvm_sdei_is_registered(kske, index) &&
+	      kvm_sdei_is_enabled(kske, index))) {
+		ret = -EPERM;
+		goto unlock_kvm;
+	}
+
+	/* Check the vcpu state */
+	spin_lock(&vsdei->lock);
+	if (vsdei->state.masked) {
+		ret = -EPERM;
+		goto unlock_vcpu;
+	}
+
+	/* Check if the event can be delivered immediately */
+	if (immediate) {
+		if (kse->state.priority == SDEI_EVENT_PRIORITY_CRITICAL &&
+		    !list_empty(&vsdei->critical_events)) {
+			ret = -ENOSPC;
+			goto unlock_vcpu;
+		}
+
+		if (kse->state.priority == SDEI_EVENT_PRIORITY_NORMAL &&
+		    (!list_empty(&vsdei->critical_events) ||
+		     !list_empty(&vsdei->normal_events))) {
+			ret = -ENOSPC;
+			goto unlock_vcpu;
+		}
+	}
+
+	/* Check if the vcpu event exists */
+	ksve = kvm_sdei_find_vcpu_event(vcpu, num);
+	if (ksve) {
+		kske->state.refcount++;
+		ksve->state.refcount++;
+		kvm_make_request(KVM_REQ_SDEI, vcpu);
+		goto unlock_vcpu;
+	}
+
+	/* Allocate vcpu event */
+	ksve = kzalloc(sizeof(*ksve), GFP_KERNEL);
+	if (!ksve) {
+		ret = -ENOMEM;
+		goto unlock_vcpu;
+	}
+
+	/*
+	 * We should take lock to update KVM event state because its
+	 * reference count might be zero. In that case, the KVM event
+	 * could be destroyed.
+	 */
+	kske->state.refcount++;
+	ksve->state.num      = num;
+	ksve->state.refcount = 1;
+	ksve->kske           = kske;
+	ksve->vcpu           = vcpu;
+
+	if (kse->state.priority == SDEI_EVENT_PRIORITY_CRITICAL)
+		list_add_tail(&ksve->link, &vsdei->critical_events);
+	else
+		list_add_tail(&ksve->link, &vsdei->normal_events);
+
+	kvm_make_request(KVM_REQ_SDEI, vcpu);
+
+unlock_vcpu:
+	spin_unlock(&vsdei->lock);
+unlock_kvm:
+	spin_unlock(&ksdei->lock);
+out:
+	return ret;
+}
+
 void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1317,6 +1422,9 @@ long kvm_sdei_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long arg)
 	case KVM_SDEI_CMD_SET_VCPU_STATE:
 		ret = kvm_sdei_set_vcpu_state(vcpu, &cmd->ksv_state);
 		break;
+	case KVM_SDEI_CMD_INJECT_EVENT:
+		ret = kvm_sdei_inject(vcpu, cmd->num, false);
+		break;
 	default:
 		ret = -EINVAL;
 	}
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
