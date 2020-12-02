Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAAEC71155
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3036421D7F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3036421D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0FDB4B3A3;
	Wed,  2 Dec 2020 13:42:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q0f7YGqy9FQp; Wed,  2 Dec 2020 13:42:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E3534B446;
	Wed,  2 Dec 2020 13:42:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B514B3CE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EnNdfA7Wxk3s for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:16 -0500 (EST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CC234B3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:16 -0500 (EST)
Received: by mail-wr1-f41.google.com with SMTP id s8so5122631wrw.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=eCJnVbiCjoN/pSAdplV1JGIGBKZGMHYP2ef/XdrHF5Q=;
 b=hzfSLkwdYdGXdchogjDVmnYDCF/2gpJ4Tp+atdehO+5Cm9Euc6M/aX/Gn62x9Qu8b2
 JDB9QgOEaQ8sMcL7F4czqGQT/dq9LhCM/FtMc0yw5kotMl/OLzGLaq932TlhEI9JTbPC
 YStQGqgocb7+YmWoCwo9cs3yhHWPk8l+K/84tU3GyZEaJfaXgbRUB9eIf1zMRzpWr6S0
 Sy0Rn9gAzv4QyT+xbL91UA9bV820Ro4L7w+j/zZt4mV/hC+RxEpBhyvrS8b5V1U0yneM
 uk4uFvTnK2+VfKflT7WwhLim6kp0CB4y9WtuPeGF9hdob34hF93Tz83unvAzaxC/FtVU
 A03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=eCJnVbiCjoN/pSAdplV1JGIGBKZGMHYP2ef/XdrHF5Q=;
 b=Lh6x646SSzOXEEuOjlrEq2wS5dDtyf9eIYewhn6wnnfjIGo46zVRflUTkSfPftfEW7
 YLi0lKzjXiCGm+/9udfKgsvmQK+jR2o5WWtZMkEYG787t4OXsl1wWmnYWhCaiKhzcUEV
 iBSCoAT1lscP0Q0HgMn/ZibNd6lqEDg/s17ZnyUlXyWen0eMWHrs+V9BxQiEMpp7AQuo
 3VPdM1V36eFMMqbtC5yd8Nk1O1P8IQM/Q5cJmLwPo/99oPwcE6x+jQvYgJem25XSVHir
 rNF20Kzd1QfbFgiICSkpHl5ZjG3KevpmfpNyvpVC6x3S0lPR0i5m6LIis5IlVqkZs1gs
 SfUw==
X-Gm-Message-State: AOAM532yPkd9PQMemTrluyVpSyZgg/DhwPeyZqFj3IZHvNcyVdfFzXYp
 kmVsXJp6FBbI+dHUCX1ARhB267Bn69FfVA==
X-Google-Smtp-Source: ABdhPJzO7xDGtOYCHE/w9ReqAHY2jQUZ9wCSW2QWoyljTFgZ0QsKnjjtpvvcmLrq7Ji0oD+HjGXa2w==
X-Received: by 2002:adf:f5c8:: with SMTP id k8mr5258235wrp.2.1606934534601;
 Wed, 02 Dec 2020 10:42:14 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id z189sm2958120wme.23.2020.12.02.10.42.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:42:13 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 21/26] kvm: arm64: Intercept host's CPU_ON SMCs
Date: Wed,  2 Dec 2020 18:41:17 +0000
Message-Id: <20201202184122.26046-22-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202184122.26046-1-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
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
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  48 +++++++++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 115 +++++++++++++++++++++++++++
 2 files changed, 163 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index b0856b006bc0..d07e75f8242e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -9,6 +9,7 @@
 
 #include <asm/alternative.h>
 #include <asm/assembler.h>
+#include <asm/el2_setup.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
@@ -139,6 +140,53 @@ alternative_else_nop_endif
 	ret
 SYM_CODE_END(___kvm_hyp_init)
 
+/*
+ * PSCI CPU_ON entry point
+ *
+ * x0: struct kvm_nvhe_init_params PA
+ */
+SYM_CODE_START(kvm_hyp_cpu_entry)
+	mov	x1, #1				// is_cpu_on = true
+	b	__kvm_hyp_init_cpu
+SYM_CODE_END(kvm_hyp_cpu_entry)
+
+/*
+ * Common code for CPU entry points. Initializes EL2 state and
+ * installs the hypervisor before handing over to a C handler.
+ *
+ * x0: struct kvm_nvhe_init_params PA
+ * x1: bool is_cpu_on
+ */
+SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
+	mov	x28, x0				// Stash arguments
+	mov	x29, x1
+
+	/* Check that the core was booted in EL2. */
+	mrs	x0, CurrentEL
+	cmp	x0, #CurrentEL_EL2
+	b.eq	2f
+
+	/* The core booted in EL1. KVM cannot be initialized on it. */
+1:	wfe
+	wfi
+	b	1b
+
+2:	msr	SPsel, #1			// We want to use SP_EL{1,2}
+
+	/* Initialize EL2 CPU state to sane values. */
+	init_el2_state nvhe			// Clobbers x0..x2
+
+	/* Enable MMU, set vectors and stack. */
+	mov	x0, x28
+	bl	___kvm_hyp_init			// Clobbers x0..x3
+
+	/* Leave idmap. */
+	mov	x0, x29
+	ldr	x1, =kvm_host_psci_cpu_entry
+	kimg_hyp_va x1, x2
+	br	x1
+SYM_CODE_END(__kvm_hyp_init_cpu)
+
 SYM_CODE_START(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	1f
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 5ad56a875ffa..637e22ed71fc 100644
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
 
+void kvm_hyp_cpu_entry(unsigned long r0);
+
+void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
+
 /* Config options set by the host. */
 __ro_after_init u32 kvm_host_psci_version;
 __ro_after_init struct psci_0_1_function_ids kvm_host_psci_0_1_function_ids;
@@ -22,6 +27,24 @@ __ro_after_init s64 hyp_physvirt_offset;
 
 #define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
 
+#define INVALID_CPU_ID	UINT_MAX
+
+struct psci_boot_args {
+	atomic_t lock;
+	unsigned long pc;
+	unsigned long r0;
+};
+
+#define PSCI_BOOT_ARGS_UNLOCKED		0
+#define PSCI_BOOT_ARGS_LOCKED		1
+
+#define PSCI_BOOT_ARGS_INIT					\
+	((struct psci_boot_args){				\
+		.lock = ATOMIC_INIT(PSCI_BOOT_ARGS_UNLOCKED),	\
+	})
+
+static DEFINE_PER_CPU(struct psci_boot_args, cpu_on_args) = PSCI_BOOT_ARGS_INIT;
+
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, func_id, host_ctxt, 0);
@@ -75,11 +98,101 @@ static __noreturn unsigned long psci_forward_noreturn(struct kvm_cpu_context *ho
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
+static __always_inline bool try_acquire_boot_args(struct psci_boot_args *args)
+{
+	return atomic_cmpxchg_acquire(&args->lock,
+				      PSCI_BOOT_ARGS_UNLOCKED,
+				      PSCI_BOOT_ARGS_LOCKED) ==
+		PSCI_BOOT_ARGS_UNLOCKED;
+}
+
+static __always_inline void release_boot_args(struct psci_boot_args *args)
+{
+	atomic_set_release(&args->lock, PSCI_BOOT_ARGS_UNLOCKED);
+}
+
+static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, mpidr, host_ctxt, 1);
+	DECLARE_REG(unsigned long, pc, host_ctxt, 2);
+	DECLARE_REG(unsigned long, r0, host_ctxt, 3);
+
+	unsigned int cpu_id;
+	struct psci_boot_args *boot_args;
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
+	boot_args = per_cpu_ptr(hyp_symbol_addr(cpu_on_args), cpu_id);
+	init_params = per_cpu_ptr(hyp_symbol_addr(kvm_init_params), cpu_id);
+
+	/* Check if the target CPU is already being booted. */
+	if (!try_acquire_boot_args(boot_args))
+		return PSCI_RET_ALREADY_ON;
+
+	boot_args->pc = pc;
+	boot_args->r0 = r0;
+	wmb();
+
+	ret = psci_call(func_id, mpidr,
+			__hyp_pa(hyp_symbol_addr(kvm_hyp_cpu_entry)),
+			__hyp_pa(init_params));
+
+	/* If successful, the lock will be released by the target CPU. */
+	if (ret != PSCI_RET_SUCCESS)
+		release_boot_args(boot_args);
+
+	return ret;
+}
+
+asmlinkage void __noreturn kvm_host_psci_cpu_entry(bool is_cpu_on)
+{
+	struct psci_boot_args *boot_args;
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = &this_cpu_ptr(hyp_symbol_addr(kvm_host_data))->host_ctxt;
+	boot_args = this_cpu_ptr(hyp_symbol_addr(cpu_on_args));
+
+	cpu_reg(host_ctxt, 0) = boot_args->r0;
+	write_sysreg_el2(boot_args->pc, SYS_ELR);
+	release_boot_args(boot_args);
+
+	__host_enter(host_ctxt);
+}
+
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
 	if ((func_id == kvm_host_psci_0_1_function_ids.cpu_off) ||
 	    (func_id == kvm_host_psci_0_1_function_ids.migrate))
 		return psci_forward(host_ctxt);
+	else if (func_id == kvm_host_psci_0_1_function_ids.cpu_on)
+		return psci_cpu_on(func_id, host_ctxt);
 	else
 		return PSCI_RET_NOT_SUPPORTED;
 }
@@ -98,6 +211,8 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
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
