Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30D6C433E4
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 13:33:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5802D2080D
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 13:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKFgg1IB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5802D2080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 019104B0F1;
	Mon, 15 Jun 2020 09:33:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HPC93NJ9K1ae; Mon, 15 Jun 2020 09:33:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 885194B127;
	Mon, 15 Jun 2020 09:33:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D9394B0EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 09:33:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZD42GusAhxT6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 09:33:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA6194B0DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 09:33:37 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 151F620739;
 Mon, 15 Jun 2020 13:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592228017;
 bh=6CKW1V6Vu9qi/0rHkSefjiW1WCUUezAl2awyfb9sRP0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=aKFgg1IBWU5h0BT2fPX+WQf51PThChKYNnG445kZ/gB994SPpchadx+bgxOjbMouU
 sEogbinqnoj2F/LlZMrK59EBt/oQFboKpf3t4dmwexWgU0bmqFxnInlxiAzEBD/2+a
 ed+QFK9kqc0ito4d73BqYoInwBzTFtxh+aPD5Mfw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jkp9R-0036w9-Dv; Mon, 15 Jun 2020 14:27:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 14/17] KVM: arm64: Disintegrate SPSR array
Date: Mon, 15 Jun 2020 14:27:16 +0100
Message-Id: <20200615132719.1932408-15-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200615132719.1932408-1-maz@kernel.org>
References: <20200615132719.1932408-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com,
 ascull@google.com, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>
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

As we're about to move SPSR_EL1 into the VNCR page, we need to
disassociate it from the rest of the 32bit cruft. Let's break
the array into individual fields.

Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  4 ++--
 arch/arm64/include/asm/kvm_host.h    |  6 ++++-
 arch/arm64/kvm/guest.c               | 19 +++++++++++----
 arch/arm64/kvm/hyp/sysreg-sr.c       | 28 ++++++++--------------
 arch/arm64/kvm/regmap.c              | 35 +++++++++++++++++++++++++---
 5 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3b1d32c639c2..83271a4d6c59 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -176,7 +176,7 @@ static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		return read_sysreg_el1(SYS_SPSR);
 	else
-		return vcpu->arch.ctxt.spsr[KVM_SPSR_EL1];
+		return vcpu->arch.ctxt.spsr_el1;
 }
 
 static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
@@ -189,7 +189,7 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(v, SYS_SPSR);
 	else
-		vcpu->arch.ctxt.spsr[KVM_SPSR_EL1] = v;
+		vcpu->arch.ctxt.spsr_el1 = v;
 }
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 22ca60408dea..7ab6f5b5bf5d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -241,7 +241,11 @@ enum vcpu_sysreg {
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
-	u64	spsr[KVM_NR_SPSR];
+	u64	spsr_el1;		/* aka spsr_svc */
+	u64	spsr_abt;
+	u64	spsr_und;
+	u64	spsr_irq;
+	u64	spsr_fiq;
 
 	struct user_fpsimd_state fp_regs;
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d614716e073b..70215f3a6f89 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -134,11 +134,20 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_CORE_REG(elr_el1):
 		return __ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
 
-	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
-	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
-		off -= KVM_REG_ARM_CORE_REG(spsr[0]);
-		off /= 2;
-		return &vcpu->arch.ctxt.spsr[off];
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_EL1]):
+		return &vcpu->arch.ctxt.spsr_el1;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_ABT]):
+		return &vcpu->arch.ctxt.spsr_abt;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_UND]):
+		return &vcpu->arch.ctxt.spsr_und;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_IRQ]):
+		return &vcpu->arch.ctxt.spsr_irq;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_FIQ]):
+		return &vcpu->arch.ctxt.spsr_fiq;
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
 	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 252d5c1240a3..4f54c1d28ff4 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -57,7 +57,7 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
-	ctxt->spsr[KVM_SPSR_EL1]	= read_sysreg_el1(SYS_SPSR);
+	ctxt->spsr_el1			= read_sysreg_el1(SYS_SPSR);
 }
 
 static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -157,7 +157,7 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 
 	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1),	sp_el1);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
-	write_sysreg_el1(ctxt->spsr[KVM_SPSR_EL1],	SYS_SPSR);
+	write_sysreg_el1(ctxt->spsr_el1,		SYS_SPSR);
 }
 
 static void __hyp_text
@@ -210,17 +210,13 @@ NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
 
 void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
-	u64 *spsr;
-
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	spsr = vcpu->arch.ctxt.spsr;
-
-	spsr[KVM_SPSR_ABT] = read_sysreg(spsr_abt);
-	spsr[KVM_SPSR_UND] = read_sysreg(spsr_und);
-	spsr[KVM_SPSR_IRQ] = read_sysreg(spsr_irq);
-	spsr[KVM_SPSR_FIQ] = read_sysreg(spsr_fiq);
+	vcpu->arch.ctxt.spsr_abt = read_sysreg(spsr_abt);
+	vcpu->arch.ctxt.spsr_und = read_sysreg(spsr_und);
+	vcpu->arch.ctxt.spsr_irq = read_sysreg(spsr_irq);
+	vcpu->arch.ctxt.spsr_fiq = read_sysreg(spsr_fiq);
 
 	__vcpu_sys_reg(vcpu, DACR32_EL2) = read_sysreg(dacr32_el2);
 	__vcpu_sys_reg(vcpu, IFSR32_EL2) = read_sysreg(ifsr32_el2);
@@ -231,17 +227,13 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 
 void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
-	u64 *spsr;
-
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	spsr = vcpu->arch.ctxt.spsr;
-
-	write_sysreg(spsr[KVM_SPSR_ABT], spsr_abt);
-	write_sysreg(spsr[KVM_SPSR_UND], spsr_und);
-	write_sysreg(spsr[KVM_SPSR_IRQ], spsr_irq);
-	write_sysreg(spsr[KVM_SPSR_FIQ], spsr_fiq);
+	write_sysreg(vcpu->arch.ctxt.spsr_abt, spsr_abt);
+	write_sysreg(vcpu->arch.ctxt.spsr_und, spsr_und);
+	write_sysreg(vcpu->arch.ctxt.spsr_irq, spsr_irq);
+	write_sysreg(vcpu->arch.ctxt.spsr_fiq, spsr_fiq);
 
 	write_sysreg(__vcpu_sys_reg(vcpu, DACR32_EL2), dacr32_el2);
 	write_sysreg(__vcpu_sys_reg(vcpu, IFSR32_EL2), ifsr32_el2);
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index b1596f314087..97c110810527 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -147,8 +147,20 @@ unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
 {
 	int spsr_idx = vcpu_spsr32_mode(vcpu);
 
-	if (!vcpu->arch.sysregs_loaded_on_cpu)
-		return vcpu->arch.ctxt.spsr[spsr_idx];
+	if (!vcpu->arch.sysregs_loaded_on_cpu) {
+		switch (spsr_idx) {
+		case KVM_SPSR_SVC:
+			return vcpu->arch.ctxt.spsr_el1;
+		case KVM_SPSR_ABT:
+			return vcpu->arch.ctxt.spsr_abt;
+		case KVM_SPSR_UND:
+			return vcpu->arch.ctxt.spsr_und;
+		case KVM_SPSR_IRQ:
+			return vcpu->arch.ctxt.spsr_irq;
+		case KVM_SPSR_FIQ:
+			return vcpu->arch.ctxt.spsr_fiq;
+		}
+	}
 
 	switch (spsr_idx) {
 	case KVM_SPSR_SVC:
@@ -171,7 +183,24 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
 	int spsr_idx = vcpu_spsr32_mode(vcpu);
 
 	if (!vcpu->arch.sysregs_loaded_on_cpu) {
-		vcpu->arch.ctxt.spsr[spsr_idx] = v;
+		switch (spsr_idx) {
+		case KVM_SPSR_SVC:
+			vcpu->arch.ctxt.spsr_el1 = v;
+			break;
+		case KVM_SPSR_ABT:
+			vcpu->arch.ctxt.spsr_abt = v;
+			break;
+		case KVM_SPSR_UND:
+			vcpu->arch.ctxt.spsr_und = v;
+			break;
+		case KVM_SPSR_IRQ:
+			vcpu->arch.ctxt.spsr_irq = v;
+			break;
+		case KVM_SPSR_FIQ:
+			vcpu->arch.ctxt.spsr_fiq = v;
+			break;
+		}
+
 		return;
 	}
 
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
