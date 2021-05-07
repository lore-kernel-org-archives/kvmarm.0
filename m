Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880ADC433ED
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:31:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 133CF613DD
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:31:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 133CF613DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B77944B297;
	Fri,  7 May 2021 02:31:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XPlCKQQu+e1i; Fri,  7 May 2021 02:31:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE4AD4B51A;
	Fri,  7 May 2021 02:31:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E35684B47E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:31:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3FmAn+GZIuDo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:31:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACFB04B297
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:31:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369100;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ZAcXwo0Oru0ZxTATfw4I2VSKoXfBLIT/f+dSWdjupcA=;
 b=BfTyU+sqYtTy6ATl7/Ev4Agu8BNRxbHKbSVXCTEmdobrt8OmLTwdADTZFfZPA9jpAWxDYM
 dIQKCcwvVVoe4mmgx6jRTL3f55MQ/1zfQ3Y8PXhtrVuNxYvl1MSu25x13kKPv34oytswkn
 prmF8t4n089/VzVB2gzZtEh7+o/trjQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-8IQ2sInXOLW67bbGzW9mSw-1; Fri, 07 May 2021 02:31:37 -0400
X-MC-Unique: 8IQ2sInXOLW67bbGzW9mSw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 806D66414C;
 Fri,  7 May 2021 06:31:35 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9C7A75D9CA;
 Fri,  7 May 2021 06:31:32 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 01/21] KVM: arm64: Introduce template for inline functions
Date: Fri,  7 May 2021 16:31:04 +0800
Message-Id: <20210507083124.43347-2-gshan@redhat.com>
In-Reply-To: <20210507083124.43347-1-gshan@redhat.com>
References: <20210507083124.43347-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, will@kernel.org
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

The inline functions used to get the SMCCC parameters have same
layout. It means the logical functionality can be presented by
a template, to make the code simplified. Besides, this adds more
similar inline functions like smccc_get_arg{4,5,6,7,8}() to visit
more SMCCC arguments, which are required by SDEI virtualization
support.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 include/kvm/arm_hypercalls.h | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 0e2509d27910..1120eff7aa28 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -6,27 +6,21 @@
 
 #include <asm/kvm_emulate.h>
 
-int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
-
-static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 0);
+#define SMCCC_DECLARE_GET_FUNCTION(type, name, reg)		\
+static inline type smccc_get_##name(struct kvm_vcpu *vcpu)	\
+{								\
+	return vcpu_get_reg(vcpu, (reg));			\
 }
 
-static inline unsigned long smccc_get_arg1(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 1);
-}
-
-static inline unsigned long smccc_get_arg2(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 2);
-}
-
-static inline unsigned long smccc_get_arg3(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_reg(vcpu, 3);
-}
+SMCCC_DECLARE_GET_FUNCTION(u32,           function, 0)
+SMCCC_DECLARE_GET_FUNCTION(unsigned long, arg1,     1)
+SMCCC_DECLARE_GET_FUNCTION(unsigned long, arg2,     2)
+SMCCC_DECLARE_GET_FUNCTION(unsigned long, arg3,     3)
+SMCCC_DECLARE_GET_FUNCTION(unsigned long, arg4,     4)
+SMCCC_DECLARE_GET_FUNCTION(unsigned long, arg5,     5)
+SMCCC_DECLARE_GET_FUNCTION(unsigned long, arg6,     6)
+SMCCC_DECLARE_GET_FUNCTION(unsigned long, arg7,     7)
+SMCCC_DECLARE_GET_FUNCTION(unsigned long, arg8,     8)
 
 static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
 				    unsigned long a0,
@@ -40,4 +34,6 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
 	vcpu_set_reg(vcpu, 3, a3);
 }
 
+int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
+
 #endif
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
