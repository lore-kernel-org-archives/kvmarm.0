Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C3F50128E
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024454; cv=none; b=eSC+h3yBIgHwmSmX5tAxoz5i4ROO5kDZV/l4fnbfImIpRpqUGgshDScbHrczzPn8K8a15w0KkUHg8wh7S0nXjZPQ9J9Cv4WzvcAIf6/VZOZo5NYoQ0riSMEpoRj0xVQzskZByGD5DbdQXrWrZie0nCql+6ou1bNFxYYxkkAiBi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024454; c=relaxed/simple;
	bh=ulOvPn6D9XPpcXaxHjr/meflqahNBKxZ6eL2m5ABUhg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muRiPwbHez56GIBFWZ6t3fjGXNcCASRLWM2d4a02TtHImiMJiiRW1CSY4aMQ59NsBcTFDlHJ2mcRtwH17KmGx3kPLTR+oeyyA4NOnh+GK+wYjP1QyAnXWwMa45czXjSQI1FcNwGzwgbZG3JKcQthPYmY746OL/CcuB34oPiRPFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=H+bcULun; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="H+bcULun"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43f9b11bso26939207b3.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790024449; x=1790629249; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4dqs3u8rw3iSD+q7sDNmdGaZSDb+sElYZHHxIFq5uRQ=;
        b=H+bcULunSuFm4JnFLnWJ+Qx7lukMjKbRcnLHaAgzx2e4ri6T0AZvraAWAfFe7yMbbA
         byvw07B47Oz5rr2MLmzeCSgeHztgBvPjoqeIeB0Ldk1dw8opkTpXx+h4S7dXIGVmG+Nd
         MzBa6RvAIesgak1/vqTnIBPZQA7NOSuzzAYDuDpc19efEMo/JTy45NlU7Mg75AIPiIq/
         Ogf6OsKwmuzJH+BSHVB4DiWIE/I371OO7Y9IssEqfAbmjE4OQgigKEC05Sbvs0OdfB5S
         nQ1Az/5JKFw6QEFVwgz9ulDTVy56243FnLyfCUreGUpb7dnUAGbbwNqAFKAhrulfH8CY
         TFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024449; x=1790629249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4dqs3u8rw3iSD+q7sDNmdGaZSDb+sElYZHHxIFq5uRQ=;
        b=BCw20FnUkKJ/wqBLCTUzXFK3NPGrJ9Aoamd1WVOQWloM/mUwXjNYXFz1tET32bo0sD
         2aqrRfaZ5ysRJMwQEEG6icsFGxnIlakleb61fQ33ZL+03oVb2x+tcXc8XrbhPPpMzcix
         P+PJM7AIUpnLw1CmWC2647MBS3LCsGsfzridaJhY3q4uF8dVAHMg+OQ+Rnkq477ocVbO
         r21gTf5/K8VworqxH7RTzZbutxswKRbslxBNND0nsCdV54yztGIVdNa5C39BckZKCqcT
         B0Qz8WCz8E9BVU3QENShuxwPmBVH+qXgcTtH4PeTj03PtrVQSiBDtDoLr1W3rJz2SzoA
         30AA==
X-Forwarded-Encrypted: i=1; AKwUvBzfVIbJZji86u5pwOr74AcgBEBv/ue5gBI5s1abQvF6Y76gHb7LS7xlulEwLzvqjzPn099YMGk=@lists.linux.dev
X-Gm-Message-State: AFuF++n5yfUwiNrxo6XdJLFY/d0Czm2ckZGpxQ1P1ic3U8QisbVATaVM
	71caZE6Lk15RamB///gRsl0ageoDpXZ5jO6gdzvFI+u9CImjnhWEnlcJoPZbLSo/328=
X-Gm-Gg: AYBFou1N0URQKkjEV5Gqshm5IM+GXP8w3ogRSB0bUoyOsGNdPkRHTLRD8aUAI0KwLmB
	BLQoUhP8wRulzVEm9Yy8eDvDYCTsb2MGTQZPbrxK8Yo9DRf08SfmKt1FRwBhgyEG52Y2UDEgepO
	8uTWdCsdbgbOoVFhUbnE0gRioZe8VOI3vb54KCF0Z1OOxEuznC+HNSxQy13/fmbSGk3+s2Bw8Lx
	ZKu4hgzX+tiXHiWDQFNoSaXfyN98LRJ01biGOoh6C865KymrQQv2w1aGdBvn7Fck3N38lpJnVMu
	m73tdTTMVJQsrZAYXusbckZOSfLZduHxR8KGLr+LuNm5F8zwaxTP1inGM6NHmULSAuus15moiZs
	xUTt22m92WYoLv0vFKmkE2WBJ9+s/RDxazNjBVEewfYf6RinUhEZoJ7+o8JIRHKouYOC8g4Odr2
	eFCT0Vi0RTJJOeB0dot11IZAc3MA7Rv1Brm33RV2jIhMMA5VDDY3A/ZaOSbB8aDV+k3/fzbu0Wo
	02oy6lvewhgy6cql/8U50RZ3VODxoagw/a5doW8xtrlb7A4/MjZokYG+rXbSMKp6Aq4371SNQLt
	3Qg1mZUS9lvwWT3CZ7U=
X-Received: by 2002:a05:690c:39b:b0:89a:63da:fa95 with SMTP id 00721157ae682-89a63db043amr28878177b3.80.1790024449272;
        Mon, 21 Sep 2026 14:00:49 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a23c738bdfsm1445297b3.11.2026.09.21.14.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:00:48 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 43/46] KVM: arm64: Add Caretaker EL2 exception vectors and guest entry/exit assembly
Date: Mon, 21 Sep 2026 17:00:31 -0400
Message-ID: <20260921210034.180424-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260921210034.180424-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
 <20260921210034.180424-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add arch/arm64/kvm/caretaker_vmenter.S for standalone VHE EL2 guest
entry/exit world switch and exception vector dispatch on preserved cores.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/kvm/caretaker_vmenter.S | 248 +++++++++++++++++++++++++++++
 1 file changed, 248 insertions(+)
 create mode 100644 arch/arm64/kvm/caretaker_vmenter.S

diff --git a/arch/arm64/kvm/caretaker_vmenter.S b/arch/arm64/kvm/caretaker_vmenter.S
new file mode 100644
index 000000000000..6dff9fbe931f
--- /dev/null
+++ b/arch/arm64/kvm/caretaker_vmenter.S
@@ -0,0 +1,248 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Caretaker low-level guest entry/exit and vector table for ARM64 VHE.
+ *
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
+#include <asm/sysreg.h>
+#include "caretaker.h"
+
+	.pushsection ".text.cpu_preserved", "ax"
+
+.macro cventry target
+	.align 7
+	stp	x0, x1, [sp, #-16]!
+	b	\target
+.endm
+
+	.align 11
+SYM_CODE_START(caretaker_hyp_vector)
+	/* Current EL with SP0 */
+	cventry	caretaker_invalid
+	cventry	caretaker_el2h_irq
+	cventry	caretaker_el2h_irq
+	cventry	caretaker_invalid
+
+	/* Current EL with SPx (EL2h) */
+	cventry	caretaker_invalid
+	cventry	caretaker_el2h_irq
+	cventry	caretaker_el2h_irq
+	cventry	caretaker_invalid
+
+	/* Lower EL using AArch64 (Guest EL1/EL0) */
+	cventry	caretaker_el1_sync
+	cventry	caretaker_el1_irq
+	cventry	caretaker_el1_fiq
+	cventry	caretaker_el1_error
+
+	/* Lower EL using AArch32 */
+	cventry	caretaker_el1_sync
+	cventry	caretaker_el1_irq
+	cventry	caretaker_el1_fiq
+	cventry	caretaker_el1_error
+SYM_CODE_END(caretaker_hyp_vector)
+
+SYM_CODE_START_LOCAL(caretaker_invalid)
+	mrs	x0, elr_el2
+	mrs	x1, esr_el2
+	mrs	x2, far_el2
+	b	arm64_caretaker_handle_invalid
+SYM_CODE_END(caretaker_invalid)
+
+SYM_CODE_START_LOCAL(caretaker_el2h_irq)
+	stp	x2, x3,   [sp, #-16]!
+	stp	x4, x5,   [sp, #-16]!
+	stp	x6, x7,   [sp, #-16]!
+	stp	x8, x9,   [sp, #-16]!
+	stp	x10, x11, [sp, #-16]!
+	stp	x12, x13, [sp, #-16]!
+	stp	x14, x15, [sp, #-16]!
+	stp	x16, x17, [sp, #-16]!
+	stp	x29, x30, [sp, #-16]!
+
+	mrs_s	x0, SYS_ICC_IAR1_EL1
+	cmp	x0, #GIC_SPECIAL_INTID_START
+	b.ge	1f
+	msr_s	SYS_ICC_EOIR1_EL1, x0
+	msr_s	SYS_ICC_DIR_EL1, x0
+1:
+	/*
+	 * Silence the EL2 physical timer before returning.
+	 *
+	 * It is the only EL2 interrupt source the Caretaker arms
+	 * (arm64_caretaker_op_arm_timer() writes CNTHP_CTL_EL2.ENABLE to
+	 * drive the on-core quantum), and it is level-triggered off
+	 * CNTHP_CTL_EL2.ISTATUS.  Neither EOIR1 nor DIR clears ISTATUS, so
+	 * without disabling ENABLE here the line re-asserts the instant we
+	 * eret and the core live-locks taking the same interrupt forever --
+	 * it never reaches the run loop, which means it can never observe a
+	 * detach request and can never be reclaimed.
+	 *
+	 * This is done on the special-INTID path too: a spurious read of
+	 * IAR1 does not mean the timer has stopped asserting.  The run loop
+	 * re-arms the timer for each new quantum, so dropping it here costs
+	 * at most the remainder of the current one.
+	 */
+	msr_s	SYS_CNTHP_CTL_EL2, xzr
+	isb
+
+	ldp	x29, x30, [sp], #16
+	ldp	x16, x17, [sp], #16
+	ldp	x14, x15, [sp], #16
+	ldp	x12, x13, [sp], #16
+	ldp	x10, x11, [sp], #16
+	ldp	x8, x9,   [sp], #16
+	ldp	x6, x7,   [sp], #16
+	ldp	x4, x5,   [sp], #16
+	ldp	x2, x3,   [sp], #16
+	ldp	x0, x1,   [sp], #16
+	eret
+	sb
+SYM_CODE_END(caretaker_el2h_irq)
+
+SYM_CODE_START_LOCAL(caretaker_el1_sync)
+	mov	x0, #ARM_EXCEPTION_TRAP
+	b	caretaker_guest_exit
+SYM_CODE_END(caretaker_el1_sync)
+
+SYM_CODE_START_LOCAL(caretaker_el1_irq)
+SYM_CODE_START_LOCAL(caretaker_el1_fiq)
+	mov	x0, #ARM_EXCEPTION_IRQ
+	b	caretaker_guest_exit
+SYM_CODE_END(caretaker_el1_fiq)
+SYM_CODE_END(caretaker_el1_irq)
+
+SYM_CODE_START_LOCAL(caretaker_el1_error)
+	mov	x0, #ARM_EXCEPTION_EL1_SERROR
+	b	caretaker_guest_exit
+SYM_CODE_END(caretaker_el1_error)
+
+/*
+ * u64 caretaker_guest_enter(struct kvm_vcpu *vcpu);
+ *   x0: vcpu pointer
+ * Returns exit code in x0.
+ */
+SYM_FUNC_START(caretaker_guest_enter)
+	// Save host callee-saved registers on stack
+	stp	x19, x20, [sp, #-112]!
+	stp	x21, x22, [sp, #16]
+	stp	x23, x24, [sp, #32]
+	stp	x25, x26, [sp, #48]
+	stp	x27, x28, [sp, #64]
+	stp	x29, x30, [sp, #80]
+	str	x0, [sp, #96]			// Save vcpu pointer on host stack
+	mrs	x1, sp_el0
+	str	x1, [sp, #104]			// Save host sp_el0 (current task)
+
+	// Install caretaker vectors
+	adr_l	x1, caretaker_hyp_vector
+	msr	vbar_el1, x1
+	msr	vbar_el2, x1
+	isb
+
+	// Restore guest context from ctx->ctxt
+	add	x29, x0, #CAP_CTXT_OFFSET
+
+	ldr	x1, [x29, #CPU_XREG_OFFSET(32)]	// regs.pc
+	msr	elr_el2, x1
+	ldr	x1, [x29, #CPU_XREG_OFFSET(33)]	// regs.pstate
+	msr	spsr_el2, x1
+	ldr	x1, [x29, #CPU_XREG_OFFSET(31)]	// regs.sp
+	msr	sp_el0, x1
+
+	// Restore guest GPRs x0-x28, lr (x30)
+	ldp	x0, x1, [x29, #CPU_XREG_OFFSET(0)]
+	ldp	x2, x3, [x29, #CPU_XREG_OFFSET(2)]
+	ldp	x4, x5, [x29, #CPU_XREG_OFFSET(4)]
+	ldp	x6, x7, [x29, #CPU_XREG_OFFSET(6)]
+	ldp	x8, x9, [x29, #CPU_XREG_OFFSET(8)]
+	ldp	x10, x11, [x29, #CPU_XREG_OFFSET(10)]
+	ldp	x12, x13, [x29, #CPU_XREG_OFFSET(12)]
+	ldp	x14, x15, [x29, #CPU_XREG_OFFSET(14)]
+	ldp	x16, x17, [x29, #CPU_XREG_OFFSET(16)]
+	ldp	x18, x19, [x29, #CPU_XREG_OFFSET(18)]
+	ldp	x20, x21, [x29, #CPU_XREG_OFFSET(20)]
+	ldp	x22, x23, [x29, #CPU_XREG_OFFSET(22)]
+	ldp	x24, x25, [x29, #CPU_XREG_OFFSET(24)]
+	ldp	x26, x27, [x29, #CPU_XREG_OFFSET(26)]
+	ldr	x30,      [x29, #CPU_XREG_OFFSET(30)]
+	ldp	x28, x29, [x29, #CPU_XREG_OFFSET(28)]
+
+	eret
+	sb
+SYM_FUNC_END(caretaker_guest_enter)
+
+SYM_CODE_START_LOCAL(caretaker_guest_exit)
+	// Save exception code in x0 temporarily
+	str	x0, [sp, #-16]!
+
+	// Retrieve ctx pointer from host stack
+	ldr	x0, [sp, #128]
+	add	x1, x0, #CAP_CTXT_OFFSET
+
+	// Save guest GPRs x2-x29, lr (x30)
+	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
+	stp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
+	stp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
+	stp	x8, x9,   [x1, #CPU_XREG_OFFSET(8)]
+	stp	x10, x11, [x1, #CPU_XREG_OFFSET(10)]
+	stp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
+	stp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
+	stp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
+	stp	x18, x19, [x1, #CPU_XREG_OFFSET(18)]
+	stp	x20, x21, [x1, #CPU_XREG_OFFSET(20)]
+	stp	x22, x23, [x1, #CPU_XREG_OFFSET(22)]
+	stp	x24, x25, [x1, #CPU_XREG_OFFSET(24)]
+	stp	x26, x27, [x1, #CPU_XREG_OFFSET(26)]
+	stp	x28, x29, [x1, #CPU_XREG_OFFSET(28)]
+	str	x30,      [x1, #CPU_XREG_OFFSET(30)]
+
+	// Clear Branch History Buffer (Spectre-BHB mitigation) across EL1->EL2 exit
+	mov	x2, #32
+1:	b	2f
+2:	subs	x2, x2, #1
+	b.ne	1b
+	isb
+
+	// Retrieve and save guest x0, x1 (from vector entry on stack)
+	ldp	x2, x3, [sp, #16]
+	stp	x2, x3, [x1, #CPU_XREG_OFFSET(0)]
+
+	// Save guest system registers
+	mrs	x2, elr_el2
+	str	x2, [x1, #CPU_XREG_OFFSET(32)]	// regs.pc
+	mrs	x2, spsr_el2
+	str	x2, [x1, #CPU_XREG_OFFSET(33)]	// regs.pstate
+	mrs	x2, sp_el0
+	str	x2, [x1, #CPU_XREG_OFFSET(31)]	// regs.sp
+	mrs	x2, esr_el2
+	str	x2, [x0, #CAP_FAULT_ESR]
+	mrs	x2, far_el2
+	str	x2, [x0, #CAP_FAULT_FAR]
+	mrs	x2, hpfar_el2
+	str	x2, [x0, #CAP_FAULT_HPFAR]
+
+	// Restore return value (exception code) in x0
+	ldr	x0, [sp], #32			// pops exception code + saved x0,x1
+
+	// Restore host callee-saved registers
+	ldp	x19, x20, [sp, #0]
+	ldp	x21, x22, [sp, #16]
+	ldp	x23, x24, [sp, #32]
+	ldp	x25, x26, [sp, #48]
+	ldp	x27, x28, [sp, #64]
+	ldp	x29, x30, [sp, #80]
+	ldr	x1, [sp, #104]
+	msr	sp_el0, x1
+	add	sp, sp, #112
+
+	ret
+SYM_CODE_END(caretaker_guest_exit)
+
+	.popsection
-- 
2.55.0.1082.g2b9226bbc0-goog

