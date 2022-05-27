Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58772C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:06:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F06744B352;
	Fri, 27 May 2022 04:06:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D3TLxnntF7Vg; Fri, 27 May 2022 04:06:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B405F4B284;
	Fri, 27 May 2022 04:06:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A668F49F3D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1mPQFEzLK0Jy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:06:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1DA49E20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638762;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=g1oE6zW708ThGzA9gQNSKRACZxEySOeeS7EX47PV2eQ=;
 b=egLMa6uovZ5RBsRXxrQPytKQntSNYtdTRQnsTyXBNJ9e/X1BPmC9M5YSU3DGmjwj5C0dTU
 83doWycH1MOE0NU3Omi2CxAgABRINvMquFAQaRgvp3UjahBfg8bzUoU+tWSl8NPj84igmK
 Oa7/BMzLa0OBbSAqNrEitr+iQ8GsSN4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-JYmtOss3NKWCf39IZ3uN1w-1; Fri, 27 May 2022 04:05:58 -0400
X-MC-Unique: JYmtOss3NKWCf39IZ3uN1w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C53E2949BA6;
 Fri, 27 May 2022 08:05:57 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B4D7C2026D07;
 Fri, 27 May 2022 08:05:50 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 16/22] KVM: arm64: Support SDEI_VERSION hypercall
Date: Fri, 27 May 2022 16:02:47 +0800
Message-Id: <20220527080253.1562538-17-gshan@redhat.com>
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

This supports SDEI_VERSION hypercall by returning v1.1, which is
the specification version we're following. The vendor is set to
one of the values returned from ARM_SMCCC_VENDOR_HYP_CALL_UID
hypercall.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_sdei.h |  3 +++
 arch/arm64/kvm/sdei.c             | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index 735d9ac1a5a2..a1e960943515 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -62,6 +62,9 @@ struct kvm_sdei_vcpu {
 	struct kvm_sdei_event_context	ctxt;
 };
 
+/* Returned as vendor through SDEI_VERSION hypercall */
+#define KVM_SDEI_VENDOR	ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2
+
 /* APIs */
 int kvm_sdei_call(struct kvm_vcpu *vcpu);
 int kvm_sdei_inject_event(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index d295f84f6940..f95b9bcce13c 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -13,6 +13,14 @@
 #include <kvm/arm_hypercalls.h>
 #include <asm/kvm_sdei.h>
 
+static unsigned long sdei_version(struct kvm_vcpu *vcpu)
+{
+	/* v1.1 and vendor ID */
+	return (1UL << SDEI_VERSION_MAJOR_SHIFT) |
+	       (1UL << SDEI_VERSION_MINOR_SHIFT) |
+	       KVM_SDEI_VENDOR;
+}
+
 static unsigned long event_register(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -308,6 +316,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	}
 
 	switch (func) {
+	case SDEI_1_0_FN_SDEI_VERSION:
+		ret = sdei_version(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
 		ret = event_register(vcpu);
 		break;
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
