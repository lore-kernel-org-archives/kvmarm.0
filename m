Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5E5C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:04:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90A2D4B29C;
	Fri, 27 May 2022 04:04:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ndQk8yM8kV1A; Fri, 27 May 2022 04:04:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A92E4B354;
	Fri, 27 May 2022 04:04:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 712FA4B29C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:04:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gMEo1Cs5ZLQD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:04:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C4DB4B357
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:04:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638657;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=P4jpm8XSirJ1238sxZZHFV9+DDVhOPJcfnDADqydjXI=;
 b=egfbuRXg63NhSk5C80CPSCV61n2Nh/hvg7R+0hm/1pE6ofr/iE2zICItMUGdcCjS6f9EqZ
 wVbfeJ3kQPwLQL/rLUL3E5fft5D6y3boislmSn7wzIVToMMWwGtaYS80o4kDNijbtYMOPt
 Xwy6pR/pns6Rgvc6dIS+tl1IExBT1S0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-M6zTRbdCOiKQyGV6iliAuA-1; Fri, 27 May 2022 04:04:14 -0400
X-MC-Unique: M6zTRbdCOiKQyGV6iliAuA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04D042949BAE;
 Fri, 27 May 2022 08:04:14 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A90A42026D64;
 Fri, 27 May 2022 08:04:07 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 04/22] KVM: arm64: Support EVENT_REGISTER hypercall
Date: Fri, 27 May 2022 16:02:35 +0800
Message-Id: <20220527080253.1562538-5-gshan@redhat.com>
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

This supports EVENT_REGISTER hypercall, which is used by guest
to register event. The event won't be raised until it's registered
and enabled. There are several cases where the request is injected:

  * The event isn't supported by KVM

  * The event has been registered or pending for unregistration

  * The reserved bits or relative mode are set in @flags argument

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 0c4415fcad16..40c2d585470d 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -13,6 +13,34 @@
 #include <kvm/arm_hypercalls.h>
 #include <asm/kvm_sdei.h>
 
+static unsigned long event_register(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	unsigned int num = smccc_get_arg(vcpu, 1);
+	unsigned long flags = smccc_get_arg(vcpu, 4);
+
+	if (num >= KVM_NR_SDEI_EVENTS)
+		return SDEI_INVALID_PARAMETERS;
+
+	/* Reject if the reserved bits or relative mode are set */
+	if (flags & ~0x1UL)
+		return SDEI_INVALID_PARAMETERS;
+
+	/*
+	 * Reject if the event has been registered or pending for
+	 * unregistration.
+	 */
+	if (test_bit(num, &vsdei->registered) ||
+	    test_bit(num, &vsdei->running))
+		return SDEI_DENIED;
+
+	vsdei->handlers[num].ep_addr = smccc_get_arg(vcpu, 2);
+	vsdei->handlers[num].ep_arg = smccc_get_arg(vcpu, 3);
+	set_bit(num, &vsdei->registered);
+
+	return SDEI_SUCCESS;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -31,6 +59,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	}
 
 	switch (func) {
+	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
+		ret = event_register(vcpu);
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
