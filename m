Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77D0C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:14:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7913A60F9F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:14:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7913A60F9F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D5CD4AEE2;
	Sat, 14 Aug 2021 20:14:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zpXgBhYlb+ph; Sat, 14 Aug 2021 20:14:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8C74B0BC;
	Sat, 14 Aug 2021 20:14:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01BB74B0A1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:14:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jEsF7lLtbCo1 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 20:14:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 807B14B0DB
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:14:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628986487;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WmO12IyDy5qzS+T4IY7K2Y+LJ28N9E7M0ofJOxtqPww=;
 b=dX68h4rbliuiuB33xbxFtF1BpDC1QzSSU9/NRR9UaJKTFmkwDwHOki377w+dSDPzkv9k4j
 2Zh2fplf5zSgXw6jqTM9pJVbpDfunMRts3iew3SMvKgtnTpfpBKRHB7m8VZkso/QOQn7v/
 FY4eeXwXrQpKOkzHaiUHbfYDv48AUlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-9WEdRhYoN1KUkZXSz3d9ug-1; Sat, 14 Aug 2021 20:14:45 -0400
X-MC-Unique: 9WEdRhYoN1KUkZXSz3d9ug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7438B1008068;
 Sun, 15 Aug 2021 00:14:44 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07F211036D2E;
 Sun, 15 Aug 2021 00:14:40 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 06/21] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
Date: Sun, 15 Aug 2021 08:13:37 +0800
Message-Id: <20210815001352.81927-7-gshan@redhat.com>
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

This supports SDEI_EVENT_CONTEXT hypercall. It's used by the guest
to retrieved the original registers (R0 - R17) in its SDEI event
handler. Those registers can be corrupted during the SDEI event
delivery.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index b022ce0a202b..b4162efda470 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -270,6 +270,44 @@ static unsigned long kvm_sdei_hypercall_enable(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static unsigned long kvm_sdei_hypercall_context(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_regs *regs;
+	unsigned long index = smccc_get_arg1(vcpu);
+	unsigned long ret = SDEI_SUCCESS;
+
+	/* Sanity check */
+	if (!(ksdei && vsdei)) {
+		ret = SDEI_NOT_SUPPORTED;
+		goto out;
+	}
+
+	if (index > ARRAY_SIZE(vsdei->state.critical_regs.regs)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	/* Check if the pending event exists */
+	spin_lock(&vsdei->lock);
+	if (!(vsdei->critical_event || vsdei->normal_event)) {
+		ret = SDEI_DENIED;
+		goto unlock;
+	}
+
+	/* Fetch the requested register */
+	regs = vsdei->critical_event ? &vsdei->state.critical_regs :
+				       &vsdei->state.normal_regs;
+	ret = regs->regs[index];
+
+unlock:
+	spin_unlock(&vsdei->lock);
+out:
+	return ret;
+}
+
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 {
 	u32 func = smccc_get_function(vcpu);
@@ -290,6 +328,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_sdei_hypercall_enable(vcpu, false);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
+		ret = kvm_sdei_hypercall_context(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
 	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
 	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
