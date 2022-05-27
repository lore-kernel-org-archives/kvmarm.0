Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A80C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:06:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96A644B32E;
	Fri, 27 May 2022 04:06:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fX9WxvPrSuRK; Fri, 27 May 2022 04:06:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8513249F0F;
	Fri, 27 May 2022 04:06:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C658049F0F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f12jO8mEJ9OC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:06:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD79549E20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638803;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=U6Q2dD3bxV4gDjNkhQvVENuOaAWqLSTexB84HcYuZeM=;
 b=Gvv4J0g9amyqqVcet1NVRSYP+Xm7LabTDLOMr2pp1EfEJFsIKnAdVd9BGGy9zNzBVc/Zqv
 BX/fIv/6hFu4elcM+Qol6n7ZQLBna9I7f4Jcczjf0DQlaiLMHhwTz4WdtEFhAENOI9435i
 vCTOrgl2oCX09d6X+8KW33KYii/uFZQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-G0fPdKk8Maqn9_4RZMunmA-1; Fri, 27 May 2022 04:06:39 -0400
X-MC-Unique: G0fPdKk8Maqn9_4RZMunmA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB6AA1C3E9AB;
 Fri, 27 May 2022 08:06:38 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 66449202699A;
 Fri, 27 May 2022 08:06:30 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 21/22] selftests: KVM: aarch64: Add SDEI case in hypercall
 tests
Date: Fri, 27 May 2022 16:02:52 +0800
Message-Id: <20220527080253.1562538-22-gshan@redhat.com>
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

This adds SDEI case in hypercall tests. The added hypercalls are
issued to mimic what guest kernel does: reset the shared and private
events, unmask PE, register/enable/disable/unregister event, and
then mask PE.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/hypercalls.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index 41e0210b7a5e..1377d2ec8d4b 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -11,6 +11,7 @@
 
 #include <errno.h>
 #include <linux/arm-smccc.h>
+#include <linux/arm_sdei.h>
 #include <asm/kvm.h>
 #include <kvm_util.h>
 
@@ -19,7 +20,7 @@
 #define FW_REG_ULIMIT_VAL(max_feat_bit) (GENMASK(max_feat_bit, 0))
 
 /* Last valid bits of the bitmapped firmware registers */
-#define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
+#define KVM_REG_ARM_STD_BMAP_BIT_MAX		1
 #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
 #define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	1
 
@@ -68,6 +69,14 @@ static const struct test_hvc_info hvc_info[] = {
 	TEST_HVC_INFO(ARM_SMCCC_TRNG_GET_UUID, 0),
 	TEST_HVC_INFO(ARM_SMCCC_TRNG_RND32, 0),
 	TEST_HVC_INFO(ARM_SMCCC_TRNG_RND64, 0),
+	TEST_HVC_INFO(SDEI_1_0_FN_SDEI_SHARED_RESET, 0),
+	TEST_HVC_INFO(SDEI_1_0_FN_SDEI_PRIVATE_RESET, 0),
+	TEST_HVC_INFO(SDEI_1_0_FN_SDEI_PE_UNMASK, 0),
+	TEST_HVC_INFO(SDEI_1_0_FN_SDEI_EVENT_REGISTER, SDEI_SW_SIGNALED_EVENT),
+	TEST_HVC_INFO(SDEI_1_0_FN_SDEI_EVENT_ENABLE, SDEI_SW_SIGNALED_EVENT),
+	TEST_HVC_INFO(SDEI_1_0_FN_SDEI_EVENT_DISABLE, SDEI_SW_SIGNALED_EVENT),
+	TEST_HVC_INFO(SDEI_1_0_FN_SDEI_EVENT_UNREGISTER, SDEI_SW_SIGNALED_EVENT),
+	TEST_HVC_INFO(SDEI_1_0_FN_SDEI_PE_MASK, 0),
 
 	/* KVM_REG_ARM_STD_HYP_BMAP */
 	TEST_HVC_INFO(ARM_SMCCC_ARCH_FEATURES_FUNC_ID, ARM_SMCCC_HV_PV_TIME_FEATURES),
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
