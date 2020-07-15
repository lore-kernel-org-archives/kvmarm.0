Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FCFC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9391F20787
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="W+x9HUJj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9391F20787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B13C4B3C6;
	Wed, 15 Jul 2020 14:44:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 56zHNAqg-dVP; Wed, 15 Jul 2020 14:44:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71A294B39D;
	Wed, 15 Jul 2020 14:44:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09EE54B3BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:44:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iJ3rHwWALTZY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:44:55 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 976184B334
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:44:55 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id b14so1973957wrp.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AgWHxC4ZZUmXuQaF0YyHtjeDjPSzAKEKxjTOvReyAjY=;
 b=W+x9HUJj1dbeM/DHGvY24aakMq0BFdrqCtUMylcr6jDnxBBwJp+wrzgWOt9CtCRCgl
 Y+iVvgOh14c9G9xoYI6gqK/0lmzXu55wJipoFyvjf17+PQmyRmImGNb9srZQRNfK+YNb
 Jt4Jas3pqH6Vos+pjEpLH2L22t2uRB/l2u0f6l5PFQX+LaFVQ7UzSK2rpccfWQsObAD2
 MArEHVgLeuAdAlrHMYJ0ohax3Rw2KhoUSwq/d2GmrA0AzkN3cKV/7dNTtWpRAtUOr2qr
 YTANVo1xiA+5oB0O37LVtyE651WZLPl2/SkMw9j8LZnb8WS56bWRe6cCD0Y1JdeJSsbK
 IOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AgWHxC4ZZUmXuQaF0YyHtjeDjPSzAKEKxjTOvReyAjY=;
 b=J3qu4HGkKYKFt7lEUkCtMIyn8Gra74yrh3VMVfZgMkGcQVTJW0VA/OmlsdNRtRHGHm
 76rti8l3HGh2G6d+RU2a98j/dfcBR+2iXZLmatvqzERsMoOO3GX4En1RW3lTTs4FvtPm
 hGV7Bb071B15pU98UrK8UCiVysBxI7eCjdjkL0INw5XRxtmwAs6ANyDgZRcyt5w9DWsV
 5zojwuGJ8AGyVqUGprDrnscQhJjcz1TO3DV6cii8p4Hy6mCr8dAajwKoaUym06R4cbHR
 4ssoaKGgvV+ogIaGkDsXct76TAXSSjMahckcD3RWm2xHTWjV3LEXK7cUNyVH0Ic0n7b7
 SIqA==
X-Gm-Message-State: AOAM532hvzZBFMLS1RdsnsyR21ZRdqe9R6qKWAjtwrpvE7zHLd9Ljctf
 yrVuvLdNYaRhcr+i1qrDNMThhu2Te5UB8Otrsxxh+/IhES2olVF59zoWriqGSH+/LFE7zy0QTMe
 ECHj3DEP7QCKCq88MtvCNLkmyEcqyg7hdcR4Yw1+SwWqyLwgVUAy6HYHdOyFLbD0fnoze5A==
X-Google-Smtp-Source: ABdhPJyRbb2HLlMp13GTLDFhuOAm7Om8IufPRMaV9carnYgao+E7sWbvX2F1PDxnsz1XW5yJYouyRnBZ3DU=
X-Received: by 2002:a1c:5581:: with SMTP id j123mr715723wmb.75.1594838694621; 
 Wed, 15 Jul 2020 11:44:54 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:04 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-4-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 03/37] KVM: arm64: Track running vCPU outside of the CPU
 context
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

The running vCPU has little to do with the CPU context so extract it to
a percpu variable.

Unfortunately, the __hyp_running_vcpu field was also being used to
identify the CPU context of the host, in the nVHE speculative AT
workaround, since it will be non-NULL for the host and NULL for the
guests. This is handled by having an explicit identificaiton of the host
context which also makes the workaround conditions much easier to
comprehend.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h           |  5 -----
 arch/arm64/include/asm/kvm_host.h          |  4 +++-
 arch/arm64/include/asm/kvm_hyp.h           |  2 ++
 arch/arm64/kernel/asm-offsets.c            |  1 -
 arch/arm64/kernel/image-vars.h             |  1 +
 arch/arm64/kvm/arm.c                       | 10 ++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S             | 10 +++++-----
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c           |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c            |  5 ++---
 10 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index fb1a922b31ba..ebe9d582f360 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -188,11 +188,6 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 	add	\reg, \reg, #HOST_DATA_CONTEXT
 .endm
 
-.macro get_vcpu_ptr vcpu, ctxt
-	get_host_ctxt \ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-.endm
-
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b06f24b5f443..67a760d08b6e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -260,7 +260,7 @@ struct kvm_cpu_context {
 		u32 copro[NR_COPRO_REGS];
 	};
 
-	struct kvm_vcpu *__hyp_running_vcpu;
+	bool is_host;
 };
 
 struct kvm_pmu_events {
@@ -578,6 +578,8 @@ DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
 
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
+	cpu_ctxt->is_host = true;
+
 	/* The host's MPIDR is immutable, so let's set it up at boot time */
 	ctxt_sys_reg(cpu_ctxt, MPIDR_EL1) = read_cpuid_mpidr();
 }
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 46689e7db46c..07745d9c49fc 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -12,6 +12,8 @@
 #include <asm/alternative.h>
 #include <asm/sysreg.h>
 
+DECLARE_PER_CPU(struct kvm_vcpu *, kvm_hyp_running_vcpu);
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 7d32fc959b1a..cbe6a0def777 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -108,7 +108,6 @@ int main(void)
   DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
   DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
   DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
-  DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
 #endif
 #ifdef CONFIG_CPU_PM
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 9e897c500237..dfe0f37567f3 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -71,6 +71,7 @@ KVM_NVHE_ALIAS(kvm_update_va_mask);
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
 KVM_NVHE_ALIAS(kvm_host_data);
+KVM_NVHE_ALIAS(kvm_hyp_running_vcpu);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
 /* Kernel constant needed to compute idmap addresses. */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 98f05bdac3c1..94f4481e5637 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
 #endif
 
 DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
+DEFINE_PER_CPU(struct kvm_vcpu *, kvm_hyp_running_vcpu);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
 /* The VMID used in the VTTBR */
@@ -1537,6 +1538,7 @@ static int init_hyp_mode(void)
 
 	for_each_possible_cpu(cpu) {
 		kvm_host_data_t *cpu_data;
+		struct kvm_vcpu **running_vcpu;
 
 		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
 		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
@@ -1545,6 +1547,14 @@ static int init_hyp_mode(void)
 			kvm_err("Cannot map host CPU state: %d\n", err);
 			goto out_err;
 		}
+
+		running_vcpu = per_cpu_ptr(&kvm_hyp_running_vcpu, cpu);
+		err = create_hyp_mappings(running_vcpu, running_vcpu + 1, PAGE_HYP);
+
+		if (err) {
+			kvm_err("Cannot map running vCPU: %d\n", err);
+			goto out_err;
+		}
 	}
 
 	err = hyp_map_aux_data();
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 689fccbc9de7..e727bee8e110 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -96,7 +96,7 @@ el1_hvc_guest:
 alternative_cb	arm64_enable_wa2_handling
 	b	wa2_end
 alternative_cb_end
-	get_vcpu_ptr	x2, x0
+	hyp_ldr_this_cpu x2, kvm_hyp_running_vcpu, x0
 	ldr	x0, [x2, #VCPU_WORKAROUND_FLAGS]
 
 	// Sanitize the argument and update the guest flags
@@ -128,17 +128,17 @@ wa_epilogue:
 	sb
 
 el1_trap:
-	get_vcpu_ptr	x1, x0
+	hyp_ldr_this_cpu x1, kvm_hyp_running_vcpu, x0
 	mov	x0, #ARM_EXCEPTION_TRAP
 	b	__guest_exit
 
 el1_irq:
-	get_vcpu_ptr	x1, x0
+	hyp_ldr_this_cpu x1, kvm_hyp_running_vcpu, x0
 	mov	x0, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
 
 el1_error:
-	get_vcpu_ptr	x1, x0
+	hyp_ldr_this_cpu x1, kvm_hyp_running_vcpu, x0
 	mov	x0, #ARM_EXCEPTION_EL1_SERROR
 	b	__guest_exit
 
@@ -151,7 +151,7 @@ el2_sync:
 	b.eq	__hyp_panic
 
 	/* Let's attempt a recovery from the illegal exception return */
-	get_vcpu_ptr	x1, x0
+	hyp_ldr_this_cpu x1, kvm_hyp_running_vcpu, x0
 	mov	x0, #ARM_EXCEPTION_IL
 	b	__guest_exit
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 7a986030145f..c55b2d17ada8 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -80,7 +80,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	    !cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
 		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
-	} else	if (!ctxt->__hyp_running_vcpu) {
+	} else	if (!ctxt->is_host) {
 		/*
 		 * Must only be done for guest registers, hence the context
 		 * test. We're coming from the host, so SCTLR.M is already
@@ -109,7 +109,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 
 	if (!has_vhe() &&
 	    cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT) &&
-	    ctxt->__hyp_running_vcpu) {
+	    ctxt->is_host) {
 		/*
 		 * Must only be done for host registers, hence the context
 		 * test. Pairs with nVHE's __deactivate_traps().
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 341be2f2f312..99cf90200bf7 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -176,7 +176,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu = kern_hyp_va(vcpu);
 
 	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
-	host_ctxt->__hyp_running_vcpu = vcpu;
+	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
@@ -247,7 +247,7 @@ void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
-	struct kvm_vcpu *vcpu = host_ctxt->__hyp_running_vcpu;
+	struct kvm_vcpu *vcpu = __hyp_this_cpu_read(kvm_hyp_running_vcpu);
 	unsigned long str_va;
 
 	if (read_sysreg(vttbr_el2)) {
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c52d714e0d75..366dc386224c 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -109,7 +109,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	u64 exit_code;
 
 	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
-	host_ctxt->__hyp_running_vcpu = vcpu;
+	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	sysreg_save_host_state_vhe(host_ctxt);
@@ -195,8 +195,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 static void __hyp_call_panic(u64 spsr, u64 elr, u64 par,
 			     struct kvm_cpu_context *host_ctxt)
 {
-	struct kvm_vcpu *vcpu;
-	vcpu = host_ctxt->__hyp_running_vcpu;
+	struct kvm_vcpu *vcpu = __hyp_this_cpu_read(kvm_hyp_running_vcpu);
 
 	__deactivate_traps(vcpu);
 	sysreg_restore_host_state_vhe(host_ctxt);
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
