Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC26C433EB
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2604A2076C
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="dZwVYSPX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2604A2076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D42554B3C4;
	Wed, 15 Jul 2020 14:45:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rx4UFvQrkbfe; Wed, 15 Jul 2020 14:45:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C9154B215;
	Wed, 15 Jul 2020 14:45:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B2A4B1B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nXcTU+OQPdyb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:06 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B75314B170
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:06 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id i203so3963085yba.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cgwmT+Xtpy7jPWwZEhAU4ETDEWRuysJT/c8HvyBFZc8=;
 b=dZwVYSPXzv+kwhd3MJO3k8ab1cE2mh0UIuTshRuP1MT/3hTeI7T89qBxCbXwsmuL1e
 TQfTNJCHHOEHsCc8nrg6VFtchGq0Z3hcQhIwUerk8caxpM3c3vfXZ/Au2Rr3TsxQlncQ
 +zCW9PC70CC1SyEVpMc8bkznaUr2G5XLfMiFfsHAzD1VaniO8Y5hIEOfB+g8Dq/hz6hJ
 V53jkDtkh7/dr2qY6v2TgvbwcrweTEHUaOAfinGxUy63oSn4f3uv1XNGJ5CNfoM5ZG7S
 lpa/EvYMZOHahHBlrw67IPNzyRk/TCnNu6enlxTJAg6JHzrVsKAWoM0hCCKRpM/n6l+V
 urOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cgwmT+Xtpy7jPWwZEhAU4ETDEWRuysJT/c8HvyBFZc8=;
 b=WypvMShdISbwrXde+3zYbZ+gFoNGOTNRC9Ia3mgFMwEiFVw3InEjNwKgOPhlewGnJU
 008HMTK9S/22ORZpqLH1U+dPKA+9NL5CRpIiaK8LWF8bOR/TxX772D0L+/Qx9CKWsUFv
 FlrtWHqSSZfoyj/Hu/yMba/hgB2/QFnxzIT4FhwdIa5FtUgSIhP97NFDWgrJ3hR/9YZz
 tVtTadzku8hXkz1MuRKFaIpes4ZTevLBFCX5wA3mIaD744fx0jKE/Djh7RL7LtuHFyEi
 yp7A7t2QmIpjEsnqmNWELq3ag4ilnwCILeXtkWB+WJ/0RfpyXCmumKld//eUuiutLXGe
 sYPA==
X-Gm-Message-State: AOAM530hMoAGVsFjvZJNrES8mxnXwrQNIkK7nAAQGWoQBwMGFd+6py3s
 zISUFPCIzb481w3wIQLE/wEe6jpITXbjCBTH6m4+KpzgMSBdNtOQPR4iu0U1qS2V21XlfZBX/Qz
 u6D5yhDh2M4HIZrxR0WYJhL2D1qmMOA0N0O+0w/5pnljVnoQ8lRCPk9Rtf0RBlGF1iHwn8Q==
X-Google-Smtp-Source: ABdhPJyas7Di9rQKemCkcoOibXMeDekkf0cdy/saWM9Wch7rvpPGRf+htqfp60wpH+AhnTBcn4/zFxseWxE=
X-Received: by 2002:a25:61ce:: with SMTP id v197mr493324ybb.459.1594838706074; 
 Wed, 15 Jul 2020 11:45:06 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:09 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-9-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 08/37] KVM: arm64: nVHE: Introduce a hyp run loop for the host
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

After installing the page tables and exception vector, the call to
__do_hyp_init no longer directly returns to the host with an eret but,
instead, begins to treat the host as a vCPU and repeatedly __guest_enters
into it.

As a result, hyp is endowed with its very own context for the general
purpose registers. However, at this point in time, the state is stored
in a confusing way:
   - hyp gp_regs and ptrauth are stored in the kvm_host_data context
   - host gp_regs and ptrauth are stored in kvm_host_vcpu
   - other host sysregs are store in the kvm_host_data context

This is the initial step in the migration but all the host registers
will need to be moved into kvm_host_vcpu for the migration to be
complete.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  5 ++
 arch/arm64/include/asm/kvm_hyp.h        |  3 +
 arch/arm64/kernel/image-vars.h          |  1 +
 arch/arm64/kvm/arm.c                    | 10 +++
 arch/arm64/kvm/hyp/entry.S              |  4 +-
 arch/arm64/kvm/hyp/hyp-entry.S          | 29 +-------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +-
 arch/arm64/kvm/hyp/nvhe/Makefile        |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 90 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-start.S     | 39 ++++++++++-
 10 files changed, 154 insertions(+), 33 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-main.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 67a760d08b6e..183312340d2c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -413,6 +413,11 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
 #define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
 
+#define KVM_ARM64_HOST_VCPU_FLAGS KVM_ARM64_DEBUG_DIRTY			\
+				| KVM_ARM64_GUEST_HAS_SVE		\
+				| KVM_ARM64_VCPU_SVE_FINALIZED		\
+				| KVM_ARM64_GUEST_HAS_PTRAUTH
+
 #define vcpu_has_sve(vcpu) (system_supports_sve() && \
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 50a774812761..d6915ab60e1f 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -13,6 +13,9 @@
 #include <asm/sysreg.h>
 
 DECLARE_PER_CPU(struct kvm_vcpu *, kvm_hyp_running_vcpu);
+#ifdef __KVM_NVHE_HYPERVISOR__
+DECLARE_PER_CPU(struct kvm_vcpu, kvm_host_vcpu);
+#endif
 
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index dfe0f37567f3..5b93da2359d4 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -71,6 +71,7 @@ KVM_NVHE_ALIAS(kvm_update_va_mask);
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
 KVM_NVHE_ALIAS(kvm_host_data);
+KVM_NVHE_ALIAS(kvm_host_vcpu);
 KVM_NVHE_ALIAS(kvm_hyp_running_vcpu);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 52be6149fcbf..8bd4630666ca 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
 #endif
 
 DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
+DEFINE_PER_CPU(struct kvm_vcpu, kvm_host_vcpu);
 DEFINE_PER_CPU(struct kvm_vcpu *, kvm_hyp_running_vcpu);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
@@ -1544,6 +1545,7 @@ static int init_hyp_mode(void)
 
 	for_each_possible_cpu(cpu) {
 		kvm_host_data_t *cpu_data;
+		struct kvm_vcpu *host_vcpu;
 		struct kvm_vcpu **running_vcpu;
 
 		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
@@ -1554,6 +1556,14 @@ static int init_hyp_mode(void)
 			goto out_err;
 		}
 
+		host_vcpu = per_cpu_ptr(&kvm_host_vcpu, cpu);
+		err = create_hyp_mappings(host_vcpu, host_vcpu + 1, PAGE_HYP);
+
+		if (err) {
+			kvm_err("Cannot map host vCPU: %d\n", err);
+			goto out_err;
+		}
+
 		running_vcpu = per_cpu_ptr(&kvm_hyp_running_vcpu, cpu);
 		err = create_hyp_mappings(running_vcpu, running_vcpu + 1, PAGE_HYP);
 
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index dc4e3e7e7407..da349c152791 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -72,8 +72,8 @@ SYM_FUNC_START(__guest_enter)
 	// Save the host's sp_el0
 	save_sp_el0	x1, x2
 
-	// Now the host state is stored if we have a pending RAS SError it must
-	// affect the host. If physical IRQ interrupts are going to be trapped
+	// Now the hyp state is stored if we have a pending RAS SError it must
+	// affect the hyp. If physical IRQ interrupts are going to be trapped
 	// and there are already asynchronous exceptions pending then we defer
 	// the entry. The DSB isn't necessary before v8.2 as any SError would
 	// be fatal.
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index c441aabb8ab0..a45459d1c135 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -17,20 +17,6 @@
 
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
@@ -44,11 +30,12 @@ el1_sync:				// Guest trapped into EL2
 	cbnz	x1, el1_hvc_guest	// called HVC
 
 	/* Here, we're pretty sure the host called HVC. */
-	ldp	x0, x1, [sp], #16
+	ldp	x0, x1, [sp]
 
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
-	b.hs	1f
+	b.hs	el1_trap
+	add	sp, sp, #16
 
 	/*
 	 * Compute the idmap address of __kvm_handle_stub_hvc and
@@ -64,16 +51,6 @@ el1_sync:				// Guest trapped into EL2
 	/* x5 = __pa(x5) */
 	sub	x5, x5, x6
 	br	x5
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
 #endif /* __KVM_NVHE_HYPERVISOR__ */
 
 el1_hvc_guest:
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 14a774d1a35a..248f434c5de6 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -405,8 +405,8 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  */
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	/* Flush guest SErrors. */
-	if (ARM_SERROR_PENDING(*exit_code))
+	/* Flush guest SErrors but leave them pending for the host. */
+	if (ARM_SERROR_PENDING(*exit_code) && !vcpu->arch.ctxt.is_host)
 		__vaxorcize_serror();
 
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 1f3a39efaa6e..d60cf9434895 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,7 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o \
-	 hyp-start.o
+	 hyp-start.o hyp-main.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
new file mode 100644
index 000000000000..9b58d58d6cfa
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 - Google Inc
+ * Author: Andrew Scull <ascull@google.com>
+ */
+
+#include <hyp/switch.h>
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+typedef unsigned long (*hypcall_fn_t)
+	(unsigned long, unsigned long, unsigned long);
+
+static void handle_trap(struct kvm_vcpu *host_vcpu) {
+	if (kvm_vcpu_trap_get_class(host_vcpu) == ESR_ELx_EC_HVC64) {
+		hypcall_fn_t func;
+		unsigned long ret;
+
+		/*
+		 * __kvm_call_hyp takes a pointer in the host address space and
+		 * up to three arguments.
+		 */
+		func = (hypcall_fn_t)kern_hyp_va(vcpu_get_reg(host_vcpu, 0));
+		ret = func(vcpu_get_reg(host_vcpu, 1),
+			   vcpu_get_reg(host_vcpu, 2),
+			   vcpu_get_reg(host_vcpu, 3));
+		vcpu_set_reg(host_vcpu, 0, ret);
+	}
+
+	/* Other traps are ignored. */
+}
+
+void __noreturn kvm_hyp_main(void)
+{
+	/* Set tpidr_el2 for use by HYP */
+	struct kvm_vcpu *host_vcpu;
+	struct kvm_cpu_context *hyp_ctxt;
+
+	host_vcpu = __hyp_this_cpu_ptr(kvm_host_vcpu);
+	hyp_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+
+	kvm_init_host_cpu_context(&host_vcpu->arch.ctxt);
+
+	host_vcpu->arch.flags = KVM_ARM64_HOST_VCPU_FLAGS;
+	host_vcpu->arch.workaround_flags = VCPU_WORKAROUND_2_FLAG;
+
+	while (true) {
+		u64 exit_code;
+
+		/*
+		 * Set the running cpu for the vectors to pass to __guest_exit
+		 * so it can get the cpu context.
+		 */
+		*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = host_vcpu;
+
+		/*
+		 * Enter the host now that we feel like we're in charge.
+		 *
+		 * This should merge with __kvm_vcpu_run as host becomes more
+		 * vcpu-like.
+		 */
+		do {
+			exit_code = __guest_enter(host_vcpu, hyp_ctxt);
+		} while (fixup_guest_exit(host_vcpu, &exit_code));
+
+		switch (ARM_EXCEPTION_CODE(exit_code)) {
+		case ARM_EXCEPTION_TRAP:
+			handle_trap(host_vcpu);
+			break;
+		case ARM_EXCEPTION_IRQ:
+		case ARM_EXCEPTION_EL1_SERROR:
+		case ARM_EXCEPTION_IL:
+		default:
+			/*
+			 * These cases are not expected to be observed for the
+			 * host so, in the event that they are seen, take a
+			 * best-effort approach to keep things going.
+			 *
+			 * Ok, our expended effort comes to a grand total of
+			 * diddly squat but the internet protocol has gotten
+			 * away with the "best-effort" euphemism so we can too.
+			 */
+			break;
+		}
+
+	}
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-start.S b/arch/arm64/kvm/hyp/nvhe/hyp-start.S
index 5f7fbcb57fd5..dd955e022963 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-start.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-start.S
@@ -6,11 +6,46 @@
 
 #include <linux/linkage.h>
 
+#include <asm/alternative.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
+#include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_ptrauth.h>
+
+#define CPU_LR_OFFSET (CPU_USER_PT_REGS + (8 * 30))
+
+/*
+ * Initialize ptrauth in the hyp ctxt by populating it with the keys of the
+ * host, which are the keys currently installed.
+ */
+.macro ptrauth_hyp_ctxt_init hyp_ctxt, reg1, reg2, reg3
+#ifdef CONFIG_ARM64_PTR_AUTH
+alternative_if_not ARM64_HAS_ADDRESS_AUTH
+	b	.L__skip_switch\@
+alternative_else_nop_endif
+	add	\reg1, \hyp_ctxt, #CPU_APIAKEYLO_EL1
+	ptrauth_save_state	\reg1, \reg2, \reg3
+.L__skip_switch\@:
+#endif
+.endm
 
 SYM_CODE_START(__kvm_hyp_start)
-	/* Hello, World! */
-	eret
+	get_host_ctxt	x0, x1
+
+	ptrauth_hyp_ctxt_init x0, x1, x2, x3
+
+	/* Prepare a tail call from __guest_exit to kvm_hyp_main */
+	adr	x1, kvm_hyp_main
+	str	x1, [x0, #CPU_LR_OFFSET]
+
+	/*
+	 * The host's x0 and x1 are expected on the stack but they will be
+	 * clobbered so there's no need to load real values.
+	 */
+	sub	sp, sp, 16
+
+	hyp_adr_this_cpu x1, kvm_host_vcpu, x0
+	mov	x0, #ARM_EXCEPTION_TRAP
+	b	__guest_exit
 SYM_CODE_END(__kvm_hyp_start)
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
