Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F9BC433F8
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CB0820787
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="F14nuYSd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CB0820787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55AFD4B3B2;
	Wed, 15 Jul 2020 14:45:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LCezeFloBiUD; Wed, 15 Jul 2020 14:45:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D08D4B3CF;
	Wed, 15 Jul 2020 14:45:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79C464B357
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id svEMa1WYMkHT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:43 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 105794B3C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:43 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id g187so1765493wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Dxn2C6VU+EXHVP1mw/rwICDIlgtSB6FBnofh1XFZ4gY=;
 b=F14nuYSdzRd0YEhlTCu6OKBWyr7IOjBb2ub7N9/Da+hyPdt8jY177iDKh4pZuUxft4
 UPA+IkXLVqtcMiJoJMBtILSDhV9NLhnC/U6hMOWZvPDiWpPZ9yC0KWtQRhq2cnDNj54x
 Vm4/XXUpU/z3CMg+GLGVNhZzNPJC5WJ8tvqWP8NTRJRG7WrI+5dPEVrfPd5bB6aURmdQ
 SHbg++4c63Zp2YyrCFgO1Cb2iLF9TIUlThUAHc1ALbtt8YyVdCSjY4Vt2Wp48WNWwjG6
 n92qiCN8Agos5GyEbYblq4qBNbFqmV96HdjwauLP9BLJjXUUERhfAruiuSsiS+OHzNNO
 /trQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Dxn2C6VU+EXHVP1mw/rwICDIlgtSB6FBnofh1XFZ4gY=;
 b=iGp4FRpDiNx0hiQRuOux1UcbRL2gzQ7z1ASiAHZ4dGsPttQqAOL027iX48ZokGZYWK
 irNv1jHktqympiaDF44RPoumLMur3QTb0U7Kv/VNZSnwwJdb0VtOAw0jKdBQ1iq4pXJD
 zRRIN/0oPSsbdzQMxGEmSGrzHj5X8vWOl34WR1D24WnF8OfvQeMWBdsEUPsc2SlGDBw3
 NYa4joXYl7Mo4Za9u90TJ4ZvvDNPL0GQFoBi3IRGFoUQooo6pwrV5k0SmFPgF6Im73Kg
 n3oLI06SCsPHdvIbhUFqBiqJ8tr4SPhXuCjiyzSdI4Z/9XUPP3Lnua9U3LPiKvsm6rPt
 rz3A==
X-Gm-Message-State: AOAM533oRn730/oabzzaRzW+tEh/H9WcqtwKS2+nCUT+E22QJn8wUvnn
 agv4tb10w8v+sF2TSypeQAbtBBxhObAi/AA0Y1R0yiP9GsQg1YM8C2v+wjDUb/aGQVqpFF8SWj6
 /GiV1yqNd3gOsJdFtoxtSUdh6aeAvwLJAw5yIJGP7/76q6H6ICdhYRNZ122fq1318zeRrfg==
X-Google-Smtp-Source: ABdhPJx5JQmGQTGhOwQPPS805PjQ5FKOMjQdwZ9oDQL2iF0jRL0pwcZx2Dv8WihR0bkSQg0xi5XHEtx9UIw=
X-Received: by 2002:a1c:ed05:: with SMTP id l5mr786907wmh.68.1594838742078;
 Wed, 15 Jul 2020 11:45:42 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:25 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-25-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 24/37] KVM: arm64: Break apart kvm_host_data
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

The host_ctxt field is used for the host's state with VHE but it's used
for the hyp state with nVHE. Using separate variables for these
different contexts makes the difference clear and will allow for any
divergences.

But then kvm_host_data only contains pmu_events so it seems reasonable
to make that standalone as well.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h        |  9 ++++---
 arch/arm64/include/asm/kvm_host.h       |  9 +------
 arch/arm64/include/asm/kvm_hyp.h        | 13 +++++++++-
 arch/arm64/kernel/asm-offsets.c         |  1 -
 arch/arm64/kernel/image-vars.h          |  3 ++-
 arch/arm64/kvm/arm.c                    | 33 ++++++++++++++++---------
 arch/arm64/kvm/hyp/entry.S              | 14 +++++------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-start.S     |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 10 ++++----
 arch/arm64/kvm/hyp/vhe/debug-sr.c       |  4 +--
 arch/arm64/kvm/hyp/vhe/switch.c         |  4 +--
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |  4 +--
 arch/arm64/kvm/pmu.c                    | 28 ++++++++++-----------
 14 files changed, 79 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 1b2c718fa58f..ec71d3bcf5f5 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -207,9 +207,12 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 	ldr	\reg,  [\reg, \tmp]
 .endm
 
-.macro get_host_ctxt reg, tmp
-	hyp_adr_this_cpu \reg, kvm_host_data, \tmp
-	add	\reg, \reg, #HOST_DATA_CONTEXT
+.macro get_hyp_ctxt reg, tmp
+#ifdef __KVM_NVHE_HYPERVISOR__
+	hyp_adr_this_cpu \reg, kvm_hyp_ctxt, \tmp
+#else
+	hyp_adr_this_cpu \reg, kvm_host_ctxt, \tmp
+#endif
 .endm
 
 #define CPU_XREG_OFFSET(x)	(CPU_USER_PT_REGS + 8*x)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 37e94a49b668..c8304f82ccb3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -269,13 +269,6 @@ struct kvm_pmu_events {
 	u32 events_guest;
 };
 
-struct kvm_host_data {
-	struct kvm_cpu_context host_ctxt;
-	struct kvm_pmu_events pmu_events;
-};
-
-typedef struct kvm_host_data kvm_host_data_t;
-
 struct vcpu_reset_state {
 	unsigned long	pc;
 	unsigned long	r0;
@@ -568,7 +561,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
-DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
+DECLARE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
 
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 32b438c1da4e..38d49f9b56c7 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -14,12 +14,23 @@
 
 DECLARE_PER_CPU(struct kvm_vcpu *, kvm_hyp_running_vcpu);
 #ifdef __KVM_NVHE_HYPERVISOR__
+DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DECLARE_PER_CPU(struct kvm_vcpu, kvm_host_vcpu);
 DECLARE_PER_CPU(u64, kvm_host_pmscr_el1);
 #else
+DECLARE_PER_CPU(struct kvm_cpu_context, kvm_host_ctxt);
 DECLARE_PER_CPU(struct kvm_guest_debug_arch, kvm_host_debug_state);
 #endif
 
+static inline struct kvm_cpu_context *get_hyp_ctxt(void)
+{
+#ifdef __KVM_NVHE_HYPERVISOR__
+	return __hyp_this_cpu_ptr(kvm_hyp_ctxt);
+#else
+	return __hyp_this_cpu_ptr(kvm_host_ctxt);
+#endif
+}
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
@@ -100,7 +111,7 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
 void deactivate_traps_vhe_put(void);
 #endif
 
-u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
+u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *hyp_ctxt);
 
 void __vaxorcize_serror(void);
 
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index cbe6a0def777..9e78f79c42c0 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -108,7 +108,6 @@ int main(void)
   DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
   DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
   DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
-  DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
 #endif
 #ifdef CONFIG_CPU_PM
   DEFINE(CPU_CTX_SP,		offsetof(struct cpu_suspend_ctx, sp));
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index c75d74adfc8b..70b5b320587e 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -70,10 +70,11 @@ KVM_NVHE_ALIAS(kvm_update_va_mask);
 
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
-KVM_NVHE_ALIAS(kvm_host_data);
 KVM_NVHE_ALIAS(kvm_host_pmscr_el1);
 KVM_NVHE_ALIAS(kvm_host_vcpu);
+KVM_NVHE_ALIAS(kvm_hyp_ctxt);
 KVM_NVHE_ALIAS(kvm_hyp_running_vcpu);
+KVM_NVHE_ALIAS(kvm_pmu_events);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
 /* Kernel constant needed to compute idmap addresses. */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cb8ac29195be..1e659bebe471 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -46,8 +46,10 @@
 __asm__(".arch_extension	virt");
 #endif
 
-DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
+DEFINE_PER_CPU(struct kvm_cpu_context, kvm_host_ctxt);
+DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(struct kvm_vcpu, kvm_host_vcpu);
+DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
 DEFINE_PER_CPU(struct kvm_vcpu *, kvm_hyp_running_vcpu);
 DEFINE_PER_CPU(struct kvm_guest_debug_arch, kvm_host_debug_state);
 DEFINE_PER_CPU(u64, kvm_host_pmscr_el1);
@@ -1277,8 +1279,8 @@ static void cpu_init_hyp_mode(void)
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
 	 * so that we can use adr_l to access per-cpu variables in EL2.
 	 */
-	tpidr_el2 = ((unsigned long)this_cpu_ptr(&kvm_host_data) -
-		     (unsigned long)kvm_ksym_ref(&kvm_host_data));
+	tpidr_el2 = ((unsigned long)this_cpu_ptr(&kvm_hyp_running_vcpu) -
+		     (unsigned long)kvm_ksym_ref(&kvm_hyp_running_vcpu));
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
@@ -1316,14 +1318,14 @@ static void cpu_hyp_reset(void)
 
 static void cpu_hyp_reinit(void)
 {
-	kvm_init_host_cpu_context(&this_cpu_ptr(&kvm_host_data)->host_ctxt);
-
 	cpu_hyp_reset();
 
-	if (is_kernel_in_hyp_mode())
+	if (is_kernel_in_hyp_mode()) {
+		kvm_init_host_cpu_context(this_cpu_ptr(&kvm_host_ctxt));
 		kvm_timer_init_vhe();
-	else
+	} else {
 		cpu_init_hyp_mode();
+	}
 
 	kvm_arm_init_debug();
 
@@ -1549,16 +1551,17 @@ static int init_hyp_mode(void)
 	}
 
 	for_each_possible_cpu(cpu) {
-		kvm_host_data_t *cpu_data;
+		struct kvm_cpu_context *hyp_ctxt;
 		struct kvm_vcpu *host_vcpu;
 		u64 *host_pmscr;
 		struct kvm_vcpu **running_vcpu;
+		struct kvm_pmu_events *pmu;
 
-		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
-		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
+		hyp_ctxt = per_cpu_ptr(&kvm_hyp_ctxt, cpu);
+		err = create_hyp_mappings(hyp_ctxt, hyp_ctxt + 1, PAGE_HYP);
 
 		if (err) {
-			kvm_err("Cannot map host CPU state: %d\n", err);
+			kvm_err("Cannot map hyp CPU context: %d\n", err);
 			goto out_err;
 		}
 
@@ -1585,6 +1588,14 @@ static int init_hyp_mode(void)
 			kvm_err("Cannot map running vCPU: %d\n", err);
 			goto out_err;
 		}
+
+		pmu = per_cpu_ptr(&kvm_pmu_events, cpu);
+		err = create_hyp_mappings(pmu, pmu + 1, PAGE_HYP);
+
+		if (err) {
+			kvm_err("Cannot map PMU events: %d\n", err);
+			goto out_err;
+		}
 	}
 
 	err = hyp_map_aux_data();
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 63d484059c01..6c3a6b27a96c 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -19,18 +19,18 @@
 
 /*
  * u64 __guest_enter(struct kvm_vcpu *vcpu,
- *		     struct kvm_cpu_context *host_ctxt);
+ *		     struct kvm_cpu_context *hyp_ctxt);
  */
 SYM_FUNC_START(__guest_enter)
 	// x0: vcpu
-	// x1: host context
+	// x1: hyp context
 	// x2-x17: clobbered by macros
 	// x29: guest context
 
-	// Store the host regs
+	// Store the hyp regs
 	save_callee_saved_regs x1
 
-	// Save the host's sp_el0
+	// Save the hyp's sp_el0
 	save_sp_el0	x1, x2
 
 	// Now the hyp state is stored if we have a pending RAS SError it must
@@ -113,7 +113,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// Store the guest's sp_el0
 	save_sp_el0	x1, x2
 
-	get_host_ctxt	x2, x3
+	get_hyp_ctxt	x2, x3
 
 	// Macro ptrauth_switch_to_guest format:
 	// 	ptrauth_switch_to_host(guest cxt, host cxt, tmp1, tmp2, tmp3)
@@ -122,10 +122,10 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// when this feature is enabled for kernel code.
 	ptrauth_switch_to_host x1, x2, x3, x4, x5
 
-	// Restore the hosts's sp_el0
+	// Restore the hyp's sp_el0
 	restore_sp_el0 x2, x3
 
-	// Now restore the host regs
+	// Now restore the hyp regs
 	restore_callee_saved_regs x2
 
 alternative_if ARM64_HAS_RAS_EXTN
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index fa62c2b21b4b..4b1e51b8bb82 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -27,6 +27,8 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
+DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
+
 extern const char __hyp_panic_string[];
 
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
@@ -382,7 +384,7 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	    !esr_is_ptrauth_trap(kvm_vcpu_get_esr(vcpu)))
 		return false;
 
-	ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	ctxt = get_hyp_ctxt();
 	__ptrauth_save_key(ctxt, APIA);
 	__ptrauth_save_key(ctxt, APIB);
 	__ptrauth_save_key(ctxt, APDA);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-start.S b/arch/arm64/kvm/hyp/nvhe/hyp-start.S
index d7744dcfd184..faec05ae3d3b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-start.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-start.S
@@ -29,7 +29,7 @@ alternative_else_nop_endif
 .endm
 
 SYM_CODE_START(__kvm_hyp_start)
-	get_host_ctxt	x0, x1
+	get_hyp_ctxt	x0, x1
 
 	ptrauth_hyp_ctxt_init x0, x1, x2, x3
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index e49967c915de..f9a35ca02ad1 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -114,7 +114,7 @@ static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
  */
 static void __pmu_switch_to_guest(void)
 {
-	struct kvm_pmu_events *pmu = &__hyp_this_cpu_ptr(kvm_host_data)->pmu_events;
+	struct kvm_pmu_events *pmu = __hyp_this_cpu_ptr(kvm_pmu_events);
 
 	if (pmu->events_host)
 		write_sysreg(pmu->events_host, pmcntenclr_el0);
@@ -128,7 +128,7 @@ static void __pmu_switch_to_guest(void)
  */
 static void __pmu_switch_to_host(void)
 {
-	struct kvm_pmu_events *pmu = &__hyp_this_cpu_ptr(kvm_host_data)->pmu_events;
+	struct kvm_pmu_events *pmu = __hyp_this_cpu_ptr(kvm_pmu_events);
 
 	if (pmu->events_guest)
 		write_sysreg(pmu->events_guest, pmcntenclr_el0);
@@ -229,11 +229,11 @@ static void __vcpu_switch_to(struct kvm_vcpu *vcpu)
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *hyp_ctxt;
 	struct kvm_vcpu *running_vcpu;
 	u64 exit_code;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	hyp_ctxt = __hyp_this_cpu_ptr(kvm_hyp_ctxt);
 	running_vcpu = __hyp_this_cpu_read(kvm_hyp_running_vcpu);
 
 	if (running_vcpu != vcpu) {
@@ -255,7 +255,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	do {
 		/* Jump in the fire! */
-		exit_code = __guest_enter(vcpu, host_ctxt);
+		exit_code = __guest_enter(vcpu, hyp_ctxt);
 
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
index a564831726e7..7a68e1215277 100644
--- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -15,7 +15,7 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = __hyp_this_cpu_ptr(kvm_host_ctxt);
 	host_dbg = __hyp_this_cpu_ptr(kvm_host_debug_state);
 
 	__debug_switch_to_guest_common(vcpu, host_dbg, host_ctxt);
@@ -26,7 +26,7 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = __hyp_this_cpu_ptr(kvm_host_ctxt);
 	host_dbg = __hyp_this_cpu_ptr(kvm_host_debug_state);
 
 	__debug_switch_to_host_common(vcpu, host_dbg, host_ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 5c2eaf889cf5..daf40004e93d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -108,7 +108,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = __hyp_this_cpu_ptr(kvm_host_ctxt);
 	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
@@ -209,7 +209,7 @@ NOKPROBE_SYMBOL(__hyp_call_panic);
 
 void __noreturn hyp_panic(void)
 {
-	struct kvm_cpu_context *host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	struct kvm_cpu_context *host_ctxt = __hyp_this_cpu_ptr(kvm_host_ctxt);
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 996471e4c138..923e10f25b5e 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -66,7 +66,7 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = __hyp_this_cpu_ptr(kvm_host_ctxt);
 	__sysreg_save_user_state(host_ctxt);
 
 	/*
@@ -100,7 +100,7 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = __hyp_this_cpu_ptr(kvm_host_ctxt);
 	deactivate_traps_vhe_put();
 
 	__sysreg_save_el1_state(guest_ctxt);
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index b5ae3a5d509e..f578192476db 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -31,15 +31,15 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
  */
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr(&kvm_host_data);
+	struct kvm_pmu_events *pmu = this_cpu_ptr(&kvm_pmu_events);
 
 	if (!kvm_pmu_switch_needed(attr))
 		return;
 
 	if (!attr->exclude_host)
-		ctx->pmu_events.events_host |= set;
+		pmu->events_host |= set;
 	if (!attr->exclude_guest)
-		ctx->pmu_events.events_guest |= set;
+		pmu->events_guest |= set;
 }
 
 /*
@@ -47,10 +47,10 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
  */
 void kvm_clr_pmu_events(u32 clr)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr(&kvm_host_data);
+	struct kvm_pmu_events *pmu = this_cpu_ptr(&kvm_pmu_events);
 
-	ctx->pmu_events.events_host &= ~clr;
-	ctx->pmu_events.events_guest &= ~clr;
+	pmu->events_host &= ~clr;
+	pmu->events_guest &= ~clr;
 }
 
 #define PMEVTYPER_READ_CASE(idx)				\
@@ -163,15 +163,15 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
  */
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_data *host;
+	struct kvm_pmu_events *pmu;
 	u32 events_guest, events_host;
 
 	if (!has_vhe())
 		return;
 
-	host = this_cpu_ptr(&kvm_host_data);
-	events_guest = host->pmu_events.events_guest;
-	events_host = host->pmu_events.events_host;
+	pmu = this_cpu_ptr(&kvm_pmu_events);
+	events_guest = pmu->events_guest;
+	events_host = pmu->events_host;
 
 	kvm_vcpu_pmu_enable_el0(events_guest);
 	kvm_vcpu_pmu_disable_el0(events_host);
@@ -182,15 +182,15 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_data *host;
+	struct kvm_pmu_events *pmu;
 	u32 events_guest, events_host;
 
 	if (!has_vhe())
 		return;
 
-	host = this_cpu_ptr(&kvm_host_data);
-	events_guest = host->pmu_events.events_guest;
-	events_host = host->pmu_events.events_host;
+	pmu = this_cpu_ptr(&kvm_pmu_events);
+	events_guest = pmu->events_guest;
+	events_host = pmu->events_host;
 
 	kvm_vcpu_pmu_enable_el0(events_host);
 	kvm_vcpu_pmu_disable_el0(events_guest);
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
