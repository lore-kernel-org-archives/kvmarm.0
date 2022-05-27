Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DF8C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:06:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE9764B26D;
	Fri, 27 May 2022 04:06:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8xB1LpSGS02b; Fri, 27 May 2022 04:06:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94DEE49F3D;
	Fri, 27 May 2022 04:06:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48DFE49E5F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21MFDu6gf1dU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:05:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ADFF49E20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638758;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=k7pKbXrqucn/sAmVex4c4gIiaSEBPmDw6Y4/7YpC/zI=;
 b=Y4LpnFKestMx64oEPd0YCf/deSzxuNIFL45nUiiYbUHWQrwUaktCYysmTcxi9SYqv6Kt08
 xAQ6qt0UEtfBIwPwD15/lPcc622KXqwco/BBKUT0z5h0lXMtmA/81McwTrRf5KxvCc4lV6
 3MqDywN7FZGHSp+D2GO2OMmyYINhVgU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-F2akXvRUPUS7TCab-24vaQ-1; Fri, 27 May 2022 04:05:55 -0400
X-MC-Unique: F2akXvRUPUS7TCab-24vaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB6403804509;
 Fri, 27 May 2022 08:05:49 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 27ABD2026D64;
 Fri, 27 May 2022 08:05:41 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 15/22] KVM: arm64: Support SDEI_FEATURES hypercall
Date: Fri, 27 May 2022 16:02:46 +0800
Message-Id: <20220527080253.1562538-16-gshan@redhat.com>
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

This supports SDEI_FEATURES hypercall. It's used to retrieve the
supported features, including number of slots for the interrupt
binding events and relative mode for event handler. Currently,
we simply return zero, meaning none of them is supported.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c         | 16 ++++++++++++++++
 include/uapi/linux/arm_sdei.h |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index a55797fce06a..d295f84f6940 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -277,6 +277,19 @@ static unsigned long event_reset(struct kvm_vcpu *vcpu, bool private)
 	return SDEI_SUCCESS;
 }
 
+static unsigned long sdei_features(struct kvm_vcpu *vcpu)
+{
+	unsigned int feature = smccc_get_arg(vcpu, 1);
+
+	switch (feature) {
+	case SDEI_FEATURE_BIND_SLOTS:
+	case SDEI_FEATURE_RELATIVE_MODE:
+		return 0;
+	}
+
+	return SDEI_INVALID_PARAMETERS;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -337,6 +350,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_SHARED_RESET:
 		ret = event_reset(vcpu, false);
 		break;
+	case SDEI_1_1_FN_SDEI_FEATURES:
+		ret = sdei_features(vcpu);
+		break;
 	default:
 		ret = SDEI_NOT_SUPPORTED;
 	}
diff --git a/include/uapi/linux/arm_sdei.h b/include/uapi/linux/arm_sdei.h
index 72b07114bbfa..5b783cc64617 100644
--- a/include/uapi/linux/arm_sdei.h
+++ b/include/uapi/linux/arm_sdei.h
@@ -23,6 +23,7 @@
 #define SDEI_1_0_FN_SDEI_INTERRUPT_BIND			SDEI_1_0_FN(0x0D)
 #define SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE		SDEI_1_0_FN(0x0E)
 #define SDEI_1_1_FN_SDEI_EVENT_SIGNAL			SDEI_1_0_FN(0x0F)
+#define SDEI_1_1_FN_SDEI_FEATURES			SDEI_1_0_FN(0x10)
 #define SDEI_1_0_FN_SDEI_PRIVATE_RESET			SDEI_1_0_FN(0x11)
 #define SDEI_1_0_FN_SDEI_SHARED_RESET			SDEI_1_0_FN(0x12)
 
@@ -73,4 +74,8 @@
 #define SDEI_EVENT_PRIORITY_NORMAL		0
 #define SDEI_EVENT_PRIORITY_CRITICAL		1
 
+/* SDEI_FEATURES */
+#define SDEI_FEATURE_BIND_SLOTS			0
+#define SDEI_FEATURE_RELATIVE_MODE		1
+
 #endif /* _UAPI_LINUX_ARM_SDEI_H */
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
