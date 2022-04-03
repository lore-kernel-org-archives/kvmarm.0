Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EE5C433EF
	for <kvmarm@archiver.kernel.org>; Sun,  3 Apr 2022 15:40:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6FE4B1BA;
	Sun,  3 Apr 2022 11:40:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oNg8fzipUI2v; Sun,  3 Apr 2022 11:40:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0828C4B120;
	Sun,  3 Apr 2022 11:40:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E0A749EEB
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 79nLhKyt4r6A for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 11:40:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 186EA49EC5
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649000425;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Pn4EoSXxKWdxPpq8ePbbzOyFgR8TeWIqlRshEfr0Kec=;
 b=U/4PWQm9Rfnpez0n+XCfPgUh5MWYhYVT0IuE6e1DHdRxJMAB25fBLp5f909n5ywrthOLmm
 JFGwW9s565hLlZXjNaITDQF+kewVsUQj0s2d1KLhySW3dlVAe5WDLX+UJ7iVqtPun72jzN
 1zRlgWvoXJdl5LVt62QbeTLWAx08ZHg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-KkgMQLitNuywmJgU6GIQKw-1; Sun, 03 Apr 2022 11:40:20 -0400
X-MC-Unique: KkgMQLitNuywmJgU6GIQKw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CFE385A5A8;
 Sun,  3 Apr 2022 15:40:20 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-82.pek2.redhat.com [10.72.12.82])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E99B4538D7;
 Sun,  3 Apr 2022 15:40:13 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 07/18] KVM: arm64: Support SDEI_EVENT_UNREGISTER hypercall
Date: Sun,  3 Apr 2022 23:39:00 +0800
Message-Id: <20220403153911.12332-8-gshan@redhat.com>
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

This supports SDEI_EVENT_UNREGISTER hypercall. It's used by the
guest to unregister event. The event is disabled automatically
and won't be delivered to guest after unregistration.

If the event is being serviced or handled, we can't unregister
it immediately. Instead, the unregistration pending state is
set for the event and it's unregistered when the event handler
is to finish by calling SDEI_EVENT_{COMPLETE, COMPLETE_AND_RESUME}
hypercall.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 79 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index af5d11b8eb2f..f774f2cf0ac7 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -45,6 +45,48 @@ static struct kvm_sdei_event *find_event(struct kvm_vcpu *vcpu,
 	return NULL;
 }
 
+static int reset_event(struct kvm_vcpu *vcpu,
+		       struct kvm_sdei_event *event)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_context *context;
+	struct kvm_sdei_exposed_event *exposed_event;
+
+	/* Check if the event has been pending for unregistration */
+	if (kvm_sdei_is_unregister_pending(event))
+		return -EAGAIN;
+
+	/*
+	 * If the event is being handled, we should set the unregistration
+	 * pending state for it. The event will be unregistered after the
+	 * event handler is to finish.
+	 */
+	exposed_event = event->exposed_event;
+	context = kvm_sdei_is_critical(exposed_event->priority) ?
+		  &vsdei->context[SDEI_EVENT_PRIORITY_CRITICAL] :
+		  &vsdei->context[SDEI_EVENT_PRIORITY_NORMAL];
+	if (context->event == event) {
+		kvm_sdei_set_unregister_pending(event);
+		return -EBUSY;
+	}
+
+	/*
+	 * The event is ready to be unregistered. The event is disabled
+	 * when it's unregistered. The pending events should be cancelled
+	 * either.
+	 */
+	if (kvm_sdei_is_critical(exposed_event->priority))
+		vsdei->critical_event_count -= event->event_count;
+	else
+		vsdei->normal_event_count -= event->event_count;
+
+	event->event_count = 0;
+	kvm_sdei_clear_enabled(event);
+	kvm_sdei_clear_registered(event);
+
+	return 0;
+}
+
 static unsigned long hypercall_register(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -171,6 +213,40 @@ static unsigned long hypercall_context(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long hypercall_unregister(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *event;
+	unsigned int num = smccc_get_arg(vcpu, 1);
+	unsigned long ret = SDEI_SUCCESS;
+
+	if (!kvm_sdei_is_supported(num))
+		return SDEI_INVALID_PARAMETERS;
+
+	spin_lock(&vsdei->lock);
+
+	/* Check if the event exists */
+	event = find_event(vcpu, num);
+	if (!event) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock;
+	}
+
+	/* Check if the event has been registered */
+	if (!kvm_sdei_is_registered(event)) {
+		ret = SDEI_DENIED;
+		goto unlock;
+	}
+
+	if (reset_event(vcpu, event))
+		ret = SDEI_PENDING;
+
+unlock:
+	spin_unlock(&vsdei->lock);
+
+	return ret;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -204,6 +280,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
 		ret = hypercall_context(vcpu);
 		break;
+	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
+		ret = hypercall_unregister(vcpu);
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
