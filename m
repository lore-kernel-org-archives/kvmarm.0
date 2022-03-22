Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86920C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:08:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CD7240BE7;
	Tue, 22 Mar 2022 04:08:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iEfxByfcaThE; Tue, 22 Mar 2022 04:08:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1AF840FD6;
	Tue, 22 Mar 2022 04:08:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3860B40431
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:08:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S6DPQBopfX9K for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:08:29 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB6D140465
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:08:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936509;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XwXLs2x0k3sHxPIhNa8hpQ1441Z7oOsOWyaaI8W2j5s=;
 b=DywhHKAMETGUUY5oncdplq4T0fJsqQ3dv/7BavOwah945rr1ZgAFCJ2Qm/ttqepsavcnqW
 gwzeHUbl/Oau3SxcTB2PnXNORaI1MMSi0szQOL6QfffC1WmMcRORitGw1GhixaiUf9r/7Y
 FqoVCVXDwRnk41hj32c/A+GHh1P7Xr0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-eyCSNExZP8-7hhveFCSmRw-1; Tue, 22 Mar 2022 04:08:26 -0400
X-MC-Unique: eyCSNExZP8-7hhveFCSmRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1BA6185A79C;
 Tue, 22 Mar 2022 08:08:25 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E00A21121324;
 Tue, 22 Mar 2022 08:08:14 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 04/22] KVM: arm64: Support SDEI_EVENT_REGISTER hypercall
Date: Tue, 22 Mar 2022 16:06:52 +0800
Message-Id: <20220322080710.51727-5-gshan@redhat.com>
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

This supports SDEI_EVENT_REGISTER hypercall, which is used by guest
to register SDEI events. The SDEI event won't be raised until it's
registered and enabled explicitly.

Only the exposed events can be registered. For shared event, the
registered event instance is created. However, the instance may be
not created for the private events.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 128 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 5a3a64cd6e84..2458dc666445 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -14,6 +14,35 @@
 #include <kvm/arm_hypercalls.h>
 #include <asm/kvm_sdei.h>
 
+static struct kvm_sdei_exposed_event *
+find_exposed_event(struct kvm *kvm, unsigned long num)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_exposed_event *exposed_event;
+
+	list_for_each_entry(exposed_event, &ksdei->exposed_events, link) {
+		if (exposed_event->state.num == num)
+			return exposed_event;
+	}
+
+	return NULL;
+}
+
+static struct kvm_sdei_registered_event *
+find_registered_event(struct kvm *kvm, unsigned long num)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_registered_event *registered_event;
+
+	list_for_each_entry(registered_event,
+			    &ksdei->registered_events, link) {
+		if (registered_event->state.num == num)
+			return registered_event;
+	}
+
+	return NULL;
+}
+
 static void remove_all_exposed_events(struct kvm *kvm)
 {
 	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
@@ -126,6 +155,103 @@ static unsigned long hypercall_version(struct kvm_vcpu *vcpu)
 	       0x4b564d;
 }
 
+static unsigned long hypercall_register(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_exposed_event *exposed_event;
+	struct kvm_sdei_registered_event *registered_event;
+	unsigned long event_num = smccc_get_arg1(vcpu);
+	unsigned long event_ep_address = smccc_get_arg2(vcpu);
+	unsigned long event_ep_arg = smccc_get_arg3(vcpu);
+	unsigned long route_mode = smccc_get_arg4(vcpu);
+	unsigned long route_affinity = smccc_get_arg5(vcpu);
+	int index;
+	unsigned long ret = SDEI_SUCCESS;
+
+	if (!kvm_sdei_is_supported(event_num)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	if (route_mode != SDEI_EVENT_REGISTER_RM_ANY &&
+	    route_mode != SDEI_EVENT_REGISTER_RM_PE) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	spin_lock(&ksdei->lock);
+
+	/*
+	 * The registered event could have been existing if it's a private
+	 * one. We needn't to create another registered event instance
+	 * in this case.
+	 */
+	registered_event = find_registered_event(kvm, event_num);
+	if (registered_event) {
+		exposed_event = registered_event->exposed_event;
+		index = kvm_sdei_vcpu_index(vcpu, exposed_event);
+		if (kvm_sdei_is_registered(registered_event, index) ||
+		    kvm_sdei_is_unregister_pending(registered_event, index)) {
+			ret = SDEI_DENIED;
+			goto unlock;
+		}
+
+		registered_event->state.route_mode        = route_mode;
+		registered_event->state.route_affinity    = route_affinity;
+		registered_event->state.ep_address[index] = event_ep_address;
+		registered_event->state.ep_arg[index]     = event_ep_arg;
+		kvm_sdei_set_registered(registered_event, index);
+		goto unlock;
+	}
+
+	/* Check if the exposed event exists */
+	exposed_event = find_exposed_event(kvm, event_num);
+	if (!exposed_event) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock;
+	}
+
+	/*
+	 * Check if the count of registered event instances exceeds
+	 * the limit.
+	 */
+	if (ksdei->registered_event_count >= KVM_SDEI_MAX_EVENTS) {
+		ret = SDEI_OUT_OF_RESOURCE;
+		goto unlock;
+	}
+
+	/* Allocate the registered event instance */
+	registered_event = kzalloc(sizeof(*registered_event),
+				   GFP_KERNEL_ACCOUNT);
+	if (!registered_event) {
+		ret = SDEI_OUT_OF_RESOURCE;
+		goto unlock;
+	}
+
+	/* Initialize the registered event state */
+	index = kvm_sdei_vcpu_index(vcpu, exposed_event);
+	registered_event->state.num               = event_num;
+	registered_event->state.route_mode        = route_affinity;
+	registered_event->state.route_affinity    = route_affinity;
+	registered_event->state.ep_address[index] = event_ep_address;
+	registered_event->state.ep_arg[index]     = event_ep_arg;
+	registered_event->kvm                     = kvm;
+	registered_event->exposed_event           = exposed_event;
+	registered_event->vcpu_event_count        = 0;
+	kvm_sdei_set_registered(registered_event, index);
+
+	/* Add the registered event instance */
+	ksdei->registered_event_count++;
+	exposed_event->registered_event_count++;
+	list_add_tail(&registered_event->link, &ksdei->registered_events);
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
@@ -153,6 +279,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = hypercall_version(vcpu);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
+		ret = hypercall_register(vcpu);
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
