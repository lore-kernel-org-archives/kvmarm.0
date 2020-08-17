Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCB1C433E3
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F05C62067C
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cU0f9lDO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F05C62067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F9464BD3E;
	Mon, 17 Aug 2020 06:06:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UeNkYnU6JIWt; Mon, 17 Aug 2020 06:06:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 733874C012;
	Mon, 17 Aug 2020 06:06:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C49C24BF3E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 798xYdtXe9+7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:06:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD82A4BD3E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658791;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lNpUD9rj1BzEVuB3mP7nxLNsh956qK/LB2eVVr4bang=;
 b=cU0f9lDOIVkLmV9RhOv3mBLpZzx9ivFnvYhvF/dQsZSGcKmAsEQdBuF0msetXrYOFLN0XP
 MT7pvvVyJIZ+MiE19+sjniSnfK+LKvt/4NC8tOydX/fV9+N8kNE6r9vzw3QoWa4IzVstfI
 Vdglj+F6rL496rqa9PDIWeCOx/n1W5M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-kmVP9YLQPzyKbRf9tQPYAg-1; Mon, 17 Aug 2020 06:06:27 -0400
X-MC-Unique: kmVP9YLQPzyKbRf9tQPYAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C69B38015F5;
 Mon, 17 Aug 2020 10:06:26 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 5B6ED7843D;
 Mon, 17 Aug 2020 10:06:23 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 11/18] arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET
 hypercall
Date: Mon, 17 Aug 2020 20:05:24 +1000
Message-Id: <20200817100531.83045-12-gshan@redhat.com>
In-Reply-To: <20200817100531.83045-1-gshan@redhat.com>
References: <20200817100531.83045-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com
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

This supports SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET hypercall by adding
kvm_sdei_hypercall_route(). On success, the specified routing mode
and affinity is set. Otherwise, errno is returned. The route mode
or affinity is updated to the KVM SDEI event.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 74 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 529505c4f0cf..1e7291acea0d 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -585,6 +585,78 @@ static unsigned long kvm_sdei_hypercall_info(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long kvm_sdei_hypercall_route(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_event *event = NULL;
+	struct kvm_sdei_kvm_event *kevent = NULL;
+	unsigned long event_num = smccc_get_arg1(vcpu);
+	unsigned long route_mode = smccc_get_arg2(vcpu);
+	unsigned long route_affinity = smccc_get_arg3(vcpu);
+	unsigned long event_type;
+	int index = 0;
+	unsigned long ret = SDEI_SUCCESS;
+
+	/* Validate the parameters */
+	if (!kvm_sdei_num_is_valid(event_num)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	if (!(kvm_sdei_data && kvm_sdei_data->supported) &&
+	    kvm_sdei_num_is_virt(event_num)) {
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
+	/* Find the event */
+	spin_lock(&kvm_sdei_lock);
+	event = kvm_sdei_find_event(kvm, event_num, &kevent, NULL, NULL);
+	if (!kevent) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock;
+	}
+
+	/* Sanity check */
+	spin_lock(&event->lock);
+	event_type = event->priv ? event->priv->type : event->event->type;
+	index = (event_type == SDEI_EVENT_TYPE_PRIVATE) ? vcpu->vcpu_idx : 0;
+	if (event_type != SDEI_EVENT_TYPE_SHARED) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock_event;
+	}
+
+	if (!test_bit(index, kevent->registered) ||
+	    test_bit(index, kevent->enabled)     ||
+	    kevent->users) {
+		ret = SDEI_DENIED;
+		goto unlock_event;
+	}
+
+	if (route_mode == kevent->route_mode &&
+	    route_affinity == kevent->route_affinity) {
+		ret = SDEI_DENIED;
+		goto unlock_event;
+	}
+
+	/* Update status */
+	kevent->route_mode = route_mode;
+	kevent->route_affinity = route_affinity;
+
+unlock_event:
+	spin_unlock(&event->lock);
+unlock:
+	spin_unlock(&kvm_sdei_lock);
+out:
+	return ret;
+}
+
 static unsigned long kvm_sdei_reset(struct kvm *kvm, unsigned int types)
 {
 	struct kvm_sdei_event *e, *event = NULL;
@@ -680,6 +752,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_sdei_hypercall_info(vcpu);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
+		ret = kvm_sdei_hypercall_route(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_PE_MASK:
 	case SDEI_1_0_FN_SDEI_PE_UNMASK:
 	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
