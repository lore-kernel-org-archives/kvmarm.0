Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C6918131C
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984898; cv=none; b=S4fmW4LRbYSaw63vfBXCy0/HcPN18+0PcnBn3619EEmS7bg9ahoPpZQtRWuPjfowruPrqz+FfF9g+U3pnwE5/5cu1d6/nS62nIGksY7t6ZQASzhSdBY0xnMeXKTRyqx7O37jLFAywvPmG06Pkt+09EyGpa8JEBAkkHowjAomoR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984898; c=relaxed/simple;
	bh=d7ll60CcSbiQvQOKCWGY1hz1EabEJsXYqy8qzz9ADYs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rl4YPsRtBxR5oH7UHl8auffDS6UtdlVLg0Ajv09DmFzLxzDRjiY6PEJWieTA9DXvzlvqHqHqOdjgWJnOn0130bZ+baLPvl93wIZW1HNfy4mXNTIp7jJm58Fo1CFpMUEMB0T+DLeJOTFmj3WaTJ5tV59c8V8xKgcCbi7hm+Eh+dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=coopgPQq; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="coopgPQq"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a635b551919so57827066b.2
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984895; x=1717589695; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=20VEPEn3Gb7BPD8Z30RwNAM2J68OYkR1rMftiYbdXdo=;
        b=coopgPQqmBcAd9WTgaJF6XySB4PGpPONZQjxgqJcdObvrfUGfpBE1pKeCQb5QoJpZD
         HVx2abUL6tc4lSodc+qLPBnUmROcW04KPvl+SvEvvvXPHB3FQrCeUBBfrWVYR3/M20Wf
         qb8r8R/7tDaRLe5iyXd85B8AhE1xxzQ55mYksVTcF+iwtuTT85TjPjQFnhFpP9Okxw78
         q2F8i6LUwcQFT/2fl9gPM4DhlWoSGA6uvQMwsfNc0zg9K4z0N1lnKi2bJ96Ju7fC1z3p
         87vYjNbWE7EoOYPKUj3SSbBTXF8H5unydaLqRKMIp9rRbQhUG1NS95cZFSlbLZ8Hluqi
         8TGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984895; x=1717589695;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=20VEPEn3Gb7BPD8Z30RwNAM2J68OYkR1rMftiYbdXdo=;
        b=IC7f22goehu0oG7dU65sv7M5FPl+e57JKP4w1wt/2OGfsHe1GMyUAKI2TBl9tf1W8f
         16geoKec1ze2CeI1p+yQGRBve5fGgGDIa3X+oWPV/W/2UanlU5nFksxGWXL/TQknECDM
         imH1zpHY5bRxLnduR8P/Kq5QZo+PyB4onqp7HfuC4qy76pnCPKrO9n6gMITZuIqh8XSD
         nshUbHaJpeP/2v0x1Uwre3s19vuR7I9stjJK47krwIOhQy760c2r6rf8eZyyT2ZHfMJA
         EqKGVUv0F3PcDgQLyf0CNZkBeCbv875XYPb17AtW0t6iGGoREwjbP5qweRJsoI/Mzbkr
         zTnQ==
X-Gm-Message-State: AOJu0YziHWZu7jBNDyWEkhE9ReN8to12uw3yhZg+BBS/moIekgiLyDud
	tJh7as0e6Af2Rx2jd/P5C2TDY9MVnndBBdAosBD52Y709fy2zkhvONsyMoolmXbMTJxM7p/4tqd
	FBI1ub7ZdbAvIcpv8EX6wPyq1FaZSGh7M5bbrHPhfrDP2Q/XhihT5FwY8CIJ72kmrHUaED4j1NE
	Jn1bi1QAALTxJLEn563ezw094/8cA=
X-Google-Smtp-Source: AGHT+IHG1MR1oKr0DJdz40/0WuzMnmz17jEaYp2Xsp5D6m+QC6YtrLkmBnRMnvH0qBf1kHCVYvlptcFOhA==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:5842:b0:a59:aa99:694c with SMTP id
 a640c23a62f3a-a62649db3c6mr1603366b.8.1716984895098; Wed, 29 May 2024
 05:14:55 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:17 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-12-ptosi@google.com>
Subject: [PATCH v4 11/13] KVM: arm64: Improve CONFIG_CFI_CLANG error message
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

For kCFI, the compiler encodes in the immediate of the BRK (which the
CPU places in ESR_ELx) the indices of the two registers it used to hold
(resp.) the function pointer and expected type. Therefore, the kCFI
handler must be able to parse the contents of the register file at the
point where the exception was triggered.

To achieve this, introduce a new hypervisor panic path that first stores
the CPU context in the per-CPU kvm_hyp_ctxt before calling (directly or
indirectly) hyp_panic() and execute it from all EL2 synchronous
exception handlers i.e.

- call it directly in host_el2_sync_vect (__kvm_hyp_host_vector, EL2t&h)
- call it directly in el2t_sync_invalid (__kvm_hyp_vector, EL2t)
- set ELR_EL2 to it in el2_sync (__kvm_hyp_vector, EL2h), which ERETs

Teach hyp_panic() to decode the kCFI ESR and extract the target and type
from the saved CPU context. In VHE, use that information to panic() with
a specialized error message. In nVHE, only report it if the host (EL1)
has access to the saved CPU context i.e. iff CONFIG_NVHE_EL2_DEBUG=3Dy,
which aligns with the behavior of CONFIG_PROTECTED_NVHE_STACKTRACE.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/handle_exit.c            | 30 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/entry.S              | 24 +++++++++++++++++++-
 arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/host.S          |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 26 +++++++++++++++++++--
 6 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 69b08ac7322d..2fac3be3db00 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -26,6 +26,8 @@
 #define CREATE_TRACE_POINTS
 #include "trace_handle_exit.h"
=20
+DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
+
 typedef int (*exit_handle_fn)(struct kvm_vcpu *);
=20
 static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
@@ -417,10 +419,34 @@ static void print_nvhe_hyp_panic(const char *name, u6=
4 panic_addr)
 		(void *)(panic_addr + kaslr_offset()));
 }
=20
-static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
+static void kvm_nvhe_report_cfi_target(struct user_pt_regs *regs, u64 esr,
+				       u64 hyp_offset)
+{
+	u64 va_mask =3D GENMASK_ULL(vabits_actual - 1, 0);
+	u8 type_idx =3D FIELD_GET(CFI_BRK_IMM_TYPE, esr);
+	u8 target_idx =3D FIELD_GET(CFI_BRK_IMM_TARGET, esr);
+	u32 expected_type =3D (u32)regs->regs[type_idx];
+	u64 target_addr =3D (regs->regs[target_idx] & va_mask) + hyp_offset;
+
+	kvm_err(" (target: [<%016llx>] %ps, expected type: 0x%08x)\n",
+		target_addr, (void *)(target_addr + kaslr_offset()),
+		expected_type);
+}
+
+static void kvm_nvhe_report_cfi_failure(u64 panic_addr, u64 esr, u64 hyp_o=
ffset)
 {
+	struct user_pt_regs *regs =3D NULL;
+
 	print_nvhe_hyp_panic("CFI failure", panic_addr);
=20
+	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) || !is_protected_kvm_enabled())
+		regs =3D &this_cpu_ptr_nvhe_sym(kvm_hyp_ctxt)->regs;
+
+	if (regs)
+		kvm_nvhe_report_cfi_target(regs, esr, hyp_offset);
+	else
+		kvm_err(" (no target information: !CONFIG_NVHE_EL2_DEBUG)\n");
+
 	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
 		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
 }
@@ -455,7 +481,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
u64 spsr,
 		else
 			print_nvhe_hyp_panic("BUG", panic_addr);
 	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
-		kvm_nvhe_report_cfi_failure(panic_addr);
+		kvm_nvhe_report_cfi_failure(panic_addr, esr, hyp_offset);
 	} else {
 		print_nvhe_hyp_panic("panic", panic_addr);
 	}
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 343851c17373..8965dbc75972 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,7 +83,7 @@ alternative_else_nop_endif
 	eret
 	sb
=20
-SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_restore_elr_save_context_and_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
=20
@@ -91,6 +91,28 @@ SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBA=
L)
 	ldr	x0, [x0, #CPU_ELR_EL2]
 	msr	elr_el2, x0
=20
+SYM_INNER_LABEL(__hyp_save_context_and_panic, SYM_L_GLOBAL)
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
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.=
S
index 7e65ef738ec9..d0d90d598338 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -130,7 +130,7 @@ SYM_CODE_END(\label)
 .endm
=20
 	/* None of these should ever happen */
-	invalid_vector	el2t_sync_invalid
+	invalid_vector	el2t_sync_invalid, __hyp_save_context_and_panic
 	invalid_vector	el2t_irq_invalid
 	invalid_vector	el2t_fiq_invalid
 	invalid_vector	el2t_error_invalid
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index d9931abf14c2..77783dbc1833 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -689,7 +689,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vc=
pu, u64 *exit_code)
=20
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __hyp_restore_elr_and_panic[];
+	extern char __hyp_restore_elr_save_context_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 =3D read_sysreg(elr_el2);
@@ -712,7 +712,7 @@ static inline void __kvm_unexpected_el2_exception(void)
=20
 	/* Trigger a panic after restoring the hyp context. */
 	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] =3D elr_el2;
-	write_sysreg(__hyp_restore_elr_and_panic, elr_el2);
+	write_sysreg(__hyp_restore_elr_save_context_and_panic, elr_el2);
 }
=20
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.=
S
index a7db40a51e4a..9343160f5357 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -214,7 +214,7 @@ SYM_FUNC_END(__host_hvc)
 .endm
=20
 .macro host_el2_sync_vect
-	__host_el2_vect __hyp_panic
+	__host_el2_vect __hyp_save_context_and_panic
 .endm
=20
 .macro invalid_host_el1_vect
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switc=
h.c
index 0550b9f6317f..6c64783c3e00 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -17,6 +17,7 @@
=20
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
+#include <asm/esr.h>
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -384,7 +385,24 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
=20
-static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic_for_cfi(u64 elr, u64 esr)
+{
+	struct user_pt_regs *regs =3D &this_cpu_ptr(&kvm_hyp_ctxt)->regs;
+	u8 type_idx =3D FIELD_GET(CFI_BRK_IMM_TYPE, esr);
+	u8 target_idx =3D FIELD_GET(CFI_BRK_IMM_TARGET, esr);
+	u32 expected_type =3D (u32)regs->regs[type_idx];
+	u64 target =3D regs->regs[target_idx];
+
+	panic("VHE hyp CFI failure at: [<%016llx>] %pB (target: [<%016llx>] %ps, =
expected type: 0x%08x)\n"
+#ifdef CONFIG_CFI_PERMISSIVE
+	      " (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n"
+#endif
+	      ,
+	      elr, (void *)elr, target, (void *)target, expected_type);
+}
+NOKPROBE_SYMBOL(__hyp_call_panic_for_cfi);
+
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par, u64 es=
r)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -395,6 +413,9 @@ static void __noreturn __hyp_call_panic(u64 spsr, u64 e=
lr, u64 par)
 	__deactivate_traps(vcpu);
 	sysreg_restore_host_state_vhe(host_ctxt);
=20
+	if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr))
+		__hyp_call_panic_for_cfi(elr, esr);
+
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%01=
6llx PAR:%016llx\nVCPU:%p\n",
 	      spsr, elr,
 	      read_sysreg_el2(SYS_ESR), read_sysreg_el2(SYS_FAR),
@@ -407,8 +428,9 @@ void __noreturn hyp_panic(void)
 	u64 spsr =3D read_sysreg_el2(SYS_SPSR);
 	u64 elr =3D read_sysreg_el2(SYS_ELR);
 	u64 par =3D read_sysreg_par();
+	u64 esr =3D read_sysreg_el2(SYS_ESR);
=20
-	__hyp_call_panic(spsr, elr, par);
+	__hyp_call_panic(spsr, elr, par, esr);
 }
=20
 asmlinkage void kvm_unexpected_el2_exception(void)
--=20
2.45.1.288.g0e0cd299f1-goog

