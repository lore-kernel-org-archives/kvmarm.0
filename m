Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28ECAC433B4
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:31:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A239861107
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A239861107
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45C944B552;
	Fri,  7 May 2021 02:31:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xez-Nib2wFhM; Fri,  7 May 2021 02:31:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20E194B56F;
	Fri,  7 May 2021 02:31:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E645B4B29A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:31:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e+o4df0MND9u for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:31:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3F284B486
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:31:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369111;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ubxkg7uim21uCK1vxap6rQ8RNDE8i62rIz2Zup72MRU=;
 b=N+e11+vdkTGqDQhS/1WqjlJppyIjDtRKGE2odyC6amlx9RTd5bcI77DSb5PCj+Kduu1Wan
 fV16t+03J1en1d3hXU/ZlK+y+nLIpUeQaBhqu2uwXOLH2EXEV8v9Q4V5ruRW6h8KcJhItB
 U2BZrMhMbyT95zsUPhkhyTlUruDo6tQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-eC-V8CEDOjyOrI7_CBcXSA-1; Fri, 07 May 2021 02:31:49 -0400
X-MC-Unique: eC-V8CEDOjyOrI7_CBcXSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA9AD1006C81;
 Fri,  7 May 2021 06:31:47 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 965005D9CA;
 Fri,  7 May 2021 06:31:44 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 04/21] KVM: arm64: Support SDEI_EVENT_REGISTER hypercall
Date: Fri,  7 May 2021 16:31:07 +0800
Message-Id: <20210507083124.43347-5-gshan@redhat.com>
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

This supports SDEI_EVENT_REGISTER hypercall, which is used by guest
to register SDEI events. The SDEI event won't be raised to the guest
or specific vCPU until it's registered and enabled explicitly.

Only those events that have been exported by KVM can be registered.
After the event is registered successfully, the KVM SDEI event (object)
is created or updated because the same KVM SDEI event is shared by
multiple vCPUs if it's a private event.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 122 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index aa9485f076a9..d3ea3eee154b 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -21,6 +21,20 @@ static struct kvm_sdei_event_state defined_kse[] = {
 	},
 };
 
+static struct kvm_sdei_event *kvm_sdei_find_event(struct kvm *kvm,
+						  unsigned long num)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_event *kse;
+
+	list_for_each_entry(kse, &ksdei->events, link) {
+		if (kse->state.num == num)
+			return kse;
+	}
+
+	return NULL;
+}
+
 static void kvm_sdei_remove_events(struct kvm *kvm)
 {
 	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
@@ -32,6 +46,20 @@ static void kvm_sdei_remove_events(struct kvm *kvm)
 	}
 }
 
+static struct kvm_sdei_kvm_event *kvm_sdei_find_kvm_event(struct kvm *kvm,
+							  unsigned long num)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_kvm_event *kske;
+
+	list_for_each_entry(kske, &ksdei->kvm_events, link) {
+		if (kske->state.num == num)
+			return kske;
+	}
+
+	return NULL;
+}
+
 static void kvm_sdei_remove_kvm_events(struct kvm *kvm,
 				       unsigned int mask,
 				       bool force)
@@ -86,6 +114,98 @@ static unsigned long kvm_sdei_hypercall_version(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long kvm_sdei_hypercall_register(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *kse = NULL;
+	struct kvm_sdei_kvm_event *kske = NULL;
+	unsigned long event_num = smccc_get_arg1(vcpu);
+	unsigned long event_entry = smccc_get_arg2(vcpu);
+	unsigned long event_param = smccc_get_arg3(vcpu);
+	unsigned long route_mode = smccc_get_arg4(vcpu);
+	unsigned long route_affinity = smccc_get_arg5(vcpu);
+	int index = vcpu->vcpu_idx;
+	unsigned long ret = SDEI_SUCCESS;
+
+	/* Sanity check */
+	if (!(ksdei && vsdei)) {
+		ret = SDEI_NOT_SUPPORTED;
+		goto out;
+	}
+
+	if (!kvm_sdei_is_valid_event_num(event_num)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	if (!(route_mode == SDEI_EVENT_REGISTER_RM_ANY ||
+	      route_mode == SDEI_EVENT_REGISTER_RM_PE)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	/*
+	 * The KVM event could have been created if it's a private event.
+	 * We needn't create a KVM event in this case.
+	 */
+	spin_lock(&ksdei->lock);
+	kske = kvm_sdei_find_kvm_event(kvm, event_num);
+	if (kske) {
+		kse = kske->kse;
+		index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
+			vcpu->vcpu_idx : 0;
+
+		if (kvm_sdei_is_registered(kske, index)) {
+			ret = SDEI_DENIED;
+			goto unlock;
+		}
+
+		kske->state.route_mode     = route_mode;
+		kske->state.route_affinity = route_affinity;
+		kske->state.entries[index] = event_entry;
+		kske->state.params[index]  = event_param;
+		kvm_sdei_set_registered(kske, index);
+		goto unlock;
+	}
+
+	/* Check if the event number has been registered */
+	kse = kvm_sdei_find_event(kvm, event_num);
+	if (!kse) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock;
+	}
+
+	/* Create KVM event */
+	kske = kzalloc(sizeof(*kske), GFP_KERNEL);
+	if (!kske) {
+		ret = SDEI_OUT_OF_RESOURCE;
+		goto unlock;
+	}
+
+	/* Initialize KVM event state */
+	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
+		vcpu->vcpu_idx : 0;
+	kske->state.num            = event_num;
+	kske->state.refcount       = 0;
+	kske->state.route_mode     = route_affinity;
+	kske->state.route_affinity = route_affinity;
+	kske->state.entries[index] = event_entry;
+	kske->state.params[index] = event_param;
+	kvm_sdei_set_registered(kske, index);
+
+	/* Initialize KVM event */
+	kske->kse = kse;
+	kske->kvm = kvm;
+	list_add_tail(&kske->link, &ksdei->kvm_events);
+
+unlock:
+	spin_unlock(&ksdei->lock);
+out:
+	return ret;
+}
+
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 {
 	u32 func = smccc_get_function(vcpu);
@@ -97,6 +217,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_sdei_hypercall_version(vcpu);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
+		ret = kvm_sdei_hypercall_register(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
 	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
 	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
