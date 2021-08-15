Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFE8C432BE
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:14:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADF3B610FF
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:14:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ADF3B610FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 551354B0A1;
	Sat, 14 Aug 2021 20:14:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7aE37qNLm97V; Sat, 14 Aug 2021 20:14:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2843B4B0D2;
	Sat, 14 Aug 2021 20:14:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55D804B0B5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:14:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id en0I9pPMUEOz for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 20:14:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E8BE4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:14:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628986483;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=fkw3mJqS3pBDC+aanz8yHsGj1AbHq5g++Wkg6vpucq8=;
 b=bOvfdpAws91hk7kkn/N0F6iO+Thc9ulY8A0FM7HcwA/BEv3v8g0xqtGdXwlUpufSG5xznW
 yGExSthZBKgzheF0AudtYfgQis64vyXa2PeSUpdE0/VjwPufRN6noMMk7WOCVQOYstq6iC
 BY3QJNlat5W2e9W1phXZKOGotfwQe0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-X54qic6NOzuKUcFWJQGk6Q-1; Sat, 14 Aug 2021 20:14:41 -0400
X-MC-Unique: X54qic6NOzuKUcFWJQGk6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D3691082921;
 Sun, 15 Aug 2021 00:14:40 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D65610016FF;
 Sun, 15 Aug 2021 00:14:35 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 05/21] KVM: arm64: Support SDEI_EVENT_{ENABLE,
 DISABLE} hypercall
Date: Sun, 15 Aug 2021 08:13:36 +0800
Message-Id: <20210815001352.81927-6-gshan@redhat.com>
In-Reply-To: <20210815001352.81927-1-gshan@redhat.com>
References: <20210815001352.81927-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com,
 pbonzini@redhat.com, will@kernel.org
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

This supports SDEI_EVENT_{ENABLE, DISABLE} hypercall. After SDEI
event is registered by guest, it won't be delivered to the guest
until it's enabled. On the other hand, the SDEI event won't be
raised to the guest or specific vCPU if it's has been disabled
on the guest or specific vCPU.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 68 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index d3ea3eee154b..b022ce0a202b 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -206,6 +206,70 @@ static unsigned long kvm_sdei_hypercall_register(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long kvm_sdei_hypercall_enable(struct kvm_vcpu *vcpu,
+					       bool enable)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *kse = NULL;
+	struct kvm_sdei_kvm_event *kske = NULL;
+	unsigned long event_num = smccc_get_arg1(vcpu);
+	int index = 0;
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
+	/* Check if the KVM event exists */
+	spin_lock(&ksdei->lock);
+	kske = kvm_sdei_find_kvm_event(kvm, event_num);
+	if (!kske) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock;
+	}
+
+	/* Check if there is pending events */
+	if (kske->state.refcount) {
+		ret = SDEI_PENDING;
+		goto unlock;
+	}
+
+	/* Check if it has been registered */
+	kse = kske->kse;
+	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
+		vcpu->vcpu_idx : 0;
+	if (!kvm_sdei_is_registered(kske, index)) {
+		ret = SDEI_DENIED;
+		goto unlock;
+	}
+
+	/* Verify its enablement state */
+	if (enable == kvm_sdei_is_enabled(kske, index)) {
+		ret = SDEI_DENIED;
+		goto unlock;
+	}
+
+	/* Update enablement state */
+	if (enable)
+		kvm_sdei_set_enabled(kske, index);
+	else
+		kvm_sdei_clear_enabled(kske, index);
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
@@ -220,7 +284,11 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
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
