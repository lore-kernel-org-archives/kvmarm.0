Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B4FC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:34:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CFE320734
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:34:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2o1TioCf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CFE320734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 584E34B24B;
	Wed, 10 Jun 2020 07:34:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kgm23KNXJICr; Wed, 10 Jun 2020 07:34:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43BFE4B2C6;
	Wed, 10 Jun 2020 07:34:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 890BC4B237
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 07:34:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BplIzG3huPjp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 07:34:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8ABF44B150
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 07:34:18 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B5E6420760;
 Wed, 10 Jun 2020 11:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591788857;
 bh=/Y2n7mh6J7qge+yb7uf2/26y9v3szN7Yyb7XyJnJfiU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=2o1TioCfOCUpxyCEkhD2T3u4rcGK0ces6J+4y/9i0RuD5HVWJRC0AKmXDkK2VhoL9
 kXTUAqN2vUPP6LUZyAdRG/XYPeBpWU8arSSifhgKOdX3wlYzHlRjXExPhMdOxt6tgI
 ObD66mTj1QD7BPujKItC8tye7N+j96ssVBq+FHTE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jiyzo-001lrp-AO; Wed, 10 Jun 2020 12:34:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 3/4] KVM: arm64: Stop sparse from moaning at
 __hyp_this_cpu_ptr
Date: Wed, 10 Jun 2020 12:34:05 +0100
Message-Id: <20200610113406.1493170-4-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200610113406.1493170-1-maz@kernel.org>
References: <20200610113406.1493170-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, mark.rutland@arm.com, ascull@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

Sparse complains that __hyp_this_cpu_ptr() returns something
that is flagged noderef and not in the correct address space
(both being the result of the __percpu annotation).

Pretend that __hyp_this_cpu_ptr() knows what it is doing by
forcefully casting the pointer with __kernel __force.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---

Notes:
    v2: Add __verify_pcpu_ptr() as suggested by Andrew Scull.

 arch/arm64/include/asm/kvm_asm.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 0c9b5fc4ba0a..d9b7da15dbca 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,12 +81,19 @@ extern u32 __kvm_get_mdcr_el2(void);
 
 extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 
-/* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
+/*
+ * Home-grown __this_cpu_{ptr,read} variants that always work at HYP,
+ * provided that sym is really a *symbol* and not a pointer obtained from
+ * a data structure. As for SHIFT_PERCPU_PTR(), the creative casting keeps
+ * sparse quiet.
+ */
 #define __hyp_this_cpu_ptr(sym)						\
 	({								\
-		void *__ptr = hyp_symbol_addr(sym);			\
+		void *__ptr;						\
+		__verify_pcpu_ptr(&sym);				\
+		__ptr = hyp_symbol_addr(sym);				\
 		__ptr += read_sysreg(tpidr_el2);			\
-		(typeof(&sym))__ptr;					\
+		(typeof(sym) __kernel __force *)__ptr;			\
 	 })
 
 #define __hyp_this_cpu_read(sym)					\
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
