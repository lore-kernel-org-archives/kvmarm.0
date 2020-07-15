Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7BDC433E2
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47F9F20672
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Wc8zEvVt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47F9F20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0348D4B316;
	Wed, 15 Jul 2020 14:46:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yNTSIel+Ah6J; Wed, 15 Jul 2020 14:46:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABE594B3FB;
	Wed, 15 Jul 2020 14:46:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C545D4B3F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:46:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bTPHl7QS-0gx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:59 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 909E74B414
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:59 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id x37so1877404qvf.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=71/TOdECH5CUV1KOjaMf3rmU/Fwlx3ePs9xJ3fmTKuI=;
 b=Wc8zEvVtxfhmUXqp0w+VacSYS1XEWZu1YR4qEwjhSS+KFHv935Rj7vI0eclacsyWjT
 MAda4tZzfhd4ZkfhNda3zsmmNUK6VrY7EFC4S/h++jRFRqFjyxuV5to7kcusopAoLJIJ
 OwseiEvfuCCuCJbUBiMX9lWacL7y40cjarOiPiy2oPAy1CbnOIQ+3/hUVKC5ZVHsOztb
 V0dg1FScYkM/DVlykBKo2+Y59H49Fl84lJXB7sq3mK7cHeuCSBLXOFHw/4beolULTu4S
 AI+WgPGvDeNLuO+8Nzwyht69PIMFT5gtlFATv+vl77dbIPoBBPxkCr9T5nDbyVzxJEt3
 dbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=71/TOdECH5CUV1KOjaMf3rmU/Fwlx3ePs9xJ3fmTKuI=;
 b=cPXuEzyQ5qT1w8yqergfCtmlkLS8D5FTBAijqDK4a5DXxco2HS59fHNDlVq/NlqlNb
 73YllSnB5/NZMqY7GJFWlXvBSVmExFFeZmWnQtaN/dt6iKEivzq8T29gctPDuOFpBmam
 OHpmlQGue83eUpVdEiBY154Ynn6CAFj3ko6TONxpmSDIot2cRFMcianakLccRyqXde4N
 mVNSL4zoqKh7tYmfd7+21uzuOmdEiC6XSnTJ4fAbBHcNUdBFBUHMaoNJE1BfONxdBlmr
 Z6RUNC4FhSfcg9krMm9a751FOdKGCfT8IIQRBeEgLE7r2vOEYJRhRi2Ml6GJGGpXPgDE
 tLpA==
X-Gm-Message-State: AOAM532SLF1NXL+ZpI29Wo69epWZtRShjTpCPn+9X86FqfNs7qq4pjAp
 dLh6KW8jR3fCqK4+zq7gi1ApzIqZAcVk/f3ci/S1Xgp/eTqwEW0GZ+s4UhjQiLL3Lm+PhDw1jpM
 4vMsVAwmtjyvJ8Br1WKDuyrxxuzbKaNDQqKnjLEDlA5ZR8P15fn1rQPMNQv4msvE3N3rXYg==
X-Google-Smtp-Source: ABdhPJxPcT816I/mowhrxU8rIpggB3iBfWJ6isUIhqTqnqv7jgvgoGJCjy7/bYYKmqTwt9LF0F5Hj82ZijI=
X-Received: by 2002:ad4:4bb0:: with SMTP id i16mr760210qvw.42.1594838759017;
 Wed, 15 Jul 2020 11:45:59 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:33 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-33-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 32/37] KVM: arm64: nVHE: Unify sysreg state restoration paths
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

These sets of state are moved together as nVHE's speculative AT
workaround depends on their correct interaction. As a consequence of
this change, the workaround is much simpler as both the host and the
guests now share the same code path.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 48 ++++-------
 arch/arm64/kvm/hyp/nvhe/switch.c           | 96 +++++++++-------------
 2 files changed, 54 insertions(+), 90 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 0c24c922bae8..cffe7dd3df41 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -75,25 +75,6 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt_sys_reg(ctxt, MPIDR_EL1),	vmpidr_el2);
 	write_sysreg(ctxt_sys_reg(ctxt, CSSELR_EL1),	csselr_el1);
-
-	if (has_vhe() ||
-	    !cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
-		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
-	} else	if (!ctxt->is_host) {
-		/*
-		 * Must only be done for guest registers, hence the context
-		 * test. Pairs with nVHE's __activate_traps().
-		 */
-		write_sysreg_el1((ctxt_sys_reg(ctxt, TCR_EL1) |
-				  TCR_EPD1_MASK | TCR_EPD0_MASK),
-				 SYS_TCR);
-		isb();
-		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1] | SCTLR_ELx_M,
-				 SYS_SCTLR);
-		isb();
-	}
-
 	write_sysreg_el1(ctxt_sys_reg(ctxt, CPACR_EL1),	SYS_CPACR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL1),	SYS_TTBR0);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL1),	SYS_TTBR1);
@@ -109,23 +90,24 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),	par_el1);
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),	tpidr_el1);
 
-	if (!has_vhe() &&
-	    cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT) &&
-	    ctxt->is_host) {
+	if (!has_vhe()) {
 		/*
-		 * Must only be done for host registers, hence the context
-		 * test. Pairs with nVHE's __deactivate_traps().
+		 * For CPUs that are affected by the speculative AT errata,
+		 * ensure the vcpu's stage 1 and stage 2 translations have been
+		 * configured before before updating TCR_EL1 and SCTLR_EL1 to
+		 * potentially allow any speculative walks to occur. The stage
+		 * 2 will have already been configured by the nVHE switching
+		 * code before calling this function.
 		 */
-		isb();
-		/*
-		 * At this stage, and thanks to the above isb(), S2 is
-		 * deconfigured and disabled. We can now restore the host's
-		 * S1 configuration: SCTLR, and only then TCR.
-		 */
-		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
-		isb();
-		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
+		asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
+	}
+
+	write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
+	if (!has_vhe()) {
+		/* Ensure S1 MMU state is restored before allowing S1 walks. */
+		asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 	}
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
 
 	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1),	sp_el1);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 25c64392356b..c87b0a709d35 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -43,43 +43,12 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	}
 
 	write_sysreg(val, cptr_el2);
-
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
-
-		isb();
-		/*
-		 * At this stage, and thanks to the above isb(), S2 is
-		 * configured and enabled. We can now restore the guest's S1
-		 * configuration: SCTLR, and only then TCR.
-		 */
-		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
-		isb();
-		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
-	}
 }
 
 static void __deactivate_traps(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu)
 {
 	___deactivate_traps(vcpu);
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		u64 val;
-
-		/*
-		 * Set the TCR and SCTLR registers in the exact opposite
-		 * sequence as __activate_traps (first prevent walks,
-		 * then force the MMU on). A generous sprinkling of isb()
-		 * ensure that things happen in this exact order.
-		 */
-		val = read_sysreg_el1(SYS_TCR);
-		write_sysreg_el1(val | TCR_EPD1_MASK | TCR_EPD0_MASK, SYS_TCR);
-		isb();
-		val = read_sysreg_el1(SYS_SCTLR);
-		write_sysreg_el1(val | SCTLR_ELx_M, SYS_SCTLR);
-		isb();
-	}
-
 	__deactivate_traps_common();
 
 	write_sysreg(host_vcpu->arch.mdcr_el2, mdcr_el2);
@@ -87,9 +56,12 @@ static void __deactivate_traps(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
-static void __deactivate_vm(struct kvm_vcpu *vcpu)
+static void __restore_stage2(struct kvm_vcpu *vcpu)
 {
-	write_sysreg(0, vttbr_el2);
+	if (vcpu->arch.hcr_el2 & HCR_VM)
+		__activate_vm(kern_hyp_va(vcpu->arch.hw_mmu));
+	else
+		write_sysreg(0, vttbr_el2);
 }
 
 /* Save VGICv3 state on non-VHE systems */
@@ -147,8 +119,6 @@ static void __pmu_switch_to_host(void)
 static void __kvm_vcpu_switch_to_guest(struct kvm_vcpu *host_vcpu,
 				       struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
-
 	/*
 	 * Having IRQs masked via PMR when entering the guest means the GIC
 	 * will not signal the CPU of interrupts of lower priority, and the
@@ -162,35 +132,14 @@ static void __kvm_vcpu_switch_to_guest(struct kvm_vcpu *host_vcpu,
 
 	__pmu_switch_to_guest();
 
-	/*
-	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
-	 *
-	 * Also, and in order to be able to deal with erratum #1319537 (A57)
-	 * and #1319367 (A72), we must ensure that all VM-related sysreg are
-	 * restored before we enable S2 translation.
-	 */
-	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_state_nvhe(guest_ctxt);
-
-	__activate_vm(kern_hyp_va(vcpu->arch.hw_mmu));
-	__activate_traps(vcpu);
-
 	__timer_enable_traps(vcpu);
 }
 
 static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 				      struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
-
 	__timer_disable_traps(vcpu);
 
-	__deactivate_traps(host_vcpu, vcpu);
-	__deactivate_vm(vcpu);
-
-	__sysreg_restore_state_nvhe(&host_vcpu->arch.ctxt);
-
 	__pmu_switch_to_host();
 
 	/* Returning to host will clear PSR.I, remask PMR if needed */
@@ -228,6 +177,39 @@ static void __vcpu_restore_state(struct kvm_vcpu *vcpu, bool restore_debug)
 	else
 		__kvm_vcpu_switch_to_guest(running_vcpu, vcpu);
 
+	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
+		u64 val;
+
+		/*
+		 * Set the TCR and SCTLR registers to prevent any stage 1 or 2
+		 * page table walks or TLB allocations. A generous sprinkling
+		 * of isb() ensure that things happen in this exact order.
+		 */
+		val = read_sysreg_el1(SYS_TCR);
+		write_sysreg_el1(val | TCR_EPD1_MASK | TCR_EPD0_MASK, SYS_TCR);
+		isb();
+		val = read_sysreg_el1(SYS_SCTLR);
+		write_sysreg_el1(val | SCTLR_ELx_M, SYS_SCTLR);
+		isb();
+	}
+
+	/*
+	 * We must restore the 32-bit state before the sysregs, thanks to
+	 * erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
+	 *
+	 * Also, and in order to deal with the speculative AT errata, we must
+	 * ensure the S2 translation is restored before allowing page table
+	 * walks and TLB allocations when the sysregs are restored.
+	 */
+	__restore_stage2(vcpu);
+	__sysreg32_restore_state(vcpu);
+	__sysreg_restore_state_nvhe(&vcpu->arch.ctxt);
+
+	if (vcpu->arch.ctxt.is_host)
+		__deactivate_traps(vcpu, running_vcpu);
+	else
+		__activate_traps(vcpu);
+
 	__hyp_vgic_restore_state(vcpu);
 
 	/*
@@ -300,7 +282,7 @@ void __noreturn hyp_panic(void)
 	if (vcpu != host_vcpu) {
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(host_vcpu, vcpu);
-		__deactivate_vm(vcpu);
+		__restore_stage2(host_vcpu);
 		__sysreg_restore_state_nvhe(&host_vcpu->arch.ctxt);
 	}
 
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
