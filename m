Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC68C433EF
	for <kvmarm@archiver.kernel.org>; Sun,  3 Apr 2022 15:40:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9714C4B1B5;
	Sun,  3 Apr 2022 11:40:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g6UY2x9PRJar; Sun,  3 Apr 2022 11:40:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DB5A4B192;
	Sun,  3 Apr 2022 11:40:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FB894A0FE
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dZ4JzCCKRd6R for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 11:40:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1746749EC5
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649000404;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9lEo1vYagHbuDvOHHz7jGfQGWnUXmF26JqdCfdJr4Xk=;
 b=WyEptZain2/z3XgWHGcj4amjgghiLW5411oVgmp+KotzJnEmbbtl9dJvT580db2TnJTgNl
 yjIpL6N6FAMWtV5UfpyTeTHgNX4GWXwZTSD4z5b0FMr/vuvmiJV44Ofw/ZsRk8FuvN7R8n
 03mfap+9tv5pVcxSc2dF4cDaaoyIwvQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-iVS-vYIFO2CGM-WfXn9xhw-1; Sun, 03 Apr 2022 11:40:00 -0400
X-MC-Unique: iVS-vYIFO2CGM-WfXn9xhw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC5CB2999B23;
 Sun,  3 Apr 2022 15:39:59 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-82.pek2.redhat.com [10.72.12.82])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B66F9403172;
 Sun,  3 Apr 2022 15:39:53 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 04/18] KVM: arm64: Support SDEI_EVENT_REGISTER hypercall
Date: Sun,  3 Apr 2022 23:38:57 +0800
Message-Id: <20220403153911.12332-5-gshan@redhat.com>
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

This supports SDEI_EVENT_REGISTER hypercall, which is used by guest
to register event. The event won't be raised until it's registered
and enabled. For those KVM owned events, they can't be registered
if they aren't exposed.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 78 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 3507e33ec00e..89c1b231cb60 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -25,6 +25,81 @@ static struct kvm_sdei_exposed_event exposed_events[] = {
 	for (idx = 0, event = &exposed_events[0];	\
 	     idx < ARRAY_SIZE(exposed_events);		\
 	     idx++, event++)
+#define kvm_sdei_for_each_event(vsdei, event, idx)	\
+	for (idx = 0, event = &vsdei->events[0];	\
+	     idx < ARRAY_SIZE(exposed_events);		\
+	     idx++, event++)
+
+static struct kvm_sdei_event *find_event(struct kvm_vcpu *vcpu,
+					 unsigned int num)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *event;
+	int i;
+
+	kvm_sdei_for_each_event(vsdei, event, i) {
+		if (event->exposed_event->num == num)
+			return event;
+	}
+
+	return NULL;
+}
+
+static unsigned long hypercall_register(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *event;
+	unsigned int num = smccc_get_arg(vcpu, 1);
+	unsigned long ep_address = smccc_get_arg(vcpu, 2);
+	unsigned long ep_arg = smccc_get_arg(vcpu, 3);
+	unsigned long route_mode = smccc_get_arg(vcpu, 4);
+	unsigned long route_affinity = smccc_get_arg(vcpu, 5);
+	unsigned long ret = SDEI_SUCCESS;
+
+	if (!kvm_sdei_is_supported(num)) {
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
+	spin_lock(&vsdei->lock);
+
+	/*
+	 * The event should have been existing. Otherwise, the event
+	 * isn't exposed yet.
+	 */
+	event = find_event(vcpu, num);
+	if (!event) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock;
+	}
+
+	/*
+	 * Check if the event has been registered or pending for
+	 * unregistration.
+	 */
+	if (kvm_sdei_is_registered(event) ||
+	    kvm_sdei_is_unregister_pending(event)) {
+		ret = SDEI_DENIED;
+		goto unlock;
+	}
+
+	event->route_mode     = route_mode;
+	event->route_affinity = route_affinity;
+	event->ep_address     = ep_address;
+	event->ep_arg         = ep_arg;
+	kvm_sdei_set_registered(event);
+
+unlock:
+	spin_unlock(&vsdei->lock);
+out:
+	return ret;
+}
 
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
@@ -47,6 +122,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	}
 
 	switch (func) {
+	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
+		ret = hypercall_register(vcpu);
+		break;
 	default:
 		ret = SDEI_NOT_SUPPORTED;
 	}
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
