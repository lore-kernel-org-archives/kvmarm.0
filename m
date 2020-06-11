Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F65EC433E1
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 09:33:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25E1C20760
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 09:33:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SefjnXr1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25E1C20760
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A08D44B1AF;
	Thu, 11 Jun 2020 05:33:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jyeai+K8I6ie; Thu, 11 Jun 2020 05:33:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 818764B17D;
	Thu, 11 Jun 2020 05:33:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C11EA4B168
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 05:33:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F1JkRQBqW0kr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2020 05:33:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A123D4B164
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 05:33:22 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8D08D20747;
 Thu, 11 Jun 2020 09:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591868001;
 bh=9k1Z6Oc9tLld6mFM8g0LB4dGrlIcUbNndPsmAFUGesY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=SefjnXr1FArdFXM6HoG6yYiKFG+6zcCBmk1NZK7zvqUZtcoLekp5Ln/BBx/Jp0nBn
 r2S6cXk/v+ZjU5YNdoo4JIIrLMtpYkAFrDu6SnrMAmUgEWRE2Zh0wvZ1OP23lcuBP6
 SH8Hu+Udi95/tfwfOgKGv1zbjAZTBqXXQA2lZn34=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jjJDz-0022ZT-GD; Thu, 11 Jun 2020 10:10:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 11/11] KVM: arm64: Move hyp_symbol_addr() to kvm_asm.h
Date: Thu, 11 Jun 2020 10:09:56 +0100
Message-Id: <20200611090956.1537104-12-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611090956.1537104-1-maz@kernel.org>
References: <20200611090956.1537104-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 ascull@google.com, james.morse@arm.com, mark.rutland@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Recent refactoring of the arm64 code make it awkward to have
hyp_symbol_addr() in kvm_mmu.h. Instead, move it next to its
main user, which is __hyp_this_cpu_ptr().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h | 20 ++++++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 20 --------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index d9b7da15dbca..352aaebf4198 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,6 +81,26 @@ extern u32 __kvm_get_mdcr_el2(void);
 
 extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 
+/*
+ * Obtain the PC-relative address of a kernel symbol
+ * s: symbol
+ *
+ * The goal of this macro is to return a symbol's address based on a
+ * PC-relative computation, as opposed to a loading the VA from a
+ * constant pool or something similar. This works well for HYP, as an
+ * absolute VA is guaranteed to be wrong. Only use this if trying to
+ * obtain the address of a symbol (i.e. not something you obtained by
+ * following a pointer).
+ */
+#define hyp_symbol_addr(s)						\
+	({								\
+		typeof(s) *addr;					\
+		asm("adrp	%0, %1\n"				\
+		    "add	%0, %0, :lo12:%1\n"			\
+		    : "=r" (addr) : "S" (&s));				\
+		addr;							\
+	})
+
 /*
  * Home-grown __this_cpu_{ptr,read} variants that always work at HYP,
  * provided that sym is really a *symbol* and not a pointer obtained from
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 53bd4d517a4d..df485840005c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -107,26 +107,6 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 
 #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
 
-/*
- * Obtain the PC-relative address of a kernel symbol
- * s: symbol
- *
- * The goal of this macro is to return a symbol's address based on a
- * PC-relative computation, as opposed to a loading the VA from a
- * constant pool or something similar. This works well for HYP, as an
- * absolute VA is guaranteed to be wrong. Only use this if trying to
- * obtain the address of a symbol (i.e. not something you obtained by
- * following a pointer).
- */
-#define hyp_symbol_addr(s)						\
-	({								\
-		typeof(s) *addr;					\
-		asm("adrp	%0, %1\n"				\
-		    "add	%0, %0, :lo12:%1\n"			\
-		    : "=r" (addr) : "S" (&s));				\
-		addr;							\
-	})
-
 /*
  * We currently support using a VM-specified IPA size. For backward
  * compatibility, the default IPA size is fixed to 40bits.
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
