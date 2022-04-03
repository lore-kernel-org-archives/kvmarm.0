Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0615CC433EF
	for <kvmarm@archiver.kernel.org>; Sun,  3 Apr 2022 15:41:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B77EE4B0CE;
	Sun,  3 Apr 2022 11:41:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pqzHRPVxL+BU; Sun,  3 Apr 2022 11:41:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8825E4A0FE;
	Sun,  3 Apr 2022 11:41:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 028F14A0FE
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:41:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kVxuIm4kuIOn for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 11:41:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16F8D499F2
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:41:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649000484;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=u5GN46hECBcYCEJr/r3tYpcCJXItKVN6iW9DqJff394=;
 b=fxof5NVDxyMh3/q5pDMTyM3ULcxffOVqlXWezje9ACRhx9LMTmZQoOaMLVd7uIqAYBY72J
 s3VkepLFiPbKfr87GPCB9m3RtfTgEQyuJEk+AmKCPVlLuCL9utJZIrR3bJPqIiiu2KFWt4
 5w1nx9+9F6WptOrCmfr5zxnfHM8wSn0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-9-Ub-BPIO7ipQKp1eA7nxQ-1; Sun, 03 Apr 2022 11:41:21 -0400
X-MC-Unique: 9-Ub-BPIO7ipQKp1eA7nxQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34AC485A5A8;
 Sun,  3 Apr 2022 15:41:21 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-82.pek2.redhat.com [10.72.12.82])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 409EC403172;
 Sun,  3 Apr 2022 15:41:14 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 16/18] KVM: arm64: Support SDEI_VERSION hypercall
Date: Sun,  3 Apr 2022 23:39:09 +0800
Message-Id: <20220403153911.12332-17-gshan@redhat.com>
In-Reply-To: <20220403153911.12332-1-gshan@redhat.com>
References: <20220403153911.12332-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
index f946d4ebdc14..32dfd5595f15 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -71,6 +71,9 @@ struct kvm_sdei_vcpu {
 	struct kvm_sdei_vcpu_context	context[SDEI_EVENT_PRIORITY_CRITICAL + 1];
 };
 
+/* Returned as vendor through SDEI_VERSION hypercall */
+#define KVM_SDEI_VENDOR	ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2
+
 /*
  * According to SDEI specification (v1.1), the event number spans 32-bits
  * and the lower 24-bits are used as the (real) event number. I don't
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index ab0b7b5e3191..5d9b49a4355c 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -117,6 +117,14 @@ static int inject_event(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static unsigned long hypercall_version(struct kvm_vcpu *vcpu)
+{
+	/* v1.1 and vendor ID */
+	return (1UL << SDEI_VERSION_MAJOR_SHIFT) |
+	       (1UL << SDEI_VERSION_MINOR_SHIFT) |
+	       KVM_SDEI_VENDOR;
+}
+
 static unsigned long hypercall_register(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -565,6 +573,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	}
 
 	switch (func) {
+	case SDEI_1_0_FN_SDEI_VERSION:
+		ret = hypercall_version(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
 		ret = hypercall_register(vcpu);
 		break;
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
