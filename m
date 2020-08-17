Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159FAC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B9EF82067C
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UCnGFNHp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9EF82067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FAF74BD07;
	Mon, 17 Aug 2020 06:06:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JvVD9+GHV04G; Mon, 17 Aug 2020 06:06:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47EBF4BE67;
	Mon, 17 Aug 2020 06:06:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2154BD07
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 81WFalgB5iZz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:06:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AFA04BC42
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658785;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5aat49L0fxuluS6U1waQ/ZK3v5E+OP7EGb+6AtLw2U8=;
 b=UCnGFNHpKFk24LXXF76J/7/YrNXsy5VZIAVGIirHIEieMXNB68aM7a2fGUOILnCX2tpQ8A
 VHYjanFxzB4MrHxLbNYU5h5TYTHpv4+mzUMrdq8Hqf8Bhk1bsXJvD4rVp0T4fM7DXS3Dog
 YrLUb30RPkhZFLES8hA6GnbOkpg0o30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-_Xjai9j_NCyvRHdhReYivA-1; Mon, 17 Aug 2020 06:06:23 -0400
X-MC-Unique: _Xjai9j_NCyvRHdhReYivA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C00E918551AC;
 Mon, 17 Aug 2020 10:06:22 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B994478498;
 Mon, 17 Aug 2020 10:06:16 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 10/18] arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_GET_INFO
 hypercall
Date: Mon, 17 Aug 2020 20:05:23 +1000
Message-Id: <20200817100531.83045-11-gshan@redhat.com>
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

This supports SDEI_1_0_FN_SDEI_EVENT_GET_INFO hypercall by adding
kvm_sdei_hypercall_info(). On success, the requested information
about the event is returned. Otherwise, the errno is returned.

The required information is retrieved from the SDEI event if it
has been created. Otherwise, it's retrieved from underly firmware
if applicable.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 125 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 2d2135a5c3ea..529505c4f0cf 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -38,6 +38,14 @@ static struct sdei_event *kvm_sdei_register_event(unsigned long event_num,
 				   cb, arg);
 }
 
+static int kvm_sdei_get_event_info(unsigned long event_num,
+				   unsigned int info,
+				   unsigned long *result)
+{
+	return sdei_event_get_info(kvm_sdei_num_to_std(event_num),
+				   info, (u64 *)result);
+}
+
 static int kvm_sdei_unregister_event(struct sdei_event *event)
 {
 	return sdei_event_unregister(event);
@@ -56,6 +64,14 @@ static inline struct sdei_event *kvm_sdei_register_event(
 	return NULL;
 }
 
+static inline int kvm_sdei_get_event_info(unsigned long event_num,
+					  unsigned int info,
+					  unsigned long *result)
+{
+	*result = SDEI_NOT_SUPPORTED;
+	return -EPERM;
+}
+
 static inline int kvm_sdei_unregister_event(struct sdei_event *event)
 {
 	return -EPERM;
@@ -462,6 +478,113 @@ static unsigned long kvm_sdei_hypercall_status(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long kvm_sdei_hypercall_info(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_event *event = NULL;
+	struct kvm_sdei_kvm_event *kevent = NULL;
+	struct kvm_sdei_priv *priv = NULL;
+	unsigned long event_num = smccc_get_arg1(vcpu);
+	unsigned long event_info = smccc_get_arg2(vcpu);
+	unsigned long event_type;
+	int index;
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
+	/*
+	 * The requested information could be retrieved from the
+	 * registered event, KVM private descriptor or underly
+	 * firmware.
+	 */
+	spin_lock(&kvm_sdei_lock);
+	event = kvm_sdei_find_event(kvm, event_num, &kevent, NULL, NULL);
+	if (kevent) {
+		spin_lock(&event->lock);
+
+		event_type = event->priv ? event->priv->type :
+					   event->event->type;
+		index = (event_type == SDEI_EVENT_TYPE_PRIVATE) ?
+			vcpu->vcpu_idx : 0;
+		if (!test_bit(index, kevent->registered)) {
+			ret = SDEI_INVALID_PARAMETERS;
+			goto unlock;
+		}
+
+		priv = event->priv;
+	} else if (kvm_sdei_num_is_priv(event_num)) {
+		priv = kvm_sdei_find_priv(event_num);
+		if (!priv) {
+			ret = SDEI_INVALID_PARAMETERS;
+			goto unlock;
+		}
+	} else if (kvm_sdei_num_is_virt(event_num)) {
+		if (event_info == SDEI_EVENT_INFO_EV_ROUTING_MODE ||
+		    event_info == SDEI_EVENT_INFO_EV_ROUTING_AFF) {
+			kvm_sdei_get_event_info(event_num,
+						SDEI_EVENT_INFO_EV_TYPE,
+						&event_type);
+			if (event_type != SDEI_EVENT_TYPE_SHARED) {
+				ret = SDEI_INVALID_PARAMETERS;
+				goto unlock;
+			}
+		}
+
+		kvm_sdei_get_event_info(event_num, event_info, &ret);
+		goto unlock;
+	}
+
+	switch (event_info) {
+	case SDEI_EVENT_INFO_EV_TYPE:
+		ret = priv ? priv->type : event->event->type;
+		break;
+	case SDEI_EVENT_INFO_EV_SIGNALED:
+		ret = priv ? priv->signaled : event->event->signaled;
+		break;
+	case SDEI_EVENT_INFO_EV_PRIORITY:
+		ret = priv ? priv->priority : event->event->priority;
+		break;
+	case SDEI_EVENT_INFO_EV_ROUTING_MODE:
+		event_type = priv ? priv->type : event->event->type;
+		if (event_type != SDEI_EVENT_TYPE_SHARED) {
+			ret = SDEI_INVALID_PARAMETERS;
+			break;
+		}
+
+		ret = kevent ? kevent->route_mode : priv->route_mode;
+		break;
+	case SDEI_EVENT_INFO_EV_ROUTING_AFF:
+		event_type = priv ? priv->type : event->event->type;
+		if (event_type != SDEI_EVENT_TYPE_SHARED) {
+			ret = SDEI_INVALID_PARAMETERS;
+			break;
+		}
+
+		ret = kevent ? kevent->route_affinity : priv->route_affinity;
+		break;
+	default:
+		ret = SDEI_INVALID_PARAMETERS;
+	}
+
+unlock:
+	if (kevent)
+		spin_unlock(&event->lock);
+
+	spin_unlock(&kvm_sdei_lock);
+out:
+	return ret;
+}
+
 static unsigned long kvm_sdei_reset(struct kvm *kvm, unsigned int types)
 {
 	struct kvm_sdei_event *e, *event = NULL;
@@ -554,6 +677,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_sdei_hypercall_status(vcpu);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
+		ret = kvm_sdei_hypercall_info(vcpu);
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
