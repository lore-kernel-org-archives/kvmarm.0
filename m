Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A5FC56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 130D7221EB
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="nQ8SSmjL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 130D7221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3D4F4BC69;
	Thu, 26 Nov 2020 10:55:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sQ9AuIoCWmZc; Thu, 26 Nov 2020 10:55:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA214C0BE;
	Thu, 26 Nov 2020 10:55:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CF154C0E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aWWaq5ilqs9w for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:55:09 -0500 (EST)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF4B84BCEF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:08 -0500 (EST)
Received: by mail-wr1-f52.google.com with SMTP id r3so2658456wrt.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=OmiGNR2uuCJEGcHKM0d3V1Ye4OF2/smYKtB2F4FGZ9U=;
 b=nQ8SSmjL1BNQcjaNOG2spLM3KGhqA7Z4p05orE+wNTrlj9pvs+bt8709WH6hGD97Fp
 MO398OfUu8FCD2Pfu7pCMrAI6fqp3WUQ6fDuJkxFZhy6UOyAMVjrc+DVn+EQsRIpUEMy
 D5fuMeWEuZWKiDDiS5k/zCbk8oe4n/e71bAlcFH6eE4uhQQAdwjZbtwcU/uFNLVbI5WA
 /eVYCwlziCS/+HTHGTOp4HlCuR6QA/asEzEo4gtcYuDZtxxQh2w65RbFzgUXj6DZ/5Tt
 Z+FTUUKQX8v0FVdsfIieakkGjy4cD+VvxnmrrkL3fbZZSBOIDapQ6G+w1GANSluW+Kyt
 SYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=OmiGNR2uuCJEGcHKM0d3V1Ye4OF2/smYKtB2F4FGZ9U=;
 b=CccLhsH0B49h8bvVvt7wUGeUNI5xTQqhNQ0CPcqniGJ+meoKCAsAQXyrFw7WOXd++L
 S6jPo1Nmz8JGHsB2jyNMe3Qfte6W8K3hWKuyjOHdRg0PdEvPNgpPH2+bdN3cQxMEd9SU
 9vIzTl9tAIIJiHbKLpGEFSfTfRA0HzmMaA1O7WCfCPhSV1zMBlvjkuR0nHBP0+I61lsZ
 hZRlE7TFzza/ZjkEdYCv9H1ED82iVMMLXnodPXrqNzYwKh7Vubj5M9gOjIOjIL18h7Iz
 VlTjbN8Gu6TzZbCqj/6beXhNqoG9TKp1os1uKQ82/Ah1qMroJmAWSCu0Fw7iaXyp0qgX
 hASA==
X-Gm-Message-State: AOAM530a8w3ycZf9ldcCFQZdEiGN8ALh8ari2/gbCteVIdTJRHVGXEXk
 kl2cTMctjJjZkaP57vACYVYiP528d+5sa6hW
X-Google-Smtp-Source: ABdhPJypyppTeU5V6/k3iqU7vPbd+TN9q7mzRr6Yei6CDrxVWBkVZkf5J9/tWnOZ6PCDXQkYs77Tpg==
X-Received: by 2002:a5d:6050:: with SMTP id j16mr4697763wrt.158.1606406107573; 
 Thu, 26 Nov 2020 07:55:07 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id s6sm1779640wme.48.2020.11.26.07.55.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:55:06 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 19/23] kvm: arm64: Intercept host's CPU_ON SMCs
Date: Thu, 26 Nov 2020 15:54:17 +0000
Message-Id: <20201126155421.14901-20-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
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

Add a handler of the CPU_ON PSCI call from host. When invoked, it looks
up the logical CPU ID corresponding to the provided MPIDR and populates
the state struct of the target CPU with the provided x0, pc. It then
calls CPU_ON itself, with an entry point in hyp that initializes EL2
state before returning ERET to the provided PC in EL1.

There is a simple atomic lock around the boot args struct. If it is
already locked, CPU_ON will return PENDING_ON error code.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  30 ++++++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 109 +++++++++++++++++++++++++++
 2 files changed, 139 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 98ce40e17b42..ea71f653af55 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -9,6 +9,7 @@
 
 #include <asm/alternative.h>
 #include <asm/assembler.h>
+#include <asm/el2_setup.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
@@ -161,6 +162,35 @@ alternative_else_nop_endif
 	ret
 SYM_CODE_END(___kvm_hyp_init)
 
+SYM_CODE_START(__kvm_hyp_cpu_on_entry)
+	msr	SPsel, #1			// We want to use SP_EL{1,2}
+
+	/* Check that the core was booted in EL2. */
+	mrs	x1, CurrentEL
+	cmp	x1, #CurrentEL_EL2
+	b.eq	2f
+
+	/* The core booted in EL1. KVM cannot be initialized on it. */
+1:	wfe
+	wfi
+	b	1b
+
+	/* Initialize EL2 CPU state to sane values. */
+2:	mov	x29, x0
+	init_el2_state nvhe
+	mov	x0, x29
+
+	/* Enable MMU, set vectors and stack. */
+	bl	___kvm_hyp_init
+
+	/* Load address of the C handler. */
+	ldr	x1, =__kvm_hyp_psci_cpu_entry
+	kimg_hyp_va x1, x2
+
+	/* Leave idmap. */
+	br	x1
+SYM_CODE_END(__kvm_hyp_cpu_on_entry)
+
 SYM_CODE_START(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	1f
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 7aa87ab7f5ce..39e507672e6e 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -9,12 +9,17 @@
 #include <asm/kvm_mmu.h>
 #include <kvm/arm_hypercalls.h>
 #include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
 #include <linux/psci.h>
 #include <kvm/arm_psci.h>
 #include <uapi/linux/psci.h>
 
 #include <nvhe/trap_handler.h>
 
+extern char __kvm_hyp_cpu_on_entry[];
+
+void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
+
 /* Config options set by the host. */
 u32 __ro_after_init kvm_host_psci_version;
 u32 __ro_after_init kvm_host_psci_function_id[PSCI_FN_MAX];
@@ -22,6 +27,19 @@ s64 __ro_after_init hyp_physvirt_offset;
 
 #define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
 
+#define INVALID_CPU_ID	UINT_MAX
+
+#define CPU_UNLOCKED	0
+#define CPU_LOCKED	1
+
+struct cpu_boot_args {
+	unsigned long pc;
+	unsigned long r0;
+};
+
+static DEFINE_PER_CPU(atomic_t, cpu_on_lock) = ATOMIC_INIT(0);
+static DEFINE_PER_CPU(struct cpu_boot_args, cpu_on_args);
+
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, func_id, host_ctxt, 0);
@@ -78,10 +96,99 @@ static __noreturn unsigned long psci_forward_noreturn(struct kvm_cpu_context *ho
 	hyp_panic(); /* unreachable */
 }
 
+static unsigned int find_cpu_id(u64 mpidr)
+{
+	unsigned int i;
+
+	/* Reject invalid MPIDRs */
+	if (mpidr & ~MPIDR_HWID_BITMASK)
+		return INVALID_CPU_ID;
+
+	for (i = 0; i < NR_CPUS; i++) {
+		if (cpu_logical_map(i) == mpidr)
+			return i;
+	}
+
+	return INVALID_CPU_ID;
+}
+
+static __always_inline bool try_acquire_cpu_on_lock(atomic_t *l) {
+	return atomic_cmpxchg_acquire(l, CPU_UNLOCKED, CPU_LOCKED) == CPU_UNLOCKED;
+}
+
+static __always_inline void release_cpu_on_lock(atomic_t *l) {
+	atomic_set_release(l, CPU_UNLOCKED);
+}
+
+static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, mpidr, host_ctxt, 1);
+	DECLARE_REG(unsigned long, pc, host_ctxt, 2);
+	DECLARE_REG(unsigned long, r0, host_ctxt, 3);
+
+	unsigned int cpu_id;
+	atomic_t *lock;
+	struct cpu_boot_args *boot_args;
+	struct kvm_nvhe_init_params *init_params;
+	int ret;
+
+	/*
+	 * Find the logical CPU ID for the given MPIDR. The search set is
+	 * the set of CPUs that were online at the point of KVM initialization.
+	 * Booting other CPUs is rejected because their cpufeatures were not
+	 * checked against the finalized capabilities. This could be relaxed
+	 * by doing the feature checks in hyp.
+	 */
+	cpu_id = find_cpu_id(mpidr);
+	if (cpu_id == INVALID_CPU_ID)
+		return PSCI_RET_INVALID_PARAMS;
+
+	lock = per_cpu_ptr(hyp_symbol_addr(cpu_on_lock), cpu_id);
+	boot_args = per_cpu_ptr(hyp_symbol_addr(cpu_on_args), cpu_id);
+	init_params = per_cpu_ptr(hyp_symbol_addr(kvm_init_params), cpu_id);
+
+	/* Check if the target CPU is already being booted. */
+	if (!try_acquire_cpu_on_lock(lock))
+		return PSCI_RET_ALREADY_ON;
+
+	*boot_args = (struct cpu_boot_args){ .pc = pc, .r0 = r0 };
+	wmb();
+
+	ret = psci_call(func_id, mpidr,
+			__hyp_pa(hyp_symbol_addr(__kvm_hyp_cpu_on_entry)),
+			__hyp_pa(init_params));
+
+	/* If successful, the lock will be released by the target CPU. */
+	if (ret != PSCI_RET_SUCCESS)
+		release_cpu_on_lock(lock);
+
+	return ret;
+}
+
+asmlinkage void __noreturn __kvm_hyp_psci_cpu_entry(void)
+{
+	atomic_t *lock;
+	struct cpu_boot_args *boot_args;
+	struct kvm_cpu_context *host_ctxt;
+
+	lock = this_cpu_ptr(hyp_symbol_addr(cpu_on_lock));
+	boot_args = this_cpu_ptr(hyp_symbol_addr(cpu_on_args));
+	host_ctxt = &this_cpu_ptr(hyp_symbol_addr(kvm_host_data))->host_ctxt;
+
+	cpu_reg(host_ctxt, 0) = boot_args->r0;
+	write_sysreg_el2(boot_args->pc, SYS_ELR);
+
+	release_cpu_on_lock(lock);
+
+	__host_enter(host_ctxt);
+}
+
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
 	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
 		return psci_forward(host_ctxt);
+	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_ON])
+		return psci_cpu_on(func_id, host_ctxt);
 	else if (func_id == kvm_host_psci_function_id[PSCI_FN_MIGRATE])
 		return psci_forward(host_ctxt);
 	else
@@ -102,6 +209,8 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
 	case PSCI_0_2_FN_SYSTEM_RESET:
 		psci_forward_noreturn(host_ctxt);
 		unreachable();
+	case PSCI_0_2_FN64_CPU_ON:
+		return psci_cpu_on(func_id, host_ctxt);
 	default:
 		return PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
