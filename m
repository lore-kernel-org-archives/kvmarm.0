Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B9CC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:25:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4125322CF7
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:25:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlxIEEbn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4125322CF7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF0D4B4CB;
	Wed,  5 Aug 2020 14:25:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SANnKfD6jNx1; Wed,  5 Aug 2020 14:25:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB2494B4C6;
	Wed,  5 Aug 2020 14:25:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0F164B47D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:25:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BTfrJpiZ08G3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 14:25:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5A6E4B431
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:25:53 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 15BB822CAD;
 Wed,  5 Aug 2020 18:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596651953;
 bh=iQrgl1SR5MMHV2cl+4A1hbUWVDZDb6J94PO8R4zNjcE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hlxIEEbn7vcEg9fhqQg9O7FfjjuskRRAqfZ6QNEDTZNsbtcXhNUR3D0gsu+NmAodq
 CJdpyZ5avUIDQXS9cSsjIKmTO4dU58pM3Bo15B+n80LHtxq7uBsnMYFdvLc5bvnX/G
 3h7ABWg/yE1U4qmBTHE/tFPjooWDDOEWxeqBih1I=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3Nfu-0004w9-Pk; Wed, 05 Aug 2020 18:58:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 45/56] KVM: arm64: Move SPSR_EL1 to the system register array
Date: Wed,  5 Aug 2020 18:56:49 +0100
Message-Id: <20200805175700.62775-46-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SPSR_EL1 being a VNCR-capable register with ARMv8.4-NV, move it to
the sysregs array and update the accessors.

Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h       | 4 ++--
 arch/arm64/include/asm/kvm_host.h          | 2 +-
 arch/arm64/kvm/guest.c                     | 2 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 4 ++--
 arch/arm64/kvm/regmap.c                    | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5f959fedff09..57f9042e7270 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -176,7 +176,7 @@ static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		return read_sysreg_el1(SYS_SPSR);
 	else
-		return vcpu->arch.ctxt.spsr_el1;
+		return __vcpu_sys_reg(vcpu, SPSR_EL1);
 }
 
 static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
@@ -189,7 +189,7 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(v, SYS_SPSR);
 	else
-		vcpu->arch.ctxt.spsr_el1 = v;
+		__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
 }
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dfb97ed2f680..91b1adb6789c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -187,6 +187,7 @@ enum vcpu_sysreg {
 
 	ELR_EL1,
 	SP_EL1,
+	SPSR_EL1,
 
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
@@ -241,7 +242,6 @@ enum vcpu_sysreg {
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
-	u64	spsr_el1;		/* aka spsr_svc */
 	u64	spsr_abt;
 	u64	spsr_und;
 	u64	spsr_irq;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 70215f3a6f89..dfb5218137ca 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -135,7 +135,7 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return __ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_EL1]):
-		return &vcpu->arch.ctxt.spsr_el1;
+		return __ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_ABT]):
 		return &vcpu->arch.ctxt.spsr_abt;
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index fb4bc42e72c5..7a986030145f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -48,7 +48,7 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
-	ctxt->spsr_el1			= read_sysreg_el1(SYS_SPSR);
+	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
 }
 
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -127,7 +127,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 
 	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1),	sp_el1);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
-	write_sysreg_el1(ctxt->spsr_el1,		SYS_SPSR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1),	SYS_SPSR);
 }
 
 static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index 97c110810527..accc1d5fba61 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -150,7 +150,7 @@ unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.sysregs_loaded_on_cpu) {
 		switch (spsr_idx) {
 		case KVM_SPSR_SVC:
-			return vcpu->arch.ctxt.spsr_el1;
+			return __vcpu_sys_reg(vcpu, SPSR_EL1);
 		case KVM_SPSR_ABT:
 			return vcpu->arch.ctxt.spsr_abt;
 		case KVM_SPSR_UND:
@@ -185,7 +185,7 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
 	if (!vcpu->arch.sysregs_loaded_on_cpu) {
 		switch (spsr_idx) {
 		case KVM_SPSR_SVC:
-			vcpu->arch.ctxt.spsr_el1 = v;
+			__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
 			break;
 		case KVM_SPSR_ABT:
 			vcpu->arch.ctxt.spsr_abt = v;
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
