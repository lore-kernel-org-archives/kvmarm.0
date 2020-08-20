Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC3EC433E4
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB58F20639
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="VSNVDRJm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB58F20639
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 840964B879;
	Thu, 20 Aug 2020 06:35:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hPz-oHpo+SX6; Thu, 20 Aug 2020 06:35:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1219A4B79B;
	Thu, 20 Aug 2020 06:35:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63F284B890
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MVqlqKH-RhFq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:34 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E118B4B88D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:33 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id v11so1759501ybm.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=yWIxVTXSWX9DBZGTihfgjYAmV7ffHrDFhCW1uSQ19FA=;
 b=VSNVDRJmBuP9EBJ0jRQJNS+KXGaULrrKeHAtXhSAnOiSfxfE3lKexLQjfMPURSrQHl
 BC3bloducVyjy2R51GQoiX4zEroPp1oDVeovEH4H37RrwZpVoZBHL9zyh47DDdLE5gXH
 9Vk8EUht7VCuFlydtwVzIHH1cQNPsqkbmuM6huHHtpKGyMKMWMKhqL/Km6lqswm2AWT2
 0vFGS5O8LE7QjOPO6+pXNIn7pIvx0UeFp81Khmo0tm57t48vgzEDhkTjEPo+owCmpL9O
 PWxO/Q88qu+GFZ8sEH+fl6V6fgSPc4eo6dQffmBnfuPjNJKiLMtvFqnujVHOain62aQM
 M73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=yWIxVTXSWX9DBZGTihfgjYAmV7ffHrDFhCW1uSQ19FA=;
 b=Z+Ypsg5Nw/jO5byJj7LqDIis5zkC1ia59UzcZE/lJBZBL76hWI+RSRyzy2LVReFHsy
 AfBXeD9LYF5qmFIOejiSg75LyfNxccbfkeYLbl7Hl0DHCMWZDBc2gvQcWpVSm5Zds34R
 rbzUWru5iKpxM6nf/8m7Fy4Mcfv457Ar4dQDstb8dhNqO54OTHRiSBoupQT2LCBZXw+o
 rq6+Kx3IQkrBrb510ePz/cSaS0dnDqNK7gTX7j6232fJM67BeX8fMM/i60axkZG8E7kZ
 0QSYY86t68c7FIm80REPrGgpQt6J6jsZKGZVzGv1Fi1+59OdQRmXStETWEpYzpr63xOR
 XhFw==
X-Gm-Message-State: AOAM532cLorrZgQJP5sjhjOnlxuy5f2AI1zaC7dZXA+aDTtSp/zSDlhA
 J6Fs+9E2WeceTJFDClXKcaqCDtFHqiZ0G2OnfISvEPl04/UAHMYLXGvJ7kCQA9KIGkz3zib97uH
 eHVpBUvb+F+b5JLE0Gc0JocEb4K4/xanTQBXCJzZypW1eAJYX3zDsFRNi6XOFrxew+ZxdIQ==
X-Google-Smtp-Source: ABdhPJz5fESWbgO87rA6SAxKswcyB7Uz5IXFWQWDJgzSkcCaR7Ls23qoOqB19umoL7RrqC845cHGfrnCDzM=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a25:dc4b:: with SMTP id
 y72mr3699094ybe.197.1597919733298; 
 Thu, 20 Aug 2020 03:35:33 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:32 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-7-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 06/20] KVM: arm64: nVHE: Use separate vector for the host
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

The host is treated differently from the guests when an exception is
taken so introduce a separate vector that is specialized for the host.
This also allows the nVHE specific code to move out of hyp-entry.S and
into nvhe/host.S.

The host is only expected to make HVC calls and anything else is
considered invalid and results in a panic.

Hyp initialization is now passed the vector that is used for the host
and it is swapped for the guest vector during the context switch.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h |   2 +
 arch/arm64/kernel/image-vars.h   |   1 +
 arch/arm64/kvm/arm.c             |  11 +++-
 arch/arm64/kvm/hyp/hyp-entry.S   |  65 -------------------
 arch/arm64/kvm/hyp/nvhe/Makefile |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S   | 104 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c |   3 +
 7 files changed, 121 insertions(+), 67 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/host.S

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 413911d6446a..81f29a2c361a 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -98,10 +98,12 @@ struct kvm_vcpu;
 struct kvm_s2_mmu;
 
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
+DECLARE_KVM_NVHE_SYM(__kvm_hyp_host_vector);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
+#define __kvm_hyp_host_vector	CHOOSE_NVHE_SYM(__kvm_hyp_host_vector)
 #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
 #endif
 
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 9e897c500237..7e93b0c426d4 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -71,6 +71,7 @@ KVM_NVHE_ALIAS(kvm_update_va_mask);
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
 KVM_NVHE_ALIAS(kvm_host_data);
+KVM_NVHE_ALIAS(kvm_hyp_vector);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
 /* Kernel constant needed to compute idmap addresses. */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d779814f0da6..c6f76fdabecb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1277,7 +1277,7 @@ static void cpu_init_hyp_mode(void)
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
-	vector_ptr = __this_cpu_read(kvm_hyp_vector);
+	vector_ptr = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
@@ -1542,6 +1542,7 @@ static int init_hyp_mode(void)
 
 	for_each_possible_cpu(cpu) {
 		struct kvm_host_data *cpu_data;
+		unsigned long *vector;
 
 		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
 		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
@@ -1550,6 +1551,14 @@ static int init_hyp_mode(void)
 			kvm_err("Cannot map host CPU state: %d\n", err);
 			goto out_err;
 		}
+
+		vector = per_cpu_ptr(&kvm_hyp_vector, cpu);
+		err = create_hyp_mappings(vector, vector + 1, PAGE_HYP);
+
+		if (err) {
+			kvm_err("Cannot map hyp guest vector address\n");
+			goto out_err;
+		}
 	}
 
 	err = hyp_map_aux_data();
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index b0923e9f9291..6e14873680a8 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -12,25 +12,10 @@
 #include <asm/cpufeature.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
-#include <asm/kvm_mmu.h>
 #include <asm/mmu.h>
 
 	.text
 
-.macro do_el2_call
-	/*
-	 * Shuffle the parameters before calling the function
-	 * pointed to in x0. Assumes parameters in x[1,2,3].
-	 */
-	str	lr, [sp, #-16]!
-	mov	lr, x0
-	mov	x0, x1
-	mov	x1, x2
-	mov	x2, x3
-	blr	lr
-	ldr	lr, [sp], #16
-.endm
-
 el1_sync:				// Guest trapped into EL2
 
 	mrs	x0, esr_el2
@@ -39,43 +24,6 @@ el1_sync:				// Guest trapped into EL2
 	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
 	b.ne	el1_trap
 
-#ifdef __KVM_NVHE_HYPERVISOR__
-	mrs	x1, vttbr_el2		// If vttbr is valid, the guest
-	cbnz	x1, el1_hvc_guest	// called HVC
-
-	/* Here, we're pretty sure the host called HVC. */
-	ldp	x0, x1, [sp], #16
-
-	/* Check for a stub HVC call */
-	cmp	x0, #HVC_STUB_HCALL_NR
-	b.hs	1f
-
-	/*
-	 * Compute the idmap address of __kvm_handle_stub_hvc and
-	 * jump there. Since we use kimage_voffset, do not use the
-	 * HYP VA for __kvm_handle_stub_hvc, but the kernel VA instead
-	 * (by loading it from the constant pool).
-	 *
-	 * Preserve x0-x4, which may contain stub parameters.
-	 */
-	ldr	x5, =__kvm_handle_stub_hvc
-	ldr_l	x6, kimage_voffset
-
-	/* x5 = __pa(x5) */
-	sub	x5, x5, x6
-	br	x5
-
-1:
-	/*
-	 * Perform the EL2 call
-	 */
-	kern_hyp_va	x0
-	do_el2_call
-
-	eret
-	sb
-#endif /* __KVM_NVHE_HYPERVISOR__ */
-
 el1_hvc_guest:
 	/*
 	 * Fastest possible path for ARM_SMCCC_ARCH_WORKAROUND_1.
@@ -181,18 +129,6 @@ el2_error:
 	eret
 	sb
 
-#ifdef __KVM_NVHE_HYPERVISOR__
-SYM_FUNC_START(__hyp_do_panic)
-	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
-		      PSR_MODE_EL1h)
-	msr	spsr_el2, lr
-	ldr	lr, =panic
-	msr	elr_el2, lr
-	eret
-	sb
-SYM_FUNC_END(__hyp_do_panic)
-#endif
-
 .macro invalid_vector	label, target = hyp_panic
 	.align	2
 SYM_CODE_START(\label)
@@ -205,7 +141,6 @@ SYM_CODE_END(\label)
 	invalid_vector	el2t_irq_invalid
 	invalid_vector	el2t_fiq_invalid
 	invalid_vector	el2t_error_invalid
-	invalid_vector	el2h_sync_invalid
 	invalid_vector	el2h_irq_invalid
 	invalid_vector	el2h_fiq_invalid
 	invalid_vector	el1_fiq_invalid
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index aef76487edc2..ddf98eb07b9d 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
new file mode 100644
index 000000000000..9c96b9a3b71d
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2020 - Google Inc
+ * Author: Andrew Scull <ascull@google.com>
+ */
+
+#include <linux/linkage.h>
+
+#include <asm/assembler.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_mmu.h>
+
+	.text
+
+SYM_FUNC_START(__hyp_do_panic)
+	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
+		      PSR_MODE_EL1h)
+	msr	spsr_el2, lr
+	ldr	lr, =panic
+	msr	elr_el2, lr
+	eret
+	sb
+SYM_FUNC_END(__hyp_do_panic)
+
+.macro valid_host_el1_sync_vect
+	.align 7
+	esb
+	stp	x0, x1, [sp, #-16]!
+
+	mrs	x0, esr_el2
+	lsr	x0, x0, #ESR_ELx_EC_SHIFT
+	cmp	x0, #ESR_ELx_EC_HVC64
+	b.ne	hyp_panic
+
+	ldp	x0, x1, [sp], #16
+
+	/* Check for a stub HVC call */
+	cmp	x0, #HVC_STUB_HCALL_NR
+	b.hs	1f
+
+	/*
+	 * Compute the idmap address of __kvm_handle_stub_hvc and
+	 * jump there. Since we use kimage_voffset, do not use the
+	 * HYP VA for __kvm_handle_stub_hvc, but the kernel VA instead
+	 * (by loading it from the constant pool).
+	 *
+	 * Preserve x0-x4, which may contain stub parameters.
+	 */
+	ldr	x5, =__kvm_handle_stub_hvc
+	ldr_l	x6, kimage_voffset
+
+	/* x5 = __pa(x5) */
+	sub	x5, x5, x6
+	br	x5
+
+1:
+	/*
+	 * Shuffle the parameters before calling the function
+	 * pointed to in x0. Assumes parameters in x[1,2,3].
+	 */
+	kern_hyp_va	x0
+	str	lr, [sp, #-16]!
+	mov	lr, x0
+	mov	x0, x1
+	mov	x1, x2
+	mov	x2, x3
+	blr	lr
+	ldr	lr, [sp], #16
+
+	eret
+	sb
+.endm
+
+.macro invalid_host_vect
+	.align 7
+	b	hyp_panic
+.endm
+
+/*
+ * CONFIG_KVM_INDIRECT_VECTORS is not applied to the host vector because the
+ * host already knows the address of hyp by virtue of loading it there.
+ */
+	.align 11
+SYM_CODE_START(__kvm_hyp_host_vector)
+	invalid_host_vect			// Synchronous EL2t
+	invalid_host_vect			// IRQ EL2t
+	invalid_host_vect			// FIQ EL2t
+	invalid_host_vect			// Error EL2t
+
+	invalid_host_vect			// Synchronous EL2h
+	invalid_host_vect			// IRQ EL2h
+	invalid_host_vect			// FIQ EL2h
+	invalid_host_vect			// Error EL2h
+
+	valid_host_el1_sync_vect		// Synchronous 64-bit EL1
+	invalid_host_vect			// IRQ 64-bit EL1
+	invalid_host_vect			// FIQ 64-bit EL1
+	invalid_host_vect			// Error 64-bit EL1
+
+	invalid_host_vect			// Synchronous 32-bit EL1
+	invalid_host_vect			// IRQ 32-bit EL1
+	invalid_host_vect			// FIQ 32-bit EL1
+	invalid_host_vect			// Error 32-bit EL1
+SYM_CODE_END(__kvm_hyp_host_vector)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f969a6dc4741..05bb0b472091 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -42,6 +42,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	}
 
 	write_sysreg(val, cptr_el2);
+	write_sysreg(__hyp_this_cpu_read(kvm_hyp_vector), vbar_el2);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
@@ -60,6 +61,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 static void __deactivate_traps(struct kvm_vcpu *vcpu)
 {
+	extern char __kvm_hyp_host_vector[];
 	u64 mdcr_el2;
 
 	___deactivate_traps(vcpu);
@@ -91,6 +93,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(mdcr_el2, mdcr_el2);
 	write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
+	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
 
 static void __load_host_stage2(void)
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
