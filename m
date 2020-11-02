Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D082C55179
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 16:41:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9FDFA22275
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 16:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2beK/tVd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FDFA22275
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50A6F4B4B6;
	Mon,  2 Nov 2020 11:41:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qGmxa4TzgNDC; Mon,  2 Nov 2020 11:41:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A64D34B459;
	Mon,  2 Nov 2020 11:41:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDF944B413
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 11:41:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WS1uUj6Y-FYy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 11:41:15 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC98C4B3F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 11:41:11 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C7AE5222EC;
 Mon,  2 Nov 2020 16:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604335270;
 bh=MkUn9Av/AAah0r2wMkUAQfkyvsPjRrzmZNMUmB7I/ZA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=2beK/tVdXDqUb5zVaFagtfGNAE3asYRpJKVOgdYO1W6SGsMq6vfOWh3ehI5kRqCXy
 qv1T8jIDKZ7LlIIFouwQcClpOpODBLv6CCOv/Urm98ncQj7oJ+DKY8ZJMGUBlm5geX
 Vsjq7gMLzXNhh4YGk8TF0kl2MNsQr3Mwt+BbD7SY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kZctJ-006jJf-1z; Mon, 02 Nov 2020 16:41:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 09/11] KVM: arm64: Remove SPSR manipulation primitives
Date: Mon,  2 Nov 2020 16:40:43 +0000
Message-Id: <20201102164045.264512-10-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164045.264512-1-maz@kernel.org>
References: <20201102164045.264512-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com,
 will@kernel.org, mark.rutland@arm.com, qperret@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

The SPSR setting code is now completely unused, including that dealing
with banked AArch32 SPSRs. Cleanup time.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 26 --------
 arch/arm64/kvm/regmap.c              | 96 ----------------------------
 2 files changed, 122 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 736a342dadf7..5d957d0e7b69 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -34,8 +34,6 @@ enum exception_type {
 };
 
 unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num);
-unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu);
-void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v);
 
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu);
@@ -180,30 +178,6 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
 }
 
-static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
-{
-	if (vcpu_mode_is_32bit(vcpu))
-		return vcpu_read_spsr32(vcpu);
-
-	if (vcpu->arch.sysregs_loaded_on_cpu)
-		return read_sysreg_el1(SYS_SPSR);
-	else
-		return __vcpu_sys_reg(vcpu, SPSR_EL1);
-}
-
-static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
-{
-	if (vcpu_mode_is_32bit(vcpu)) {
-		vcpu_write_spsr32(vcpu, v);
-		return;
-	}
-
-	if (vcpu->arch.sysregs_loaded_on_cpu)
-		write_sysreg_el1(v, SYS_SPSR);
-	else
-		__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
-}
-
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index accc1d5fba61..ae7e290bb017 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -126,99 +126,3 @@ unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num)
 
 	return reg_array + vcpu_reg_offsets[mode][reg_num];
 }
-
-/*
- * Return the SPSR for the current mode of the virtual CPU.
- */
-static int vcpu_spsr32_mode(const struct kvm_vcpu *vcpu)
-{
-	unsigned long mode = *vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK;
-	switch (mode) {
-	case PSR_AA32_MODE_SVC: return KVM_SPSR_SVC;
-	case PSR_AA32_MODE_ABT: return KVM_SPSR_ABT;
-	case PSR_AA32_MODE_UND: return KVM_SPSR_UND;
-	case PSR_AA32_MODE_IRQ: return KVM_SPSR_IRQ;
-	case PSR_AA32_MODE_FIQ: return KVM_SPSR_FIQ;
-	default: BUG();
-	}
-}
-
-unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
-{
-	int spsr_idx = vcpu_spsr32_mode(vcpu);
-
-	if (!vcpu->arch.sysregs_loaded_on_cpu) {
-		switch (spsr_idx) {
-		case KVM_SPSR_SVC:
-			return __vcpu_sys_reg(vcpu, SPSR_EL1);
-		case KVM_SPSR_ABT:
-			return vcpu->arch.ctxt.spsr_abt;
-		case KVM_SPSR_UND:
-			return vcpu->arch.ctxt.spsr_und;
-		case KVM_SPSR_IRQ:
-			return vcpu->arch.ctxt.spsr_irq;
-		case KVM_SPSR_FIQ:
-			return vcpu->arch.ctxt.spsr_fiq;
-		}
-	}
-
-	switch (spsr_idx) {
-	case KVM_SPSR_SVC:
-		return read_sysreg_el1(SYS_SPSR);
-	case KVM_SPSR_ABT:
-		return read_sysreg(spsr_abt);
-	case KVM_SPSR_UND:
-		return read_sysreg(spsr_und);
-	case KVM_SPSR_IRQ:
-		return read_sysreg(spsr_irq);
-	case KVM_SPSR_FIQ:
-		return read_sysreg(spsr_fiq);
-	default:
-		BUG();
-	}
-}
-
-void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
-{
-	int spsr_idx = vcpu_spsr32_mode(vcpu);
-
-	if (!vcpu->arch.sysregs_loaded_on_cpu) {
-		switch (spsr_idx) {
-		case KVM_SPSR_SVC:
-			__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
-			break;
-		case KVM_SPSR_ABT:
-			vcpu->arch.ctxt.spsr_abt = v;
-			break;
-		case KVM_SPSR_UND:
-			vcpu->arch.ctxt.spsr_und = v;
-			break;
-		case KVM_SPSR_IRQ:
-			vcpu->arch.ctxt.spsr_irq = v;
-			break;
-		case KVM_SPSR_FIQ:
-			vcpu->arch.ctxt.spsr_fiq = v;
-			break;
-		}
-
-		return;
-	}
-
-	switch (spsr_idx) {
-	case KVM_SPSR_SVC:
-		write_sysreg_el1(v, SYS_SPSR);
-		break;
-	case KVM_SPSR_ABT:
-		write_sysreg(v, spsr_abt);
-		break;
-	case KVM_SPSR_UND:
-		write_sysreg(v, spsr_und);
-		break;
-	case KVM_SPSR_IRQ:
-		write_sysreg(v, spsr_irq);
-		break;
-	case KVM_SPSR_FIQ:
-		write_sysreg(v, spsr_fiq);
-		break;
-	}
-}
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
