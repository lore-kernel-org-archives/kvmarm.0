Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAADC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:09:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 202DB49EEE;
	Tue, 22 Mar 2022 04:09:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sn2qAJlVoYap; Tue, 22 Mar 2022 04:09:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C747149EE1;
	Tue, 22 Mar 2022 04:09:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB68649ED3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:09:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qw4BZqGeOHKd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:09:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A515640FC0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:09:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936548;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=uBmvh5ZuowzkjTYHJM1SHAN/6NzyYtxJ4RrsdQ22jlY=;
 b=aLUaFly1ux6LGQ1eTncT6KeHnmjpE1epqkiqcaHWiOQ+rDs4rop0Z6huLA19kzGAaVBiCT
 mlS1jnsng0mescdGywBEDcFH8p+R0iTefMv1NwJKN5nTUq+PW+EQkyUCbQALQNLhlSQQ3O
 o0yMDlyjTmkTZ0qGyPSN+zP3QxXpOUI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-KasuIbuaPbesOOtic6uUbg-1; Tue, 22 Mar 2022 04:09:05 -0400
X-MC-Unique: KasuIbuaPbesOOtic6uUbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FB1B1044562;
 Tue, 22 Mar 2022 08:09:04 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F41401121324;
 Tue, 22 Mar 2022 08:08:58 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 09/22] KVM: arm64: Support SDEI_EVENT_GET_INFO hypercall
Date: Tue, 22 Mar 2022 16:06:57 +0800
Message-Id: <20220322080710.51727-10-gshan@redhat.com>
In-Reply-To: <20220322080710.51727-1-gshan@redhat.com>
References: <20220322080710.51727-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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

This supports SDEI_EVENT_GET_INFO hypercall. It's used by the guest
to retrieve various information about the exposed or registered event,
including type, signaled, routing mode and affinity. The routing
mode and affinity information is only valid to the shared and
registered event.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 73 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 5c43c8912ea1..4f26e5f70bff 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -494,6 +494,77 @@ static unsigned long hypercall_status(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long hypercall_info(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_exposed_event *exposed_event = NULL;
+	struct kvm_sdei_registered_event *registered_event = NULL;
+	unsigned long event_num = smccc_get_arg1(vcpu);
+	unsigned long event_info = smccc_get_arg2(vcpu);
+	int index;
+	unsigned long ret = SDEI_SUCCESS;
+
+	if (!kvm_sdei_is_supported(event_num)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	spin_lock(&ksdei->lock);
+
+	/*
+	 * Retrieve the information from the registered event if it exists.
+	 * Otherwise, we turn into the exposed event if needed.
+	 */
+	registered_event = find_registered_event(kvm, event_num);
+	exposed_event = registered_event ? registered_event->exposed_event :
+					   find_exposed_event(kvm, event_num);
+	if (!exposed_event) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock;
+	}
+
+	/* Retrieve the requested information */
+	switch (event_info) {
+	case SDEI_EVENT_INFO_EV_TYPE:
+		ret = exposed_event->state.type;
+		break;
+	case SDEI_EVENT_INFO_EV_SIGNALED:
+		ret = exposed_event->state.signaled;
+		break;
+	case SDEI_EVENT_INFO_EV_PRIORITY:
+		ret = exposed_event->state.priority;
+		break;
+	case SDEI_EVENT_INFO_EV_ROUTING_MODE:
+	case SDEI_EVENT_INFO_EV_ROUTING_AFF:
+		if (!kvm_sdei_is_shared(exposed_event->state.type)) {
+			ret = SDEI_INVALID_PARAMETERS;
+			break;
+		}
+
+		index = kvm_sdei_vcpu_index(vcpu, exposed_event);
+		if (!registered_event ||
+		    !kvm_sdei_is_registered(registered_event, index)) {
+			ret = SDEI_DENIED;
+			break;
+		}
+
+		if (event_info == SDEI_EVENT_INFO_EV_ROUTING_MODE)
+			ret = registered_event->state.route_mode;
+		else
+			ret = registered_event->state.route_affinity;
+
+		break;
+	default:
+		ret = SDEI_INVALID_PARAMETERS;
+	}
+
+unlock:
+	spin_unlock(&ksdei->lock);
+out:
+	return ret;
+}
+
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -543,6 +614,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = hypercall_status(vcpu);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
+		ret = hypercall_info(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
 	case SDEI_1_0_FN_SDEI_PE_MASK:
 	case SDEI_1_0_FN_SDEI_PE_UNMASK:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
