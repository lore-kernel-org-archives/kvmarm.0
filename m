Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938B7C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D4CE2078E
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UCMqoONa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D4CE2078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEDEA4C005;
	Mon, 17 Aug 2020 06:06:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zEapqOcuOrAl; Mon, 17 Aug 2020 06:06:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0DA64C016;
	Mon, 17 Aug 2020 06:06:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BEC84BF3C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hFpc1FStOQqU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:06:13 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CD4B4BE67
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658772;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xJgQZj3oLv5mgMZjE6oW/BbYd8SD5DnrZ+6i3n6byYg=;
 b=UCMqoONaZeZ4wjLJMf+dlnEprqRw5UZpXUYnPxOwjhpMdRVRDV3/XEfBkkIo5XITaU9isC
 xq+vTwKHuySgLxwNWPgjubgM86j3Df1yW+N1NUA2Nt3H4ErQGqeds801SSQoaCCDAsXzfa
 HH3A18tD1mhOjG4/iY785f3Dh++6JJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-aOscoTbPMzuqWQ421a4zKA-1; Mon, 17 Aug 2020 06:06:10 -0400
X-MC-Unique: aOscoTbPMzuqWQ421a4zKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AF4E18686C1;
 Mon, 17 Aug 2020 10:06:09 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 1B7DC78414;
 Mon, 17 Aug 2020 10:06:06 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 07/18] arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_{ENABLE,
 DISABLE} hypercall
Date: Mon, 17 Aug 2020 20:05:20 +1000
Message-Id: <20200817100531.83045-8-gshan@redhat.com>
In-Reply-To: <20200817100531.83045-1-gshan@redhat.com>
References: <20200817100531.83045-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
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

This supports SDEI_1_0_FN_SDEI_EVENT_{ENABLE, DISABLE} hypercall by
implementing function sdei_kvm_hypercall_enable(). On success, the
event is enabled globally or on the local CPU. Otherwise, errno is
returned. For the passthrou event, it's not enabled or disabled from
the underly firmware. What we need is to update the enabled bits,
which will be serving as filters during the event delivery to the
target VMs and vCPUs.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 68 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 740694d7f0ff..320b79528211 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -279,6 +279,70 @@ static unsigned long kvm_sdei_hypercall_register(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long kvm_sdei_hypercall_enable(struct kvm_vcpu *vcpu,
+					       bool enabled)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_event *event = NULL;
+	struct kvm_sdei_kvm_event *kevent = NULL;
+	unsigned long event_num = smccc_get_arg1(vcpu);
+	unsigned long event_type;
+	int index = 0;
+	unsigned long ret = SDEI_SUCCESS;
+
+	/* Validate event number */
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
+	if (kevent->users) {
+		ret = SDEI_PENDING;
+		goto unlock_event;
+	}
+
+	if (!test_bit(index, kevent->registered)) {
+		ret = SDEI_DENIED;
+		goto unlock_event;
+	}
+
+	if (enabled == test_bit(index, kevent->enabled)) {
+		ret = SDEI_DENIED;
+		goto unlock_event;
+	}
+
+	/* Update status */
+	if (enabled)
+		set_bit(index, kevent->enabled);
+	else
+		clear_bit(index, kevent->enabled);
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
@@ -356,7 +420,11 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_sdei_hypercall_register(vcpu);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
+		ret = kvm_sdei_hypercall_enable(vcpu, true);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
+		ret = kvm_sdei_hypercall_enable(vcpu, false);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
 	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
 	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
