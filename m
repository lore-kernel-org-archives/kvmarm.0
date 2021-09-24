Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A5BC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DED56135E
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2DED56135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D85424B086;
	Fri, 24 Sep 2021 08:54:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qG6AFY+xqvDY; Fri, 24 Sep 2021 08:54:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B5204B186;
	Fri, 24 Sep 2021 08:54:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACB444B0ED
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rgCOSlwGHEOV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:15 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 746334B19A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:15 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 r15-20020adfce8f000000b0015df1098ccbso8021686wrn.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GNJXCwSAbei7X+d2zrSyKPjr3s2IaQgd3QwFYy/hAIU=;
 b=FgWbPgZcipmM7hDQfUPsPO0ieDHPnx6Sh8kB3YNh80tJE+M54GZgHyARNdv3SkWMP9
 FSzi0J6f9EIJPfjbRf1AFSSOW1Jo+/pz6JNlawA8iXeg5Fp9pgKDq/hCIO6xw1A4rWop
 5Q/QA+HIOhZ9eNuVlB0g2c3HSZX9DjA6BCPGN8x+H/jI/mqgI8+MrF0sHOhjfaag8B0b
 1E8Vfe1o34gnJVeKjdcqGdedCnwx9+69P0v2p9mdnzUuHO9uu1/r3/fEA9dhtQGc2nZM
 6tkk2EPfnh1zCzD55dDl/i7LIDH7jHzhKj2v3/lcj8EjKNnCO4AHNo0s09MGfzgAvGuD
 Pi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GNJXCwSAbei7X+d2zrSyKPjr3s2IaQgd3QwFYy/hAIU=;
 b=PG+Qge9gx+OTI4JP6t21MRZBivkiqJoGs2Id9/uYSRHYiu/iNzub94AaQhvftgTOS0
 +RizxYHT9sCDP9lRIUybms/jfDYu+EGwZyeAd67dXrhLMcgraJFqi4etOr4wYlVN5Bb3
 gAPY8NL5PwTPLGeAcS3zyChr6eBCBgb8JUTLunWzRYGVl58yqb0Q8zfIRGE5sLk+MZAP
 GaPPtL0gI2tKkSA01N8Rhm8XK+766lb36JP8nA3hSkwyrLlmzJzWlDFZtpiLVK/oAaHF
 exSbLq9vpZs7OqPdpVPtfn7oC1Z3bexcm3EVNqnECCPkWKgjcWnE4d0ICwE+d5YAFt3j
 Yz1g==
X-Gm-Message-State: AOAM532Jt76b8I7vCSPOvOUc3XH8SqWiNlwjfNWAivfHi1LfhuuD6Ipi
 vgJw7Xr+sU68YnMAQVlqjkEwG4Q4VYmgqzOHyH4UZU1rH625yLINmInFQ9nUm+D2Pr8JgkXgS3w
 EobYavnrFLBz4ZI4vx/dtc+oLnPvzb8rhfSASWW5t/6R701E4ekO7xdr+tNhlAwkKDqM=
X-Google-Smtp-Source: ABdhPJyoJ4ezBcFbxEorS+BChh9gJ7Ip4MIZRiUmXZuwwPnp+ovEAnjm0lg/pp1rPexQj9d9ps3gIy+HdA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:896:: with SMTP id
 l22mr1903656wmp.173.1632488054622; Fri, 24 Sep 2021 05:54:14 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:35 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-7-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 06/30] KVM: arm64: COCCI: use_ctxt_access.cocci: use
 kvm_cpu_context accessors
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Some parts of the code access vcpu->arch.ctxt directly instead of
using existing accessors. Refactor to use the existing accessors
to make the code more consistent and to simplify future patches.

This applies the semantic patch with the following command:

spatch --sp-file cocci_refactor/use_ctxt_access.cocci --dir arch/arm64/kvm/ --include-headers --in-place

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/fpsimd.c                    |  2 +-
 arch/arm64/kvm/guest.c                     | 28 +++++++++++-----------
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  4 ++--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 16 ++++++-------
 arch/arm64/kvm/reset.c                     | 10 ++++----
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 5621020b28de..db135588236a 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -97,7 +97,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
-		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fp_regs,
+		fpsimd_bind_state_to_cpu(vcpu_fp_regs(vcpu),
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl);
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5cb4a1cd5603..c4429307a164 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -116,49 +116,49 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
 		off -= KVM_REG_ARM_CORE_REG(regs.regs[0]);
 		off /= 2;
-		return &vcpu->arch.ctxt.regs.regs[off];
+		return &vcpu_gp_regs(vcpu)->regs[off];
 
 	case KVM_REG_ARM_CORE_REG(regs.sp):
-		return &vcpu->arch.ctxt.regs.sp;
+		return &vcpu_gp_regs(vcpu)->sp;
 
 	case KVM_REG_ARM_CORE_REG(regs.pc):
-		return &vcpu->arch.ctxt.regs.pc;
+		return &vcpu_gp_regs(vcpu)->pc;
 
 	case KVM_REG_ARM_CORE_REG(regs.pstate):
-		return &vcpu->arch.ctxt.regs.pstate;
+		return &vcpu_gp_regs(vcpu)->pstate;
 
 	case KVM_REG_ARM_CORE_REG(sp_el1):
-		return __ctxt_sys_reg(&vcpu->arch.ctxt, SP_EL1);
+		return &__vcpu_sys_reg(vcpu, SP_EL1);
 
 	case KVM_REG_ARM_CORE_REG(elr_el1):
-		return __ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
+		return &__vcpu_sys_reg(vcpu, ELR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_EL1]):
-		return __ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1);
+		return &__vcpu_sys_reg(vcpu, SPSR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_ABT]):
-		return &vcpu->arch.ctxt.spsr_abt;
+		return vcpu_spsr_abt(vcpu);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_UND]):
-		return &vcpu->arch.ctxt.spsr_und;
+		return vcpu_spsr_und(vcpu);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_IRQ]):
-		return &vcpu->arch.ctxt.spsr_irq;
+		return vcpu_spsr_irq(vcpu);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_FIQ]):
-		return &vcpu->arch.ctxt.spsr_fiq;
+		return vcpu_spsr_fiq(vcpu);
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
 	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
 		off -= KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]);
 		off /= 4;
-		return &vcpu->arch.ctxt.fp_regs.vregs[off];
+		return &vcpu_fp_regs(vcpu)->vregs[off];
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
-		return &vcpu->arch.ctxt.fp_regs.fpsr;
+		return &vcpu_fp_regs(vcpu)->fpsr;
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpcr):
-		return &vcpu->arch.ctxt.fp_regs.fpcr;
+		return &vcpu_fp_regs(vcpu)->fpcr;
 
 	default:
 		return NULL;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..9fa9cf71eefa 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -217,7 +217,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
-			    &vcpu->arch.ctxt.fp_regs.fpsr);
+			    &vcpu_fp_regs(vcpu)->fpsr);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
@@ -276,7 +276,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	if (sve_guest)
 		__hyp_sve_restore_guest(vcpu);
 	else
-		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
+		__fpsimd_restore_state(vcpu_fp_regs(vcpu));
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index cce43bfe158f..9451206f512e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -161,10 +161,10 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	vcpu->arch.ctxt.spsr_abt = read_sysreg(spsr_abt);
-	vcpu->arch.ctxt.spsr_und = read_sysreg(spsr_und);
-	vcpu->arch.ctxt.spsr_irq = read_sysreg(spsr_irq);
-	vcpu->arch.ctxt.spsr_fiq = read_sysreg(spsr_fiq);
+	*vcpu_spsr_abt(vcpu) = read_sysreg(spsr_abt);
+	*vcpu_spsr_und(vcpu) = read_sysreg(spsr_und);
+	*vcpu_spsr_irq(vcpu) = read_sysreg(spsr_irq);
+	*vcpu_spsr_fiq(vcpu) = read_sysreg(spsr_fiq);
 
 	__vcpu_sys_reg(vcpu, DACR32_EL2) = read_sysreg(dacr32_el2);
 	__vcpu_sys_reg(vcpu, IFSR32_EL2) = read_sysreg(ifsr32_el2);
@@ -178,10 +178,10 @@ static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	write_sysreg(vcpu->arch.ctxt.spsr_abt, spsr_abt);
-	write_sysreg(vcpu->arch.ctxt.spsr_und, spsr_und);
-	write_sysreg(vcpu->arch.ctxt.spsr_irq, spsr_irq);
-	write_sysreg(vcpu->arch.ctxt.spsr_fiq, spsr_fiq);
+	write_sysreg(*vcpu_spsr_abt(vcpu), spsr_abt);
+	write_sysreg(*vcpu_spsr_und(vcpu), spsr_und);
+	write_sysreg(*vcpu_spsr_irq(vcpu), spsr_irq);
+	write_sysreg(*vcpu_spsr_fiq(vcpu), spsr_fiq);
 
 	write_sysreg(__vcpu_sys_reg(vcpu, DACR32_EL2), dacr32_el2);
 	write_sysreg(__vcpu_sys_reg(vcpu, IFSR32_EL2), ifsr32_el2);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index d37ebee085cf..ab1ef5313a3e 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -258,11 +258,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
-	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
-	vcpu->arch.ctxt.spsr_abt = 0;
-	vcpu->arch.ctxt.spsr_und = 0;
-	vcpu->arch.ctxt.spsr_irq = 0;
-	vcpu->arch.ctxt.spsr_fiq = 0;
+	memset(vcpu_fp_regs(vcpu), 0, sizeof(*vcpu_fp_regs(vcpu)));
+	*vcpu_spsr_abt(vcpu) = 0;
+	*vcpu_spsr_und(vcpu) = 0;
+	*vcpu_spsr_irq(vcpu) = 0;
+	*vcpu_spsr_fiq(vcpu) = 0;
 	vcpu_gp_regs(vcpu)->pstate = pstate;
 
 	/* Reset system registers */
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
