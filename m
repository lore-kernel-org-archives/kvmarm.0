Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82644C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:47:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 404204B4BB;
	Thu, 19 May 2022 09:47:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w9GMibAaVgd7; Thu, 19 May 2022 09:47:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DA234B49E;
	Thu, 19 May 2022 09:47:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A864B443
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ODGuW2bYDSCG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:47:44 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80A254B481
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:44 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id AF9D2B824AF;
 Thu, 19 May 2022 13:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA43C34115;
 Thu, 19 May 2022 13:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968062;
 bh=U5L7YKpcVZ4RGBMLh9l/9JmqOUeaR68eA9xYHCvM3eA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Q+Ks1TY6Op73OxzQK3ChLtd/TSZuV9gBh2YroRocI9RKFy09F1zcAGk9CdV3M5IxC
 XjhGIB1gsZkQe+MAXANKkVhd2iTHJNKBC7gJs2+ZVaIPmtCJlmr+P0nrm/+DqRn5p9
 KyDWNcTpwlkiOkDYlZhOAv6aa6DnFue54lCccxOch7gHIXVij5y8nhgsdN6nTqB+9r
 1WzVTquG5+Kig1mctkHhHOS6BI+MtGMuJCiE7a2vXnE2MKO3ptt2MHBW5821u3HxJ3
 lPU9JocWCCzZZS0aX4Vt048eG6NXkFJjZCJ4bIAjVtxD5S1VidlCnPPcepaNbSOEgL
 CoamQoUCITO4g==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 80/89] KVM: arm64: Refactor enter_exception64()
Date: Thu, 19 May 2022 14:41:55 +0100
Message-Id: <20220519134204.5379-81-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

In order to simplify the injection of exceptions in the host in pkvm
context, let's factor out of enter_exception64() the code calculating
the exception offset from VBAR_EL1 and the cpsr.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  5 ++
 arch/arm64/kvm/hyp/exception.c       | 89 ++++++++++++++++------------
 2 files changed, 57 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 2a79c861b8e0..8b6c391bbee8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -41,6 +41,11 @@ void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
+unsigned long get_except64_offset(unsigned long psr, unsigned long target_mode,
+				  enum exception_type type);
+unsigned long get_except64_cpsr(unsigned long old, bool has_mte,
+				unsigned long sctlr, unsigned long mode);
+
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
 static inline int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index c5d009715402..14a80b0e2f91 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -60,31 +60,12 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
 		vcpu->arch.ctxt.spsr_und = val;
 }
 
-/*
- * This performs the exception entry at a given EL (@target_mode), stashing PC
- * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
- * The EL passed to this function *must* be a non-secure, privileged mode with
- * bit 0 being set (PSTATE.SP == 1).
- *
- * When an exception is taken, most PSTATE fields are left unchanged in the
- * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
- * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
- * layouts, so we don't need to shuffle these for exceptions from AArch32 EL0.
- *
- * For the SPSR_ELx layout for AArch64, see ARM DDI 0487E.a page C5-429.
- * For the SPSR_ELx layout for AArch32, see ARM DDI 0487E.a page C5-426.
- *
- * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
- * MSB to LSB.
- */
-static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
-			      enum exception_type type)
+unsigned long get_except64_offset(unsigned long psr, unsigned long target_mode,
+				  enum exception_type type)
 {
-	unsigned long sctlr, vbar, old, new, mode;
+	u64 mode = psr & (PSR_MODE_MASK | PSR_MODE32_BIT);
 	u64 exc_offset;
 
-	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
-
 	if      (mode == target_mode)
 		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
 	else if ((mode | PSR_MODE_THREAD_BIT) == target_mode)
@@ -94,28 +75,32 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	else
 		exc_offset = LOWER_EL_AArch32_VECTOR;
 
-	switch (target_mode) {
-	case PSR_MODE_EL1h:
-		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL1);
-		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
-		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
-		break;
-	default:
-		/* Don't do that */
-		BUG();
-	}
-
-	*vcpu_pc(vcpu) = vbar + exc_offset + type;
+	return exc_offset + type;
+}
 
-	old = *vcpu_cpsr(vcpu);
-	new = 0;
+/*
+ * When an exception is taken, most PSTATE fields are left unchanged in the
+ * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
+ * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
+ * layouts, so we don't need to shuffle these for exceptions from AArch32 EL0.
+ *
+ * For the SPSR_ELx layout for AArch64, see ARM DDI 0487E.a page C5-429.
+ * For the SPSR_ELx layout for AArch32, see ARM DDI 0487E.a page C5-426.
+ *
+ * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
+ * MSB to LSB.
+ */
+unsigned long get_except64_cpsr(unsigned long old, bool has_mte,
+				unsigned long sctlr, unsigned long target_mode)
+{
+	u64 new = 0;
 
 	new |= (old & PSR_N_BIT);
 	new |= (old & PSR_Z_BIT);
 	new |= (old & PSR_C_BIT);
 	new |= (old & PSR_V_BIT);
 
-	if (kvm_has_mte(vcpu->kvm))
+	if (has_mte)
 		new |= PSR_TCO_BIT;
 
 	new |= (old & PSR_DIT_BIT);
@@ -151,6 +136,36 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 
 	new |= target_mode;
 
+	return new;
+}
+
+/*
+ * This performs the exception entry at a given EL (@target_mode), stashing PC
+ * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
+ * The EL passed to this function *must* be a non-secure, privileged mode with
+ * bit 0 being set (PSTATE.SP == 1).
+ */
+static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
+			      enum exception_type type)
+{
+	u64 offset = get_except64_offset(*vcpu_cpsr(vcpu), target_mode, type);
+	unsigned long sctlr, vbar, old, new;
+
+	switch (target_mode) {
+	case PSR_MODE_EL1h:
+		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL1);
+		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
+		break;
+	default:
+		/* Don't do that */
+		BUG();
+	}
+
+	*vcpu_pc(vcpu) = vbar + offset;
+
+	old = *vcpu_cpsr(vcpu);
+	new = get_except64_cpsr(old, kvm_has_mte(vcpu->kvm), sctlr, target_mode);
 	*vcpu_cpsr(vcpu) = new;
 	__vcpu_write_spsr(vcpu, old);
 }
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
