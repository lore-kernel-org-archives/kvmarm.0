Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71B1C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:33:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4541964F2B
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:33:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4541964F2B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECBEA4B736;
	Thu, 18 Mar 2021 10:33:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R3KXK3BejKaE; Thu, 18 Mar 2021 10:33:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 901FA4B752;
	Thu, 18 Mar 2021 10:33:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 058144B729
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:33:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zOH5bEIdaNbN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 10:33:27 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C23564B766
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:33:26 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id s192so11913351wme.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 07:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=vTK8q0JnJBebUN5zGwJ3iwxC8prpg76SNvMBvE60kIc=;
 b=PAQAi9rqbbrrIXvlyLR/J5hOkX8xc5Ha/O5pRT5H1MHzU0wOqOCyM6fpPFXH9iDVEf
 dGiOAWxlBp0hkmVTYESyueid7YqSSSVvT8rpeckToSAL/wF/c7gmvjp5atTpP2iLQU4v
 j7lQb0KJQ6P8ZgkieDcWhsECGmXPoCCvV8BwgLNxlo8OwHVO1unArwA9AftSRehUbbZJ
 lXEiPRaZ/0EjCMMZLMjQTTRixGPSYgJHqCy+gp01jbeDT5bRpwBqISp3rPO4WXnfQTJQ
 DbwbJbutsEnsYIWcipQ+7lrPw/wTT8LEthbysPOkKeUwkfdB06PeUreYximUW2kxqY0M
 o1pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vTK8q0JnJBebUN5zGwJ3iwxC8prpg76SNvMBvE60kIc=;
 b=VPsKzpxsn+BMxKZFqruCmLQR3HCsZaQp+dVouHnyoA2a28mdBDYPHsoQati3R73Pxs
 4r0fQn7Fw9z7CsZ0sWzOWgEhcO5PWVbyRprAAZHmXtxuIu6UTQ5qzf4wRlyNF4kyRVRe
 WO933P2JrTQ5bc/b1djxzWsFloRChAiJygRTJ6Rch/CARm82o4RkjYsTeQYHc96Kwlhu
 e2tZjQmbo07+Q72XfOmgWx8ftc1sOlZhUjpT0LHIfhNezxWnY7gdSn/kxY9zX/1V2zbQ
 smhA3hXvXrw9mSHiGAvjQy9c4zA0agp2M9CpLj2ji1BnibVrj5nXBf2PfuIF+mZr3gOG
 RPeA==
X-Gm-Message-State: AOAM532il7lyWfiCme3s1o9Np31OLlZk22072qQwl5hm34R7DMlEA4R8
 Ql5YK/B+mMq+h/fCpdvvL9BmAbf/BJYTcJ9sDPHK5XXUNx1++9CM9iTwN8YgSxHJguhO/JXMsPF
 UM+/2kCubvkPWTDncMUoXQ3scaDYoxJxyAC3qeormLLA0fGEIbkeQho2OYGbkCZwFBGy8tA==
X-Google-Smtp-Source: ABdhPJwlKRZYz2+CY5LDRld2ByPb5630K+8xGHv01C3pFJ+rbVIQVOtqKI/T0Tr18BUyr81US9LkR+9AabA=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a05:600c:2312:: with SMTP id
 18mr3941011wmo.8.1616078005797; Thu, 18 Mar 2021 07:33:25 -0700 (PDT)
Date: Thu, 18 Mar 2021 14:33:11 +0000
In-Reply-To: <20210318143311.839894-1-ascull@google.com>
Message-Id: <20210318143311.839894-6-ascull@google.com>
Mime-Version: 1.0
References: <20210318143311.839894-1-ascull@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v3 5/5] KVM: arm64: Log source when panicking from nVHE hyp
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
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

To aid with debugging, add details of the source of a panic from nVHE
hyp. This is done by having nVHE hyp exit to nvhe_hyp_panic_handler()
rather than directly to panic(). The handler will then add the extra
details for debugging before panicking the kernel.

If the panic was due to a BUG(), look up the metadata to log the file
and line, if available, otherwise log an address that can be looked up
in vmlinux. The hyp offset is also logged to allow other hyp VAs to be
converted, similar to how the kernel offset is logged during a panic.

__hyp_panic_string is now inlined since it no longer needs to be
referenced as a symbol and the message is free to diverge between VHE
and nVHE.

The following is an example of the logs generated by a BUG in nVHE hyp.

[   46.754840] kvm [307]: nVHE hyp BUG at: arch/arm64/kvm/hyp/nvhe/switch.c:242!
[   46.755357] kvm [307]: Hyp Offset: 0xfffea6c58e1e0000
[   46.755824] Kernel panic - not syncing: HYP panic:
[   46.755824] PS:400003c9 PC:0000d93a82c705ac ESR:f2000800
[   46.755824] FAR:0000000080080000 HPFAR:0000000000800800 PAR:0000000000000000
[   46.755824] VCPU:0000d93a880d0000
[   46.756960] CPU: 3 PID: 307 Comm: kvm-vcpu-0 Not tainted 5.12.0-rc3-00005-gc572b99cf65b-dirty #133
[   46.757459] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
[   46.758366] Call trace:
[   46.758601]  dump_backtrace+0x0/0x1b0
[   46.758856]  show_stack+0x18/0x70
[   46.759057]  dump_stack+0xd0/0x12c
[   46.759236]  panic+0x16c/0x334
[   46.759426]  arm64_kernel_unmapped_at_el0+0x0/0x30
[   46.759661]  kvm_arch_vcpu_ioctl_run+0x134/0x750
[   46.759936]  kvm_vcpu_ioctl+0x2f0/0x970
[   46.760156]  __arm64_sys_ioctl+0xa8/0xec
[   46.760379]  el0_svc_common.constprop.0+0x60/0x120
[   46.760627]  do_el0_svc+0x24/0x90
[   46.760766]  el0_svc+0x2c/0x54
[   46.760915]  el0_sync_handler+0x1a4/0x1b0
[   46.761146]  el0_sync+0x170/0x180
[   46.761889] SMP: stopping secondary CPUs
[   46.762786] Kernel Offset: 0x3e1cd2820000 from 0xffff800010000000
[   46.763142] PHYS_OFFSET: 0xffffa9f680000000
[   46.763359] CPU features: 0x00240022,61806008
[   46.763651] Memory Limit: none
[   46.813867] ---[ end Kernel panic - not syncing: HYP panic:
[   46.813867] PS:400003c9 PC:0000d93a82c705ac ESR:f2000800
[   46.813867] FAR:0000000080080000 HPFAR:0000000000800800 PAR:0000000000000000
[   46.813867] VCPU:0000d93a880d0000 ]---

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h        |  2 ++
 arch/arm64/kernel/image-vars.h          |  3 +-
 arch/arm64/kvm/handle_exit.c            | 45 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 --
 arch/arm64/kvm/hyp/nvhe/host.S          | 18 ++++------
 arch/arm64/kvm/hyp/nvhe/psci-relay.c    |  2 --
 arch/arm64/kvm/hyp/vhe/switch.c         |  4 +--
 7 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 90873851f677..7c17a67d2291 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -121,6 +121,8 @@ void kvm_update_va_mask(struct alt_instr *alt,
 void kvm_compute_layout(void);
 void kvm_apply_hyp_relocations(void);
 
+#define __hyp_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)
+
 static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 {
 	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 5aa9ed1e9ec6..5ff2b6909387 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -70,8 +70,7 @@ KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
 /* Kernel symbols used to call panic() from nVHE hyp code (via ERET). */
-KVM_NVHE_ALIAS(__hyp_panic_string);
-KVM_NVHE_ALIAS(panic);
+KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
 
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index cebe39f3b1b6..6f48336b1d86 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -291,3 +291,48 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 	if (exception_index == ARM_EXCEPTION_EL1_SERROR)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
+
+void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
+					      u64 par, uintptr_t vcpu,
+					      u64 far, u64 hpfar) {
+	u64 elr_in_kimg = __phys_to_kimg(__hyp_pa(elr));
+	u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr;
+	u64 mode = spsr & PSR_MODE_MASK;
+
+	/*
+	 * The nVHE hyp symbols are not included by kallsyms to avoid issues
+	 * with aliasing. That means that the symbols cannot be printed with the
+	 * "%pS" format specifier, so fall back to the vmlinux address if
+	 * there's no better option.
+	 */
+	if (mode != PSR_MODE_EL2t && mode != PSR_MODE_EL2h) {
+		kvm_err("Invalid host exception to nVHE hyp!\n");
+	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
+		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
+		struct bug_entry *bug = find_bug(elr_in_kimg);
+		const char *file = NULL;
+		unsigned int line = 0;
+
+		/* All hyp bugs, including warnings, are treated as fatal. */
+		if (bug)
+			bug_get_file_line(bug, &file, &line);
+
+		if (file)
+			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
+		else
+			kvm_err("nVHE hyp BUG at: %016llx!\n", elr + hyp_offset);
+	} else {
+		kvm_err("nVHE hyp panic at: %016llx!\n", elr + hyp_offset);
+	}
+
+	/*
+	 * Hyp has panicked and we're going to handle that by panicking the
+	 * kernel. The kernel offset will be revealed in the panic so we're
+	 * also safe to reveal the hyp offset as a debugging aid for translating
+	 * hyp VAs to vmlinux addresses.
+	 */
+	kvm_err("Hyp Offset: 0x%llx\n", hyp_offset);
+
+	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%016lx\n",
+	      spsr, elr, esr, far, hpfar, par, vcpu);
+}
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6c1f51f25eb3..32d0c036c050 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -30,8 +30,6 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
-extern const char __hyp_panic_string[];
-
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 5d94584840cc..2b23400e0fb3 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -79,22 +79,18 @@ SYM_FUNC_START(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
 		      PSR_MODE_EL1h)
 	msr	spsr_el2, lr
-	ldr	lr, =panic
+	ldr	lr, =nvhe_hyp_panic_handler
 	hyp_kimg_va lr, x6
 	msr	elr_el2, lr
 
 	mov	x29, x0
 
-	/* Load the format string into x0 and arguments into x1-7 */
-	ldr	x0, =__hyp_panic_string
-	hyp_kimg_va x0, x6
-
-	/* Load the format arguments into x1-7. */
-	mov	x6, x3
-	get_vcpu_ptr x7, x3
-	mrs	x3, esr_el2
-	mrs	x4, far_el2
-	mrs	x5, hpfar_el2
+	/* Load the panic arguments into x0-7 */
+	mrs	x0, esr_el2
+	get_vcpu_ptr x4, x5
+	mrs	x5, far_el2
+	mrs	x6, hpfar_el2
+	mov	x7, xzr			// Unused argument
 
 	/* Enter the host, conditionally restoring the host context. */
 	cbz	x29, __host_enter_without_restoring
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 63de71c0481e..ca630896476d 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -22,8 +22,6 @@ void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 struct kvm_host_psci_config __ro_after_init kvm_host_psci_config;
 s64 __ro_after_init hyp_physvirt_offset;
 
-#define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
-
 #define INVALID_CPU_ID	UINT_MAX
 
 struct psci_boot_args {
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index af8e940d0f03..7b8f7db5c1ed 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -27,8 +27,6 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
-const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
-
 /* VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
@@ -207,7 +205,7 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 	__deactivate_traps(vcpu);
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	panic(__hyp_panic_string,
+	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n",
 	      spsr, elr,
 	      read_sysreg_el2(SYS_ESR), read_sysreg_el2(SYS_FAR),
 	      read_sysreg(hpfar_el2), par, vcpu);
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
