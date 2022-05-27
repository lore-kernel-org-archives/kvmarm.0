Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121B2C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:05:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDFBB4B26D;
	Fri, 27 May 2022 04:05:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KDLvVVV9h+88; Fri, 27 May 2022 04:05:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C2B74B354;
	Fri, 27 May 2022 04:05:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E4A4B32E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MPFX0OXeNAPf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:05:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CECF74B26D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638702;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=F48pBQPoVsgMuE4olcTfKdFglqqUe1/4WW/F05DCMx0=;
 b=WGtgt3cIJhY38P09t7V9AoKTBg1AQ88u+ifJGOY3UADMgOuozHm5jMMPFpDRI5WuGWHuTe
 AytS+vKQ7/lHEJVDZSD7LWO8HIU1Xc3V0B9AKC+ciWV816CKTTaM0J5IRTpO/Qor0OG4mT
 azLM7Rv5jEOPsrd7okxkmFcWKROlZmE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-D069rGygNjaL8Jre3L4_gg-1; Fri, 27 May 2022 04:04:57 -0400
X-MC-Unique: D069rGygNjaL8Jre3L4_gg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75C7E3C0ED5D;
 Fri, 27 May 2022 08:04:56 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 239ED202699A;
 Fri, 27 May 2022 08:04:48 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 09/22] KVM: arm64: Support EVENT_GET_INFO hypercall
Date: Fri, 27 May 2022 16:02:40 +0800
Message-Id: <20220527080253.1562538-10-gshan@redhat.com>
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

This supports EVENT_GET_INFO hypercall. It's used to retrieve
information about the event: type, signaled, priority, routing
mode and affinity.

All supported events are private and have normal priority.
Besides, all supported events can be signaled from software.
It means we just return fixed value for type/signaled/priority.

As the routing mode and affinity are only available for the
shared event, which is unsupported. So SDEI_INVALID_PARAMETERS
is returned when they're requested.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 377341f229da..cea523418c75 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -137,6 +137,38 @@ static unsigned long event_status(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long event_info(struct kvm_vcpu *vcpu)
+{
+	unsigned int num = smccc_get_arg(vcpu, 1);
+	unsigned int info = smccc_get_arg(vcpu, 2);
+	unsigned long ret = 0;
+
+	if (num >= KVM_NR_SDEI_EVENTS)
+		return SDEI_INVALID_PARAMETERS;
+
+	/*
+	 * All supported events are private and have normal priority.
+	 * Besides, all supported events can be signaled by software
+	 */
+	switch (info) {
+	case SDEI_EVENT_INFO_EV_TYPE:
+		ret = SDEI_EVENT_TYPE_PRIVATE;
+		break;
+	case SDEI_EVENT_INFO_EV_SIGNALED:
+		ret = 1;
+		break;
+	case SDEI_EVENT_INFO_EV_PRIORITY:
+		ret = SDEI_EVENT_PRIORITY_NORMAL;
+		break;
+	case SDEI_EVENT_INFO_EV_ROUTING_MODE:
+	case SDEI_EVENT_INFO_EV_ROUTING_AFF:
+	default:
+		ret = SDEI_INVALID_PARAMETERS;
+	}
+
+	return ret;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -173,6 +205,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_EVENT_STATUS:
 		ret = event_status(vcpu);
 		break;
+	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
+		ret = event_info(vcpu);
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
