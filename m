Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55393C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:04:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 083544B35E;
	Fri, 27 May 2022 04:04:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Ll55Lbgwn1Q; Fri, 27 May 2022 04:04:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D33554B2C1;
	Fri, 27 May 2022 04:04:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B10C4B1E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:04:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 61YpYTOT8BjT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:04:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24EB74B26D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:04:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638675;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=kcK/t9iW1JR5lhmsZM8idJt1ZlBlpeTLocByfzKuNnU=;
 b=hccRh0Wml44hy4J1a2Id3t/M6KAlkMT8w8KFxW8iut7ie4+0lnJf83cmGfn/w1mKuFY6S1
 nnooZJTGeSkal0L36XLqlTluCBA0H7mRXnOuAsLNEyVRbgX6fA4XXGUyjrZqXClmrZKvkx
 ivExal5MtiwEAztc5913bekSZJdjHAM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-RzrZnFTLOkWOtiHCvt0Maw-1; Fri, 27 May 2022 04:04:34 -0400
X-MC-Unique: RzrZnFTLOkWOtiHCvt0Maw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFC77187506C;
 Fri, 27 May 2022 08:04:33 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C23382024CBB;
 Fri, 27 May 2022 08:04:24 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 06/22] KVM: arm64: Support EVENT_CONTEXT hypercall
Date: Fri, 27 May 2022 16:02:37 +0800
Message-Id: <20220527080253.1562538-7-gshan@redhat.com>
In-Reply-To: <20220527080253.1562538-1-gshan@redhat.com>
References: <20220527080253.1562538-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Cc: maz@kernel.org, shijie@amperemail.onmicrosoft.com,
 linux-kernel@vger.kernel.org, eauger@redhat.com, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, vkuznets@redhat.com,
 will@kernel.org
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

This supports EVENT_CONTEXT hypercall. It's called inside the event
handler to retrieve the specified register in the saved or preempted
context.

  * The request is rejected if no running event handler exists or the
    parameter ID is out of range.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index a4046e7b21d8..2fec2dcd02b0 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -44,7 +44,7 @@ static unsigned long event_register(struct kvm_vcpu *vcpu)
 static unsigned long event_enable(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
-	unsigned int num = smccc_get_arg(vcpu, 1);
+	int num = smccc_get_arg(vcpu, 1);
 
 	if (num >= KVM_NR_SDEI_EVENTS)
 		return SDEI_INVALID_PARAMETERS;
@@ -68,6 +68,23 @@ static unsigned long event_enable(struct kvm_vcpu *vcpu, bool enable)
 	return SDEI_SUCCESS;
 }
 
+static unsigned long event_context(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event_context *ctxt = &vsdei->ctxt;
+	unsigned int param_id = smccc_get_arg(vcpu, 1);
+
+	/* Reject if event handler isn't running */
+	if (!vsdei->running)
+		return SDEI_DENIED;
+
+	/* Reject if the parameter ID is out of range */
+	if (param_id >= ARRAY_SIZE(ctxt->regs))
+		return SDEI_INVALID_PARAMETERS;
+
+	return ctxt->regs[param_id];
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -95,6 +112,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
 		ret = event_enable(vcpu, false);
 		break;
+	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
+		ret = event_context(vcpu);
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
