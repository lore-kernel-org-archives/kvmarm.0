Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6F7C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:09:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A0B49F18;
	Tue, 22 Mar 2022 04:09:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SxchTgBRnwZ6; Tue, 22 Mar 2022 04:09:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 954F049EFC;
	Tue, 22 Mar 2022 04:09:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40027411C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:09:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eGnX5ROdLvQh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:09:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A1A648F9C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:09:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936542;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=fTnMxADpXxnYuQkzViZbgk/aAQ/eKV1ZLVLzIbtgdgU=;
 b=IRJD8jJUHT+4OR81WJWXjXvK6G1a+WpdQjCnH1Z/4JsQXMs0StxGE5a6Y8suAhn/7Ec7n9
 hcimO9JLnTmEtqT7W1UxNsmmSUubxWc07OGnnUdfw2K4WHBYxbU0TAQhoSlyQk4nIB2Enc
 cbVZ228PMvBYM5HqZYbI6zODWHbYbeQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-bvRgHREHPe-x5Yy-r3kExA-1; Tue, 22 Mar 2022 04:08:58 -0400
X-MC-Unique: bvRgHREHPe-x5Yy-r3kExA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 485DD8038E3;
 Tue, 22 Mar 2022 08:08:58 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C40281121324;
 Tue, 22 Mar 2022 08:08:52 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 08/22] KVM: arm64: Support SDEI_EVENT_STATUS hypercall
Date: Tue, 22 Mar 2022 16:06:56 +0800
Message-Id: <20220322080710.51727-9-gshan@redhat.com>
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

This supports SDEI_EVENT_STATUS hypercall. It's used by the guest
to retrieve the status about the specified SDEI event. A bitmap
is returned to indicate the corresponding status, including
registration, enablement and delivery state.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 36eda31e0392..5c43c8912ea1 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -454,6 +454,46 @@ static unsigned long hypercall_unregister(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long hypercall_status(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_exposed_event *exposed_event;
+	struct kvm_sdei_registered_event *registered_event;
+	unsigned long event_num = smccc_get_arg1(vcpu);
+	int index;
+	unsigned long ret = 0;
+
+	if (!kvm_sdei_is_supported(event_num)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	spin_lock(&ksdei->lock);
+
+	/*
+	 * Check if the registered event exists. None of the flags
+	 * will be set if it doesn't exist.
+	 */
+	registered_event = find_registered_event(kvm, event_num);
+	if (!registered_event)
+		goto unlock;
+
+	exposed_event = registered_event->exposed_event;
+	index = kvm_sdei_vcpu_index(vcpu, exposed_event);
+	if (kvm_sdei_is_registered(registered_event, index))
+		ret |= (1UL << SDEI_EVENT_STATUS_REGISTERED);
+	if (kvm_sdei_is_enabled(registered_event, index))
+		ret |= (1UL << SDEI_EVENT_STATUS_ENABLED);
+	if (registered_event->vcpu_event_count > 0)
+		ret |= (1UL << SDEI_EVENT_STATUS_RUNNING);
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
@@ -500,6 +540,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = hypercall_unregister(vcpu);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_STATUS:
+		ret = hypercall_status(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
 	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
 	case SDEI_1_0_FN_SDEI_PE_MASK:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
