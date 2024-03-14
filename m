Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B5D74BFE
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 20:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447970; cv=none; b=K3UQpc9hFJIh2R2VE+V1Kpi1QBJxZC4U8RCc7N/2BafOCYpCoJpE6WB9OJUd6nluWajaxbglCB1m01ZZQQ5YaWrRG/mgJrzfwQKJ/PIFjoLBTrOaXYZ8Tmnm3hpu+rGnqZ+IKd366/GHa9yFtXmdHhFqh3fiHyz4OpPxCTLIRhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447970; c=relaxed/simple;
	bh=lVUq8Tjf9oK6tIzQo5+3/KLAKzgTNPmjYvQfI7c4rMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSPTPY3zMq/dtZqOIuGw9DYaEpDSW0FyNSY2fimoa/FVLFrAJ9OPSE86nlEbZsxxyc3rzzCezKMN/SPFdIvfODA7vnEFequsJOyEpGtRUgoDkXJya2ExZpTDoi3IwNvB4qcwVkhUNOleOdFlhRbtyM/wdpkxtM4vbSL/leRrd3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WCl+XuJH; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WCl+XuJH"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-513cf9bacf1so1754176e87.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 13:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447966; x=1711052766; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1X42YuqTctT4vzgW20/hDSVUJpY4koOC9rkGtJkqjtA=;
        b=WCl+XuJHuBoVxV2GuyPUnGOqxD+NfoUQEr2MF08WLJZHAA5qocEBamMiTiAEz52eA9
         G8cOWMLIRZ99RgxTFUZPvJ4g8PoWV57gYik5aZxZYe4V8V/IGqJ3yHMooDx8GTnp9Z81
         MlPWUWeoy4TjJZ8bwuWiQDgE+L3GkEzLGUf431Nj2GLH2KUT6AhyrtOUKkPernXT78ET
         kS17ImE945ylco1IcGC9m2yS94pI9jlI21cfBPsvUC8Xj2CGkfLAOFceipHDQNRPMqbv
         TPVC2cd+FP78psRevoe0J0yYtr8CXdLzwjzsIvPLtBxV4RJEAnZOSB9sl7fTWCUCaeO7
         Nf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447966; x=1711052766;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1X42YuqTctT4vzgW20/hDSVUJpY4koOC9rkGtJkqjtA=;
        b=K2kNxfauWRdYonIwB0O3Fo5DL5Q8nDOZR+BmkVwiR+ihfOh3XIDGwz7lk2Nyxlw1ZF
         9/uvcj2WYWH5i8UzKEljSxS8RimOxDsP6mVqnHddmbZ8baPZ/eSm7ouhu3WHIB5d0IEt
         IHlxwsmMWqN/tAprJk+HwWuh4gB4V6jPuNxKehhMHWfukr50RI/R00qeTqKFdhfrRVYx
         ydMiG8ix+M9Q8HBdqLFj0QUXPH52X6wBk1ERJG8zvGrfSIPFEmNV3fgiMlHXAqS+oTjF
         7ruyLa1oKD3n678nA+/b4mZ+W8e/T0Ly7BYqnyRFTNoHn6yl+UXDW+fuZCxhkbyC3Szu
         i/LQ==
X-Gm-Message-State: AOJu0YyOXZ6+g19lBy9nBv9a6ao4b2i9Tvr77nIhUbtm1i9K6cAKR/tk
	Chh++8HEBvhr6Y9YDemZRPGwsiS4MZnxhwcJg5mzjEnbj8pKfaG+GdinBDmaofLwRDZ/BwoPRX/
	zjQj7
X-Google-Smtp-Source: AGHT+IHkzNmsE0KL1mSwwtaDDxJ2Z0EOfjOFXiDM9tdY0BYN+4IxOoQ2ahyHAy73nBFdMUHgJ8ASJQ==
X-Received: by 2002:a19:e054:0:b0:512:a4ce:abaa with SMTP id g20-20020a19e054000000b00512a4ceabaamr900363lfj.48.1710447965560;
        Thu, 14 Mar 2024 13:26:05 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id s11-20020a170906454b00b00a44f07e55d2sm1005673ejq.41.2024.03.14.13.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:26:05 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:26:01 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH 10/10] KVM: arm64: Improve CONFIG_CFI_CLANG error message
Message-ID: <6efd86cefda82a35b1e002a2fb48811e3b1960db.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

For KCFI, the compiler encodes in the immediate of the BRK (which the
CPU places in ESR_ELx) the indices of the two registers it used to hold
(resp.) the function pointer and expected type. Therefore, the CFI
handler must be able to parse the contents of the register file at the
point where the exception was triggered.

To achieve this, introduce a new hypervisor panic path that first stores
the CPU context in the per-CPU kvm_hyp_ctxt before calling (directly or
indirectly) hyp_panic() and execute it from all EL2 synchronous
exception handlers i.e.

- call it directly in host_el2_sync_vect (__kvm_hyp_host_vector, EL2t&h)
- call it directly in el2t_sync_invalid (__kvm_hyp_vector, EL2t)
- set ELR_EL2 to it in el2_sync (__kvm_hyp_vector, EL2h), which ERETs

Teach hyp_panic() to decode the KCFI ESR and extract the target and type
from the saved CPU context. In VHE, use that information to panic() with
a specialized error message. In nVHE, only report it if the host (EL1)
has access to the saved CPU context i.e. iff CONFIG_NVHE_EL2_DEBUG=y,
which aligns with the behavior of CONFIG_PROTECTED_NVHE_STACKTRACE.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/handle_exit.c            | 30 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/entry.S              | 24 +++++++++++++++++++-
 arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/host.S          |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 26 +++++++++++++++++++--
 6 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 9b6574e50b13..d343a5130943 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -26,6 +26,8 @@
 #define CREATE_TRACE_POINTS
 #include "trace_handle_exit.h"
 
+DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
+
 typedef int (*exit_handle_fn)(struct kvm_vcpu *);
 
 static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
@@ -383,11 +385,35 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
 
-static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
+static void kvm_nvhe_report_cfi_target(struct user_pt_regs *regs, u64 esr,
+				       u64 hyp_offset)
+{
+	u64 va_mask = GENMASK_ULL(vabits_actual - 1, 0);
+	u8 type_idx = FIELD_GET(CFI_BRK_IMM_TYPE, esr);
+	u8 target_idx = FIELD_GET(CFI_BRK_IMM_TARGET, esr);
+	u32 expected_type = (u32)regs->regs[type_idx];
+	u64 target_addr = (regs->regs[target_idx] & va_mask) + hyp_offset;
+
+	kvm_err(" (target: [<%016llx>] %ps, expected type: 0x%08x)\n",
+		target_addr, (void *)(target_addr + kaslr_offset()),
+		expected_type);
+}
+
+static void kvm_nvhe_report_cfi_failure(u64 panic_addr, u64 esr, u64 hyp_offset)
 {
+	struct user_pt_regs *regs = NULL;
+
 	kvm_err("nVHE hyp CFI failure at: [<%016llx>] %pB!\n", panic_addr,
 		(void *)(panic_addr + kaslr_offset()));
 
+	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) || !is_protected_kvm_enabled())
+		regs = &this_cpu_ptr_nvhe_sym(kvm_hyp_ctxt)->regs;
+
+	if (regs)
+		kvm_nvhe_report_cfi_target(regs, esr, hyp_offset);
+	else
+		kvm_err(" (no target information: !CONFIG_NVHE_EL2_DEBUG)\n");
+
 	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
 		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
 }
@@ -423,7 +449,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
 					(void *)(panic_addr + kaslr_offset()));
 	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
-		kvm_nvhe_report_cfi_failure(panic_addr);
+		kvm_nvhe_report_cfi_failure(panic_addr, esr, hyp_offset);
 	} else {
 		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
 				(void *)(panic_addr + kaslr_offset()));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index ac8aa8571b2f..eb6699d2bb7a 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,7 +83,7 @@ alternative_else_nop_endif
 	eret
 	sb
 
-SYM_INNER_LABEL(__hyp_panic_with_restored_elr, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_panic_with_context_and_restored_elr, SYM_L_GLOBAL)
 	// x0-x29,lr: hyp regs
 
 	stp	x0, x1, [sp, #-16]!
@@ -92,6 +92,28 @@ SYM_INNER_LABEL(__hyp_panic_with_restored_elr, SYM_L_GLOBAL)
 	msr	elr_el2, x0
 	ldp	x0, x1, [sp], #16
 
+SYM_INNER_LABEL(__hyp_panic_with_context, SYM_L_GLOBAL)
+	// x0-x29,lr: hyp regs
+
+	stp	x0, x1, [sp, #-16]!
+
+	adr_this_cpu x0, kvm_hyp_ctxt, x1
+
+	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(2)]
+
+	ldp	x2, x3, [sp], #16
+
+	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(0)]
+	stp	x4, x5,   [x0, #CPU_XREG_OFFSET(4)]
+	stp	x6, x7,   [x0, #CPU_XREG_OFFSET(6)]
+	stp	x8, x9,   [x0, #CPU_XREG_OFFSET(8)]
+	stp	x10, x11, [x0, #CPU_XREG_OFFSET(10)]
+	stp	x12, x13, [x0, #CPU_XREG_OFFSET(12)]
+	stp	x14, x15, [x0, #CPU_XREG_OFFSET(14)]
+	stp	x16, x17, [x0, #CPU_XREG_OFFSET(16)]
+
+	save_callee_saved_regs x0
+
 SYM_INNER_LABEL(__hyp_panic, SYM_L_GLOBAL)
 	// x0-x29,lr: vcpu regs
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 7e65ef738ec9..6eedab7f9767 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -130,7 +130,7 @@ SYM_CODE_END(\label)
 .endm
 
 	/* None of these should ever happen */
-	invalid_vector	el2t_sync_invalid
+	invalid_vector	el2t_sync_invalid, __hyp_panic_with_context
 	invalid_vector	el2t_irq_invalid
 	invalid_vector	el2t_fiq_invalid
 	invalid_vector	el2t_error_invalid
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0dc721ced358..6c4b3f9d538f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -747,7 +747,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __hyp_panic_with_restored_elr[];
+	extern char __hyp_panic_with_context_and_restored_elr[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
@@ -769,7 +769,7 @@ static inline void __kvm_unexpected_el2_exception(void)
 	}
 
 	/* Trigger a panic after restoring the hyp context. */
-	write_sysreg(__hyp_panic_with_restored_elr, elr_el2);
+	write_sysreg(__hyp_panic_with_context_and_restored_elr, elr_el2);
 
 	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] = elr_el2;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 1b9111c2b480..8bb6fed5ba4e 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -202,7 +202,7 @@ SYM_FUNC_END(__host_hvc)
 	 * context has been saved by __host_exit or after the hyp context has
 	 * been partially clobbered by __host_enter.
 	 */
-	b	__hyp_panic
+	b	__hyp_panic_with_context
 
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9db04a286398..c733f5bdab59 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -17,6 +17,7 @@
 
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
+#include <asm/esr.h>
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -301,7 +302,24 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic_for_cfi(u64 elr, u64 esr)
+{
+	struct user_pt_regs *regs = &this_cpu_ptr(&kvm_hyp_ctxt)->regs;
+	u8 type_idx = FIELD_GET(CFI_BRK_IMM_TYPE, esr);
+	u8 target_idx = FIELD_GET(CFI_BRK_IMM_TARGET, esr);
+	u32 expected_type = (u32)regs->regs[type_idx];
+	u64 target = regs->regs[target_idx];
+
+	panic("VHE hyp CFI failure at: [<%016llx>] %pB (target: [<%016llx>] %ps, expected type: 0x%08x)\n"
+#ifdef CONFIG_CFI_PERMISSIVE
+	      " (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n"
+#endif
+	      ,
+	      elr, (void *)elr, target, (void *)target, expected_type);
+}
+NOKPROBE_SYMBOL(__hyp_call_panic_for_cfi);
+
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par, u64 esr)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -312,6 +330,9 @@ static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 	__deactivate_traps(vcpu);
 	sysreg_restore_host_state_vhe(host_ctxt);
 
+	if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr))
+		__hyp_call_panic_for_cfi(elr, esr);
+
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n",
 	      spsr, elr,
 	      read_sysreg_el2(SYS_ESR), read_sysreg_el2(SYS_FAR),
@@ -324,8 +345,9 @@ void __noreturn hyp_panic(void)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
+	u64 esr = read_sysreg_el2(SYS_ESR);
 
-	__hyp_call_panic(spsr, elr, par);
+	__hyp_call_panic(spsr, elr, par, esr);
 }
 
 asmlinkage void kvm_unexpected_el2_exception(void)

-- 
Pierre
