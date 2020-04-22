Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABBFFC55189
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:21:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 659C620CC7
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:21:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KA+ikTTQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 659C620CC7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 201114B160;
	Wed, 22 Apr 2020 08:21:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cN5JwN5q10SI; Wed, 22 Apr 2020 08:21:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21A644B172;
	Wed, 22 Apr 2020 08:21:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86EB74B13A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:21:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kGFB-cltO4wL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 08:21:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBA714B186
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:21:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D987B20784;
 Wed, 22 Apr 2020 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587558074;
 bh=emmdZiXQuwsaS8C+jg5oVpUxlihglO+d8zeL5CTB7iQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=KA+ikTTQqMUx+w/E9ILkb+7cEBFRlRjNkcpq8Y0MNjxIegOYZTZIj1IHFymNOHgP9
 6pcvMkjcfw5EeSebpM8TLyJG9tzGIQSoV+1AI2b52VdNpN4zvq4fOWmf7ExxrVJPSh
 YNQZ0sj4Iu9CrHfhP20ZR1rry0D8br6mkZ8EEoCM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRE41-005UI7-Tn; Wed, 22 Apr 2020 13:01:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 20/26] KVM: arm64: Move ELR_EL1 to the system register array
Date: Wed, 22 Apr 2020 13:00:44 +0100
Message-Id: <20200422120050.3693593-21-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com,
 will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
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

As ELR-EL1 is a VNCR-capable register with ARMv8.4-NV, let's move it to
the sys_regs array and repaint the accessors. While we're at it, let's
kill the now useless accessors used only on the fault injection path.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 21 ---------------------
 arch/arm64/include/asm/kvm_host.h    |  3 ++-
 arch/arm64/kvm/guest.c               |  2 +-
 arch/arm64/kvm/hyp/sysreg-sr.c       |  4 ++--
 arch/arm64/kvm/inject_fault.c        |  4 ++--
 arch/arm64/kvm/sys_regs.c            |  2 ++
 6 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c0d9363f328dc..1b8a396528851 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -133,27 +133,6 @@ static __always_inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->pc;
 }
 
-static inline unsigned long *__vcpu_elr_el1(const struct kvm_vcpu *vcpu)
-{
-	return (unsigned long *)&vcpu->arch.ctxt.elr_el1;
-}
-
-static inline unsigned long vcpu_read_elr_el1(const struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.sysregs_loaded_on_cpu)
-		return read_sysreg_el1(SYS_ELR);
-	else
-		return *__vcpu_elr_el1(vcpu);
-}
-
-static inline void vcpu_write_elr_el1(const struct kvm_vcpu *vcpu, unsigned long v)
-{
-	if (vcpu->arch.sysregs_loaded_on_cpu)
-		write_sysreg_el1(v, SYS_ELR);
-	else
-		*__vcpu_elr_el1(vcpu) = v;
-}
-
 static __always_inline unsigned long *vcpu_cpsr(const struct kvm_vcpu *vcpu)
 {
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->pstate;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 95977b80265ce..46949fce3e813 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -184,6 +184,8 @@ enum vcpu_sysreg {
 	APGAKEYLO_EL1,
 	APGAKEYHI_EL1,
 
+	ELR_EL1,
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
@@ -238,7 +240,6 @@ struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
 	u64	sp_el1;
-	u64	elr_el1;
 
 	u64	spsr[KVM_NR_SPSR];
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 9fec9231b63e2..ab99fe91c16d0 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -126,7 +126,7 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return &vcpu->arch.ctxt.sp_el1;
 
 	case KVM_REG_ARM_CORE_REG(elr_el1):
-		return &vcpu->arch.ctxt.elr_el1;
+		return __ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
 	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index d9dd19f39a537..1d862b81eb70a 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -62,7 +62,7 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
 
 	ctxt->sp_el1			= read_sysreg(sp_el1);
-	ctxt->elr_el1			= read_sysreg_el1(SYS_ELR);
+	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
 	ctxt->spsr[KVM_SPSR_EL1]	= read_sysreg_el1(SYS_SPSR);
 }
 
@@ -167,7 +167,7 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	}
 
 	write_sysreg(ctxt->sp_el1,			sp_el1);
-	write_sysreg_el1(ctxt->elr_el1,			SYS_ELR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
 	write_sysreg_el1(ctxt->spsr[KVM_SPSR_EL1],	SYS_SPSR);
 }
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 6aafc2825c1cb..d3ebf8bca4b89 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -116,7 +116,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
-	vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
+	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
 	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
@@ -151,7 +151,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
+	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
 	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5bda4af36a0e7..7c2fffb20c217 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -95,6 +95,7 @@ static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
 	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
 	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
+	case ELR_EL1:		*val = read_sysreg_s(SYS_ELR_EL12);	break;
 	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
 	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
@@ -135,6 +136,7 @@ static bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
 	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
 	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
+	case ELR_EL1:		write_sysreg_s(val, SYS_ELR_EL12);	break;
 	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
 	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
