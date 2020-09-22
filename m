Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6B0C4727E
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93775238D7
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Gfzg4P+M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93775238D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 221F24B32C;
	Tue, 22 Sep 2020 16:49:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XoHN8xAA+8q1; Tue, 22 Sep 2020 16:49:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B014B313;
	Tue, 22 Sep 2020 16:49:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6616E4B226
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ffwZwur1EL2e for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 16:49:21 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 129C14B2F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:21 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id s13so4752704wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=G5BfnFkypsuHsKqXP8ErB3dblSM7o7zNnaIIUEU0OA0=;
 b=Gfzg4P+M99Bj/VtLtlR9Zz8hjgewl+m03sGyf+iYOQSkZuuD1eRIT8lKkTXEUOlNfF
 3sRjsiA6PBiXhZhH4K7Bcw+c4CEnvgm3qVXwpEc0zd0q04ClqeTTRZctkjh01CJqdAZF
 6GD8VZbLGdPfk5oba/NYPG61bDYC0Nspajts+8YrqL928+k2k6LBKN+/AdzMfGExl82Q
 DdZ6qSVClY53bOt0vGXyERkMAcgy2o4ekChXFhBjMGckD/39T/kxgaEpCupOkK3p2rqQ
 KTLKSbQN9WgIFPJA4/wrinBvgCrCp1pvhhQM0AensXRhLOqFc+6tnUnri0rV6WYjK544
 T0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=G5BfnFkypsuHsKqXP8ErB3dblSM7o7zNnaIIUEU0OA0=;
 b=IrzhF+s1r1iquFsztGedVSzVKWft98WqY/JYLfTbd67vS4gpQbldY7811699dtXuj9
 CuSYFEuuj8eZs7pWQlkGr6q0+5wolNenrXt+HNXoM10YcChFvEBgW/6aS6JUuSBVmcz8
 vZtoSJvrJp7kuDEVfb1dAE1P/WgJr+FVY023ImqfOg/WjaKZgGwAlzuJnRE7WPgPaYeg
 y7NAltNtaCqT3gIVx6k21uSB1HUkq1NR3sRfWiuTvegxscYV/22uhEy0ksLqMi0Hq443
 cGG+GI/AhMu9W60XxRrldjmrS09R0zZACig4NnvuDM43KZZoZjSjxHErYNSNGO0G3bib
 Z8ew==
X-Gm-Message-State: AOAM532BfBVpB1EWQRZkQm3lXtrfM4Qe+F4GdTQjKynnIsF0wgfczIOk
 /fBImqBY2Nhpu7VNurv+YCA8qlaufJFsulxz
X-Google-Smtp-Source: ABdhPJx96GCqe8z3nLYveSuFwaQckNQT2LOdtuxNKpBFNIwBcIpsN1AbPYzRuZczVtssKfExWT1+Kg==
X-Received: by 2002:a1c:6187:: with SMTP id v129mr2840724wmb.35.1600807759424; 
 Tue, 22 Sep 2020 13:49:19 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:1105:630f:e990:272f])
 by smtp.gmail.com with ESMTPSA id l17sm5799200wme.11.2020.09.22.13.49.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Sep 2020 13:49:18 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 04/10] kvm: arm64: Remove __hyp_this_cpu_read
Date: Tue, 22 Sep 2020 21:49:04 +0100
Message-Id: <20200922204910.7265-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922204910.7265-1-dbrazdil@google.com>
References: <20200922204910.7265-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

this_cpu_ptr is meant for use in kernel proper because it selects between
TPIDR_EL1/2 based on nVHE/VHE. __hyp_this_cpu_ptr was used in hyp to always
select TPIDR_EL2. Unify all users behind this_cpu_ptr and friends by
selecting _EL2 register under __KVM_NVHE_HYPERVISOR__. VHE continues
selecting the register using alternatives.

Under CONFIG_DEBUG_PREEMPT, the kernel helpers perform a preemption check
which is omitted by the hyp helpers. Preserve the behavior for nVHE by
overriding the corresponding macros under __KVM_NVHE_HYPERVISOR__. Extend
the checks into VHE hyp code.

Acked-by: Andrew Scull <ascull@google.com>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h          | 20 ----------------
 arch/arm64/include/asm/percpu.h           | 28 +++++++++++++++++++++--
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  4 ++--
 arch/arm64/kvm/hyp/include/hyp/switch.h   |  8 +++----
 arch/arm64/kvm/hyp/nvhe/switch.c          |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c           |  2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |  4 ++--
 7 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index c085032e2e3e..c196eec25498 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -143,26 +143,6 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 		addr;							\
 	})
 
-/*
- * Home-grown __this_cpu_{ptr,read} variants that always work at HYP,
- * provided that sym is really a *symbol* and not a pointer obtained from
- * a data structure. As for SHIFT_PERCPU_PTR(), the creative casting keeps
- * sparse quiet.
- */
-#define __hyp_this_cpu_ptr(sym)						\
-	({								\
-		void *__ptr;						\
-		__verify_pcpu_ptr(&sym);				\
-		__ptr = hyp_symbol_addr(sym);				\
-		__ptr += read_sysreg(tpidr_el2);			\
-		(typeof(sym) __kernel __force *)__ptr;			\
-	 })
-
-#define __hyp_this_cpu_read(sym)					\
-	({								\
-		*__hyp_this_cpu_ptr(sym);				\
-	 })
-
 #define __KVM_EXTABLE(from, to)						\
 	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
 	"	.align		3\n"					\
diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index 0b6409b89e5e..1599e17379d8 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -19,7 +19,16 @@ static inline void set_my_cpu_offset(unsigned long off)
 			:: "r" (off) : "memory");
 }
 
-static inline unsigned long __my_cpu_offset(void)
+static inline unsigned long __hyp_my_cpu_offset(void)
+{
+	/*
+	 * Non-VHE hyp code runs with preemption disabled. No need to hazard
+	 * the register access against barrier() as in __kern_my_cpu_offset.
+	 */
+	return read_sysreg(tpidr_el2);
+}
+
+static inline unsigned long __kern_my_cpu_offset(void)
 {
 	unsigned long off;
 
@@ -35,7 +44,12 @@ static inline unsigned long __my_cpu_offset(void)
 
 	return off;
 }
-#define __my_cpu_offset __my_cpu_offset()
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#define __my_cpu_offset __hyp_my_cpu_offset()
+#else
+#define __my_cpu_offset __kern_my_cpu_offset()
+#endif
 
 #define PERCPU_RW_OPS(sz)						\
 static inline unsigned long __percpu_read_##sz(void *ptr)		\
@@ -227,4 +241,14 @@ PERCPU_RET_OP(add, add, ldadd)
 
 #include <asm-generic/percpu.h>
 
+/* Redefine macros for nVHE hyp under DEBUG_PREEMPT to avoid its dependencies. */
+#if defined(__KVM_NVHE_HYPERVISOR__) && defined(CONFIG_DEBUG_PREEMPT)
+#undef	this_cpu_ptr
+#define	this_cpu_ptr		raw_cpu_ptr
+#undef	__this_cpu_read
+#define	__this_cpu_read		raw_cpu_read
+#undef	__this_cpu_write
+#define	__this_cpu_write	raw_cpu_write
+#endif
+
 #endif /* __ASM_PERCPU_H */
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 5e28ea6aa097..4ebe9f558f3a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -135,7 +135,7 @@ static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
@@ -154,7 +154,7 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5b6b8fa00f0a..f150407fa798 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -386,7 +386,7 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	    !esr_is_ptrauth_trap(kvm_vcpu_get_esr(vcpu)))
 		return false;
 
-	ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	__ptrauth_save_key(ctxt, APIA);
 	__ptrauth_save_key(ctxt, APIB);
 	__ptrauth_save_key(ctxt, APDA);
@@ -495,7 +495,7 @@ static inline void __set_guest_arch_workaround_state(struct kvm_vcpu *vcpu)
 	 * guest wants it disabled, so be it...
 	 */
 	if (__needs_ssbd_off(vcpu) &&
-	    __hyp_this_cpu_read(arm64_ssbd_callback_required))
+	    __this_cpu_read(arm64_ssbd_callback_required))
 		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_2, 0, NULL);
 #endif
 }
@@ -507,7 +507,7 @@ static inline void __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
 	 * If the guest has disabled the workaround, bring it back on.
 	 */
 	if (__needs_ssbd_off(vcpu) &&
-	    __hyp_this_cpu_read(arm64_ssbd_callback_required))
+	    __this_cpu_read(arm64_ssbd_callback_required))
 		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_2, 1, NULL);
 #endif
 }
@@ -521,7 +521,7 @@ static inline void __kvm_unexpected_el2_exception(void)
 
 	entry = hyp_symbol_addr(__start___kvm_ex_table);
 	end = hyp_symbol_addr(__stop___kvm_ex_table);
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 
 	while (entry < end) {
 		addr = (unsigned long)&entry->insn + entry->insn;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0970442d2dbc..cc4f8e790fb3 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -175,7 +175,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	vcpu = kern_hyp_va(vcpu);
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c1da4f86ccac..575e8054f116 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -108,7 +108,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 996471e4c138..2a0b8c88d74f 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -66,7 +66,7 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	__sysreg_save_user_state(host_ctxt);
 
 	/*
@@ -100,7 +100,7 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	deactivate_traps_vhe_put();
 
 	__sysreg_save_el1_state(guest_ctxt);
-- 
2.28.0.681.g6f77f65b4e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
