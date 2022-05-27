Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C708C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:04:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BEE24B354;
	Fri, 27 May 2022 04:04:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oOXTqkA5Q71e; Fri, 27 May 2022 04:04:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AE954B1E1;
	Fri, 27 May 2022 04:04:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E94B84B1E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:04:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HYRCYVxrXKR0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:04:44 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBF7449F0F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:04:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638684;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=329kwVYlUvTHO0LeA/plITFrudtBaaBxKIDFkDJlGH8=;
 b=QF/gmH7s+vINugrXxHhZR3pU/mZ+A83EA1iBr2ysLw4cG6Z3/YXL4lP23NA0P8j1/0i7Tf
 c8tel3KepbJoD4gy42eSCR8o4ACqNorPqJCqlLZq5A568cUVSRDyz13V+uEfvwPxr7RM4G
 5dDS6xhJuB9jMVWoErOo1TwerULIIjQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-dMEdTzJWOrCpZMOLi9hD9A-1; Fri, 27 May 2022 04:04:41 -0400
X-MC-Unique: dMEdTzJWOrCpZMOLi9hD9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2FAD811E76;
 Fri, 27 May 2022 08:04:40 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 87E762026D64;
 Fri, 27 May 2022 08:04:34 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 07/22] KVM: arm64: Support EVENT_UNREGISTER hypercall
Date: Fri, 27 May 2022 16:02:38 +0800
Message-Id: <20220527080253.1562538-8-gshan@redhat.com>
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

This supports EVENT_UNREGISTER hypercall. No event will be delivered
to guest after it's unregistered.

  * Reject if the event hasn't been registered.

  * Return SDEI_PENDING if the event handler is running.

  * The event is disabled automatically on unregistration.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 2fec2dcd02b0..b44ab302732d 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -85,6 +85,39 @@ static unsigned long event_context(struct kvm_vcpu *vcpu)
 	return ctxt->regs[param_id];
 }
 
+static unsigned long event_unregister(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	unsigned int num = smccc_get_arg(vcpu, 1);
+
+	if (num >= KVM_NR_SDEI_EVENTS)
+		return SDEI_INVALID_PARAMETERS;
+
+	/*
+	 * Reject if the event isn't registered. It's allowed to
+	 * unregister event which has been pending for that.
+	 */
+	if (!test_bit(num, &vsdei->registered)) {
+		if (test_bit(num, &vsdei->running))
+			return SDEI_PENDING;
+		else
+			return SDEI_DENIED;
+	}
+
+	/*
+	 * The event is disabled automatically on unregistration, even
+	 * pending for that.
+	 */
+	clear_bit(num, &vsdei->enabled);
+	clear_bit(num, &vsdei->registered);
+
+	/* Pending for unreigstration if the event handler is running */
+	if (test_bit(num, &vsdei->running))
+		return SDEI_PENDING;
+
+	return SDEI_SUCCESS;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -115,6 +148,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
 		ret = event_context(vcpu);
 		break;
+	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
+		ret = event_unregister(vcpu);
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
